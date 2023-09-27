import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'vmc_setting.g.dart';

@JsonSerializable()
@CopyWith()
class VmcSetting extends Equatable implements JsonPayload, Comparable {
  final int? vmcSettingId;
  final int? vmcSettingFieldId;
  final VmcSettingField? settingField;
  final int? vmcId;
  final Vmc? vmc;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const VmcSetting({
    this.vmcSettingId,
    this.vmcSettingFieldId,
    this.vmcId,
    this.settingField,
    this.vmc,
    this.json,
  });

  factory VmcSetting.fromJson(Map<String, dynamic> json) {
    var result = _$VmcSettingFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcSettingToJson(this);

  static VmcSetting fromJsonModel(Map<String, dynamic> json) =>
      VmcSetting.fromJson(json);

  @override
  List<Object?> get props => [
        vmcSettingFieldId,
        vmcSettingId,
        vmcId,
      ];

  @override
  int compareTo(other) {
    if (other is VmcSetting) {
      return settingField?.description
              ?.compareTo(settingField?.description ?? '') ??
          -1;
    }
    return -1;
  }
}
