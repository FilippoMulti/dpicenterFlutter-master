import 'dart:typed_data';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class MessageHubEvent {
  String? message;

  MessageHubEvent({this.message});
}

class ScanHubEvent {
  String? scanResult;

  ScanHubEvent({this.scanResult});
}

class SignalREvent {
  List<dynamic>? message;

  SignalREvent({this.message});
}

class OpenAiEvent {
  String message;

  OpenAiEvent({required this.message});
}

class OpenAiChatEvent {
  String message;

  OpenAiChatEvent({required this.message});
}

class RestartHubEvent {
  String? newUrl;

  RestartHubEvent({this.newUrl});
}

class LogHubEvent {
  String? newEvent;

  LogHubEvent({this.newEvent});
}

class SerialMessageEvent {
  Uint8List newEvent;

  SerialMessageEvent({required this.newEvent});
}

String getNow() {
  try {
    /*Future.sync(
              () => initializeDateFormatting(Intl.defaultLocale!, null));*/
    DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");
    return format.format(DateTime.now());
  } catch (e) {
    print("getNow: $e");
  }
  return DateTime.now().toLocal().toString();
}