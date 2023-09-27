import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/locals/multi_point_list.dart';
import 'package:equatable/equatable.dart';

part 'signature_info.g.dart';

@CopyWith(copyWithNull: true)
class SignatureInfo extends Equatable {
  final String? contactPerson;
  final Uint8List? signature;
  final MultiPointList? pointList;

  const SignatureInfo({this.contactPerson, this.signature, this.pointList});

  @override
  List<Object?> get props => [contactPerson, signature, pointList];
}
