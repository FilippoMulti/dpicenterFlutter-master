import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/usage_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../globals/ui_global.dart';
import '../../models/server/autogeneration/vmc.dart';

class EditItemOld extends StatefulWidget {
  final VmcItem? item;

  ///TODO: includere vmc in VmcItem?
  final Vmc? vmc;

  final Function(VmcItem item)? onSave;
  final Function(VmcItem item)? onClose;
  final Function(VmcItem item)? onAdd;

  final Color? backgroundColor;

  const EditItemOld(
      {required this.item,
      this.onSave,
      this.onClose,
      this.onAdd,
      this.vmc,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => EditItemOldState();
}

class EditItemOldState extends State<EditItemOld> {
  VmcItem? item;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    item = widget.item;
    item ??= VmcItem(
        itemId: -1,
        item: const Item(
            itemId: -1, code: 'Nuovo', description: 'Nuovo articolo'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 1,
            depthSpaces: 9,
            heightSpaces: 1,
            photoCell: true,
            engineType: EngineType.single,
            vmcId: -1,
            vmc: widget.vmc!),
        usageConfiguration: const UsageConfiguration(value: 10, priority: 1));
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
        Navigator.of(context).pop(item);
        return false;
      },
      child: Scaffold(
        appBar: (widget.onAdd != null || widget.onClose != null)
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: backgroundColor,
                title: Text('${widget.item?.item.description}'),
                actions: [
                  if (widget.onAdd != null)
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          widget.onAdd?.call(item!);
                        });
                      },
                    ),
                  if (widget.onClose != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          widget.onClose?.call(item!);
                        });
                      },
                    )
                ],
              )
            : null,
        body: Column(
          children: [
            Expanded(
              child: SettingsList(
                shrinkWrap: true,
                //contentPadding: EdgeInsets.zero,
                platform: DevicePlatform.web,
                sections: [
                  SettingsSection(
                    title: const Text(
                      'Configurazione',
                      //  style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    tiles: <SettingsTile>[
                      _widthSettingTile(),
                      _heightSettingTile(),
                      _depthSettingTile(),
                      _engineSettingTile(),
                      _photoCellSettingTile(),
                    ],
                  ),
                  /*    SettingsSection(
                      title: Text(
                        'Posizionamento',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      tiles: <SettingsTile>[
                        _minimumHeightSettingTile(),
                        SettingsTile.navigation(
                          onPressed: (context) async {
                            int result = await _displayTextInputDialog(
                                context,
                                'Inserisci altezza massima',
                                'Altezza massima',
                                item?.itemConfiguration?.maxRow?.toString() ??
                                    '6');
                            if (result != 1) {
                              SampleItemConfiguration itemConfiguration =
                                  item!.itemConfiguration!;
                              setState(() {
                                item = item!.copyWith(
                                    itemConfiguration:
                                        itemConfiguration.copyWith(
                                            maxRow:
                                                int.parse(_controller.text)));
                              });
                              widget.onSave?.call(item!);
                            }
                          },
                          leading: const Icon(Icons.vertical_align_top),
                          title: const Text('Altezza massima'),
                          value: Text(
                              item?.itemConfiguration?.maxRow?.toString() ??
                                  'Non impostata'),
                        ),
                        SettingsTile.navigation(
                          onPressed: (context) async {
                            int result = await _displayTextInputDialog(
                                context,
                                'Inserisci posizione orizzontale minima',
                                'Posizione orizzontale minima',
                                item?.itemConfiguration?.minPos?.toString() ??
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
                            quarterTurns: 3,
                            child: Icon(Icons.vertical_align_top),
                          ),
                          title: const Text('Posizione orizzontale minima'),
                          value: Text(
                              item?.itemConfiguration?.minPos?.toString() ??
                                  'Non impostata'),
                        ),
                        SettingsTile.navigation(
                          onPressed: (context) async {
                            int result = await _displayTextInputDialog(
                                context,
                                'Inserisci posizione orizzontale massima',
                                'Posizione orizzontale massima',
                                item?.itemConfiguration?.maxPos?.toString() ??
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
                            quarterTurns: 1,
                            child: Icon(Icons.vertical_align_top),
                          ),
                          title: const Text('Posizione orizzontale massima'),
                          value: Text(
                              item?.itemConfiguration?.maxPos?.toString() ??
                                  'Non impostata'),
                        ),
                      ]),
                  SettingsSection(
                      title: Text(
                        'Quantità previste',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          onPressed: (context) async {
                            int result = await _displayTextInputDialog(
                                context,
                                'Inserisci quantità richiesta',
                                'Quantità richiesta',
                                item?.usageConfiguration?.value.toString() ??
                                    '1');
                            if (result != 1) {
                              UsageConfiguration usageConfiguration =
                                  item!.usageConfiguration!;
                              setState(() {
                                item = item!.copyWith(
                                    usageConfiguration:
                                        usageConfiguration.copyWith(
                                            value: double.parse(
                                                _controller.text)));
                              });
                              widget.onSave?.call(item!);
                            }
                          },
                          leading: const Icon(Icons.battery_full),
                          title: const Text('Quantità richiesta'),
                          value: Text(
                              item?.usageConfiguration?.value.toString() ??
                                  '1'),
                        ),
                        SettingsTile.navigation(
                            onPressed: (context) async {
                              int result = await _displayTextInputDialog(
                                  context,
                                  'Inserisci priorità',
                                  'Priorità',
                                  item?.usageConfiguration?.priority
                                          .toString() ??
                                      '1');
                              if (result != 1) {
                                UsageConfiguration usageConfiguration =
                                    item!.usageConfiguration!;
                                setState(() {
                                  item = item!.copyWith(
                                      usageConfiguration:
                                          usageConfiguration.copyWith(
                                              priority:
                                                  int.parse(_controller.text)));
                                });
                                widget.onSave?.call(item!);
                              }
                            },
                            leading: const Icon(Icons.priority_high),
                            title: const Text('Priorità'),
                            value: Text(
                                item?.usageConfiguration?.priority.toString() ??
                                    '1')),
                      ])*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SettingsTile _getUpDownSettingTile(
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
        int result = await _displayUpDownInputDialog(context,
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
  }

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

  final lightTileDescriptionTextColor = const Color.fromARGB(255, 70, 70, 70);
  final darkTileDescriptionTextColor = const Color.fromARGB(154, 160, 166, 198);

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
    return _getSwitchSettingTile(
      title: 'Fotocellula',
      description:
          'Imposta se è possibile utilizzare la fotocellula per l\'erogazione',
      initialValue: item?.itemConfiguration?.photoCell,
      icon: const Icon(Icons.sensors),
      textWhenTrue: 'Attivata',
      textWhenFalse: 'Disattivata',
      onToggle: (value) {
        SampleItemConfiguration itemConfiguration = item!.itemConfiguration!;
        setState(() {
          item = item!.copyWith(
              itemConfiguration: itemConfiguration.copyWith(photoCell: value));
        });
        widget.onSave?.call(item!);
      },
    );
  }

  SettingsTile _engineSettingTile() {
    return _getSelectionSettingTile(
        title: 'Seleziona tipo motore',
        hint: 'Tipo motore',
        description: 'Imposta il tipo di motore utilizzato per l\'erogazione.',
        icon: const Icon(Icons.join_inner),
        initialValue: SampleItemConfiguration.engineTypeToString(
            item!.itemConfiguration!.engineType),
        children: [
          ...EngineType.values.map((e) {
            return SimpleDialogOption(
              onPressed: () {
                SampleItemConfiguration itemConfiguration =
                    item!.itemConfiguration!;
                setState(() {
                  item = item!.copyWith(
                      itemConfiguration:
                          itemConfiguration.copyWith(engineType: e));
                });
                widget.onSave?.call(item!);
                if (!mounted) return;
                Navigator.of(context).maybePop();
              },
              //
              child: SampleItemConfiguration.engineTypeToRowItem(e),
            );
          })
        ]);
  }

  SettingsTile _depthSettingTile() {
    return _getUpDownSettingTile(
        title: 'Inserisci profondità',
        hint: 'Profondità',
        description:
            'Spazi occupati in profondità. Generalmente corrisponde al passo della spirale in cui viene contenuto il prodotto. Può comunque essere un valore diverso dai passi disponibili per questo modello. Valore minimo 1',
        initialValue: item?.itemConfiguration?.depthSpaces.toString() ?? '1',
        quarterTurns: 3,
        icon: const Icon(Icons.keyboard_double_arrow_right),
        min: 1,
        step: 1,
        max: 50,
        onResult: (int result) {
          if (result != 1) {
            SampleItemConfiguration itemConfiguration =
                item!.itemConfiguration!;
            setState(() {
              item = item!.copyWith(
                  itemConfiguration: itemConfiguration.copyWith(
                      depthSpaces: double.parse(_controller.text)));
            });
            widget.onSave?.call(item!);
          }
        });
  }

  SettingsTile _heightSettingTile() {
    return _getUpDownSettingTile(
        title: 'Inserisci altezza',
        hint: 'Altezza',
        description:
            'Spazi occupati verticalmente. Il valore 1 corrisponde all\'altezza di un cassetto. Valore minimo 0.1',
        initialValue: item?.itemConfiguration?.heightSpaces.toString() ?? '1',
        icon: const Icon(Icons.expand),
        decimals: 1,
        step: 0.1,
        min: 0.1,
        onResult: (int result) {
          if (result != 1) {
            SampleItemConfiguration itemConfiguration =
                item!.itemConfiguration!;
            setState(() {
              item = item!.copyWith(
                  itemConfiguration: itemConfiguration.copyWith(
                      heightSpaces: double.parse(_controller.text)));
            });
            widget.onSave?.call(item!);
          }
        });
  }

  SettingsTile _widthSettingTile() {
    return _getUpDownSettingTile(
        title: 'Inserisci larghezza',
        hint: 'Larghezza',
        description:
            'Spazi occupati orizzontalmente. Il valore 1 corrisponde alla larghezza di un motore. Valore minimo 0.5',
        initialValue: item?.itemConfiguration?.widthSpaces.toString() ?? '1',
        quarterTurns: 1,
        icon: const Icon(Icons.expand),
        decimals: 1,
        step: 0.5,
        min: 0.5,
        onResult: (int result) {
          if (result != 1) {
            SampleItemConfiguration itemConfiguration =
                item!.itemConfiguration!;
            setState(() {
              item = item!.copyWith(
                  itemConfiguration: itemConfiguration.copyWith(
                      widthSpaces: double.parse(_controller.text)));
            });
            widget.onSave?.call(item!);
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

  Future<int> _displayUpDownInputDialog(BuildContext context,
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
                /*  KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _vmcWidthKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;*/
              },
            ),

            /*TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                ///solo numeri e punto
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))
              ],
              onChanged: (value) {},
              controller: _controller,
              decoration: InputDecoration(hintText: hint),
            ),
          */

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

  InputDecoration _upDownInputDecoration(
      {String? labelText, String? hintText}) {
    return textFieldInputDecoration(labelText: labelText, hintText: hintText);
  }
}
