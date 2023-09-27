import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/openai/data_frame.dart';
import 'package:dpicenter/models/server/openai/data_frame_type_enum.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

// Define a custom Form widget.
class DataFrameEditForm extends StatefulWidget {
  final DataFrame? element;
  final String? title;

  const DataFrameEditForm(
      {Key? key, required this.element, required this.title})
      : super(key: key);

  @override
  DataFrameEditFormState createState() {
    return DataFrameEditFormState();
  }
}

class DataFrameEditFormState extends State<DataFrameEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController questionController;
  late TextEditingController answerController;
  late TextEditingController attachmentsController;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");
  DataFrame? element;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');
  final FocusNode _questionFocusNode =
      FocusNode(debugLabel: '_questionFocusNode');
  final FocusNode _answerFocusNode = FocusNode(debugLabel: '_answerFocusNode');
  final FocusNode _attachmentsFocusNode =
      FocusNode(debugLabel: '_attachmentsFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _questionKey = GlobalKey(debugLabel: '_questionKey');
  final GlobalKey _answerKey = GlobalKey(debugLabel: '_answerKey');
  final GlobalKey _attachmentsKey = GlobalKey(debugLabel: '_attachmentsKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///rappresentazione enum del tipo di dataframe
  late DataFrameType dataFrameType;

  @override
  void initState() {
    super.initState();
    initKeys();
    element = widget.element;
    dataFrameType = DataFrameType.fromType(element?.type ?? 0);

    if (element != null) {
      questionController = TextEditingController(text: element!.question);
      answerController = TextEditingController(text: element!.answer);
      attachmentsController = TextEditingController(text: element!.attachments);
    } else {
      questionController = TextEditingController();
      answerController = TextEditingController();
      attachmentsController = TextEditingController();
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    attachmentsController.dispose();
    _saveFocusNode.dispose();
    _questionFocusNode.dispose();
    _answerFocusNode.dispose();
    _attachmentsFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _questionKey),
      KeyValidationState(key: _answerKey),
      KeyValidationState(key: _attachmentsKey),
    ];
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
      _questionSettingTile(),
      _answerSettingTile(),
      _attachmentsSettingTile(),
      _typeSettingTile(),
    ]);
  }

  SettingsTile _typeSettingTile() {
    return getSelectionSettingTile(
      title: 'Tipo dataframe',
      hint: 'Seleziona tipo dataframe',
      description: 'Seleziona il tipo da associare al dataframe',
      currentValueIcon:
          dataFrameType.toIcon(color: getTextColor(context: context)),
      icon: const Icon(Icons.type_specimen),
      initialValue: dataFrameType.toString(),
      children: [
        ...DataFrameType.values.map((e) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                dataFrameType = e;
                element = element?.copyWith(type: e.type);
              });
              if (!mounted) return;
              Navigator.of(context).maybePop();
            },
            //
            child: DataFrameType.toRowItem(e),
          );
        })
      ],
      //controller: _controller,
    );
  }

  SettingsTile _questionSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci domanda o titotlo',
        hint: 'Inserire domanda o titolo',
        description: 'Inserisci una domanda o il titolo dell\'argomento',
        child: _question());
  }

  Widget _question() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _questionKey,
        focusNode: _questionFocusNode,
        maxLines: null,
        //autofocus: isDesktop ? true : false,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: questionController,
        maxLength: 15000,
        onChanged: (value) => editState = true,
        decoration: textFieldInputDecoration(
            labelText: 'Domanda', hintText: 'Inserisci domanda o titolo'),
        validator: (str) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == _questionKey);
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

  SettingsTile _answerSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci risposta',
        hint: 'Inserire risposta',
        description: 'Inserisci la risposta o il contenuto',
        child: _answer());
  }

  Widget _answer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _answerKey,
        focusNode: _answerFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: answerController,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLength: 15000,
        maxLines: null,
        onChanged: (value) => editState = true,
        decoration: textFieldInputDecoration(
            labelText: 'Risposta',
            hintText:
                'Inserisci risposta o contenuto dell\'argomento trattato'),
        validator: (str) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == _answerKey);
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

  SettingsTile _attachmentsSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci allegati',
        hint: 'Inserire allegati',
        description:
            'Inserisci allegati, ogni riga deve contenere un indirizzo nel formato "cartella/nomefile.png|Descrizione file"\r\nEsempio:\r\narticoli/group_list.png|Lista dei gruppi articolo',
        child: _attachments());
  }

  Widget _attachments() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _attachmentsKey,
        focusNode: _attachmentsFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: attachmentsController,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLength: 15000,
        maxLines: null,
        onChanged: (value) => editState = true,
        decoration:
            textFieldInputDecoration(labelText: 'Allegati', hintText: ''),
        validator: (str) {
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
        element = DataFrame(
            id: 0,
            question: questionController.text,
            answer: answerController.text,
            attachments: attachmentsController.text);
      } else {
        element = element!.copyWith(
            question: questionController.text,
            answer: answerController.text,
            attachments: attachmentsController.text);
      }
      Navigator.pop(context, element);
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
  }
}
