import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'machine_history.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class MachineHistory extends Equatable implements JsonPayload {
  final int? machineHistoryId;
  final String? date;
  final String? matricola;
  final Machine? machine;
  final String? customerId;
  final Customer? customer;
  final String? stabId;
  final Customer? stabilimento;
  final int? applicationUserId;
  final String? userName;
  final String? name;
  final String? surname;
  final String? machineId;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const MachineHistory({
    this.machineHistoryId,
    this.date,
    this.matricola,
    this.machine,
    this.customerId,
    this.customer,
    this.stabId,
    this.stabilimento,
    this.applicationUserId,
    this.userName,
    this.name,
    this.surname,
    this.machineId,
    this.json,
  });

  factory MachineHistory.fromJson(Map<String, dynamic> json) {
    var result = _$MachineHistoryFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MachineHistoryToJson(this);

  static MachineHistory fromJsonModel(Map<String, dynamic> json) =>
      MachineHistory.fromJson(json);

  @override
  String toString([bool withSpace = true]) {
    return '$matricola${withSpace ? ' ' : '\r\n'}${machine?.stabilimento?.description}${withSpace ? ' ' : '\r\n'}${machine?.stabilimento?.indirizzo} ${machine?.stabilimento?.comune} ${machine?.stabilimento?.provincia} ${machine?.stabilimento?.nazione}';
  }

  String toStringWithoutAddress([bool withSpace = true]) {
    return '$matricola${withSpace ? ' ' : '\r\n'}Id: ${machine?.machineId ?? ''}';
  }

  @override
  List<Object?> get props => [
        machineHistoryId,
        matricola,
        customerId,
        stabId,
        applicationUserId,
        machineId
      ];
}
