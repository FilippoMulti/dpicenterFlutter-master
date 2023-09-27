import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vmc_configuration.g.dart';

@JsonSerializable()
@CopyWith()
class VmcConfiguration extends Equatable implements JsonPayload {
  final int? vmcConfigurationId;
  final String? description;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const VmcConfiguration(
      {this.vmcConfigurationId, this.description, this.json});

  factory VmcConfiguration.fromJson(Map<String, dynamic> json) {
    var result = _$VmcConfigurationFromJson(json);
    result = result.copyWith(json: json);
    return result;
    //return Manufacturer().decodeJson(json);
  }

  /*{
    return Manufacturer(
      manufacturerId: json['manufacturerId'],
      description: json['description'],
      referente: json['referente'],
      json: json,
    );
  }*/

  Map<String, dynamic> toJson() => _$VmcConfigurationToJson(this);

  static VmcConfiguration fromJsonModel(Map<String, dynamic> json) =>
      VmcConfiguration.fromJson(json);

/*=> {
        'manufacturerId': manufacturerId,
        'description': description,
        'referente': referente,
      };*/

/*  @override
  bool operator ==(Object other) =>
      other is Manufacturer && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props => [vmcConfigurationId, description];
}
