import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_configuration.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';

class EditVmc extends StatefulWidget {
  final Vmc vmc;
  final Function(Vmc vmc)? onSave;
  final Function(Vmc vmc)? onClose;

  const EditVmc({required this.vmc, this.onSave, this.onClose, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => EditVmcState();
}

class EditVmcState extends State<EditVmc> {
  late Vmc vmc;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    vmc = widget.vmc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    if (isDarkTheme(context)) {
      backgroundColor = Color.alphaBlend(
          Theme.of(context).colorScheme.surface.withAlpha(240),
          Theme.of(context).colorScheme.primary);
    }

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(vmc);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: backgroundColor,
            title: const Text('Distributore'),
            actions: [
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    widget.onClose?.call(vmc);
                  });
                },
              )
            ],
          ),
          body: Column(children: [
            Expanded(
                child: SettingsList(
                    platform: DevicePlatform.web, sections: [
              SettingsSection(
                title: Text(
                  'Configurazione',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    onPressed: (context) async {
                      int result = await _displayTextInputDialog(
                          context,
                              'Inserisci numero massimo cassetti',
                              'Numero massimo cassetti',
                              vmc.vmcConfiguration?.maxRows.toString() ?? "0");
                          if (result != 1) {
                            setState(() {
                              VmcConfiguration? vmcConfiguration =
                                  vmc.vmcConfiguration;
                              vmc = vmc.copyWith(
                                vmcConfiguration: vmcConfiguration?.copyWith(
                                    maxRows: int.parse(_controller.text)),
                              );

                              widget.onSave?.call(vmc);
                            });
                          }
                        },
                        leading: const RotatedBox(
                          quarterTurns: 1,
                          child: Icon(Icons.expand),
                        ),
                        title: const Text('Numero massimo cassetti'),
                        value: Text(
                            vmc.vmcConfiguration?.maxRows.toString() ?? "0"),
                      ),
                    ],
                  ),
                ])),
          ]),
        ));
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
}
