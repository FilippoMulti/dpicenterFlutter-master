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
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:settings_ui/settings_ui.dart';

// Define a custom Form widget.
class VmcSettingCategoryEditForm extends StatefulWidget {
  final VmcSettingCategory? element;
  final String? title;

  const VmcSettingCategoryEditForm(
      {Key? key, required this.element, required this.title})
      : super(key: key);

  @override
  VmcSettingCategoryEditFormState createState() {
    return VmcSettingCategoryEditFormState();
  }
}

class VmcSettingCategoryEditFormState
    extends State<VmcSettingCategoryEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController codeController;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");
  VmcSettingCategory? element;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');
  final FocusNode _nameFocusNode = FocusNode(debugLabel: '_nameFocusNode');
  final FocusNode _codeFocusNode = FocusNode(debugLabel: '_nameFocusNode');
  final FocusNode _colorFocusNode = FocusNode(debugLabel: '_colorFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _nameKey = GlobalKey(debugLabel: '_nameKey');
  final GlobalKey _codeKey = GlobalKey(debugLabel: '_codeKey');
  final GlobalKey _colorKey = GlobalKey(debugLabel: '_colorKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  Color? currentColor;

  @override
  void initState() {
    super.initState();
    initKeys();
    element = widget.element;

    if (element != null) {
      nameController = TextEditingController(text: element!.name);
      codeController =
          TextEditingController(text: element!.vmcSettingCategoryCode);
      currentColor = Color(int.parse(element!.color ?? "0"));
    } else {
      nameController = TextEditingController();
      currentColor = Colors.black;
      codeController = TextEditingController();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    _saveFocusNode.dispose();
    _nameFocusNode.dispose();
    _colorFocusNode.dispose();
    _codeFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _codeKey),
      KeyValidationState(key: _nameKey),
      KeyValidationState(key: _colorKey),
    ];
  }

  InputDecoration _codeInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Codice', hintText: 'Inserisci un codice per la categoria');
  }

  InputDecoration _nameInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Etichetta',
        hintText: 'Inserisci l\'etichetta per l\'impostazione');
  }

  InputDecoration _colorInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Colore',
        hintText: 'Seleziona un colore da associare alla categoria');
  }

  Future<Color?> selectColorPicker(BuildContext context, int currentColor,
      void Function(Color value)? onChanged) async {
    // raise the [showDialog] widget
    var result = await showDialog(
      context: context,
      builder: (context) {
        return multiDialog(
          title: const Text('Seleziona un colore'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: Color(currentColor),
              portraitOnly: true,
              enableLabel: false,
              onPrimaryChanged: (color) {
                currentColor = color.value;
                onChanged?.call(color);
              },
              onColorChanged: (color) {
                currentColor = color.value;
                onChanged?.call(color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Seleziona'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return result;
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
        _codeSettingTile(),
        _nameSettingTile(),
        _colorSettingTile(),
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

  SettingsTile _codeSettingTile() {
    return getCustomSettingTile(
      title: 'Inserisci codice',
      hint: 'Codice',
      description: 'Inserisci codice categoria. Deve essere univoco.',
      child: TextFormField(
        key: _codeKey,
        focusNode: _codeFocusNode,
        maxLines: null,
        //autofocus: isDesktop ? true : false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: codeController,
        maxLength: 500,
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

  SettingsTile _colorSettingTile() {
    return getCustomSettingTile(
        title: 'Seleziona colore',
        hint: 'Colore',
        description: 'Seleziona un colore da associare alla categoria',
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await selectColorPicker(context, currentColor?.value ?? 0,
                      (value) {
                    setState(() {
                      editState = true;
                      currentColor = value;
                    });
                  });
                },
                child: const Text("Seleziona colore")),
            const SizedBox(
              width: 16,
            ),
            Container(
              width: 32,
              height: 32,
              decoration:
                  BoxDecoration(color: currentColor, shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
            )
          ],
        ));
  }

  void validateSave() {
    if (_formKey.currentState!.validate()) {
      if (element == null) {
        element = VmcSettingCategory(
          color: currentColor?.value.toString() ?? "0",
          name: nameController.text,
          vmcSettingCategoryCode: codeController.text,
        );
      } else {
        element = element!.copyWith(
          color: currentColor?.value.toString() ?? "0",
          name: nameController.text,
          vmcSettingCategoryCode: codeController.text,
        );
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
}
