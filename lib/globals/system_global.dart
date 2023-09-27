import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'dart:ui' as ui;
import 'package:open_file/open_file.dart' as open_file;
import 'package:universal_html/html.dart' as html;

openFile(Media file, {bool withMessage = true, BuildContext? context}) async {
  bool toOpen = false;

  if (withMessage && context != null) {
    bool? res = await openMediaRequestMessage(context, file.name);

    if (res != null) {
      toOpen = res;
    }
  } else {
    toOpen = true;
  }
  if (toOpen) {
    if (kIsWeb) {
      if (file.content != null) {
        webDownload(file.name, base64Decode(file.content!));
      }
    } else {
      open_file.OpenFile.open(file.file!.path!);
    }
  }
}

openFilepath(String filepath,
    {List<int>? bytes, bool withMessage = true, BuildContext? context}) async {
  bool toOpen = false;

  if (withMessage && context != null) {
    bool? res = await openMediaRequestMessage(context, filepath);

    if (res != null) {
      toOpen = res;
    }
  } else {
    toOpen = true;
  }
  if (toOpen) {
    if (kIsWeb) {
      if (bytes != null) {
        webDownload(filepath, bytes);
      }
    } else {
      open_file.OpenFile.open(filepath);
    }
  }
}

void webDownload(String filename, List<int> bytes) {
  // prepare
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = filename;
  html.document.body?.children.add(anchor);

  // download
  anchor.click();

  // cleanup
  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}

Future<bool?> openMediaRequestMessage(
    BuildContext context, String mediaName) async {
  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return MessageDialog(
          title: 'Aprire il file',
          message: 'Aprire il file selezionato ($mediaName)?',
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
  ).then((value) {
    return value;
    //return value
  });
  return result;
}

Future saveFile(String path, List<int> bytes) async {
  try {
    var file = File(path);
    await file.writeAsBytes(bytes, mode: FileMode.write);
  } catch (e) {
    debugPrint(e.toString());
  }
}
