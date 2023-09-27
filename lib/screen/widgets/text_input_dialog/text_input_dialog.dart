import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputDialog extends StatefulWidget {
  final String? title;
  final String? hint;
  final String initialValue;
  final List<TextInputFormatter>? inputFormatters;

  const TextInputDialog(
      {this.title,
      this.hint,
      required this.initialValue,
      this.inputFormatters,
      Key? key})
      : super(key: key);

  @override
  TextInputDialogState createState() => TextInputDialogState();
}

class TextInputDialogState extends State<TextInputDialog> {
  String? currentValue;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
    currentValue = controller.text;
  }

  @override
  Widget build(BuildContext context) => TextField(
        keyboardType: TextInputType.text,
        inputFormatters: widget.inputFormatters,

        ///
        ///
        /// Se si vuole filtrare i tasti visualizzati su Android utilizzare inputFormatters
        ///
        /*inputFormatters: <TextInputFormatter>[

              ///solo numeri e punto
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))
            ],*/
        onChanged: (value) {
          currentValue = value;
        },
        controller: controller,
        decoration: InputDecoration(hintText: widget.hint),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
