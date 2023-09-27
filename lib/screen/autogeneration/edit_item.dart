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
import 'package:dpicenter/models/server/item_physics_configuration.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/image_loader/image_loader.dart';
import 'package:dpicenter/screen/widgets/markdown_editor/markdown_editor.dart';
import 'package:dpicenter/screen/widgets/note_editor/note.dart';
import 'package:dpicenter/screen/widgets/note_editor/note_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:reorderables/reorderables.dart';
import 'package:settings_ui/settings_ui.dart';

class EditItem extends StatefulWidget {
  final ItemPhysicsConfiguration? itemConfiguration;
  final List<ItemPicture>? itemPictures;

  final Item? item;

  final Function(List? config)? onSave;
  final Function(List? config)? onClose;
  final Function(List? config)? onAdd;

  final Color? backgroundColor;

  final List<AbstractSettingsTile>? textInputSettingsTileChildren;
  final ScrollController? scrollController;

  const EditItem(
      {this.itemPictures,
      this.itemConfiguration,
      this.item,
      this.onSave,
      this.onClose,
      this.onAdd,
      this.backgroundColor,
      this.textInputSettingsTileChildren,
      this.scrollController,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => EditItemState();
}

class EditItemState extends State<EditItem> {
  List? itemConfig;

  ItemPhysicsConfiguration? get configuration => itemConfig?[0];

  set configuration(ItemPhysicsConfiguration? configuration) {
    itemConfig = [configuration, itemConfig?[1]];
  }

  List<ItemPicture>? get itemPictures => itemConfig?[1];

  set itemPictures(List<ItemPicture>? itemPictures) {
    itemConfig = [itemConfig?[0], itemPictures];
  }

  final GlobalKey<ImageLoaderState> loaderKey =
      GlobalKey<ImageLoaderState>(debugLabel: 'loaderKey');

  final GlobalKey<MarkdownEditorState> notesKey =
      GlobalKey<MarkdownEditorState>(debugLabel: 'notesKey');

  final GlobalKey _notesSettingTileKey =
      GlobalKey(debugLabel: '_notesSettingTileKey');
  final GlobalKey _notesSettingSectionKey =
      GlobalKey(debugLabel: '_notesSettingSectionKey');

  final TextEditingController _controller = TextEditingController();

  final lightTileDescriptionTextColor = const Color.fromARGB(255, 70, 70, 70);
  final darkTileDescriptionTextColor = const Color.fromARGB(154, 160, 166, 198);

  @override
  void initState() {
    if (widget.itemConfiguration !=
        null /*non può esistere itemPictures se non è stata impostata una configuration*/) {
      itemConfig = [widget.itemConfiguration, widget.itemPictures];
    } else {
      itemConfig = [
        const ItemPhysicsConfiguration(itemPhysicsId: 0),
        widget.itemPictures
      ];
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
                          widget.onAdd?.call(itemConfig);
                        });
                      },
                    ),
                  if (widget.onClose != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          widget.onClose?.call(itemConfig);
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
                  if (widget.textInputSettingsTileChildren != null)
                    _textInputSection(),
                  _configurationSection(),
                  _imagesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SettingsScrollSection _textInputSection() {
    return SettingsScrollSection(
      title: const Text(
        'Dati generali',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: widget.textInputSettingsTileChildren!,
    );
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(
      title: const Text(
        'Configurazione',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _widthSettingTile(),
        _heightSettingTile(),
        _depthSettingTile(),
      ],
    );
  }

  SettingsScrollSection _imagesSection() {
    return SettingsScrollSection(
      title: const Text(
        'Immagini',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _imagesSettingTile(),
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
            controller: _controller,
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

  SettingsTile _getSelectionSettingTile(
      {String? title,
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
  }

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
            itemPictures: itemPictures,
            //sampleItemConfig?[1],
            onChanged: (values) {
              itemPictures =
                  values;
            },
          ),
        ],
      ),
    );
  }*/

  SettingsTile _getSwitchSettingTile(
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
  }

  SettingsTile _imagesSettingTile() {
    return getImagesSettingTile(
        title: 'Seleziona immagini da associare all\'articolo',
        hint: 'Lista immagini',
        description: 'Immagini che mostrano l\'articolo e la sua confezione',
        icon: const Icon(Icons.photo_album),
        onChanged: (value) {
          itemPictures = value;
          widget.onSave?.call(itemConfig);
        },
        onLoaded: (value) {},
        itemPictures: itemPictures ?? [],
        loaderKey: loaderKey);
  }

  SettingsTile _depthSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci profondità',
      hint: 'Profondità',
      description: 'Profondità dell\'articolo in millimetri',
      initialValue: configuration?.depthMm.toString() ?? '0',
      quarterTurns: 3,
      icon: const Icon(Icons.keyboard_double_arrow_right),
      min: 1,
      step: 1,
      max: 50,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            configuration =
                configuration?.copyWith(depthMm: double.parse(result));
          });
          widget.onSave?.call(itemConfig);
        }
      },
    );
  }

  SettingsTile _heightSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci altezza',
      hint: 'Altezza',
      description: 'Altezza dell\'articolo in millimetri',
      initialValue: configuration?.heightMm.toString() ?? '0',
      icon: const Icon(Icons.expand),
      decimals: 1,
      step: 0.1,
      min: 0.1,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            configuration =
                configuration!.copyWith(heightMm: double.parse(result));
          });
          widget.onSave?.call(itemConfig);
        }
      },
    );
  }

  SettingsTile _widthSettingTile() {
    return getUpDownSettingTile(
        controller: _controller,
        title: 'Inserisci larghezza',
        hint: 'Larghezza',
        description: 'Larghezza dell\'articolo in millimetri',
        initialValue: configuration?.widthMm.toString() ?? '0',
        quarterTurns: 1,
        icon: const Icon(Icons.expand),
        decimals: 1,
        step: 0.5,
        min: 0.5,
        onResult: (String? result) {
          if (result != null) {
            setState(() {
              configuration =
                  configuration?.copyWith(widthMm: double.parse(result));
            });
            widget.onSave?.call(itemConfig);
          }
        });
  }

  TextStyle _itemValueTextStyle() {
    return TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: Color.alphaBlend(
            isDarkTheme(context)
                ? Colors.white.withAlpha(150)
                : Colors.black.withAlpha(150),
            Theme.of(context).colorScheme.primary));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<int> _displayTextInputDialog(BuildContext context, String title,
      String hint, String initialValue) async {
    _controller.text = initialValue;

    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                ///solo numeri e punto
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))
              ],
              // Only numbers can be entered*/
              onChanged: (value) {},
              controller: _controller,
              decoration: InputDecoration(hintText: hint),
            ),
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

  Future<void> _displaySelectionDialog(BuildContext context, String title,
      String hint, String initialValue, List<Widget> children) async {
    _controller.text = initialValue;

    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            /*backgroundColor: isDarkTheme(context)
                  ? Color.alphaBlend(
                  Theme.of(context)
                      .colorScheme
                      .surface
                      .withAlpha(240),
                  Theme.of(context).colorScheme.primary)
                  : Theme.of(context).colorScheme.surface,*/
              title: Text(title),
              children: children);
        });
  }

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
