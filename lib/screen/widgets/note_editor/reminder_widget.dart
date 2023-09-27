import 'package:dotted_border/dotted_border.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_note.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_reminder.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/machines/machine_screen_ex.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dashboard/pusher.dart';
import 'package:dpicenter/screen/widgets/note_editor/note.dart';
import 'package:dpicenter/screen/widgets/note_editor/reminder_editor.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'blink_text.dart';

class ReminderWidget extends StatefulWidget {
  final MapEntry<Customer?, List<MachineReminder>> mapEntry;
  final Function(MachineReminder item)? onRemoved;
  final Function(MapEntry<Customer?, List<MachineReminder>> item)? onRemove;
  final Function(Machine machine)? onMachineSelected;
  final Function(MachineReminder machineReminder)? onEditReminder;

  const ReminderWidget(
      {required this.mapEntry,
      this.onRemove,
      this.onRemoved,
      this.onMachineSelected,
      this.onEditReminder,
      super.key});

  @override
  ReminderWidgetState createState() => ReminderWidgetState();
}

class ReminderWidgetState extends State<ReminderWidget> {
  final ScrollController _noteScrollController =
      ScrollController(debugLabel: '_reminderScrollController');
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    Color? backColor = Theme.of(context).cardColor;
    Color foreColor =
        backColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white70;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHover = false;
        });
      },
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            alignment: Alignment.center,
                            transformAlignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: backColor.computeLuminance() > 0.5
                                    ? backColor.lighten(0.2)
                                    : backColor.darken(0.2),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.factory, color: foreColor),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    widget.mapEntry.key?.toString(
                                            withSpace: false,
                                            withAddressBreak: true) ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: foreColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                      child: Wrap(children: [
                    ...List.generate(
                      widget.mapEntry.value.length,
                      (index) {
                        // Machine? currentMachine = _currentReminders.firstWhereOrNull((element) => element.matricola == mapEntry.value[index].matricola) as Machine?;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.developer_board, color: foreColor),
                                  const SizedBox(width: 6),
                                  FilterChip(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 0),
                                    labelPadding: EdgeInsets.zero,
                                    label: Text(widget.mapEntry.value[index]
                                            .machine?.matricola ??
                                        ''),
                                    onSelected: (bool value) async {
                                      if (widget
                                              .mapEntry.value[index].machine !=
                                          null) {
                                        widget.onMachineSelected?.call(widget
                                            .mapEntry.value[index].machine!);

                                        if (widget.mapEntry.value[index]
                                                    .machine ==
                                                null ||
                                            widget
                                                    .mapEntry
                                                    .value[index]
                                                    .machine!
                                                    .machineReminders ==
                                                null) {
                                          List<Machine>? machines =
                                              await downloadMachine(
                                                  context,
                                                  widget.mapEntry.value[index]
                                                          .matricola ??
                                                      '');
                                          if (machines != null &&
                                              machines.isNotEmpty) {
                                            widget.mapEntry.value[index] =
                                                widget.mapEntry.value[index]
                                                    .copyWith(
                                                        machine: machines[0]);
                                          }
                                        }
                                        if (mounted) {
                                          MachineActions.openDetailAndSave(
                                              context,
                                              widget.mapEntry.value[index]
                                                  .machine!);
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: Note.fromReminder(
                                widget.mapEntry.value[index].reminder ??
                                    const Reminder(reminderId: 0),
                                context,
                                onTap: () async {
                                  ///modifica nota
                                  Reminder? reminder = await addEditNoteDialog(
                                      machineReminder:
                                          widget.mapEntry.value[index]);

                                  if (reminder != null && mounted) {
                                    widget.onEditReminder
                                        ?.call(widget.mapEntry.value[index]);

                                    MachineReminder toSave = widget
                                        .mapEntry.value[index]
                                        .copyWith(reminder: reminder);

                                    await showPusher(context, _saver(reminder));

                                    setState(() {
                                      widget.mapEntry.value[index] = widget
                                          .mapEntry.value[index]
                                          .copyWith(reminder: reminder);
                                      /*configuration =
                                                    configuration!.copyWith(notes: _currentNotes);*/
                                    });
                                  }
                                },
                                onRemove: () async {
                                  bool result = await requestRemoveConfirmation(
                                      widget.mapEntry.value[index].reminder
                                              ?.reminderConfiguration?.text ??
                                          '');

                                  if (result && mounted) {
                                    await showPusher(
                                        context,
                                        _deleter(
                                            [widget.mapEntry.value[index]]));

                                    widget.onRemoved?.call(
                                        widget.mapEntry.value.elementAt(index));

                                    setState(() {
                                      /*  _currentReminders
                                              .remove(widget.mapEntry.value[index]);
                                        */
                                      widget.mapEntry.value.removeAt(index);
                                      //_visibleReminders = _currentReminders.sublist(0, _currentReminders.length<5 ? _currentReminders.length : 4);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ])),
                ],
              ),
            ),
          ),
          if ((_isHover || isMobile) && widget.onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.red,
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  shape: const CircleBorder(),
                  type: MaterialType.transparency,
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      iconSize: 12,
                      color: Colors.white,
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        bool result = await requestRemoveAllConfirmation(
                            widget.mapEntry.key?.description ?? '');

                        if (result && mounted) {
                          await showPusher(
                              context, _deleter(widget.mapEntry.value));

                          for (MachineReminder reminder
                              in widget.mapEntry.value) {
                            widget.onRemoved?.call(reminder);
                          }

                          setState(() {
                            widget.mapEntry.value.clear();
                          });
                        }
                        widget.onRemove?.call(widget.mapEntry);
                      }),
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteScrollController.dispose();
    super.dispose();
  }

  Future<bool> requestRemoveConfirmation(String noteText) async {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Rimozione nota',
            message: 'Nota selezionata:\r\n$noteText\r\nRimuovere questa nota?',
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

    result ??= false;
    return result;
  }

  Future<bool> requestRemoveAllConfirmation(String reminderText) async {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Rimozione promemoria',
            message:
                'Promemoria selezionato:\r\n$reminderText\r\nRimuovere tutti i promemoria selezionati?',
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

    result ??= false;
    return result;
  }

  Widget _deleter(List<MachineReminder> items) {
    return MultiBlocProvider(
        //key: _reportStatBlocKey,
        providers: [
          BlocProvider<ServerDataBloc<MachineReminder>>(
            lazy: false,
            create: (context) => ServerDataBloc<MachineReminder>(
                repo: MultiService<MachineReminder>(
                    MachineReminder.fromJsonModel,
                    apiName: 'MachineReminder')),
          ),
        ],
        child: Pusher(
          command: (context) {
            var bloc =
                BlocProvider.of<ServerDataBloc<MachineReminder>>(context);
            bloc.add(ServerDataEvent<MachineReminder>(
              status: ServerDataEvents.delete,
              items: items,
              item: items[0],
            ));
          },
          child: BlocListener<ServerDataBloc<MachineReminder>, ServerDataState>(
              listener: (BuildContext context, ServerDataState state) {
            if (state.event is ServerDataLoaded) {
              Navigator.pop(context, state.event?.items);
            }
          }, child:
                  BlocBuilder<ServerDataBloc<MachineReminder>, ServerDataState>(
                      builder: (BuildContext context, ServerDataState state) {
            if (state is ServerDataLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pop(context, state.items);
              });
              // return const Text("OK!");
            }
            return Container(
              constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    pacman(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text("Eliminazione in corso..."),
                    const SizedBox(
                      height: 16,
                    ),
                    /* OkCancel(onCancel: (){
                if (mounted) {
                  Navigator.of(context).maybePop(null);
                }

              },)*/
                  ],
                ),
              ),
            );
          })),
        ));
  }

  Widget _saver(Reminder item) {
    return MultiBlocProvider(
        //key: _reportStatBlocKey,
        providers: [
          BlocProvider<ServerDataBloc<Reminder>>(
            lazy: false,
            create: (context) => ServerDataBloc<Reminder>(
                repo: MultiService<Reminder>(Reminder.fromJsonModel,
                    apiName: 'Reminder')),
          ),
        ],
        child: Pusher(
          command: (context) {
            var bloc = BlocProvider.of<ServerDataBloc<Reminder>>(context);
            bloc.add(ServerDataEvent<Reminder>(
              status: ServerDataEvents.update,
              keyName: 'reminderId',
              items: [item],
              item: item,
            ));
          },
          child: BlocListener<ServerDataBloc<Reminder>, ServerDataState>(
              listener: (BuildContext context, ServerDataState state) {
            if (state.event is ServerDataLoaded) {
              Navigator.pop(context, state.event?.items);
            }
          }, child: BlocBuilder<ServerDataBloc<Reminder>, ServerDataState>(
                  builder: (BuildContext context, ServerDataState state) {
            if (state is ServerDataLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pop(context, state.items);
              });
              // return const Text("OK!");
            }
            return Container(
              constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    pacman(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text("Salvataggio in corso..."),
                    const SizedBox(
                      height: 16,
                    ),
                    /* OkCancel(onCancel: (){
                if (mounted) {
                  Navigator.of(context).maybePop(null);
                }

              },)*/
                  ],
                ),
              ),
            );
          })),
        ));
  }

  Future<Reminder?> addEditNoteDialog(
      {MachineReminder? machineReminder}) async {
    Reminder? result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return multiDialog(
              content: ReminderEditor(
            element: machineReminder?.reminder,
            title: 'Promemoria',
          ));
        }).then((returningValue) {
      return returningValue;
    });

    return result;
  }
}
