import 'dart:convert';

// ignore: flutter_style_todos
// TODO エラー修正できない
Map<String, String> holidayFromJson(String str) =>
    // ignore: inference_failure_on_instance_creation, always_specify_types
    Map.from(json.decode(str) as Map<dynamic, dynamic>)
// ignore: always_specify_types
        .map((k, v) => MapEntry<String, String>(k as String, v as String));

// ignore: flutter_style_todos
// TODO エラー修正できない
// ignore: inference_failure_on_instance_creation, always_specify_types
String holidayToJson(Map<String, String> data) => json.encode(Map.from(data)
    // ignore: always_specify_types
    .map((k, v) => MapEntry<String, dynamic>(k as String, v as String)));

class Holiday {
  Holiday({required this.date, required this.content});

  String date;
  String content;
}
