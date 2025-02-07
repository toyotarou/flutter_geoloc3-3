import 'package:flutter/material.dart';

void showButtonErrorOverlay({
  required BuildContext context,
  required GlobalKey buttonKey,
  required String message,
  Duration displayDuration = const Duration(seconds: 1),
  Duration fadeDuration = const Duration(milliseconds: 300),
}) {
  final OverlayState overlayState = Overlay.of(context);

  final RenderBox? renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return;
  }

  final Offset buttonOffset = renderBox.localToGlobal(Offset.zero);

  final AnimationController animationController =
      AnimationController(vsync: Navigator.of(context), duration: fadeDuration);

  final CurvedAnimation curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return Positioned(
        left: buttonOffset.dx,
        top: buttonOffset.dy - 15,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: curvedAnimation,
            child: Text(
              message,
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    },
  );

  overlayState.insert(overlayEntry);
  animationController.forward();

  // ignore: always_specify_types
  Future.delayed(displayDuration, () async {
    await animationController.reverse();
    overlayEntry.remove();
    animationController.dispose();
  });
}
