import 'package:json_annotation/json_annotation.dart';

enum EventTypeEnum {
  @JsonValue(0)
  add,
  @JsonValue(1)
  update,
  @JsonValue(2)
  delete,
  @JsonValue(3)
  other,
}
