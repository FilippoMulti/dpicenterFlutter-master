import 'dart:convert';
import 'dart:math';

import 'package:dpicenter/models/config/start_config_model.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/screen/navigation/navigation_screen_ex2.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
/*import 'package:sembast/sembast.dart';*/
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

const String openAIKey = "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";
const String applicationUserIdSetting = "applicationUserId";
const String tokenSetting = "token";
const String loadDashboardSetting = "loadDashboard";
const String showBackgroundImageSetting = "showBackgroundImage";
const String backgroundOpacitySetting = "backgroundOpacitySetting";
const String preReleaseSetting = "preReleaseSetting";
const String urlSetting = "url";
const String usernameSetting = "userName";
const String sessionIdSetting = "sessionId";

///json completo di ApplicationUser
const String userInfoSetting = "userInfo";

///json completo di ApplicationUserDetail
const String userDetailInfoSetting = "userDetailInfo";

///connectionId -> ricevuto dopo la connessione a SignalR tramite un messaggio
///Viene utilizzato nella connessione a OpenAi per ricevere la risposta tramite SignalR
String? connectionId = "";

///ottenuti tramite richiesta a CheckVersionController
int? kServerVersion;
String? kServerVersionString;
GlobalKey windowsTitleKey = GlobalKey(debugLabel: 'windowsTitleKey');
Map<String, dynamic> currentDeviceInfo = {};
String currentDeviceName = "";
bool gShowCloseMessage = true;

bool? isOnline;

Menu? baseMenu;
Menu? currentMenu;
Menu? dashBoardMenu;

GlobalKey<NavigatorState>? navigatorKey;
GlobalKey<NavigationScreenPageExState>? navigationScreenKey;

//Auth? loginInfo;
/*DatabaseFactory? dbFactory;
Database? db;*/
StartConfig? startConfig;

HubConnection? messageHub;
SharedPreferences? prefs;
bool? reconnectSignalR = false;
EventBus eventBus = EventBus();

String sessionId = "";

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

///valore dell'altezza in cui lo schermo viene considerato piccolo (Esempio: title bar più piccola, riduzione dei font...)
const double tinyHeight = 500;
const double midWidth = 650;
const double tinyWidth = 500;
//const double tinyHeight = 500;

void sendToUser(HubConnection? hub, String to, String message) async {
  await hub?.invoke('SendToUser', args: [to, message]);
}

void sendCommandToUser(
    HubConnection? hub, String command, String to, String message) async {
  await hub?.invoke('SendCommandToUser', args: [command, to, message]);
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}