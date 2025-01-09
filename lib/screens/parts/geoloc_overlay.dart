import 'package:flutter/material.dart';

//=======================================================//

class DraggableOverlayItem {
  late OverlayEntry entry;

  Offset position;

  final double width;
  final double height;

  final Color color;

  DraggableOverlayItem({required this.position, required this.width, required this.height, required this.color});
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
  final screenSize = MediaQuery.of(context).size;

  final item = DraggableOverlayItem(position: initialOffset, width: width, height: height, color: color);

  final entry = OverlayEntry(
    builder: (context) {
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
              children: [
                Container(
                  color: Colors.transparent,
                  height: 40,
                  width: double.infinity,
                  child: Listener(
                    onPointerMove: (PointerMoveEvent event) {
                      if (event.buttons == 1) {
                        item.position += event.delta;

                        final maxX = screenSize.width - item.width;
                        final maxY = screenSize.height - item.height;
                        final clampedX = item.position.dx.clamp(0, maxX);
                        final clampedY = item.position.dy.clamp(0, maxY);

                        item.position = Offset(double.parse(clampedX.toString()), double.parse(clampedY.toString()));

                        item.entry.markNeedsBuild();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                      children: [
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
    for (final e in bigEntries) {
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
