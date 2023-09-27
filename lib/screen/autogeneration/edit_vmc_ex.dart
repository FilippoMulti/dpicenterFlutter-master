import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_physics_configuration.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select_container.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

class EditVmcEx extends StatefulWidget {
  final VmcConfiguration? vmcConfiguration;
  final VmcPhysicsConfiguration? vmcPhysicsConfiguration;

  final Function(List? config)? onSave;
  final Function(List? config)? onClose;
  final Function(List? config)? onAdd;

  final Color? backgroundColor;

  final List<SettingsTile>? textInputSettingsTileChildren;
  final List<SettingsTile>? settingListSettingsTileChildren;
  final List<SettingsTile>? productionListSettingsTileChildren;
  final List<SettingsTile>? filesSettingsTileChildren;
  final ScrollController? scrollController;
  final String? title;

  final bool showPhysicsSettings;
  final bool showLogicSettings;

  const EditVmcEx(
      {this.onSave,
      this.onClose,
      this.onAdd,
      this.vmcConfiguration,
      this.vmcPhysicsConfiguration,
      this.backgroundColor,
      this.textInputSettingsTileChildren,
      this.settingListSettingsTileChildren,
      this.productionListSettingsTileChildren,
      this.filesSettingsTileChildren,
      this.scrollController,
      this.showPhysicsSettings = true,
      this.showLogicSettings = true,
      this.title,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => EditVmcExState();
}

class EditVmcExState extends State<EditVmcEx> {
  List? vmcConfig;
  final TextEditingController _controller = TextEditingController();

  VmcConfiguration? get configuration => vmcConfig?[1];

  set configuration(VmcConfiguration? configuration) {
    vmcConfig = [vmcConfig?[0], configuration];
  }

  VmcPhysicsConfiguration? get physicsConfiguration => vmcConfig?[0];

  set physicsConfiguration(VmcPhysicsConfiguration? physicsConfiguration) {
    vmcConfig = [physicsConfiguration, vmcConfig?[1]];
  }

  final lightTileDescriptionTextColor = const Color.fromARGB(255, 70, 70, 70);
  final darkTileDescriptionTextColor = const Color.fromARGB(154, 160, 166, 198);

  final GlobalKey _textInputSectionKey =
      GlobalKey(debugLabel: '_textInputSectionKey');
  final GlobalKey _physicsParamsSectionKey =
      GlobalKey(debugLabel: '_physicsParamsSectionKey');
  final GlobalKey _logicParamsSectionKey =
      GlobalKey(debugLabel: '_logicParamsSectionKey');
  final GlobalKey _settingsSectionKey =
      GlobalKey(debugLabel: '_settingsSectionKey');
  final GlobalKey _productionsSectionKey =
      GlobalKey(debugLabel: '_productionsSectionKey');
  final GlobalKey _docsSectionKey = GlobalKey(debugLabel: '_docsSectionKey');

  @override
  void initState() {
    configuration = widget.vmcConfiguration ??
        const VmcConfiguration(vmcConfigurationId: 0);
    physicsConfiguration = widget.vmcPhysicsConfiguration ??
        const VmcPhysicsConfiguration(vmcPhysicsConfigurationId: 0);

    vmcConfig = [physicsConfiguration, configuration];

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
    Map<MultiSelectorItem, GlobalKey> headers = {};

    if (widget.textInputSettingsTileChildren != null) {
      headers.addAll({
        const MultiSelectorItem(text: 'Dati generali'): _textInputSectionKey
      });
    }
    if (widget.showPhysicsSettings) {
      headers.addAll({
        const MultiSelectorItem(text: 'Parametri fisici'):
            _physicsParamsSectionKey
      });
    }
    if (widget.showLogicSettings) {
      headers.addAll({
        const MultiSelectorItem(text: 'Parametri logici'):
            _logicParamsSectionKey
      });
    }
    if (widget.settingListSettingsTileChildren != null) {
      headers.addAll(
          {const MultiSelectorItem(text: 'Impostazioni'): _settingsSectionKey});
    }
    if (widget.productionListSettingsTileChildren != null) {
      headers.addAll({
        const MultiSelectorItem(text: 'Produzione'): _productionsSectionKey
      });
    }
    if (widget.filesSettingsTileChildren != null) {
      headers.addAll(
          {const MultiSelectorItem(text: 'Documenti'): _docsSectionKey});
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: MultiSelectorContainer(
        title: widget.title,
        scrollController: widget.scrollController ?? ScrollController(),
        headerSectionsMap: headers,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: SettingsScroll(
                  controller: widget.scrollController,
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
                    if (widget.textInputSettingsTileChildren != null)
                      _textInputSection(),
                    if (widget.showPhysicsSettings)
                      _physicsConfigurationSection(),
                    if (widget.showLogicSettings) _logicConfigurationSection(),
                    if (widget.settingListSettingsTileChildren != null)
                      _listSettingSection(),
                    if (widget.productionListSettingsTileChildren != null)
                      _listProductionSection(),
                    if (widget.filesSettingsTileChildren != null)
                      _fileSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SettingsScrollSection _physicsConfigurationSection() {
    return SettingsScrollSection(
      key: _physicsParamsSectionKey,
      title: const Text(
        'Parametri fisici',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _widthSettingTile(),
        _heightSettingTile(),
        _depthSettingTile(),
        _drawerHeightSettingTile(),
        _contentHeightSettingTile(),
        _contentWidthSettingTile(),

        /*    _flapSettingTile(),
        _envelopSettingTile(),*/
      ],
    );
  }

  SettingsScrollSection _textInputSection() {
    return SettingsScrollSection(
      key: _textInputSectionKey,
      title: const Text(
        'Dati generali',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: widget.textInputSettingsTileChildren!,
    );
  }

  SettingsScrollSection _listSettingSection() {
    return SettingsScrollSection(
      key: _settingsSectionKey,
      title: const Text(
        'Impostazioni da compilare per questo modello',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: widget.settingListSettingsTileChildren!,
    );
  }

  SettingsScrollSection _listProductionSection() {
    return SettingsScrollSection(
      key: _productionsSectionKey,
      title: const Text(
        'Operazioni da compiere per preparare questo modello',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: widget.productionListSettingsTileChildren!,
    );
  }

  SettingsScrollSection _fileSection() {
    return SettingsScrollSection(
      key: _docsSectionKey,
      title: const Text(
        'Documentazione tecnica di questo modello',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: widget.filesSettingsTileChildren!,
    );
  }

  SettingsScrollSection _logicConfigurationSection() {
    return SettingsScrollSection(
      key: _logicParamsSectionKey,
      title: const Text(
        'Parametri logici',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _maxRowsSettingTile(),
        _maxSelectionsPerRowSettingTile(),
        _ticksPerSingleSpaceSettingTile(),

        /*    _flapSettingTile(),
        _envelopSettingTile(),*/
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

  SettingsTile _getSelectionSettingTile({String? title,
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

*/
  SettingsTile _maxRowsSettingTile() {
    return getUpDownSettingTile(
        title: 'Inserisci numero cassetti',
      hint: 'Numero cassetti',
      description:
          'Numero massimo di cassetti/piani che può contenere il distributore',
      initialValue: configuration?.maxRows.toString() ?? '1',
      quarterTurns: 1,
      icon: const Icon(Icons.expand),
      decimals: 0,
      step: 1,
      min: 1,
      max: 10,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            configuration =
                configuration?.copyWith(maxRows: double.parse(result).toInt());
          });
          widget.onSave?.call(vmcConfig);
        }
      },
    );
  }

  SettingsTile _maxSelectionsPerRowSettingTile() {
    return getUpDownSettingTile(
        title: 'Inserisci numero motori per piano',
      hint: 'Numero motori per piano',
      description:
          'Numero massimo di motori che può contenere un piano del distributore',
      initialValue: configuration?.maxWidthSpaces.toString() ?? '1',
      quarterTurns: 0,
      icon: const Icon(Icons.join_inner),
      decimals: 0,
      step: 1,
      min: 1,
      max: 20,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            configuration = configuration?.copyWith(
                maxWidthSpaces: double.parse(result).toInt());
          });
          widget.onSave?.call(vmcConfig);
        }
      },
    );
  }

  SettingsTile _ticksPerSingleSpaceSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci numero suddivisioni singolo spazio',
      hint: 'Numero suddivisioni singolo spazio',
      description: 'In quanti parti si può dividere un singolo spazio.',
      initialValue: configuration?.tickInSingleSpace.toString() ?? '4',
      quarterTurns: 1,
      icon: const Icon(Icons.expand),
      decimals: 0,
      step: 1,
      min: 1,
      max: 10,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            configuration = configuration?.copyWith(
                tickInSingleSpace: double.parse(result).toInt());
          });
          widget.onSave?.call(vmcConfig);
        }
      },
    );
  }

  SettingsTile _widthSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci larghezza',
      hint: 'Larghezza in millimetri',
      description: 'Larghezza distributore in millimetri',
      initialValue: physicsConfiguration?.vmcWidthMm.toString() ?? '1',
      quarterTurns: 1,
      icon: const Icon(Icons.expand),
      decimals: 1,
      step: 0.5,
      min: 0.5,
      max: 100000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            physicsConfiguration = physicsConfiguration?.copyWith(
                vmcWidthMm: double.parse(result));
          });
          widget.onSave?.call(vmcConfig);
        }
      },
    );
  }

  SettingsTile _heightSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci altezza',
      hint: 'Altezza in millimetri',
      description: 'Altezza distributore in millimetri',
      initialValue: physicsConfiguration?.vmcHeightMm.toString() ?? '1',
      quarterTurns: 0,
      icon: const Icon(Icons.expand),
      decimals: 1,
      step: 0.5,
      min: 0.5,
      max: 100000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            physicsConfiguration = physicsConfiguration?.copyWith(
                vmcHeightMm: double.parse(result));
          });
          widget.onSave?.call(vmcConfig);
        }
      },
    );
  }

  SettingsTile _depthSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci profondità',
      hint: 'Profondità in millimetri',
      description: 'Profondità distributore in millimetri',
      initialValue: physicsConfiguration?.vmcDepthMm.toString() ?? '1',
      quarterTurns: 3,
      icon: const Icon(Icons.keyboard_double_arrow_right),
      decimals: 1,
      step: 0.5,
      min: 0.5,
      max: 100000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            physicsConfiguration = physicsConfiguration?.copyWith(
                vmcDepthMm: double.parse(result));
          });
          widget.onSave?.call(vmcConfig);
        }
      },
    );
  }

  SettingsTile _drawerHeightSettingTile() {
    return getUpDownSettingTile(
      title: 'Inserisci altezza cassetto',
      hint: 'Altezza cassetto in millimetri',
      description: 'Spazio occupato verticalmente dal cassetto in millimetri',
      initialValue: physicsConfiguration?.drawerHeight.toString() ?? '1',
      quarterTurns: 0,
      icon: const Icon(Icons.expand),
      decimals: 1,
      step: 0.5,
      min: 0.5,
      max: 100000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            physicsConfiguration = physicsConfiguration?.copyWith(
                drawerHeight: double.parse(result));
          });
          widget.onSave?.call(vmcConfig);
        }
      },
    );
  }

  SettingsTile _contentHeightSettingTile() {
    return getUpDownSettingTile(
        title: 'Inserisci altezza spazio utile',
      hint: 'Altezza spazio utile cassetto in millimetri',
      description:
          'Spazio utile disponibile verticalmente per il prodotto all\'interno del cassetto, in millimetri',
      initialValue: physicsConfiguration?.contentHeight.toString() ?? '1',
      quarterTurns: 0,
      icon: const Icon(Icons.expand),
      decimals: 1,
      step: 0.5,
      min: 0.5,
      max: 100000,
      onResult: (String? result) {
        if (result != null) {
          setState(() {
            physicsConfiguration = physicsConfiguration?.copyWith(
                contentHeight: double.parse(result));
          });
          widget.onSave?.call(vmcConfig);
        }
      },
    );
  }

  SettingsTile _contentWidthSettingTile() {
    return getUpDownSettingTile(
        title: 'Inserisci larghezza singola selezione',
        hint: 'Larghezza singola selezione in millimetri',
        description:
            'Larghezza di una singola selezione. Corrisponde alla spazio occupato dal motore o da una singola spirale, in millimetri',
        initialValue: physicsConfiguration?.contentWidth.toString() ?? '1',
        quarterTurns: 0,
        icon: const Icon(Icons.expand),
        decimals: 1,
        step: 0.5,
        min: 0.5,
        max: 100000,
        onResult: (String? result) {
          if (result != null) {
            setState(() {
              physicsConfiguration = physicsConfiguration?.copyWith(
                  contentWidth: double.parse(result));
            });
            widget.onSave?.call(vmcConfig);
          }
        },
        controller: _controller);
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


}
