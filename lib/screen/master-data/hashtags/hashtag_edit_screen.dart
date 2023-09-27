import 'dart:ui' as ui;

import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/hashtag.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtag_global.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:settings_ui/settings_ui.dart';

import '../validation_helpers/key_validation_state.dart';

// Define a custom Form widget.
class HashTagEditForm extends StatefulWidget {
  final HashTag? element;
  final String? title;

  final bool showActions;
  final VoidCallback? onCancel;
  final Function(HashTag?)? onSave;
  final bool roundedActionsContainer;

  final double width;

  const HashTagEditForm(
      {Key? key,
      required this.element,
      required this.title,
      this.showActions = true,
      this.onCancel,
      this.onSave,
      this.roundedActionsContainer = false,
      this.width = 500})
      : super(key: key);

  @override
  HashTagEditFormState createState() {
    return HashTagEditFormState();
  }
}

class HashTagEditFormState extends State<HashTagEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final List<HashTag> _filters = <HashTag>[];
  final _hexController = TextEditingController();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  HashTag? element;

  late ui.VoidCallback? _nameListener;
  int currentHashTagColor = Colors.purple.value;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  ///chiavi per i campi da compilare
  final GlobalKey _nameKey = GlobalKey(debugLabel: '_nameKey');
  final GlobalKey _descriptionKey = GlobalKey(debugLabel: '_descriptionKey');
  late List<KeyValidationState> _keyStates;

  bool editState = false;

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _nameKey),
      KeyValidationState(key: _descriptionKey),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    nameController.removeListener(_nameListener!);
    nameController.dispose();
    descriptionController.dispose();
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _scrollController.dispose();
    _hexController.dispose();
  }

  @override
  void initState() {
    super.initState();

    initKeys();

    element = widget.element;
    _nameListener = () {
      setState(() {});
    };

    if (element != null) {
      nameController = TextEditingController(text: element!.name);
      descriptionController = TextEditingController(text: element!.description);
      currentHashTagColor = element!.color == null
          ? Colors.purple.value
          : int.parse(element!.color!);
    } else {
      nameController = TextEditingController();
      descriptionController = TextEditingController();
      currentHashTagColor = Colors.purple.value;
    }
    nameController.addListener(_nameListener!);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return FocusScope(
      child: Container(
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
                    width: widget.width,

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
            //const Divider(),
            if (widget.showActions)
              SizedBox(
                width: widget.width,
                child: OkCancel(
                  onCancel: widget.onCancel ??
                      () {
                        Navigator.maybePop(context, null);
                      },
                  onSave: () => validateSave(),
                  borderRadius: widget.roundedActionsContainer
                      ? BorderRadius.circular(20)
                      : const BorderRadius.vertical(
                          top: Radius.circular(20), bottom: Radius.circular(2)),
                  elevation: widget.roundedActionsContainer ? 0 : 8,
                ),
              )
          ],
        ),
      ),
    );
  }

  final FocusNode _nameFocusNode = FocusNode(debugLabel: 'nameFocusNode');
  final FocusNode _descriptionFocusNode =
      FocusNode(debugLabel: 'descriptionFocusNode');

  InputDecoration _nameInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Etichetta',
        hintText: 'Inserisci un etichetta per questo hashtag');
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(title: const Text("Inserimento dati"), tiles: [
      _nameSettingTile(),
      _descriptionSettingTile(),
      _exampleChipSettingTile(),
    ]);
  }

  SettingsTile _nameSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci etichetta',
        hint: 'Inserire etichetta',
        description: 'Inserisci un etichetta per questo hashtag',
        child: _name());
  }

  Widget _name() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _nameKey,
        focusNode: _nameFocusNode,
        onTap: () {
          if (MediaQuery.of(context).size.height <= tinyHeight && isMobile) {
            _nameFocusNode.unfocus();
            showFullScreenKeyboard(context, nameController,
                decoration: _nameInputDecoration());
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: nameController,
        maxLength: 50,
        decoration: _nameInputDecoration(),
        validator: (str) {
          if (str!.isEmpty) {
            KeyValidationState state =
                _keyStates.firstWhere((element) => element.key == _nameKey);
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            KeyValidationState state =
                _keyStates.firstWhere((element) => element.key == _nameKey);
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        onChanged: (value) => editState = true,
      ),
    );
  }

  InputDecoration _descriptionInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Descrizione',
        hintText:
            'Inserisci una descrizione che spieghi l\'utilizzo di questo hashtag');
  }

  SettingsTile _descriptionSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci descrizione',
        hint: 'Inserire descrizione',
        description:
            'Inserisci una descrizione che spieghi l\'utilizzo di questo hashtag',
        child: _description());
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _descriptionKey,
        focusNode: _descriptionFocusNode,
        onChanged: (value) => editState = true,
        onTap: () {
          if (MediaQuery.of(context).size.height <= tinyHeight && isMobile) {
            //_descriptionFocusNode.unfocus();
            showFullScreenKeyboard(context, descriptionController,
                decoration: _descriptionInputDecoration());
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: descriptionController,
        maxLength: 500,
        decoration: _descriptionInputDecoration(),
        validator: (str) {
          if (str!.isEmpty) {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _descriptionKey);
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _descriptionKey);
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
      ),
    );
  }

  SettingsTile _exampleChipSettingTile() {
    return getCustomSettingTile(
        title: 'Antemprima hashtag',
        hint: 'Antemprima hashtag',
        description: 'Come apparirà l\'hashtag',
        child: _exampleChip());
  }

  Widget _exampleChip() {
    HashTag exampleTag = HashTag(
        hashTagId: 0,
        name: nameController.text,
        description: descriptionController.text,
        color: currentHashTagColor.toString());

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        getHashTagItem(
          tag: exampleTag,
          selected: () {
            return _filters.contains(exampleTag);
          },
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(exampleTag);
              } else {
                _filters.removeWhere((HashTag tag) {
                  return tag == exampleTag;
                });
              }
            });
          },
        ),
        ElevatedButton(
            onPressed: () {
              _selectColorPicker();
            },
            child: const Text("Seleziona colore"))
      ],
    );
  }

  /*Widget _selectColor() {
    return Center(
        child: Row(
      children: [
        Padding(
            padding: EdgeInsets.all(16),
            child: Container(width: 50, height: 50, color: Colors.purple)),
        SizedBox(
          width: 16,
        ),
        ElevatedButton(
            onPressed: () {
              _selectColorPicker();
            },
            child: Text("Seleziona colore"))
      ],
    ));
  }*/

  _selectColorPicker() {
    // raise the [showDialog] widget
    showDialog(
      context: context,
      builder: (context) {
        return multiDialog(
          title: const Text('Seleziona un colore'),
          content: SingleChildScrollView(
            child: ColorPicker(
              hexInputBar: true,
              hexInputController: _hexController,
              pickerColor: Color(currentHashTagColor),
              onColorChanged: (color) {
                setState(() {
                  editState = true;
                  currentHashTagColor = color.value;
                });
              },
            ),
            // Use Material color picker:
            //
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   showLabel: true, // only on portrait mode
            // ),
            //
            // Use Block color picker:
            //
            // child: BlockPicker(
            //   pickerColor: currentColor,
            //   onColorChanged: changeColor,
            // ),
            //
            // child: MultipleChoiceBlockPicker(
            //   pickerColors: currentColors,
            //   onColorsChanged: changeColors,
            // ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Copia'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _hexController.text));
              },
            ),
            ElevatedButton(
              child: const Text('Incolla'),
              onPressed: () async {
                ClipboardData? data = await Clipboard.getData('text/plain');
                debugPrint(data?.text ?? 'no data');
                _hexController.text =
                    (data != null ? data.text : _hexController.text)!;
                /*setState(() {


                });*/
              },
            ),
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
  }

  void validateSave() {
    if (_formKey.currentState!.validate()) {
      if (element == null) {
        element = HashTag(
            hashTagId: 0,
            name: nameController.text,
            description: descriptionController.text,
            color: currentHashTagColor.toString());
      } else {
        element = element!.copyWith(
            name: nameController.text,
            description: descriptionController.text,
            color: currentHashTagColor.toString());
        /*element!.name = nameController.text;
        element!.description = descriptionController.text;
        element!.color = currentHashTagColor.toString();*/
      }

      //Navigator.pop(ctx, textController.text);

      if (widget.onSave != null) {
        widget.onSave?.call(element);
      } else {
        Navigator.pop(context, element);
      }
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
/*Widget _okCancel() {
    return Center(
      child: Wrap(
        spacing: 10,
        children: [
          TextButton(
            onPressed: widget.onCancel ?? () {
              Navigator.pop(context, null);
            },
            child: const Text('ANNULLA'),
          ),
          ElevatedButton(
            onPressed:  () {

              if (_formKey.currentState!.validate()) {
                if (element == null) {
                  element = HashTag(
                      hashTagId: 0,
                      name: nameController.text,
                      description: descriptionController.text,
                      color: currentHashTagColor.toString());
                } else {
                  element!.name = nameController.text;
                  element!.description = descriptionController.text;
                  element!.color = currentHashTagColor.toString();
                }

                //Navigator.pop(ctx, textController.text);

                if (widget.onSave!=null){
                  widget.onSave?.call(element);
                } else {
                  Navigator.pop(context, element);
                }

              }
            },
            child: const Text(
              'SALVA',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}
