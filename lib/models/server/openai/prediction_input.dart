import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'prediction_input.g.dart';

@JsonSerializable()
@CopyWith()
class PredictionInput extends Equatable implements JsonPayload {
  final String prompt;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const PredictionInput({
    this.prompt = "",
    this.json,
  });

  factory PredictionInput.fromJson(Map<String, dynamic> json) {
    var result = _$PredictionInputFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$PredictionInputToJson(this);

  static PredictionInput fromJsonModel(Map<String, dynamic> json) =>
      PredictionInput.fromJson(json);

  @override
  List<Object?> get props => [prompt];
}
