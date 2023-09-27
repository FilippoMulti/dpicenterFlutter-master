import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

// Define a custom Form widget.
class ManufacturerEditForm extends StatefulWidget {
  final Manufacturer? element;
  final String? title;

  const ManufacturerEditForm({Key? key, required this.element, required this.title})
      : super(key: key);

  @override
  ManufacturerEditFormState createState() {
    return ManufacturerEditFormState();
  }
}

class ManufacturerEditFormState extends State<ManufacturerEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController manufacturerController;
  late TextEditingController referenteController;

  final ScrollController _scrollController =
  ScrollController(debugLabel: "_scrollController");
  Manufacturer? element;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');
  final FocusNode _manufacturerFocusNode =
  FocusNode(debugLabel: '_manufacturerFocusNode');
  final FocusNode _referenteFocusNode =
  FocusNode(debugLabel: '_referenteFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _manufacturerKey = GlobalKey(debugLabel: '_manufacturerKey');
  final GlobalKey _referenteKey = GlobalKey(debugLabel: '_referenteKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  @override
  void initState() {
    super.initState();
    initKeys();
    element = widget.element;

    if (element != null) {
      manufacturerController =
          TextEditingController(text: element!.description);
      referenteController = TextEditingController(text: element!.referente);
    } else {
      manufacturerController = TextEditingController();
      referenteController = TextEditingController();
    }
  }

  @override
  void dispose() {
    manufacturerController.dispose();
    referenteController.dispose();
    _saveFocusNode.dispose();
    _manufacturerFocusNode.dispose();
    _referenteFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _manufacturerKey),
      KeyValidationState(key: _referenteKey),
    ];
  }

  InputDecoration _manufacturerInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Produttore', hintText: 'Inserisci il nome del produttore');
  }

  InputDecoration _referenteInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Referente', hintText: 'Inserisci il nome del referente');
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 800),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DialogTitleEx(widget.title!),
            Flexible(
                child: Scaffold(
              backgroundColor: getAppBackgroundColor(context),
              body: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

                    ///permette al widget di essere scrollato
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
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
      ),
    );
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(title: const Text("Inserimento dati"), tiles: [
      _manufacturerSettingTile(),
      _referenteSettingTile(),
    ]);
  }

  SettingsTile _manufacturerSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci produttore',
        hint: 'Inserire produttore',
        description: 'Inserisci il nome o la ragione sociale del produttore',
        child: _manufacturer());
  }

  Widget _manufacturer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _manufacturerKey,
        focusNode: _manufacturerFocusNode,
        maxLines: null,
        //autofocus: isDesktop ? true : false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: manufacturerController,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _manufacturerInputDecoration(),
        validator: (str) {
          KeyValidationState state = _keyStates
              .firstWhere((element) => element.key == _manufacturerKey);
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

  SettingsTile _referenteSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci referente',
        hint: 'Inserire referente',
        description: 'Inserisci il nome del referente',
        child: _referente());
  }

  Widget _referente() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _referenteKey,
        focusNode: _referenteFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: referenteController,
        textInputAction: TextInputAction.next,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _referenteInputDecoration(),
        validator: (str) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == _referenteKey);
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

  void validateSave() {
    if (_formKey.currentState!.validate()) {
      if (element == null) {
        element = Manufacturer(
            manufacturerId: 0,
            description: manufacturerController.text,
            referente: referenteController.text);
      } else {
        element = element!.copyWith(
            description: manufacturerController.text,
            referente: referenteController.text);
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

/*
        _scrollController.position.ensureVisible(
          state.key.currentContext!.findRenderObject()!,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
*/
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}
