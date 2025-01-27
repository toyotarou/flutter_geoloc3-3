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
      body: PageView(
        children: widget.templephotos.map((String url) {
          return Image.network(url, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
        }).toList(),
      ),
    );
  }
}
