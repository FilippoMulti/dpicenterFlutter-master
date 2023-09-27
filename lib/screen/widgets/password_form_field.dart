import 'package:dpicenter/platform/platform_helper.dart';
import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    Key? key,
    this.controller,
    this.showPasswordText = 'Mostra password',
    this.hidePasswordText = 'Nascondi password',
    this.labelText = 'Password',
    this.hintText = 'Inserisci password',
    this.validator,
    this.onChanged,
    this.decoration,
    this.maxLenght = 50,
    this.style,
    this.onFieldSubmitted,
    this.iconColor,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? showPasswordText;
  final String? hidePasswordText;
  final String? labelText;
  final String? hintText;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLenght;
  final TextStyle? style;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? iconColor;

  @override
  State<StatefulWidget> createState() => PasswordFormFieldState();
}

class PasswordFormFieldState extends State<PasswordFormField> {
  bool _passwordVisible = false;
  bool _validateCalled = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: widget.onChanged,
        autofillHints: isMacBrowser ? null : const [AutofillHints.password],
        textInputAction: TextInputAction.done,
        autovalidateMode: _validateCalled
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: widget.controller,
        maxLength: widget.maxLenght,
        obscureText: !_passwordVisible,
        decoration: widget.decoration?.copyWith(
                suffixIcon: IconButton(
              icon: Tooltip(
                message: !_passwordVisible
                    ? widget.showPasswordText
                    : widget.hidePasswordText,
                child: Icon(
                  // Based on passwordVisible state choose the icon
                  !_passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: widget.iconColor ??
                      Theme.of(context).textTheme.labelLarge!.color,
                  semanticLabel: !_passwordVisible
                      ? widget.showPasswordText
                      : widget.hidePasswordText,
                ),
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )) ??
            InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .color,
                        width: 1.0)),
                border: const OutlineInputBorder(),
                labelText: widget.labelText,
                //labelStyle: const TextStyle(color: Colors.white54),
                hintText: widget.hintText,
                //hintStyle: const TextStyle(color: Colors.white54),
                suffixIcon: IconButton(
                  icon: Tooltip(
                    message: !_passwordVisible
                        ? widget.showPasswordText
                        : widget.hidePasswordText,
                    child: Icon(
                      // Based on passwordVisible state choose the icon
                      !_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: widget.iconColor ??
                          Theme.of(context).textTheme.labelLarge!.color,
                      semanticLabel: !_passwordVisible
                          ? widget.showPasswordText
                          : widget.hidePasswordText,
                    ),
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )),
        style: widget.style,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: (str) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              setState(() {
                _validateCalled = true;
              });
            }
          });

          if (widget.validator != null) {
            return widget.validator!.call(str);
          } else {
            if (str!.isEmpty) {
              return "Campo obbligatorio";
            }
          }
          return null;
        });
  }
}
