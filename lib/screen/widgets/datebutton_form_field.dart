import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DateTimeButtonFormField extends FormField<DateTime> {
  DateTimeButtonFormField({
    Key? key,
    DateTime? initialValue,

    /// Initial field value
    this.firstDate,
    this.lastDate,
    this.decoration =
        const InputDecoration(), // A BoxDecoration to style the field FormFieldSetter
    this.buttonStyle,
    onSaved, // Method called when when the form is saved FormFieldValidator
    required this.buttonChild,
    bool autovalidate = false,
    AutovalidateMode? autovalidateMode,
    validator, // Method called for validation
    required this.onChanged, // Method called whenever the value changes
    this.constraints =
        const BoxConstraints(), // A BoxConstraints to set the switch size
    required this.withTime,
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
            return DecoratedBox(
                decoration: !field.hasError
                    ? const BoxDecoration()
                    : (field as _DateTimeButtonFormFieldState)
                        .errorDecoration(),
                child: ConstrainedBox(
                  constraints: constraints!,
                  child: ElevatedButton(
                      onPressed: () async {
                        _DateTimeButtonFormFieldState fieldState =
                            field as _DateTimeButtonFormFieldState;
                        await fieldState.selectDate();
                      },
                      style: buttonStyle,
                      child: buttonChild),
                ));
          },
        );
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged? onChanged;
  final InputDecoration? decoration;
  final BoxConstraints? constraints;
  final ButtonStyle? buttonStyle;
  final Widget buttonChild;

  final bool withTime;

  @override
  FormFieldState<DateTime> createState() => _DateTimeButtonFormFieldState();
}

class _DateTimeButtonFormFieldState extends FormFieldState<DateTime> {
  DateTime? selectedValue;

  @override
  void didChange(DateTime? value) {
    super.didChange(value);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  DateTimeButtonFormField get widget {
    return super.widget as DateTimeButtonFormField;
  }

  BoxDecoration errorDecoration() {
    return const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
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

  selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.initialValue ?? DateTime.now(),
        firstDate: widget.firstDate ?? DateTime.now(),
        lastDate: widget.lastDate ?? DateTime(2101));
    if (picked != null) selectedValue = picked;
    if (!widget.withTime) {
      didChange(selectedValue);
    } else {
      selectTime();
    }
  }

  selectTime() async {
    TimeOfDay timePart = TimeOfDay(
        hour: widget.initialValue?.hour ?? 0,
        minute: widget.initialValue?.minute ?? 0);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: timePart,
    );
    //initialEntryMode: TimePickerEntryMode.);
    try {
      if (picked != null) {
        if (selectedValue != null) {
          selectedValue = DateTime(selectedValue!.year, selectedValue!.month,
              selectedValue!.day, picked.hour, picked.minute);

          didChange(selectedValue);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
