import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query_model.g.dart';

@JsonSerializable()
@CopyWith()
class QueryModel implements Equatable {

  final String id;
  final bool downloadContent;
  final String fieldName;
  final int compareType;

  //costruttore. Equivalente a
  //QueryModel(this.id){};
  // ed è equivalente anche a
  //QueryModel(int id){this.id=id;}
  QueryModel(
      {this.id = "",
      this.downloadContent = true,
      this.fieldName = "",
      this.compareType = 0});

  factory QueryModel.fromJson(Map<String, dynamic> json) =>
      _$QueryModelFromJson(json);

  Map<String, dynamic> toJson() => _$QueryModelToJson(this);

  @override
  List<Object?> get props => [id, downloadContent, fieldName, compareType];

  @override
  bool? get stringify => false;
}
