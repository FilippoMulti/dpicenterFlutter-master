import 'dart:convert';

import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:dpicenter/models/server/setting_type.dart';

// Define a custom Form widget.
class VmcSettingFieldEditForm extends StatefulWidget {
  final VmcSettingField? element;
  final String? title;

  const VmcSettingFieldEditForm(
      {Key? key, required this.element, required this.title})
      : super(key: key);

  @override
  VmcSettingFieldEditFormState createState() {
    return VmcSettingFieldEditFormState();
  }
}

class VmcSettingFieldEditFormState extends State<VmcSettingFieldEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");
  VmcSettingField? element;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');
  final FocusNode _nameFocusNode = FocusNode(debugLabel: '_nameFocusNode');
  final FocusNode _descriptionFocusNode =
      FocusNode(debugLabel: '_descriptionFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _nameKey = GlobalKey(debugLabel: '_nameKey');
  final GlobalKey _descriptionKey = GlobalKey(debugLabel: '_descriptionKey');
  final GlobalKey _categoryKey = GlobalKey(debugLabel: '_categoryKey');
  final GlobalKey _textWhenTrueKey = GlobalKey(debugLabel: '_textWhenTrueKey');
  final GlobalKey _textWhenFalseKey =
      GlobalKey(debugLabel: '_textWhenFalseKey');

  final GlobalKey _minValueKey = GlobalKey(debugLabel: '_minValueKey');
  final GlobalKey _maxValueKey = GlobalKey(debugLabel: '_maxValueKey');
  final GlobalKey _stepValueKey = GlobalKey(debugLabel: '_stepValueKey');
  final GlobalKey _fractionDigitsValueKey =
      GlobalKey(debugLabel: '_fractionDigitsValueKey');

  TextEditingController minValueController = TextEditingController();
  TextEditingController maxValueController = TextEditingController();
  TextEditingController stepValueController = TextEditingController();
  TextEditingController fractionDigitsValueController = TextEditingController();

  TextEditingController textWhenTrueController = TextEditingController();
  TextEditingController textWhenFalseController = TextEditingController();
  final FocusNode _textWhenTrueFocusNode =
      FocusNode(debugLabel: '_textWhenTrueFocusNode');
  final FocusNode _textWhenFalseFocusNode =
      FocusNode(debugLabel: '_textWhenTrueFocusNode');

  final GlobalKey _selectionOptionsKey =
      GlobalKey(debugLabel: '_selectionOptionsKey');
  final FocusNode _selectionOptionsFocusNode =
      FocusNode(debugLabel: '_selectionOptionsFocusNode');
  TextEditingController selectionOptionsController = TextEditingController();

  late TextEditingController _searchCategoryController;

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///lista delle categorie tra cui selezionare
  List<VmcSettingCategory>? vmcSettingCategories = <VmcSettingCategory>[];

  VmcSettingCategory? selectedCategory;

  ///attiva o disattiva l'autovalidazione
  bool _autovalidate = false;

  int selectedType = 0;

  @override
  void initState() {
    super.initState();
    initKeys();
    element = widget.element;

    _searchCategoryController = TextEditingController();
    _loadCategories();

    if (element != null) {
      nameController = TextEditingController(text: element!.name);
      descriptionController = TextEditingController(text: element!.description);
      selectedCategory = element!.category;
      selectedType = element!.type ?? 0;

      switch (selectedType) {
        case 1: //selection
          selectionOptionsController =
              TextEditingController(text: element!.params);
          break;
        case 2:
          if (element!.params != null) {
            List<String> values = element!.params!.split('|');
            minValueController = TextEditingController(text: values[0]);
            maxValueController = TextEditingController(text: values[1]);
            stepValueController = TextEditingController(text: values[2]);
            fractionDigitsValueController =
                TextEditingController(text: values[3]);
          } else {
            minValueController = TextEditingController(text: "0");
            maxValueController = TextEditingController(text: "400000000");
            stepValueController = TextEditingController(text: "1");
            fractionDigitsValueController = TextEditingController(text: "0");
          }

          break;
        case 4:
          if (element!.params != null) {
            List<String> values = element!.params!.split('|');
            textWhenTrueController = TextEditingController(text: values[0]);
            textWhenFalseController = TextEditingController(text: values[1]);
          } else {
            textWhenTrueController = TextEditingController(text: 'Vero');
            textWhenFalseController = TextEditingController(text: 'Falso');
          }
          break;
        default:
          textWhenTrueController = TextEditingController();
          textWhenFalseController = TextEditingController();
          break;
      }
    } else {
      nameController = TextEditingController();
      descriptionController = TextEditingController();
      selectedType = 0;
      textWhenTrueController = TextEditingController();
      textWhenFalseController = TextEditingController();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    _saveFocusNode.dispose();
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _scrollController.dispose();
    _textWhenFalseFocusNode.dispose();
    _textWhenTrueFocusNode.dispose();
    textWhenTrueController.dispose();
    textWhenFalseController.dispose();
    selectionOptionsController.dispose();
    minValueController.dispose();
    maxValueController.dispose();
    stepValueController.dispose();
    fractionDigitsValueController.dispose();
    super.dispose();
  }

  _loadCategories() {
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    bloc.add(const ServerDataEvent<VmcSettingCategory>(
        status: ServerDataEvents.fetch));
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _nameKey),
      KeyValidationState(key: _descriptionKey),
      KeyValidationState(key: _categoryKey),
      KeyValidationState(key: _textWhenTrueKey),
      KeyValidationState(key: _textWhenFalseKey),
      KeyValidationState(key: _selectionOptionsKey),
      KeyValidationState(key: _minValueKey),
      KeyValidationState(key: _maxValueKey),
      KeyValidationState(key: _stepValueKey),
      KeyValidationState(key: _fractionDigitsValueKey),
    ];
  }

  InputDecoration _nameInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Etichetta',
        hintText: 'Inserisci l\'etichetta per l\'impostazione');
  }

  InputDecoration _descriptionInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Descrizione',
        hintText: 'Inserisci una descrizione per l\'impostazione');
  }

  InputDecoration _textWhenTrueInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Testo quando On',
        hintText: 'Testo da visualizzare quando l\'interrutore è On');
  }

  InputDecoration _selectionOptionsInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Valori selezionabili',
        hintText:
            'Imposta i valori selezionabili separandoli con un pipe \'|\'');
  }

  InputDecoration _textWhenFalseInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Testo quando Off',
        hintText: 'Testo da visualizzare quando l\'interrutore è Off');
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
                  constraints: BoxConstraints(
                      maxWidth: 500,
                      maxHeight: MediaQuery.of(context).size.height > 700
                          ? MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).size.height / 3)
                          : MediaQuery.of(context).size.height),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DialogTitleEx(widget.title!),
                      Flexible(
                        child: SettingsScroll(
                          darkTheme: SettingsThemeData(
                            settingsListBackground: isDarkTheme(context)
                                ? Color.alphaBlend(
                                    Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withAlpha(240),
                                    Theme.of(context).colorScheme.primary)
                                : Theme.of(context).colorScheme.surface,
                          ),
                          lightTheme: const SettingsThemeData(
                              settingsListBackground: Colors.transparent),
                          //contentPadding: EdgeInsets.zero,
                          platform: DevicePlatform.web,
                          sections: [
                            _configurationSection(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
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

/*    return FocusScope(
      child: Column(


        children: [
          DialogTitle(widget.title!),
          Flexible(
            child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 500,
                  constraints: BoxConstraints.loose(Size(500,200)),
                  child:


                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Expanded(
                        child: SettingsList(
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
                          shrinkWrap: true,
                          sections: [
                            _configurationSection(),
                          ],
                        ),
                      ),

                      */ /*Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: TextFormField(
                          fieldKey: _nameKey,
                          focusNode: _nameFocusNode,
                          maxLines: null,
                          //autofocus: isDesktop ? true : false,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          controller: nameController,
                          maxLength: 500,
                          onChanged: (value) => editState = true,
                          decoration: _nameInputDecoration(),
                          validator: (str) {
                            KeyValidationState state = _keyStates.firstWhere(
                                (element) => element.key == _nameKey);
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
                      ),*/ /*
                      */ /*Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: TextFormField(
                          fieldKey: _descriptionKey,
                          focusNode: _descriptionFocusNode,
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          controller: descriptionController,
                          textInputAction: TextInputAction.next,
                          maxLength: 500,
                          onChanged: (value) => editState = true,
                          decoration: _descriptionInputDecoration(),
                          validator: (str) {
                            */ /**/ /*KeyValidationState state = _keyStates.firstWhere(
                                (element) => element.key == _referenteKey);
                            if (str!.isEmpty) {
                              _keyStates[_keyStates.indexOf(state)] =
                                  state.copyWith(state: false);
                              return "Campo obbligatorio";
                            } else {
                              _keyStates[_keyStates.indexOf(state)] =
                                  state.copyWith(state: true);
                            }*/ /**/ /*
                            return null;
                          },
                          onFieldSubmitted: (str) {
                            _saveFocusNode.requestFocus();
                          },
                        ),
                      ),*/ /*
                      const SizedBox(height: 20),
                    ],
                  ),
                )),
          ),
          OkCancel(
              okFocusNode: _saveFocusNode,
              onCancel: () {
                Navigator.maybePop(context, null);
              },
              onSave: () {
                validateSave();
              })
        ],
      ),
    );*/
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(
      title: const Text(
        'Configurazione',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _nameSettingTile(),
        _descriptionSettingTile(),
        _categorySettingTile(),
        _typeSettingTile(),
        if (selectedType != 0 && selectedType != 3 && selectedType != 5)
          _paramsSettingTile()
      ],
    );
  }

  SettingsTile _nameSettingTile() {
    return getCustomSettingTile(
      title: 'Inserisci etichetta',
      hint: 'Etichetta',
      description: 'Etichetta visualizzata al momento della compilazione',
      child: TextFormField(
        key: _nameKey,
        focusNode: _nameFocusNode,
        maxLines: null,
        //autofocus: isDesktop ? true : false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: nameController,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _nameInputDecoration(),
        validator: (str) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == _nameKey);
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

  SettingsTile _descriptionSettingTile() {
    return getCustomSettingTile(
      title: 'Inserisci descrizione',
      hint: 'Descrizione',
      description:
          'Eventuale descrizione, utile per spiegare cosa e perchè inserire questo dato',
      child: TextFormField(
        key: _descriptionKey,
        focusNode: _descriptionFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: descriptionController,
        textInputAction: TextInputAction.next,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _descriptionInputDecoration(),
        validator: (str) {
          /*KeyValidationState state = _keyStates.firstWhere(
                                (element) => element.key == _referenteKey);
                            if (str!.isEmpty) {
                              _keyStates[_keyStates.indexOf(state)] =
                                  state.copyWith(state: false);
                              return "Campo obbligatorio";
                            } else {
                              _keyStates[_keyStates.indexOf(state)] =
                                  state.copyWith(state: true);
                            }*/
          return null;
        },
        onFieldSubmitted: (str) {
          _saveFocusNode.requestFocus();
        },
      ),
    );
  }

  SettingsTile _categorySettingTile() {
    return getCustomSettingTile(
      title: 'Seleziona categoria',
      hint: 'Categoria',
      description: 'Seleziona una categoria per l\'impostazione',
      child: _categoriesDropDown(),
    );
  }

  SettingsTile _typeSettingTile() {
    return getSelectionSettingTile(
      title: 'Tipo impostazione',
      hint: 'Seleziona il tipo di impostazione',
      description:
          'Imposta l\'editor da utilizzare per compilare questa impostazione',
      initialValue: Type.fromType(selectedType).toString(),
      children: [
        ...Type.values.map((e) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                selectedType = e.index;
              });
              if (!mounted) return;
              Navigator.of(context).maybePop();
            },
            //
            child: Type.toRowItem(e),
          );
        })
      ],
    );
  }

  SettingsTile _paramsSettingTile() {
    return getCustomSettingTile(
      title: 'Parametri',
      hint: 'Imposta parametri tipo impostazione',
      description:
          'Imposta i parametri necessari alla compilazione dell\'impostazione. ${selectedType == 1 ? 'Separa i valori utilizando un pipe \'|\' come divisore.' : ''}',
      child: _getParamsEditor(),
    );
  }

  Widget _getParamsEditor() {
    switch (selectedType) {
      case 0:
        break;
      case 1: //selection
        return Column(
          children: [
            _selectionOptionsField(),
          ],
        );
      case 2: //up down
        return Column(
          children: [
            _minValueSettingTile(),
            _maxValueSettingTile(),
            _stepValueSettingTile(),
            _fractionDigitsValueSettingTile(),
          ],
        );
      case 4:
        return Column(
          children: [
            _textWhenTrueSettingTile(),
            _textWhenFalseSettingTile(),
          ],
        );
        break;
    }
    return const Text("in costruzione");
  }

  Widget _selectionOptionsField() {
    return TextFormField(
      key: _selectionOptionsKey,
      focusNode: _selectionOptionsFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: selectionOptionsController,
      textInputAction: TextInputAction.next,
      maxLength: 500,
      onChanged: (value) => editState = true,
      decoration: _selectionOptionsInputDecoration(),
      validator: (str) {
        KeyValidationState state = _keyStates
            .firstWhere((element) => element.key == _selectionOptionsKey);
        if (str!.isEmpty) {
          _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: false);
          return "Campo obbligatorio";
        } else {
          _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
        }
        return null;
      },
      onFieldSubmitted: (str) {
        _saveFocusNode.requestFocus();
      },
    );
  }

  SettingsTile _textWhenTrueSettingTile() {
    return getCustomSettingTile(
      title: 'Testo quando interuttore On',
      hint: 'Testo quando interuttore On',
      description:
          'Inserisci il testo da visualizzare quando l\'interuttore è On',
      child: TextFormField(
        key: _textWhenTrueKey,
        focusNode: _textWhenTrueFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textWhenTrueController,
        textInputAction: TextInputAction.next,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _textWhenTrueInputDecoration(),
        validator: (str) {
          KeyValidationState state = _keyStates
              .firstWhere((element) => element.key == _textWhenTrueKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        onFieldSubmitted: (str) {
          _saveFocusNode.requestFocus();
        },
      ),
    );
  }

  SettingsTile _textWhenFalseSettingTile() {
    return getCustomSettingTile(
      title: 'Testo quando interuttore Off',
      hint: 'Testo quando interuttore Off',
      description:
          'Inserisci il testo da visualizzare quando l\'interuttore è Off',
      child: TextFormField(
        key: _textWhenFalseKey,
        focusNode: _textWhenFalseFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textWhenFalseController,
        textInputAction: TextInputAction.next,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _textWhenFalseInputDecoration(),
        validator: (str) {
          KeyValidationState state = _keyStates
              .firstWhere((element) => element.key == _textWhenFalseKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        onFieldSubmitted: (str) {
          _saveFocusNode.requestFocus();
        },
      ),
    );
  }

  SettingsTile _minValueSettingTile() {
    return getUpDownSettingTile(
      key: _minValueKey,
      title: 'Valore minimo',
      hint: 'Valore minimo',
      description: 'Inserisci il valore minimo per l\'impostazione',
      initialValue: minValueController.text,
      decimals: 0,
      step: 1,
      min: 0,
      max: 4000000000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            minValueController.text = double.parse(result).toStringAsFixed(0);
          });
        }
      },
      icon: const Icon(Icons.settings),
    );
  }

  SettingsTile _maxValueSettingTile() {
    return getUpDownSettingTile(
      key: _maxValueKey,
      title: 'Valore massimo',
      hint: 'Valore massimo',
      description: 'Inserisci il valore massimo per l\'impostazione',
      initialValue: maxValueController.text,
      decimals: 0,
      step: 1,
      min: 0,
      max: 4000000000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            maxValueController.text = double.parse(result).toStringAsFixed(0);
          });
        }
      },
      icon: const Icon(Icons.settings),
    );
  }

  SettingsTile _stepValueSettingTile() {
    return getUpDownSettingTile(
      key: _stepValueKey,
      title: 'Valore step',
      hint: 'Valore step',
      description: 'Valore associato ai pulsanti + e -',
      initialValue: stepValueController.text,
      decimals: 0,
      step: 1,
      min: 0,
      max: 4000000000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            stepValueController.text = result;
          });
        }
      },
      icon: const Icon(Icons.settings),
    );
  }

  SettingsTile _fractionDigitsValueSettingTile() {
    return getUpDownSettingTile(
      key: _fractionDigitsValueKey,
      title: 'Numero di decimali',
      hint: 'Numero di decimali',
      description: 'Numero decimali del valore',
      initialValue: fractionDigitsValueController.text,
      decimals: 0,
      step: 1,
      min: 0,
      max: 4000000000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            fractionDigitsValueController.text = result;
          });
        }
      },
      icon: const Icon(Icons.settings),
    );
  }

  Widget _categoriesDropDown() {
    return BlocBuilder<ServerDataBloc, ServerDataState>(
        builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            if (state.items != null &&
                state.items is List<VmcSettingCategory>) {
              vmcSettingCategories = state.items as List<VmcSettingCategory>;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: DropdownSearch<VmcSettingCategory>(
/*                focusNode:
                    isWindows || isWindowsBrowser ? null : _categoriesFocusNode,*/
                enabled: true,
                //isEnabled(),
                key: _categoryKey,
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
                    item.vmcSettingCategoryCode ==
                    selectedItem.vmcSettingCategoryCode,
                //showClearButton: true,
                clearButtonProps: const ClearButtonProps(isVisible: true),
                itemAsString: (VmcSettingCategory? c) => c?.name ?? 'no name',
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectedItem: selectedCategory,
                onChanged: (VmcSettingCategory? newValue) {
                  editState = true;
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Categoria',
                    hintText: 'Seleziona una categoria',
                  ),
                ),
                validator: (item) {
                  if (item == null) {
                    KeyValidationState state = _keyStates
                        .firstWhere((element) => element.key == _categoryKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: false);
                    return "Campo obbligatorio";
                  } else {
                    KeyValidationState state = _keyStates
                        .firstWhere((element) => element.key == _categoryKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: true);
                  }
                  return null;
                },
                items: vmcSettingCategories ?? <VmcSettingCategory>[],
                filterFn: (VmcSettingCategory? item, String? filter) {
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

/*  Widget _category() {
    return BlocBuilder<ServerDataBloc, ServerDataState>(
        builder: (BuildContext context, ServerDataState state) {
          switch (state.event!.status) {
            case ServerDataEvents.fetch:
              if (state is ServerDataInitState || state is ServerDataLoading) {
                return shimmerComboLoading(context,
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
              }

              if (state is ServerDataLoaded) {
                vmcSettingCategories!.clear();
                vmcSettingCategories =
                    state.items!.map<DropdownMenuItem<VmcSettingCategory>>((value) {
                      return DropdownMenuItem<VmcSettingCategory>(
                        value: value,
                        child:
                        Text("${(value as VmcSettingCategory).name}"),
                      );
                    }).toList();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: DropdownButtonFormField<VmcSettingCategory>(
                      key: _categoryKey,
                      autovalidateMode: _autovalidate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      value: (() {
                        if (element != null && element!.category!=null) {
                          return element!.category;
                        } else {
                          return null;
                        }
                      }()),
                      onChanged: (VmcSettingCategory? newValue) {
                        setState(() {
                          editState = true;
                          selectedCategory = newValue;
                        });

                        //_passwordSetFocusNode.requestFocus();
                        _saveFocusNode.requestFocus();
                        //context.nextEditableTextFocus();
                      },

                      decoration: const InputDecoration(
                        //enabledBorder: OutlineInputBorder(),
                        border: OutlineInputBorder(),
                        labelText: 'Categoria',
                        hintText: 'Seleziona una categoria',
                      ),
                      validator: (item) {
                        KeyValidationState state = _keyStates
                            .firstWhere((element) => element.key == _categoryKey);
                        if (item == null) {
                          _keyStates[_keyStates.indexOf(state)] =
                              state.copyWith(state: false);
                          return "Campo obbligatorio";
                        } else {
                          _keyStates[_keyStates.indexOf(state)] =
                              state.copyWith(state: true);
                        }
                        return null;
                      },
                      items: vmcSettingCategories),
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
  }*/
  void validateSave() {
    if (_formKey.currentState!.validate()) {
      if (element == null) {
        element = VmcSettingField(
            vmcSettingFieldId: 0,
            name: nameController.text,
            description: descriptionController.text,
            vmcSettingCategoryCode: selectedCategory?.vmcSettingCategoryCode,
            type: selectedType,
            params: _getParamsValue());
      } else {
        element = element!.copyWith(
            name: nameController.text,
            description: descriptionController.text,
            vmcSettingCategoryCode: selectedCategory?.vmcSettingCategoryCode,
            type: selectedType,
            params: _getParamsValue());
        /*element!.description = manufacturerController.text;
        element!.referente = referenteController.text;*/
      }

      //Navigator.pop(ctx, textController.text);
      Navigator.pop(context, element);
    } else {
      try {
        KeyValidationState state =
            _keyStates.firstWhere((element) => element.state == false);

        Scrollable.ensureVisible(state.key.currentContext!,
            duration: const Duration(milliseconds: 500));
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

  ///Trasforma i parametri in una stringa e li restituisce al chiamante
  String _getParamsValue() {
    switch (selectedType) {
      case 1:
        return selectionOptionsController.text;
      case 2:
        return "${minValueController.text}|${maxValueController.text}|${stepValueController.text}|${fractionDigitsValueController.text}";
      case 4:
        return "${textWhenTrueController.text}|${textWhenFalseController.text}";
      default:
        return '';
    }
  }
}
