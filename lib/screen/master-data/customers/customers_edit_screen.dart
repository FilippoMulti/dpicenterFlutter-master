import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import "package:collection/collection.dart";
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/pdf.global.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_production_picture.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/machine_setting_picture.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/vmc_production.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/machines/machine_productions_view.dart';
import 'package:dpicenter/screen/master-data/machines/machine_settings_view.dart';
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
class CustomerEditForm extends StatefulWidget {
  final Customer? element;
  final String? title;
  final List<Customer> customers;

  const CustomerEditForm(
      {Key? key, required this.element, this.title, required this.customers})
      : super(key: key);

  @override
  CustomerEditFormState createState() => CustomerEditFormState();
}

class CustomerEditFormState extends State<CustomerEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///item da creare/modificare
  Customer? element;

  List<SelectorData>? _selectorData;

  final ScrollController _scrollController =
      ScrollController(debugLabel: 'ScrollController');

  ///chiavi per i campi da compilare
  final GlobalKey _idKey = GlobalKey(debugLabel: '_idKey');
  final GlobalKey _codeKey = GlobalKey(debugLabel: '_codeKey');
  final GlobalKey _descriptionKey = GlobalKey(debugLabel: '_descriptionKey');
  final GlobalKey _pIVAKey = GlobalKey(debugLabel: '_pIVAKey');
  final GlobalKey _cFiscaleKey = GlobalKey(debugLabel: '_cFiscaleKey');
  final GlobalKey _indirizzoKey = GlobalKey(debugLabel: '_indirizzoKey');
  final GlobalKey _capKey = GlobalKey(debugLabel: '_capKey');
  final GlobalKey _comuneKey = GlobalKey(debugLabel: '_comuneKey');
  final GlobalKey _provinciaKey = GlobalKey(debugLabel: '_provinciaKey');
  final GlobalKey _nazioneKey = GlobalKey(debugLabel: '_nazioneKey');

  final GlobalKey<DialogTitleExState> _dialogTitleKey =
      GlobalKey<DialogTitleExState>(debugLabel: '_dialogTitleKey');
  final GlobalKey _dialogNavigationKey =
      GlobalKey(debugLabel: '_dialogNavigationKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pIVAController = TextEditingController();
  final TextEditingController _cFiscaleController = TextEditingController();
  final TextEditingController _indirizzoController = TextEditingController();
  final TextEditingController _capController = TextEditingController();
  final TextEditingController _comuneController = TextEditingController();
  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _nazioneController = TextEditingController();

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');

  ///stato della barra di navigazione
  int statNavStatus = -1;

  ///scorre alla posizione di toNavStatus e poi viene impostato statNavStatus
  int toNavStatus = -1;

/*
  final Map<GlobalKey, RenderBox> _boxes = <GlobalKey, RenderBox>{};
  final GlobalKey<MultiSelectorExState> _multiSelectorKey =
      GlobalKey<MultiSelectorExState>(debugLabel: '_multiSelectorKey');*/

  String title = "";

  final GlobalKey _addressSectionKey =
      GlobalKey(debugLabel: "_assignSectionKey");
  final GlobalKey _textInputSectionKey =
      GlobalKey(debugLabel: "_textInputSectionKey");

  late Map<String, GlobalKey>? firstHeaderSectionsMap;

  final ScrollController _multiSelectorScrollController =
      ScrollController(debugLabel: '_multiSelectorScrollController');

  @override
  void initState() {
    super.initState();

    title = widget.title ?? "";
    initKeys();
    firstHeaderSectionsMap = {
      'Dati generali': _textInputSectionKey,
      'Indirizzo': _addressSectionKey,
    };

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
      _idController.text = element!.customerId ?? '';
      _codeController.text = element!.code ?? '';
      _descriptionController.text = element!.description ?? '';
      _pIVAController.text = element!.pIva ?? '';
      _cFiscaleController.text = element!.cFiscale ?? '';
      _indirizzoController.text = element!.indirizzo ?? '';
      _capController.text = element!.cap ?? '';
      _comuneController.text = element!.comune ?? '';
      _provinciaController.text = element!.provincia ?? '';
      _nazioneController.text = element!.nazione ?? '';
    }

    //_scrollController.addListener(scrollListener);
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _idKey),
      KeyValidationState(key: _codeKey),
      KeyValidationState(key: _descriptionKey),
      KeyValidationState(key: _pIVAKey),
      KeyValidationState(key: _cFiscaleKey),
      KeyValidationState(key: _indirizzoKey),
      KeyValidationState(key: _capKey),
      KeyValidationState(key: _comuneKey),
      KeyValidationState(key: _provinciaKey),
      KeyValidationState(key: _nazioneKey),
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
      child: MultiSelectorContainer(
        title: title,
        headerSectionsMap: {
          const MultiSelectorItem(text: 'Dati generali'): _textInputSectionKey,
          const MultiSelectorItem(text: 'Indirizzo'): _addressSectionKey,
        },
        scrollController: _scrollController,
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
        _textInputSection(),
        _addressSection(),
      ],
    );
  }

/*  Widget _categorySelector() {
    return SizedBox(
      width: 330,
      child: SingleChildScrollView(
          controller: _multiSelectorScrollController,
          key: _dialogNavigationKey,
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                */ /*  _fieldsDropDown(),
                const SizedBox(
                  height: 16,
                ),*/ /*
                Padding(
                  padding: getPadding(),
                  child: _multiSelector(),
                ),
              ],
            ),
          )),
    );
  }*/

/*  Widget _multiSelector() {
    _selectorData = _getSelectorData(direction: Axis.vertical);
    return MultiSelectorEx(
      direction: Axis.vertical,
      key: _multiSelectorKey,
      onPressed: (index) async {
        if (isLittleWidth()) {
          if (!mounted) return;
          Navigator.of(context).pop();
        }

        toNavStatus = index;
        //statNavStatus = index;
        */ /*setState(() {
                        statNavStatus = index;
                    });*/ /*
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

  bool _checkCategoryKey(String key) {
*/ /*    switch (key) {
      case 'Assegnazione':
        return currentStato >= 1;
      case 'Impostazioni':
        return currentStato >= 2;
      case 'Produzione':
        return currentStato >= 2;
      case 'Operazioni':
        return currentStato >= 2 && element != null;

      default:
        return true;
    }*/ /*
    return true;
  }

  Map<String, GlobalKey> _getMapIndexKey() {
    Map<String, GlobalKey> mapIndexKey = {};

    firstHeaderSectionsMap?.forEach((key, value) {
      if (_checkCategoryKey(key)) {
        mapIndexKey.addAll({key: value});
      }
    });

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
    */ /* Map mapSettings = selectedSettings.groupBy((p0) => p0.categoryName);
    Map mapProductions = selectedProductions.groupBy((p0) => p0.categoryName);
*/ /*
    List<SelectorData> result = <SelectorData>[];

    firstHeaderSectionsMap?.forEach((key, value) {
      if (_checkCategoryKey(key)) {
        result.add(getSelectorDataItem(
            text: key,
            direction: direction,
            color:
                Theme.of(context).colorScheme.primaryContainer.withAlpha(150)));
      }
    });

    return result;
  }

  SelectorData getSelectorDataItem({
    required String text,
    Axis direction = Axis.horizontal,
    required Color color,
  }) {
    return SelectorData(
        periodString: text,
        selectedColor: color,
        child: Container(
          constraints: direction == Axis.horizontal
              ? null
              : const BoxConstraints(maxHeight: 50, minWidth: 290),
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            */ /*  const SizedBox(width: 8),
                    const Icon(Icons.category),*/ /*
            const SizedBox(width: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: direction == Axis.horizontal
                  ? Text(text,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(letterSpacing: 0, wordSpacing: 0))
                  : Text(text, style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(width: 8),
          ]),
        ));
  }

  ///se esiste, aggiungo alle chiavi da navigare la chiave e il box relativo
  void addToBoxes(GlobalKey key) {
    if (!_boxes.containsKey(key)) {
      var box = key.currentContext?.findRenderObject();
      if (box != null && box is RenderBox) {
        _boxes.addAll({key: box});
      }
    }
  }*/

/*
  void scrollListener() {
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

    RenderBox? currentDialogTitleBox =
        _dialogTitleKey.currentContext?.findRenderObject() as RenderBox?;
    Offset currentDialogTitleBoxOffset =
        currentDialogTitleBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    RenderBox? currentDialogNavigationBox =
        _dialogNavigationKey.currentContext?.findRenderObject() as RenderBox?;

    Offset currentDialogNavigationBoxOffset =
        currentDialogNavigationBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    //print("Dy: $dy");
    //print("mainBoxOffset.dy: ${mainBoxOffset.dy+4}");
    dy = (mainBoxOffset.dy +
        currentDialogTitleBoxOffset.dy +
        (currentDialogTitleBox?.size.height ?? 0) +
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

    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent) {
      title = "${widget.title ?? ''} - ${mapIndexKey.keys.elementAt(0)}";
      _setTitle(title);
    } else if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      title = "${widget.title ?? ''} - ${mapIndexKey.keys.last}";
      _setTitle(title);
    } else {
      if (index == -1) {
        if (title != (widget.title ?? '')) {
          title = widget.title ?? '';
          _setTitle(title);
        }
      } else {
        if (index < mapIndexKey.length) {
          if (index < mapIndexKey.keys.length) {
            int localIndex = index - firstHeaderSectionsMap!.length;
            String desiredTitle = "";
            //if (localIndex < 0 || localIndex >= categoriesMap!.length) {
            desiredTitle =
                "${widget.title ?? ''} - ${mapIndexKey.keys.elementAt(index)}";
            */
/*} else {
              desiredTitle =
                  "${widget.title ?? ''} - ${categoriesMap!.keys.elementAt(localIndex)}";
            }*/ /*

            if (title != desiredTitle) {
              title = desiredTitle;
              _setTitle(title);
            }
          }
        }
      }
    }

    if (statNavStatus != index) {
      statNavStatus = index;

      if (index != -1) {
        if (_multiSelectorKey.currentState?.mounted ?? false) {
          _multiSelectorKey.currentState?.setState(() {
            _multiSelectorKey.currentState?.status = index;
          });
        }
      }
    }
  }

  void _setTitle(String title) {
    if (_dialogTitleKey.currentState?.mounted ?? false) {
      _dialogTitleKey.currentState?.setState(() {
        _dialogTitleKey.currentState?.title = title;
      });
    }
  }
*/

  Widget _panelContainer(List<Widget> children) {
    if (isTinyWidth(context)) {
      return Row(children: children);
    } else {
      return Row(children: children);
    }
  }

  SettingsScrollSection _textInputSection() {
    return SettingsScrollSection(
      key: _textInputSectionKey,
      title: const Text(
        'Dati generali',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _idSettingTile(),
        _codeSettingTile(),
        _descriptionSettingTile(),
        _pIVASettingTile(),
        _cFiscaleSettingTile(),
      ],
    );
  }

  SettingsScrollSection _addressSection() {
    return SettingsScrollSection(
      key: _addressSectionKey,
      title: const Text(
        'Indirizzo',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _indirizzoSettingTile(),
        _capSettingTile(),
        _comuneSettingTile(),
        _provinciaSettingTile(),
        _nazioneSettingTile(),
      ],
    );
  }

  SettingsTile _idSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci id',
        hint: 'Identificativo',
        description: 'Identificativo univoco del cliente',
        child: _textField(
            fieldKey: _idKey,
            controller: _idController,
            labelText: 'Identificativo',
            hintText: 'Identificativo univoco del cliente',
            enabled: null,
            maxLenght: 450,
            customValidator: (String? str) {
              if (str == null || str.isEmpty) {
                return "Campo obbligatorio";
              }

              List<Customer> existing = widget.customers
                  .where((element) => element.customerId == str)
                  .toList(growable: false);
              if (existing.isNotEmpty) {
                return "Codice già utilizzato per ${existing.last.description}";
              }

              return null;
            }));
  }

  SettingsTile _codeSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci codice',
        hint: 'Codice',
        description: 'Codice identificativo univoco del cliente',
        child: _textField(
            fieldKey: _codeKey,
            controller: _codeController,
            labelText: 'Codice',
            hintText: 'Codice identificativo univoco del cliente',
            enabled: null,
            maxLenght: 8));
  }

  SettingsTile _descriptionSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci descrizione',
        hint: 'Descrizione',
        description: 'Descrizione o Ragione Sociale del cliente',
        child: _textField(
            fieldKey: _descriptionKey,
            controller: _descriptionController,
            labelText: 'Descrizione',
            hintText: 'Descrizione o Ragione Sociale del cliente',
            maxLenght: 500));
  }

  SettingsTile _pIVASettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci partita IVA',
        hint: 'Partita IVA',
        description: 'Partita IVA del cliente',
        child: _textField(
            fieldKey: _pIVAKey,
            controller: _pIVAController,
            labelText: 'Partita IVA',
            hintText: 'Partita IVA del cliente',
            maxLenght: 50,
            validate: false));
  }

  SettingsTile _cFiscaleSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci codice fiscale',
        hint: 'Codice Fiscale',
        description: 'Codice Fiscale del cliente',
        child: _textField(
            fieldKey: _cFiscaleKey,
            controller: _cFiscaleController,
            labelText: 'Codice Fiscale',
            hintText: 'Codice Fiscale del cliente',
            maxLenght: 50,
            validate: false));
  }

  SettingsTile _indirizzoSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci indirizzo',
        hint: 'Indirizzo',
        description: 'Indirizzo del cliente',
        child: _textField(
            fieldKey: _indirizzoKey,
            controller: _indirizzoController,
            labelText: 'Indirizzo',
            hintText: 'Indirizzo del cliente',
            validate: false,
            maxLenght: 100));
  }

  SettingsTile _capSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci CAP',
        hint: 'CAP',
        description: 'Codice Avviamento Postale del cliente',
        child: _textField(
            fieldKey: _capKey,
            controller: _capController,
            labelText: 'CAP',
            hintText: 'Codice avviamento postale del cliente',
            validate: false,
            maxLenght: 20));
  }

  SettingsTile _comuneSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci comune',
        hint: 'Comune',
        description: 'Comune del cliente',
        child: _textField(
            fieldKey: _comuneKey,
            controller: _comuneController,
            labelText: 'Comune',
            hintText: 'Comune del cliente',
            validate: false,
            maxLenght: 200));
  }

  SettingsTile _provinciaSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci provincia',
        hint: 'Provincia',
        description: 'Provincia del cliente',
        child: _textField(
            fieldKey: _provinciaKey,
            controller: _provinciaController,
            labelText: 'Provincia',
            hintText: 'Provincia del cliente',
            validate: false,
            maxLenght: 200));
  }

  SettingsTile _nazioneSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci nazione',
        hint: 'Nazione',
        description: 'Nazione del cliente',
        child: _textField(
            fieldKey: _nazioneKey,
            controller: _nazioneController,
            labelText: 'Nazione',
            hintText: 'Nazione del cliente',
            validate: false,
            maxLenght: 200));
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
      if (element == null) {
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
      }
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
    _idController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _pIVAController.dispose();
    _cFiscaleController.dispose();
    _indirizzoController.dispose();
    _capController.dispose();
    _comuneController.dispose();
    _provinciaController.dispose();
    _nazioneController.dispose();

    //_scrollController.removeListener(scrollListener);
    /*_boxes.clear();*/
    _scrollController.dispose();
    _multiSelectorScrollController.dispose();
    super.dispose();
  }
}

class MapSettingKey {
  final String fieldName;
  final int fieldId;
  final GlobalKey key;
  final MachineSetting machineSetting;

  const MapSettingKey(
      {required this.fieldId,
      required this.machineSetting,
      required this.fieldName,
      required this.key});
}

class MapProductionKey {
  final String fieldName;
  final int fieldId;
  final GlobalKey key;
  final MachineProduction machineProduction;

  const MapProductionKey(
      {required this.fieldId,
      required this.machineProduction,
      required this.fieldName,
      required this.key});
}
