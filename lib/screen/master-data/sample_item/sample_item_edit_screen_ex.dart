import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

//import 'package:audioplayers/audioplayers.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import "package:collection/collection.dart";
import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/pdf.global.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_category.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/item_category.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_production_picture.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/machine_setting_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/vmc_production.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/autogeneration/space_item_ex.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/items/item_edit_screen.dart';
import 'package:dpicenter/screen/master-data/items/items_screen.dart';
import 'package:dpicenter/screen/master-data/machines/machine_productions_view.dart';
import 'package:dpicenter/screen/master-data/machines/machine_settings_view.dart';
import 'package:dpicenter/screen/master-data/sample_item/sample_item_configuration_edit_screen.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/master-data/vmc_production_fields/vmc_production_fields_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_setting_fields/vmc_setting_fields_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select_container.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/dynamic_qr_button.dart';
import 'package:dpicenter/screen/widgets/print_qrcode/print_qr_options.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:universal_io/io.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

// Define a custom Form widget.
class SampleItemEditForm extends StatefulWidget {
  final SampleItem? element;
  final String? title;

  const SampleItemEditForm({Key? key, required this.element, this.title})
      : super(key: key);

  @override
  State<SampleItemEditForm> createState() => SampleItemEditFormState();
}

class SampleItemEditFormState extends State<SampleItemEditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///item da creare/modificare
  SampleItem? element;

  final ScrollController _scrollController =
      ScrollController(debugLabel: 'ScrollController');

  ///chiavi per i campi da compilare
  final GlobalKey<DropdownSearchState<Item>> _itemsDropDownKey =
      GlobalKey<DropdownSearchState<Item>>(debugLabel: 'itemsDropDownKey');

  final GlobalKey<DialogTitleExState> _dialogTitleKey =
      GlobalKey<DialogTitleExState>(debugLabel: '_dialogTitleKey');
  final GlobalKey _dialogNavigationKey =
      GlobalKey(debugLabel: '_dialogNavigationKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');

  ///stato della barra di navigazione
  int statNavStatus = -1;

  ///scorre alla posizione di toNavStatus e poi viene impostato statNavStatus
  int toNavStatus = -1;

  String title = "";

  Item? selectedItem;

  ///ultimo articolo creato
  Item? lastAddedItem;

  ///lista degli articoli
  List<Item>? items;

  ///lista dei modelli
  List<Vmc>? models;

  ///lista delle configurazioni
  final List<List> modelsConfiguration = [];

  ///ItemEditForm key
  final GlobalKey<ItemEditFormState> _itemsEditFormKey =
      GlobalKey<ItemEditFormState>(debugLabel: "_itemsEditFormKey");

  final GlobalKey _itemSectionKey = GlobalKey(debugLabel: "_itemSectionKey");
  final GlobalKey _configurationSectionKey =
      GlobalKey(debugLabel: "_configurationSectionKey");

  Map<MultiSelectorItem, GlobalKey> headers = {};

  @override
  void initState() {
    super.initState();

    title = widget.title ?? "";
    initKeys();

    headers
        .addAll({const MultiSelectorItem(text: 'Articolo'): _itemSectionKey});

    ///creo una copia dell'elemento in modo da poter annullare le modifiche
    ///in caso l'utente decida di non salvare
    try {
      element = widget.element?.copyWith();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (kDebugMode) {
      print(element.hashCode.toString());
    }
    if (element == null) {
    } else {
      selectedItem = element?.item;
    }
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

    Future.delayed(const Duration(milliseconds: 150), () {
      _loadCategories();
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      _loadItems();
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      _loadModels();
    });
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _itemsDropDownKey),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ///form contenente i dati da compilare
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: _selectorContainerBloc(),
    );
  }

  Widget _selectorContainerBloc() {
    return BlocBuilder<ServerDataBloc<Vmc>, ServerDataState<Vmc>>(
        builder: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded || state is ServerDataLoadedCompleted) {
        models?.forEach((element) {
          bool alreadyContained = false;
          for (var key in headers.keys) {
            if (key.text == element.description) {
              alreadyContained = true;
              break;
            }
          }
          if (!alreadyContained) {
            headers.addAll({
              MultiSelectorItem(text: element.description):
                  GlobalKey(debugLabel: element.description)
            });
          }
        });

        return _selectorContainerWidget(headerSectionsMap: headers);
      }

      if (state is ServerDataInitState) {
        return _selectorContainerWidget(headerSectionsMap: headers);
      }

      if (state is ServerDataLoading) {
        return _selectorContainerWidget(headerSectionsMap: headers);
      }
      if (state is ServerDataLoadingSendProgress) {
        return _selectorContainerWidget(headerSectionsMap: headers);
      }
      if (state is ServerDataLoadingReceiveProgress) {
        return _selectorContainerWidget(headerSectionsMap: headers);
      }
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;

        case ServerDataEvents.add:
          if (state is ServerDataAdded) {
            return _selectorContainerWidget(headerSectionsMap: headers);
          }

          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    });
  }

  Widget _selectorContainerWidget(
      {Map<MultiSelectorItem, GlobalKey>? headerSectionsMap}) {
    return MultiSelectorContainer(
      scrollController: _scrollController,
      title: title,
      headerSectionsMap: headerSectionsMap ??
          {
            const MultiSelectorItem(text: 'Articolo'): _itemSectionKey,
            const MultiSelectorItem(text: 'Configurazione'):
                _configurationSectionKey,
          },
      bottom: OkCancel(
          okFocusNode: _saveFocusNode,
          onCancel: () async {
            Navigator.maybePop(context, null);
          },
          onSave: () async {
            validateSave();
          }),
      child: FocusScope(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            /*DialogTitleEx(
                  key: _dialogTitleKey,
                  title,
                  titleAlignment: CrossAxisAlignment.start,
                  trailingChild: isLittleWidth() ? _popupCategoryButton() : null),*/
            Expanded(
              child: Form(
                  key: _formKey,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      constraints: BoxConstraints(
                          maxWidth: 1000,
                          maxHeight: MediaQuery.of(context).size.height > 700
                              ? MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).size.height / 3)
                              : MediaQuery.of(context).size.height),
                      child: _settingsScroll())),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _popupCategoryButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: const CircleBorder(),
        type: MaterialType.transparency,
        child: PopupMenuButton(
          elevation: 0,
          color: Colors.transparent,
          position: PopupMenuPosition.under,
          tooltip: 'Categorie',
          constraints: const BoxConstraints(maxWidth: 1500),
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          itemBuilder: (BuildContext context) => List.generate(
            1,
            (index) => PopupMenuItem(
              enabled: false,
                value: index,
                child: _categorySelector(),


                */ /*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/ /*
                ),
          ),
        ),
      ),
    );
  }*/

  bool isLittleWidth() => MediaQuery.of(context).size.width <= 800;

/*  Widget _mainLayout() {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: _settingsScroll(),
                  ),
                  const SizedBox(height: 20),
                ]),
          ),
          if (!isLittleWidth()) _categorySelector(),
        ]);
  }*/

  Widget _settingsScroll() {
    return SettingsScroll(
      controller: _scrollController,
      darkTheme: getSettingsDarkTheme(context),
      lightTheme: getSettingsLightTheme(context),
      // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      //contentPadding: EdgeInsets.zero,
      platform: DevicePlatform.web,
      sections: [
        _itemSection(),
        _configurationSection(),
      ],
    );
  }

  SettingsScrollSection _itemSection() {
    return SettingsScrollSection(
      key: _itemSectionKey,
      title: const Text(
        'Articolo',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _itemSettingTile(),
      ],
    );
  }

  Widget _configurationSection() {
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
      if (state is ServerDataLoaded) {
        return _modelsWidget(false);
      }
      if (state is ServerDataLoadedCompleted) {
        return _modelsWidget(false);
      }
      if (state is ServerDataInitState) {
        return _modelsWidget(true);
      }

      if (state is ServerDataLoading) {
        return _modelsWidget(true);
      }
      if (state is ServerDataLoadingSendProgress) {
        return _modelsWidget(true);
      }
      if (state is ServerDataLoadingReceiveProgress) {
        return _modelsWidget(true);
      }
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;

        case ServerDataEvents.add:
          return _modelsWidget(false);
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    }));
  }

  Widget _modelsWidget(bool isLoading) {
    return SettingsScrollSection(
        title: const Text(
          'Configurazione',
          //  style: Theme.of(context).textTheme.bodyLarge,
        ),
        tiles: !isLoading
            ? List.generate(models?.length ?? 0, (index) {
                print(
                    'Chiave nell\'indice ${index + 1}: ${headers.entries.elementAt(index + 1).value}');

                return _modelItem(
                    index, headers.entries.elementAt(index + 1).value);
              })
            : List.generate(
                models?.length ?? 5,
                (index) => getCustomSettingTile(
                    child: shimmerComboLoading(context, height: 80))));
  }

  Widget _modelItem(int index, GlobalKey key) {
    List? config = modelsConfiguration.firstWhereOrNull((element) =>
        element[0] != null &&
        element[0] is SampleItemConfiguration &&
        element[0].vmcId == models![index].vmcId);

    return getCustomSettingTile(
        key: key,
        hint: models![index].description,
        description:
            'Configurazione articolo per ${models![index].code}: ${models![index].description}',
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
                          itemConfiguration:
                              (config[0] as SampleItemConfiguration),
                          onPressed: () {
                            configureModel(index);
                          }),
                    ],
                  ),
                ),
              ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          configureModel(index);
                        },
                        child: const Text("Configura"))),
              ));
  }

  SettingsTile _itemSettingTile() {
    return getCustomSettingTile(
        title: 'Articolo',
        hint: 'Seleziona articolo',
        description: 'Seleziona un articolo dalla lista',
        child: _itemsDropDown());
  }

  Widget _itemsDropDown() {
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
                  searchFieldProps: const TextFieldProps(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //autofocus: isWindows || isWindowsBrowser ? true : false,
                      //controller: _searchItemsController,
                      decoration: InputDecoration(
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

  Widget _textField(
      {required int maxLenght,
      required TextEditingController controller,
      required GlobalKey fieldKey,
      required String labelText,
      required String hintText,
      bool validate = true,
      String validationError = 'Campo obbligatorio',
      bool? enabled = true,
      String? Function(String?)? customValidator}) {
    return Padding(
      padding: getPadding(),
      child: TextFormField(
        key: fieldKey,
        enabled: enabled ?? isEnabled(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        maxLength: maxLenght,
        onChanged: (value) {
          /*       setState(() {
            //_updateStato();
          });*/

          editState = true;
        },
        decoration: InputDecoration(
          //enabledBorder: OutlineInputBorder(),
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        validator: (str) {
          if (validate) {
            if (customValidator != null) {
              String? result = customValidator.call(str);
              if (result != null && result.isNotEmpty) {
                KeyValidationState state =
                    _keyStates.firstWhere((element) => element.key == fieldKey);
                _keyStates[_keyStates.indexOf(state)] =
                    state.copyWith(state: false);
                return result;
              } else {
                KeyValidationState state =
                    _keyStates.firstWhere((element) => element.key == fieldKey);
                _keyStates[_keyStates.indexOf(state)] =
                    state.copyWith(state: true);
                return null;
              }
            }

            if (str!.isEmpty) {
              KeyValidationState state =
                  _keyStates.firstWhere((element) => element.key == fieldKey);
              _keyStates[_keyStates.indexOf(state)] =
                  state.copyWith(state: false);
              return validationError;
            } else {
              KeyValidationState state =
                  _keyStates.firstWhere((element) => element.key == fieldKey);
              _keyStates[_keyStates.indexOf(state)] =
                  state.copyWith(state: true);
            }
          }
          return null;
        },
      ),
    );
  }

  EdgeInsets getPadding() {
    return const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
  }

  validateSave() {
    ///validazione
    if (_formKey.currentState!.validate()) {
      ///salvataggio
      if (_save()) {
        editState = false;

        Navigator.pop(context, element);
      } else {
        debugPrint("MachineEditScreen: Salvataggio non riuscito");
      }
    } else {
      /*Scrollable.ensureVisible(servicesKey.currentContext,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeOut);*/
      try {
        KeyValidationState state =
            _keyStates.firstWhere((element) => element.state == false);

        Scrollable.ensureVisible(
          state.key.currentContext!,
          duration: const Duration(milliseconds: 500),
        );
        /*_scrollController.position.ensureVisible(
          state.key.currentContext!.findRenderObject()!,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );*/
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  bool _save() {
    if (kDebugMode) {
      print("Urrà!");
    }
    try {
      /*if (element == null) {
        element = Customer(
          customerId: _idController.text,
          code: _codeController.text,
          description: _descriptionController.text,
          pIva: _pIVAController.text,
          cFiscale: _cFiscaleController.text,
          indirizzo: _indirizzoController.text,
          cap: _capController.text,
          comune: _comuneController.text,
          provincia: _provinciaController.text,
          nazione: _nazioneController.text,
          isManualEntry: true,
        );
      } else {
        element = element!.copyWith(
          customerId: _idController.text,
          code: _codeController.text,
          description: _descriptionController.text,
          pIva: _pIVAController.text,
          cFiscale: _cFiscaleController.text,
          indirizzo: _indirizzoController.text,
          cap: _capController.text,
          comune: _comuneController.text,
          provincia: _provinciaController.text,
          nazione: _nazioneController.text,
          isManualEntry: true,
        );
      }*/
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  bool isEnabled() {
    if (element != null) {
      return false;
    }
    /* return (details != null && details!.isNotEmpty) ||
            (element != null && element!.status == Status.closed.index)
        ? false
        : true;*/
    return true;
  }

  @override
  void dispose() {
    //_scrollController.removeListener(scrollListener);
    /*_boxes.clear();*/
    _scrollController.dispose();
    super.dispose();
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
      //player?.play(AssetSource('audio/se_non_bestemmio.mp3'));
      debugPrint("scan cancelled");
    }
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
}
