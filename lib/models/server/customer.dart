import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Customer extends Equatable implements JsonPayload, Comparable {
  final String? customerId;
  final String? code;
  final String? description;
  final String? pIva;
  final String? cFiscale;
  final String? indirizzo;
  final String? cap;
  final String? comune;
  final String? provincia;
  final String? nazione;
  final bool? isManualEntry;

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const Customer({
    this.customerId,
    this.code,
    this.description,
    this.pIva,
    this.cFiscale,
    this.indirizzo,
    this.cap,
    this.comune,
    this.provincia,
    this.nazione,
    this.isManualEntry,
    this.json,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    var result = _$CustomerFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  static Customer fromJsonModel(Map<String, dynamic> json) =>
      Customer.fromJson(json);

  @override
  String toString({bool withSpace = true, bool withAddressBreak = false}) {
    return '$description${withSpace ? ' ' : '\r\n'}$indirizzo${withAddressBreak ? '\r\n' : ' '}$comune $provincia $nazione';
  }

  @override
  List<Object?> get props => [
        code,
        description,
        pIva,
        cFiscale,
        indirizzo,
        cap,
        comune,
        provincia,
        nazione
      ];

  @override
  int compareTo(other) {
    if (other is Customer) {
      return description?.compareTo(other.description ?? '') ?? -1;
    }
    return -1;
  }
}
