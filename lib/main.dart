/*import 'package:awesome_notifications/awesome_notifications.dart';*/
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
//import 'package:audioplayers/audioplayers.dart';

//import 'package:bitsdojo_window/bitsdojo_window.dart';
/*import 'package:bitsdojo_window_flutter3/bitsdojo_window.dart';*/
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dpicenter/blocs/login_bloc.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/models/server/application_user_detail.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/check_version_response.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/machine_history.dart';
import 'package:dpicenter/models/server/openai/data_frame.dart';
import 'package:dpicenter/models/server/openai/doc_frame.dart';
import 'package:dpicenter/models/server/report_header_view.dart';
import 'package:dpicenter/models/server/vmc_configuration.dart';
import 'package:dpicenter/models/server/vmc_production_category.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/autogeneration/vmc_configuration_screen.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/login/login_screen.dart';
import 'package:dpicenter/screen/master-data/application_profiles/application_profiles_screen_ex.dart'
    as ex;
import 'package:dpicenter/screen/master-data/application_users/application_users_screen_ex.dart'
    as ex;
import 'package:dpicenter/screen/master-data/customers/customers_screen_ex.dart'
    as ex;
import 'package:dpicenter/screen/master-data/data_event_logs/data_event_log_screen_ex.dart'
    as ex;
import 'package:dpicenter/screen/master-data/dataframes/data_frame_screen.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtags_screen_ex.dart'
    as ex;
import 'package:dpicenter/screen/master-data/items/items_screen.dart';
import 'package:dpicenter/screen/master-data/machines/machine_screen_ex.dart'
    as ex;
import 'package:dpicenter/screen/master-data/manufacturers/manufacturers_screen_ex.dart'
    as ex;
import 'package:dpicenter/screen/master-data/reports/report_screen_ex_2.dart';
import 'package:dpicenter/screen/master-data/sample_item/sample_items_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_production_categories/vmc_production_categories_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_production_fields/vmc_production_fields_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_setting_categories/vmc_setting_categories_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_setting_fields/vmc_setting_fields_screen.dart';
import 'package:dpicenter/screen/master-data/vmcs/vmcs_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_screen_ex2.dart';
import 'package:dpicenter/screen/widgets/barcode_web/barcode_web.dart';
import 'package:dpicenter/screen/widgets/multi_text_animation/text_animation_ex.dart';
import 'package:dpicenter/screen/widgets/screen_saver/screen_saver.dart';
import 'package:dpicenter/screen/widgets/signalr/log_list.dart';
import 'package:dpicenter/screen/widgets/top_widget_button.dart';
import 'package:dpicenter/scrollbehaviors/default_scroll_behavior.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/signalr/retry_policy.dart';
import 'package:dpicenter/theme_manager/theme_color.dart';
import 'package:dpicenter/theme_manager/theme_manager.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_azure_tts/flutter_azure_tts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:libserialport/libserialport.dart'
    if (dart.library.html) 'package:dpicenter/dummy/dummy_serialport.dart'
    if (dart.library.io) 'package:libserialport/libserialport.dart';
import 'package:path_provider/path_provider.dart';
/*import 'package:screen_recorder/screen_recorder.dart';*/
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_io/io.dart';
import 'package:vitality/models/ItemBehaviour.dart';
import 'package:vitality/models/WhenOutOfScreenMode.dart';
import 'package:vitality/vitality.dart';

import 'blocs/check_version_bloc.dart';
import 'blocs/server_data_bloc.dart';
import 'debug/debug_loader.dart';
import 'globals/event_message.dart';
import 'models/config/start_config_model.dart';
import 'models/menus/menu.dart';
import 'models/server/application_profile.dart';
import 'models/server/application_user.dart';
import 'models/server/autogeneration/sample_item.dart';
import 'models/server/customer.dart';
import 'models/server/data_event_log.dart';
import 'models/server/hashtag.dart';
import 'models/server/machine.dart';
import 'models/server/manufacturer.dart';
import 'screen/master-data/docframes/doc_frame_screen.dart';

Timer? watchdogTimer;
Timer? screenSaverTimer;

bool messageHubIsOpen = false;
/*final HelperService _helper = HelperService();*/

List<CameraDescription>? cameras;
//AudioPlayer? player;
int lastInteraction = 0;
/*String oldToken="";*/

Future<void> main() async {
  //ottimismo -> imposto il sistema come online
  isOnline = true;

  WidgetsFlutterBinding.ensureInitialized();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  final info = await deviceInfo.deviceInfo;
  currentDeviceInfo = info.toMap();
  try {
    if (Platform.isAndroid && !kIsWeb) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      String deviceName =
          "${info.manufacturer?.toUpperCase() ?? ''}-${info.model}";
      currentDeviceName =
          "$deviceName ${info.version.baseOS} ${info.version.codename} ${info.version.incremental} ${info.version.release} ${info.version.sdkInt} ${info.version.securityPatch} ${info.board} ${info.bootloader} ${info.brand} ${info.device}"
              .trim();
      //print(info.toMap());
    } else if (Platform.isIOS && !kIsWeb) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      currentDeviceName =
      "${info.name} ${info.systemName} ${info.systemVersion} ${info.model} ${info.localizedModel}";
      //print(info.toMap());
    } else if (Platform.isLinux && !kIsWeb) {
      LinuxDeviceInfo info = await deviceInfo.linuxInfo;
      currentDeviceName =
      "${info.name} ${info.version} ${info.id} ${info.versionCodename} ${info.versionId}";
      //print(info.toMap());
    } else if (Platform.isMacOS && !kIsWeb) {
      MacOsDeviceInfo info = await deviceInfo.macOsInfo;
      currentDeviceName =
      "${info.computerName} ${info.hostName} ${info.arch} ${info.model} ${info.kernelVersion}";
      //print(info.toMap());
    } else if (Platform.isWindows && !kIsWeb) {
      WindowsDeviceInfo info = await deviceInfo.windowsInfo;
      currentDeviceName =
      "${info.computerName} ${info.numberOfCores} ${info.systemMemoryInMegabytes}";
      //print(info.toMap());
    } else if (kIsWeb) {
      WebBrowserInfo info = await deviceInfo.webBrowserInfo;
      currentDeviceName =
          "${info.browserName} ${info.userAgent} ${info.appVersion}";
      //print(info.toMap());
    }
  } catch (e) {
    currentDeviceName = "Unknown";
    print(e);
  }
  if (!isWindows) {
    //player = AudioPlayer();
  }
  print("currentDeviceName: $currentDeviceName");
  ByteData bytes = await rootBundle.load('graphics/default.webp');
  defaultBackgroundBytes = bytes.buffer.asUint8List();

  try {
    cameras = await availableCameras();
  } catch (e) {
    print(e);
  } finally {}

  //openSerialPort();

  //loginInfo = Auth();

  ///utile per identificare la sessione tra tutte quelle collegate al server
  ///viene inserito nell'header della richiesta web
  sessionId = getRandString(25);

  ///permette ad Android di accettare la connessione al servizio anche con certificato Self Signed
  ///TODO: verificare come utilizzare effettivamente il certificato dell'app
  /* if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }*/

  ///DATABASE LOCALE
  //dbFactory = getDatabaseFactory(packageName: "dpicenter", rootPath: ".");

  /* /// Open the database
  try {
    db = await dbFactory!.openDatabase('dpicenter.db');
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }*/

  ///preference
  prefs = await SharedPreferences.getInstance();

  try {
    startConfig = await StartConfig.loadFromAsset();

    if (startConfig!.url != null) {
      //TODO: se kIsWeb utilizzare startConfig!.url come baseUrl altrimenti
      //per debug lascio attivo il salvataggio nei preference della baseUrl
      String? url = prefs!.getString(urlSetting);
      if (url == null) {
        prefs!.setString("url", startConfig!.url!);
      }
      /*if (kIsWeb){
        BaseServiceEx.baseUrl = startConfig!.url!;
      } else {
        BaseServiceEx.baseUrl = prefs!.getString("url")!;
      }*/

      MultiService.baseUrl = prefs!.getString(urlSetting)!;
    }
    if (kDebugMode) {
      if (kDebugMode) {
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(startConfig!.toJson());
        print(prettyprint);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  //signalr

  try {
    // _createMessageHub();

/*
    messageHub!.on('ReceiveMessage', (message) {
      if (message![0].toString()=="1"){

      }
      print(message.toString());
    });
    messageHub!.onreconnected((connectionId) {
      print("M onReconnected: ");});
    messageHub!.onreconnecting((connectionId) {
      print("M onReconnecting: ");});
    messageHub!.onclose((connectionId) {
      print("M onClose: ");});
*/
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  //Intl.systemLocale = await findSystemLocale();
  Intl.defaultLocale = 'it_IT';

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  try {
    html.window.document.onContextMenu.listen((evt) => evt.preventDefault());
  } catch (e) {
    print(e);
  }

  runApp(const DpiCenterApp());

  if (isWindows || isLinux) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(500, 500);
      //win.minSize = initialSize;
      win.minSize = initialSize;

/*
      if (Platform.isLinux) {
        win.size = initialSize;
      }
*/
      win.alignment = Alignment.center;
      win.title = "Dpi Center";

      if (Platform.isWindows || Platform.isLinux) {
        // TODO: remove this once https://github.com/bitsdojo/bitsdojo_window/issues/193 fixed
        WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
          if (appWindow.isMaximized) {
            appWindow.restore();
          }
          appWindow.size = appWindow.size + const Offset(0, 1);
        });
      }

      /*if (win.isMaximized) {
        win.restore();
        win.size = Size(win.size.width - 1, win.size.height - 1);


        //win.maximize();
      } else {
        win.size = Size(win.size.width + 1, win.size.height + 1);
        win.size = Size(win.size.width - 1, win.size.height + 1);
      }*/

      win.show();
    });
  }
  //spengo watchdog
  //watchdogTimer.cancel();
}

Future<bool?> _startMessageHub() async {
  try {
    if (messageHub != null &&
        messageHub!.state == HubConnectionState.disconnected) {
      await messageHub!.start();
      return true;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return false;
}

Future<String> loadAsset(String asset) async {
  return await rootBundle.loadString(asset);
}

class DpiCenterApp extends StatefulWidget {
  final String? initialRoute;

  const DpiCenterApp({Key? key, this.initialRoute}) : super(key: key);

  @override
  _DpiCenterAppState createState() {
    return _DpiCenterAppState();
  }

  static _DpiCenterAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_DpiCenterAppState>();
}

class _DpiCenterAppState extends State<DpiCenterApp>
    with TickerProviderStateMixin {
  List<String> currentTrace = <String>[];
  List<String> currentLogTrace = <String>[];
  final TransformationController _trasformationController =
      TransformationController();

  bool scaleEnabled = false;
  int recordEnabled = 0;

  ///Comunicazione seriale su Windows, per ricevere le letture dei codici a barre
  SerialPortReader? reader;
  List<String>? availablePorts;
  SerialPort? port;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _logScrollController = ScrollController();

  void openSerialPort() {
    if (isWindows && (port == null || port!.isOpen == false)) {
      availablePorts = SerialPort.availablePorts;

      if (availablePorts?.isNotEmpty ?? false) {
        port = SerialPort(availablePorts!.last);
        port!.openRead();
      }
      if (port == null) {
        debugPrint("port is null");
      } else if (!port!.isOpen && !port!.openRead()) {
        debugPrint(SerialPort.lastError.toString());
      } else {
        //port.write(Uint8List.fromList("MY_COMMAND".codeUnits));
        if (!kIsWeb) {
          reader = SerialPortReader(port!);
          reader?.stream.listen((data) {
            debugPrint('received: ${utf8.decode(data)}');
            eventBus.fire(SerialMessageEvent(newEvent: data));
          });
        }
      }
    }
  }

  @override
  void reassemble() async {
    debugPrint('Captain, we are going down!!!');

    //closeSerialPort();
    /*try {
      if (messageHub != null &&
          messageHub!.state != HubConnectionState.disconnected) {
        _detachMessageHub();
      }

      //await _destroyMessageHub();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
*/
    /*if (watchdogTimer != null) {
      watchdogTimer!.cancel();
    }*/
    //baseMenu = null;

    super.reassemble(); // must call
  }

  @override
  void dispose() async {
    screenSaverTimer?.cancel();
    try {
      _detachMessageHub();
      await _destroyMessageHub();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    closeSerialPort();

    watchdogTimer?.cancel();

    super.dispose();
  }

  void closeSerialPort() {
    try {
      port?.close();
      reader?.close();
      reader?.port.close();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void restartMessageHub() async {
    try {
      _detachMessageHub();
      await _destroyMessageHub();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    //watchdogTimer?.cancel();

    ///quando viene eseguito un host restart è gia attivo,
    if (messageHub == null) {
      _createMessageHub();
    }
    _startMessageHub().then((value) {
      if (!(value as bool)) {
        _createWatchdog();
      } else {
        _connectToMessageHub();
      }
    });
  }

  @override
  void initState() {
    //_createWatchdog();

    navigatorKey = GlobalKey<NavigatorState>();
    navigationScreenKey = GlobalKey<NavigationScreenPageExState>(
        debugLabel: 'navigationScreenKey');

    ///messaggio chiusura app
    if ((isWindows || isLinux || isMac) && !kIsWeb && gShowCloseMessage) {
      FlutterWindowClose.setWindowShouldCloseHandler(() async {
        if (gShowCloseMessage) {
          return (await showCloseMessage() ?? false);
        }
        return true;
      });
    } else {
      if (kIsWeb) {
        FlutterWindowClose.setWebReturnValue('Vuoi uscire da Dpi Center?');
      }
    }

    AzureTts.init(
        subscriptionKey: "8edd987cb1124524ba038517deafa35c",
        region: "westeurope",
        withLogs: true);

    openSerialPort();

    _createWatchdog();

    ///quando viene eseguito un hot restart è gia attivo,
    ///restartMessageHub();
    /*
    if (messageHub == null) {
      _createMessageHub();
    }
    _startMessageHub().then((value) {
      if (!(value as bool)) {
        _createWatchdog();
      } else {
        _connectToMessageHub();
      }
    });*/

    eventBus.on<MessageHubEvent>().listen((event) {
      setState(() {
        if (currentTrace.length >= 200) {
          currentTrace.removeAt(currentTrace.length - 1);
        }
        currentTrace.insert(0, "${getNow()} >> ${event.message!}");
      });
    });

    eventBus.on<SignalREvent>().listen((event) {
      setState(() {
        if (messageHub != null) {
          messageHub!.invoke("SendInput", args: event.message);
        }
      });
    });

    eventBus.on<RestartHubEvent>().listen((event) {
      if (kDebugMode) {
        print("new uri: ${event.newUrl}");
      }
      restartMessageHub();
    });

    //eventBus.on<LogHubEvent>().listen((event) {
    //setState(() {
    //currentLogTrace.add(event.newEvent!);
    /* if (currentTrace.length >= 200) {
          currentTrace.removeAt(currentTrace.length - 1);
        }
        currentTrace.insert(0, "${getNow()} >> ${event.newEvent!}");*/
    //});
    //});

    asyncLoadStartConfig();

    ///PER SCREENSAVER
    /*
    lastInteraction = DateTime.now().millisecondsSinceEpoch;
    screenSaverTimer?.cancel();
    screenSaverTimer = startTimeout();
    */

//    baseMenu = Menu.load(context);

    super.initState();
  }

  Future<bool?> showCloseMessage() async {
    var result = await showDialog(
      context: navigatorKey!.currentContext!,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Chiusura DpiCenter',
            message: 'Vuoi chiudere l\'applicazione?',
            type: MessageDialogType.yesNo,
            yesText: 'SI',
            noText: 'NO',
            okPressed: () {
              Navigator.pop(context, true);
            },
            noPressed: () {
              Navigator.pop(context, false);
            });
      },
    ).then((value) async {
      return value;
      //return value
    });
    return result;
  }

  void asyncLoadStartConfig() async {
    try {
      ///inizializzo i localizationsDelegates questo permette di avere le date
      ///inizializzate prima dell'avvio effettivo della schermata di accesso
      ///Ancora prima di aprire la schermata di accesso veniva ricevuto un messaggio
      ///tramite signalr che necessitava di formattazione ma ciò causava l'eccezione "LocaleDataException mancata inizializzazione -> inizializeDataFormatting".
      for (final delegate in localizationsDelegates) {
        await delegate.load(Locale(window.locale.languageCode));
      }

      ///caricamento configurazione dagli assets
      startConfig = await StartConfig.loadFromAsset();

      if (startConfig!.url != null) {
        //TODO: se kIsWeb utilizzare startConfig!.url come baseUrl altrimenti
        //per debug lascio attivo il salvataggio nei preference della baseUrl
        String? url = prefs!.getString(urlSetting);
        if (url == null) {
          prefs!.setString("url", startConfig!.url!);
        }
        /*if (kIsWeb){
        BaseServiceEx.baseUrl = startConfig!.url!;
      } else {
        BaseServiceEx.baseUrl = prefs!.getString("url")!;
      }*/

        MultiService.baseUrl = prefs!.getString(urlSetting)!;
      }
      if (kDebugMode) {
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(startConfig!.toJson());
        print(prettyprint);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _createWatchdog() async {
    watchdogTimer = _startWatchdogTimer();
  }

  int _lastMessageTime = -1;

  Timer _startWatchdogTimer() {
    watchdogTimer?.cancel();
    return Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      try {
        //print("Watchdog Timer TICK");
        if (_lastMessageTime != -1) {
          //debugPrint(
          //    "Passed millisecs: ${(DateTime.now().microsecondsSinceEpoch - _lastMessageTime) / 1e3}");
        }
        if (_lastMessageTime == -1 ||
            (DateTime.now().microsecondsSinceEpoch - _lastMessageTime) / 1e3 >
                30000) {
          if ((isOnline ?? true) && _lastMessageTime != -1) {
            await Future.delayed(
                const Duration(seconds: 1),
                () => setState(() {
                      setState(() {
                        isOnline = false;
                      });
                    }));
          }
          _lastMessageTime = DateTime.now().microsecondsSinceEpoch;

          restartMessageHub();
        }
        /*  if (messageHub?.state == HubConnectionState.disconnected) {
          try {
            _startMessageHub().then((value) {
              if (!(value as bool)) {
                //_createWatchdog();
              } else {
                _connectToMessageHub();
              }
            });
            */ /*bool? result = await _startMessageHub();
            if (result != null && result == true) {
              _connectToMessageHub();
            } else {
              //ricreo il timer
              await _createWatchdog();
            }*/ /*
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }*/
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }

  _destroyMessageHub() async {
    if (messageHub != null) {
      try {
        try {
          messageHub!.stop();
          messageHub = null;
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  _createMessageHub() {
    try {
      messageHub = HubConnectionBuilder()
          .withAutomaticReconnect(DpiCenterReconnectPolicy(delay: 1000))
          .withUrl(
          "https://${MultiService.baseUrl}/messagehub",
              HttpConnectionOptions(
                client: !kIsWeb
                    ? IOClient(HttpClient()
                      ..badCertificateCallback = (x, y, z) => true)
                    : null,
                customHeaders: {
                  "Content-Type": "application/json; charset=UTF-8",
                  "Authorization": "Bearer ${prefs!.getString('token') ?? ""}",
                  "app_version":
                      "${startConfig?.currentVersionString} (${startConfig?.currentVersion})",
                  "current_os": currentOs(),
                  "current_device_info": currentDeviceName,
                },
                accessTokenFactory: () async {
                  return prefs!.getString('token');
                },
                logging: (level, message) async {
                  print("level $level");
                  if (level.toString() == "LogLevel.error") {
                    if (isOnline ?? true) {
                      await Future.delayed(
                          const Duration(seconds: 1),
                              () => setState(() {
                            setState(() {
                              isOnline = false;
                            });
                          }));
                    }
                  } else if (level.toString() == "LogLevel.information") {
                    if (!message.contains("RetryContext") &&
                        !message.contains("Reconnect")) {
                      if (!(isOnline ?? false)) {
                        await Future.delayed(
                            const Duration(seconds: 1),
                                () => setState(() {
                              setState(() {
                                isOnline = true;
                              });
                            }));
                      }
                    }
                  }

                  _lastMessageTime = DateTime.now().microsecondsSinceEpoch;
                  if (kDebugMode) {
                    print("$level $message");
                  }
                  if (currentTrace.length >= 200) {
                    currentTrace.removeAt(currentTrace.length - 1);
                  }
                  currentTrace.insert(0, "${getNow()} >> $level $message");
                  eventBus.fire(
                      LogHubEvent(newEvent: "${getNow()} >> $level $message"));

                  ///se non autorizzato oppure ora è disponibile un token
                  ///riavvio mi ricollego a signalr impostando il token
                  if ((message.contains("status") &&
                      message.contains(
                          "401")) /*|| (prefs!.getString('token') ?? "")!=oldToken*/) {
                    //oldToken = prefs!.getString('token') ?? "";
                    _destroyMessageHub();

                    if (messageHub == null) {
                      _createMessageHub();
                    }
                    _startMessageHub().then((value) {
                      if (!(value as bool)) {
                        _createWatchdog();
                      } else {
                        _connectToMessageHub();
                      }
                    });
                  }
                },
      )).build();

      messageHub!.serverTimeoutInMilliseconds = 30000;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _connectToMessageHub() {
    try {
      //_detachMessageHub();

      messageHub!.on('ReceiveMessage', messageHubCallback);
      //messageHub.in
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void messageHubCallback(List? message) async {
    print("messageHubCallback: ${message?.toString()}");

    //print('currentRoute: ${ModalRoute.of(context)?.settings.name ?? ''}');
    for (var element in message!) {
      if (element?.toString().contains("CheckVersion") ?? false) {
        ///verifica versione app
        String json = element?.toString().replaceAll("CheckVersion|", "") ?? '';
        if (json.isNotEmpty) {
          CheckVersionResponse sc = CheckVersionResponse.fromJsonModel(
              jsonDecode(json.substring(0, json.length - 1)));
          if (sc.version > startConfig!.currentVersion!) {
            ///sul server esiste una versione più recente;
            await Navigator.pushReplacementNamed(
                navigatorKey!.currentContext!, "/");
          }
        }
      } else if (element?.toString().contains("DirectMessage") ?? false) {
        /// messaggio diretto solo a questo client
        List<String> parts = element!.toString().split("|");
        if (parts.length >= 4) {
          String type = parts[1];

          ///DirectMessage|Command|From[connectionId]|From[FriendlyName]|Message
          switch (type.toLowerCase()) {
            case 'showmessage':

              ///DirectMessage|showMessage|From[connectionId]|From[FriendlyName]|Message
              if (navigatorKey?.currentContext != null) {
                showMessage(navigatorKey!.currentContext!,
                    title: "Messaggio da ${parts[3]}", message: parts[4]);
              }
              break;
            case 'scanrequest':
              if (isAndroid) {
                if (navigatorKey?.currentContext != null) {
                  ScanResult scanResult = await scanCodeWithCameraMobile();
                  if (scanResult.type == ResultType.Barcode) {
                    sendCommandToUser(messageHub, 'ScanResult', parts[2],
                        "${parts[4]}\t${scanResult.rawContent}");
                  }
                }
              } else if (kIsWeb) {
                /*try {
                cameras = await availableCameras();
              } catch (e) {
                print(e);
              } finally {}*/

                final screen = BarcodeScannerWidget((result) {
                  debugPrint("Result: ${result.toString()}");
                });

                Navigator.of(navigatorKey!.currentContext!)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return screen;
                }));
              }
              break;

            case 'scanresult':
              eventBus.fire(ScanHubEvent(scanResult: parts[4]));
              break;
            case 'show': //openai event
              eventBus.fire(OpenAiEvent(message: parts[4]));
              break;
            case 'showchat': //openai event
              eventBus.fire(OpenAiChatEvent(message: parts[4]));
              break;
            case 'connectionid': //openai event
              connectionId = parts[4];
              break;
            default:
              break;
          }
        }
      } else {
        eventBus.fire(MessageHubEvent(message: element));
      }
    }
  }

  void _detachMessageHub() {
    try {
      messageHub!.off('ReceiveMessage', method: messageHubCallback);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final Offset _offset = const Offset(100, 500);

  ///per generare screen dell'app
  final ScreenshotController _screenshotController = ScreenshotController();

  ///solo main senza la barra del windowsmanager
  final ScreenshotController _screenshotMainController = ScreenshotController();

/*  final ScreenRecorderController _screenRecorderController =
      ScreenRecorderController(
    pixelRatio: 0.5,
    skipFramesBetweenCaptures: 0,
  );*/
  final localizationsDelegates = const <LocalizationsDelegate>[
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    DebugDpi.debugDpi.setState = setState;

    final lightTextTheme =
        GoogleFonts.robotoTextTheme(ThemeData.light().textTheme);
    final darkTextTheme =
        GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme);

    /* final TextTheme textTheme = TextTheme(
      headline1: GoogleFonts.roboto(
          fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      headline2: GoogleFonts.roboto(
          fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      headline3: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400),
      headline4: GoogleFonts.roboto(
          fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      headline5: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
      headline6: GoogleFonts.roboto(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      subtitle1: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      subtitle2: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyText1: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyText2: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      button: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
      caption: GoogleFonts.roboto(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      overline: GoogleFonts.roboto(
          fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      */ /* bodySmall: GoogleFonts.roboto(
          color: Theme.of(context).textTheme.bodySmall?.color?.darken().darken())*/ /*
    );*/
    //final TextTheme textTheme = GoogleFonts.robotoTextTheme(Theme.of(context).textTheme);
    /*return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: handleInteraction,
      onPointerHover: handleInteraction,
      onPointerDown: handleInteraction,
      onPointerSignal: handleInteraction,
      child:*/
    print("isOnline-------------------------------------->: $isOnline");

    return ThemeModeHandler(
        manager: MyManager(),
        placeholderWidget: const Center(
          child: CircularProgressIndicator(),
        ),
        builder: (ThemeMode themeMode, ThemeColor themeColor) {
          return Builder(builder: (context) {
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              localizationsDelegates: localizationsDelegates,
              supportedLocales: const [
                Locale('it', 'IT'),
              ],
              scrollBehavior: DefaultScrollBehavior(),
              theme: getThisLightTheme(
                  context, themeMode, themeColor, lightTextTheme),
              darkTheme: getThisDarkTheme(
                  context, themeMode, themeColor, darkTextTheme),
              /*ThemeData(
                  useMaterial3: true,
                    brightness: Brightness.light,
                    //textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
                    textTheme: textTheme,
                    inputDecorationTheme: InputDecorationTheme(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color!))),
                    */ /* light theme settings */ /*
                    primarySwatch: Colors.green,
                    iconTheme: const IconThemeData(
                      color: Colors.green,
                    )),
                darkTheme: ThemeData(
                    brightness: Brightness.dark,
                    textTheme: textTheme,
                    //textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),

                    inputDecorationTheme: const InputDecorationTheme(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                    primarySwatch: Colors.green,
                    iconTheme: const IconThemeData(color: Colors.green)
                    */ /* dark theme settings */ /*
                    ),*/
              themeMode: themeMode,
              /* ThemeMode.system to follow system theme,
           ThemeMode.light for light theme,
           ThemeMode.dark for dark theme
        */

              debugShowCheckedModeBanner: true,
              title: 'DPI Center',
              builder: (context, child) {
                List items = <dynamic>[];

                Widget? mainWidget;
                if (isWindows || isLinux) {
                  ///la vista principale,
                  mainWidget = getWindowsMain(context, child!);
                } else {
                  if (kIsWeb) {
                    mainWidget = getMain(context, child!);
                  } else {
                    mainWidget = getMain(context, child!);
                  }
                  mainWidget = Screenshot(
                      controller: _screenshotMainController, child: mainWidget);
                }

                const ColorFilter greyscale = ColorFilter.matrix(<double>[
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]);
                items.add((!(isOnline ?? true))
                    ? ColorFiltered(
                        colorFilter: greyscale,
                        child: mainWidget,
                      )
                    : mainWidget);
                /*items.add(
                    AnimatedSwitcher(duration: const Duration(seconds:1),
                    child: (!(isOnline ?? true)) ?
                    SizedBox(
                      key: const ValueKey("offline"),
                      child: ColorFiltered(
                        colorFilter: greyscale,
                        child: mainWidget,
                      ),
                    ) : SizedBox(
                        key: const ValueKey("online"),
                        child: mainWidget)
                    ));*/
                //if (DebugDpi.debugDpi.debug) {
                if (kDebugMode) {
                  ///log di signalR
                  if (DebugDpi.debugDpi.debug) {
                    items.add(signalRDebugOverlay());
                  }

                  /*if (DebugDpi.debugDpi.debug) {
                      items.add(logDebugOverlay());
                    }*/

                  items.add(getPositionedButton());

                  ///pulsante flottante attualmente utilizzato per visualizzare il log di signalr
                  //items.add(getPositionedButton());
                }

                return Screenshot(
                  controller: _screenshotController,
                  child: Stack(
                      children: List.generate(
                          items.length, (index) => items[index])),
                );
              },
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/home':

                    ///non creare lo screen nel builder perchè fa si che venga richiamato il build in modo inaspettato e inatteso
                    ///creare una variabile al di fuori del build e restituirla nel build
                    ///TODO: E' possibile che questo errore sia presenti in altre parti del programma
                    ///TODO: E' necessario verificare
                    ///
                    Widget home2 =
                        NavigationScreenPageEx.withSearchBlocProvider(
                            key: navigationScreenKey, title: "Dpi center");
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return home2;
                    });
                  /*case '/home':
                      */ /*    if (kDebugMode) {
                          LocalSearchService searchService = LocalSearchService();
                          searchService.findMenu('Nuovo intervento').then((value) {
                            if (value.length > 0) {
                              value[0]?.command?.call();
                            }
                          });
                        }*/ /*
                      //if (kDebugMode) {

                      //}
                      final _home = NavigationScreenPage.withSearchBlocProvider(
                          'Dpi Center', baseMenu);
                      return MaterialPageRoute(builder: (BuildContext context) {
                        return _home;
                      });*/
                  case '/':
                    final login = loginScreen();
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return login;
                    });

                  case '/anagrafiche/produttori':
                    final menu = settings.arguments as Menu;
                    final manufacturerScreen =
                        manufacturersScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return manufacturerScreen;
                    });

                  case '/anagrafiche/modellivmc':
                    final menu = settings.arguments as Menu;
                    final vmcsScreen = vmcsScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return vmcsScreen;
                    });
                  case '/anagrafiche/articoli':
                    final menu = settings.arguments as Menu;
                    final itemsScreen = itemsScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return itemsScreen;
                    });
                  case '/anagrafiche/campionature':
                    final menu = settings.arguments as Menu;
                    final itemsScreen = samplesScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return itemsScreen;
                    });
                  case '/anagrafiche/clienti':
                    final menu = settings.arguments as Menu;
                    final customerScreen = customersScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return customerScreen;
                    });
                  case '/anagrafiche/macchine':
                    final menu = settings.arguments as Menu;
                    final machineScreen = machinesScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return machineScreen;
                    });
                  case '/anagrafiche/hashtags':
                    final menu = settings.arguments as Menu;
                    final hashTagsScreen = hashTagsScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return hashTagsScreen;
                    });
                  case '/anagrafiche/vmcsettingfields':
                    final menu = settings.arguments as Menu;
                    final vmcFieldSettingScreen =
                        vmcSettingFieldsScreen(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return vmcFieldSettingScreen;
                    });
                  case '/anagrafiche/vmcproductionfields':
                    final menu = settings.arguments as Menu;
                    final vmcFieldProductionScreen =
                        vmcProductionFieldsScreen(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return vmcFieldProductionScreen;
                    });
                  case '/anagrafiche/vmcsettingcategories':
                    final menu = settings.arguments as Menu;
                    final vmcCategorySettingScreen =
                        vmcSettingCategoriesScreen(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return vmcCategorySettingScreen;
                    });
                  case '/anagrafiche/vmcproductioncategories':
                    final menu = settings.arguments as Menu;
                    final vmcProductionSettingScreen =
                        vmcProductionCategoriesScreen(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return vmcProductionSettingScreen;
                    });
                  case '/accounts/operatori':
                    final menu = settings.arguments as Menu;
                    final applicationUserScreen =
                        applicationUsersScreenEx(context, menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return applicationUserScreen;
                    });
                  case '/accounts/profili':
                    final menu = settings.arguments as Menu;

                    final applicationProfileScreen =
                        applicationProfilesScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return applicationProfileScreen;
                    });
                  case '/interventi/assistenze':
                    final menu = settings.arguments as Menu;
                    final reportScreen = reportsScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return reportScreen;
                    });
                  case '/avanzate/eventi':
                    final menu = settings.arguments as Menu;
                    final dataEventLogsScreen =
                        dataEventLogsScreenEx(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return dataEventLogsScreen;
                    });
                  case '/avanzate/vmc_configuration':
                    final menu = settings.arguments as Menu;
                    final vmcConfigScreen =
                        vmcConfigurationScreen(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return vmcConfigScreen;
                    });
                  case '/avanzate/dataframes':
                    final menu = settings.arguments as Menu;
                    final dataFrameScr = dataFrameScreen(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return dataFrameScr;
                    });
                  case '/avanzate/docframes':
                    final menu = settings.arguments as Menu;
                    final docFrameScr = docFrameScreen(menu, null, false);
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return docFrameScr;
                    });
                }
                return null;
              },
              /*routes: <String, WidgetBuilder>{
                    '/home': (BuildContext context) {
                      return NavigationScreenPage.withSearchBlocProvider(
                          'Dpi Center', baseMenu);
                    },
                  },*/
            );
          });
        });
    /*);*/
  }

  handleInteraction(dynamic value) {
    //print("User Interaction");

    lastInteraction = DateTime.now().millisecondsSinceEpoch;
    /*screenSaverTimer?.cancel();

    screenSaverTimer = startTimeout();*/
  }

  startTimeout([int milliseconds = 1000]) {
    return Timer(Duration(milliseconds: milliseconds), handleTimeout);
  }

  void handleTimeout() async {
    print(
        "Timeout: ${DateTime.now().millisecondsSinceEpoch - lastInteraction}");
    if (DateTime.now().millisecondsSinceEpoch - lastInteraction >= 10000) {
      screenSaverTimer?.cancel();
      Uint8List? image = await _screenshotMainController.capture();

      if (mounted) {
        await showDialog(
            barrierColor: Colors.transparent,
            context: navigatorKey!.currentContext!,
            builder: (context) {
              return ScreenSaver(image!);
            });
      }
    }
    screenSaverTimer = startTimeout();
  }

  /*Widget _dialogImportaClienti() {


    return BlocBuilder<SyncBloc, SyncState>(
        builder: (BuildContext context, SyncState state) {
          switch(state.event!.status){
            case SyncEvents.idle:
              break;
            case SyncEvents.syncCustomers:
              break;
            case SyncEvents.syncMachines:
              break;
            default: break;
          }
        });

    var result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              content: ManufacturerEditForm(
                  row: row, element: item, title: "Modifica produttore"));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }*/
  Widget? background;

  Widget getVitalityBackground(BuildContext context) {
    var themeModeHandler = ThemeModeHandler.of(context);
    //var list = themeModeHandler!.themeColor.backgroundSelectedIcons.map((e) => e.toItemBehaviour()).toList(growable: false);
    String key = "${themeModeHandler!.themeColor.backgroundShowBackground}"
        "${themeModeHandler.themeColor.backgroundShowEffects}"
        "${themeModeHandler.themeColor.backgroundSelectedIcons?.map((e) => "${e.icon ?? ''}${e.shape.toString()}").toString()}"
        "${themeModeHandler.themeColor.backgroundEnableXMovements}"
        "${themeModeHandler.themeColor.backgroundEnableYMovements}"
        "${themeModeHandler.themeColor.backgroundMaxSize}"
        "${themeModeHandler.themeColor.backgroundMaxSpeed}"
        "${themeModeHandler.themeColor.backgroundMinSpeed}"
        "${themeModeHandler.themeColor.backgroundEffectsColors?.map((e) => e.toString()).toString()}";

    return Vitality.randomly(
      key: ValueKey(key),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      background: !themeModeHandler.themeColor.backgroundShowBackground
          ? Colors.black.withAlpha(200)
          : Colors.transparent,
      maxOpacity: 0.8,
      minOpacity: 0.3,
      itemsCount: 80,
      enableXMovements: themeModeHandler.themeColor.backgroundEnableXMovements,
      enableYMovements: themeModeHandler.themeColor.backgroundEnableYMovements,
      whenOutOfScreenMode: WhenOutOfScreenMode.Teleport,
      maxSpeed: themeModeHandler.themeColor.backgroundMaxSpeed,
      maxSize: themeModeHandler.themeColor.backgroundMaxSize,
      minSpeed: themeModeHandler.themeColor.backgroundMinSpeed,
      randomItemsColors:
          (themeModeHandler.themeColor.backgroundEffectsColors == null ||
                  themeModeHandler.themeColor.backgroundEffectsColors!.isEmpty)
              ? [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withAlpha(100)
                ]
              : (themeModeHandler.themeColor.backgroundEffectsColors!
                  .map((e) => Color(e))
                  .toList()),
      randomItemsBehaviours:
          themeModeHandler.themeColor.backgroundSelectedIcons != null
              ? themeModeHandler.themeColor.backgroundSelectedIcons!
                  .map((e) => e.toItemBehaviour())
                  .toList(growable: true)
              : [ItemBehaviour(shape: ShapeType.Icon, icon: Icons.star)],
      /*[
        ItemBehaviour(shape: ShapeType.Icon, icon: Icons.star),
        ItemBehaviour(shape: ShapeType.Icon, icon: Icons.star_border),
        ItemBehaviour(shape: ShapeType.StrokeCircle),
      ],*/
    );
  }


  Widget getWindowsMain(context, Widget child) {
    var themeModeHandler = ThemeModeHandler.of(context);
    bool showBackground =
        themeModeHandler?.themeColor.backgroundShowBackground ?? true;

    //showBackground = prefs!.getBool(showBackgroundImageSetting) ?? false;
/*
    currentBackgroundOpacity =
        themeModeHandler?.themeColor.backgroundOpacity ?? 1.0;
        prefs!.getDouble(backgroundOpacitySetting) ?? 0.95;
*/
    //background = getBackground(context);
    Menu baseMenu = Menu.load();
    return Builder(builder: (context) {
      var themeModeHandler = ThemeModeHandler.of(context);
      return Theme(
          data: Theme.of(context),
          child: Overlay(
            //    key: ValueKey("overlay"),
            initialEntries: [
              /*  OverlayEntry(builder: (context) {
                  return getBackground(context);
                }),*/

              /*  if (themeModeHandler!.themeColor.backgroundShowEffects)
              OverlayEntry(
                  maintainState: false,
                  builder: (context) {
                    return getVitalityBackground(context);
                  }),*/

              /* OverlayEntry(
                    maintainState: true,
                    builder: (context) {
                  return FloatingBubbles.alwaysRepeating(
                    noOfBubbles: 25,
                    colorsOfBubbles: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.onPrimary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.onSecondary,
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.onTertiary,
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                      Theme.of(context).colorScheme.tertiaryContainer,
                    ],
                    sizeFactor: 0.05,
                    opacity: 70,
                    paintingStyle: PaintingStyle.fill,
                    shape: BubbleShape.circle,
                    speed: BubbleSpeed.slow,

                  );

                }),*/
              OverlayEntry(builder: (context) {
                return WindowBorder(
                    key: windowsTitleKey,
                    color: Theme.of(context).colorScheme.primary,
                    width: 0,
                    child: Stack(
                      children: [
                        getBackground(context),
                        /*if (showBackground) Builder(
                            builder: (context) {
                              return getBackground(context);
                            }
                          ),*/

                        if (themeModeHandler
                            ?.themeColor.backgroundShowEffects ??
                            false)
                          getVitalityBackground(context),

                        /*getAnimatedBackground(),*/
                        Opacity(
                          opacity: showBackground
                              ? themeModeHandler
                              ?.themeColor.backgroundOpacity ??
                              0.87
                              : 1.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WindowTitleBarBox(
                                child: Container(
                                  color: isLightTheme(context)
                                      ? Theme.of(context).colorScheme.primary
                                      : Color.alphaBlend(
                                      Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withAlpha(240),
                                      Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 40,
                                          child: Material(
                                              type: MaterialType.transparency,
                                              child: Center(
                                                  child: IconButton(
                                                icon: const Icon(
                                                  Icons.masks,
                                                  color: Colors.white70,
                                                ),
                                                padding: EdgeInsets.zero,
                                                onPressed: () {},
                                              )))),
                                      if (themeModeHandler
                                              ?.themeColor.menuType !=
                                          0)
                                        ...List.generate(
                                            baseMenu.subMenus?.length ?? 0,
                                            (index) => MenuItemButton(
                                                  leadingIcon: baseMenu
                                                              .subMenus![index]
                                                              .icon !=
                                                          null
                                                      ? Icon(
                                                          icons[baseMenu
                                                              .subMenus![index]
                                                              .icon],
                                                          color: getMenuColor(
                                                              baseMenu
                                                                  .subMenus![
                                                                      index]
                                                                  .color),
                                                        )
                                                      : null,
                                                  child: Text(baseMenu
                                                      .subMenus![index].label),
                                                  onPressed: () {
                                                    navigationScreenKey
                                                        ?.currentState
                                                        ?.tabController
                                                        ?.index = index;
                                                  },
                                                )),

                                      /*SizedBox( width: 40, child: Material(type: MaterialType.transparency, child:  PopupMenuButton<int>(
                                                      color: Colors.black,
                                                      itemBuilder: (context) => [
                                                        const PopupMenuItem<int>(value: 0, child: Text("Setting")),
                                                        const PopupMenuItem<int>(
                                                            value: 1, child: Text("Privacy Policy page")),
                                                        const PopupMenuDivider(),
                                                        PopupMenuItem<int>(
                                                            value: 2,
                                                            child: Row(
                                                              children:const  [
                                                                Icon(
                                                                  Icons.logout,
                                                                  color: Colors.red,
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text("Logout")
                                                              ],
                                                            )),
                                                      ],
                                                      onSelected: (item) => {} //SelectedItem(context, item),
                                                  ))),*/
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: MoveWindow(
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(0),
                                                child: Text(
                                                    "Dpi Center ${startConfig!.currentVersionString!}v${startConfig!.currentVersion!}@${MultiService.baseUrl}${kServerVersionString != null ? " (${kServerVersionString ?? '?'} - ${kServerVersion ?? '?'})" : ''}",
                                                    maxLines: null,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.white70,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                              )),
                                        ),
                                      ),

                                      ///cambio tipo di menu
                                      SizedBox(
                                        width: 50,
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: ToggleButtons(
                                            isSelected: const [false],
                                            onPressed: (value) async {
                                              if (themeModeHandler != null) {
                                                int menuType = themeModeHandler
                                                    .themeColor.menuType;
                                                if (menuType < 1) {
                                                  menuType++;
                                                } else {
                                                  menuType = 0;
                                                }
                                                await ThemeModeHandler.of(
                                                        context)
                                                    ?.saveThemeMode(
                                                        themeModeHandler
                                                            .themeMode,
                                                        themeModeHandler
                                                            .themeColor
                                                            .copyWith(
                                                                menuType:
                                                                    menuType++));
                                              }
                                            },
                                            children: [
                                              Icon((themeModeHandler?.themeColor
                                                              .menuType ??
                                                          0) ==
                                                      0
                                                  ? Icons.tab
                                                  : Icons.menu_open)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: ToggleButtons(
                                            isSelected: [scaleEnabled],
                                            onPressed: (value) {
                                              setState(() {
                                                scaleEnabled = !scaleEnabled;
                                                if (!scaleEnabled) {
                                                  _trasformationController
                                                          .value =
                                                      Matrix4.identity();
                                                }
                                              });
                                            },
                                            children: const [
                                              Icon(Icons.zoom_in)
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                          child: IconButton(
                                        onPressed: () {
                                          _screenshotController
                                              .capture()
                                              .then((Uint8List? image) async {
                                            if (image != null) {
                                              String newPath = '';

                                              if (!kIsWeb) {
                                                    var tempDir =
                                                    await getTemporaryDirectory();
                                                    String tempPath = tempDir.path;
                                                    newPath =
                                                    "$tempPath${Platform.pathSeparator}screenDpiCenter.png";
                                                    saveFile(newPath, image);
                                                  } else {}
                                                  openFilepath(newPath,
                                                      bytes: image);
                                                }
                                              }).catchError((onError) {
                                                print(onError);
                                              });
                                            },
                                            tooltip: 'Fa uno screenshot',
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.screenshot,
                                                color: Colors.white70),
                                          )),
                                      /*             SizedBox(
                                            child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () async {
                                            if (recordEnabled == 0) {
                                              setState(() {
                                                ///inizio registrazione
                                                recordEnabled = 1;
                                              });
                                              _screenRecorderController.start();
                                            } else if (recordEnabled == 1) {
                                              setState(() {
                                                ///stop registrazione - elaborazione in corso
                                                recordEnabled = 2;
                                              });
                                              _screenRecorderController.stop();
                                              await Future.delayed(
                                                  const Duration(milliseconds: 500),
                                                  () async {
                                                var bytes =
                                                    await _screenRecorderController
                                                        .export();

                                                if (bytes != null) {
                                                  String newPath = '';

                                                  if (!kIsWeb) {
                                                    var tempDir =
                                                        await getTemporaryDirectory();
                                                    String tempPath = tempDir.path;
                                                    newPath =
                                                        "$tempPath${Platform.pathSeparator}screenRecDpiCenter.gif";
                                                    saveFile(newPath, bytes);
                                                  } else {}
                                                  openFilepath(newPath,
                                                      bytes: bytes);
                                                }

                                                setState(() {
                                                  ///completato tutto rimetto a 0 lo stato
                                                  recordEnabled = 0;
                                                });
                                              });
                                            }
                                          },
                                          icon: Icon(
                                              recordEnabled == 0
                                                  ? Icons.fiber_manual_record
                                                  : recordEnabled == 1
                                                      ? Icons.stop_circle
                                                      : recordEnabled == 2
                                                          ? Icons.movie
                                                          : Icons.add,
                                              color: recordEnabled == 1
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                          tooltip: recordEnabled == 0
                                              ? 'Inizia registrazione'
                                              : recordEnabled == 1
                                                  ? 'Termina registrazione'
                                                  : recordEnabled == 2
                                                      ? 'Creazione video in corso...'
                                                      : 'Sconosciuto',
                                        )),*/
                                      const WindowButtons(),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Screenshot(
                                  controller: _screenshotMainController,
                                  child: AnimatedSwitcher(
                                      duration:
                                      const Duration(milliseconds: 500),
                                      reverseDuration: Duration.zero,
                                      child: InteractiveViewer(
                                          transformationController:
                                          _trasformationController,
                                          maxScale: scaleEnabled ? 100 : 1,
                                          constrained: true,
                                          scaleEnabled: scaleEnabled,
                                          child: child)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ));
              }),
            ],
          ));
    });
  }

  Widget getMain(context, Widget child) {
    var themeModeHandler = ThemeModeHandler.of(context);
    bool showBackground =
        themeModeHandler?.themeColor.backgroundShowBackground ?? true;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkTheme(context)
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withAlpha(240),
              Theme.of(context).colorScheme.primary)
          : Theme.of(context).primaryColor,
    ));

    Widget background = getBackground(context);
    return Stack(children: [
      if (showBackground) background,
      if (themeModeHandler!.themeColor.backgroundShowEffects)
        getVitalityBackground(context),
      Opacity(
          opacity: showBackground
              ? themeModeHandler.themeColor.backgroundOpacity ?? 0.87
              : 1.0,
          child: child),
    ]);
  }

  Widget getAnimatedBackground() {
    return const Center(
        child: TextAnimationEx(
      text: "Dpi Center",
      cycleLetters: false,
    ));
  }

  Widget getBackground(context) {
    var themeModeHandler = ThemeModeHandler.of(context);

    Uint8List? image = themeModeHandler != null &&
            themeModeHandler.themeColor.backgroundImage != null &&
            themeModeHandler.themeColor.backgroundImage!.decodedContents != null
        ? themeModeHandler.themeColor.backgroundImage!.decodedContents!
        : null;

    Color? filterColor;

    if (themeModeHandler!.themeColor.backgroundFilterColors != null) {
      switch (themeModeHandler.themeColor.backgroundFilterColors!) {
        case ThemeFilterColors.custom:
          filterColor = themeModeHandler
                      .themeColor.backgroundCustomFilterColor !=
                  null
              ? Color(
                  themeModeHandler.themeColor.backgroundCustomFilterColor ?? 0)
              : Theme.of(context).colorScheme.primary;
          break;
        case ThemeFilterColors.transparent:
          filterColor = Colors.transparent;
          break;
        case ThemeFilterColors.system:
        default:
          filterColor = Theme.of(context).colorScheme.primary;
          break;
      }
    } else {
      filterColor = Theme.of(context).colorScheme.primary;
    }
    return themeModeHandler.themeColor.backgroundShowBackground
        ? IgnorePointer(
            child: Opacity(
              opacity: 1,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    filterColor,
                    themeModeHandler.themeColor.backgroundBlendMode ??
                        BlendMode.hue),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: image != null
                          ? DecorationImage(
                              image: Image.memory(image).image,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.medium)
                          : DecorationImage(
                              image: Image.asset(assetsImages[0]).image,
                              filterQuality: FilterQuality.medium,
                              fit: BoxFit.cover),
                    ),
                    /*child: Container(
                  color: Theme.of(context).colorScheme.primary.withAlpha(0)),*/
                    child: ClipRRect(
                        // make sure we apply clip it properly
                        child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX:
                              themeModeHandler.themeColor.backgroundBlurSigmaX,
                          sigmaY:
                              themeModeHandler.themeColor.backgroundBlurSigmaY),
                      child: Stack(
                        children: [
                          Container(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(0),
                          ),
                          navigatorKey?.currentContext != null &&
                                  !(isOnline ?? true)
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Builder(builder: (context) {
                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: DefaultTextStyle(
                                          style: TextStyle(color: Colors.white),
                                          child: Text("offline",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40))),
                                    );
                                  }))
                              : const SizedBox()
                        ],
                      ),
                    ))),
              ),
            ),
          )
        : const SizedBox();
  }

/*  Widget getBackground(context) {
    var themeModeHandler = ThemeModeHandler.of(context);

    Uint8List? image = themeModeHandler != null &&
            themeModeHandler.themeColor.backgroundImage != null &&
            themeModeHandler.themeColor.backgroundImage!.decodedContents != null
        ? themeModeHandler.themeColor.backgroundImage!.decodedContents!
        : null;

    Color? filterColor;

    if (themeModeHandler!.themeColor.backgroundFilterColors != null) {
      switch (themeModeHandler.themeColor.backgroundFilterColors!) {
        case ThemeFilterColors.custom:
          filterColor = themeModeHandler
                      .themeColor.backgroundCustomFilterColor !=
                  null
              ? Color(
                  themeModeHandler.themeColor.backgroundCustomFilterColor ?? 0)
              : Theme.of(context).colorScheme.primary;
          break;
        case ThemeFilterColors.transparent:
          filterColor = Colors.transparent;
          break;
        case ThemeFilterColors.system:
        default:
          filterColor = Theme.of(context).colorScheme.primary;
          break;
      }
    } else {
      filterColor = Theme.of(context).colorScheme.primary;
    }
    return themeModeHandler.themeColor.backgroundShowBackground
        ? IgnorePointer(
            child: Opacity(
              opacity: themeModeHandler.themeColor.backgroundShowBackground ? 1 : 0,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    filterColor,
                    themeModeHandler.themeColor.backgroundBlendMode ??
                        BlendMode.hue),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: image != null
                          ? DecorationImage(
                              image: Image.memory(image).image,
                              fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium)
                    : DecorationImage(
                    image: Image.asset(assetsImages[0]).image,
                        filterQuality: FilterQuality.medium,
                        fit: BoxFit.cover),
              ),
              */ /*child: Container(
                  color: Theme.of(context).colorScheme.primary.withAlpha(0)),*/ /*
              child: ClipRRect(
                        // make sure we apply clip it properly
                        child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX:
                              themeModeHandler.themeColor.backgroundBlurSigmaX,
                          sigmaY:
                              themeModeHandler.themeColor.backgroundBlurSigmaY),
                      child: navigatorKey?.currentContext!=null &&  !(isOnline ?? true) ?
                      Theme(
                        data: Theme.of(navigatorKey!.currentContext!), child: Container(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(0)
                        ,child: Align(
                          alignment: Alignment.bottomRight,
                          child: Builder(
                            builder: (context) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: DefaultTextStyle(style: TextStyle(color: Colors.white),
                                child: Text("offline", style: TextStyle(color: Colors.white, fontSize: 40))),
                              );
                            }
                          )) ),
                      ) : const SizedBox()

                    ))),
              ),
            ),
          ) : const SizedBox();
  }*/

  Widget getScreen(String destination,
      [Menu? menu,
      VoidCallback? customBackClick,
      context1,
      bool withBackButton = true]) {
    switch (destination) {
      case '/home':
        return const NavigationScreenPageEx(title: "Dpi center");
/*      case '/home':
        */ /*    if (kDebugMode) {
                    LocalSearchService searchService = LocalSearchService();
                    searchService.findMenu('Nuovo intervento').then((value) {
                      if (value.length > 0) {
                        value[0]?.command?.call();
                      }
                    });
                  }*/ /*
        return NavigationScreenPage.withSearchBlocProvider(
            'Dpi Center', baseMenu);*/
      case '/':
        return loginScreen();

      case '/anagrafiche/produttori':
        return manufacturersScreenEx(menu!, customBackClick, withBackButton);

      case '/anagrafiche/modellivmc':
        return vmcsScreenEx(menu!, customBackClick, withBackButton);
      case '/anagrafiche/articoli':
        return itemsScreenEx(menu!, customBackClick, withBackButton);
      case '/anagrafiche/campionature':
        return samplesScreenEx(menu!, customBackClick, withBackButton);
      case '/anagrafiche/clienti':
        return customersScreenEx(menu!, customBackClick, withBackButton);

      case '/anagrafiche/macchine':
        return machinesScreenEx(menu!, customBackClick, withBackButton);

      case '/anagrafiche/hashtags':
        return hashTagsScreenEx(menu!, customBackClick, withBackButton);
      case '/anagrafiche/vmcsettingfields':
        return vmcSettingFieldsScreen(menu!, customBackClick, withBackButton);
      case '/anagrafiche/vmcproductionfields':
        return vmcProductionFieldsScreen(
            menu!, customBackClick, withBackButton);

      case '/anagrafiche/vmcsettingcategories':
        return vmcSettingCategoriesScreen(
            menu!, customBackClick, withBackButton);
      case '/anagrafiche/vmcproductioncategories':
        return vmcProductionCategoriesScreen(
            menu!, customBackClick, withBackButton);

      case '/accounts/operatori':
        return applicationUsersScreenEx(
            context1, menu!, customBackClick, withBackButton);

      case '/accounts/profili':
        return applicationProfilesScreenEx(
            menu!, customBackClick, withBackButton);

      case '/interventi/assistenze':
        return reportsScreenEx(menu!, customBackClick, withBackButton);

      case '/avanzate/eventi':
        return dataEventLogsScreenEx(menu!, customBackClick, withBackButton);

      case '/avanzate/vmc_configuration':
        return vmcConfigurationScreen(menu!, customBackClick, withBackButton);
      case '/avanzate/dataframes':
        return dataFrameScreen(menu!, customBackClick, withBackButton);
      case '/avanzate/docframes':
        return docFrameScreen(menu!, customBackClick, withBackButton);
      default:
        return loginScreen();
    }
  }

  Widget loginScreen() {
    return MultiBlocProvider(
        key: const ValueKey("loginScreen"),
        providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) =>
                LoginBloc(loginRepo: LoginServices()),
          ),
          BlocProvider<CheckVersionBloc>(
            create: (BuildContext context) =>
                CheckVersionBloc(repo: CheckVersionServices()),
          ),
        ],
        child: const LoginScreen());
  }

  Widget vmcsScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("vmcsScreenBloc"),
        lazy: false,
        create: (context) => ServerDataBloc<Vmc>(
            repo: MultiService<Vmc>(Vmc.fromJsonModel, apiName: "Vmc")),
        child: VmcsScreen(
            // key: const ValueKey("manufacturerScreenEx"),
            title: 'Modelli macchina',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget itemsScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("itemsScreenBloc"),
        lazy: false,
        create: (context) => ServerDataBloc<Item>(
            repo: MultiService<Item>(Item.fromJsonModel, apiName: "Item")),
        child: ItemsScreen(
            // key: const ValueKey("manufacturerScreenEx"),
            title: 'Articoli',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget samplesScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("samplesScreenBloc"),
        lazy: false,
        create: (context) => ServerDataBloc<SampleItem>(
            repo: MultiService<SampleItem>(SampleItem.fromJsonModel,
                apiName: "SampleItem")),
        child: SampleItemsScreen(
          title: 'Campionature',
          menu: menu,
          customBackClick: customBackClick,
          withBackButton: withBackButton,
        ));
  }

  Widget manufacturersScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("manufacturersScreenBloc"),
        lazy: false,
        create: (context) => ServerDataBloc<Manufacturer>(
            repo: MultiService<Manufacturer>(Manufacturer.fromJsonModel,
                apiName: 'Manufacturer')),
        child: ex.ManufacturersScreen(
            // key: const ValueKey("manufacturerScreenEx"),
            title: 'Produttori',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  dataFrameScreen(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("dataFrameScreenBloc"),
        lazy: false,
        create: (context) => ServerDataBloc<DataFrame>(
            repo: MultiService<DataFrame>(DataFrame.fromJsonModel,
                apiName: 'DataFrame')),
        child: DataFrameScreen(
            // key: const ValueKey("manufacturerScreenEx"),
            title: 'Dataframes',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  docFrameScreen(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("docFrameScreenBloc"),
        lazy: false,
        create: (context) => ServerDataBloc<DocFrame>(
            repo: MultiService<DocFrame>(DocFrame.fromJsonModel,
                apiName: 'DocFrame')),
        child: DocFrameScreen(
            // key: const ValueKey("manufacturerScreenEx"),
            title: 'Docframes',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget customersScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("customersScreenBloc"),
        create: (context) => ServerDataBloc<Customer>(
                repo: MultiService<Customer>(
              Customer.fromJsonModel,
              apiName: 'Customer',
            )),
        child: ex.CustomersScreen(
          key: const ValueKey("customersScreenEx"),
          title: 'Clienti',
          menu: menu,
          customBackClick: customBackClick,
          withBackButton: withBackButton,
        ));
  }

  Widget machinesScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ServerDataBloc>(
              key: const ValueKey("machinesScreen"),
              create: (context) => ServerDataBloc<Machine>(
                  repo: MultiService<Machine>(Machine.fromJsonModel,
                      apiName: 'VMMachine'))),
          BlocProvider<ServerDataBloc<MachineHistory>>(
              key: const ValueKey("machineHistoryScreen"),
              create: (context) => ServerDataBloc<MachineHistory>(
                  repo: MultiService<MachineHistory>(
                      MachineHistory.fromJsonModel,
                      apiName: "MachineHistory")))
        ],
        child: ex.MachinesScreen(
          title: 'Macchine',
          menu: menu,
          customBackClick: customBackClick,
          withBackButton: withBackButton,
        ));
  }

  Widget hashTagsScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("hashTagsScreen"),
        lazy: false,
        create: (context) => ServerDataBloc<HashTag>(
            repo: MultiService<HashTag>(HashTag.fromJsonModel,
                apiName: 'HashTag')),
        child: ex.HashTagsScreen(
            title: 'HashTags',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget vmcSettingFieldsScreen(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("vmcSettingFieldsScreen"),
        lazy: false,
        create: (context) => ServerDataBloc<VmcSettingField>(
            repo: MultiService<VmcSettingField>(VmcSettingField.fromJsonModel,
                apiName: "VmcSettingField")),
        child: VmcSettingFieldsScreen(
            title: 'Impostazioni base vmc',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget vmcProductionFieldsScreen(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("vmcProductionFieldsScreen"),
        lazy: false,
        create: (context) => ServerDataBloc<VmcProductionField>(
            repo: MultiService<VmcProductionField>(
                VmcProductionField.fromJsonModel,
                apiName: "VmcProductionField")),
        child: VmcProductionFieldsScreen(
            title: 'Operazioni base vmc',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget vmcSettingCategoriesScreen(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("vmcSettingCategoriesScreen"),
        lazy: false,
        create: (context) => ServerDataBloc<VmcSettingCategory>(
            repo: MultiService<VmcSettingCategory>(
                VmcSettingCategory.fromJsonModel,
                apiName: "VmcSettingCategory")),
        child: VmcSettingCategoriesScreen(
            title: 'Categorie impostazioni',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget vmcProductionCategoriesScreen(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("vmcProductionCategoriesScreen"),
        lazy: false,
        create: (context) => ServerDataBloc<VmcProductionCategory>(
            repo: MultiService<VmcProductionCategory>(
                VmcProductionCategory.fromJsonModel,
                apiName: "VmcProductionCategory")),
        child: VmcProductionCategoriesScreen(
            title: 'Categorie operazioni',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget applicationUsersScreenEx(context, Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    var bloc = BlocProvider.of<ServerDataBloc<ApplicationUser>>(
        navigationScreenKey!.currentContext!);

    return BlocProvider<ServerDataBloc>.value(
        value: bloc,
        child: ex.ApplicationUsersScreen(
            title: 'Operatori',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget applicationProfilesScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("applicationProfilesScreen"),
        create: (context) => ServerDataBloc<ApplicationProfile>(
            repo: MultiService<ApplicationProfile>(
                ApplicationProfile.fromJsonModel,
                apiName: 'ApplicationProfile')),
        child: ex.ApplicationProfilesScreen(
            title: 'Profili',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget reportsScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServerDataBloc>(
            key: const ValueKey("reportsScreen"),
            create: (context) => ServerDataBloc<ReportHeaderView>(
                repo: MultiService<ReportHeaderView>(
                    ReportHeaderView.fromJsonModel,
                    apiName: 'ReportView'))),
        BlocProvider<ServerDataBloc<ApplicationUserDetail>>(
            key: const ValueKey("reportsScreen"),
            create: (context) => ServerDataBloc<ApplicationUserDetail>(
                repo: MultiService<ApplicationUserDetail>(
                    ApplicationUserDetail.fromJsonModel,
                    apiName: 'ApplicationUserDetail'))),
      ],
      child: ReportScreenEx(
          title: 'Assistenze',
          menu: menu,
          customBackClick: customBackClick,
          withBackButton: withBackButton),
    );
  }

  Widget dataEventLogsScreenEx(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("dataEventLogsScreen"),
        create: (context) => ServerDataBloc<DataEventLog>(
            repo: MultiService<DataEventLog>(DataEventLog.fromJsonModel,
                apiName: 'DataEventLog')),
        child: ex.DataEventLogScreen(
            title: 'Eventi',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  Widget vmcConfigurationScreen(Menu menu,
      [VoidCallback? customBackClick, bool withBackButton = true]) {
    return BlocProvider<ServerDataBloc>(
        key: const ValueKey("dataEventLogsScreen"),
        create: (context) => ServerDataBloc<VmcConfiguration>(
            repo: MultiService<VmcConfiguration>(VmcConfiguration.fromJsonModel,
                apiName: 'VmcConfiguration')),
        child: VmcConfigurationScreen(
            title: 'Configurazioni distributore',
            menu: menu,
            customBackClick: customBackClick,
            withBackButton: withBackButton));
  }

  ///pulsante flottande attualmente utilizzato per visualizzare il log di signalr
  Widget getPositionedButton() {
    return TopButton(
      offset: _offset,
      onPressed: () {
        setState(() {
          DebugDpi.debugDpi.toggle();
        });
      },
    );
    /*return Positioned(
    left: _offset.dx,
    top: _offset.dy,
    child: GestureDetector(
      onPanUpdate: (d){
        late double dx;
        late double dy;


        var currentOffset = _offset += Offset(d.delta.dx, d.delta.dy);
        dx = currentOffset.dx;
        dy = currentOffset.dy;

        if (currentOffset.dx<0){
          dx = 0;
        }
        if (currentOffset.dy<0){
          dy = 0;
        }
        if (size.safeWidth <currentOffset.dx + 56){
          dx = size.safeWidth - 56;
        }
        if (size.safeHeight <currentOffset.dy + 56){
          dy = size.safeHeight - 56;
        }

        setState(() {

          _offset = Offset(dx, dy);
          */ /*Offset newOffset = _offset + Offset(d.delta.dx, d.delta.dy);


        double width = WidgetsBinding.instance!.window.physicalGeometry.width;
        print(WidgetsBinding.instance!.window..physicalGeometry.width);
        double height = WidgetsBinding.instance!.window.physicalSize.height* WidgetsBinding.instance!.window.physicalSize.aspectRatio;
        if ((newOffset.dx <= width-64) && (newOffset.dy <= height-64)){
          _offset += Offset(d.delta.dx, d.delta.dy);
        }
*/ /*
        });},
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          setState(() {
            DebugDpi.debugDpi.toggle();
          });
        },
        child: Icon(Icons.bug_report, color: Colors.white),
      ),
    ),
  );*/
  }

/*  Widget logDebugOverlay() {
    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          */ /*    String toShow = "";
          if (currentTrace.length > 0) {
            toShow = currentTrace[0];
          }*/ /*
          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor:
                  Theme.of(context).primaryColorDark.withAlpha(180),
              body: Scrollbar(
                  controller: _logScrollController,
                  child: ListView.builder(
                    controller: _logScrollController,
                    shrinkWrap: true,
                    itemCount: currentLogTrace.length,
                    itemBuilder: (context, index) {
                      return Text(currentLogTrace[index],
                          style: const TextStyle(
                            color: Colors.white,
                          ));
                    },
                  )));
        });
  }*/

  Widget signalRDebugOverlay() {
    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          /*    String toShow = "";
          if (currentTrace.length > 0) {
            toShow = currentTrace[0];
          }*/
          return Scaffold(
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.usb),
                      onPressed: () {
                        if (port!.isOpen) {
                          reader?.close();
                          reader?.port.close();
                        } else {
                          reader?.close();
                          reader?.port.close();

                          openSerialPort();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.telegram),
                      onPressed: () async {
                        /* sendToUser(
                            messageHub, "test", "bella li fratello server");*/
                        try {
                          cameras = await availableCameras();
                        } catch (e) {
                          print(e);
                        } finally {}

                        final screen = BarcodeScannerWidget((result) {
                          debugPrint("Result: ${result.toString()}");
                        });

                        Navigator.of(navigatorKey!.currentContext!).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return screen;
                        }));

                      /*await showPusher(navigatorKey!.currentContext!, BarcodeScannerWidget((result){
                          debugPrint("Result: ${result.toString()}");
                        }));*/
                    },
                  ),
                ],
              ),
            ),
            backgroundColor: Theme.of(context).primaryColorDark.withAlpha(180),
            body: SignalRLog(
              currentTrace: currentTrace,
            ),
            /*Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount:
                        currentTrace.length <= 200 ? currentTrace.length : 200,
                    itemBuilder: (context, index) {
                      return Text(currentTrace[index],
                          style: const TextStyle(
                            color: Colors.white,
                          ));
                    },
                  ))*/
          );
        });
  }
}

/*class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return newUniversalHttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
        iconNormal: Colors.white70,
        mouseOver: Theme.of(context).highlightColor,
        mouseDown: Theme.of(context).colorScheme.background.withAlpha(80),
        iconMouseOver: Colors.white70,
        iconMouseDown: Colors.white70);
    final closeButtonColors = WindowButtonColors(
        mouseOver: const Color(0xFFD32F2F),
        mouseDown: const Color(0xFFB71C1C),
        iconNormal: Colors.white70,
        iconMouseOver: Colors.white70);
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        //MaximizeOrRestoreWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: closeButtonColors /*animate: true*/,
          /* onPressed: () async {
            if (await showCloseMessage() ?? false) {
              appWindow.close();
            }
          },*/
        ),
      ],
    );
  }
}

class MaximizeOrRestoreWindowButton extends WindowButton {
  MaximizeOrRestoreWindowButton(
      {Key? key,
      WindowButtonColors? colors,
      VoidCallback? onPressed,
      bool? animate})
      : super(
            key: key,
            colors: colors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) => appWindow.isMaximized
                ? RestoreIcon(color: buttonContext.iconColor)
                : MaximizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.maximizeOrRestore());
}

