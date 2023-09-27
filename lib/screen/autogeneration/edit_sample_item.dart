import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_note.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/autogeneration/space_item_ex.dart';
import 'package:dpicenter/screen/autogeneration/stand_widget.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/image_loader/image_loader.dart';
import 'package:dpicenter/screen/widgets/markdown_editor/markdown_editor.dart';
import 'package:dpicenter/screen/widgets/note_editor/note.dart';
import 'package:dpicenter/screen/widgets/note_editor/note_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import 'package:settings_ui/settings_ui.dart';

class EditSampleItem extends StatefulWidget {
  final SampleItemConfiguration? itemConfiguration;
  final List<SampleItemPicture>? itemPictures;

  ///vmc per cui devo creare SampleItem
  final Vmc? vmc;

  ///item per cui devo creare SampleItem
  final Item? item;

  final Function(List? config)? onSave;
  final Function(List? config)? onClose;
  final Function(List? config)? onAdd;

  final GlobalKey? configurationSectionKey;
  final GlobalKey? imageSectionKey;
  final GlobalKey? noteSettingsSectionKey;
  final Color? backgroundColor;

  final ScrollController? scrollController;

  const EditSampleItem(
      {this.itemPictures,
      this.itemConfiguration,
      this.item,
      this.onSave,
      this.onClose,
      this.onAdd,
      this.vmc,
      this.backgroundColor,
      this.configurationSectionKey,
      this.imageSectionKey,
      this.noteSettingsSectionKey,
      this.scrollController,
      Key? key})
      : assert(itemConfiguration != null || (item != null && vmc != null),
            'sampleItem, item e vmc sono tutti null. Impostare un SampleItem da modificare o un Vmc e un Item da configurare'),
        super(key: key);

  @override
  State<StatefulWidget> createState() => EditSampleItemState();
}

class EditSampleItemState extends State<EditSampleItem> {
  List? sampleItemConfig;

  final ScrollController noteListScrollController =
      ScrollController(debugLabel: 'noteListScrollController');

  SampleItemConfiguration? get configuration => sampleItemConfig?[0];

  set configuration(SampleItemConfiguration? configuration) {
    sampleItemConfig = [configuration, sampleItemConfig?[1]];
  }

  List<SampleItemPicture>? get itemPictures => sampleItemConfig?[1];

  set itemPictures(List<SampleItemPicture>? itemPictures) {
    sampleItemConfig = [sampleItemConfig?[0], itemPictures];
  }

  final GlobalKey<ImageLoaderState> loaderKey =
      GlobalKey<ImageLoaderState>(debugLabel: 'loaderKey');

  final GlobalKey<MarkdownEditorState> notesKey =
      GlobalKey<MarkdownEditorState>(debugLabel: 'notesKey');

  final GlobalKey _notesSettingTileKey =
      GlobalKey(debugLabel: '_notesSettingTileKey');

  final TextEditingController _controller = TextEditingController();

  final lightTileDescriptionTextColor = const Color.fromARGB(255, 70, 70, 70);
  final darkTileDescriptionTextColor = const Color.fromARGB(154, 160, 166, 198);

  List<SampleItemNote> _currentNotes = <SampleItemNote>[];

  @override
  void initState() {
    if (widget.itemConfiguration !=
        null /*non può esistere itemPictures se non è stata impostata una configuration*/) {
      sampleItemConfig = [widget.itemConfiguration, widget.itemPictures];
    } else {
      sampleItemConfig = [
        SampleItemConfiguration(
            widthSpaces: 1,
            depthSpaces: 9,
            heightSpaces: 1,
            photoCell: true,
            engineType: EngineType.single,
            vmcId: widget.vmc!.vmcId,
            vmc: widget.vmc!),
        widget.itemPictures
      ];
    }

    if (configuration != null) {
      _currentNotes = configuration!.notes.map((e) => e).toList();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = widget.backgroundColor;
    if (backgroundColor == null) {
      if (isDarkTheme(context)) {
        backgroundColor = Color.alphaBlend(
            Theme.of(context).colorScheme.surface.withAlpha(240),
            Theme.of(context).colorScheme.primary);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: (widget.onAdd != null || widget.onClose != null)
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: backgroundColor,
                title: Text('${widget.item?.description}'),
                actions: [
                  if (widget.onAdd != null)
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          widget.onAdd?.call(sampleItemConfig);
                        });
                      },
                    ),
                  if (widget.onClose != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          widget.onClose?.call(sampleItemConfig);
                        });
                      },
                    )
                ],
              )
            : null,
        body: Column(
          children: [
            Expanded(
              child: SettingsScroll(
                controller: widget.scrollController,
                darkTheme: SettingsThemeData(
                  settingsListBackground: isDarkTheme(context)
                      ? Color.alphaBlend(
                          Theme.of(context).colorScheme.surface.withAlpha(240),
                          Theme.of(context).colorScheme.primary)
                      : Theme.of(context).colorScheme.surface,
                ),
                lightTheme: const SettingsThemeData(
                    settingsListBackground: Colors.transparent),
                //contentPadding: EdgeInsets.zero,
                platform: DevicePlatform.web,
                sections: [
                  _configurationSection(),
                  _imagesSection(),
                  _notesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(
      key: widget.configurationSectionKey,
      title: const Text(
        'Configurazione',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _widthSettingTile(),
        _heightSettingTile(),
        _depthSettingTile(),
        _engineSettingTile(),
        _engineTimingSettingTile(),
        _standSettingTile(),
        _photoCellSettingTile(),
        _flapSettingTile(),
        _packagingSettingTile(),
      ],
    );
  }

  SettingsScrollSection _imagesSection() {
    return SettingsScrollSection(
      key: widget.imageSectionKey,
      title: const Text(
        'Immagini',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _imagesSettingTile(),
      ],
    );
  }

  SettingsScrollSection _notesSection() {
    return SettingsScrollSection(
      key: widget.noteSettingsSectionKey,
      title: const Text(
        'Note',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _notesSettingTile(),
      ],
    );
  }

  /*SettingsTile _getUpDownSettingTile(
      {String? title,
      String? hint,
      required String initialValue,
      double min = 1,
      double max = 100,
      double step = 1,
      Function(int result)? onResult,
      int quarterTurns = 0,
      required Icon icon,
      String? description,
    int decimals = 0}) {
    return SettingsTile.navigation(
      onPressed: (context) async {
        int result = await displayUpDownInputDialog(context,
            title: title,
            hint: hint,
            initialValue: initialValue,
            decimals: decimals,
            min: min,
            step: step,
            max: max);
        onResult?.call(result);
      },
      leading: RotatedBox(
        quarterTurns: quarterTurns,
        child: icon,
      ),
      title: Text(title ?? ''),
      value: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null) Text(description),
          if (description != null)
            const SizedBox(
              height: 8,
            ),
          Text(initialValue, style: _itemValueTextStyle()),
        ],
      ),
    );
  }*/

  /*SettingsTile _getSelectionSettingTile({String? title,
    String? description,
    required Icon icon,
    String? hint,
    required String initialValue,
    required List<Widget> children}) {
    return SettingsTile.navigation(
      onPressed: (context) async {
        await _displaySelectionDialog(
            context, title ?? '', hint ?? '', initialValue, children);
      },
      leading: icon,
      title: Text(hint ?? ''),
      value: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null) Text(description),
          if (description != null)
            const SizedBox(
              height: 8,
            ),
          Text(
            initialValue,
            style: _itemValueTextStyle(),
          ),
        ],
      ),
    );
  }*/

  /*SettingsTile _getImagesSettingTile({String? title, String? description, required Icon icon, String? hint}) {
    return SettingsTile.navigation(
      onPressed: null,
      leading: icon,
      title: Text(hint ?? ''),
      value: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null) Text(description),
          if (description != null)
            const SizedBox(
              height: 8,
            ),
          ImageLoader(
            key: loaderKey,
            itemPictures: itemPictures?.map((e) => e.toItemPicture()).toList(),
            //sampleItemConfig?[1],
            onChanged: (values) {
              itemPictures =
                  values.map((e) => e.toSampleItemPicture()).toList();
            },
          ),
        ],
      ),
    );
  }
*/
  SettingsTile _getNotesSettingTile(
      {String? title,
      String? description,
      required Icon icon,
      String? hint,
      Key? key}) {
    return getCustomSettingTile(
      key: key,
      onPressed: null,
      icon: icon,
      title: title ?? '',
      hint: hint,
      description: description,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReorderableWrap(
            controller: noteListScrollController,
            spacing: 8,
            runSpacing: 8,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                //SampleItemNote noteOld = _currentNotes[oldIndex];
                /*SampleItemNote noteNew = _currentNotes[newIndex];*/
                SampleItemNote noteOld = _currentNotes.removeAt(oldIndex);
                _currentNotes.insert(newIndex, noteOld);
                /*for (int index=0; index<)
                _currentNotes[newIndex] = noteOld;
                _currentNotes[oldIndex] = noteNew;*/
                configuration = configuration!.copyWith(notes: _currentNotes);
              });
            },
            children: [
              ...List.generate(_currentNotes.length, (index) {
                return Note.fromSampleItemNote(
                  _currentNotes[index],
                  context,
                  onTap: () async {
                    ///modifica nota
                    ReminderConfiguration? note =
                    await addEditNoteDialog(note: _currentNotes[index]);

                    if (note != null) {
                      setState(() {
                        _currentNotes[index] = _currentNotes[index]
                            .copyWith(reminderConfiguration: note);
                        configuration =
                            configuration!.copyWith(notes: _currentNotes);
                      });
                    }
                  },
                  onRemove: () async {
                    bool result = await requestRemoveConfirmation(
                        _currentNotes[index].reminderConfiguration?.text ?? '');

                    if (result) {
                      setState(() {
                        _currentNotes.removeAt(index);
                      });
                    }
                  },
                );
              }),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 80,
            child: Align(
              alignment: Alignment.center,
              child: FloatingActionButton(
                  onPressed: () async {
                    ReminderConfiguration? note = await addEditNoteDialog();
                    if (note != null) {
                      setState(() {
                        /*_currentNotes.add(SampleItemNote(
                            text:
                                'Nota aggiunta tramite il pulsante + in fondo alla lista, esattamente in questo momento: ${DateTime.now().toString()}'));*/
                        _currentNotes.add(SampleItemNote(
                            sampleItemConfigurationId: 0,
                            reminderConfiguration: note));
                        configuration =
                            configuration!.copyWith(notes: _currentNotes);
                      });
                    }
                  },
                  child: const Icon(Icons.add)),
            ),
          )
        ],
      ),
    );
  }

  Future<ReminderConfiguration?> addEditNoteDialog(
      {SampleItemNote? note}) async {
    ReminderConfiguration? result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return multiDialog(
              content: NoteEditor(
            note: note?.reminderConfiguration,
          ));
        }).then((returningValue) {
      return returningValue;
    });

    return result;
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

/*  SettingsTile _getSwitchSettingTile(
      {required String title,
      required bool? initialValue,
      required Icon icon,
      String? description,
      required String textWhenTrue,
      required String textWhenFalse,
      Function(bool value)? onToggle}) {
    return SettingsTile.switchTile(
      onToggle: onToggle,
      initialValue: initialValue,
      leading: icon,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          if (description != null)
            DefaultTextStyle(
              style: TextStyle(
                  color: isDarkTheme(context)
                      ? darkTileDescriptionTextColor
                      : lightTileDescriptionTextColor),
              child: Text(description),
            ),
          if (description != null)
            const SizedBox(
              height: 8,
            ),
          Text(
            initialValue != null && initialValue == true
                ? textWhenTrue
                : textWhenFalse,
            style: _itemValueTextStyle(),
          ),
        ],
      ),
    );
  }*/

/*  SettingsTile _minimumHeightSettingTile(){
    return _getUpDownSettingTile(
        title: 'Inserisci altezza minima',
        hint: 'Altezza minima',
        description: 'Il prodotto non può essere posizionato al di sotto dell\'altezza minima. L\'unità di misura è il cassetto. Si considera come primo cassetto quello più in basso.',
        initialValue: item?.itemConfiguration?.minRow?.toString() ??
            'Non impostata',
        quarterTurns: 2,
        icon: const Icon(Icons.vertical_align_top),
        min: 1,
        step: 1,
        max: widget.vmc.vmcConfiguration?.maxRows,
        onResult: (int result){
          if (result != 1) {
            SampleItemConfiguration itemConfiguration =
            item!.itemConfiguration!;
            setState(() {
              item = item!.copyWith(
                  itemConfiguration:
                  itemConfiguration.copyWith(
                      minRow:
                      int.parse(_controller.text)));
            });
            widget.onSave?.call(item!);
          }
        });
    SettingsTile.navigation(
      onPressed: (context) async {
        int result = await _displayTextInputDialog(
            context,

            'Altezza minima',
            item?.itemConfiguration?.minRow?.toString() ??
                '6');
        if (result != 1) {
          SampleItemConfiguration itemConfiguration =
          item!.itemConfiguration!;
          setState(() {
            item = item!.copyWith(
                itemConfiguration:
                itemConfiguration.copyWith(
                    minRow:
                    int.parse(_controller.text)));
          });
          widget.onSave?.call(item!);
        }
      },
      leading: const RotatedBox(
        quarterTurns: 2,
        child: Icon(Icons.vertical_align_top),
      ),
      title: const Text('Altezza minima'),
      value: Text(
          item?.itemConfiguration?.minRow?.toString() ??
              'Non impostata'),
    ),
  }*/
  SettingsTile _photoCellSettingTile() {
    return getSwitchSettingTile(
        title: 'Fotocellula',
        description:
            'Imposta se è possibile utilizzare la fotocellula per l\'erogazione',
        initialValue: configuration?.photoCell,
        icon: const Icon(Icons.sensors),
        textWhenTrue: 'Attivata',
        textWhenFalse: 'Disattivata',
        onToggle: (value) {
          setState(() {
            configuration = configuration?.copyWith(photoCell: value);
          });
          widget.onSave?.call(sampleItemConfig);
        },
        defaultTextColor: isDarkTheme(context)
            ? darkTileDescriptionTextColor
            : lightTileDescriptionTextColor);
  }

  /*SettingsTile _envelopSettingTile() {
    return getSwitchSettingTile(
        title: 'Imbustare',
        description:
        'Attiva o disattiva la segnalazione di imbustare il prodotto per una corretta erogazione',
        initialValue: configuration?.envelop,
        icon: const Icon(Icons.move_to_inbox),
        textWhenTrue: 'Si',
        textWhenFalse: 'No',
        onToggle: (value) {
          setState(() {
            configuration = configuration?.copyWith(envelop: value);
          });
          widget.onSave?.call(sampleItemConfig);
        },
        defaultTextColor: isDarkTheme(context)
            ? darkTileDescriptionTextColor
            : lightTileDescriptionTextColor);
  }*/

  SettingsTile _packagingSettingTile() {
    return getSelectionSettingTile(
      title: 'Confezionamento',
      hint: 'Seleziona confezione',
      description:
          'Imposta l\'eventuale confezione da aggiungere al prodotto per una corretta erogazione',
      currentValueIcon: configuration?.packaging
          .toIcon(color: getTextColor(context: context)),
      icon: const Icon(Icons.move_to_inbox),
      initialValue: configuration!.packaging.toString(),
      children: [
        ...PackageType.values.map((e) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                configuration = configuration?.copyWith(packaging: e);
              });
              widget.onSave?.call(sampleItemConfig);
              if (!mounted) return;
              Navigator.of(context).maybePop();
            },
            //
            child: PackageType.toRowItem(e),
          );
        })
      ],
      controller: _controller,
    );
  }

  SettingsTile _flapSettingTile() {
    return getSwitchSettingTile(
        title: 'Aletta',
        description:
            'Attiva o disattiva la segnalazione di montare l\'aletta sulla spirale per una corretta erogazione',
        initialValue: configuration?.flap,
        icon: const Icon(Icons.switch_access_shortcut),
        textWhenTrue: 'Montare',
        textWhenFalse: 'Non montare',
        onToggle: (value) {
          setState(() {
            configuration = configuration?.copyWith(flap: value);
          });
          widget.onSave?.call(sampleItemConfig);
        },
        defaultTextColor: isDarkTheme(context)
            ? darkTileDescriptionTextColor
            : lightTileDescriptionTextColor);
  }

  SettingsTile _engineTimingSettingTile() {
    return getCustomSettingTile(
      title: 'Fasatura motori',
      hint: 'Imposta la fasatura dei motori',
      description:
          'Imposta la fasatura dei motori per ottimizzare il rilascio dell\'articolo in fase di erogazione.\r\nClicca sui motori per modificare l\'angolo di partenza delle molle',
      icon: const Icon(Icons.join_inner),
      child: SizedBox(
        height: 200,
        child: SpaceItemEx(
          showInfoElements: false,
          showQuotes: false,
          showEngineDegrees: true,
          onLeftEngineTap: () {
            setState(() {
              configuration = configuration?.copyWith(
                  leftEngineRotation:
                      (configuration?.leftEngineRotation ?? 0) + (15 / 360));

              if ((configuration?.leftEngineRotation.toPrecision(2) ?? 0) >=
                  1.0) {
                configuration = configuration?.copyWith(
                    leftEngineRotation:
                        (configuration?.leftEngineRotation ?? 0) - 1.0);
              }
            });
            widget.onSave?.call(sampleItemConfig);
          },
          onLeftEngineCancelTap: () {
            setState(() {
              configuration = configuration?.copyWith(
                  leftEngineRotation:
                      (configuration?.leftEngineRotation ?? 0) - (15 / 360));

              if ((configuration?.leftEngineRotation.toPrecision(2) ?? 0) <=
                  -1.0) {
                configuration = configuration?.copyWith(
                    leftEngineRotation:
                        (configuration?.leftEngineRotation ?? 0) + 1.0);
              }
            });
            widget.onSave?.call(sampleItemConfig);
          },
          onRightEngineTap: () {
            setState(() {
              configuration = configuration?.copyWith(
                  rightEngineRotation:
                      (configuration?.rightEngineRotation ?? 0) + (15 / 360));

              if ((configuration?.rightEngineRotation.toPrecision(2) ?? 0) >=
                  1.0) {
                configuration = configuration?.copyWith(
                    rightEngineRotation:
                        (configuration?.rightEngineRotation ?? 0) - 1.0);
              }
            });
            widget.onSave?.call(sampleItemConfig);
          },
          onRightEngineCancelTap: () {
            setState(() {
              configuration = configuration?.copyWith(
                  rightEngineRotation:
                      (configuration?.rightEngineRotation ?? 0) - (15 / 360));
              if ((configuration?.rightEngineRotation.toPrecision(2) ?? 0) <=
                  -1.0) {
                configuration = configuration?.copyWith(
                    rightEngineRotation:
                        (configuration?.rightEngineRotation ?? 0) + 1.0);
              }
            });
            widget.onSave?.call(sampleItemConfig);
          },
          vmc: widget.vmc!,
          itemConfiguration: configuration!,
          codeToShow: '',
        ),
      ),
    );
  }

  SettingsTile _standSettingTile() {
    return getCustomSettingTile(
      title: 'Alzatina',
      hint: 'Imposta l\'alzatina da utilizzare',
      description:
          'Seleziona o disattiva l\'utilizzo dell\'alzatina per l\'erogazione del prodotto\r\nL\'altezza viene modificata in accordo a questo parametro.',
      icon: const Icon(Icons.join_inner),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: SpaceItemEx(
              itemPictures: itemPictures,
              showInfoElements: false,
              showQuotes: false,
              onStandTap: () {
                setState(() {
                  int stand = configuration?.stand ?? 0;
                  stand++;
                  if (stand > 6) {
                    stand = 0;
                  }
                  configuration = configuration?.copyWith(stand: stand);
                });
                widget.onSave?.call(sampleItemConfig);
              },
              vmc: widget.vmc!,
              itemConfiguration: configuration!,
              codeToShow: '',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            StandType.fromType(configuration?.stand ?? 0).toString(),
            style: itemValueTextStyle(context: context),
          )
        ],
      ),
    );
  }

  SettingsTile _engineSettingTile() {
    return getSelectionSettingTile(
        title: 'Seleziona tipo motore',
        hint: 'Tipo motore',
        description: 'Imposta il tipo di motore utilizzato per l\'erogazione.',
        icon: const Icon(Icons.join_inner),
        initialValue: SampleItemConfiguration.engineTypeToString(
            configuration!.engineType),
        children: [
          ...EngineType.values.map((e) {
            return SimpleDialogOption(
              onPressed: () {
                setState(() {
                  if (e == EngineType.double &&
                      (configuration?.widthSpaces ?? 0) < 2) {
                    configuration = configuration?.copyWith(widthSpaces: 2);
                  }
                  if (e == EngineType.doubleCustom &&
                      (configuration?.widthSpaces ?? 0) < 2.5) {
                    configuration = configuration?.copyWith(widthSpaces: 2.5);
                  }

                  configuration = configuration?.copyWith(engineType: e);
                });
                widget.onSave?.call(sampleItemConfig);
                if (!mounted) return;
                Navigator.of(context).maybePop();
              },
              //
              child: SampleItemConfiguration.engineTypeToRowItem(e),
            );
          })
        ],
        controller: _controller);
  }

  SettingsTile _notesSettingTile() {
    return _getNotesSettingTile(
        key: _notesSettingTileKey,
        title: 'Note per un corretto caricamento del prodotto',
        hint: 'Note',
        description:
            'Inserisci le note necessarie all\'operatore per caricare correttamente il prodotto.',
        icon: const Icon(Icons.notes));
  }

  SettingsTile _imagesSettingTile() {
    return getImagesSettingTile(
        title: 'Seleziona immagini del prodotto configurato per l\'erogazione',
        hint: 'Lista immagini',
        description:
            'Immagini che mostrano come configurare l\'articolo per l\'erogazione',
        icon: const Icon(Icons.photo_album),
        loaderKey: loaderKey,
        itemPictures:
            itemPictures?.map((e) => e.toItemPicture()).toList() ?? [],
        onChanged: (values) {
          itemPictures = values.map((e) => e.toSampleItemPicture()).toList();
          widget.onSave?.call(sampleItemConfig);
        },
        onLoaded: (_) {});
  }

  SettingsTile _depthSettingTile() {
    return getUpDownSettingTile(
        title: 'Inserisci profondità',
      hint: 'Profondità',
      description:
          'Spazi occupati in profondità. Generalmente corrisponde al passo della spirale in cui viene contenuto il prodotto. Può comunque essere un valore diverso dai passi disponibili per questo modello. Valore minimo 1',
      initialValue: configuration?.depthSpaces.toInt().toString() ?? '1',
      quarterTurns: 3,
      icon: const Icon(Icons.keyboard_double_arrow_right),
      min: 1,
      step: 1,
      max: 50,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            configuration =
                configuration?.copyWith(depthSpaces: double.parse(result));
          });
          widget.onSave?.call(sampleItemConfig);
        }
      },
    );
  }

  SettingsTile _heightSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci altezza',
      hint: 'Altezza',
      description:
          'Spazi occupati verticalmente. Il valore 1 corrisponde all\'altezza di un cassetto. Valore minimo 0.1',
      initialValue: configuration?.heightSpaces.toString() ?? '1',
      icon: const Icon(Icons.expand),
      decimals: 1,
      step: 0.1,
      min: 0.1,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            configuration =
                configuration!.copyWith(heightSpaces: double.parse(result));
          });
          widget.onSave?.call(sampleItemConfig);
        }
      },
    );
  }

  SettingsTile _widthSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci larghezza',
      hint: 'Larghezza',
      description:
          'Spazi occupati orizzontalmente. Il valore 1 corrisponde alla larghezza di un motore. Valore minimo 0.5',
      initialValue: configuration?.widthSpaces.toString() ?? '1',
      quarterTurns: 1,
      icon: const Icon(Icons.expand),
      decimals: 1,
      step: 0.5,
      min: 0.5,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            configuration =
                configuration?.copyWith(widthSpaces: double.parse(result));
          });
          widget.onSave?.call(sampleItemConfig);
        }
      },
    );
  }

  /*TextStyle _itemValueTextStyle() {
    return TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: Color.alphaBlend(
            isDarkTheme(context)
                ? Colors.white.withAlpha(150)
                : Colors.black.withAlpha(150),
            Theme.of(context).colorScheme.primary));
  }*/

  @override
  void dispose() {
    super.dispose();
    noteListScrollController.dispose();
    _controller.dispose();
  }

/*Future<void> _displaySelectionDialog(BuildContext context, String title,
      String hint, String initialValue, List<Widget> children) async {
    _controller.text = initialValue;

    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            */ /*backgroundColor: isDarkTheme(context)
                  ? Color.alphaBlend(
                  Theme.of(context)
                      .colorScheme
                      .surface
                      .withAlpha(240),
                  Theme.of(context).colorScheme.primary)
                  : Theme.of(context).colorScheme.surface,*/ /*
              title: Text(title),
              children: children);
        });
  }
*/
/* Future<int> _displayUpDownInputDialog(BuildContext context,
      {String? title,
        String? hint,
        required String initialValue,
        double min = 1,
        double max = 100,
        double step = 1,
        double acceleration = 1,
        int decimals = 0}) async {
    _controller.text = initialValue;

    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title ?? ''),
            content: SpinBox(
              //key: _vmcWidthKey,
              max: max,
              min: min,
              decimals: decimals,
              acceleration: acceleration,
              step: step,
              value: double.parse(_controller.text),
              //focusNode: _vmcWidthFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                //editState = true;
                _controller.text = value.toString();
                //vmcWidthValue = value;
              },
              decoration:
              _upDownInputDecoration(labelText: title, hintText: hint),
              validator: (str) {
                */ /*  KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _vmcWidthKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;*/ /*
              },
            ),

            */ /*TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                ///solo numeri e punto
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))
              ],
              onChanged: (value) {},
              controller: _controller,
              decoration: InputDecoration(hintText: hint),
            ),
          */ /*

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(1);
                },
                child: Text(
                  'ANNULLA',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(0);
                  },
                  child: const Text('SALVA')),
            ],
          );
        });
  }

  InputDecoration _upDownInputDecoration({String? labelText, String? hintText}) {
    return textFieldInputDecoration(labelText: labelText, hintText: hintText);
  }*/
}
