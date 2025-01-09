import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_params/app_params_notifier.dart';
import '../../controllers/app_params/app_params_response_state.dart';

//=======================================================//

class DraggableOverlayItem {
  DraggableOverlayItem({required this.position, required this.width, required this.height, required this.color});

  late OverlayEntry entry;

  Offset position;

  final double width;
  final double height;

  final Color color;
}

//=======================================================//

///
OverlayEntry createDraggableOverlayEntry({
  required BuildContext context,
  required Offset initialOffset,
  required double width,
  required double height,
  required Color color,
  required VoidCallback onRemove,
  required Widget widget,
}) {
  final Size screenSize = MediaQuery.of(context).size;

  final DraggableOverlayItem item =
      DraggableOverlayItem(position: initialOffset, width: width, height: height, color: color);

  final OverlayEntry entry = OverlayEntry(
    builder: (BuildContext context) {
      return Positioned(
        left: item.position.dx,
        top: item.position.dy,
        child: Material(
          elevation: 8,
          color: item.color,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: item.width,
            height: item.height,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  height: 40,
                  width: double.infinity,
                  child: Listener(
                    onPointerMove: (PointerMoveEvent event) {
                      if (event.buttons == 1) {
                        item.position += event.delta;

                        final double maxX = screenSize.width - item.width;
                        final double maxY = screenSize.height - item.height;
                        final num clampedX = item.position.dx.clamp(0, maxX);
                        final num clampedY = item.position.dy.clamp(0, maxY);

                        item.position = Offset(double.parse(clampedX.toString()), double.parse(clampedY.toString()));

                        item.entry.markNeedsBuild();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.drag_indicator),
                        const Expanded(child: Text('')),
                        IconButton(onPressed: onRemove, icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(width: double.infinity),
                        // Text('Width: ${item.width}'),
                        // Text('Height: ${item.height}'),
                        // Text('dx: ${item.position.dx}'),
                        // Text('dy: ${item.position.dy}'),
                        // const SizedBox(height: 10),

                        widget,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  item.entry = entry;
  return entry;
}

//=======================================================//

///
void addBigOverlay({
  required BuildContext context,
  required List<OverlayEntry> bigEntries,
  required void Function(VoidCallback fn) setStateCallback,
  required double width,
  required double height,
  required Color color,
  required Offset initialPosition,
  required Widget widget,
}) {
  if (bigEntries.isNotEmpty) {
    for (final OverlayEntry e in bigEntries) {
      e.remove();
    }

    setStateCallback(() => bigEntries.clear());
  }

  late OverlayEntry entry;
  entry = createDraggableOverlayEntry(
    context: context,
    initialOffset: initialPosition,
    width: width,
    height: height,
    color: color,
    onRemove: () {
      entry.remove();

      setStateCallback(() => bigEntries.remove(entry));
    },
    widget: widget,
  );

  setStateCallback(() => bigEntries.add(entry));

  Overlay.of(context).insert(entry);
}

///
void closeAllOverlays({required WidgetRef ref}) {
  final List<OverlayEntry>? bigEntries =
      ref.watch(appParamProvider.select((AppParamsResponseState value) => value.bigEntries));
  final void Function(void Function() p1)? setStateCallback =
      ref.watch(appParamProvider.select((AppParamsResponseState value) => value.setStateCallback));

  if (bigEntries != null && setStateCallback != null) {
    for (final OverlayEntry e in bigEntries) {
      e.remove();
    }

//    setStateCallback(() => bigEntries.clear());
  }
}
