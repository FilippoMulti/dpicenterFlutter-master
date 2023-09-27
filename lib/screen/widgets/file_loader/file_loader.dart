import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/file_global.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/helpers/mime_icon.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/media_item.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/vmc_file.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/file_loader/file_downloader.dart';
import 'package:dpicenter/screen/widgets/take_picture/take_picture_screen.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'dart:ui' as ui;
import 'package:open_file/open_file.dart' as open_file;
import 'package:universal_html/html.dart' as html;

class FileLoader extends StatefulWidget {
  final List<MediaItem>? itemFiles;
  final Function(List<MediaItem> values)? onChanged;
  final Function(List<MediaItem> values) onLoaded;
  final bool showButtons;
  final Function(MediaItem item)? onRemove;
  final bool canRemove;
  final bool canAdd;
  final bool canEdit;
  final double? width;
  final double? height;
  final bool dense;

  const FileLoader({
    Key? key,
    this.itemFiles,
    this.onChanged,
    this.showButtons = true,
    this.onRemove,
    this.canRemove = true,
    this.canAdd = true,
    this.canEdit = true,
    this.width,
    this.height,
    this.dense = false,
    required this.onLoaded,
  }) : super(key: key);

  @override
  FileLoaderState createState() => FileLoaderState();
}

class FileLoaderState extends State<FileLoader>
    with AutomaticKeepAliveClientMixin {
  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///files selezionati
  final List<MediaItem>? selectedFiles = <MediaItem>[];

  ///immagini sottoposte a compressione
  List<MediaItem>? _compressingFiles = <MediaItem>[];

  ///stato della compressione immagini
  int compressStatus = 0;

  ///immagini sottoposte a caricamento
  final List<MediaItem> _loadingImages = <MediaItem>[];

  String imageGridKeyString = "key";

  final TextEditingController _docSearchController = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 150), () {
      loadFiles();
    });

    super.initState();
  }

  @override
  void dispose() {
    _docSearchController.dispose();
    super.dispose();
  }

  Offset? _tapPosition;

  void _showCustomMenu() async {
    final RenderBox? overlay =
        Overlay.of(context)?.context?.findRenderObject() as RenderBox?;

    bool openMenu = false;
    Uint8List? imageBytes;
    List<String> clipboardFiles = await Pasteboard.files();
    for (var element in clipboardFiles) {
      debugPrint("Clipboard: $element");
    }

    if (kIsWeb) {
      openMenu = true;
    } else {
      imageBytes = await Pasteboard.image;
      if (imageBytes != null || clipboardFiles.isNotEmpty) {
        openMenu = true;
      }
    }

/*    var result = await Clipboard.getData('image/png');

    print("ShowCustomMenu");
    print("text: ${await Pasteboard.text}");
    print("html: ${await Pasteboard.html}");*/

    //imageStream.isEmpty
/*    for (String s in await Pasteboard.files()){
      print("File $s");
    }*/
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
                    } else if (clipboardFiles.isNotEmpty) {
                      for (String path in clipboardFiles) {
                        File toRead = File(path);
                        Uint8List fileBytes = await toRead.readAsBytes();
                        String name = path.split(Platform.pathSeparator).last;
                        _addFile(name, fileBytes);
                      }
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTap: _showCustomMenu,
      // This does not give the tap position ...
      onLongPress: _showCustomMenu,
      onSecondaryTapDown: _storePosition,
      // Have to remember it on tap-down.
      onTapDown: _storePosition,
      child: Column(
        children: [
          _detailFilesWidget(),
          if (widget.canAdd) _attachFiles(),
        ],
      ),
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _idle() {
    var bloc = BlocProvider.of<MediaBloc>(context);
    bloc.add(
        const MediaEvent(status: MediaEvents.idle, bytesList: <Uint8List>[]));
  }

  _addFile(String name, Uint8List bytes) async {
    //_files.removeWhere((element) => element == null);
    var bloc = BlocProvider.of<MediaBloc>(context);
    bloc.add(MediaEvent(status: MediaEvents.addFile, name: name, bytes: bytes));
  }

  loadFiles() {
    var bloc = BlocProvider.of<ServerDataBloc<Media>>(context);
    bloc.add(ServerDataEvent<Media>(
        status: ServerDataEvents.fetch,
        onEvent: (Bloc bloc, ServerDataEvent event, Emitter emit) async {
          if (widget.itemFiles != null) {
            for (MediaItem itemFile in widget.itemFiles!) {
              selectedFiles!.add(itemFile);
            }
          }

          MultiService<Media> mediasService =
              MultiService<Media>(Media.fromJsonModel, apiName: "Media");
          try {
            ///caricare le immagini effettive
            if (widget.itemFiles != null) {
              for (int index = 0; index < selectedFiles!.length; index++) {
                MediaItem itemFile = selectedFiles![index];
                if (itemFile.media == null && itemFile.mediaId != 0) {
                  ///solo file già salvato
                  QueryModel item = QueryModel(
                      id: itemFile.mediaId.toString(), downloadContent: false);
                  List<Media>? media = await mediasService.get(item);
                  if (media != null && media.isNotEmpty) {
                    var selectedFile = itemFile.copyWith(
                        media: media[
                            0] /*.copyWith(bytes: base64Decode(pic[0].content!))*/);
                    selectedFiles![index] = selectedFile;
                    emit(ServerDataAdded<Media>(event: event, item: media[0]));
                  }
                }
              }
            }
            emit(ServerDataLoaded<Media>(event: event));
            widget.onLoaded.call(selectedFiles!);
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          } finally {}
        }));
  }

  Future<List<Media>?> openFileDialog(BuildContext context, Media media) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return multiDialog(
              content: BlocProvider<ServerDataBloc<Media>>(
                  lazy: false,
                  create: (context) => ServerDataBloc<Media>(
                      repo: MultiService<Media>(Media.fromJsonModel,
                          apiName: 'Media')),
                  child: MediaDownloader(
                    mediaToDownload: media,
                  )));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  _compressFile(FilePickerResult? filesPicked) async {
    if (filesPicked != null) {
      //_files.removeWhere((element) => element == null);
      var bloc = BlocProvider.of<MediaBloc>(context);
      bloc.add(MediaEvent(
          status: MediaEvents.compressList,
          fileList: <FilePickerResult>[filesPicked]));
    }
  }

  Widget _attachFiles() {
    return BlocBuilder<MediaBloc, MediaState>(
        builder: (BuildContext context, MediaState state) {
      List<Widget> children = <Widget>[];
      if (state is MediaError) {
        for (var element in state.compressedFilesStatus!) {
          children.add(Text(element));
        }
      }
      switch (state.event!.status) {
        case MediaEvents.compressList:
          if (state is MediaInitState) {}
          if (state is MediaCompressStarted) {
            children.add(addStopButton());
          }
          if (state is MediaCompressed) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
            children.add(addStopButton());
          }
          if (state is MediaCompressedError) {
            for (var element in state.compressedFilesStatus!) {
              children.add(Text(element));
            }
          }
          if (state is MediaCompressCompleted) {
            /*  for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/
          }
          if (state is MediaEndState) {
            /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/
            if (widget.showButtons) {
              children.add(addFilesButton());
            }
          }
          break;
        case MediaEvents.idle:
          if (widget.showButtons) {
            children.add(addFilesButton());
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

  Widget _detailFilesWidget() {
    return BlocListener<ServerDataBloc<Media>, ServerDataState>(
        listener: (BuildContext context, ServerDataState state) {
      if (state.event is ServerDataLoadedCompleted) {}
    }, child: BlocBuilder<ServerDataBloc<Media>, ServerDataState>(
            builder: (BuildContext context, ServerDataState state) {
      print(state.toString());
      if (state is ServerDataLoaded) {
        return _detailFilesWidgetBloc();
      }
      return Column(
        children: [
          Center(
              child: SizedBox(height: 50, child: shimmerComboLoading(context))),
          const Center(
            child: SizedBox(
                height: 50, child: Text("Caricamento files in corso...")),
          ),
          _detailFilesWidgetBloc(),
        ],
      );
    }));
  }

  Widget _detailFilesWidgetBloc() {
    return BlocListener<MediaBloc, MediaState>(
        listener: (BuildContext context, MediaState state) {
      if (state.event!.status == MediaEvents.idle) {
        _compressingFiles = null;
        compressStatus = 0;
      } else {
        if (state is MediaCompressStarted) {
          _compressingFiles = state.medias
              .map((e) => MediaItem(
                  mediaItemId: 0,
                  compressionId: e.compressionId,
                  parentId: 0,
                  mediaId: e.mediaId ?? 0,
                  media: e))
              .toList();
          compressStatus = 1;
        }

        if (state is MediaCompressed) {
          _compressingFiles?.removeWhere((element) =>
              element.compressionId == state.media!.compressionId!);
          selectedFiles?.add(MediaItem(
              mediaItemId: 0,
              parentId: 0,
              compressionId: state.media?.compressionId ?? 0,
              mediaId: state.media?.mediaId ?? 0,
              media: state.media));
          widget.onChanged?.call(selectedFiles!);
        }

        if (state is MediaAddCompleted) {
          selectedFiles?.add(MediaItem(
              mediaItemId: 0,
              parentId: 0,
              compressionId: 0,
              mediaId: state.medias.first.mediaId ?? 0,
              media: state.medias.first));
          widget.onChanged?.call(selectedFiles!);
        }

        if (state is MediaCompressCompleted) {
          _compressingFiles =
              null; //state.images.map((e) => ItemPicture(itemPictureId: 0, itemId: 0, pictureId: 0, picture: e)).toList();

          compressStatus = 0;

          widget.onChanged?.call(selectedFiles!);
        }
      }
    }, child: BlocBuilder<MediaBloc, MediaState>(
            builder: (BuildContext context, MediaState state) {
      if (state is MediaError) {
        return Text("error: ${state.error}");
      }
      switch (state.event!.status) {
        case MediaEvents.compressList:
        case MediaEvents.addFile:
          if (state is MediaInitState) {}
          if (state is MediaCompressStarted) {}
          if (state is MediaCompressed) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
          }
          if (state is MediaCompressedError) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
          }
          if (state is MediaCompressCompleted) {
            /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/
          }
          if (state is MediaEndState) {
            /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/
          }
          if (selectedFiles != null && selectedFiles!.isNotEmpty ||
              _compressingFiles != null && _compressingFiles!.isNotEmpty) {
            return fileGrid();
          }

          break;

        case MediaEvents.idle:
          //children.add(addImagesButton());

          break;
        default:
          break;
      }
      if (selectedFiles != null && selectedFiles!.isNotEmpty) {
        return fileGrid();
      }
      return const SizedBox();
    }));
  }

  Widget _searchField() {
    return SizedBox(
        width: 200,
        child: TextField(
          controller: _docSearchController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            labelText: 'Cerca tra i documenti',
            hintText: 'Cerca',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _docSearchController.text = "";
                  });
                }),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ));
  }

  Widget fileGrid() {
    List<Widget> children = <Widget>[];
    var grid = _buildFilesGrid(imageGridKeyString);

    var container = AnimatedContainer(
        constraints: BoxConstraints(
            maxHeight: widget.height ?? double.infinity,
            maxWidth: widget.width ?? double.infinity),
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: isDarkTheme(context)
                    ? Colors.grey
                    : Theme.of(context).textTheme.bodySmall!.color!)),
        child: Center(child: grid));

    Padding padding = Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
        child: container);

    Padding padding2 = Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
        child: _searchField());
    children.add(padding2);
    children.add(padding);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget addFilesButton() {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.any,
              allowMultiple: true,
            );
            if (result != null) {
              /*       setState(() {
                imageGridKeyString=Random().nextInt(1000000).toString();
              });*/
              editState = true;
              await _compressFile(result);
            }
          },
          child: const Text("Aggiungi file")),
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
  Widget _buildFilesGrid(String key) {
    return AnimationLimiter(
        key: ValueKey(key),
        child: Container(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildGridFilesList(),
            ),
          ),
        ));
  }

  List<Widget> _buildGridFilesList([double size = 128]) {
    String searchText = _docSearchController.text.toLowerCase();

    List<Widget> filesChildren = [];
    for (int index = 0; index < (selectedFiles?.length ?? 0); index++) {
      if (searchText.isEmpty ||
          (selectedFiles![index]
                  .description
                  ?.toLowerCase()
                  .contains(searchText) ??
              false) ||
          (selectedFiles![index]
                  .media
                  ?.name
                  .toLowerCase()
                  .contains(searchText) ??
              false)) {
        filesChildren.add(fileContainer(
            selectedFiles!, index, size, selectedFiles![index].mediaId != -1));
        filesChildren.add(const Divider());
      }
    }

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
          ...filesChildren,

          ///nel caso voglia comprimere i file
          ...List.generate(_compressingFiles?.length ?? 0, (int i) {
            return fileContainer(_compressingFiles!, i, size,
                _compressingFiles![i].mediaId != -1);
          }),
        ]);
  }

  ///action: 0 - open / 1 - save
  Future openSaveFileRequest(int index, {int action = 0}) async {
    String? fileSelected;

    bool? res;
    switch (action) {
      case 0:
        res = await openMediaRequestMessage(selectedFiles![index].media!.name,
            action: action);
        break;
      case 1:
        fileSelected = await FilePicker.platform.saveFile(
            type: FileType.any, fileName: selectedFiles?[index].media?.name);
        if (fileSelected != null) {
          res = true;
        }
        break;
    }

    if (mounted && res != null && res) {
      List<Media>? result = [selectedFiles![index].media!];

      ///se bytes è null vuol dire che il file è ricevuto dal server, altrimenti è stato selezionato con un picker
      if (selectedFiles![index].media?.bytes == null &&
          selectedFiles![index].media!.content == null) {
        result = await openFileDialog(context, selectedFiles![index].media!);
        selectedFiles![index] =
            selectedFiles![index].copyWith(media: result![0]);
      }

      if (!kIsWeb) {
        ///solo piattiaforme native -> path_provider non funziona sul web
        switch (action) {
          case 0:

            ///apri
            MediaItem? newFile =
                await _getMediaItemWithNewPath(selectedFiles![index]);
            if (newFile != null) {
              selectedFiles![index] = newFile; //.copyWith(file: result);
            }
            if (selectedFiles![index].media!.file != null) {
              try {
                openFile(selectedFiles![index].media!, withMessage: false);
              } catch (e) {
                print("Errore Apri: $e");
              }
            }
            break;
          case 1:

            ///salva

            if (fileSelected != null) {
              MediaItem? newFile =
                  await _saveAndGetVmcFile(selectedFiles![index], fileSelected);
              if (newFile != null) {
                selectedFiles![index] = newFile; //.copyWith(file: result);
              }
            } else {
              return;
            }
            break;
        }
      } else {
        openFile(
          selectedFiles![index].media!,
          withMessage: false,
        );
      }
    }
  }

  Widget fileContainer(
      List<MediaItem> list, int index, double size, bool visible) {
    return list[index].media?.name != null
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: visible ? null : 0,
            height: visible ? null : 0,
            child: visible
                ? ListTile(
                    dense: widget.dense,
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    //contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: -4),
                    minVerticalPadding: 0,
                    horizontalTitleGap: 0,
                    leading: MimeTypeIcon(
                        filename: list[index].media?.name ?? '',
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    title: Text(
                      list[index].media?.name ?? '',
                    ),
                    subtitle: Text(
                      list[index].description ?? '',
                    ),
                    onTap: () async {
                      await openSaveFileRequest(index);
                    },
                    trailing: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton(
                            tooltip: 'Opzioni',
                            constraints: const BoxConstraints(maxWidth: 1500),
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuItem>[
                                PopupMenuItem(
                                    child: const Text("Apri"),
                                    onTap: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                        (_) async {
                                          await openSaveFileRequest(index);
                                        },
                                      );
                                    }),
                                if (isWindows || isLinux)
                                  PopupMenuItem(
                                      child: const Text("Salva"),
                                      onTap: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (_) async {
                                            await openSaveFileRequest(index,
                                                action: 1);
                                          },
                                        );
                                      }),
                                if (widget.canEdit)
                                  PopupMenuItem(
                                    child: const Text("Modifica descrizione"),
                                    onTap: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                        (_) {
                                          editDescription(
                                              list[index].description,
                                              (String? result) {
                                            if (result != null) {
                                              setState(() {
                                                editState = true;
                                                //imageGridKeyString=Random().nextInt(1000000).toString();
                                                list[index] = list[index]
                                                    .copyWith(
                                                        description: result);
                                                widget.onChanged
                                                    ?.call(selectedFiles!);
                                                //list.remove(list[index]);
                                              });
                                            }
                                          });
                                        },
                                      );
                                    },
                                  )
                              ];
                            },

                            /*=> List.generate(
                widget.itemConfiguration.notes.length,
                      (index) => PopupMenuItem(
                  value: index,
                  child: Note.fromSampleItemNote(
                        widget.itemConfiguration.notes[index],
                        context),
                ),
              ),*/
                          ),
                          if (widget.canRemove || widget.onRemove != null)
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () async {
                                widget.onRemove?.call(list[index]);
                                if (widget.canRemove) {
                                  if (await deleteMediaRequestMessage()) {
                                    setState(() {
                                      editState = true;
                                      //imageGridKeyString=Random().nextInt(1000000).toString();
                                      list[index] =
                                          list[index].copyWith(mediaId: -1);
                                      widget.onChanged?.call(selectedFiles!);
                                      //list.remove(list[index]);
                                    });
                                  }
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  )
                : null,
          )
        : list[index].media?.file != null
            ? mediaCompressionWidget(list, index)
            : mediaLoadingWidget(list, index);
  }

  Future<MediaItem?> _getMediaItemWithNewPath(MediaItem mediaItem) async {
    var tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    if (mediaItem.media?.file == null) {
      String newPath =
          "$tempPath${Platform.pathSeparator}${mediaItem.media!.name}";
      Uint8List bytes = mediaItem.media!.bytes != null
          ? mediaItem.media!.bytes!
          : base64Decode(mediaItem.media!.content!);
      saveFile(newPath, bytes);
      return mediaItem.copyWith(
          media: mediaItem.media!.copyWith(
              file: PlatformFile(
                  path: newPath,
                  name: newPath,
                  size: bytes.length,
                  bytes: bytes)));
    }
    return null;
  }

  Future<MediaItem?> _saveAndGetVmcFile(
      MediaItem mediaItem, String pathToSave) async {
    if (mediaItem.media?.file == null) {
      Uint8List bytes = base64Decode(mediaItem.media!.content!);
      saveFile(pathToSave, bytes);
      return mediaItem.copyWith(
          media: mediaItem.media!.copyWith(
              file: PlatformFile(
                  path: pathToSave,
                  name: pathToSave,
                  size: bytes.length,
                  bytes: bytes)));
    }
    return null;
  }

  editDescription(String? initialValue, Function(String?) onResult) async {
    String? result = await displayTextInputDialog(
        context: context,
        title: 'Inserisci descrizione',
        initialValue: initialValue ?? '');
    onResult.call(result);
  }

  openFile(Media file, {bool withMessage = true}) async {
    bool toOpen = false;

    if (withMessage) {
      bool? res = await openMediaRequestMessage(file.name);

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
      {Uint8List? bytes, bool withMessage = true}) async {
    bool toOpen = false;

    if (withMessage) {
      bool? res = await openMediaRequestMessage(filepath);

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

  void webDownload(String filename, Uint8List bytes) {
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

  Widget mediaCompressionWidget(List list, int index) {
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
            "Compressione...\r\n${list[index].file?.file?.name ?? ''}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 8),
          ),
        ],
      )),
    );
  }

  Widget mediaLoadingWidget(List<MediaItem> list, int index) {
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
            'Caricamento...\r\n${list[index].media?.name ?? ''}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 8),
          ),
        ],
      )),
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

  Future<bool?> openMediaRequestMessage(String mediaName,
      {int action = 0}) async {
    String title = "Aprire il file";
    String message = 'Aprire il file selezionato ($mediaName)?';

    switch (action) {
      case 1:
        title = "Salvare il file";
        message = "Salvare il file selezionato ($mediaName)?";
        break;
    }
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: title,
            message: message,
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

  Future<bool> deleteMediaRequestMessage() async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Eliminazione file',
            message: 'Eliminare il file selezionato?',
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
