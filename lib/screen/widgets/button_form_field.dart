import 'package:flutter/material.dart';

class ButtonFormField<T> extends FormField<T> {
  ButtonFormField({
    Key? key,
    T? initialValue,
    this.controller,

    /// Initial field value
    this.decoration =
        const InputDecoration(), // A BoxDecoration to style the field FormFieldSetter
    this.buttonStyle,
    onSaved, // Method called when when the form is saved FormFieldValidator
    required this.buttonChild,
    this.focusNode,
    bool autovalidate = false,
    AutovalidateMode? autovalidateMode,
    validator, // Method called for validation
    required this.onChanged, // Method called whenever the value changes
    this.onPressed, //metodo chiamato alla pressione del pulsante, richiede che venga restituito il risultato che verrà poi notificato tramite didChange
    this.constraints =
        const BoxConstraints(), // A BoxConstraints to set the switch size
  })  : assert(decoration != null),
        assert(constraints != null),
        assert(
          autovalidate == false ||
              autovalidate == true && autovalidateMode == null,
          'autovalidate and autovalidateMode should not be used together.',
        ),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          validator: validator,
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DecoratedBox(
                    decoration: !field.hasError
                        ? const BoxDecoration()
                        : (field as ButtonFormFieldState).errorDecoration(),
                    child: ConstrainedBox(
                      constraints: constraints!,
                      child: ElevatedButton(
                          focusNode: focusNode,
                          onPressed: onPressed != null
                              ? () async {
                                  try {
                                    ButtonFormFieldState fieldState =
                                        field as ButtonFormFieldState;
                                    dynamic value = await fieldState
                                        .widget.onPressed!
                                        .call();
                                    fieldState.didChange(value);
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              : null,
                          style: buttonStyle,
                          child: buttonChild),
                    )),
                if (field.hasError)
                  const SizedBox(
                    height: 8,
                  ),
                if (field.hasError)
                  ConstrainedBox(
                      constraints: constraints,
                      child: Text(
                        field.errorText!,
                        style: Theme.of(field.context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color: Theme.of(field.context).errorColor),
                      ))
              ],
            );
          },
        );

  final ButtonFormFieldController<T>? controller;
  final ValueChanged? onChanged;
  final Future<T>? Function()? onPressed;
  final InputDecoration? decoration;
  final BoxConstraints? constraints;
  final ButtonStyle? buttonStyle;
  final Widget buttonChild;

  final FocusNode? focusNode;

  @override
  FormFieldState<T> createState() => ButtonFormFieldState<T>();
}

class ButtonFormFieldState<T> extends FormFieldState<T> {
  dynamic selectedValue;
  late ButtonFormFieldController<T> controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ??
        ButtonFormFieldController(initialValue: widget.initialValue);
  }

  @override
  void didChange(dynamic value) {
    super.didChange(value);
    controller.setValue(value);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  ButtonFormField<T> get widget {
    return super.widget as ButtonFormField<T>;
  }

  BoxDecoration errorDecoration() {
    return const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.pink,
            spreadRadius: 4,
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.pink,
            spreadRadius: -4,
            blurRadius: 5,
          )
        ]);
  }
}

class ButtonFormFieldController<T> extends ChangeNotifier {
  T? initialValue;

  T? value;

  void setValue(T value) {
    this.value = value;
    notifyListeners();
  }

  ButtonFormFieldController({this.initialValue, this.value});
}
