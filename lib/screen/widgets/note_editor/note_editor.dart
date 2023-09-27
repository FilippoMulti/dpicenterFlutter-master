import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_note.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/note_editor/note.dart';
import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:enough_ascii_art/enough_ascii_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path/path.dart';

const double kNoteHeight = 250;
const double kNoteWidth = 250;

class NoteEditor extends StatefulWidget {
  const NoteEditor({this.note, Key? key}) : super(key: key);

  final ReminderConfiguration? note;

  @override
  NoteEditorState createState() => NoteEditorState();
}

class NoteEditorState extends State<NoteEditor> {
  double? fontSize;
  int? fontWeight;
  String? text;
  Color? backgroundColor;
  Color? foregroundColor;
  Offset? alignment;
  int? textAlign;
  bool blink = false;
  bool freeForm = false;

  ReminderConfiguration? itemNote;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController =
      ScrollController(debugLabel: 'ScrollController');

  late TextEditingController textController;
  List<bool> emojiGroupSelected = <bool>[];
  int emojiGroupCurrentIndex = 0;

  List<bool> emojiSubgroupSelected = <bool>[];
  int emojiSubgroupCurrentIndex = 0;

  @override
  void initState() {
    emojiGroupSelected =
        List.generate(EmojiGroup.values.length, (index) => false);
    emojiGroupCurrentIndex = 0;

    emojiSubgroupSelected =
        List.generate(EmojiSubgroup.values.length, (index) => false);
    emojiSubgroupCurrentIndex = 0;

    fontSize = widget.note?.fontSize ?? 16;
    fontWeight = widget.note?.fontWeight ?? 1;
    text = widget.note?.text ?? '';
    alignment =
        Offset(widget.note?.alignmentX ?? -1, widget.note?.alignmentY ?? -1);
    textController = TextEditingController(text: text);
    textController.addListener(textListener);
    blink = widget.note?.blink ?? false;
    freeForm = widget.note?.freeForm ?? false;

    backgroundColor = widget.note?.backgroundColor != null
        ? Color(widget.note!.backgroundColor!)
        : Colors.yellow;
    foregroundColor = widget.note?.textColor != null
        ? Color(widget.note!.textColor!)
        : Colors.black;

    itemNote = widget.note ??
        ReminderConfiguration(
            reminderConfigurationId: 0,
            text: text!,
            textColor: foregroundColor!.value,
            backgroundColor: backgroundColor!.value,
            alignmentX: widget.note?.alignmentX ?? -1,
            alignmentY: widget.note?.alignmentY ?? -1,
            blink: blink,
            freeForm: freeForm);

    super.initState();
  }

  textListener() {
    itemNote = itemNote?.copyWith(text: textController.text);

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    textAlign = alignment!.dx == -1.0
        ? TextAlign.start.index
        : alignment!.dx == 0.0
            ? TextAlign.center.index
            : alignment!.dx == 1.0
                ? TextAlign.end.index
                : 0;

    return FocusScope(
      child: Container(
        color: getAppBackgroundColor(context),
        width: 800,
        child: Column(
          children: [
            Expanded(
                child: Scaffold(
              backgroundColor: getAppBackgroundColor(context),
              body: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    width: 800,

                    ///permette al widget di essere scrollato
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DialogTitleEx('Scrivi nota'),
                          const SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: textController,
                            maxLength: 1000,
                            maxLines: null,
                            decoration: getInputDecoration(
                                context, 'Nota', 'Inserisci una nota'),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Divider(),
                          ...emojiSelect(),
                          const Divider(),
                          formatTools(context),
                          const Divider(),
                          const SizedBox(
                            height: 32,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Note.fromReminderConfiguration(
                              itemNote!,
                              context,
                              onTap: () {},
                              showReminder: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            //const Divider(),
            OkCancel(onCancel: () {
              Navigator.maybePop(context, null);
            }, onSave: () {
              if (textController.text.isNotEmpty) {
                ReminderConfiguration result = ReminderConfiguration(
                  reminderConfigurationId:
                      widget.note?.reminderConfigurationId ?? 0,
                  text: textController.text,
                  textColor: foregroundColor!.value,
                  backgroundColor: backgroundColor!.value,
                  fontSize: fontSize!,
                  alignmentX: alignment?.dx ?? -1.0,
                  alignmentY: alignment?.dy ?? -1.0,
                  blink: blink,
                  fontWeight: fontWeight ?? 1,
                  freeForm: freeForm,
                );
                Navigator.pop(context, result);
              }
              //validateSave();
            })
          ],
        ),
      ),
    );
  }

  List<Widget> emojiSelect() {
    return [
      groupEmoji(),
      const Divider(),
      subGroupEmoji(),
      const Divider(),
      selectedEmoji(),
    ];
  }

  Widget groupEmoji() {
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ToggleButtons(
                isSelected: emojiGroupSelected,
                onPressed: (index) {
                  setState(() {
                    emojiGroupSelected = List.generate(
                        EmojiGroup.values.length, (index) => false);
                    emojiGroupSelected[index] = true;
                    emojiGroupCurrentIndex = index;
                  });
                },
                children: List.generate(
                  EmojiGroup.values.length,
                  (index) => Tooltip(
                      message: EmojiGroup.values[index].name,
                      child: Text(
                        Emoji.byGroup(EmojiGroup.values[index]).first.char,
                        style: TextStyle(
                          inherit: false,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w100,
                          fontFamily: Icons.format_bold.fontFamily,
                          package: Icons.format_bold.fontPackage,
                        ),
                      )),
                  /*onPressed: () {
                  setState((){
                    emojiGroupSelected = List.generate(EmojiGroup.values.length, (index) => false);
                    emojiGroupSelected[index]=true;
                  });
                },*/
                  /*icon: Text(
                  Emoji.byGroup(EmojiGroup.values[index]).first.char,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w100,
                    fontFamily: Icons.format_bold.fontFamily,
                    package: Icons.format_bold.fontPackage,
                  ),
                )*/
                ))
          ],
        ),
      ),
    );
  }

  Widget subGroupEmoji() {
    List<Emoji> list = Emoji.byGroup(EmojiGroup.values[emojiGroupCurrentIndex])
        .toList(growable: false);
    Map map = list.groupBy((p0) => p0.emojiSubgroup.index);

    if (emojiSubgroupSelected.length != map.keys.length) {
      emojiSubgroupSelected =
          List.generate(map.keys.length, (index) => index == 0 ? true : false);
      emojiSubgroupCurrentIndex = map.keys.first;
    }

    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ToggleButtons(
                isSelected: emojiSubgroupSelected,
                onPressed: (index) {
                  setState(() {
                    emojiSubgroupSelected =
                        List.generate(map.keys.length, (index) => false);
                    emojiSubgroupSelected[index] = true;
                    emojiSubgroupCurrentIndex = map.keys.elementAt(index);
                  });
                },
                children: List.generate(
                  map.keys.length,
                  (index) {
                    try {
                      int subgroupIndex = map.keys.elementAt(index);
                      String name = EmojiSubgroup.values[subgroupIndex].name;

                      return Tooltip(
                          message: name,
                          child: Text(
                            Emoji.bySubgroup(
                                    EmojiSubgroup.values[subgroupIndex])
                                .first
                                .char,
                            style: TextStyle(
                              inherit: false,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w100,
                              fontFamily: Icons.format_bold.fontFamily,
                              package: Icons.format_bold.fontPackage,
                            ),
                          ));
                    } catch (e) {
                      print(e);
                    }
                    return const SizedBox();
                  },
                ))
          ],
        ),
      ),
    );
  }

  Widget selectedEmoji() {
    List<Emoji> list =
        Emoji.bySubgroup(EmojiSubgroup.values[emojiSubgroupCurrentIndex])
            .toList(growable: false);

    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(
              list.length,
              (index) => IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 40,
                  tooltip: list[index].name,
                  onPressed: () {
                    String text = textController.text;
                    TextSelection textSelection = textController.selection;

                    int start = 0, end = 0;
                    if (textSelection.start != -1) {
                      start = textSelection.start;
                    } else {
                      start = textController.text.length;
                    }
                    if (textSelection.end != -1) {
                      end = textSelection.end;
                    } else {
                      end = textController.text.length;
                    }
                    String newText =
                        text.replaceRange(start, end, list[index].char);
                    final emojiLength = list[index].char.length;
                    textController.text = newText;
                    textController.selection = textSelection.copyWith(
                      baseOffset: start + emojiLength,
                      extentOffset: start + emojiLength,
                    );
                  },
                  icon: Text(
                    list[index].char,
                    style: TextStyle(
                      inherit: false,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w100,
                      fontFamily: Icons.format_bold.fontFamily,
                      package: Icons.format_bold.fontPackage,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget allEmoji() {
    List<Emoji> all =
        Emoji.byGroup(EmojiGroup.activities).toList(growable: false);
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(
              all.length,
              (index) => IconButton(
                  iconSize: 40,
                  tooltip:
                      '${all[index].name} - ${all[index].emojiGroup} - ${all[index].emojiSubgroup}',
                  onPressed: () {
                    String text = textController.text;
                    TextSelection textSelection = textController.selection;
                    String newText = text.replaceRange(textSelection.start,
                        textSelection.end, all[index].char);
                    final emojiLength = all[index].char.length;
                    textController.text = newText;
                    textController.selection = textSelection.copyWith(
                      baseOffset: textSelection.start + emojiLength,
                      extentOffset: textSelection.start + emojiLength,
                    );
                  },
                  icon: Text(
                    all[index].char,
                    style: TextStyle(
                      inherit: false,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w100,
                      fontFamily: Icons.format_bold.fontFamily,
                      package: Icons.format_bold.fontPackage,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget formatTools(BuildContext context) {
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
                tooltip: 'Aumenta dimensione testo',
                onPressed: () {
                  setState(() {
                    if (fontSize != null) {
                      fontSize = fontSize! + 1.00;
                    } else {
                      fontSize = 16;
                    }
                    itemNote = itemNote?.copyWith(fontSize: fontSize);
                  });
                },
                icon: const Icon(Icons.text_increase)),
            IconButton(
                tooltip: 'Diminuisci dimensione testo',
                onPressed: () {
                  setState(() {
                    if (fontSize != null) {
                      fontSize = fontSize! - 1.00;
                    } else {
                      fontSize = 16;
                    }
                    itemNote = itemNote?.copyWith(fontSize: fontSize);
                  });
                },
                icon: const Icon(Icons.text_decrease)),
            const VerticalDivider(),
            CircleAvatar(
              radius: 24,
              backgroundColor: foregroundColor,
              child: IconButton(
                  tooltip: 'Selezione colore testo',
                  onPressed: () async {
                    await selectColorPicker(
                        context, foregroundColor?.value ?? 0, (value) {
                      setState(() {
                        foregroundColor = value;
                        itemNote = itemNote?.copyWith(
                            textColor: foregroundColor!.value);
                      });
                    });
                  },
                  icon: const Icon(Icons.font_download)),
            ),
            CircleAvatar(
              radius: 24,
              backgroundColor: backgroundColor,
              child: IconButton(
                  tooltip: 'Selezione colore sfondo',
                  onPressed: () async {
                    await selectColorPicker(
                        context, backgroundColor?.value ?? 0, (value) {
                      setState(() {
                        backgroundColor = value;
                        itemNote = itemNote?.copyWith(
                            backgroundColor: backgroundColor!.value);
                      });
                    });
                  },
                  icon: Icon(
                    Icons.format_size,
                    color: foregroundColor,
                  )),
            ),
            const VerticalDivider(),
            IconButton(
                tooltip: 'Diminuisci larghezza testo',
                onPressed: () {
                  setState(() {
                    fontWeight = 0;
                    /*if (fontWeight != null) {
                      if (fontWeight!>0) {
                        fontWeight = fontWeight! - 1;
                      }
                    } else {
                      fontWeight = 1;
                    }*/
                  });
                },
                icon: Text(
                  String.fromCharCode(Icons.format_bold.codePoint),
                  style: TextStyle(
                    inherit: false,
                    fontSize: 24.0,
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.w100,
                    fontFamily: Icons.format_bold.fontFamily,
                    package: Icons.format_bold.fontPackage,
                  ),
                )),
            IconButton(
                tooltip: 'Aumenta larghezza testo',
                onPressed: () {
                  setState(() {
                    fontWeight = 8;
                    itemNote = itemNote?.copyWith(fontWeight: fontWeight!);
/*
                    if (fontWeight != null) {
                      if (fontWeight! < FontWeight.values.length-1) {
                        fontWeight = 0;
                      }
                    } else {
                      fontWeight = 0;
                    }
*/
                  });
                },
                icon: Text(
                  String.fromCharCode(Icons.format_bold.codePoint),
                  style: TextStyle(
                    inherit: false,
                    fontSize: 24.0,
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.w900,
                    fontFamily: Icons.format_bold.fontFamily,
                    package: Icons.format_bold.fontPackage,
                  ),
                )),
            const VerticalDivider(),
            IconButton(
                tooltip: 'Allinea orizzontalmente all\'inizio',
                onPressed: () {
                  setState(() {
                    alignment = Offset(Alignment.topLeft.x, alignment!.dy);
                    itemNote = itemNote?.copyWith(
                        alignmentX: alignment!.dx, alignmentY: alignment!.dy);
                  });
                },
                icon: const Icon(Icons.format_align_left)),
            IconButton(
                tooltip: 'Allinea orizzontalmente al centro',
                onPressed: () {
                  setState(() {
                    alignment = Offset(Alignment.topCenter.x, alignment!.dy);
                    itemNote = itemNote?.copyWith(
                        alignmentX: alignment!.dx, alignmentY: alignment!.dy);
                  });
                },
                icon: const Icon(Icons.format_align_center)),
            IconButton(
                tooltip: 'Allinea orizzontalmente alla fine',
                onPressed: () {
                  setState(() {
                    alignment = Offset(Alignment.topRight.x, alignment!.dy);
                    itemNote = itemNote?.copyWith(
                        alignmentX: alignment!.dx, alignmentY: alignment!.dy);
                  });
                },
                icon: const Icon(Icons.format_align_right)),
            IconButton(
                tooltip: 'Allinea verticalmente sopra',
                onPressed: () {
                  setState(() {
                    alignment = Offset(alignment!.dx, Alignment.topRight.y);
                    itemNote = itemNote?.copyWith(
                        alignmentX: alignment!.dx, alignmentY: alignment!.dy);
                  });
                },
                icon: const Icon(Icons.vertical_align_top)),
            IconButton(
                tooltip: 'Allinea verticalmente al centro',
                onPressed: () {
                  setState(() {
                    alignment = Offset(alignment!.dx, Alignment.centerRight.y);
                    itemNote = itemNote?.copyWith(
                        alignmentX: alignment!.dx, alignmentY: alignment!.dy);
                  });
                },
                icon: const Icon(Icons.vertical_align_center)),
            IconButton(
                tooltip: 'Allinea verticalmente al fondo',
                onPressed: () {
                  setState(() {
                    alignment = Offset(alignment!.dx, Alignment.bottomRight.y);
                    itemNote = itemNote?.copyWith(
                        alignmentX: alignment!.dx, alignmentY: alignment!.dy);
                  });
                },
                icon: const Icon(Icons.vertical_align_bottom)),
            const VerticalDivider(),
            IconButton(
                tooltip: 'Attiva o disattiva il lampeggio del testo',
                onPressed: () {
                  setState(() {
                    blink = !blink;
                    itemNote = itemNote?.copyWith(blink: blink);
                  });
                },
                icon: const Icon(Icons.wb_iridescent)),
            const VerticalDivider(),
            IconButton(
                tooltip: 'Attiva o disattiva la dimensione minima della nota',
                onPressed: () {
                  setState(() {
                    freeForm = !freeForm;
                    itemNote = itemNote?.copyWith(freeForm: freeForm);
                  });
                },
                icon: const Icon(Icons.crop_5_4)),
          ],
        ),
      ),
    );
  }

  Future<Color?> selectColorPicker(BuildContext context, int currentColor,
      void Function(Color value)? onChanged) async {
    // raise the [showDialog] widget
    var result = await showDialog(
      context: context,
      builder: (context) {
        return multiDialog(
          title: const Text('Seleziona un colore'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: Color(currentColor),
              portraitOnly: true,
              enableLabel: false,
              onPrimaryChanged: (color) {
                currentColor = color.value;
                onChanged?.call(color);
              },
              onColorChanged: (color) {
                currentColor = color.value;
                onChanged?.call(color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Seleziona'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return result;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textController.removeListener(textListener);
    super.dispose();
  }
}
