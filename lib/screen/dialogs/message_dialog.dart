import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:flutter/material.dart';

enum MessageDialogType {
  okOnly,
  yesNo,
  yesNoCancel,
}

// Define a custom Form widget.
class MessageDialog extends StatefulWidget {
  final String? message;
  final String? title;
  final VoidCallback? okPressed;
  final VoidCallback? cancelPressed;
  final VoidCallback? noPressed;
  final String? okText;
  final String? yesText;
  final String? noText;
  final String? cancelText;
  final MessageDialogType? type;

  final Widget? okWidget;
  final Widget? yesWidget;
  final Widget? noWidget;
  final Widget? cancelWidget;

  const MessageDialog({Key? key,
    this.title,
    this.message,
    this.okPressed,
    this.cancelPressed,
    this.noPressed,
    this.okText,
    this.yesText,
    this.noText,
    this.cancelText,
    this.type,
    this.okWidget,
    this.noWidget,
    this.cancelWidget,
    this.yesWidget})
      : super(key: key);

  @override
  MessageDialogState createState() {
    return MessageDialogState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MessageDialogState extends State<MessageDialog> {
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    List<Widget> buttons = <Widget>[];

    switch (widget.type) {
      case MessageDialogType.okOnly:
        buttons.add(widget.okWidget == null
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
                    primary: standardOkButtonBackgroundColor(context)),
                onPressed: widget.okPressed,
                child: Text(
                  widget.okText!,
                  style: TextStyle(color: standardOkButtonTextColor(context)),
                ),
              )
            : widget.okWidget!);
        break;
      case MessageDialogType.yesNo:
        buttons.add(widget.noWidget == null
            ? ElevatedButton(
          onPressed: widget.noPressed,
                style: ElevatedButton.styleFrom(
                  primary: standardNoButtonBackgroundColor(context),
                  /*getMenuColor(
                        Theme.of(context).colorScheme.onError.value.toString())*/
                ),
                child: Text(widget.noText!,
                    style:
                        TextStyle(color: standardNoButtonTextColor(context))),
              )

            /*ElevatedButton(
                onPressed: widget.noPressed,
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.error),
                child: Text(
                  widget.noText!,
                  style: TextStyle(
                      color: getMenuColor(
                          Theme.of(context).colorScheme.onError.toHex())),
                ))*/
            : widget.noWidget!);
        buttons.add(widget.yesWidget == null
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
                  backgroundColor: standardYesButtonBackgroundColor(context),
                ),
                onPressed: widget.okPressed,
                child: Text(
                  widget.yesText!,
                  style: TextStyle(color: standardYesButtonTextColor(context)),
                ),
              )
            : widget.yesWidget!);

        break;
      case MessageDialogType.yesNoCancel:
        buttons.add(widget.cancelWidget == null
            ? ElevatedButton(
                onPressed: widget.cancelPressed,
                style: ElevatedButton.styleFrom(
                    primary: standardCustomButtonBackgroundColor(context)),
                child: Text(widget.cancelText!,
                    style: TextStyle(
                        color: standardCustomButtonTextColor(context))))
            : widget.cancelWidget!);
        buttons.add(widget.noWidget == null
            ? ElevatedButton(
          onPressed: widget.noPressed,
                style: ElevatedButton.styleFrom(
                  primary: standardNoButtonBackgroundColor(context),
                  /*getMenuColor(
                        Theme.of(context).colorScheme.onError.value.toString())*/
                ),
                child: Text(widget.noText!,
                    style:
                        TextStyle(color: standardNoButtonTextColor(context))),
              )
            : widget.noWidget!);
        buttons.add(widget.yesWidget == null
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: standardYesButtonBackgroundColor(context)
                    /*getMenuColor(
                        Theme.of(context).colorScheme.onError.value.toString())*/
                ),
                onPressed: widget.okPressed,
                child: Text(
                  widget.yesText!,
                  style: TextStyle(color: standardYesButtonTextColor(context)),
                ),
              )
            : widget.yesWidget!);

        break;
      default:
        break;
    }

    // set up the AlertDialog
    return _customMessageDialog(widget.title!, widget.message!, buttons);
  }

  _customMessageDialog(String title, String message, List<Widget> buttons) {
    return AlertDialog(
        backgroundColor: getAppBackgroundColor(context),
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: buttons);
  }
}

Future showMessage(
  BuildContext context, {
  String? message,
  String? title,
  VoidCallback? okPressed,
  VoidCallback? cancelPressed,
  VoidCallback? noPressed,
  String? okText = "OK",
  String? yesText = "SI",
  String? noText = "NO",
  String? cancelText,
  MessageDialogType? type,
  Widget? okWidget,
  Widget? yesWidget,
  Widget? noWidget,
  Widget? cancelWidget,
}) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          title: title,
          message: message,
          type: type ?? MessageDialogType.okOnly,
          okText: okText ?? "OK",
          cancelText: cancelText,
          yesText: yesText,
          noText: noText,
          okPressed: okPressed ?? () => Navigator.pop(context, true),
          cancelPressed: cancelPressed ?? () => Navigator.pop(context, null),
          noPressed: noPressed ?? () => Navigator.pop(context, false),
          okWidget: okWidget,
          noWidget: noWidget,
          cancelWidget: cancelWidget,
        );
      }).then((value) {
    return value;
    //return value
  });
}
