import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change_key_model.g.dart';

@JsonSerializable()
class ChangeKeyModel implements Equatable {
  final String oldId;
  final String newId;

  ChangeKeyModel(this.oldId, this.newId);

  factory ChangeKeyModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeKeyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeKeyModelToJson(this);

  @override
  List<Object?> get props => [oldId, newId];

  @override
  bool? get stringify => false;
}
