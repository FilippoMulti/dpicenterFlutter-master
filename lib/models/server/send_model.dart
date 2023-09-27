import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_model.g.dart';

@JsonSerializable()
class SendModel implements Equatable {
  final String? content;
  final String? filename;

  SendModel(this.content, this.filename);

  factory SendModel.fromJson(Map<String, dynamic> json) =>
      _$SendModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendModelToJson(this);

  @override
  List<Object?> get props => [content, filename];

  @override
  bool? get stringify => false;
}
