import 'package:json_annotation/json_annotation.dart';

enum VmcTypeEnum {
  @JsonValue(0)
  vendingMachine,
  @JsonValue(1)
  other,
}
