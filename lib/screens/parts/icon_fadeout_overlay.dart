import 'package:flutter/material.dart';

void iconFadeoutOverlay({
  required BuildContext context,
  required GlobalKey targetKey,
  Duration fadeDuration = const Duration(milliseconds: 300),
  Duration displayDuration = const Duration(seconds: 1),
  double overlayWidth = 100.0,
  required Icon icon,
}) {
  final RenderBox? renderBox = targetKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return;
  }

  final Offset offset = renderBox.localToGlobal(Offset.zero);
  final Size size = renderBox.size;

  final OverlayState overlayState = Overlay.of(context);

  final Duration totalDuration = fadeDuration + displayDuration + fadeDuration;
  final AnimationController animationController =
      AnimationController(vsync: Navigator.of(context), duration: totalDuration);

  final double fadeInMs = fadeDuration.inMilliseconds.toDouble();
  final double displayMs = displayDuration.inMilliseconds.toDouble();
  final double fadeOutMs = fadeDuration.inMilliseconds.toDouble();

  final Animation<double> scaleAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.8, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: fadeInMs),
    TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: displayMs),
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 4.0).chain(CurveTween(curve: Curves.easeInOut)), weight: fadeOutMs),
  ]).animate(animationController);

  final Animation<double> opacityAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: fadeInMs),
    TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: displayMs),
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: fadeOutMs),
  ]).animate(animationController);

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      final double leftPosition = offset.dx + (size.width - overlayWidth) / 2;

      final double topPosition = offset.dy + size.height;

      return Positioned(
        left: leftPosition,
        top: topPosition,
        child: Material(
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: scaleAnimation.value,
                child: Opacity(
                  opacity: opacityAnimation.value,
                  child: Container(
                    width: overlayWidth,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: icon,
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );

  overlayState.insert(overlayEntry);

  animationController.forward();

  animationController.addStatusListener((AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      overlayEntry.remove();
      animationController.dispose();
    }
  });
}
