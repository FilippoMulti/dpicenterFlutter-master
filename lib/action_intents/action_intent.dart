import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class CloseIntent extends Intent {
  const CloseIntent();
}

class CloseAction extends Action<CloseIntent> {
  CloseAction(this.appWindow);

  final dynamic appWindow;

  @override
  Object? invoke(covariant CloseIntent intent) async {
    try {
      if (_isOpen == false) {
        if (await showCloseMessage() ?? false) {
          appWindow.close();
        }
      }
    } catch (e) {
      print("CloseAction: $e");
    }
    return null;
  }
}

bool _isOpen = false;

Future<bool?> showCloseMessage() async {
  _isOpen = true;
  var result = await showDialog(
    context: navigatorKey!.currentContext!,
    builder: (BuildContext context) {
      return MessageDialog(
          title: 'Chiusura DpiCenter',
          message: 'Vuoi chiudere l\'applicazione?',
          type: MessageDialogType.yesNo,
          yesText: 'SI',
          noText: 'NO',
          okPressed: () {
            Navigator.pop(context, true);
          },
          noPressed: () {
            Navigator.pop(context, false);
          });
    },
  ).then((value) async {
    return value;
    //return value
  });
  _isOpen = false;
  return result;
}
