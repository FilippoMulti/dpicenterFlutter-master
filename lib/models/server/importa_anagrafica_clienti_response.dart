import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'importa_anagrafica_clienti_response.g.dart';

@JsonSerializable()
@CopyWith()
class ImportaAnagraficaClientiResponse extends Equatable
    implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  final bool result;
  final String info;

  const ImportaAnagraficaClientiResponse(
      {required this.result, required this.info, this.json});

  factory ImportaAnagraficaClientiResponse.fromJson(Map<String, dynamic> json) {
    var result = _$ImportaAnagraficaClientiResponseFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() =>
      _$ImportaAnagraficaClientiResponseToJson(this);

  @override
  List<Object?> get props => [result, info];

  static ImportaAnagraficaClientiResponse fromJsonModel(
          Map<String, dynamic> json) =>
      ImportaAnagraficaClientiResponse.fromJson(json);
}
