import 'package:json_annotation/json_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
class FileModel {
  @JsonKey(ignore: true)
  final String _name = "QueryModel";

  String name;
  String content;

  ///base64

  FileModel({required this.name, required this.content});

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileModelToJson(this);

  @override
  bool operator ==(Object other) =>
      other is FileModel && other.content == content && other.name == name;

  @override
  int get hashCode => _name.hashCode;
}
