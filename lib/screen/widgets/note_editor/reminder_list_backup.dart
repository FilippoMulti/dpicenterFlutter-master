import 'dart:async';

import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_reminder.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/useful/loading_screen.dart';
import 'package:dpicenter/screen/widgets/note_editor/reminder_widget.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';

class ReminderList extends StatefulWidget {
  final int? maxElement;
  final Function()? onShowAll;
  final bool reorderable;
  final bool refresh;
  final Function(List<MachineReminder>)? onLoaded;
  final ScrollController? reminderListScrollController;

  const ReminderList(
      {this.maxElement,
      this.onShowAll,
      this.reorderable = true,
      this.refresh = true,
      this.onLoaded,
      this.reminderListScrollController,
      Key? key})
      : super(key: key);

  @override
  State<ReminderList> createState() => ReminderListState();
}

class ReminderListState extends State<ReminderList> {
  ///promemoria attuali
  List<MachineReminder> currentReminders = <MachineReminder>[];
  Map<Customer?, List<MachineReminder>>? factoriesReminders =
      <Customer?, List<MachineReminder>>{};
  List<Customer?>? sortedReminders;
  bool ignoreRemindersMessage = false;
  late ScrollController _reminderListScrollContoller;

  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;

  @override
  void initState() {
    super.initState();
    _reminderListScrollContoller = widget.reminderListScrollController ??
        ScrollController(debugLabel: '_reminderListScrollContoller');

    loadMachines();
    _connectToMessageHub();
  }

  @override
  void dispose() {
    eventBusSubscription?.cancel();
    _reminderListScrollContoller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _reminderList();
  }

  Widget _reminderCard(MapEntry<Customer?, List<MachineReminder>> mapEntry) {
    Color? backColor = Theme.of(context).cardColor;
    Color foreColor = (backColor.computeLuminance() ?? 0) > 0.5
        ? Colors.black87
        : Colors.white70;

    return ReorderableWidget(
        reorderable: widget.reorderable,
        key: ValueKey(mapEntry.key?.customerId),
        child: ReminderWidget(
          mapEntry: mapEntry,
          onMachineSelected: (machine) {},
          onEditReminder: (reminder) {
            ignoreRemindersMessage = true;
          },
          onRemove: (item) {},
          onRemoved: (item) {
            setState(() {
              currentReminders.remove(item);

              currentReminders = currentReminders
                ..sort((a, b) => a.position?.compareTo(b.position ?? 0) ?? 0);

              factoriesReminders =
                  currentReminders.groupBy((p0) => p0.machine?.stabilimento);
              factoriesReminders = factoriesReminders?.map((key, value) =>
                  MapEntry(
                      key,
                      value
                        ..sort((a, b) =>
                            a.position?.compareTo(b.position ?? 0) ?? 0)));

              factoriesReminders?.removeWhere((key, value) => value.isEmpty);

              sortedReminders = factoriesReminders?.keys.toList()
                ?..sort((a, b) =>
                    a?.description?.compareTo(b?.description ?? '') ?? 0);
            });
          },
        ));
  }

  _connectToMessageHub() {
    try {
      //_detachMessageHub();
      //messageHub!.on('ReceiveMessage', messageHubCallback);
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

        if (message.toLowerCase().contains("reminders")) {
          if (ignoreRemindersMessage) {
            debugPrint("ignoreRemindersMessage=true");
            ignoreRemindersMessage = false;
          } else {
            debugPrint("ignoreRenindersMessage=false: loadMachines()");
            loadMachines(refresh: true);
          }

          //await _loadAsync();

          /*ScaffoldMessenger.of(context).hideCurrentSnackBar();

          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: const Duration(days: 365),
            elevation: 6,
            content:
            const Text("I dati sono stati modificati da un altro utente"),
            action: SnackBarAction(
              label: "Ricarica",
              onPressed: () async {
                await reload();
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  loadMachines({bool? refresh}) {
    var bloc = BlocProvider.of<ServerDataBloc<Machine>>(context);
    bloc.add(ServerDataEvent<Machine>(
      status: ServerDataEvents.fetch,
      refresh: refresh ?? widget.refresh,
    ));
  }

  Widget _reminderList() {
    return BlocListener<ServerDataBloc<Machine>, ServerDataState<Machine>>(
        listener: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded) {
        if (state.items != null && state.items is List<Machine>) {
          List<Machine> items = state.items as List<Machine>;
          List<MachineReminder> machineReminders = [];
          for (Machine machine in items) {
            if (machine.machineReminders != null &&
                machine.machineReminders!.isNotEmpty) {
              machineReminders.addAll(machine.machineReminders!
                  .map((e) => e.copyWith(machine: machine)));
            }
          }

          currentReminders = machineReminders;
          widget.onLoaded?.call(currentReminders);
          /*currentReminders = currentReminders..sort((a, b) =>
              a.position?.compareTo(b.position ?? 0) ?? 0);*/
          factoriesReminders =
              currentReminders.groupBy((p0) => p0.machine?.stabilimento);
          factoriesReminders = factoriesReminders?.map((key, value) => MapEntry(
              key,
              value
                ..sort((a, b) => a.position?.compareTo(b.position ?? 0) ?? 0)));

          factoriesReminders?.removeWhere((key, value) => value.isEmpty);
          sortedReminders = factoriesReminders?.keys.toList()
            ?..sort(
                (a, b) => a?.description?.compareTo(b?.description ?? '') ?? 0);
        }
      }
    }, child: BlocBuilder<ServerDataBloc<Machine>, ServerDataState<Machine>>(
            builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataLoaded) {
            return _dataColumn();
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          if (state is ServerDataLoadingSendProgress) {
            return LoadingScreen(
                message:
                    "Richiesta promemoria in corso (${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)})");
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return LoadingScreen(
                message:
                    "Ricezione promemoria in corso (${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)})");
          }
          return LoadingScreen(
            borderRadius: BorderRadius.circular(20),
            message: 'Caricamento promemoria in corso...',
          );

        default:
          break;
      }
      return const Text("Stato sconosciuto");
    }));
  }

  Widget _dataColumn() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReorderableWrap(
            controller: _reminderListScrollContoller,
            spacing: 8,
            padding: EdgeInsets.zero,
            runSpacing: 8,
            onNoReorder: (index) {},
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                Customer? oldCustomer = sortedReminders!.removeAt(oldIndex);
                sortedReminders!.insert(newIndex, oldCustomer);
              });
            },
            children: [
              ...List.generate(
                  widget.maxElement == null
                      ? (sortedReminders?.length ?? 0)
                      : (sortedReminders?.length ?? 0) < widget.maxElement!
                          ? (sortedReminders?.length ?? 0)
                          : widget.maxElement!, (index) {
                return _reminderCard(factoriesReminders!.entries.firstWhere(
                    (element) => element.key == sortedReminders![index]!));
              }),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          if (widget.maxElement != null &&
              (sortedReminders?.length ?? 0) > widget.maxElement!)
            Center(
                child: TextButton(
                    onPressed: () {
                      widget.onShowAll?.call();
                      var screen = Scaffold(
                          appBar: AppBar(
                              title: getHeroTitle('Promemoria', 'PROMEM',
                                  Theme.of(context).textTheme.headlineSmall)),
                          body: MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value:
                                      BlocProvider.of<ServerDataBloc<Machine>>(
                                          context),
                                ),
                              ],
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: ReminderList(
                                  reorderable: false,
                                  refresh: false,
                                ),
                              )));

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => screen),
                      );
                    },
                    child: const Text("Mostra tutti i promemoria")))
          /*if (withAddButton)
            SizedBox(
              height: 80,
              child: Align(
                alignment: Alignment.center,
                child: FloatingActionButton(
                    onPressed: () async {
                      Reminder? note = await addEditNoteDialog();
                      if (note != null) {
                        setState(() {
                          _currentReminders.add(MachineReminder(
                              machineReminderId: 0, reminder: note));
                          _visibleReminders = _currentReminders.sublist(
                              0,
                              _currentReminders.length < 5
                                  ? _currentReminders.length
                                  : 4);
                          */ /*configuration =
                              configuration!.copyWith(notes: _currentNotes);*/ /*
                        });
                      }
                    },
                    child: const Icon(Icons.add)),
              ),
            )*/
        ],
      ),
    );
  }
}
