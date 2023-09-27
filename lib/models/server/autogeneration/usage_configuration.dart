import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usage_configuration.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class UsageConfiguration extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final double value;
  final int priority;

  const UsageConfiguration({required this.value, this.priority = 1, this.json});

  factory UsageConfiguration.fromJson(Map<String, dynamic> json) {
    var result = _$UsageConfigurationFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$UsageConfigurationToJson(this);

  static UsageConfiguration fromJsonModel(Map<String, dynamic> json) =>
      UsageConfiguration.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props => [value, priority];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
