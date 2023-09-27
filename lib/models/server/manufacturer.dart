import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manufacturer.g.dart';

@JsonSerializable()
@CopyWith()
class Manufacturer extends Equatable implements JsonPayload {
  final int? manufacturerId;
  final String? description;
  final String? referente;
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const Manufacturer(
      {this.manufacturerId, this.description, this.referente, this.json});

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    var result = _$ManufacturerFromJson(json);
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

  Map<String, dynamic> toJson() => _$ManufacturerToJson(this);

  static Manufacturer fromJsonModel(Map<String, dynamic> json) =>
      Manufacturer.fromJson(json);

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
  List<Object?> get props => [referente, manufacturerId, description];
}
