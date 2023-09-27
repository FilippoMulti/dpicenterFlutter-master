import 'dart:convert';

import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/services/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:open_file/open_file.dart' as open_file;

class ImagePreview extends StatefulWidget {
  final int index;
  final List<ItemPicture> list;

  const ImagePreview({required this.index, required this.list, Key? key})
      : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return preview(currentIndex);
  }

  Widget preview(int index) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  if (currentIndex > 0) {
                    currentIndex -= 1;
                  } else {
                    currentIndex = widget.list.length - 1;
                  }
                });
              },
            ),
            Expanded(
              child: InteractiveViewer(
                minScale: 0.25,
                maxScale: 100,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: (widget.list[index].picture != null &&
                        widget.list[index].picture!.bytes != null)
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.memory(
                                      widget.list[index].picture!.bytes!,
                                      filterQuality: FilterQuality.medium,
                                      fit: BoxFit.contain)
                                  .image,
                              fit: BoxFit.cover),
                        ),
                        child: ClipRRect(
                            // make sure we apply clip it properly
                            child: BackdropFilter(
                                filter:
                                    ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Scaffold(
                                    backgroundColor: Colors.transparent,
                                    /*appBar: AppBar(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),*/
                                    body: Center(
                                      child: Stack(
                                        children: [
                                          Center(
                                              child: Image.memory(
                                                  filterQuality:
                                                      FilterQuality.medium,
                                                  widget.list[index].picture!
                                                      .bytes!,
                                                  fit: BoxFit.cover)),
                                        ],
                                      ),
                                    )))))
                    : Container(
                        color: Colors.black.withAlpha(100),
                        child: const Center(
                            child: Icon(
                          Icons.hourglass_bottom,
                          size: 256,
                        ))),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  if (currentIndex < widget.list.length - 1) {
                    currentIndex += 1;
                  } else {
                    currentIndex = 0;
                  }
                });
              },
            ),
          ],
        ),
        Positioned(
            left: 100,
            right: 100,
            bottom: 20,
            child: ElevatedButton(
                onPressed: () async {
                  if (!kIsWeb) {
                    ///solo piattiaforme native -> path_provider non funziona sul web
                    var tempDir = await getTemporaryDirectory();
                    String tempPath = tempDir.path;

                    if (widget.list[index].picture!.file == null) {
                      String newPath =
                          "$tempPath\\${widget.list[index].picture!.name.split('/').last}";
                      Uint8List bytes =
                          base64Decode(widget.list[index].picture!.content!);
                      saveFile(newPath, bytes);
                      widget.list[index] = widget.list[index].copyWith(
                          picture: widget.list[index].picture!.copyWith(
                              file: PlatformFile(
                                  path: newPath,
                                  name: newPath,
                                  size: bytes.length,
                                  bytes: bytes)));
                    }

                    if (widget.list[index].picture!.file != null) {
                      try {
                        open_file.OpenFile.open(
                            widget.list[index].picture!.file!.path!);
                      } catch (e) {
                        print("Errore Apri: $e");
                      }
                    }
                  }
                  //OpenFile.open("/sdcard/example.txt");
                },
                child: const Text("Apri"))),
        Positioned(
            left: 0,
            top: 0,
            child: Material(
              type: MaterialType.transparency,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(48),
              //shape: const CircleBorder(),
              child: SizedBox(
                height: 64,
                width: 64,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white.withAlpha(200),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                ),
              ),
            )),
      ],
    );
  }
}

void showImagePreview(
  BuildContext context,
  int index,
  List<ItemPicture> items,
) {
  double oldBackgroundOpacity =
      prefs!.getDouble(backgroundOpacitySetting) ?? 1.0;
  prefs!.setDouble(backgroundOpacitySetting, 1.0);
  eventBus.fire(RestartHubEvent(newUrl: MultiService.baseUrl));

  showDialog(
      context: context,
      builder: (context) {
        return ImagePreview(
          index: index,
          list: items,
        );
      }).then((value) {
    prefs!.setDouble(backgroundOpacitySetting, oldBackgroundOpacity);
    eventBus.fire(RestartHubEvent(newUrl: MultiService.baseUrl));
  });
}
