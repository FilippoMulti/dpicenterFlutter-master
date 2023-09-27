import 'package:json_annotation/json_annotation.dart';

part 'print_response.g.dart';

@JsonSerializable()
class PrintResponse {
  @JsonKey(ignore: true)
  final String _name = "PrintResponse";

  int? status;
  String? resultFile;

  @JsonKey(ignore: true)
  String? path;

  //costruttore. Equivalente a
  //QueryModel(this.id){};
  // ed è equivalente anche a
  //QueryModel(int id){this.id=id;}
  PrintResponse(this.status, this.resultFile);

  factory PrintResponse.fromJson(Map<String, dynamic> json) =>
      _$PrintResponseFromJson(json);

  static PrintResponse fromJsonModel(Map<String, dynamic> json) {
    return PrintResponse.fromJson(json);
  }

  Map<String, dynamic> toJson() => _$PrintResponseToJson(this);

  @override
  bool operator ==(Object other) =>
      other is PrintResponse && other._name == _name;

  @override
  int get hashCode => _name.hashCode;
}
