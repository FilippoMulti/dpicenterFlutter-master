import 'dart:convert';

//import 'package:audioplayers/audioplayers.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:collection/collection.dart';
import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
//import 'package:dpicenter/dummy/dummy_serialport.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_category.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/item_category.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/autogeneration/space_item_ex.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/items/item_edit_screen.dart';
import 'package:dpicenter/screen/master-data/items/items_screen.dart';
import 'package:dpicenter/screen/master-data/sample_item/sample_item_configuration_edit_screen.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/arrows/widget_arrows.dart';
import 'package:dpicenter/screen/widgets/dialog_header.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
/*import 'package:libserialport/libserialport.dart'
    if (dart.library.html) 'package:dpicenter/dummy/dummy_serialport.dart'
    if (dart.library.io) 'package:libserialport/libserialport.dart';*/

import 'package:flutter_spinbox/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
//import 'package:universal_io/io.dart';

// Define a custom Form widget.
class SampleItemEditForm extends StatefulWidget {
  final SampleItem? element;
  final String? title;

  const SampleItemEditForm(
      {Key? key, required this.element, required this.title})
      : super(key: key);

  @override
  SampleItemEditFormState createState() => SampleItemEditFormState();
}

class SampleItemEditFormState extends State<SampleItemEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

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

  ///ItemEditForm key
  final GlobalKey<ItemEditFormState> _itemsEditFormKey =
      GlobalKey<ItemEditFormState>(debugLabel: "_itemsEditFormKey");

  ///ultimo articolo creato
  Item? lastAddedItem;

  ///articolo selezionato
  Item? selectedItem;

  ///lista degli articoli
  List<Item>? items;

  ///lista dei modelli
  List<Vmc>? models;

  ///lista delle configurazioni
  final List<List> modelsConfiguration = [];

  ///stato della compressione immagini
  int compressStatus = 0;

  late TextEditingController _searchItemsController;
  late TextEditingController barcodeController;
  late TextEditingController _searchCategoryController;

  double widthValue = 0;
  double heightValue = 0;
  double depthValue = 0;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");
  SampleItem? element;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');

  final FocusNode _barcodeFocusNode =
      FocusNode(debugLabel: '_barcodeFocusNode');
  final FocusNode _categoriesFocusNode =
      FocusNode(debugLabel: '_categoriesFocusNode');

  final FocusNode _widthFocusNode = FocusNode(debugLabel: '_widthFocusNode');
  final FocusNode _heightFocusNode = FocusNode(debugLabel: '_heightFocusNode');
  final FocusNode _depthFocusNode = FocusNode(debugLabel: '_depthFocusNode');
  final FocusNode _itemsFocusNode = FocusNode(debugLabel: '_itemsFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _barcodeKey = GlobalKey(debugLabel: '_barcodeKey');
  final GlobalKey _categoriesKey = GlobalKey(debugLabel: '_categoriesKey');
  final GlobalKey _widthKey = GlobalKey(debugLabel: '_widthKey');
  final GlobalKey _heightKey = GlobalKey(debugLabel: '_heightKey');
  final GlobalKey _depthKey = GlobalKey(debugLabel: '_depthKey');
  final GlobalKey<DropdownSearchState<Item>> _itemsDropDownKey =
      GlobalKey<DropdownSearchState<Item>>(debugLabel: 'itemsDropDownKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  String imageGridKeyString = "key";

  SampleItem? sampleItem;

  bool get isSmall => !(MediaQuery.of(context).size.width > 1000);

  @override
  void initState() {
    super.initState();

    initKeys();
    element = widget.element;

    //debugPrint(availablePorts.length.toString());
//check here that your device exists

    eventBus.on<SerialMessageEvent>().listen((event) {
      setState(() {
        String code = utf8.decode(event.newEvent);
        setState(() {
          try {
            selectedItem =
                items?.firstWhereOrNull((element) => element.barcode == code);
          } catch (e) {
            print(e);
          }
        });
      });
    });

    _searchCategoryController = TextEditingController();
    _searchItemsController = TextEditingController();

    /* if (element != null) {
      barcodeController = TextEditingController(text: element!.barcode);

      selectedItemCategory = element!.itemCategory;

      heightValue = element!.physicsConfiguration?.heightMm ?? 0;
      widthValue = element!.physicsConfiguration?.widthMm ?? 0;
      depthValue = element!.physicsConfiguration?.depthMm ?? 0;
    } else {
      barcodeController = TextEditingController();
    }*/

    Future.delayed(const Duration(milliseconds: 150), () {
      _loadCategories();
    });
/*    Future.delayed(const Duration(milliseconds: 150), () {
      _loadImages();
    });*/
    Future.delayed(const Duration(milliseconds: 150), () {
      _loadItems();
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      _loadModels();
    });
/*    Future.delayed(const Duration(milliseconds: 150), () {
      _loadImages();
    });*/
  }

  _loadModels() {
    var bloc = BlocProvider.of<ServerDataBloc<Vmc>>(context);
    bloc.add(const ServerDataEvent<Vmc>(status: ServerDataEvents.fetch));
  }

  _loadCategories() {
    var bloc = BlocProvider.of<ServerDataBloc<SampleItemCategory>>(context);
    bloc.add(const ServerDataEvent<SampleItemCategory>(
        status: ServerDataEvents.fetch));
  }

  _loadItems() {
    var bloc = BlocProvider.of<ServerDataBloc<Item>>(context);
    bloc.add(const ServerDataEvent<Item>(status: ServerDataEvents.fetch));
  }


  @override
  void dispose() {
    //_searchItemsController.dispose();

    _saveFocusNode.dispose();
    _itemsFocusNode.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _itemsDropDownKey),
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
    return textFieldInputDecoration(
        labelText: 'Codice a barre / QR CODE',
        hintText: 'Inserisci o leggi codice a barre dell\'articolo');
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
                  width: isSmall ? 500 : 900,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DialogTitle(widget.title!),
                        _itemsDropDown(),
                        _modelsParameters(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )),
          ),
          OkCancel(
              okFocusNode: _saveFocusNode,
              onCancel: () async {
                Navigator.maybePop(context, null);
              },
              onSave: () async {
                validateSave();
              })
        ],
      ),
    );
  }

  Widget _modelsParameters() {
    return BlocListener<ServerDataBloc<Vmc>, ServerDataState<Vmc>>(
        listener: (BuildContext context, ServerDataState state) {
      if (state is ServerDataAdded<Vmc>) {
        //  lastAddedItem = state.item;
      }
      if (state is ServerDataLoaded) {
        models = state.items! as List<Vmc>;
        try {
          models!.sort((value1, value2) =>
              value1.description.compareTo(value2.description));
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      if (state is ServerDataLoadedCompleted) {
        if (state.items != null && state.items is List<Vmc>) {
          models = state.items! as List<Vmc>;

          /*WidgetsBinding.instance.addPostFrameCallback((_) {
                ///necessaria per accedere alla chiave dopo che che è stata creata
                Item? selected = _itemsDropDownKey.currentState?.getSelectedItem;
                if (selected != null && lastAddedItem != null) {
                  selected = lastAddedItem;
                  lastAddedItem = null;
                  _itemsDropDownKey.currentState?.changeSelectedItem(selected);
                }
              });*/
        }
      }
    }, child: BlocBuilder<ServerDataBloc<Vmc>, ServerDataState<Vmc>>(
            builder: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded<Vmc>) {
        return _modelsWidget();
      }
      if (state is ServerDataLoadedCompleted<Vmc>) {
        return _modelsWidget();
      }
      if (state is ServerDataInitState<Vmc>) {
        return shimmerComboLoading(context);
      }

      if (state is ServerDataLoading<Vmc>) {
        return shimmerComboLoading(context);
      }

      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;

        case ServerDataEvents.add:
          if (state is ServerDataAdded) {
            return Stack(children: [
              //_hashTagDropDownWidget(),
              shimmerComboLoading(context)
            ]);
          }

          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    }));
  }

  void scanCodeWithCamera2() async {
    var result = await BarcodeScanner.scan();
    if (result.type != ResultType.Cancelled) {
      //player?.play(AssetSource('audio/beep_08b.mp3'));
      setState(() {
        try {
          selectedItem = items?.firstWhereOrNull(
              (element) => element.barcode == result.rawContent);
        } catch (e) {
          print(e);
        }
      });

      debugPrint(result.type
          .toString()); // The result type (barcode, cancelled, failed)
      debugPrint(result.rawContent); // The barcode content
      debugPrint(result.format.toString()); // The barcode format (as enum)
      debugPrint(result.formatNote); //
    } else {
      // player?.play(AssetSource('audio/se_non_bestemmio.mp3'));
      debugPrint("scan cancelled");
    }
  }

  void scanCodeWithCamera() async {
    showDialog(
        context: context,
        builder: (context) {
          return MobileScanner(
              // allowDuplicates: false,
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

  Widget _itemsDropDown() {
    /*   var box = _hashTagDropDownKey.currentContext?.findRenderObject();
    Size? size;
    if (box!=null){
      size =  (box as RenderBox).size;
      print(size ?? 'size is null');
    }*/

    return BlocListener<ServerDataBloc<Item>, ServerDataState<Item>>(
        listener: (BuildContext context, ServerDataState state) {
      if (state is ServerDataAdded) {
        lastAddedItem = state.item;
      }
      if (state is ServerDataLoaded) {
        items = state.items! as List<Item>;
        try {
          items!.sort((value1, value2) =>
              value1.description!.compareTo(value2.description!));
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      if (state is ServerDataLoadedCompleted) {
        if (state.items != null && state.items is List<Item>) {
          items = state.items! as List<Item>;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ///necessaria per accedere alla chiave dopo che che è stata creata
            Item? selected = _itemsDropDownKey.currentState?.getSelectedItem;
            if (selected != null && lastAddedItem != null) {
              selected = lastAddedItem;
              lastAddedItem = null;
              _itemsDropDownKey.currentState?.changeSelectedItem(selected);
            }
          });
        }
      }
    }, child: BlocBuilder<ServerDataBloc<Item>, ServerDataState<Item>>(
            builder: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded) {
        return _itemsDropDownWidget();
      }
      if (state is ServerDataLoadedCompleted) {
        return _itemsDropDownWidget();
      }
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
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;

        case ServerDataEvents.add:
          if (state is ServerDataAdded) {
            return Stack(children: [
              //_hashTagDropDownWidget(),
              shimmerComboLoading(context)
            ]);
          }

          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    }));
  }

  Widget _modelsWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: isDarkTheme(context) ? Colors.white54 : Colors.black54,
                width: 1)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: List.generate(
                  models?.length ?? 0, (index) {
            List? config = modelsConfiguration.firstWhereOrNull((element) =>
                element[0] != null &&
                element[0] is SampleItemConfiguration &&
                element[0].vmcId == models![index].vmcId);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          models?[index].code ?? 'no data',
                          style: isSmall
                              ? Theme.of(context).textTheme.headline6
                              : Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          models?[index].description ?? 'no data',
                          style: isSmall
                              ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.color)
                              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.color),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 70, child: VerticalDivider(width: 1)),
                  Expanded(
                      child: config != null
                          ? Center(
                              child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                height: 180,
                                width: 300,
                                child: Stack(
                                  children: [
                                    SpaceItemEx(
                                        codeToShow: selectedItem?.code ?? '?',
                                        vmc: models![index],
                                        itemPictures: config[1],
                                        onStandTap: () {},
                                        itemConfiguration: (config[0]
                                            as SampleItemConfiguration),
                                        onPressed: () {
                                          configureModel(index);
                                        }),
                                  ],
                                ),
                              ),
                            ))
                          : Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    configureModel(index);
                                  },
                                  child: const Text("Configura")))),
                  /*  const SizedBox(
                                height: 70, child: VerticalDivider(width: 1)),
                            Flexible(
                                child: Center(
                                    child: ElevatedButton(
                                        onPressed: ()  {
                                           configureModel(index);
                                        },
                                        child: const Text("Configura"))))*/
                ],
              ),
            );
          })),
        ),
      ),
    );
  }

  void configureModel(int index) async {
    if (selectedItem != null && models?[index] != null) {
      List? config = modelsConfiguration.firstWhereOrNull((element) =>
          element[0] != null &&
          element[0] is SampleItemConfiguration &&
          element[0].vmcId == models![index].vmcId);

      if (config == null) {
        List result =
            await configureItemForModel(models![index], selectedItem!);
        modelsConfiguration.add(result);
      } else {
        List result = await configureItemForModel(models![index], selectedItem!,
            itemConfiguration: config[0], itemPictures: config[1]);
        modelsConfiguration[modelsConfiguration.indexOf(config)] = result;
      }

      setState(() {});
    } else {
      await showItemEmptyErrorMessage();
      scrollAndTapEffect(
          scrollController: _scrollController, target: _itemsDropDownKey);
    }
  }

  showItemEmptyErrorMessage() async {
    var result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Seleziona un articolo',
            message:
                'Per poter campionare un articolo è necessario prima selezionarlo',
            type: MessageDialogType.okOnly,
            okText: 'OK',
            okPressed: () {
              Navigator.pop(context, "0");
            });
      },
    ).then((value) async {
      return value;
      //return value
    });
    if (kDebugMode) {
      print(result);
    }
  }

  Future configureItemForModel(Vmc model, Item item,
      {List<SampleItemPicture>? itemPictures,
      SampleItemConfiguration? itemConfiguration}) async {
    final GlobalKey<SampleItemEditFormState> formKey =
        GlobalKey<SampleItemEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: MultiBlocProvider(
                providers: [
                  BlocProvider<ServerDataBloc<Item>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<Item>(
                        repo: MultiService<Item>(Item.fromJsonModel,
                            apiName: "Item")),
                  ),
                  BlocProvider<ServerDataBloc<ItemCategory>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<ItemCategory>(
                        repo: MultiService<ItemCategory>(
                            ItemCategory.fromJsonModel,
                            apiName: "ItemCategory")),
                  ),
                  BlocProvider<ServerDataBloc<SampleItemCategory>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<SampleItemCategory>(
                        repo: MultiService<SampleItemCategory>(
                            SampleItemCategory.fromJsonModel,
                            apiName: "SampleItemCategory")),
                  ),
                  BlocProvider<ServerDataBloc<Media>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<Media>(
                        repo: MultiService<Media>(Media.fromJsonModel,
                            apiName: "Media")),
                  ),
                  BlocProvider<ServerDataBloc<Vmc>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<Vmc>(
                        repo: MultiService<Vmc>(Vmc.fromJsonModel,
                            apiName: "Vmc")),
                  ),
                  BlocProvider<PictureBloc>(
                    lazy: false,
                    create: (context) => PictureBloc(),
                  ),
                ],
                child: SampleItemConfigurationEditForm(
                  key: formKey,
                  item: item,
                  title:
                      "Configura ${item.description} per ${model.description}",
                  vmc: model,
                  itemConfiguration: itemConfiguration,
                  itemPictures: itemPictures,
                ),
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  Widget _itemsDropDownWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: DropdownSearch<Item>(
                key: _itemsDropDownKey,

                popupProps: PopupProps.dialog(
                  //listViewProps: ListViewProps(physics: NeverScrollableScrollPhysics()),
                  dialogProps: DialogProps(
                      clipBehavior: Clip.antiAlias,
                      backgroundColor: getAppBackgroundColor(context)),
                  searchFieldProps: TextFieldProps(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      //autofocus: isWindows || isWindowsBrowser ? true : false,
                      //controller: _searchItemsController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  showSelectedItems: true,
                  showSearchBox: true,
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  emptyBuilder: (BuildContext
                          context2 /*modificato nome in context2 per permettere di far accedere MultiBlocProvider al contesto giusto*/,
                      String? item) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<ServerDataBloc<Media>>(
                          lazy: false,
                          create: (context) => ServerDataBloc<Media>(
                              repo: MultiService<Media>(Media.fromJsonModel,
                                  apiName: "Media")),
                        ),
                        BlocProvider.value(
                          value: BlocProvider.of<ServerDataBloc<ItemCategory>>(
                              context),
                        ),
                        BlocProvider<PictureBloc>(
                          lazy: false,
                          create: (context) => PictureBloc(),
                        ),
                      ],
                      child: Center(
                          child: ItemEditForm(
                        key: _itemsEditFormKey,
                        element: null,
                        title: "Nuovo articolo",
                        onSave: (Item? value) {
                          if (value != null) {
                            _itemsDropDownKey.currentState
                                ?.closeDropDownSearch();
                            selectedItem = value;
                            _addItem(value);
                          }
                        },
                      )),
                    );
                  },
                  itemBuilder:
                      (BuildContext context, Item item, bool isSelected) {
                    return ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        title: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(item.code!))),
                        subtitle: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(item.description!)));
                  },
                ),
                /*focusNode:
                    isWindows || isWindowsBrowser ? null : _itemsFocusNode,*/
                enabled: true,

                ///TODO: verificare se il campione risulta utilizzato, in caso affermativo è necessario bloccare la modifica,

                ///Verificare quando e se disabilitare //isEnabled(),

                /*popupBackgroundColor: getAppBackgroundColor(context),*/

                autoValidateMode: /*selectedItem == null
                    ? AutovalidateMode.disabled
                    :*/
                    AutovalidateMode.onUserInteraction,
                compareFn: (item, selectedItem) =>
                    item.itemId == selectedItem.itemId,
                clearButtonProps: const ClearButtonProps(isVisible: true),

                itemAsString: (Item? c) => c!.description!,
                onChanged: (Item? newValue) {
                  setState(() {
                    editState = true;
                    selectedItem = newValue;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Articolo',
                    hintText:
                        'Seleziona articolo da associare alla campionatura',
                  ),
                ),

                validator: (item) {
                  if (item == null) {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) => element.key == _itemsDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: false);
                    return "Seleziona un articolo";
                  } else {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) => element.key == _itemsDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: true);
                  }
                  return null;
                },

                dropdownBuilder: (context, selectedItem) {
                  Widget item(Item item) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(item.description!));
                  return Row(
                    children: [
                      Expanded(
                        child: selectedItem != null
                            ? item(selectedItem)
                            : Text("Selezionare un articolo",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: isDarkTheme(context)
                                            ? Colors.white60
                                            : Colors.black54)),
                      ),
                      if (isMobile) /*SCAN BARCODE QR CODE*/
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 16,
                                maxWidth: 18,
                                minHeight: 16,
                                maxHeight: 18),
                            onPressed: () {
                              scanCodeWithCamera2();
                            },
                            icon: const Icon(Icons.qr_code_scanner, size: 20)),
                      if (isMobile)
                        const SizedBox(
                          width: 26,
                        ),
                      IconButton(
                          tooltip: 'Apri',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 16,
                              maxWidth: 18,
                              minHeight: 16,
                              maxHeight: 18),
                          onPressed: () {
                            if (selectedItem != null) {
                              ItemsActions.openDetail(context, selectedItem);
                            }
                          },
                          icon: Icon(Icons.open_in_browser,
                              size: 20,
                              color: isDarkTheme(context)
                                  ? Colors.white60
                                  : Colors.black54)),
                    ],
                  );
                },
                items: items ?? <Item>[],
                selectedItem: selectedItem,
              ),
            ),
          ],
        ));
  }

  _addItem(Item item) {
    var bloc = BlocProvider.of<ServerDataBloc<Item>>(context);
    bloc.add(ServerDataEvent<Item>(
        status: ServerDataEvents.add,
        item: item,
        columnFilters: null,
        customFilters: null,
        onEvent: ItemsActions.onAdd));
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DropdownSearch<ItemCategory>(
                key: _categoriesKey,

                popupProps: PopupProps.dialog(
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  dialogProps: DialogProps(
                      backgroundColor: getAppBackgroundColor(context)),
                  emptyBuilder: (context, searchEntry) =>
                      const Center(child: Text('Nessun risultato')),
                  searchFieldProps: TextFieldProps(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      autofocus: isWindows || isWindowsBrowser ? true : false,
                      //controller: _searchCategoryController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  showSelectedItems: true,
                  showSearchBox: true,
                ),

                /*focusNode:
                    isWindows || isWindowsBrowser ? null : _categoriesFocusNode,*/
                enabled: true,
                //isEnabled(),

                /*popupBackgroundColor: getAppBackgroundColor(context),*/

                compareFn: (item, selectedItem) =>
                    item.itemCategoryId == selectedItem.itemCategoryId,
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
        for (var image in selectedImages!) {
          // var encoded = await encodeBase64(image.picture!.bytes!);

          ItemPicture itemPicture = image.copyWith(
              picture: image.picture!.copyWith(
                  bytes: image.picture!.bytes!,
                  mediaId: image.picture?.mediaId ?? 0));
          itemPictures.add(itemPicture);
        }

        /*var itemPictures =  selectedImages!
                .map((e) async {
              return  e.copyWith(
                  picture:  e.picture!.copyWith(
                      image: await encodeBase64(e.picture!.bytes!),
                      pictureId: e.picture?.pictureId ?? 0));
            }).toList(growable: false);*/

        /*if (element == null) {
          element = Item(
            itemId: 0,
            barcode: barcodeController.text,
            itemPhysicsId: 0,
            physicsConfiguration: ItemPhysicsConfiguration(
                itemPhysicsId: 0,
                widthMm: widthValue,
                depthMm: depthValue,
                heightMm: heightValue),
            itemPictures: itemPictures,
            itemCategoryId: selectedItemCategory?.itemCategoryId,
            itemCategory:
                null, //const ItemCategory(itemCategoryId: 6, code: '5', description: 'Articolo')
          );
        } else {
          element = element!.copyWith(
              barcode: barcodeController.text,
              physicsConfiguration: element!.physicsConfiguration!.copyWith(
                  widthMm: widthValue,
                  depthMm: depthValue,
                  heightMm: heightValue),
              itemPictures: itemPictures,
              itemCategoryId: selectedItemCategory?.itemCategoryId,
              itemCategory:
                  null //const ItemCategory(itemCategoryId: 6, code: '5', description: 'Articolo')
              );
        }*/

        //Navigator.pop(ctx, textController.text);
        Navigator.pop(context, element);
      } else {
        try {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.state == false);

          _scrollController.position.ensureVisible(
            state.key.currentContext!.findRenderObject()!,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
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
}
