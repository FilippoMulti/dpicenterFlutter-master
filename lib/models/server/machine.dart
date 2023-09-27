import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/machine_note.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_reminder.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'machine.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Machine extends Equatable implements JsonPayload {
  final String? matricola;
  final int? modelloId;
  final String? customerId;
  final Customer? customer;
  final String? stabId;
  final int? stato;
  final int? vmcId;
  final Vmc? vmc;
  final Customer? stabilimento;
  final String? reparto;
  final String? machineId;
  final List<MachineSetting>? machineSettings;
  final List<MachineProduction>? machineProductions;
  final List<MachineReminder>? machineReminders;
  final List<MachineNote>? machineNotes;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const Machine({
    this.matricola,
    this.modelloId,
    this.customerId,
    this.customer,
    this.stabId,
    this.stabilimento,
    this.reparto,
    this.machineId,
    this.stato,
    this.vmcId,
    this.vmc,
    this.machineSettings,
    this.machineProductions,
    this.machineReminders,
    this.machineNotes,
    this.json,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    var result = _$MachineFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MachineToJson(this);

  static Machine fromJsonModel(Map<String, dynamic> json) =>
      Machine.fromJson(json);

  @override
  String toString([bool withSpace = true]) {
    return '$matricola${withSpace ? ' ' : '\r\n'}${stabilimento?.description}${withSpace ? ' ' : '\r\n'}${stabilimento?.indirizzo} ${stabilimento?.comune} ${stabilimento?.provincia} ${stabilimento?.nazione}';
  }

  String toStringWithoutAddress([bool withSpace = true]) {
    return '$matricola${withSpace ? ' ' : '\r\n'}Id: $machineId';
  }

  @override
  List<Object?> get props => [
        stato,
        matricola,
        modelloId,
        customerId,
        stabId,
        reparto,
        machineId,
        vmcId,
        machineProductions,
        machineSettings,
    machineReminders
      ];
}
