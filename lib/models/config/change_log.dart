import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change_log.g.dart';

@JsonSerializable()
@CopyWith()
class ChangeLog implements Equatable {
  ///dpi center backend url
  final String? version;
  final String? date;
  final int? versionNumber;
  final String? info;

  ChangeLog({
    this.date,
    this.version,
    this.versionNumber,
    this.info,
  });

  factory ChangeLog.fromJson(Map<String, dynamic> json) =>
      _$ChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeLogToJson(this);

  @override
  List<Object?> get props => [
        date,
        version,
        versionNumber,
        info,
      ];

  @override
  bool? get stringify => true;
}
