import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/date_time_picker_multi.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/note_editor/note.dart';
import 'package:dpicenter/screen/widgets/note_editor/note_editor.dart';
import 'package:dpicenter/screen/widgets/settings_tiles/multi_setting_tile.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

// Define a custom Form widget.
class ReminderEditor extends StatefulWidget {
  final String? title;
  final Reminder? element;

  const ReminderEditor({Key? key, this.element, required this.title})
      : super(key: key);

  @override
  ReminderEditorState createState() => ReminderEditorState();
}

class ReminderEditorState extends State<ReminderEditor> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final FocusNode _deadlineFocusNode =
      FocusNode(debugLabel: '_deadlineFocusNode');

  ///Controller per data di deadline
  late TextEditingController _deadlineController;

  ///data scadenza
  DateTime deadlineDate = DateTime.now();

  ///elemento eventualmente in modifica
  Reminder? element;
  ReminderConfiguration? elementConfiguration;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _deadlineKey = GlobalKey(debugLabel: '_deadlineKey');
  final GlobalKey _reminderKey = GlobalKey(debugLabel: '_reminderKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  @override
  void initState() {
    super.initState();
    initKeys();
    element = widget.element;
    elementConfiguration = widget.element?.reminderConfiguration;

    if (element != null) {
      deadlineDate = element!.deadline!.toDate().toLocal();
      _deadlineController =
          TextEditingController(text: deadlineDate.toString());
    } else {
      _deadlineController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _deadlineFocusNode.dispose();
    _deadlineController.dispose();
    _saveFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _deadlineKey),
      KeyValidationState(key: _reminderKey),
    ];
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
            DialogTitleEx(widget.title!),
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
                        Flexible(
                          child: SettingsScroll(
                            darkTheme: SettingsThemeData(
                              settingsListBackground: isDarkTheme(context)
                                  ? Color.alphaBlend(
                                      Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withAlpha(240),
                                      Theme.of(context).colorScheme.primary)
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            lightTheme: const SettingsThemeData(
                                settingsListBackground: Colors.transparent),
                            //contentPadding: EdgeInsets.zero,
                            platform: DevicePlatform.web,
                            sections: [
                              _configurationSection(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            OkCancel(
                okFocusNode: _saveFocusNode,
                onCancel: () {
                  Navigator.maybePop(context, null);
                },
                onSave: () {
                  validateSave();
                })
          ],
        ),
      ),
    );
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(title: const Text("Inserimento dati"), tiles: [
      _deadlineSettingTile(),
      _reminderSettingTile(),
    ]);
  }

  SettingsTile _reminderSettingTile() {
    return getCustomSettingTile(
        title: 'Imposta promemoria',
        hint: 'Imposta promemoria',
        description: 'Imposta il promemoria',
        child: _note());
  }

  Widget _note() {
    return Note.fromReminder(
      element,
      context,
      showReminder: false,
      onTap: () async {
        ///modifica nota
        ReminderConfiguration? note = await addEditNoteDialog(
            reminderConfiguration: element?.reminderConfiguration);

        if (note != null) {
          setState(() {
            elementConfiguration = note;
            if (element != null) {
              element = element!
                  .copyWith(reminderConfiguration: elementConfiguration);
            } else {
              element = Reminder(
                  reminderId: 0,
                  reminderConfiguration: elementConfiguration,
                  deadline: deadlineDate.toIso8601String());
            }
          });
        }
      },
    );
  }

  Future<ReminderConfiguration?> addEditNoteDialog(
      {ReminderConfiguration? reminderConfiguration}) async {
    ReminderConfiguration? result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return multiDialog(
              content: NoteEditor(
            note: reminderConfiguration,
          ));
        }).then((returningValue) {
      return returningValue;
    });

    return result;
  }

  void validateSave() {
    if (_formKey.currentState!.validate()) {
      ApplicationUser? user = ApplicationUser.getUserFromSetting();
      if (element == null) {
        element = Reminder(
            reminderId: 0,
            reminderConfiguration: elementConfiguration,
            date: DateTime.now().toUtc().toIso8601String(),
            deadline: deadlineDate.toUtc().toIso8601String(),
            reminderConfigurationId: 0,
            state: 0,
            applicationUserId: user?.applicationUserId,
            applicationUser: user);
      } else {
        element = element!.copyWith(
            reminderConfiguration: elementConfiguration,
            date: DateTime.now().toUtc().toIso8601String(),
            deadline: deadlineDate.toUtc().toIso8601String(),
            state: 0,
            applicationUserId: user?.applicationUserId,
            applicationUser: user);
      }

      Navigator.pop(context, element);
    } else {
      try {
        KeyValidationState state =
            _keyStates.firstWhere((element) => element.state == false);
        Scrollable.ensureVisible(state.key.currentContext!,
            duration: const Duration(milliseconds: 500));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  SettingsTile _deadlineSettingTile() {
    return getCustomSettingTile(
        title: 'Scadenza',
        hint: 'Scadenza promemoria',
        description:
            'Inserisci la data e l\'ora in cui il promemoria viene considerato scaduto',
        child: _deadlineDateSelect());
  }

  Widget _deadlineDateSelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DateTimePicker(
        focusNode: _deadlineFocusNode,
        timePickerEntryModeInput: isWindows,
        initialEntryMode: isWindows
            ? DatePickerEntryMode.input
            : DatePickerEntryMode.calendar,
        enabled: true,
        decoration: getInputDecoration(context, 'Data scadenza',
            'Seleziona una data per la scadenza del promemoria'),
        type: DateTimePickerType.dateTime,
        dateMask: 'd MMM, yyyy HH:mm',
        controller: _deadlineController,
        //initialValue: startDateFormatted,
        firstDate: DateTime(2022),
        lastDate: DateTime(2100),
        icon: const Icon(Icons.event),
        dateLabelText: 'Data scadenza',
        timeLabelText: "Ora scadenza",
        //use24HourFormat: false,
        //locale: Locale('pt', 'BR'),
        selectableDayPredicate: (date) {
          /*
          Per disabilitare il sabato e la domenica
          if (date.weekday == 6 || date.weekday == 7) {
            return false;
          }*/
          return true;
        },

        onChanged: (val) {
          setState(() {
            editState = true;
            deadlineDate = DateTime.parse(val);
          });
        },
        validator: (val) {
          if (kDebugMode) {
            print("Validator: $val");
          }
          if (val == null || val.isEmpty) {
            return "Impostare una data e un ora per il promemoria";
          }
          /*setState(() => _valueToValidate1 = val ?? '');*/
          return null;
        },
        /*
        onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),*/
      ),
    );
  }
}
