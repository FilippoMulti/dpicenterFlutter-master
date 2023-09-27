import 'dart:async';

import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/change_key_model.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/useful/loading_screen.dart';
import 'package:dpicenter/screen/useful/loading_screen_2.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:settings_ui/settings_ui.dart';

class MatricolaChange extends StatefulWidget {
  final String? currentMatricola;

  const MatricolaChange({this.currentMatricola, Key? key}) : super(key: key);

  @override
  State<MatricolaChange> createState() => _MatricolaChangeState();
}

class _MatricolaChangeState extends State<MatricolaChange> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _matricolaChangeKey =
      GlobalKey(debugLabel: '_matricolaChangeKey');
  late TextEditingController _matricolaChangeController;
  Timer? _matricolaSearchTimer;
  bool _matricolaCheckPending = false;
  bool _matricolaAlreadyExist = false;
  late List<KeyValidationState> _keyStates;

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _matricolaChangeKey),
    ];
  }

  @override
  void initState() {
    initKeys();
    super.initState();
    _matricolaChangeController =
        TextEditingController(text: widget.currentMatricola);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 800, maxHeight: 800),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const DialogTitleEx('Cambia matricola'),
            _formDataBlocBuilder(),
            _okCancelBlocBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _okCancelBlocBuilder() {
    return BlocListener<ServerDataBloc<Machine>, ServerDataState<Machine>>(
      listener: (BuildContext context, ServerDataState state) {
        if (state is ServerDataCommandCompleted<Machine>) {}
        if (state is ServerDataError<Machine>) {}
      },
      child: BlocBuilder<ServerDataBloc<Machine>, ServerDataState<Machine>>(
          builder: (BuildContext context, ServerDataState state) {
        try {
          switch (state.event!.status) {
            case ServerDataEvents.command:
            default:
              if (state is ServerDataLoading) {
                return shimmerComboLoading(context,
                    height: 40,
                    padding: EdgeInsets.zero,
                    borderRadius: 0,
                    baseColor: isDarkTheme(context)
                        ? getScaffoldBackgroundColor(context)
                        : Color.alphaBlend(Colors.grey.shade300.withAlpha(200),
                            Theme.of(context).colorScheme.primary),
                    highlightColor: isDarkTheme(context)
                        ? Color.alphaBlend(
                            getScaffoldBackgroundColor(context).withAlpha(200),
                            Theme.of(context).colorScheme.primary)
                        : Color.alphaBlend(Colors.grey.shade100.withAlpha(100),
                            Theme.of(context).colorScheme.primary));
              }
              break;
          }
          return OkCancel(
              //okFocusNode: _saveFocusNode,
              onCancel: () {
            Navigator.maybePop(context, null);
          }, onSave: () {
            validateSave();
          });
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          return Container();
        }
      }),
    );
  }

  Widget _formDataBlocBuilder() {
    return BlocListener<ServerDataBloc<Machine>, ServerDataState<Machine>>(
      listener: (BuildContext context, ServerDataState state) {
        if (state is ServerDataCommandCompleted<Machine>) {}
        if (state is ServerDataError<Machine>) {}
      },
      child: BlocBuilder<ServerDataBloc<Machine>, ServerDataState<Machine>>(
          builder: (BuildContext context, ServerDataState state) {
        try {
          switch (state.event!.status) {
            case ServerDataEvents.command:
            default:
              if (state is ServerDataCommandCompleted) {
                if (state.items != null) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context).pop(state.items);
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    _formKey.currentState?.validate();
                  });
                }
              }
              if (state is ServerDataLoading) {
                return const LoadingScreen2(message: 'Operazione in corso');
              }
              break;
          }
          return Flexible(
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
                            SettingsScrollSection(tiles: [
                              getCustomSettingTile(
                                  title: 'Cambio matricola',
                                  hint: 'Inserisci nuova matricola',
                                  description:
                                      'Inserire la nuova matricola da assegnare alla macchina. La matricola deve essere univoca.',
                                  child: _matricolaTextFormField(
                                      _matricolaChangeKey,
                                      readOnly: false,
                                      controller: _matricolaChangeController,
                                      includeThisMatricola: true))
                            ]),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            //floatingActionButton: getFloatingActionButton(),
          ));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          return Container();
        }
      }),
    );
  }

  Future<bool> waitMatricolaCheck() async {
    while (_matricolaCheckPending) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return false;
  }

  validateSave() async {
    ///validazione
    if (_formKey.currentState!.validate()) {
      ///salvataggio
      _matricolaChange();
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
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  _matricolaChange() {
    var bloc = BlocProvider.of<ServerDataBloc<Machine>>(context);
    bloc.add(ServerDataEvent<Machine>(
      command: (bloc) async {
        await waitMatricolaCheck();
        if (_matricolaAlreadyExist) {
          return null;
        }
        MultiService serviceEx =
            MultiService<Machine>(Machine.fromJsonModel, apiName: 'VMMachine');
        String url = '/api/VMMachine/change-number/';
        List<JsonPayload>? result = await serviceEx.retrieveCommand(
            url,
            ChangeKeyModel(
                widget.currentMatricola ?? '', _matricolaChangeController.text),
            Machine.fromJsonModel);
        return result;
      },
      status: ServerDataEvents.command,
    ));
  }

  Widget _matricolaTextFormField(GlobalKey key,
      {bool readOnly = false,
      TextEditingController? controller,
      bool includeThisMatricola = false}) {
    return TextFormField(
      key: key,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLength: 50,
      onChanged: (value) {
        bool makeCheck = false;
        if (includeThisMatricola) {
          makeCheck = true;
        } else {
          if (value != widget.currentMatricola) {
            makeCheck = true;
          }
        }

        if (makeCheck) {
          _matricolaSearchTimer?.cancel();
          if (value.isNotEmpty) {
            _matricolaCheckPending = true;
            print("Value to check: $value");
            _matricolaSearchTimer =
                Timer(const Duration(milliseconds: 500), () async {
                  bool newValue = await _doesMatricolaAlreadyExist(value);
                  if (_matricolaAlreadyExist) {
                    print("Matricola già esistente");
                  }
                  _matricolaCheckPending = false;

                  setState(() {
                    _matricolaAlreadyExist = newValue;
                  });
                });
          } else {
            setState(() {
              _matricolaAlreadyExist = false;
            });
          }
        }
      },
      decoration: InputDecoration(
        enabled: true,
        //enabledBorder: OutlineInputBorder(),
        border: const OutlineInputBorder(),
        labelText: 'Matricola',
        hintText: 'Inserisci matricola della macchina',
        suffixIcon: (controller?.text.isNotEmpty ?? false)
            ? IconButton(
          onPressed: () {
            setState(() {
              Pasteboard.writeText(controller?.text ?? '');
            });
          },
          icon: const Icon(
            Icons.copy,
            size: 16,
          ),
        )
            : null,
      ),
      validator: (str) {
        if (str!.isEmpty) {
          KeyValidationState state =
          _keyStates.firstWhere((element) => element.key == key);
          _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: false);
          return "Campo obbligatorio";
        } else if (_matricolaAlreadyExist) {
          KeyValidationState state =
          _keyStates.firstWhere((element) => element.key == key);
          _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: false);
          return "Matricola già utilizzata";
        } else {
          KeyValidationState state =
          _keyStates.firstWhere((element) => element.key == key);
          _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
        }
        return null;
      },
    );
  }

  Future<bool> _doesMatricolaAlreadyExist(String matricola) async {
    MultiService<Machine> service =
        MultiService<Machine>(Machine.fromJson, apiName: "VMMachine");

    List<Machine>? result = await service.get(QueryModel(id: matricola));

    ///ritorno vero se la lista non è vuota
    return result?.isNotEmpty ?? false;
  }
}
