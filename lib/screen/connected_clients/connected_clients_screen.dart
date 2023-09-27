import 'dart:async';
import 'package:collection/collection.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/config/start_config_model.dart';
import 'package:dpicenter/models/server/connected_client_info.dart';
import 'package:dpicenter/screen/connected_clients/connected_client_item.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

enum ConnectedClientsScreenOpenType {
  open,
  select,
}

// Define a custom Form widget.
class ConnectedClientsScreen extends StatefulWidget {
  final String? osFilter;
  final String? userFilter;
  final ConnectedClientsScreenOpenType type;

  const ConnectedClientsScreen(
      {this.type = ConnectedClientsScreenOpenType.open,
      this.osFilter,
      this.userFilter,
      Key? key})
      : super(key: key);

  @override
  ConnectedClientsScreenState createState() {
    return ConnectedClientsScreenState();
  }
}

class ConnectedClientsScreenState extends State<ConnectedClientsScreen> {
  final _formKey = GlobalKey<FormState>();

  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;

  ///flag per visualizzare la schermata di caricamento solo al primo caricamento
  bool firstLoad = true;

  List<ConnectedClientInfo>? items;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  @override
  void initState() {
    super.initState();
    _connectToMessageHub();
    _loadConnectedClients();
  }

  _loadConnectedClients() {
    var bloc = BlocProvider.of<ServerDataBloc<ConnectedClientInfo>>(context);

    bloc.add(ServerDataEvent<ConnectedClientInfo>(
        status: ServerDataEvents.command,
        refresh: true,
        command: (bloc) async {
          String url = "api/Management/get-connected-clients";
          MultiService baseServiceEx =
              MultiService<ConnectedClientInfo>(null, apiName: 'Management');
          List<ConnectedClientInfo> clients = await baseServiceEx
                  .retrieveCommand(url, null, ConnectedClientInfo.fromJson)
              as List<ConnectedClientInfo>;

          return clients;
        }));
  }

  @override
  void dispose() {
    eventBusSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
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
            const DialogTitleEx("Client connessi"),
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
                        Expanded(
                          child: connectedClientList(),
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            OkCancel(
                cancelText: 'CHIUDI',
                onCancel: () {
                  Navigator.maybePop(context, null);
                })
          ],
        ),
      ),
    );
  }

  Widget connectedClientList() {
    return LayoutBuilder(builder: (context, constraints) {
      return BlocListener<ServerDataBloc<ConnectedClientInfo>, ServerDataState>(
          listener: (BuildContext context, ServerDataState state) {
        if (state is ServerDataCommandCompleted) {
          setState(() => firstLoad = false);
          items = state.items as List<ConnectedClientInfo>;
        }
      }, child:
              BlocBuilder<ServerDataBloc<ConnectedClientInfo>, ServerDataState>(
                  builder: (BuildContext context, ServerDataState state) {
        return firstLoad
            ? Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: shimmerComboLoading(context,
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    padding: EdgeInsets.zero,
                    borderRadius: 0),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SeparatedSettingsList(
                  shrinkWrap: true,
                  contentPadding: EdgeInsets.zero,
                  //contentPadding: EdgeInsets.zero,
                  lightTheme: const SettingsThemeData(
                    settingsSectionBackground: Colors.transparent,
                    settingsListBackground: Colors.transparent,
                  ),
                  darkTheme: const SettingsThemeData(
                    settingsSectionBackground: Colors.transparent,
                    settingsListBackground: Colors.transparent,
                  ),
                  platform: DevicePlatform.web,
                  automaticKeepAlive: false,
                  sections: [
                    BlocListener<ServerDataBloc<ConnectedClientInfo>,
                        ServerDataState>(
                      listener: (BuildContext context, ServerDataState state) {
                        if (state is ServerDataCommandCompleted) {
                          setState(() => firstLoad = false);
                          items = state.items as List<ConnectedClientInfo>;
                        }
                      },
                      child: BlocBuilder<ServerDataBloc<ConnectedClientInfo>,
                              ServerDataState>(
                          builder:
                              (BuildContext context, ServerDataState state) {
                                if (state is ServerDataCommandCompleted) {
                        } else {}

                        List<ConnectedClientInfo> filteredItems = [];
                        if (items != null) {
                          for (ConnectedClientInfo clientInfo in items!) {
                            bool add = true;
                            if (widget.osFilter != null) {
                              if (clientInfo.currentOs?.toLowerCase().contains(
                                      widget.osFilter!.toLowerCase()) ??
                                  false) {
                              } else {
                                add = false;
                              }
                            }
                            if (add) {
                              if (widget.userFilter != null) {
                                if (clientInfo.user?.toLowerCase().contains(
                                        widget.userFilter?.toLowerCase() ??
                                            '') ??
                                    false) {
                                  add = true;
                                } else {
                                  add = false;
                                }
                              }
                            }

                            if (add) {
                              filteredItems.add(clientInfo);
                            }
                          }
                        }

/*
                        var filteredItems = items?.where((element) =>
                            (widget.osFilter!= null && widget.osFilter!=null) ?
                            (element.currentOs?.toLowerCase().contains(widget.osFilter?.toLowerCase() ?? '') ?? false) : true
                        );
*/
                        return SettingsSection(
                            tiles: List.generate(filteredItems.length ?? 0,
                                (index) {
                          ConnectedClientInfo item = filteredItems[index];
                          return ConnectedClientItem(
                              item: item,
                              showDetails: widget.type ==
                                  ConnectedClientsScreenOpenType.open,
                              onPressed: widget.type ==
                                      ConnectedClientsScreenOpenType.select
                                  ? (context) {
                                      Navigator.of(context).pop(item);
                                    }
                                  : null);
                        }));
                      }),
                    ),
                  ],
                ),
              );
      }));
    });
  }

  _connectToMessageHub() {
    try {
      eventBusSubscription = eventBus.on<MessageHubEvent>().listen((event) {
        List<String> messageData = event.message?.split(';') ?? <String>[];
        String message = '';
        String sessionId = '';

        if (messageData.length == 2) {
          message = messageData[0];
          sessionId = messageData[1];
        }
        print("Message: $message");

        if (message.toLowerCase().contains("ondisconnectedclient") ||
            message.toLowerCase().contains("onconnectedclient")) {
          print("_loadConnectedClients();");
          _loadConnectedClients();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      eventBusSubscription = eventBus.on<ScanHubEvent>().listen((event) {
        showMessage(context,
            message: event.scanResult ?? '', title: 'Scan result');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

Future openConnectedClients(BuildContext context,
    {String? osFilter,
    String? userFilter,
    ConnectedClientsScreenOpenType openType =
        ConnectedClientsScreenOpenType.open}) async {
  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return multiDialog(
          content: MultiBlocProvider(
              providers: [
                BlocProvider<ServerDataBloc<ConnectedClientInfo>>(
                  lazy: false,
                  create: (context) => ServerDataBloc<ConnectedClientInfo>(
                      repo: MultiService<ConnectedClientInfo>(
                          ConnectedClientInfo.fromJsonModel,
                          apiName: "Management")),
                ),
              ],
              child: ConnectedClientsScreen(
                osFilter: osFilter,
                userFilter: userFilter,
                type: openType,
              )),
        );
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}
