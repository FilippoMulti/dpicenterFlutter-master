import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
//import 'package:audioplayers/audioplayers.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';

//import 'package:dpicenter/dummy/dummy_serialport.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/file_global.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/connected_client_info.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/item_category.dart';
import 'package:dpicenter/models/server/item_physics_configuration.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/autogeneration/edit_item.dart';
import 'package:dpicenter/screen/connected_clients/connected_clients_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/dialog_header.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list.dart';
import 'package:dpicenter/screen/widgets/image_loader/image_loader.dart';
import 'package:dpicenter/screen/widgets/take_picture/take_picture_screen.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dpicenter/theme_manager/theme_color.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_spinbox/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:universal_io/io.dart';
//import 'package:universal_io/io.dart';

// Define a custom Form widget.
class ItemEditForm extends StatefulWidget {
  final Item? element;
  final String? title;
  final Function(Item?)? onSave;

  const ItemEditForm(
      {Key? key, required this.element, required this.title, this.onSave})
      : super(key: key);

  @override
  ItemEditFormState createState() => ItemEditFormState();
}

class ItemEditFormState extends State<ItemEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;

  String? deviceConnected;

  ///gestione pannelli
  bool _physicsPanelIsExpanded = true;

  ///default expanded

  ///immagini selezionate
  final List<ItemPicture>? selectedImages = <ItemPicture>[];

  ///immagini sottoposte a compressione
  List<ItemPicture>? _compressingImages = <ItemPicture>[];

  ///immagini sottoposte a caricamento
  final List<ItemPicture> _loadingImages = <ItemPicture>[];

  ///lista delle categorie tra cui selezionare
  List<ItemCategory>? categories = <ItemCategory>[];

  ///categoria selezionato
  ItemCategory? selectedItemCategory;

  ///stato della compressione immagini
  int compressStatus = 0;

  late TextEditingController codeController;
  late TextEditingController descriptionController;
  late TextEditingController barcodeController;
  late TextEditingController _searchCategoryController;

  double widthValue = 0;
  double heightValue = 0;
  double depthValue = 0;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");
  Item? element;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');

  final FocusNode _codeFocusNode = FocusNode(debugLabel: '_codeFocusNode');
  final FocusNode _descriptionFocusNode =
      FocusNode(debugLabel: '_descriptionFocusNode');
  final FocusNode _barcodeFocusNode =
      FocusNode(debugLabel: '_barcodeFocusNode');
  final FocusNode _categoriesFocusNode =
      FocusNode(debugLabel: '_categoriesFocusNode');

  final FocusNode _widthFocusNode = FocusNode(debugLabel: '_widthFocusNode');
  final FocusNode _heightFocusNode = FocusNode(debugLabel: '_heightFocusNode');
  final FocusNode _depthFocusNode = FocusNode(debugLabel: '_depthFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _codeKey = GlobalKey(debugLabel: '_codeKey');
  final GlobalKey _descriptionKey = GlobalKey(debugLabel: '_descriptionKey');
  final GlobalKey _barcodeKey = GlobalKey(debugLabel: '_barcodeKey');
  final GlobalKey _categoriesKey = GlobalKey(debugLabel: '_categoriesKey');
  final GlobalKey _widthKey = GlobalKey(debugLabel: '_widthKey');
  final GlobalKey _heightKey = GlobalKey(debugLabel: '_heightKey');
  final GlobalKey _depthKey = GlobalKey(debugLabel: '_depthKey');

  final GlobalKey<EditItemState> _editItemKey =
      GlobalKey<EditItemState>(debugLabel: '_editItemKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  String imageGridKeyString = "key";

  //SerialPortReader? reader;

  @override
  void initState() {
    super.initState();
    _connectToMessageHub();
    initKeys();
    element = widget.element;

    //debugPrint(availablePorts.length.toString());
//check here that your device exists
    eventBus.on<SerialMessageEvent>().listen((event) {
      setState(() {
        barcodeController.value =
            barcodeController.value.copyWith(text: utf8.decode(event.newEvent));
      });
    });

    /*if (isDesktop) {
      var availablePorts = SerialPort.availablePorts;
      SerialPort? port;
      if (availablePorts.isNotEmpty) {
        port = SerialPort(availablePorts.last);
        port.openRead();
      }
      if (port == null) {
        debugPrint("port is null");
      } else if (!port.isOpen && !port.openRead()) {
        debugPrint(SerialPort.lastError.toString());
      } else {
        //port.write(Uint8List.fromList("MY_COMMAND".codeUnits));
        if (!kIsWeb) {
          reader = SerialPortReader(port);
          reader?.stream.listen((data) {
            debugPrint('received: ${utf8.decode(data)}');
            setState(() {
              barcodeController.value =
                  barcodeController.value.copyWith(text: utf8.decode(data));
            });
          });
        }
      }
    } else {
      debugPrint("mobile platform, serialport not needed");
    }*/

    _searchCategoryController = TextEditingController();

    if (element != null) {
      codeController = TextEditingController(text: element!.code);
      descriptionController = TextEditingController(text: element!.description);
      barcodeController = TextEditingController(text: element!.barcode);

      selectedItemCategory = element!.itemCategory;

      heightValue = element!.physicsConfiguration?.heightMm ?? 0;
      widthValue = element!.physicsConfiguration?.widthMm ?? 0;
      depthValue = element!.physicsConfiguration?.depthMm ?? 0;
    } else {
      codeController = TextEditingController();
      descriptionController = TextEditingController();
      barcodeController = TextEditingController();
    }

    Future.delayed(const Duration(milliseconds: 150), () {
      _loadCategories();
    });
/*
    Future.delayed(const Duration(milliseconds: 150), () {
      _loadImages();
    });
*/

/*    Future.delayed(const Duration(milliseconds: 150), () {
      _loadImages();
    });*/
  }

  _loadCategories() {
    var bloc = BlocProvider.of<ServerDataBloc<ItemCategory>>(context);
    bloc.add(
        const ServerDataEvent<ItemCategory>(status: ServerDataEvents.fetch));
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
          if (element != null) {
            for (ItemPicture itemPicture in element!.itemPictures!) {
              selectedImages!.add(itemPicture);
            }

            MultiService<Media> picturesService =
                MultiService<Media>(Media.fromJsonModel, apiName: "Media");
            try {
              if (element != null) {
                ///caricare le immagini effettive
                if (element!.itemPictures != null) {
                  for (int index = 0; index < selectedImages!.length; index++) {
                    ItemPicture itemPicture = selectedImages![index];
                    if (itemPicture.mediaId != 0) {
                      ///solo immagini già salvate
                      QueryModel item =
                          QueryModel(id: itemPicture.mediaId.toString());
                      List<Media>? pic = await picturesService.get(item);
                      if (pic != null && pic.isNotEmpty) {
                        var selectedImage = itemPicture.copyWith(
                            picture: pic[0].copyWith(
                                bytes: base64Decode(pic[0].content!)));
                        selectedImages![index] = selectedImage;
                        emit(
                            ServerDataAdded<Media>(event: event, item: pic[0]));
                      }
                    }
                  }
                }
                emit(ServerDataLoaded<Media>(event: event));
              } else {
                emit(ServerDataLoaded<Media>(event: event));
              }
            } catch (e) {
              print(e);
            } finally {}
          } else {
            emit(ServerDataLoaded<Media>(event: event));
          }
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
            children.add(addImagesButton());
            if (cameras != null && cameras!.isNotEmpty) {
              children.add(const SizedBox(
                height: 16.0,
              ));
              children.add(takePictureButton());
            }
          }
          break;
        case PictureEvents.idle:
          children.add(addImagesButton());
          if (cameras != null && cameras!.isNotEmpty) {
            children.add(const SizedBox(
              height: 16.0,
            ));
            children.add(takePictureButton());
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
        }
        if (state is PictureCompressCompleted) {
          _compressingImages =
              null; //state.images.map((e) => ItemPicture(itemPictureId: 0, itemId: 0, pictureId: 0, picture: e)).toList();

          compressStatus = 0;
        }
      }
    }, child: BlocBuilder<PictureBloc, PictureState>(
            builder: (BuildContext context, PictureState state) {
      if (state is PictureError) {
        return Text("error: ${state.error}");
      }
      switch (state.event!.status) {
        case PictureEvents.compressList:
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

  Widget imageGrid() {
    List<Widget> children = <Widget>[];
    var grid = _buildImagesGrid(imageGridKeyString);

    var container = AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: isDarkTheme(context)
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
                  ThemeModeHandler.of(context)!.themeColor.backgroundOpacity;
              ThemeColor tc = ThemeModeHandler.of(context)!.themeColor;
              ThemeModeHandler.of(context)!.saveThemeMode(
                  ThemeModeHandler.of(context)!.themeMode,
                  tc.copyWith(backgroundOpacity: 1.0));

              /*               prefs!.getDouble(backgroundOpacitySetting) ?? 1.0;
              prefs!.setDouble(backgroundOpacitySetting, 1.0);
              eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));*/

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
                ThemeColor tc = ThemeModeHandler.of(context)!.themeColor;
                ThemeModeHandler.of(context)!.saveThemeMode(
                    ThemeModeHandler.of(context)!.themeMode,
                    tc.copyWith(backgroundOpacity: oldBackgroundOpacity));
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
                                      filterQuality: FilterQuality.medium)
                                  .image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              /*Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return imagePreview(i);
                                    }));*/
                              showImagePreview(index);
                            },
                          ),
                        )
                      : list[index].picture?.file != null
                          ? imageCompressionWidget(list, index)
                          : imageLoadingWidget(list, index)),
              if (list[index].picture?.bytes != null)
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
    return Stack(
      children: [
        InteractiveViewer(
          minScale: 0.25,
          maxScale: 100,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.memory(selectedImages![index].picture!.bytes!,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.medium)
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
                                        selectedImages![index].picture!.bytes!,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.medium)),
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
                      selectedImages![index] = selectedImages![index].copyWith(
                          picture: selectedImages![index].picture!.copyWith(
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

  void showImagePreview(int index) {
    double oldBackgroundOpacity =
        ThemeModeHandler.of(context)!.themeColor.backgroundOpacity;
    ThemeColor tc = ThemeModeHandler.of(context)!.themeColor;
    ThemeModeHandler.of(context)!.saveThemeMode(
        ThemeModeHandler.of(context)!.themeMode,
        tc.copyWith(backgroundOpacity: 1.0));

/*
    double oldBackgroundOpacity =
        prefs!.getDouble(backgroundOpacitySetting) ?? 1.0;
    prefs!.setDouble(backgroundOpacitySetting, 1.0);
    eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));
*/

    showDialog(
        context: context,
        builder: (context) {
          return imagePreview(index);
        }).then((value) {
      /*prefs!.setDouble(backgroundOpacitySetting, oldBackgroundOpacity);
      eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));*/
      ThemeModeHandler.of(context)!.saveThemeMode(
          ThemeModeHandler.of(context)!.themeMode,
          tc.copyWith(backgroundOpacity: oldBackgroundOpacity));
    });
  }

  /*
    _compressFiles(List<FilePickerCross> filesPicked) async {
    List<File?> _files =
        filesPicked.map((e) => e.path != null ? File(e.path!) : null).toList();
    */ /* var _files = <File>[];
    for (var element in filesPicked){
      if ( await element.saveToPath(path: '/my/path/${element.path}')){
        _files.add(File('/my/path/${element.path}'));
      }
    }*/ /*

    _files.removeWhere((element) => element == null);
    var bloc = BlocProvider.of<ImageGalleryBloc>(context);
   */ /* bloc.add(ImageGalleryEvent(
        status: ImageGalleryEvents.compressList, fileList: _files, bytesList: <Uint8List>[]));*/ /*
  }*/

  @override
  void dispose() {
    descriptionController.dispose();
    codeController.dispose();
    eventBusSubscription?.cancel();
    _saveFocusNode.dispose();
    _codeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _scrollController.dispose();
    /*try {
      reader?.close();
      reader?.port.close();
    } catch (e) {
      debugPrint(e.toString());
    }*/
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _codeKey),
      KeyValidationState(key: _descriptionKey),
      KeyValidationState(key: _barcodeKey),
      KeyValidationState(key: _categoriesKey),
      KeyValidationState(key: _widthKey),
      KeyValidationState(key: _heightKey),
      KeyValidationState(key: _depthKey),
    ];
  }

  InputDecoration _codeInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Codice', hintText: 'Inserisci il codice dell\'articolo');
  }

  InputDecoration _descriptionInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Descrizione',
        hintText: 'Inserisci la descrizione dell\'articolo');
  }

  InputDecoration _barcodeInputDecoration() {
    return InputDecoration(
        //enabledBorder: OutlineInputBorder(),
        border: const OutlineInputBorder(),
        labelText: 'Codice a barre / QR CODE',
        hintText: 'Inserisci o leggi codice a barre dell\'articolo',
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () async {
                  if (isMobile) {
                    scanCodeWithCamera2();
                  } else {
                    if (deviceConnected == null) {
                      var result = await openConnectedClients(context,
                          userFilter:
                              ApplicationUser.getUserFromSetting()?.userName ??
                                  '',
                          openType: ConnectedClientsScreenOpenType.select);
                      if (result != null && result is ConnectedClientInfo) {
                        setState(() {
                          deviceConnected = result.sessionId;
                          sendCommandToUser(messageHub, "ScanRequest",
                              deviceConnected!, "item_edit_screen");
                        });
                      }
                    } else {
                      sendCommandToUser(messageHub, "ScanRequest",
                          deviceConnected!, "item_edit_screen");
                    }
                  }
                },
                icon: const Icon(
                  Icons.qr_code,
                  size: 16,
                )),
            if (deviceConnected != null) const SizedBox(width: 8),
            if (deviceConnected != null)
              IconButton(
                  tooltip: 'Disconnetti',
                  onPressed: () async {
                    await showMessage(context,
                        title: 'Disconnessione dispositivo',
                        message: 'Disconnettersi dal dispositivo',
                        type: MessageDialogType.yesNo, okPressed: () {
                      setState(() {
                        deviceConnected = null;
                        Navigator.of(context).pop(true);
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.phonelink_erase,
                    size: 16,
                  )),
            if (deviceConnected != null) const SizedBox(width: 8),
          ],
        ));
  }

  InputDecoration _widthInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Largezza in millimetri',
        hintText: 'Inserisci la larghezza del prodotto in millimetri');
  }

  InputDecoration _heightInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Altezza in millimetri',
        hintText: 'Inserisci l\'altezza  del prodotto in millimetri');
  }

  InputDecoration _depthInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Profondità in millimetri',
        hintText: 'Inserisci la profondità in millimetri');
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return FocusScope(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width > 1000 ? 900 : 500,
                  child: Column(
                    children: [
                      DialogTitle(widget.title!),

                      Expanded(
                        child: EditItem(
                          key: _editItemKey,
                          item: element,
                          scrollController: _scrollController,
                          itemConfiguration: element?.physicsConfiguration,
                          itemPictures: element?.itemPictures,
                          onSave: (value) {
                            editState = true;
                          },
                          textInputSettingsTileChildren: [
                            _codeSettingTile(),
                            _descriptionSettingTile(),
                            _barcodeSettingTile(),
                            _categoriesSettingTile(),
                          ],
                        ),
                      ),

                      //_physicsPanel(),
                      /*ImageLoader(
                        itemPictures: element?.itemPictures!,
                        onChanged: (values) {
                          selectedImages?.clear();
                          for (var item in values) {
                            selectedImages?.add(item);
                          }
                        }),*/
                      /*           _detailImagesWidget(),
                    _attachImages(),*/
                      /*_testButton(),*/
                      const SizedBox(height: 20),
                    ],
                  ),
                )),
          ),
          OkCancel(
              okFocusNode: _saveFocusNode,
              onCancel: () async {
                if (compressStatus == 1) {
                  if (await stopCompressionMessage()) {
                    await _idle();
                  } else {
                    return;
                  }
                }
                if (mounted) {
                  Navigator.maybePop(context, null);
                }
              },
              onSave: () async {
                if (compressStatus == 1) {
                  if (await stopCompressionMessage()) {
                    await _idle();
                  } else {
                    return;
                  }
                }
                validateSave();
              })
        ],
      ),
    );
  }

  SettingsTile _codeSettingTile() {
    return getCustomSettingTile(
        key: _codeKey,
        title: 'Inserisci codice',
        hint: 'Codice',
        description: 'Codice identificativo articolo',
        child: _codeField());
  }

  SettingsTile _descriptionSettingTile() {
    return getCustomSettingTile(
        key: _descriptionKey,
        title: 'Inserisci descrizione',
        hint: 'Descrizione',
        description: 'Descrizione articolo',
        child: _descriptionField());
  }

  SettingsTile _barcodeSettingTile() {
    return getCustomSettingTile(
        key: _barcodeKey,
        title: 'Inserisci barcode',
        hint: 'Codice a barre',
        description: 'Codice a barre o QR Code del prodotto',
        child: _barcodeField());
  }

  SettingsTile _categoriesSettingTile() {
    return getCustomSettingTile(
        key: _categoriesKey,
        title: 'Seleziona categoria',
        hint: 'Categoria articolo',
        description: 'Associa una categoria all\'articolo',
        child: _categoriesDropDown());
  }

  /* @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return FocusScope(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width > 1000 ? 900 : 500,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DialogTitle(widget.title!),
                        _codeField(),
                        _descriptionField(),
                        _barcodeField(),
                        _categoriesDropDown(),
                        Expanded(
                          child: EditItem(
                            key: _editItemKey,
                            item: element,
                            itemConfiguration: element?.physicsConfiguration,
                            itemPictures: element?.itemPictures,

                          ),
                        ),
                        //_physicsPanel(),
                        */ /*ImageLoader(
                            itemPictures: element?.itemPictures!,
                            onChanged: (values) {
                              selectedImages?.clear();
                              for (var item in values) {
                                selectedImages?.add(item);
                              }
                            }),*/ /*
                        */ /*           _detailImagesWidget(),
                        _attachImages(),*/ /*
                        */ /*_testButton(),*/ /*
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )),
          ),
          OkCancel(
              okFocusNode: _saveFocusNode,
              onCancel: () async {
                if (compressStatus == 1) {
                  if (await stopCompressionMessage()) {
                    await _idle();
                  } else {
                    return;
                  }
                }
                Navigator.maybePop(context, null);
              },
              onSave: () async {
                if (compressStatus == 1) {
                  if (await stopCompressionMessage()) {
                    await _idle();
                  } else {
                    return;
                  }
                }
                validateSave();
              })
        ],
      ),
    );
  }*/

  Widget _testButton() {
    return ElevatedButton(
        onPressed: () async {
          try {
            eventBus.fire(SignalREvent(message: ['Bob', 'Says hi!']));
            //await eventBus.fire(event)!.invoke("SendMessage", args: ['Bob', 'Says hi!']);
          } catch (e) {
            print(e);
          }
        },
        child: const Text("TEST SIGNALR SEND MESSAGE"));
  }

  Widget _codeField() {
    return Padding(
      padding: getPadding(),
      child: TextFormField(
        focusNode: _codeFocusNode,
        maxLines: null,
        //autofocus: isDesktop ? true : false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: codeController,
        maxLength: 50,
        onChanged: (value) => editState = true,
        decoration: _codeInputDecoration(),
        validator: (str) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == _codeKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
      ),
    );
  }

  void scanCodeWithCamera2() async {
    var result = await BarcodeScanner.scan();
    if (result.type != ResultType.Cancelled) {
      //player?.play(AssetSource("audio/beep_08b.mp3"));
      setState(() {
        barcodeController.value =
            barcodeController.value.copyWith(text: result.rawContent);
      });
      debugPrint(result.type
          .toString()); // The result type (barcode, cancelled, failed)
      debugPrint(result.rawContent); // The barcode content
      debugPrint(result.format.toString()); // The barcode format (as enum)
      debugPrint(result.formatNote); //
    } else {
      //player?.play(AssetSource("audio/se_non_bestemmio.mp3"));
      debugPrint("scan cancelled");
    }
  }

  void scanCodeWithCamera() async {
    showDialog(
        context: context,
        builder: (context) {
          return MobileScanner(
              //allowDuplicates: false,
              onDetect: (barcode) {
            final String? code = barcode.barcodes[0].rawValue;
            if (code != null) {
              debugPrint('Barcode found! $code');
            } else {
              debugPrint('Barcode not found!');
            }
          });
        });

/*    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        COLOR_CODE,
        CANCEL_BUTTON_TEXT,
        isShowFlashIcon,
        scanMode);*/
  }

  Widget _descriptionField() {
    return Padding(
      padding: getPadding(),
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: descriptionController,
        textInputAction: TextInputAction.next,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _descriptionInputDecoration(),
        validator: (str) {
          KeyValidationState state = _keyStates
              .firstWhere((element) => element.key == _descriptionKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        /*onFieldSubmitted: (str) {
          _saveFocusNode.requestFocus();
        },*/
      ),
    );
  }

  Widget _barcodeField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: _barcodeFocusNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: barcodeController,
              textInputAction: TextInputAction.next,
              maxLength: 500,
              onChanged: (value) => editState = true,
              decoration: _barcodeInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _barcodeKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
              /*onFieldSubmitted: (str) {
                _saveFocusNode.requestFocus();
              },*/
            ),
          ),
          /* //if (isMobile)
            const SizedBox(width: 8),
          //if (isMobile)
            SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (isMobile) {
                    scanCodeWithCamera2();
                  } else {

                    if (deviceConnected==null){
                     var result = await openConnectedClients(context, userFilter: ApplicationUser.getUserFromSetting()?.userName ?? '', openType: ConnectedClientsScreenOpenType.select);
                     if (result!=null && result is ConnectedClientInfo){
                       setState(() {
                         deviceConnected=result.sessionId;
                         sendCommandToUser(messageHub, "ScanRequest", deviceConnected!, "Scan request");
                       });
                     }
                    } else {
                      sendCommandToUser(messageHub, "ScanRequest", deviceConnected!, "Scan request");
                    }
                  }
                },
                child: const Text("..."),
              ),
            ),
          if (deviceConnected!=null)
            const SizedBox(width: 8),
          if (deviceConnected!=null)
            SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    deviceConnected=null;
                  });


                },
                child: const Text("/"),
              ),
            )*/
        ],
      ),
    );
  }

  Widget _categoriesDropDown() {
    return BlocBuilder<ServerDataBloc<ItemCategory>,
            ServerDataState<ItemCategory>>(
        builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            categories = state.items as List<ItemCategory>;

            return Padding(
              padding: getPadding(),
              child: DropdownSearch<ItemCategory>(
/*                focusNode:
                    isWindows || isWindowsBrowser ? null : _categoriesFocusNode,*/
                enabled: true,
                //isEnabled(),
                popupProps: PopupProps.dialog(
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  dialogProps: DialogProps(
                      backgroundColor: getAppBackgroundColor(context)),
                  showSelectedItems: true,
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      autofocus: isWindows || isWindowsBrowser ? true : false,
                      //controller: _searchCategoryController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  emptyBuilder: (context, searchEntry) =>
                      const Center(child: Text('Nessun risultato')),
                ),
                //popupBackgroundColor: getAppBackgroundColor(context),

                compareFn: (item, selectedItem) =>
                    item.itemCategoryId == selectedItem.itemCategoryId,
                //showClearButton: true,
                clearButtonProps: const ClearButtonProps(isVisible: true),
                itemAsString: (ItemCategory? c) => c!.description,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectedItem: selectedItemCategory,
                onChanged: (ItemCategory? newValue) {
                  editState = true;
                  setState(() {
                    selectedItemCategory = newValue;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Categoria',
                    hintText: 'Seleziona una categoria',
                  ),
                ),
                validator: (item) {
                  if (item == null) {
                    KeyValidationState state = _keyStates
                        .firstWhere((element) => element.key == _categoriesKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: false);
                    return "Campo obbligatorio";
                  } else {
                    KeyValidationState state = _keyStates
                        .firstWhere((element) => element.key == _categoriesKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: true);
                  }
                  return null;
                },
                items: categories ?? <ItemCategory>[],
                filterFn: (ItemCategory? item, String? filter) {
                  String json = jsonEncode(item?.json);
                  String newString = json.removePunctuation();
                  debugPrint(newString);
                  String filterString = filter?.removePunctuation() ?? '';
                  return newString
                      .toLowerCase()
                      .contains(filterString.toLowerCase());
                },
              ),
            );
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    });
  }

  Future<void> showMessageWaitLoad() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
              title: 'Caricamento in corso',
              message: 'Attendere il completamento del caricamento.',
              type: MessageDialogType.okOnly,
              okText: 'OK',
              okPressed: () {
                Navigator.pop(context, true);
              });
        }).then((value) {
      return value;
      //return value
    });
  }

  Future<bool> stopCompressionMessage() async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Compressione in corso',
            message:
                'La compressione delle immagini è ancora in corso. Fermare la compressione delle immagini?',
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

  void validateSave() async {
    try {
      if (_formKey.currentState!.validate()) {
        /*    List<ItemPicture> itemPictures = <ItemPicture>[];
            for (var image in selectedImages!){
              var encoded = await encodeBase64(image.picture!.bytes!);

              ItemPicture itemPicture = image.copyWith(picture: image.picture!.copyWith(image: encoded, pictureId: image.picture?.pictureId ?? 0));
              itemPictures.add(itemPicture);
            }*/

        List<ItemPicture> itemPictures = <ItemPicture>[];
        /*for (var image in selectedImages!) {
          // var encoded = await encodeBase64(image.picture!.bytes!);

          ItemPicture itemPicture = image.copyWith(
              picture: image.picture!.copyWith(
                  bytes: image.picture!.bytes!,
                  pictureId: image.picture?.pictureId ?? 0));
          itemPictures.add(itemPicture);
        }
*/
        if (_editItemKey.currentState != null &&
            _editItemKey.currentState!.itemPictures != null) {
          for (var image in _editItemKey.currentState!.itemPictures!) {
            ItemPicture itemPicture = image.copyWith(
                picture: image.picture!.copyWith(
                    bytes: image.picture!.bytes!,
                    mediaId: image.picture?.mediaId ?? 0));
            itemPictures.add(itemPicture);
          }
        }

        /*var itemPictures =  selectedImages!
                .map((e) async {
              return  e.copyWith(
                  picture:  e.picture!.copyWith(
                      image: await encodeBase64(e.picture!.bytes!),
                      pictureId: e.picture?.pictureId ?? 0));
            }).toList(growable: false);*/

        if (_editItemKey.currentState != null &&
            _editItemKey.currentState!.configuration != null) {
          if (element == null) {
            element = Item(
              itemId: 0,
              code: codeController.text,
              description: descriptionController.text,
              barcode: barcodeController.text,
              itemPhysicsId: 0,
              physicsConfiguration: ItemPhysicsConfiguration(
                itemPhysicsId: 0,
                widthMm: _editItemKey.currentState!.configuration?.widthMm ?? 0,
                depthMm: _editItemKey.currentState!.configuration?.depthMm ?? 0,
                heightMm:
                    _editItemKey.currentState!.configuration?.heightMm ?? 0,
              ),
              itemPictures: itemPictures,
              itemCategoryId: selectedItemCategory?.itemCategoryId,
              itemCategory:
                  null, //const ItemCategory(itemCategoryId: 6, code: '5', description: 'Articolo')
            );
          } else {
            element = element!.copyWith(
                code: codeController.text,
                description: descriptionController.text,
                barcode: barcodeController.text,
                physicsConfiguration: element!.physicsConfiguration!.copyWith(
                  widthMm:
                      _editItemKey.currentState!.configuration?.widthMm ?? 0,
                  depthMm:
                      _editItemKey.currentState!.configuration?.depthMm ?? 0,
                  heightMm:
                      _editItemKey.currentState!.configuration?.heightMm ?? 0,
                ),
                itemPictures: itemPictures,
                itemCategoryId: selectedItemCategory?.itemCategoryId,
                itemCategory:
                    null //const ItemCategory(itemCategoryId: 6, code: '5', description: 'Articolo')
                );
          }
        }
        if (widget.onSave != null) {
          widget.onSave?.call(element);
        } else {
          Navigator.pop(context, element);
        }
        //Navigator.pop(ctx, textController.text);
        //Navigator.pop(context, element);
      } else {
        try {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.state == false);

          Scrollable.ensureVisible(state.key.currentContext!,
              duration: const Duration(milliseconds: 500));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    } catch (e) {
      print(e);
      await showMessageWaitLoad();
    }
  }

  Widget _physicsPanel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: MultiExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            switch (panelIndex) {
              case 0: //fisici
                _physicsPanelIsExpanded = !_physicsPanelIsExpanded;
                break;
            /* case 1: //logici
                _logicPanelIsExpanded = !_logicPanelIsExpanded;
                break;*/
            }

            setState(() {});
          },
          children: [
            MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: _physicsPanelIsExpanded,
                canTapOnHeader: false,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const SizedBox(
                      height: 80, child: DialogHeader("Parametri fisici"));
                },
                body: Column(
                  children: [
                    widthField(),
                    heightField(),
                    depthField(),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  EdgeInsets getPadding() {
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  }

  Widget widthField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.expand),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _widthKey,
              max: 100000,
              min: 1,
              acceleration: 1,
              step: 1,
              value: widthValue,
              focusNode: _widthFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                widthValue = value;
              },
              decoration: _widthInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _widthKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget heightField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.expand),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _heightKey,
              max: 100000,
              min: 1,
              value: heightValue,
              acceleration: 1,
              step: 1,
              focusNode: _heightFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                heightValue = value;
              },
              decoration: _heightInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _heightKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget depthField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.keyboard_double_arrow_right),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _depthKey,
              max: 100000,
              min: 1,
              acceleration: 1,
              step: 1,
              value: depthValue,
              focusNode: _depthFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                depthValue = value;
              },
              decoration: _depthInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _depthKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  _connectToMessageHub() {
    try {
      eventBusSubscription = eventBus.on<ScanHubEvent>().listen((event) {
        List<String> result = (event.scanResult ?? '').split("\t");
        if (result.length == 2 && result.first == 'item_edit_screen') {
          barcodeController.text = result[1];
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
