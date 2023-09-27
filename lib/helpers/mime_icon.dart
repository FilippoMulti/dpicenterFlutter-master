import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///passando un filename o un extension visualizza l'icona che rappresenta il file
class MimeTypeIcon extends StatelessWidget {
  final String? filename;
  final String? extension;
  final Color? color;

  const MimeTypeIcon({this.filename, this.extension, this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getIcon();
  }

  FaIcon getIcon() {
    String? mimeType;
    if (filename != null) {
      mimeType = mime(filename);
    } else if (extension != null) {
      mimeType = mimeFromExtension(extension!);
    }

    if (mimeType == null) {
      return FaIcon(FontAwesomeIcons.file, color: color);
    }

    if (mimeType.contains('pdf')) {
      return FaIcon(FontAwesomeIcons.filePdf, color: color);
    }
    if (mimeType.contains('word')) {
      return FaIcon(FontAwesomeIcons.fileWord, color: color);
    }

    if (mimeType.contains('spreadsheet')) {
      return FaIcon(FontAwesomeIcons.fileExcel, color: color);
    }
    if (mimeType.contains('image')) {
      return FaIcon(FontAwesomeIcons.fileImage, color: color);
    }
    if (mimeType.contains('zip') ||
        mimeType.contains('rar') ||
        mimeType.contains('7z') ||
        mimeType.contains('tar') ||
        mimeType.contains('gz')) {
      return FaIcon(FontAwesomeIcons.fileZipper, color: color);
    }
    return FaIcon(FontAwesomeIcons.file, color: color);
  }
}
