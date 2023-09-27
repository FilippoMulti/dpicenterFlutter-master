import 'package:dpicenter/screen/widgets/signature_form_field.dart';
import 'package:dpicenter/signature/signature_info.dart';
import 'package:flutter/material.dart';

/// A [RestorableProperty] that knows how to store and restore a
/// [TextEditingController].
///
/// The [TextEditingController] is accessible via the [value] getter. During
/// state restoration, the property will restore [TextEditingController.text] to
/// the value it had when the restoration data it is getting restored from was
/// collected.
class RestorableSignatureEditingController
    extends RestorableChangeNotifier<SignatureEditingController> {
  /// Creates a [RestorableTextEditingController].
  ///
  /// This constructor treats a null `text` argument as if it were the empty
  /// string.
  factory RestorableSignatureEditingController({SignatureInfo? info}) =>
      RestorableSignatureEditingController.fromValue(
        info ?? const SignatureInfo(),
      );

  /// Creates a [RestorableTextEditingController] from an initial
  /// [TextEditingValue].
  ///
  /// This constructor treats a null `value` argument as if it were
  /// [TextEditingValue.empty].
  RestorableSignatureEditingController.fromValue(SignatureInfo value)
      : _initialValue = value;

  final SignatureInfo _initialValue;

  @override
  SignatureEditingController createDefaultValue() {
    return SignatureEditingController.fromValue(_initialValue);
  }

  @override
  SignatureEditingController fromPrimitives(Object? data) {
    return SignatureEditingController(info: data! as SignatureInfo);
  }

  @override
  Object toPrimitives() {
    return value;
  }
}
