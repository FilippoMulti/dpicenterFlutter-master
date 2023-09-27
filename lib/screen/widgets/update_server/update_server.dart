import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:dpicenter/models/server/send_model.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/useful/loading_screen_2.dart';
import 'package:dpicenter/screen/widgets/dashboard/pusher.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:universal_io/io.dart';

class UpdateServer extends StatefulWidget {
  const UpdateServer({Key? key}) : super(key: key);

  @override
  State<UpdateServer> createState() => _UpdateServerState();
}

class _UpdateServerState extends State<UpdateServer> {
  bool editState = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FilePickerResult? selectedFile;
  int sendedPart = 0;
  int totalToSend = 0;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 800),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const DialogTitleEx("Aggiornamento server"),
            Flexible(
                child: Scaffold(
              backgroundColor: getAppBackgroundColor(context),
              body: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(16),

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
                              _dataSectionBloc(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            _okCancelBloc(),
          ],
        ),
      ),
    );
  }

  Widget _okCancelBloc() {
    return BlocListener<ServerDataBloc, ServerDataState>(
      listener: (BuildContext context, ServerDataState state) {
        if (state is ServerDataCommandCompleted) {}
        if (state is ServerDataError) {}
      },
      child: BlocBuilder<ServerDataBloc, ServerDataState>(
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
              onCancel: () {
                Navigator.maybePop(context, null);
              },
              okText: 'AVVIA AGGIORNAMENTO',
              onSave: () {
//devo validare
                send();
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

  Widget _dataSectionBloc() {
    return BlocListener<ServerDataBloc, ServerDataState>(
      listener: (BuildContext context, ServerDataState state) {
        if (state is ServerDataCommandCompleted) {}
        if (state is ServerDataError) {}
      },
      child: BlocBuilder<ServerDataBloc, ServerDataState>(
          builder: (BuildContext context, ServerDataState state) {
        bool withProgress = false;
        try {
          switch (state.event!.status) {
            case ServerDataEvents.command:
            default:
              if (state is ServerDataCommandCompleted) {
                withProgress = false;
                /*if (state.items!=null) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Navigator.of(context).pop(state.items);
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        _formKey.currentState?.validate();
                      });
                    }*/
              }
              if (state is ServerDataLoading) {
                withProgress = true;
              }
              break;
          }
          return _dataSection(withProgress: withProgress);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          return Container();
        }
      }),
    );
  }

  send() {
    var bloc = BlocProvider.of<ServerDataBloc>(context);

    bloc.add(ServerDataEvent(
      command: (bloc) async {
        Uint8List? bytes;
        String filename = '';
        if (!kIsWeb) {
          if (selectedFile?.files.first.path != null) {
            bytes = await File(selectedFile!.files.first.path!).readAsBytes();
            filename = selectedFile!.files.first.name;
          }
        } else {
          if (selectedFile?.files.first.bytes != null) {
            bytes = selectedFile!.files.first.bytes;
            filename = selectedFile!.files.first.name;
          }
        }
        if (bytes != null) {
          Dio dio = Dio();
          try {
            dio.options.headers['content-Type'] = "application/json";
            dio.options.headers['authorization'] =
                "Bearer ${prefs!.getString('token') ?? ""}";

            dio.options.headers['app_version'] =
                "${startConfig?.currentVersionString} (${startConfig?.currentVersion})";
            dio.options.headers['current_os'] = currentOs();
            dio.options.headers['current_device_info'] = currentDeviceName;

            dio.options.sendTimeout = const Duration(milliseconds: 360000);
            ;
            dio.options.receiveTimeout = const Duration(milliseconds: 360000);
            ;

            var response = await dio.post(
              "https://${MultiService.baseUrl}/api/Management/send",
              data: jsonEncode(SendModel(base64Encode(bytes), filename)),
              onSendProgress: (int sent, int total) {
                setState(() {
                  sendedPart = sent;
                  totalToSend = total;
                });
                print("$sent $total");
              },
            );

            dio.close(force: true);
          } catch (e) {
            print(e);
          }

          //print(response.toString());
        }
      },
      status: ServerDataEvents.command,
    ));
  }

  SettingsScrollSection _dataSection({bool withProgress = false}) {
    return SettingsScrollSection(
        title: const Text("Seleziona aggiornamento"),
        tiles: [
          _selectFileTile(withProgress: withProgress),
        ]);
  }

  SettingsTile _selectFileTile({bool withProgress = false}) {
    return getCustomSettingTile(
        title: 'Seleziona file',
        hint: 'Seleziona file',
        description: "Seleziona un file zip con l'aggiornamento da effettuare",
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _selectFile(),
            if (withProgress) const SizedBox(height: 8),
            if (withProgress)
              FAProgressBar(
                animatedDuration: const Duration(milliseconds: 10),
                maxValue: double.parse(totalToSend.toString()),
                backgroundColor: Theme.of(context).colorScheme.background,
                progressColor: Theme.of(context).colorScheme.primary,
                currentValue: double.parse(sendedPart.toString()),
              ),
          ],
        ));
  }

  Widget _selectFile() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: Text(
                selectedFile?.files.first.name ?? 'Nessun file selezionato')),
        ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.any,
                allowMultiple: false,
              );
              if (result != null) {
                /*       setState(() {
                imageGridKeyString=Random().nextInt(1000000).toString();
              });*/
                editState = true;
                setState(() {
                  selectedFile = result;
                });
                //await _compressFile(result);
              }
            },
            child: const Text("Seleziona"))
      ],
    );
  }
}

Future showUpdateServer(BuildContext context) async {
  var result = await showPusher(
      context,
      Pusher(
          command: (BuildContext context) {},
          child: MultiBlocProvider(providers: [
            BlocProvider<ServerDataBloc>(
              lazy: false,
              create: (context) => ServerDataBloc(
                  repo: MultiService(null, apiName: 'Management')),
            ),
          ], child: const UpdateServer())));
  return result;
}
