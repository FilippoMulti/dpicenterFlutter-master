import 'dart:convert';

import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/issue_attachment.dart';
import 'package:dpicenter/models/server/issue_model.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/image_loader/image_loader.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

// Define a custom Form widget.
class ReportProblemForm extends StatefulWidget {
  const ReportProblemForm({Key? key}) : super(key: key);

  @override
  ReportProblemFormState createState() {
    return ReportProblemFormState();
  }
}

class ReportProblemFormState extends State<ReportProblemForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController messageController;
  final GlobalKey<ImageLoaderState> loaderKey =
      GlobalKey<ImageLoaderState>(debugLabel: 'loaderKey');

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');
  final FocusNode _titleFocusNode = FocusNode(debugLabel: '_titleFocusNode');
  final FocusNode _messageFocusNode =
      FocusNode(debugLabel: '_messageFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _titleKey = GlobalKey(debugLabel: '_titleKey');
  final GlobalKey _messageKey = GlobalKey(debugLabel: '_messageKey');

  List<ItemPicture>? itemPictures = [];

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  @override
  void initState() {
    super.initState();
    initKeys();
    titleController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    _saveFocusNode.dispose();
    _titleFocusNode.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _titleKey),
      KeyValidationState(key: _messageKey),
    ];
  }

  InputDecoration _titleInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Titolo',
        hintText: 'Inserisci il titolo del problema o del suggerimento');
  }

  InputDecoration _messageInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Messaggio',
        hintText: 'Inserisci il messaggio con la descrizione del problema');
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
            const DialogTitleEx(
                "Segnala un problema o suggerisci uno sviluppo"),
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
                onSave: () async {
                  await validateSave();
                })
          ],
        ),
      ),
    );
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(title: const Text("Inserimento dati"), tiles: [
      _titleSettingTile(),
      _messageSettingTile(),
      _imagesSettingTile(),
    ]);
  }

  SettingsTile _titleSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci titolo',
        hint: 'Inserire titolo',
        description: 'Inserisci il titolo del problema o del suggerimento',
        child: _title());
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _titleKey,
        focusNode: _titleFocusNode,
        maxLines: null,
        //autofocus: isDesktop ? true : false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: titleController,
        maxLength: 5000,
        onChanged: (value) => editState = true,
        decoration: _titleInputDecoration(),
        validator: (str) {
          KeyValidationState state =
          _keyStates.firstWhere((element) => element.key == _titleKey);
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

  SettingsTile _messageSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci messaggio',
        hint: 'Inserire messaggio',
        description:
        'Inserisci il messaggio con la descrizione del problema o del suggerimento',
        child: _message());
  }

  Widget _message() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _messageKey,
        focusNode: _messageFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: messageController,
        textInputAction: TextInputAction.next,
        maxLength: 5000,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        onChanged: (value) => editState = true,
        decoration: _messageInputDecoration(),
        validator: (str) {
          KeyValidationState state =
          _keyStates.firstWhere((element) => element.key == _messageKey);
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
          //_saveFocusNode.requestFocus();
        },
      ),
    );
  }

  SettingsScrollSection _imagesSection() {
    return SettingsScrollSection(
      title: const Text(
        'Immagini',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: [
        _imagesSettingTile(),
      ],
    );
  }

  Widget _imagesSettingTile() {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ServerDataBloc<Media>>(
            lazy: false,
            create: (context) => ServerDataBloc<Media>(
                repo:
                    MultiService<Media>(Media.fromJsonModel, apiName: "Media")),
          ),
          BlocProvider<PictureBloc>(
            lazy: false,
            create: (context) => PictureBloc(),
          ),
          BlocProvider<MediaBloc>(
            lazy: false,
            create: (context) => MediaBloc(),
          ),
        ],
        child: getImagesSettingTile(
            title: 'Seleziona immagini da associare alla segnalazione',
            hint: 'Lista immagini',
            description:
                'Immagini che possono aiutare a capire il problema o il suggerimento',
            icon: const Icon(Icons.photo_album),
            onChanged: (value) {
              itemPictures = value;
            },
            onLoaded: (value) {},
            itemPictures: itemPictures ?? [],
            loaderKey: loaderKey));
  }

  Future validateSave() async {
    if (_formKey.currentState!.validate() &&
        loaderKey.currentState?.compressStatus == 0) {
      Navigator.pop(
          context,
          IssueModel(
              title: titleController.text,
              message: messageController.text,
              issueAttachments: itemPictures
                  ?.where((element) => element.mediaId != -1)
                  .map((e) => IssueAttachment(
                      name: e.picture?.name,
                      content: base64Encode(e.picture!.bytes!)))
                  .toList(growable: false)));
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
