import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, List<int>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<int>? json) {
    if (json == null) {
      throw Exception("fromJson: json is null!");
    }

    return Uint8List.fromList(json);
  }

  @override
  List<int>? toJson(Uint8List? object) {
    if (object == null) {
      throw Exception("toJson: object is null!");
    }

    return object.toList(growable: false);
  }
}
