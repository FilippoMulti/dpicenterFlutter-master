import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/file_global.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/vmc_file.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/take_picture/take_picture_screen.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'dart:ui' as ui;
import 'package:open_file/open_file.dart' as open_file;
import 'package:universal_html/html.dart' as html;

class Pusher extends StatefulWidget {
  final Widget child;
  final Function(BuildContext context) command;
  final List<String>? hubReloadMessage;

  const Pusher({
    Key? key,
    required this.command,
    required this.child,
    this.hubReloadMessage,
  }) : super(key: key);

  @override
  PusherState createState() => PusherState();
}

class PusherState extends State<Pusher> with AutomaticKeepAliveClientMixin {
  bool ignoreMessage = false;

  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.hubReloadMessage == null) {
      ignoreMessage = true;
    }
    _connectToMessageHub();
    callCommand();
  }

  @override
  void dispose() {
    eventBusSubscription?.cancel();
    super.dispose();
  }

  void callCommand() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 150), () {
        widget.command.call(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
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
        var currentSessionId = prefs!.getString(sessionIdSetting);

        print("Message: $message");
        if (!ignoreMessage && widget.hubReloadMessage != null) {
          debugPrint("ignoreMessage=false: load()");
          for (String reloadMessage in widget.hubReloadMessage!) {
            if (message.toLowerCase().contains(reloadMessage.toLowerCase())) {
              callCommand();
            }
          }
        } else {
          debugPrint("ignoreMessage=true");
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
