// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/signature/restorable_signature_editing_controller.dart';
import 'package:dpicenter/signature/signature_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:flutter/services.dart' show SmartQuotesType, SmartDashesType;

/// A [FormField] that contains a [TextField].
///
/// This is a convenience widget that wraps a [TextField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// When a [controller] is specified, its [TextEditingController.text]
/// defines the [initialValue]. If this [FormField] is part of a scrolling
/// container that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// Remember to call [TextEditingController.dispose] of the [TextEditingController]
/// when it is no longer needed. This will ensure we discard any resources used
/// by the object.
///
/// By default, `decoration` will apply the [ThemeData.inputDecorationTheme] for
/// the current context to the [InputDecoration], see
/// [InputDecoration.applyDefaults].
///
/// For a documentation about the various parameters, see [TextField].
///
/// {@tool snippet}
///
/// Creates a [TextFormField] with an [InputDecoration] and validator function.
///
/// ![If the user enters valid text, the TextField appears normally without any warnings to the user](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field.png)
///
/// ![If the user enters invalid text, the error message returned from the validator function is displayed in dark red underneath the input](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field_error.png)
///
/// ```dart
/// TextFormField(
///   decoration: const InputDecoration(
///     icon: Icon(Icons.person),
///     hintText: 'What do people call you?',
///     labelText: 'Name *',
///   ),
///   onSaved: (String? value) {
///     // This optional block of code can be used to run
///     // code when the user saves the form.
///   },
///   validator: (String? value) {
///     return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to move the focus to the next field when the user
/// presses the SPACE key.
///
/// ** See code in examples/api/lib/material/text_form_field/text_form_field.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * <https://material.io/design/components/text-fields.html>
///  * [TextField], which is the underlying text field without the [Form]
///    integration.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
///  * Learn how to use a [TextEditingController] in one of our [cookbook recipes](https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller).
class SignatureFormField extends FormField<SignatureInfo> {
  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [TextField.new], the constructor.
  SignatureFormField({
    Key? key,
    this.controller,
    this.signatureController,
    SignatureInfo? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    @Deprecated(
      'Use maxLengthEnforcement parameter which provides more specific '
      'behavior related to the maxLength limit. '
      'This feature was deprecated after v1.25.0-5.0.pre.',
    )
        bool maxLengthEnforced = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<SignatureInfo>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<SignatureInfo>? onFieldSubmitted,
    FormFieldSetter<SignatureInfo>? onSaved,
    FormFieldValidator<SignatureInfo>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    ScrollController? scrollController,
    String? restorationId,
    bool enableIMEPersonalizedLearning = true,
  })  : assert(initialValue == null || controller == null),
        assert(obscuringCharacter.length == 1),
        assert(
          maxLengthEnforced || maxLengthEnforcement == null,
          'maxLengthEnforced is deprecated, use only maxLengthEnforcement',
        ),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        super(
          key: key,
          restorationId: restorationId,
          initialValue: controller != null
              ? SignatureInfo(contactPerson: controller.text)
              : (initialValue ?? const SignatureInfo(contactPerson: '')),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<SignatureInfo> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(SignatureInfo value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: Column(
                children: [
                  if (state._effectiveSignatureController.signatureImage ==
                      null)
                    Container(
                        width: 300,
                        height: 150,
                        decoration: getSignatureDecoration(
                          field.context,
                          field.errorText != null,
                        ),
                        child: Center(
                          child: Text(
                            "Fai firmare l'intervento",
                            textAlign: TextAlign.center,
                            style: Theme.of(field.context).textTheme.bodySmall,
                          ),
                        ))
                  else
                    Container(
                        width: 300,
                        height: 150,
                        decoration: getSignatureDecoration(
                            field.context, field.errorText != null),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.memory(
                            state._effectiveSignatureController.signatureImage!,
                            fit: BoxFit.scaleDown,
                            filterQuality: FilterQuality.medium,
                            color: isDarkTheme(field.context)
                                ? Colors.white
                                : null,
                          ),
                        )),
                  const SizedBox(height: 16),
                  TextField(
                    restorationId: restorationId,
                    controller: state._effectiveController,
                    focusNode: focusNode,
                    decoration: effectiveDecoration.copyWith(
                        errorText: field.errorText),
                    keyboardType: keyboardType,
                    textInputAction: textInputAction,
                    style: style,
                    strutStyle: strutStyle,
                    textAlign: textAlign,
                    textAlignVertical: textAlignVertical,
                    textDirection: textDirection,
                    textCapitalization: textCapitalization,
                    autofocus: autofocus,
                    toolbarOptions: toolbarOptions,
                    readOnly: readOnly,
                    showCursor: showCursor,
                    obscuringCharacter: obscuringCharacter,
                    obscureText: obscureText,
                    autocorrect: autocorrect,
                    smartDashesType: smartDashesType ??
                        (obscureText
                            ? SmartDashesType.disabled
                            : SmartDashesType.enabled),
                    smartQuotesType: smartQuotesType ??
                        (obscureText
                            ? SmartQuotesType.disabled
                            : SmartQuotesType.enabled),
                    enableSuggestions: enableSuggestions,
                    maxLengthEnforcement: maxLengthEnforcement,
                    maxLines: maxLines,
                    minLines: minLines,
                    expands: expands,
                    maxLength: maxLength,
                    onChanged: (value) => onChangedHandler(state
                        ._effectiveSignatureController.value
                        .copyWith(contactPerson: value)),
                    onTap: onTap,
                    onEditingComplete: onEditingComplete,
                    onSubmitted: (value) => onFieldSubmitted?.call(state
                        ._effectiveSignatureController.value
                        .copyWith(contactPerson: value)),
                    inputFormatters: inputFormatters,
                    enabled: enabled ?? decoration?.enabled ?? true,
                    cursorWidth: cursorWidth,
                    cursorHeight: cursorHeight,
                    cursorRadius: cursorRadius,
                    cursorColor: cursorColor,
                    scrollPadding: scrollPadding,
                    scrollPhysics: scrollPhysics,
                    keyboardAppearance: keyboardAppearance,
                    enableInteractiveSelection: enableInteractiveSelection,
                    selectionControls: selectionControls,
                    buildCounter: buildCounter,
                    autofillHints: autofillHints,
                    scrollController: scrollController,
                    enableIMEPersonalizedLearning:
                        enableIMEPersonalizedLearning,
                  ),
                ],
              ),
            );
          },
        );

  static Decoration getSignatureDecoration(context, bool withError) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: getCurrentCalcThemeMode(context) == ThemeMode.light
            ? Colors.white
            : Theme.of(context).colorScheme.surface,
        border: Border.all(
            color: withError
                ? Colors.red
                : getCurrentCalcThemeMode(context) == ThemeMode.light
                    ? Theme.of(context).textTheme.bodySmall!.color!
                    : Colors.grey));
  }

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  final SignatureEditingController? signatureController;

  @override
  FormFieldState<SignatureInfo> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<SignatureInfo> {
  RestorableTextEditingController? _controller;
  RestorableSignatureEditingController? _signatureController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  SignatureEditingController get _effectiveSignatureController =>
      widget.signatureController ?? _signatureController!.value;

  @override
  SignatureFormField get widget => super.widget as SignatureFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    if (_signatureController != null) {
      _registerSignatureController();
    }
    // Make sure to update the internal [FormFieldState] value to sync up with
    // text editing controller value.
    setValue(_effectiveSignatureController.value);
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _registerSignatureController() {
    assert(_signatureController != null);
    registerForRestoration(_signatureController!, 'singatureController');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  void _createLocalSignatureController([SignatureInfo? value]) {
    assert(_signatureController == null);
    _signatureController = value == null
        ? RestorableSignatureEditingController()
        : RestorableSignatureEditingController.fromValue(value);
    if (!restorePending) {
      _registerSignatureController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _createLocalController(widget.initialValue != null
          ? TextEditingValue(text: widget.initialValue!.contactPerson ?? '')
          : null);
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }

    if (widget.signatureController == null) {
      _createLocalSignatureController(
          widget.initialValue ?? const SignatureInfo());
    } else {
      widget.signatureController!
          .addListener(_handleSignatureControllerChanged);
    }
  }

  @override
  void didUpdateWidget(SignatureFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (widget.controller != null) {
        if (widget.signatureController != null) {
          setValue(widget.signatureController?.value
              .copyWith(contactPerson: widget.controller!.text));
        }
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }

    if (widget.signatureController != oldWidget.signatureController) {
      oldWidget.signatureController
          ?.removeListener(_handleSignatureControllerChanged);
      widget.signatureController
          ?.addListener(_handleSignatureControllerChanged);

      if (oldWidget.signatureController != null &&
          widget.signatureController == null) {
        _createLocalSignatureController(oldWidget.signatureController!.value);
      }

      if (widget.signatureController != null) {
        setValue(widget.signatureController!.value);
        if (oldWidget.signatureController == null) {
          unregisterFromRestoration(_signatureController!);
          _signatureController!.dispose();
          _signatureController = null;
        }
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    widget.signatureController
        ?.removeListener(_handleSignatureControllerChanged);
    _controller?.dispose();
    _signatureController?.dispose();
    super.dispose();
  }

  @override
  void didChange(SignatureInfo? value) {
    super.didChange(value);
//TODO: dacci un occhio per verificare cosa succede qui
    if (_effectiveController.text != value?.contactPerson) {
      _effectiveController.text = value?.contactPerson ?? '';
    }
    if (_effectiveSignatureController.value != value) {
      _effectiveSignatureController.value = value!;
    }
  }

  @override
  void reset() {
    // setState will be called in the superclass, so even though state is being
    // manipulated, no setState call is needed here.
    _effectiveController.text = widget.initialValue?.contactPerson ?? '';
    _effectiveSignatureController.value =
        widget.initialValue ?? const SignatureInfo();
    super.reset();
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value?.contactPerson) {
      didChange(_effectiveSignatureController.value
          .copyWith(contactPerson: _effectiveController.text));
    }
  }

  void _handleSignatureControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveSignatureController.value != value) {
      didChange(_effectiveSignatureController.value);
    }
  }
}

/// A controller for an editable text field.
///
/// Whenever the user modifies a text field with an associated
/// [TextEditingController], the text field updates [value] and the controller
/// notifies its listeners. Listeners can then read the [label] and [selection]
/// properties to learn what the user has typed or how the selection has been
/// updated.
///
/// Similarly, if you modify the [label] or [selection] properties, the text
/// field will be notified and will update itself appropriately.
///
/// A [TextEditingController] can also be used to provide an initial value for a
/// text field. If you build a text field with a controller that already has
/// [label], the text field will use that text as its initial value.
///
/// The [value] (as well as [label] and [selection]) of this controller can be
/// updated from within a listener added to this controller. Be aware of
/// infinite loops since the listener will also be notified of the changes made
/// from within itself. Modifying the composing region from within a listener
/// can also have a bad interaction with some input methods. Gboard, for
/// example, will try to restore the composing region of the text if it was
/// modified programmatically, creating an infinite loop of communications
/// between the framework and the input method. Consider using
/// [TextInputFormatter]s instead for as-you-type text modification.
///
/// If both the [label] or [selection] properties need to be changed, set the
/// controller's [value] instead.
///
/// Remember to [dispose] of the [TextEditingController] when it is no longer
/// needed. This will ensure we discard any resources used by the object.
/// {@tool dartpad}
/// This example creates a [TextField] with a [TextEditingController] whose
/// change listener forces the entered text to be lower case and keeps the
/// cursor at the end of the input.
///
/// ** See code in examples/api/lib/widgets/editable_text/text_editing_controller.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [TextField], which is a Material Design text field that can be controlled
///    with a [TextEditingController].
///  * [EditableText], which is a raw region of editable text that can be
///    controlled with a [TextEditingController].
///  * Learn how to use a [TextEditingController] in one of our [cookbook recipes](https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller).
class SignatureEditingController extends ValueNotifier<SignatureInfo> {
  /// Creates a controller for an editable text field.
  ///
  /// This constructor treats a null [label] argument as if it were the empty
  /// string.
  SignatureEditingController({required SignatureInfo? info}) : super(info!);

  /// Creates a controller for an editable text field from an initial [TextEditingValue].
  ///
  /// This constructor treats a null [value] argument as if it were
  /// [TextEditingValue.empty].
  SignatureEditingController.fromValue(SignatureInfo? value) : super(value!);

  /// The current string the user is editing.
  Uint8List? get signatureImage => value.signature;

  /// The current string the user is editing.
  Uint8List? get signaturePointList => value.signature;

  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  ///
  /// This property can be set from a listener added to this
  /// [TextEditingController]; however, one should not also set [selection]
  /// in a separate statement. To change both the [label] and the [selection]
  /// change the controller's [value].
  set signatureImage(Uint8List? newImage) {
    signatureImage = newImage;
  }

  @override
  set value(SignatureInfo newValue) {
    super.value = newValue;
  }

  /// Set the [value] to empty.
  ///
  /// After calling this function, [label] will be the empty string and the
  /// selection will be collapsed at zero offset.
  ///
  /// Calling this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    value = const SignatureInfo();
  }
}
