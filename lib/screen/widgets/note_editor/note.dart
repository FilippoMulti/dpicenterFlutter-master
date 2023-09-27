import 'package:dotted_border/dotted_border.dart';
import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_note.dart';
import 'package:dpicenter/models/server/machine_note.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'blink_text.dart';

class Note extends StatefulWidget {
  const Note(
      {required this.text,
      this.textStyle,
      this.decoration,
      this.constraints,
      this.contentPadding = const EdgeInsets.all(8.0),
      this.splashColor,
      this.onTap,
      this.onRemove,
      this.alignment,
      this.textAlign,
      this.blink = false,
      this.showReminder = false,
      this.deadline,
      this.state,
      this.userInfo,
      Key? key})
      : super(key: key);

  ///attiva il lampeggio del testo
  final bool blink;

  ///testo da visualizzare
  final String text;

  ///stile del testo
  final TextStyle? textStyle;

  ///colore sfondo e bordo
  final BoxDecoration? decoration;

  ///dimensione
  final BoxConstraints? constraints;

  ///padding del testo
  final EdgeInsets contentPadding;

  ///color dell'effetto ripple, quando viene cliccata una nota
  final Color? splashColor;

  ///onTap
  final Function()? onTap;

  ///richiamata al momento del click sulla cancellazione della nota
  ///se viene lasciato a null non viene visualizzato il pulsante per la rimozione
  final Function()? onRemove;

  ///allineamento nota
  final AlignmentGeometry? alignment;

  ///allineamento testo
  final TextAlign? textAlign;

  ///visualizza la nota come promemoria
  final bool? showReminder;

  ///data scadenza
  final String? deadline;

  ///info sull'utente che effettuato l'inserimento
  final String? userInfo;

  ///stato del promemoria
  final int? state;

  factory Note.fromSampleItemNote(
      SampleItemNote sampleItemNote, BuildContext context,
      {dynamic Function()? onTap, dynamic Function()? onRemove}) {
    ReminderConfiguration note = sampleItemNote.reminderConfiguration!;
    return Note.fromReminderConfiguration(
      note,
      context,
      onTap: onTap,
      onRemove: onRemove,
      showReminder: false,
    );
  }

  factory Note.fromMachineNote(MachineNote machineNote, BuildContext context,
      {dynamic Function()? onTap, dynamic Function()? onRemove}) {
    ReminderConfiguration note = machineNote.noteConfiguration!;
    return Note.fromReminderConfiguration(
      note,
      context,
      onTap: onTap,
      onRemove: onRemove,
      showReminder: false,
    );
  }

  factory Note.fromReminder(Reminder? reminder, BuildContext context,
      {dynamic Function()? onTap,
      dynamic Function()? onRemove,
      bool showReminder = true}) {
    ReminderConfiguration note = reminder?.reminderConfiguration ??
        const ReminderConfiguration(reminderConfigurationId: 0, text: '');
    String userInfo =
        '${reminder?.applicationUser?.surname ?? ''} ${reminder?.applicationUser?.name ?? ''} il ${reminder?.date?.toLocalDateTimeString() ?? ''}';
    String deadline = '';
    if (reminder != null && reminder.deadline != null) {
      deadline = reminder.deadline!.toLocalDateTimeString();
    }

    return Note.fromReminderConfiguration(
      note,
      context,
      userInfo: userInfo,
      deadline: deadline,
      onTap: onTap,
      onRemove: onRemove,
      showReminder: showReminder,
    );
  }

  factory Note.fromReminderConfiguration(
      ReminderConfiguration note, BuildContext context,
      {dynamic Function()? onTap,
      dynamic Function()? onRemove,
      String? userInfo,
      String? deadline,
      bool showReminder = true}) {
    int textAlign = note.alignmentX == -1.0
        ? TextAlign.start.index
        : note.alignmentX == 0.0
            ? TextAlign.center.index
            : note.alignmentX == 1.0
                ? TextAlign.end.index
                : 0;

    return Note(
      blink: note.blink,
      alignment: Alignment(note.alignmentX, note.alignmentY),
      onTap: onTap,
      onRemove: onRemove,
      text: note.text,
      constraints: note.freeForm
          ? const BoxConstraints(
              minHeight: 40,
            )
          : const BoxConstraints(
              minWidth: 200,
              minHeight: 200,
            ),
      textAlign: TextAlign.values[textAlign],
      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: note.textColor != null ? Color(note.textColor!) : Colors.black,
          fontSize: note.fontSize,
          fontWeight: FontWeight.values[note.fontWeight]),
      decoration: BoxDecoration(
          color: note.backgroundColor != null
              ? Color(note.backgroundColor!)
              : Colors.yellow,
          border: Border.all(
              color: note.backgroundColor != null
                  ? Color(note.backgroundColor!).darken()
                  : Colors.yellow.darken())),
      showReminder: showReminder,
      deadline: deadline,
      userInfo: userInfo,
    );
  }
  @override
  NoteState createState() => NoteState();
}

class NoteState extends State<Note> {
  final ScrollController _noteScrollController =
      ScrollController(debugLabel: '_noteScrollController');
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    Color backColor = widget.decoration!.color!;
    Color foreColor =
        backColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Column(
      children: [
        Container(
          //alignment: widget.alignment,
          constraints: widget.constraints,
          decoration: widget.showReminder == true
              ? widget.decoration?.copyWith(
                  border: Border.all(
                  color: backColor.computeLuminance() > 0.5
                      ? widget.decoration!.color!.lighten(0.2)
                      : widget.decoration!.color!.darken(0.2),
                ))
              : widget.decoration,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashColor: widget.splashColor,
              onTap: widget.onTap,
              child: MouseRegion(
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
                child: IntrinsicHeight(
                  child: IntrinsicWidth(
                    child: Container(
                      alignment: widget.alignment,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if ((widget.showReminder ?? false) &&
                                    widget.deadline != null)
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color:
                                            backColor.computeLuminance() > 0.5
                                                ? widget.decoration!.color!
                                                    .lighten(0.2)
                                                : widget.decoration!.color!
                                                    .darken(0.2),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 2),
                                            Icon(
                                              Icons.notifications,
                                              color: foreColor,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 10),
                                            DefaultTextStyle(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: foreColor,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                child: Text(
                                                  widget.deadline!,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                /*                     if ((widget.showReminder ?? false) &&
                                    widget.deadline != null)
                                  SizedBox(
                                    height: 30,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 2),
                                          Icon(
                                            Icons.notifications,
                                            color: foreColor,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 10),
                                          DefaultTextStyle(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color: foreColor,
                                                      fontWeight:
                                                          FontWeight.w700),
                                              child: Text(
                                                widget.deadline!,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),*/
                                Expanded(
                                  child: Padding(
                                    padding: widget.contentPadding,
                                    child: Align(
                                        alignment: widget.alignment ??
                                            Alignment.topLeft,
                                        child: widget.blink
                                            ? BlinkingText(
                                                widget.text,
                                                style: widget.textStyle,
                                                textAlign: widget.textAlign,
                                              )
                                            : Text(
                                                widget.text,
                                                style: widget.textStyle,
                                                textAlign: widget.textAlign,
                                              )),
                                  ),
                                ),
                                /* if (widget.showReminder ?? false)
                                  const Expanded(child: SizedBox()),*/
                                if ((widget.showReminder ?? false) &&
                                    widget.userInfo != null)
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        height: 24,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  color:
                                                      foreColor.withAlpha(180),
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 10),
                                                DefaultTextStyle(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color: foreColor
                                                              .withAlpha(180),
                                                        ),
                                                    child: Text(
                                                      widget.userInfo!,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                              ],
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
                                      onPressed: widget.onRemove),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _noteScrollController.dispose();
    super.dispose();
  }
}
