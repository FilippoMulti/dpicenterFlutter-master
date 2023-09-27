import 'dart:async';

import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:flutter/material.dart';

class SignalRLog extends StatefulWidget {
  const SignalRLog({Key? key, this.currentTrace}) : super(key: key);
  final List<String>? currentTrace;

  @override
  State<SignalRLog> createState() => _SignalRLogState();
}

class _SignalRLogState extends State<SignalRLog> {
  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;

  List<String>? trace;
  final ScrollController _scrollController =
      ScrollController(debugLabel: '_scrollController');

  @override
  void initState() {
    super.initState();
    trace = widget.currentTrace ?? [];
/*    eventBusSubscription= eventBus.on<LogHubEvent>().listen((event) {
      if (trace!.length >= 200) {
        trace!.removeAt(trace!.length - 1);
      }
      trace!.insert(0, event.newEvent!);
    });*/
  }

  @override
  void dispose() {
    _scrollController.dispose();
    eventBusSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: trace!.length <= 200 ? trace!.length : 200,
          itemBuilder: (context, index) {
            return Text(trace![index],
                style: const TextStyle(
                  color: Colors.white,
                ));
          },
        ));
  }
}
