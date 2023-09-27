import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/file_global.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/image_preview.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/widgets/take_picture/take_picture_screen.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'dart:ui' as ui;
import 'package:open_file/open_file.dart' as open_file;
import 'package:desktop_drop/desktop_drop.dart';

class ImageLoader extends StatefulWidget {
  final List<ItemPicture>? itemPictures;
  final Function(List<ItemPicture> values)? onChanged;
  final Function(List<ItemPicture> values) onLoaded;
  final bool showButtons;

  const ImageLoader({
    Key? key,
    this.itemPictures,
    this.onChanged,
    this.showButtons = true,
    required this.onLoaded,
  }) : super(key: key);

  @override
  ImageLoaderState createState() => ImageLoaderState();
}

class ImageLoaderState extends State<ImageLoader>
    with AutomaticKeepAliveClientMixin {
  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///immagini selezionate
  final List<ItemPicture>? selectedImages = <ItemPicture>[];

  ///immagini sottoposte a compressione
  List<ItemPicture>? _compressingImages = <ItemPicture>[];

  ///stato della compressione immagini
  int compressStatus = 0;

  ///immagini sottoposte a caricamento
  final List<ItemPicture> _loadingImages = <ItemPicture>[];

  String imageGridKeyString = "key";

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 150), () {
      _loadImages();
    });

    super.initState();
  }

  FilePickerResult? getFilePickerResultFromDroppedFiles(List<XFile> files) {
    FilePickerResult? result;
    if (isDesktop) {
      List<PlatformFile> platformFiles = [];
      if (files.isNotEmpty) {
        for (XFile s in files) {
          print("File $s");
          platformFiles.add(PlatformFile(
            name: s.name,
            path: s.path,
            size: 0,
          ));
        }
      }
      result = FilePickerResult(platformFiles);
    }
    return result;
  }

  Future<FilePickerResult?> getFilePickerResultFromClipboard() async {
    FilePickerResult? result;
    if (isDesktop) {
      List<String> files = await Pasteboard.files();
      List<PlatformFile> platformFiles = [];
      if (files.isNotEmpty) {
        for (String s in files) {
          print("File $s");
          platformFiles.add(PlatformFile(
            name: s,
            path: s,
            size: 0,
          ));
        }
      }
      result = FilePickerResult(platformFiles);
    }
    return result;
  }

  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DropTarget(
      onDragDone: (detail) {
        setState(() {
          FilePickerResult? result =
              getFilePickerResultFromDroppedFiles(detail.files);
          if (result != null && result!.files.isNotEmpty) {
            editState = true;
            _compressFile(result);
          }
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTap: _showCustomMenu,
        // This does not give the tap position ...
        onLongPress: _showCustomMenu,
        onSecondaryTapDown: _storePosition,
        // Have to remember it on tap-down.
        onTapDown: _storePosition,
        child: Column(
          children: [
            _detailImagesWidget(),
            _attachImages(),
          ],
        ),
      ),
    );
  }

  _idle() {
    var bloc = BlocProvider.of<PictureBloc>(context);
    bloc.add(const PictureEvent(
        status: PictureEvents.idle, bytesList: <Uint8List>[]));
  }

  _loadImages() {
    var bloc = BlocProvider.of<ServerDataBloc<Media>>(context);
    bloc.add(ServerDataEvent<Media>(
        status: ServerDataEvents.fetch,
        onEvent: (Bloc bloc, ServerDataEvent event, Emitter emit) async {
          if (widget.itemPictures != null) {
            for (ItemPicture itemPicture in widget.itemPictures!) {
              selectedImages!.add(itemPicture);
            }
          }

          MultiService<Media> picturesService =
              MultiService<Media>(Media.fromJsonModel, apiName: "Media");
          try {
            ///caricare le immagini effettive
            if (widget.itemPictures != null) {
              for (int index = 0; index < selectedImages!.length; index++) {
                ItemPicture itemPicture = selectedImages![index];
                if (itemPicture.mediaId != 0) {
                  ///solo immagini già salvate
                  QueryModel item =
                      QueryModel(id: itemPicture.mediaId.toString());
                  List<Media>? pic = await picturesService.get(item);
                  if (pic != null && pic.isNotEmpty) {
                    var selectedImage = itemPicture.copyWith(
                        picture: pic[0]
                            .copyWith(bytes: base64Decode(pic[0].content!)));
                    selectedImages![index] = selectedImage;
                    emit(ServerDataAdded<Media>(event: event, item: pic[0]));
                  }
                }
              }
            }
            emit(ServerDataLoaded<Media>(event: event));
            widget.onLoaded.call(selectedImages!);
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          } finally {}
        }));
  }

  _compressFile(FilePickerResult? filesPicked) async {
    if (filesPicked != null) {
      //_files.removeWhere((element) => element == null);
      var bloc = BlocProvider.of<PictureBloc>(context);
      bloc.add(PictureEvent(
          status: PictureEvents.compressList,
          fileList: <FilePickerResult>[filesPicked]));
    }
  }

  _addFile(String name, Uint8List bytes) async {
    //_files.removeWhere((element) => element == null);
    var bloc = BlocProvider.of<PictureBloc>(context);
    bloc.add(
        PictureEvent(status: PictureEvents.addFile, name: name, bytes: bytes));
  }

  Widget _attachImages() {
    return BlocBuilder<PictureBloc, PictureState>(
        builder: (BuildContext context, PictureState state) {
      List<Widget> children = <Widget>[];
      if (state is PictureError) {
        for (var element in state.compressedFilesStatus!) {
          children.add(Text(element));
        }
      }
      switch (state.event!.status) {
        case PictureEvents.compressList:
          if (state is PictureInitState) {}
          if (state is PictureCompressStarted) {
            children.add(addStopButton());
          }
          if (state is PictureCompressed) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
            children.add(addStopButton());
          }
          if (state is PictureCompressedError) {
            for (var element in state.compressedFilesStatus!) {
              children.add(Text(element));
            }
          }
          if (state is PictureCompressCompleted) {
            /*  for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/
          }
          if (state is PictureEndState) {
            /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/
            if (widget.showButtons) {
              children.add(addImagesButton());
              if (cameras != null && cameras!.isNotEmpty) {
                children.add(const SizedBox(
                  height: 16.0,
                ));
                children.add(takePictureButton());
              }
            }
          }
          break;
        case PictureEvents.idle:
          if (widget.showButtons) {
            children.add(addImagesButton());
            if (cameras != null && cameras!.isNotEmpty) {
              children.add(const SizedBox(
                height: 16.0,
              ));
              children.add(takePictureButton());
            }
          }

          break;
        default:
          break;
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      );
    });
  }

  Widget _detailImagesWidget() {
    return BlocListener<ServerDataBloc<Media>, ServerDataState>(
        listener: (BuildContext context, ServerDataState state) {
      if (state.event is ServerDataLoadedCompleted) {}
    }, child: BlocBuilder<ServerDataBloc<Media>, ServerDataState>(
            builder: (BuildContext context, ServerDataState state) {
      print(state.toString());
      if (state is ServerDataLoaded) {
        return _detailImagesWidgetBloc();
      }
      return Column(
        children: [
          Center(
              child: SizedBox(height: 50, child: shimmerComboLoading(context))),
          const Center(
            child: SizedBox(
                height: 50, child: Text("Caricamento immagini in corso...")),
          ),
          _detailImagesWidgetBloc(),
        ],
      );
    }));
  }

  Widget _detailImagesWidgetBloc() {
    return BlocListener<PictureBloc, PictureState>(
        listener: (BuildContext context, PictureState state) {
      if (state.event!.status == PictureEvents.idle) {
        _compressingImages = null;
        compressStatus = 0;
      } else {
        if (state is PictureCompressStarted) {
          _compressingImages = state.images
              .map((e) => ItemPicture(
                  itemPictureId: 0,
                  compressionId: e.compressionId,
                  itemId: 0,
                  mediaId: e.mediaId ?? 0,
                  picture: e))
              .toList();
          compressStatus = 1;
        }

        if (state is PictureCompressed) {
          _compressingImages?.removeWhere((element) =>
              element.compressionId == state.image!.compressionId!);
          selectedImages?.add(ItemPicture(
              itemPictureId: 0,
              itemId: 0,
              compressionId: state.image?.compressionId ?? 0,
              mediaId: state.image?.mediaId ?? 0,
              picture: state.image));
          widget.onChanged?.call(selectedImages!);
        }
        if (state is PictureAddCompleted) {
          selectedImages?.add(ItemPicture(
              itemPictureId: 0,
              itemId: 0,
              compressionId: 0,
              mediaId: state.images.first.mediaId ?? 0,
              picture: state.images.first));
          widget.onChanged?.call(selectedImages!);
        }

        if (state is PictureCompressCompleted) {
          _compressingImages =
              null; //state.images.map((e) => ItemPicture(itemPictureId: 0, itemId: 0, pictureId: 0, picture: e)).toList();

          compressStatus = 0;

          widget.onChanged?.call(selectedImages!);
        }
      }
    }, child: BlocBuilder<PictureBloc, PictureState>(
            builder: (BuildContext context, PictureState state) {
      if (state is PictureError) {
        return Text("error: ${state.error}");
      }
      switch (state.event!.status) {
        case PictureEvents.compressList:
        case PictureEvents.addFile:
          if (state is PictureInitState) {}
          if (state is PictureCompressStarted) {}
          if (state is PictureCompressed) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
          }
          if (state is PictureCompressedError) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
          }
          if (state is PictureCompressCompleted) {
            /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/
          }
          if (state is PictureEndState) {
            /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/
          }
          if (selectedImages != null && selectedImages!.isNotEmpty ||
              _compressingImages != null && _compressingImages!.isNotEmpty) {
            return imageGrid();
          }

          break;

        case PictureEvents.idle:
          //children.add(addImagesButton());

          break;
        default:
          break;
      }
      if (selectedImages != null && selectedImages!.isNotEmpty) {
        return imageGrid();
      }
      return const SizedBox();
    }));
  }

  Offset? _tapPosition;

  void _showCustomMenu() async {
    final RenderBox? overlay =
        Overlay.of(context)?.context?.findRenderObject() as RenderBox?;

    bool openMenu = false;
    Uint8List? imageBytes;

    if (kIsWeb) {
      openMenu = true;
    } else {
      imageBytes = await Pasteboard.image;
      if (imageBytes != null) {
        openMenu = true;
      }
    }

/*    var result = await Clipboard.getData('image/png');

    print("ShowCustomMenu");
    print("text: ${await Pasteboard.text}");
    print("html: ${await Pasteboard.html}");*/

    //imageStream.isEmpty
    FilePickerResult? result = await getFilePickerResultFromClipboard();
    if (result != null && result.files.isNotEmpty) {
      openMenu = true;
    }
    /*if (isDesktop) {
      List<String> files = await Pasteboard.files();
      List<PlatformFile> platformFiles = [];
      if (files.isNotEmpty){
        openMenu=true;
        for (String s in files) {
          print("File $s");
          platformFiles.add(PlatformFile(name: s, path: s, size: 0,));
        }
      }
      result = FilePickerResult(platformFiles);
    }
*/
    //print(imageBytes?.length);

    if (openMenu) {
      showMenu(
              context: context,
              items: <PopupMenuEntry<int>>[
                PopupMenuItem(
                  child: const Text("Incolla"),
                  onTap: () async {
                    imageBytes ??= await Pasteboard.image;
                    if (imageBytes != null) {
                      _addFile('pasted', imageBytes!);
                    }

                    if (result != null) {
                      editState = true;
                      await _compressFile(result);
                    }
                  },
                )
              ],
              position: RelativeRect.fromRect(
                  (_tapPosition ?? const Offset(0, 0)) & const Size(40, 40),
                  // smaller rect, the touch area
                  Offset.zero &
                      (overlay?.size ??
                          const Size(40, 40)) // Bigger rect, the entire screen
                  ))
          .then<void>((int? delta) {
        // delta would be null if user taps on outside the popup menu
        // (causing it to close without making selection)
        /* if (delta == null) return;

        if (delta==0){
            _addFile('pasted', imageBytes);

        }
        setState(() {

        });*/
      });
    }

    // Another option:
    //
    // final delta = await showMenu(...);
    //
    // Then process `delta` however you want.
    // Remember to make the surrounding function `async`, that is:
    //
    // void _showCustomMenu() async { ... }
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Widget imageGrid() {
    List<Widget> children = <Widget>[];
    var grid = _buildImagesGrid(imageGridKeyString);

    var container = AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _dragging ? Colors.yellow.withAlpha(100) : null,
            border: Border.all(
                color: selectedImages
                            ?.where((element) => element.mediaId != -1)
                            .toList(growable: false)
                            .isEmpty ??
                        true
                    ? Colors.transparent
                    : isDarkTheme(context)
                        ? Colors.grey
                        : Theme.of(context).textTheme.bodySmall!.color!)),
        child: Center(child: grid));

    var padding = Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
        child: container);
    children.add(padding);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget addImagesButton() {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: true,
            );
            if (result != null) {
              /*       setState(() {
                imageGridKeyString=Random().nextInt(1000000).toString();
              });*/
              editState = true;
              await _compressFile(result);
            }
            /*List<FilePickerCross>? myFiles =
                await FilePickerCross.importMultipleFromStorage(
                        type: kIsWeb ? FileTypeCross.any : FileTypeCross.custom,
                        // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
                        fileExtension:
                            'png, jpg, jpeg' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
                        )
                    .then((value) async {
              await _compressFiles(value);
              */ /*value.forEach((element) async {
                    print("Before: " + element.length.toString());
                    File result = await compressPicture(File(element.path!));
                    print("After: " + result.length.toString());
                  });*/ /*
              return value;
            }).onError((error, _) {
              String _exceptionData = error.toString();
              if (kDebugMode) {
                print('----------------------');
              }
              if (kDebugMode) {
                print('REASON: ${_exceptionData}');
              }
              if (_exceptionData == 'read_external_storage_denied') {
                if (kDebugMode) {
                  print('Permission was denied');
                }
              } else if (_exceptionData == 'selection_canceled') {
                if (kDebugMode) {
                  print('User canceled operation');
                }
              }
              if (kDebugMode) {
                print('----------------------');
              }
              return <FilePickerCross>[];
            });*/
          },
          child: const Text("Aggiungi immagine")),
    );
  }

  Widget takePictureButton() {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            // Obtain a list of the available cameras on the device.

            //final cameras = await availableCameras();

            // Get a specific camera from the list of available cameras.
            if (cameras != null && cameras!.isNotEmpty) {
              final firstCamera = cameras!.first;

              double oldBackgroundOpacity =
                  prefs!.getDouble(backgroundOpacitySetting) ?? 1.0;
              prefs!.setDouble(backgroundOpacitySetting, 1.0);
              eventBus.fire(RestartHubEvent(newUrl: MultiService.baseUrl));

              showDialog(
                  context: context,
                  builder: (context) {
                    return TakePictureScreen(
                      // Pass the appropriate camera to the TakePictureScreen widget.
                      camera: firstCamera,
                    );
                  }).then((value) async {
                if (value != null) {
                  debugPrint("Value received from camera: ${value.toString()}");
                  List<PlatformFile> files = <PlatformFile>[];
                  Uint8List? bytes = await readBytesFromPath(value.toString());
                  files.add(PlatformFile(
                      path: value.toString(),
                      name: value.toString(),
                      size: bytes?.length ?? 0,
                      bytes: bytes));
                  FilePickerResult? result = FilePickerResult(files);
                  _compressFile(result);
                }
                prefs!
                    .setDouble(backgroundOpacitySetting, oldBackgroundOpacity);
                eventBus.fire(RestartHubEvent(newUrl: MultiService.baseUrl));
              });
            }
          },
          child: const Text("Scatta foto")),
    );
  }

  Widget addStopButton() {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            await _idle();
          },
          child: const Text("Ferma compressione")),
    );
  }

  ///main screen
  Widget _buildImagesGrid(String key) {
    return AnimationLimiter(
        key: ValueKey(key),
        child: SingleChildScrollView(
          child: Wrap(children: _buildGridImagesList()),
        ));
  }

  List<Widget> _buildGridImagesList([double size = 128]) {
    return AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 375),
        childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: widget,
              ),
            )),
        children: [
          ...List.generate(selectedImages?.length ?? 0, (int i) {
            return imageContainer(
                selectedImages!, i, size, selectedImages![i].mediaId != -1);
          }),
          ...List.generate(_compressingImages?.length ?? 0, (int i) {
            return imageContainer(_compressingImages!, i, size,
                _compressingImages![i].mediaId != -1);
          }),
        ]);
  }

  Widget imageContainer(
      List<ItemPicture> list, int index, double size, bool visible) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      clipBehavior: Clip.antiAlias,
      width: visible ? size : 0,
      height: visible ? size : 0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Stack(
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  clipBehavior: Clip.antiAlias,
                  width: visible ? size : 0,
                  height: visible ? size : 0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent),
                  child: list[index].picture?.bytes != null
                      ? Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: Image.memory(list[index].picture!.bytes!,
                                        fit: BoxFit.cover,
                                        isAntiAlias: true,
                                        filterQuality: FilterQuality.medium)
                                    .image,
                                fit: BoxFit.cover,
                                isAntiAlias: true,
                                filterQuality: FilterQuality.medium),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              /*Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return imagePreview(i);
                                    }));*/
                              showImagePreview(context, index, list);
                            },
                          ),
                        )
                      : list[index].picture?.file != null
                          ? imageCompressionWidget(list, index)
                          : imageLoadingWidget(list, index)),
              if (list[index].picture?.bytes != null && widget.showButtons)
                Positioned(
                  top: 8,
                  right: 8,
                  width: visible ? 32 : 0,
                  height: visible ? 32 : 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () async {
                      if (await deleteImageRequestMessage()) {
                        setState(() {
                          editState = true;
                          //imageGridKeyString=Random().nextInt(1000000).toString();
                          list[index] = list[index].copyWith(mediaId: -1);
                          widget.onChanged?.call(selectedImages!);
                          //list.remove(list[index]);
                        });
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black.withAlpha(50),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                        size: 20,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageCompressionWidget(List list, int index) {
    return Container(
      color: Color.alphaBlend(
          Colors.grey.withAlpha(200), Theme.of(context).colorScheme.primary),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
            child: LoadingIndicator(
                indicatorType: Indicator.ballRotate,

                /// Required, The loading type of the widget
                colors: [
                  Colors.red,
                  Colors.green,
                  Colors.yellow,
                ],

                /// Optional, The color collections
                strokeWidth: 2,

                /// Optional, The stroke of the line, only applicable to widget which contains line
                backgroundColor: Colors.transparent,

                /// Optional, Background of the widget
                pathBackgroundColor: Colors.transparent

                /// Optional, the stroke backgroundColor
                ),
          ),
          Text(
            "Compressione...\r\n${list[index].picture?.file?.name ?? ''}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 8),
          ),
        ],
      )),
    );
  }

  Widget imageLoadingWidget(List list, int index) {
    return Container(
      color: Color.alphaBlend(
          Colors.grey.withAlpha(200), Theme.of(context).colorScheme.primary),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
            child: LoadingIndicator(
                indicatorType: Indicator.ballScaleMultiple,

                /// Required, The loading type of the widget
                colors: [
                  Colors.red,
                  Colors.green,
                  Colors.yellow,
                ],

                /// Optional, The color collections
                strokeWidth: 2,

                /// Optional, The stroke of the line, only applicable to widget which contains line
                backgroundColor: Colors.transparent,

                /// Optional, Background of the widget
                pathBackgroundColor: Colors.transparent

                /// Optional, the stroke backgroundColor
                ),
          ),
          Text(
            'Caricamento...\r\n${list[index].picture?.name ?? ''}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 8),
          ),
        ],
      )),
    );
  }

  Widget imagePreview(int index) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        Expanded(
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.25,
                maxScale: 100,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.memory(
                                  selectedImages![index].picture!.bytes!,
                                  filterQuality: FilterQuality.medium,
                                  fit: BoxFit.contain)
                              .image,
                          fit: BoxFit.cover),
                    ),
                    child: ClipRRect(
                        // make sure we apply clip it properly
                        child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
                                              selectedImages![index]
                                                  .picture!
                                                  .bytes!,
                                              fit: BoxFit.cover)),
                                    ],
                                  ),
                                ))))),
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

                          if (selectedImages![index].picture!.file == null) {
                            String newPath =
                                "$tempPath\\${selectedImages![index].picture!.name}";
                            Uint8List bytes = base64Decode(
                                selectedImages![index].picture!.content!);
                            saveFile(newPath, bytes);
                            selectedImages![index] = selectedImages![index]
                                .copyWith(
                                    picture: selectedImages![index]
                                        .picture!
                                        .copyWith(
                                            file: PlatformFile(
                                                path: newPath,
                                                name: newPath,
                                                size: bytes.length,
                                                bytes: bytes)));
                          }

                          if (selectedImages![index].picture!.file != null) {
                            try {
                              open_file.OpenFile.open(
                                  selectedImages![index].picture!.file!.path!);
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
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {},
        ),
      ],
    );
  }

  void saveFile(String path, List<int> bytes) async {
    try {
      var file = File(path);
      await file.writeAsBytes(bytes, mode: FileMode.write);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /*void showImagePreview(int index) {
    double oldBackgroundOpacity =
        prefs!.getDouble(backgroundOpacitySetting) ?? 1.0;
    prefs!.setDouble(backgroundOpacitySetting, 1.0);
    eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));

    showDialog(
        context: context,
        builder: (context) {
          return imagePreview(index);
        }).then((value) {
      prefs!.setDouble(backgroundOpacitySetting, oldBackgroundOpacity);
      eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));
    });
  }*/

  Future<bool> deleteImageRequestMessage() async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Eliminazione immagine',
            message: 'Eliminare l\'immagine selezionata?',
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

  Future<String?>? encodeBase64(Uint8List bytes) {
    try {
      return compute(base64Encode, bytes);
    } catch (e) {
      print(e);
    }
    return null;
  }

  void stopCompression() {
    _idle();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
