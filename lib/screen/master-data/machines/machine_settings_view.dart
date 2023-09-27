import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import "package:collection/collection.dart";
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/machine_setting_picture.dart';
import 'package:dpicenter/models/server/media_item.dart';
import 'package:dpicenter/models/server/vmc_production_category.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/machines/machine_edit_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_production_fields/vmc_production_fields_screen.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/settings_tiles/multi_setting_tile.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:universal_io/io.dart';

import '../vmc_setting_fields/vmc_setting_fields_screen.dart';

class MachineSettingsView extends StatefulWidget {
  final Machine? machine;
  final List<MachineSetting>? machineSettings;

  ///ritorna true se è necessario eseguire la chiusura con il Navigator oppure false se alla chiusura pensa il chiamante
  final bool Function()? closePressed;

  ///ritorna true se è necessario eseguire la chiusura con il Navigator oppure false se alla chiusura pensa il chiamante
  final bool Function()? savePressed;
  final double? maxWidth;
  final String? title;
  final double topPadding;

  const MachineSettingsView(
      {this.machine,
      this.machineSettings,
      this.closePressed,
      this.maxWidth = 1200,
      this.savePressed,
      this.topPadding = 0,
      this.title,
      Key? key})
      : super(key: key);

  @override
  MachineSettingsViewState createState() => MachineSettingsViewState();
}

class MachineSettingsViewState extends State<MachineSettingsView> {
  Map<VmcSettingCategory, List<MachineSetting>>? categories;
  List<SettingsScrollSection> settingSections = <SettingsScrollSection>[];
  List<MachineSetting>? selectedSettings = <MachineSetting>[];
  final Map<String, GlobalKey> categoryKeysMap = <String, GlobalKey>{};
  final List<MapSettingKey> categorySettingsList = <MapSettingKey>[];
  final ScrollController _scrollController =
      ScrollController(debugLabel: 'machineSettingsViewScrollController');
  MapSettingKey? _selectedMapSettingKey;

  final GlobalKey<MultiSelectorExState> _multiSelectorKey =
      GlobalKey<MultiSelectorExState>(debugLabel: '_multiSelectorKey');
  final GlobalKey _multiSelectorContainerKey =
      GlobalKey(debugLabel: '_multiSelectorContainerKey');

  bool isLittleWidth() => MediaQuery.of(context).size.width <= 800;

  ///stato della barra di navigazione
  int statNavStatus = -1;

  ///scorre alla posizione di toNavStatus e poi viene impostato statNavStatus
  int toNavStatus = -1;
  final Map<GlobalKey, RenderBox> _boxes = <GlobalKey, RenderBox>{};

  final GlobalKey _dialogNavigationKey =
      GlobalKey(debugLabel: "_dialogNavigationKey");
  final ScrollController _multiSelectorScrollController =
      ScrollController(debugLabel: '_multiSelectorScrollController');

  List<SelectorData>? _selectorData;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  @override
  void initState() {
    super.initState();
    selectedSettings = widget.machine?.machineSettings != null &&
            widget.machine!.machineSettings!.isNotEmpty
        ? widget.machine?.machineSettings
        : widget.machineSettings;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _mainLayout() {
    return Column(children: [
      if (isLittleWidth())
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(
                top: (8.0 + widget.topPadding),
                left: 8.0,
                right: 8.0,
                bottom: 8.0),
            child: ListTile(
              title: widget.title != null ? Text(widget.title!) : null,
              trailing: Material(
                clipBehavior: Clip.antiAlias,
                shape: const CircleBorder(),
                type: MaterialType.transparency,
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  tooltip: 'Categorie',
                  constraints: const BoxConstraints(maxWidth: 1500),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  itemBuilder: (BuildContext context) => List.generate(
                    1,
                    (index) => PopupMenuItem(
                      value: index,
                      child: _categorySelector(),

                      /*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      if (!isLittleWidth() && widget.title != null)
        DialogTitleEx(widget.title!),
      Expanded(
        child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: _settingsScrollWidget(),
                        ),
                        const SizedBox(height: 20),
                      ]),
                ),
              ),
              if (!isLittleWidth())
                Flexible(
                  flex: 0,
                  child: _categorySelector(),
                ),
            ]),
      ),
    ]);
  }

  Widget _categorySelector() {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 330,
        child: SingleChildScrollView(
            controller: _multiSelectorScrollController,
            key: _dialogNavigationKey,
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  IntrinsicHeight(child: _settingFieldsDropDownWidget()),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    key: _multiSelectorContainerKey,
                    padding: getPadding(),
                    child: _multiSelectorWidget(direction: Axis.vertical),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _settingsScrollWidget() {
    return SettingsScroll(
      controller: _scrollController,
      darkTheme: SettingsThemeData(
        settingsListBackground: isDarkTheme(context)
            ? Color.alphaBlend(
                Theme.of(context).colorScheme.surface.withAlpha(240),
                Theme.of(context).colorScheme.primary)
            : Theme.of(context).colorScheme.surface,
      ),
      lightTheme:
          const SettingsThemeData(settingsListBackground: Colors.transparent),
      //contentPadding: EdgeInsets.zero,
      platform: DevicePlatform.web,
      sections: [
        _settingsOptionsSection(),
        ...settingSections,
      ],
    );
  }

  SettingsScrollSection _settingsOptionsSection() {
    return SettingsScrollSection(
      //key: _settingsSectionKey,
      title: const Text(
        'Caricamento impostazioni da file excel',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _loadSettingTile(),
      ],
    );
  }

  SettingsTile _loadSettingTile() {
    return getCustomSettingTile(
        title: 'Carica impostazioni',
        hint: 'Carica impostazioni da file Excel',
        description: 'Carica impostazioni da file Excel',
        child: _loadButton());
  }

  Widget _loadButton() {
    return Padding(
      padding: getPadding(),
      child: ElevatedButton(
        child: const Text("Carica"),
        onPressed: () {
          _loadFileExcel(context);
        },
      ),
    );
  }

  _loadFileExcel(BuildContext context) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      allowedExtensions: ["xls", "xlsx"],
      type: FileType.custom,
    );
    if (file != null) {
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
              title: 'Importazione parametri',
              message:
                  'Importare i parametri dei distributori da un file excel?',
              type: MessageDialogType.yesNo,
              yesText: 'SI',
              noText: 'NO',
              okPressed: () {
                Navigator.pop(context, "0");
              },
              noPressed: () {
                Navigator.pop(context, "1");
              });
        },
      ).then((value) async {
        return value;
        //return value
      });
      if (result is String) {
        if (result == "0") {
          Uint8List? bytes;
          if (file.files[0].bytes != null) {
            bytes = file.files[0].bytes!;
          } else {
            File fileToRead = File(file.files[0].path!);
            bytes = fileToRead.readAsBytesSync();
          }

          if (bytes != null) {
            int result = await _importExcelFile(bytes);
          }
        }
      }
    }
  }

  Future<int> _importExcelFile(Uint8List bytes) async {
    try {
      List<String> notImported = <String>[];
      Map<String, List<MachineSetting>>? categoriesMap =
          selectedSettings?.groupBy((p0) => p0.categoryName!);

      var excel = Excel.decodeBytes(bytes);
      String currentCategory = "";

      for (var table in excel.tables.keys) {
        print(table); //sheet Name
        print(excel.tables[table]?.maxCols);
        print(excel.tables[table]?.maxRows);
        for (var row in excel.tables[table]!.rows) {
          String? currentAValue;

          if (row.isNotEmpty) {
            if (row.elementAt(0) != null) {
              currentAValue = row.elementAt(0)!.value;

              dynamic currentBValue;
              if (row.length > 1) {
                currentBValue = row.elementAt(1)?.value.toString();
              }
              debugPrint("currentAValue: ${currentAValue}");

              if (categoriesMap?.keys.firstWhereOrNull((element) =>
                      element.toLowerCase() == currentAValue!.toLowerCase()) !=
                  null) {
                currentCategory = currentAValue!;
              } else {
                if (currentCategory.isNotEmpty) {
                  ///sono all'interno di una categoria specifica
                  if (currentBValue != null) {
                    ///ci sono dati nella cella dei valori
                    for (int index = 0;
                        index < (selectedSettings?.length ?? 0);
                        index++) {
                      if (selectedSettings![index].name!.toLowerCase() ==
                              currentAValue!.toLowerCase() &&
                          selectedSettings![index]
                                  .categoryName!
                                  .toLowerCase() ==
                              currentCategory.toLowerCase()) {
                        ///c'è un impostazione con lo stesso nome e categoria di quella del file excel
                        setState(() {
                          ///esegui l'aggiornamento dell'importazione
                          ApplicationUser? currentUser =
                              ApplicationUser.getUserFromSetting();

                          Future.sync(() => initializeDateFormatting(
                              Intl.defaultLocale!, null));

                          selectedSettings![index] = selectedSettings![index]
                              .copyWith(
                                  value: currentBValue,
                                  applicationUserId:
                                      currentUser?.applicationUserId ?? 0,
                                  user: currentUser,
                                  date: DateFormat().format(DateTime.now()));
                          _multiSelectorKey.currentState?.setState(() {
                            _multiSelectorKey.currentState?.selectorData =
                                _getSelectorData(direction: Axis.vertical);
                          });

                          GlobalKey<MultiSettingTileState>? key =
                              categorySettingsList
                                  .firstWhereOrNull((element) =>
                                      element.fieldId ==
                                      selectedSettings![index]
                                          .vmcSettingFieldId)
                                  ?.key as GlobalKey<MultiSettingTileState>?;

                          key?.currentState?.setState(() {
                            //aggiornare user
                            key.currentState?.currentValue = currentBValue;
                            key.currentState?.currentUser = currentUser != null
                                ? "Modificato da ${currentUser.name} ${currentUser.surname} il ${DateFormat().format(DateTime.now())}"
                                : null;
                          });
                        });
                        break;
                      }
                    }
                    editState = true;
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
      return 1;
    }
    return 0;
  }

  createSettingsSections() {
    settingSections.clear();

    if (selectedSettings != null) {
      ///ottengo le categorie
      categories = selectedSettings?.groupBy((m) => VmcSettingCategory(
          vmcSettingCategoryCode: m.categoryCode,
          name: m.categoryName,
          color: m.categoryColor));

      if (categories != null) {
        for (VmcSettingCategory element in categories!.keys) {
          ///creo le chiavi per le categorie
          if (!categoryKeysMap.containsKey(element.vmcSettingCategoryCode)) {
            categoryKeysMap.addAll({
              element.vmcSettingCategoryCode!:
                  GlobalKey(debugLabel: element.vmcSettingCategoryCode)
            });
          }

          ///separo le impostazioni per categoria
          List<MachineSetting> categorySettings = <MachineSetting>[];
          for (MachineSetting item in selectedSettings!) {
            if (categorySettingsList.firstWhereOrNull(
                    (element) => element.fieldId == item.vmcSettingFieldId) ==
                null) {
              categorySettingsList.add(MapSettingKey(
                  fieldId: item.vmcSettingFieldId,
                  machineSetting: item,
                  fieldName: item.name ?? '',
                  key: GlobalKey<MultiSettingTileState>(
                      debugLabel: item.name ?? '')));
            } else {
              /*debugPrint(
                  "MachineSettingsView: non trovato: ${item.description}");*/
            }

            if (item.categoryCode == element.vmcSettingCategoryCode) {
              categorySettings.add(item);
            }
          }

          print(
              "categoryKeysMap[element.vmcSettingCategoryCode]: ${categoryKeysMap[element.vmcSettingCategoryCode]}");

          ///creo le sezioni
          settingSections.add(SettingsScrollSection(
            key: categoryKeysMap[element.vmcSettingCategoryCode],
            color: element.color != null
                ? isDarkTheme(context)
                    ? Color.alphaBlend(
                        Color(int.parse(element.color!)).withAlpha(200),
                        Color.alphaBlend(
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withAlpha(240),
                            Theme.of(context).colorScheme.primary))
                    : Color.alphaBlend(
                        Color(int.parse(element.color!)).withAlpha(200),
                        Theme.of(context).colorScheme.surface)
                : null,
            //element.color!=null ? Color(int.parse(element.color!)).withAlpha(80) : null,
            title: Text(element.name!),
            tiles: categorySettings.isNotEmpty
                ? List.generate(
                    categorySettings.length,
                    (index) => _settingSettingTile(categorySettings[index]),
                  )
                : List.generate(
                    1,
                    (index) => getCustomSettingTile(
                        child: const Text('Nessuna impostazione selezionata'))),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedSettings != null) {
      createSettingsSections();
    }
    _selectorData = _getSelectorData(direction: Axis.vertical);

    return WillPopScope(
      onWillPop: () async {
        bool status = editState;
        if (status) {
          //on edit

          String? result = await exitScreen(context);
          if (result != null) {
            switch (result) {
              case '0': //si
                if (mounted) {
                  if ((widget.savePressed?.call() ?? true)) {
                    Navigator.of(context).pop(selectedSettings);
                  }
                }
                break;
              case '1': //no
                if (mounted) {
                  if ((widget.closePressed?.call() ?? true)) {
                    Navigator.of(context).pop();
                  }
                }
                break;
              case '2': //annulla
                break;
            }
          }
        }
        return !status;
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
                color: isDarkTheme(context)
                    ? Color.alphaBlend(
                        Theme.of(context).colorScheme.surface.withAlpha(240),
                        Theme.of(context).colorScheme.primary)
                    : Theme.of(context).colorScheme.surface,
                constraints: BoxConstraints(
                  maxWidth: widget.maxWidth ?? double.infinity,
                  /*maxHeight: MediaQuery.of(context).size.height > 700
      ? MediaQuery.of(context).size.height -
      (MediaQuery.of(context).size.height / 3)
                : MediaQuery.of(context).size.height*/
                ),
                child: _mainLayout()),
          ),
          _okCancel(),
        ],
      ),
    );
    /* return Column(
      children: [
        SizedBox(
          height: 120,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IntrinsicWidth(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _multiSelectorWidget(),
                      )),
                      IntrinsicWidth(child: _productionFieldsDropDownWidget()),
                    ],
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(side: const BorderSide(color: Colors.green)),
                onPressed: widget.closePressed,
                child: const Text("Salva", style: TextStyle(color: Colors.green),),
              ),
              const SizedBox(width: 8,),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.red)),
                child: IconButton(
                  padding: const EdgeInsets.all(3),
                  visualDensity: VisualDensity.compact,
                  splashRadius:24 ,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: widget.closePressed,
                ),
              ),
              const SizedBox(width: 8,),
            ],
          ),
        ),
        Expanded(
          child: SettingsScroll(
            controller: _scrollController,
            darkTheme: SettingsThemeData(
              settingsListBackground: isDarkTheme(context)
                  ? Color.alphaBlend(
                      Theme.of(context).colorScheme.surface.withAlpha(240),
                      Theme.of(context).colorScheme.primary)
                  : Theme.of(context).colorScheme.surface,
            ),
            lightTheme: const SettingsThemeData(
                settingsListBackground: Colors.transparent),
            //contentPadding: EdgeInsets.zero,
            platform: DevicePlatform.web,
            sections: [
              ...productionSections,
            ],
          ),
        ),
      ],
    );*/
  }

  Widget _okCancel() {
    return OkCancel(
        // okFocusNode: _saveFocusNode,
        onCancel: () {
      Navigator.of(context).maybePop();
    },
        onSave: () async {
          widget.savePressed?.call();
          Navigator.of(context).pop(selectedSettings);
        });
  }

  Widget _checkBoxTile(MachineSetting item) {
    ///check box
    List<String> valuesToSelect = <String>[];

    if (item.params != null) {
      valuesToSelect = item.params!.split('|');
    }

    bool initialValue = valuesToSelect.isEmpty
        ? item.value.toLowerCase() == "vero"
            ? true
            : false
        : item.value.toLowerCase() == valuesToSelect[0].toLowerCase()
            ? true
            : false;

    GlobalKey<MultiSettingTileState>? key = categorySettingsList
        .firstWhereOrNull(
            (element) => element.fieldId == item.vmcSettingFieldId)
        ?.key as GlobalKey<MultiSettingTileState>?;
    return MultiSettingTile.checkBoxTile(
        key: key,
        title: item.name ?? '',
        description: item.description,
        showCheck: false,
        user: item.user != null
            ? "Modificato da ${item.user!.name} ${item.user!.surname} il ${item.date}"
            : null,
        icon: _iconButton(onPressed: () => _editMachineSetting(item)),
        initialValue: initialValue,
        textWhenTrue: valuesToSelect.isEmpty ? 'Vero' : valuesToSelect[0],
        textWhenFalse: valuesToSelect.isEmpty ? 'Falso' : valuesToSelect[1],
        onToggle: (value) {
          for (int index = 0; index < selectedSettings!.length; index++) {
            if (selectedSettings![index].vmcSettingFieldId ==
                item.vmcSettingFieldId) {
              String trueString = 'Vero';
              String falseString = 'Falso';
              if (valuesToSelect.isNotEmpty) {
                trueString = valuesToSelect[0];
                falseString = '';
              }
              Future.sync(
                  () => initializeDateFormatting(Intl.defaultLocale!, null));
              ApplicationUser? currentUser =
                  ApplicationUser.getUserFromSetting();
              selectedSettings![index] = selectedSettings![index].copyWith(
                  value: value ? trueString : falseString,
                  applicationUserId: currentUser?.applicationUserId ?? 0,
                  user: currentUser,
                  date: DateFormat().format(DateTime.now()));
              _multiSelectorKey.currentState?.setState(() {
                _multiSelectorKey.currentState?.selectorData =
                    _getSelectorData(direction: Axis.vertical);
              });

              key?.currentState?.setState(() {
                //aggiornare user
                key.currentState?.currentUser = currentUser != null
                    ? "Modificato da ${currentUser.name} ${currentUser.surname} il ${DateFormat().format(DateTime.now())}"
                    : null;
              });
              break;
            }
          }
          editState = true;
        },
        defaultTextColor: isDarkTheme(context)
            ? darkTileDescriptionTextColor
            : lightTileDescriptionTextColor);
  }

  Widget _iconButton({VoidCallback? onPressed}) {
    return IconButton(
        alignment: Alignment.topLeft,
        icon: const Icon(Icons.settings),
        splashRadius: isLittleWidth() ? 8 : null,
        iconSize: isLittleWidth() ? 16 : null,
        padding: isLittleWidth()
            ? const EdgeInsets.all(0)
            : const EdgeInsets.all(8.0),
        constraints: isLittleWidth()
            ? const BoxConstraints(maxWidth: 16, maxHeight: 16)
            : null,
        onPressed: onPressed);
  }

  Widget _imageTile(MachineSetting item) {
/*
    ///check box
    List<String> valuesToSelect = <String>[];
    List<String> valueSplitted = <String>[];
    if (item.params != null) {
      valuesToSelect = item.params!.split('|');
    }
*/

    GlobalKey<MultiSettingTileState>? key = categorySettingsList
        .firstWhereOrNull(
            (element) => element.fieldId == item.vmcSettingFieldId)
        ?.key as GlobalKey<MultiSettingTileState>?;
    return MultiSettingTile.image(
      key: key,
      title: item.name ?? '',
      hint: item.name ?? '',
      description: item.description,
      showCheck: false,
      user: item.user != null
          ? "Modificato da ${item.user!.name} ${item.user!.surname} il ${item.date}"
          : null,
      icon: _iconButton(onPressed: () => _editMachineSetting(item)),
      initialValue:
          item.images?.map((e) => e.toItemPicture()).toList(growable: false),
      defaultTextColor: isDarkTheme(context)
          ? darkTileDescriptionTextColor
          : lightTileDescriptionTextColor,
      falseValue: '',
      onImagesChanged: (List<ItemPicture> list) async {
        print("onImagesChanged - list.lenght: ${list.length}");
        print(
            "onImagesChanged - list(mediaId!=-1).lenght: ${list.where((element) => element.mediaId != -1).length}");
        for (int index = 0; index < selectedSettings!.length; index++) {
          if (selectedSettings![index].vmcSettingFieldId ==
              item.vmcSettingFieldId) {
            Future.sync(
                () => initializeDateFormatting(Intl.defaultLocale!, null));
            ApplicationUser? currentUser = ApplicationUser.getUserFromSetting();
            selectedSettings![index] = selectedSettings![index].copyWith(
                applicationUserId: currentUser?.applicationUserId ?? 0,
                images: list
                    .where((element) => element.mediaId != -1)
                    .map((e) => e.toMachineSettingPicture())
                    .toList(growable: false),
                user: currentUser,
                date: DateFormat().format(DateTime.now()));
            _multiSelectorKey.currentState?.setState(() {
              _multiSelectorKey.currentState?.selectorData =
                  _getSelectorData(direction: Axis.vertical);
            });

            key?.currentState?.setState(() {
              //aggiornare user
              key.currentState?.currentUser = currentUser != null
                  ? "Modificato da ${currentUser.name} ${currentUser.surname} il ${DateFormat().format(DateTime.now())}"
                  : null;
            });

            break;
          }
        }
        editState = true;
      },
      onImagesLoaded: (list) {
        print("onImageaLoaded: ${list.length}");
      },
    );
  }

  Widget _fileTile(MachineSetting item) {
    GlobalKey<MultiSettingTileState>? key = categorySettingsList
        .firstWhereOrNull(
            (element) => element.fieldId == item.vmcSettingFieldId)
        ?.key as GlobalKey<MultiSettingTileState>?;
    return MultiSettingTile.file(
      key: key,
      title: item.name ?? '',
      hint: item.name ?? '',
      description: item.description,
      showCheck: false,
      user: item.user != null
          ? "Modificato da ${item.user!.name} ${item.user!.surname} il ${item.date}"
          : null,
      icon: _iconButton(onPressed: () => _editMachineSetting(item)),
      initialValue:
          item.files?.map((e) => e.toMediaItem()).toList(growable: false),
      defaultTextColor: isDarkTheme(context)
          ? darkTileDescriptionTextColor
          : lightTileDescriptionTextColor,
      falseValue: '',
      onMediasChanged: (List<MediaItem> list) async {
        print("onMediasChanged - list.lenght: ${list.length}");
        print(
            "onMediasChanged - list(mediaId!=-1).lenght: ${list.where((element) => element.mediaId != -1).length}");
        for (int index = 0; index < selectedSettings!.length; index++) {
          if (selectedSettings![index].vmcSettingFieldId ==
              item.vmcSettingFieldId) {
            Future.sync(
                () => initializeDateFormatting(Intl.defaultLocale!, null));
            ApplicationUser? currentUser = ApplicationUser.getUserFromSetting();
            selectedSettings![index] = selectedSettings![index].copyWith(
                applicationUserId: currentUser?.applicationUserId ?? 0,
                files: list
                    .where((element) => element.mediaId != -1)
                    .map((e) => e.toMachineSettingFile())
                    .toList(growable: false),
                user: currentUser,
                date: DateFormat().format(DateTime.now()));
            _multiSelectorKey.currentState?.setState(() {
              _multiSelectorKey.currentState?.selectorData =
                  _getSelectorData(direction: Axis.vertical);
            });

            key?.currentState?.setState(() {
              //aggiornare user
              key.currentState?.currentUser = currentUser != null
                  ? "Modificato da ${currentUser.name} ${currentUser.surname} il ${DateFormat().format(DateTime.now())}"
                  : null;
            });

            break;
          }
        }
        editState = true;
      },
      onMediasLoaded: (list) {
        print("onMediasLoaded: ${list.length}");
      },
    );
  }

  Future<String?>? encodeBase64(Uint8List bytes) {
    try {
      return compute(base64Encode, bytes);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Widget _upDownTile(MachineSetting item) {
    ///UpDown
    List<String> valuesToSelect = <String>[];
    if (item.params != null) {
      ///min|max|step|fractionDigits
      valuesToSelect = item.params!.split('|');
    }
    GlobalKey<MultiSettingTileState>? key = categorySettingsList
        .firstWhereOrNull(
            (element) => element.fieldId == item.vmcSettingFieldId)
        ?.key as GlobalKey<MultiSettingTileState>;
    return MultiSettingTile.upDown(
      key: categorySettingsList
          .firstWhereOrNull(
              (element) => element.fieldId == item.vmcSettingFieldId)
          ?.key,
      title: item.name ?? '',
      hint: item.name ?? '',
      showCheck: false,
      description: item.description,
      initialValue: item.value.isEmpty ? "0" : item.value,
      quarterTurns: 0,
      decimals: 0,
      user: item.user != null
          ? "Modificato da ${item.user!.name} ${item.user!.surname} il ${item.date}"
          : null,
      icon: _iconButton(onPressed: () => _editMachineSetting(item)),
      min: valuesToSelect.isEmpty
          ? 0
          : double.parse(
              valuesToSelect[0].isNotEmpty ? valuesToSelect[0] : '0.0'),
      step: valuesToSelect.isEmpty
          ? 1
          : double.parse(
              valuesToSelect[2].isNotEmpty ? valuesToSelect[2] : '0.0'),
      max: valuesToSelect.isEmpty
          ? 1000
          : double.parse(
              valuesToSelect[1].isNotEmpty ? valuesToSelect[1] : '0.0'),
      onResult: (String? result) {
        if (result != null) {
          result = double.parse(result).toStringAsFixed(0);
          Future.sync(
              () => initializeDateFormatting(Intl.defaultLocale!, null));
          ApplicationUser? currentUser = ApplicationUser.getUserFromSetting();

          for (int index = 0; index < selectedSettings!.length; index++) {
            if (selectedSettings![index].vmcSettingFieldId ==
                item.vmcSettingFieldId) {
              setState(() {
                selectedSettings![index] = selectedSettings![index].copyWith(
                    value: result,
                    applicationUserId: currentUser?.applicationUserId ?? 0,
                    user: currentUser,
                    date: DateFormat().format(DateTime.now()));
              });
              _multiSelectorKey.currentState?.setState(() {
                _multiSelectorKey.currentState?.selectorData =
                    _getSelectorData(direction: Axis.vertical);
              });

              key.currentState?.setState(() {
                //aggiornare user
                key.currentState?.currentUser = currentUser != null
                    ? "Modificato da ${currentUser.name} ${currentUser.surname} il ${DateFormat().format(DateTime.now())}"
                    : null;
                key.currentState?.currentValue = result;
              });
              break;
            }
          }
        }
        editState = true;
        /*if (result != null) {

          for (int index = 0; index < selectedSettings!.length; index++) {
            if (selectedSettings![index].vmcSettingFieldId ==
                item.vmcSettingFieldId) {
              setState(() {
                selectedSettings![index] = selectedSettings![index].copyWith(
                    value: double.parse(result).toStringAsFixed(
                        valuesToSelect.isEmpty
                            ? 0
                            : int.parse(valuesToSelect[3])));
              });
              break;
            }
          }
        }
        editState = true;*/
      },
    );
  }

  Widget _selectionTile(MachineSetting item) {
    ///Selection

    if (item.params != null) {
      List<String> valuesToSelect = <String>[];
      valuesToSelect = item.params!.split('|');
      GlobalKey<MultiSettingTileState>? key = categorySettingsList
          .firstWhereOrNull(
              (element) => element.fieldId == item.vmcSettingFieldId)
          ?.key as GlobalKey<MultiSettingTileState>;
      return MultiSettingTile.selection(
        key: key,
        title: item.name ?? '',
        hint: item.name,
        description: item.description,
        showCheck: false,
        falseValue: '',
        user: item.user != null
            ? "Modificato da ${item.user!.name} ${item.user!.surname} il ${item.date}"
            : null,
        icon: _iconButton(onPressed: () => _editMachineSetting(item)),
        initialValue: item.value.isEmpty ? '' : item.value,
        selectionChildren: [
          ...valuesToSelect.map((e) {
            return SimpleDialogOption(
                onPressed: () {
                  for (int index = 0;
                      index < selectedSettings!.length;
                      index++) {
                    if (selectedSettings![index].vmcSettingFieldId ==
                        item.vmcSettingFieldId) {
                      /*setState(() {
                        selectedProductions![index] =
                            selectedProductions![index]
                                .copyWith(value: e);
                        key.currentState?.currentValue=e;
                      });*/

                      Future.sync(() =>
                          initializeDateFormatting(Intl.defaultLocale!, null));
                      ApplicationUser? currentUser =
                          ApplicationUser.getUserFromSetting();

                      String? value = e;
                      selectedSettings![index] = selectedSettings![index]
                          .copyWith(
                              value: value,
                              applicationUserId:
                                  currentUser?.applicationUserId ?? 0,
                              user: currentUser,
                              date: DateFormat().format(DateTime.now()));

                      _multiSelectorKey.currentState?.setState(() {
                        _multiSelectorKey.currentState?.selectorData =
                            _getSelectorData(direction: Axis.vertical);
                      });

                      key.currentState?.setState(() {
                        //aggiornare user
                        key.currentState?.currentUser = currentUser != null
                            ? "Modificato da ${currentUser.name} ${currentUser.surname} il ${DateFormat().format(DateTime.now())}"
                            : null;
                        key.currentState?.currentValue = value;
                      });
                      break;
                    }
                  }
                  editState = true;
                  if (!mounted) return;
                  Navigator.of(context).maybePop(item);
                },
                //
                child: Row(
                  children: [
                    /*type.toIcon(),
                      const SizedBox(
                      width: 8,
                      ),*/
                    Text(e),
                  ],
                ));
          })
        ],
      );
    }
    return const SizedBox();
  }

  Widget _textInputTile(MachineSetting item) {
    ///TextInput
    GlobalKey<MultiSettingTileState> key = categorySettingsList
        .firstWhereOrNull(
            (element) => element.fieldId == item.vmcSettingFieldId)
        ?.key as GlobalKey<MultiSettingTileState>;
    return MultiSettingTile.textInputTile(
      key: categorySettingsList
          .firstWhereOrNull(
              (element) => element.fieldId == item.vmcSettingFieldId)
          ?.key,
      title: item.name ?? '',
      description: item.description,
      showCheck: false,
      user: item.user != null
          ? "Modificato da ${item.user!.name} ${item.user!.surname} il ${item.date}"
          : null,
      onResult: (String? result) {
        if (result != null) {
          Future.sync(
              () => initializeDateFormatting(Intl.defaultLocale!, null));
          ApplicationUser? currentUser = ApplicationUser.getUserFromSetting();

          for (int index = 0; index < selectedSettings!.length; index++) {
            if (selectedSettings![index].vmcSettingFieldId ==
                item.vmcSettingFieldId) {
              setState(() {
                selectedSettings![index] = selectedSettings![index].copyWith(
                    value: result,
                    applicationUserId: currentUser?.applicationUserId ?? 0,
                    user: currentUser,
                    date: DateFormat().format(DateTime.now()));
              });
              _multiSelectorKey.currentState?.setState(() {
                _multiSelectorKey.currentState?.selectorData =
                    _getSelectorData(direction: Axis.vertical);
              });

              key.currentState?.setState(() {
                //aggiornare user
                key.currentState?.currentUser = currentUser != null
                    ? "Modificato da ${currentUser.name} ${currentUser.surname} il ${DateFormat().format(DateTime.now())}"
                    : null;
                key.currentState?.currentValue = result;
              });
              break;
            }
          }
        }
        editState = true;
      },
      initialValue: item.value.isEmpty ? '' : item.value,
      icon: _iconButton(onPressed: () => _editMachineSetting(item)),
    );
  }

  Widget _settingSettingTile(MachineSetting item) {
    if (selectedSettings != null) {
      switch (MachineSettingItemType.fromType(item.type!)) {
        case MachineSettingItemType.checkbox:
          return _checkBoxTile(item);
        case MachineSettingItemType.image:
          return _imageTile(item);
        case MachineSettingItemType.upDown:
          return _upDownTile(item);

        case MachineSettingItemType.selection:
          return _selectionTile(item);
        case MachineSettingItemType.file:
          return _fileTile(item);
        case MachineSettingItemType.textInput:
        default:
          return _textInputTile(item);
      }
    }
    return getCustomSettingTile(child: const Text('Errore'));
  }

  /* _editProductionSetting(MachineProduction item) async {
    if (selectedProductions != null) {
      dynamic editedItem = await VmcProductionFieldsActions.openDetail(
          context, VmcProductionField.fromMachineProduction(item));

      if (editedItem is VmcProductionField) {
        for (int index = 0; index < selectedProductions!.length; index++) {
          MachineProduction candidateItem =
          selectedProductions!.elementAt(index);
          if (candidateItem.vmcProductionId == item.vmcProductionId) {
            MachineProduction editedSetting =
            MachineProduction.fromVmcProductionField(
                editedItem,
                ApplicationUser.getUserFromSetting()?.applicationUserId,
                ApplicationUser.getUserFromSetting())
                .copyWith(
                machine: item.machine,
                vmcProductionFieldId: item.vmcProductionFieldId,
                vmcProductionId: item.vmcProductionId,
                value: item.value,
                machineProductionId: item.machineProductionId,
                matricola: item.matricola);
            editedSetting =
                editedSetting.copyWith(json: editedSetting.toJson());
            setState(() {
              selectedProductions![index] = editedSetting;
            });
            break;
          }
        }
      }
    }
  }
*/
  EdgeInsets getPadding() {
    if (isLittleWidth() == false) {
      return const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
    } else {
      return const EdgeInsets.symmetric(vertical: 4, horizontal: 0);
    }
  }

  Widget _settingFieldsDropDownWidget() {
    return Padding(
      padding: getPadding(),
      child: DropdownSearch<MapSettingKey>(
        enabled: true,
        popupProps: PopupPropsMultiSelection.dialog(
          containerBuilder: (context, child) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: child);
          },
          itemBuilder: (context, item, isSelected) {
            return getMachineSettingItem(item.machineSetting,
                context: context, showClearButton: false);
          },
          scrollbarProps: const ScrollbarProps(thickness: 0),
          dialogProps: DialogProps(
            backgroundColor: getAppBackgroundColor(context),
          ),
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              autofocus: isWindows || isWindowsBrowser ? true : false,
              //    controller: settingFieldsController,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: "Cerca",
              )),
          emptyBuilder: (context, searchEntry) =>
              const Center(child: Text('Nessun risultato')),
        ),
        //popupBackgroundColor: getAppBackgroundColor(context),

        compareFn: (item, selectedItem) => item.fieldId == selectedItem.fieldId,
        //showClearButton: true,
        clearButtonProps: const ClearButtonProps(isVisible: true),
        itemAsString: (MapSettingKey? c) => c?.machineSetting.name ?? 'no name',

        dropdownBuilder: (context, MapSettingKey? item) {
          if (item != null) {
            return getMachineSettingItem(item.machineSetting,
                context: context, showClearButton: false);
          } else {
            return const Text("Seleziona un campo");
          }
        },
        selectedItem: _selectedMapSettingKey,
        onChanged: (MapSettingKey? newValue) async {
          if (newValue != null && isLittleWidth()) {
            Navigator.of(context).maybePop();
          }
          setState(() {
            _selectedMapSettingKey = newValue;
          });
          if (_selectedMapSettingKey != null) {
            //RenderObject? renderObj = _selectedMapSettingKey?.key.currentContext?.findRenderObject();
            Scrollable.ensureVisible(
                _selectedMapSettingKey!.key.currentContext!,
                duration: const Duration(milliseconds: 500));
            Timer(const Duration(milliseconds: 500), () async {
              await tapTargetWithEffect(_selectedMapSettingKey!.key);
            });
            //await Future.delayed(const Duration(milliseconds: 1500),

            //);
            /*if (renderObj!=null) {
              await scrollTo(renderObj);
            }*/
          }
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            //enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            labelText: 'Cerca impostazione',
            hintText: 'Seleziona un campo',
            isDense: true,
          ),
        ),

        validator: (item) {
          return null;
        },
        items: categorySettingsList,
        filterFn: (MapSettingKey? item, String? filter) {
          String json = item?.fieldName ?? '';
          String newString = json.removePunctuation();
          if (kDebugMode) {
            print(newString);
          }
          String filterString = filter?.removePunctuation() ?? '';
          return newString.toLowerCase().contains(filterString.toLowerCase());
        },
      ),
    );
  }

  Map<String, GlobalKey> _getMapIndexKey() {
    Map<String, GlobalKey> mapIndexKey = {};
    mapIndexKey.addAll(categoryKeysMap);
    return mapIndexKey;
  }

  Future _scrollToCurrentNavStatus() async {
    GlobalKey? key;

    Map<String, GlobalKey> mapIndexKey = _getMapIndexKey();

    if (toNavStatus >= 0 && toNavStatus < mapIndexKey.entries.length) {
      key = mapIndexKey.entries.elementAt(toNavStatus).value;
      if (key.currentContext != null) {
        await Scrollable.ensureVisible(key.currentContext!,
            duration: const Duration(milliseconds: 500));
      }
    }
  }

  Widget _multiSelectorWidget({Axis direction = Axis.horizontal}) {
    if (isLittleWidth()) {
      _multiSelectorKey.currentState?.selectorData =
          _getSelectorData(direction: direction);
    }

/*    return MultiSelectorEx(
      key: _multiSelectorKey,
      onPressed: (index) async {
        statNavStatus = index;
        */ /*setState(() {
                        statNavStatus = index;
                    });*/ /*
        _scrollToCurrentStatus();
        //widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
      },
      status: statNavStatus,
      selectorData: _getSelectorData(),
    );*/
    return MultiSelectorEx(
      key: _multiSelectorKey,
      direction: direction,
      onPressed: (index) async {
        if (isLittleWidth()) {
          if (!mounted) return;
          Navigator.of(context).pop();
        }

        toNavStatus = index;
        //statNavStatus = index;
        /*setState(() {
                        statNavStatus = index;
                    });*/
        await _scrollToCurrentNavStatus(); //_scrollToCurrentStatus();
        statNavStatus = index;
        _multiSelectorKey.currentState?.setState(() {
          _multiSelectorKey.currentState?.status = statNavStatus;
        });

        //widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
      },
      status: statNavStatus,
      selectorData: _selectorData!,
    );
  }

  void _scrollToCurrentStatus() async {
    if (statNavStatus >= 0) {
      RenderObject? renderObj;
      renderObj = categoryKeysMap[categoryKeysMap.keys.elementAt(statNavStatus)]
          ?.currentContext
          ?.findRenderObject();
      if (renderObj != null) {
        //_mainScrollController.jumpTo(_mainScrollController.offset);
        await scrollTo(renderObj);
      }
    }
  }

  Future scrollTo(RenderObject renderObj) async {
    // _mainScrollController.removeListener(scrollListener);
    await _scrollController.position.ensureVisible(renderObj,
        alignment: 0.0,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOut,
        targetRenderObject: renderObj,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
    // _mainScrollController.addListener(scrollListener);
  }

  List<SelectorData> _getSelectorData({Axis direction = Axis.horizontal}) {
    if (selectedSettings != null) {
      Map<String, List<MachineSetting>> map =
          selectedSettings!.groupBy((p0) => p0.categoryName ?? '');
      List<SelectorData> result = <SelectorData>[];
      for (var element in map.keys) {
        result.add(getSelectorDataItem(
          text: element,
          direction: direction,
          color: Color(int.parse(selectedSettings!
                  .firstWhere((selSet) => selSet.categoryName == element)
                  .categoryColor!))
              .withAlpha(150),
        ));
      }
      return result;
    }
    return <SelectorData>[];
  }

  SelectorData getSelectorDataItem({
    required String text,
    Axis direction = Axis.horizontal,
    required Color color,
    double? percentage,
  }) {
    return SelectorData(
        periodString: text,
        selectedColor: color,
        percentage: percentage,
        child: Container(
          constraints: isLittleWidth()
              ? const BoxConstraints(
                  maxHeight: 50, minWidth: 250, maxWidth: 250)
              : const BoxConstraints(
                  maxHeight: 50, minWidth: 290, maxWidth: 290),
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            /*  const SizedBox(width: 8),
                    const Icon(Icons.category),*/
            const SizedBox(width: 8),
            Flexible(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: direction == Axis.horizontal
                    ? Text(text,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(letterSpacing: 0, wordSpacing: 0))
                    : Text(text,
                        style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            const SizedBox(width: 8),
            /*Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: direction == Axis.horizontal
                    ? Text(text,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(letterSpacing: 0, wordSpacing: 0))
                    : Text('${percentage!.round()}%',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            const SizedBox(width: 8),*/
          ]),
        ));
  }

  Map? categoriesMap;

  void scrollListener() {
    categoriesMap = selectedSettings?.groupBy((p0) => p0.categoryName);

    bool isNavigationOnTop = MediaQuery.of(context).size.width <= 800;

    Map<String, GlobalKey> mapIndexKey = _getMapIndexKey();

    ///se esistono, aggiungo alle chiavi da navigare i relativi boxes

    for (var item in mapIndexKey.keys) {
      addToBoxes(mapIndexKey[item]!);
    }

    int index = -1;
    int nCycle = 0;

    double dy =
        0; //(_reportStatBlocKey.currentContext!.findRenderObject()! as RenderBox).localToGlobal(Offset.zero).dy + (_isTinyWidth() ? 66 : 0);

    RenderBox? currentBox = context.findRenderObject() as RenderBox?;
    Offset mainBoxOffset =
        currentBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    RenderBox? currentDialogNavigationBox =
        _dialogNavigationKey.currentContext?.findRenderObject() as RenderBox?;

    Offset currentDialogNavigationBoxOffset =
        currentDialogNavigationBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    //print("Dy: $dy");
    //print("mainBoxOffset.dy: ${mainBoxOffset.dy+4}");
    dy = (mainBoxOffset.dy +
        (isNavigationOnTop
            ? (currentDialogNavigationBox?.size.height ?? 0)
            : 0));

    for (MapEntry entry in _boxes.entries) {
      if ((entry.value.localToGlobal(Offset.zero).dy - dy) < 10) {
        index = nCycle;
      } else {
        if (nCycle == 0) {
          if ((entry.value.localToGlobal(Offset.zero).dy - dy) > 100) {
            index = -1;
          }
        }
      }
      nCycle++;
    }

    /*if (_scrollController.position.pixels<=_scrollController.position.minScrollExtent){
      title = "${widget.title ?? ''} - ${mapIndexKey.keys.elementAt(0)}";
      _dialogTitleKey.currentState?.setState(() {
        _dialogTitleKey.currentState?.title = title;
      });
    } else if (_scrollController.position.pixels>=_scrollController.position.maxScrollExtent){
      title="${widget.title ?? ''} - ${mapIndexKey.keys.last}";
      _dialogTitleKey.currentState?.setState(() {
        _dialogTitleKey.currentState?.title = title;
      });
    } else {
      if (index == -1) {
        if (title != (widget.title ?? '')) {
          title = widget.title ?? '';
          _dialogTitleKey.currentState?.setState(() {
            _dialogTitleKey.currentState?.title = title;
          });
        }
      } else {
        if (index < mapIndexKey.length) {
          if (index < mapIndexKey.keys.length) {
            int localIndex = index - firstHeaderSectionsMap!.length;
            String desiredTitle = "";
            if (localIndex < 0 || localIndex >= categoriesMap!.length) {
              desiredTitle =
              "${widget.title ?? ''} - ${mapIndexKey.keys.elementAt(index)}";
            } else {
              desiredTitle =
              "${widget.title ?? ''} - ${categoriesMap!.keys.elementAt(
                  localIndex)}";
            }
            if (title != desiredTitle) {
              title = desiredTitle;
              _dialogTitleKey.currentState?.setState(() {
                _dialogTitleKey.currentState?.title = title;
              });
            }
          }
        }
      }

    }*/

    if (statNavStatus != index) {
      statNavStatus = index;

      if (index != -1) {
        _multiSelectorKey.currentState?.setState(() {
          _multiSelectorKey.currentState?.status = index;
        });
      }
    }
    // print("DashboardContainer scrollPosition ${_mainScrollController.position.toString()}");
  }

  ///se esiste, aggiungo alle chiavi da navigare la chiave e il box relativo
  void addToBoxes(GlobalKey key) {
    if (!_boxes.containsKey(key)) {
      var box = key.currentContext?.findRenderObject();
      if (box != null && box is RenderBox) {
        _boxes.addAll({key: box});
      }
    }
  }

  _editMachineSetting(MachineSetting item) async {
    dynamic editedItem = await VmcSettingFieldsActions.openDetail(
        context, VmcSettingField.fromMachineSetting(item));

    if (editedItem is VmcSettingField) {
      for (int index = 0; index < selectedSettings!.length; index++) {
        MachineSetting candidateItem = selectedSettings!.elementAt(index);
        if (candidateItem.machineSettingId == item.machineSettingId) {
          MachineSetting editedSetting =
              MachineSetting.fromVmcSettingField(editedItem).copyWith(
                  machine: item.machine,
                  vmcSettingFieldId: item.vmcSettingFieldId,
                  vmcSettingId: item.vmcSettingId,
                  value: item.value,
                  machineSettingId: item.machineSettingId,
                  matricola: item.matricola);
          editedSetting = editedSetting.copyWith(json: editedSetting.toJson());
          setState(() {
            selectedSettings![index] = editedSetting;
          });
          break;
        }
      }
    }
  }
}

enum MachineSettingItemType {
  textInput(0),
  selection(1),
  upDown(2),
  image(3),
  checkbox(4),
  file(5);

  final int type;

  const MachineSettingItemType(this.type);

  factory MachineSettingItemType.fromType(int type) {
    return values.firstWhere((e) => e.type == type);
  }
}

/*
import 'dart:async';

import "package:collection/collection.dart";
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/master-data/machines/machine_edit_screen.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class MachineSettingsView extends StatefulWidget {
  final Machine machine;
  final VoidCallback closePressed;

  const MachineSettingsView(
      {required this.machine, required this.closePressed, Key? key})
      : super(key: key);

  @override
  MachineSettingsViewState createState() => MachineSettingsViewState();
}

class MachineSettingsViewState extends State<MachineSettingsView> {
  Map<VmcSettingCategory, List<MachineSetting>>? categories;
  List<SettingsScrollSection> settingsSections = <SettingsScrollSection>[];
  List<MachineSetting>? selectedSettings = <MachineSetting>[];
  final Map<String, GlobalKey> categoryKeysMap = <String, GlobalKey>{};
  final List<MapSettingKey> categorySettingsList = <MapSettingKey>[];
  final ScrollController _scrollController =
      ScrollController(debugLabel: 'machineSettingsViewScrollController');
  MapSettingKey? _selectedMapSettingKey;

  final GlobalKey<MultiSelectorExState> _multiSelectorKey =
      GlobalKey<MultiSelectorExState>(debugLabel: '_multiSelectorKey');
  int statNavStatus = 0;

  @override
  void initState() {
    super.initState();
    selectedSettings = widget.machine.machineSettings;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  createSettingsSections() {
    settingsSections.clear();

    if (selectedSettings != null) {
      ///ottengo le categorie
      categories = selectedSettings?.groupBy((m) => VmcSettingCategory(
          vmcSettingCategoryCode: m.categoryCode,
          name: m.categoryName,
          color: m.categoryColor));

      if (categories != null) {
        for (VmcSettingCategory element in categories!.keys) {
          ///creo le chiavi per le categorie
          if (!categoryKeysMap.containsKey(element.vmcSettingCategoryCode)) {
            categoryKeysMap.addAll({
              element.vmcSettingCategoryCode!:
                  GlobalKey(debugLabel: element.vmcSettingCategoryCode)
            });
          }

          ///separo le impostazioni per categoria
          List<MachineSetting> categorySettings = <MachineSetting>[];
          for (MachineSetting item in selectedSettings!) {
            if (categorySettingsList.firstWhereOrNull(
                    (element) => element.fieldId == item.vmcSettingFieldId) ==
                null) {
              categorySettingsList.add(MapSettingKey(
                  fieldId: item.vmcSettingFieldId,
                  machineSetting: item,
                  fieldName: item.name ?? '',
                  key: GlobalKey(debugLabel: item.name ?? '')));
            }

            if (item.categoryCode == element.vmcSettingCategoryCode) {
              categorySettings.add(item);
            }
          }

          ///creo le sezioni
          settingsSections.add(SettingsScrollSection(
            key: categoryKeysMap[element.vmcSettingCategoryCode],
            color: element.color != null
                ? isDarkTheme(context)
                    ? Color.alphaBlend(
                        Color(int.parse(element.color!)).withAlpha(200),
                        Color.alphaBlend(
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withAlpha(240),
                            Theme.of(context).colorScheme.primary))
                    : Color.alphaBlend(
                        Color(int.parse(element.color!)).withAlpha(200),
                        Theme.of(context).colorScheme.surface)
                : null,
            //element.color!=null ? Color(int.parse(element.color!)).withAlpha(80) : null,
            title: Text(element.name!),
            tiles: categorySettings.isNotEmpty
                ? List.generate(
                    categorySettings.length,
                    (index) => _settingSettingTile(categorySettings[index]),
                  )
                : List.generate(
                    1,
                    (index) => getCustomSettingTile(
                        child: const Text('Nessuna impostazione selezionata'))),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedSettings != null && settingsSections.isEmpty) {
      createSettingsSections();
    }

    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IntrinsicWidth(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _multiSelectorWidget(),
                      )),
                      IntrinsicWidth(child: _settingsFieldsDropDownWidget()),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.closePressed,
              ),
            ],
          ),
        ),
        Expanded(
          child: SettingsScroll(
            controller: _scrollController,
            darkTheme: SettingsThemeData(
              settingsListBackground: isDarkTheme(context)
                  ? Color.alphaBlend(
                      Theme.of(context).colorScheme.surface.withAlpha(240),
                      Theme.of(context).colorScheme.primary)
                  : Theme.of(context).colorScheme.surface,
            ),
            lightTheme: const SettingsThemeData(
                settingsListBackground: Colors.transparent),
            //contentPadding: EdgeInsets.zero,
            platform: DevicePlatform.web,
            sections: [
              ...settingsSections,
            ],
          ),
        ),
      ],
    );
  }

  SettingsTile _settingSettingTile(MachineSetting item) {
    if (selectedSettings != null) {
      switch (item.type) {
        case 6:

          ///double input
          break;
        case 5:

          ///int input
          break;
        case 4:

          ///check box
          List<String> valuesToSelect = <String>[];

          if (item.params != null) {
            valuesToSelect = item.params!.split('|');
          }

          return getSwitchSettingTile(
              readOnly: true,
              key: categorySettingsList
                  .firstWhereOrNull(
                      (element) => element.fieldId == item.vmcSettingFieldId)
                  ?.key,
              title: item.name ?? '',
              description: item.description,
              icon: const Icon(Icons.settings),
              initialValue: valuesToSelect.isEmpty
                  ? item.value.toLowerCase() == "vero"
                      ? true
                      : false
                  : item.value.toLowerCase() == valuesToSelect[0].toLowerCase()
                      ? true
                      : false,
              textWhenTrue: valuesToSelect.isEmpty ? 'Vero' : valuesToSelect[0],
              textWhenFalse:
                  valuesToSelect.isEmpty ? 'Falso' : valuesToSelect[1],
              onToggle: (value) {
                for (int index = 0; index < selectedSettings!.length; index++) {
                  if (selectedSettings![index].vmcSettingFieldId ==
                      item.vmcSettingFieldId) {
                    setState(() {
                      String trueString = 'Vero';
                      String falseString = 'Falso';
                      if (valuesToSelect.isNotEmpty) {
                        trueString = valuesToSelect[0];
                        falseString = valuesToSelect[1];
                      }
                      selectedSettings![index] = selectedSettings![index]
                          .copyWith(value: value ? trueString : falseString);
                    });
                    break;
                  }
                }
              },
              defaultTextColor: isDarkTheme(context)
                  ? darkTileDescriptionTextColor
                  : lightTileDescriptionTextColor);

        case 3:

          ///Image
          break;
        case 2:

          ///UpDown

          List<String> valuesToSelect = <String>[];
          if (item.params != null) {
            ///min|max|step|fractionDigits
            valuesToSelect = item.params!.split('|');
          }
          return getUpDownSettingTile(
            readOnly: true,
            key: categorySettingsList
                .firstWhereOrNull(
                    (element) => element.fieldId == item.vmcSettingFieldId)
                ?.key,
            title: item.name ?? '',
            hint: item.name ?? '',
            description: item.description,
            initialValue: item.value.isEmpty ? "0" : item.value,
            quarterTurns: 0,
            icon: const Icon(Icons.settings),
            min: valuesToSelect.isEmpty ? 0 : double.parse(valuesToSelect[0]),
            step: valuesToSelect.isEmpty ? 1 : double.parse(valuesToSelect[2]),
            max:
                valuesToSelect.isEmpty ? 1000 : double.parse(valuesToSelect[1]),
            onResult: (String? result) {
              if (result != null) {
                for (int index = 0; index < selectedSettings!.length; index++) {
                  if (selectedSettings![index].vmcSettingFieldId ==
                      item.vmcSettingFieldId) {
                    setState(() {
                      selectedSettings![index] = selectedSettings![index]
                          .copyWith(
                              value: double.parse(result).toStringAsFixed(
                                  valuesToSelect.isEmpty
                                      ? 0
                                      : int.parse(valuesToSelect[3])));
                    });
                    break;
                  }
                }
              }
            },
          );
        case 1:

          ///Selection

          if (item.params != null) {
            List<String> valuesToSelect = <String>[];
            valuesToSelect = item.params!.split('|');
            return getSelectionSettingTile(
              readOnly: true,
              key: categorySettingsList
                  .firstWhereOrNull(
                      (element) => element.fieldId == item.vmcSettingFieldId)
                  ?.key,
              title: item.name,
              hint: item.name,
              description: item.description,
              icon: const Icon(Icons.settings),
              initialValue: item.value.isEmpty ? '' : item.value,
              children: [
                ...valuesToSelect.map((e) {
                  return SimpleDialogOption(
                      onPressed: () {
                        for (int index = 0;
                            index < selectedSettings!.length;
                            index++) {
                          if (selectedSettings![index].vmcSettingFieldId ==
                              item.vmcSettingFieldId) {
                            setState(() {
                              selectedSettings![index] =
                                  selectedSettings![index].copyWith(value: e);
                            });
                            break;
                          }
                        }

                        if (!mounted) return;
                        Navigator.of(context).maybePop();
                      },
                      //
                      child: Row(
                        children: [
                          */
/*type.toIcon(),
                      const SizedBox(
                      width: 8,
                      ),*/ /*

                          Text(e),
                        ],
                      ));
                })
              ],
            );
          }
          break;
        case 0:
        default:

          ///TextInput

          return getTextInputSettingTile(
              readOnly: true,
              key: categorySettingsList
                  .firstWhereOrNull(
                      (element) => element.fieldId == item.vmcSettingFieldId)
                  ?.key,
              title: item.name,
              hint: item.name,
              description: item.description,
              onResult: (String? result) {
                if (result != null) {
                  for (int index = 0;
                      index < selectedSettings!.length;
                      index++) {
                    if (selectedSettings![index].vmcSettingFieldId ==
                        item.vmcSettingFieldId) {
                      setState(() {
                        selectedSettings![index] =
                            selectedSettings![index].copyWith(value: result);
                      });
                      break;
                    }
                  }
                }
              },
              initialValue: item.value.isEmpty ? '' : item.value,
              icon: const Icon(Icons.settings));
      }
    }
    return getCustomSettingTile(child: const Text('Errore'));
  }

  EdgeInsets getPadding() {
    return const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
  }

  Widget _settingsFieldsDropDownWidget() {
    return Padding(
      padding: getPadding(),
      child: DropdownSearch<MapSettingKey>(
        enabled: true,
        popupProps: PopupPropsMultiSelection.dialog(
          containerBuilder: (context, child) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: child);
          },
          itemBuilder: (context, item, isSelected) {
            return getMachineSettingItem(item.machineSetting,
                context: context, showClearButton: false);
          },
          scrollbarProps: const ScrollbarProps(thickness: 0),
          dialogProps: DialogProps(
            backgroundColor: getAppBackgroundColor(context),
          ),
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              autofocus: isWindows || isWindowsBrowser ? true : false,
              //    controller: settingFieldsController,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: "Cerca",
              )),
          emptyBuilder: (context, searchEntry) =>
              const Center(child: Text('Nessun risultato')),
        ),
        //popupBackgroundColor: getAppBackgroundColor(context),

        compareFn: (item, selectedItem) => item.fieldId == selectedItem.fieldId,
        //showClearButton: true,
        clearButtonProps: const ClearButtonProps(isVisible: true),
        itemAsString: (MapSettingKey? c) => c?.machineSetting.name ?? 'no name',

        dropdownBuilder: (context, MapSettingKey? item) {
          if (item != null) {
            return getMachineSettingItem(item.machineSetting,
                context: context, showClearButton: false);
          } else {
            return const Text("Seleziona un campo");
          }
        },
        selectedItem: _selectedMapSettingKey,
        onChanged: (MapSettingKey? newValue) async {
          setState(() {
            _selectedMapSettingKey = newValue;
          });
          if (_selectedMapSettingKey != null) {
            //RenderObject? renderObj = _selectedMapSettingKey?.key.currentContext?.findRenderObject();
            Scrollable.ensureVisible(
                _selectedMapSettingKey!.key.currentContext!,
                duration: const Duration(milliseconds: 500));
            Timer(const Duration(milliseconds: 500), () async {
              await tapTargetWithEffect(_selectedMapSettingKey!.key);
            });
            //await Future.delayed(const Duration(milliseconds: 1500),

            //);
            */
/*if (renderObj!=null) {
              await scrollTo(renderObj);
            }*/ /*

          }
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            //enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            labelText: 'Cerca impostazione',
            hintText: 'Seleziona un campo',
            isDense: true,
          ),
        ),

        validator: (item) {
          return null;
        },
        items: categorySettingsList,
        filterFn: (MapSettingKey? item, String? filter) {
          String json = item?.fieldName ?? '';
          String newString = json.removePunctuation();
          if (kDebugMode) {
            print(newString);
          }
          String filterString = filter?.removePunctuation() ?? '';
          return newString.toLowerCase().contains(filterString.toLowerCase());
        },
      ),
    );
  }

  Widget _multiSelectorWidget() {
    return MultiSelectorEx(
      key: _multiSelectorKey,
      onPressed: (index) async {
        statNavStatus = index;
        */
/*setState(() {
                        statNavStatus = index;
                    });*/ /*

        _scrollToCurrentStatus();
        //widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
      },
      status: statNavStatus,
      selectorData: _getSelectorData(),
    );
  }

  void _scrollToCurrentStatus() async {
    if (statNavStatus >= 0) {
      RenderObject? renderObj;
      renderObj = categoryKeysMap[categoryKeysMap.keys.elementAt(statNavStatus)]
          ?.currentContext
          ?.findRenderObject();
      if (renderObj != null) {
        //_mainScrollController.jumpTo(_mainScrollController.offset);
        await scrollTo(renderObj);
      }
    }
  }

  Future scrollTo(RenderObject renderObj) async {
    // _mainScrollController.removeListener(scrollListener);
    await _scrollController.position.ensureVisible(renderObj,
        alignment: 0.0,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOut,
        targetRenderObject: renderObj,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
    // _mainScrollController.addListener(scrollListener);
  }

  List<SelectorData> _getSelectorData() {
    if (selectedSettings != null) {
      Map map = selectedSettings!.groupBy((p0) => p0.categoryName);
      List<SelectorData> result = <SelectorData>[];
      for (var element in map.keys) {
        result.add(
          SelectorData(
              periodString: element,
              child: const Icon(Icons.category),
              selectedColor: getMenuColor(selectedSettings!
                  .firstWhere((selSet) => selSet.categoryName == element)
                  .categoryColor)),
        );
      }
      return result;
    }
    return <SelectorData>[];
  }
}
*/
