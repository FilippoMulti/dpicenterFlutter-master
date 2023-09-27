import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_setting_file.dart';
import 'package:dpicenter/models/server/machine_setting_picture.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'machine_setting.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class MachineSetting extends Equatable implements JsonPayload, Comparable {
  final int? machineSettingId;
  final String? matricola;
  final Machine? machine;
  final String? name;
  final int vmcSettingId;
  final int vmcSettingFieldId;
  final String? description;
  final String? categoryCode;
  final String? categoryName;
  final String? categoryColor;
  final int? type;
  final String value;
  final String? params;
  final ApplicationUser? user;
  final String? date;
  final int? applicationUserId;
  final List<MachineSettingPicture>? images;
  final List<MachineSettingFile>? files;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const MachineSetting({
    this.machineSettingId,
    this.matricola,
    this.machine,
    this.name,
    this.description,
    this.categoryCode,
    this.categoryName,
    this.categoryColor,
    this.type,
    this.value = "",
    this.params,
    required this.vmcSettingFieldId,
    required this.vmcSettingId,
    this.user,
    this.date,
    this.applicationUserId,
    this.images,
    this.files,
    this.json,
  });

  factory MachineSetting.fromJson(Map<String, dynamic> json) {
    var result = _$MachineSettingFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  factory MachineSetting.fromVmcSettingField(VmcSettingField item) {
    return MachineSetting(
        machineSettingId: 0,
        vmcSettingFieldId: item.vmcSettingFieldId ?? 0,
        vmcSettingId: 0,
        name: item.name,
        description: item.description,
        categoryCode: item.category!.vmcSettingCategoryCode,
        categoryName: item.category!.name,
        categoryColor: item.category!.color,
        type: item.type,
        params: item.params);
  }

  Map<String, dynamic> toJson() => _$MachineSettingToJson(this);

  static MachineSetting fromJsonModel(Map<String, dynamic> json) =>
      MachineSetting.fromJson(json);

  @override
  String toString() {
    return '$description';
  }

  @override
  List<Object?> get props =>
      [
        machineSettingId,
        name,
        matricola,
        name,
        description,
        categoryCode,
        categoryName,
        categoryColor,
        vmcSettingFieldId,
        vmcSettingId,
        type,
        value,
        params,
        user,
        date,
        applicationUserId,
      ];

  @override
  int compareTo(other) {
    if (other is MachineSetting) {
      return matricola?.compareTo(other.matricola ?? '') ?? -1;
    }
    return -1;
  }
}
