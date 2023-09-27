import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';

part 'key_validation_state.g.dart';

@CopyWith(copyWithNull: true)
class KeyValidationState {
  final GlobalKey key;
  final bool? state;

  const KeyValidationState({required this.key, this.state});
}
