import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplePhotoDisplayAlert extends ConsumerStatefulWidget {
  const TemplePhotoDisplayAlert({super.key, required this.templephotos});

  final List<String> templephotos;

  @override
  ConsumerState<TemplePhotoDisplayAlert> createState() => _TemplePhotoDisplayAlertState();
}

class _TemplePhotoDisplayAlertState extends ConsumerState<TemplePhotoDisplayAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
              children: widget.templephotos.map((String e) {
        return Text(e);
      }).toList())),
    );
  }
}
