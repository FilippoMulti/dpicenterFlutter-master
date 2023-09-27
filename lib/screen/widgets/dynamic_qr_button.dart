import 'dart:typed_data';

import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class DynamicQrButton extends StatefulWidget {
  const DynamicQrButton(
      {required this.code,
      this.eyeColor = Colors.black,
      this.moduleColor = Colors.black54,
      this.label,
      super.key});

  final String code;
  final Color eyeColor;
  final Color moduleColor;
  final String? label;

  @override
  DynamicQrButtonState createState() => DynamicQrButtonState();
}

class DynamicQrButtonState extends State<DynamicQrButton> {
  late Future<ui.Image> _dataFuture;

  ui.Image? image;

  @override
  void initState() {
    super.initState();
    _dataFuture = getUiImage('graphics/triangle.png', 40, 40);
  }

  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder<ui.Image>(
      future: getUiImage('graphics/triangle.png', 40, 40),
      builder: (ctx, snapshot) {
        double size = 200.0;
        if (!snapshot.hasData) {
          return SizedBox(width: size, height: size);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomPaint(
                  size: Size.square(size),
                  painter: QrPainter(
                    data: code,
                    version: QrVersions.auto,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: eyeColor,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle,
                      color: moduleColor,
                    ),
                    // size: 320.0,
                    embeddedImage: snapshot.data,
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size.square(40),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              onTap: () async {
                ByteData? image = await QrPainter(
                  data: code,
                  version: QrVersions.auto,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: Colors.black.withAlpha(200),
                  ),
                  // size: 320.0,
                  embeddedImage: snapshot.data,
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size.square(40),
                    color: Colors.green.withAlpha(100),
                  ),
                ).toImageData(220);

                if (image != null) {
                  var pngBytes = image.buffer.asUint8List();
                  String newPath = 'qr.png';
                  if (!kIsWeb) {
                    var tempDir = await getTemporaryDirectory();
                    String tempPath = tempDir.path;
                    newPath = "$tempPath${Platform.pathSeparator}qr.png";
                    saveFile(newPath, pngBytes);
                  } else {}
                  openFilepath(newPath, bytes: pngBytes);
                }
              },
            ),
            if (label != null) Text(label!),
          ],
        );
      },
    );*/

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<ui.Image>(
                future: _dataFuture,
                builder: (ctx, snapshot) {
                  double size = 200.0;
                  if (!snapshot.hasData) {
                    return SizedBox(width: size, height: size);
                  } else {
                    return CustomPaint(
                      size: Size.square(size),
                      painter: QrPainter(
                        data: widget.code,
                        version: QrVersions.auto,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: widget.eyeColor,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: widget.moduleColor,
                        ),
                        // size: 320.0,
                        embeddedImage: snapshot.data,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size.square(40),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }
                }),
          ),
          onTap: () async {
            Uint8List? bytes = await imageToPrintFromCode(widget.code);
            String newPath = '';
            if (bytes != null) {
              if (!kIsWeb) {
                var tempDir = await getTemporaryDirectory();
                String tempPath = tempDir.path;
                newPath = "$tempPath${Platform.pathSeparator}qr.png";
                saveFile(newPath, bytes);
              } else {}
              openFilepath(newPath, bytes: bytes);
            }
          },
        ),
        if (widget.label != null) Text(widget.label!),
      ],
    );
  }

  static Future<Uint8List?> imageToPrintFromCode(String code,
      {String logoAsset = 'graphics/triangle.png', int size = 40}) async {
    var embeddedImage = await getUiImage(logoAsset, size, size);
    ByteData? image = await QrPainter(
      data: code,
      version: QrVersions.auto,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle,
        color: Colors.black.withAlpha(200),
      ),
      // size: 320.0,
      embeddedImage: embeddedImage,
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: const Size.square(40),
        color: Colors.green.withAlpha(100),
      ),
    ).toImageData(220);

    if (image != null) {
      Uint8List pngBytes = image.buffer.asUint8List();
      return pngBytes;
    }
    return null;
  }
}
