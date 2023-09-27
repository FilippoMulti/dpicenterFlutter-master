import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resource_query_model.g.dart';

@JsonSerializable()
@CopyWith()
class ResourceQueryModel extends Equatable {
  final String name;
  final int id;

  const ResourceQueryModel({required this.name, this.id = -1});

  factory ResourceQueryModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceQueryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceQueryModelToJson(this);

  @override
  List<Object?> get props => [name, id];
}
