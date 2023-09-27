import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:universal_io/io.dart';

Future<Uint8List?> readBytesFromPath(String filePath) async {
  Uri myUri = Uri.file(filePath);
  File file = File.fromUri(myUri);
  Uint8List? bytes;
  await file.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    debugPrint('reading of bytes is completed');
  }).catchError((onError) {
    debugPrint('Exception Error while reading from path:$onError');
  });
  return bytes;
}
