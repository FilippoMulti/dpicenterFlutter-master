import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_production_file.dart';
import 'package:dpicenter/models/server/machine_production_picture.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'machine_production.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class MachineProduction extends Equatable implements JsonPayload, Comparable {
  final int? machineProductionId;
  final String? matricola;
  final Machine? machine;
  final String? name;
  final int vmcProductionId;
  final int vmcProductionFieldId;
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
  final List<MachineProductionPicture>? images;
  final List<MachineProductionFile>? files;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const MachineProduction({
    this.machineProductionId,
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
    this.applicationUserId,
    this.user,
    required this.vmcProductionFieldId,
    required this.vmcProductionId,
    this.date,
    this.json,
    this.images,
    this.files,
  });

  factory MachineProduction.fromJson(Map<String, dynamic> json) {
    var result = _$MachineProductionFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  factory MachineProduction.fromVmcProductionField(
      VmcProductionField item, int? applicationUserId, ApplicationUser? user) {
    return MachineProduction(
        machineProductionId: 0,
        vmcProductionFieldId: item.vmcProductionFieldId ?? 0,
        vmcProductionId: 0,
        name: item.name,
        description: item.description,
        categoryCode: item.category!.vmcProductionCategoryCode,
        categoryName: item.category!.name,
        categoryColor: item.category!.color,
        applicationUserId: applicationUserId,
        user: user,
        type: item.type,
        params: item.params);
  }

  Map<String, dynamic> toJson() => _$MachineProductionToJson(this);

  static MachineProduction fromJsonModel(Map<String, dynamic> json) =>
      MachineProduction.fromJson(json);

  @override
  String toString() {
    return '$description';
  }

  @override
  List<Object?> get props => [
        machineProductionId,
        name,
        matricola,
        name,
        description,
        categoryCode,
        categoryName,
        categoryColor,
        vmcProductionFieldId,
        vmcProductionId,
        date,
        applicationUserId,
        type,
        value,
        params,
      ];

  @override
  int compareTo(other) {
    if (other is MachineProduction) {
      return matricola?.compareTo(other.matricola ?? '') ?? -1;
    }
    return -1;
  }
}
