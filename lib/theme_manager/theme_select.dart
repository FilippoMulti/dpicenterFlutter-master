import 'dart:ui';

import 'package:dpicenter/blocs/resource_bloc.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/icons/icon_selector.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/models/server/resource_response.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dialog_header.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dpicenter/theme_manager/background_shape.dart';
import 'package:dpicenter/theme_manager/theme_color.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:vitality/models/ItemBehaviour.dart';

import '../screen/widgets/app_bar.dart';
import '../screen/widgets/dialog_ok_cancel.dart';

class ThemeSelect extends StatefulWidget {
  const ThemeSelect({
    Key? key,
  }) : super(key: key);

  @override
  ThemeSelectState createState() => ThemeSelectState();
}

class ThemeSelectState extends State<ThemeSelect> {
  int selectedIndex = -1;

  late TextEditingController _promptController;
  final GlobalKey _promptKey = GlobalKey(debugLabel: '_promptKey');

  ///andrà a sostituire selectedIndex per laa gestione dell'immagine di sfondo.
  String selectedBackgroundName = 'default.webp';

  double selectedMaxSpeed = 1.0;
  double selectedMinSpeed = 0.5;
  double selectedMaxSize = 30;
  bool backgroundEnableXMovements = true;
  bool backgroundEnableYMovements = false;

  double selectedOpacity = 0.50;
  double selectedSigmaX = 0;
  double selectedSigmaY = 0;
  ThemeMode themeType = ThemeMode.system;
  ThemeColors themeColor = ThemeColors.green;
  BlendMode selectedBlendMode = BlendMode.hue;
  ThemeFilterColors selectedFilterColor = ThemeFilterColors.system;
  bool showBackground = true;
  bool showBackgroundEffects = false;
  List<BackgroundShape> selectedBackgroundIcons = <BackgroundShape>[];
  List<int> selectedBackgroundColors = [];

  int? customFilterColor;

  List? currentTheme;

  bool editState = false;

  List<ResourceResponse>? backgroundImages;
  final FocusNode saveFocusNode = FocusNode(debugLabel: 'saveFocusNode');

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
    loadData();
  }

  @override
  void dispose() {
    saveFocusNode.dispose();
    _promptController.dispose();
    super.dispose();
  }

  void _loadImagesNameList() {
    var bloc = BlocProvider.of<ResourceBloc>(context);

    bloc.add(const ResourceEvent(
      status: ResourceEvents.fetchNameList,
    ));
  }

/*  void _loadImagePreview(String name){
    var bloc = BlocProvider.of<ResourceBloc>(context);

    bloc.add(ResourceEvent(
      status: ResourceEvents.fetchImagePreview,
      name: name,
    ));
  }*/
  void _loadImage(String name) {
    var bloc = BlocProvider.of<ResourceBloc>(context);

    bloc.add(ResourceEvent(
      status: ResourceEvents.fetchImage,
      name: name,
    ));
  }

  void _generateImage(String input) {
    var bloc = BlocProvider.of<ResourceBloc>(context);

    bloc.add(ResourceEvent(
      status: ResourceEvents.generateImage,
      input: input,
    ));
  }

  void loadData() {
    _loadImagesNameList();

    themeType = ThemeModeHandler.of(context)?.themeMode ?? ThemeMode.system;
    themeColor =
        ThemeModeHandler.of(context)?.themeColor.colorType ?? ThemeColors.green;
    /*selectedIndex =
        ThemeModeHandler.of(context)?.themeColor.backgroundImageIndex ?? 0;*/
    selectedBackgroundName =
        ThemeModeHandler.of(context)?.themeColor.backgroundImageName ??
            'default.webp';

    selectedOpacity =
        ThemeModeHandler.of(context)?.themeColor.backgroundOpacity ?? 0.87;
    selectedSigmaX =
        ThemeModeHandler.of(context)?.themeColor.backgroundBlurSigmaX ?? 50;
    selectedSigmaY =
        ThemeModeHandler.of(context)?.themeColor.backgroundBlurSigmaY ?? 50;
    selectedBlendMode =
        ThemeModeHandler.of(context)?.themeColor.backgroundBlendMode ??
            BlendMode.hue;
    selectedFilterColor =
        ThemeModeHandler.of(context)?.themeColor.backgroundFilterColors ??
            ThemeFilterColors.system;
    customFilterColor =
        ThemeModeHandler.of(context)?.themeColor.backgroundCustomFilterColor;

    showBackgroundEffects =
        ThemeModeHandler.of(context)?.themeColor.backgroundShowEffects ?? true;

    showBackground =
        ThemeModeHandler.of(context)?.themeColor.backgroundShowBackground ??
            false;
    selectedBackgroundIcons =
        ThemeModeHandler.of(context)?.themeColor.backgroundSelectedIcons ??
            <BackgroundShape>[
              const BackgroundShape(shape: ShapeType.Icon, icon: 'star'),
              const BackgroundShape(shape: ShapeType.Icon, icon: 'star_border'),
              const BackgroundShape(shape: ShapeType.StrokeCircle),
            ];
    selectedBackgroundColors =
        ThemeModeHandler.of(context)?.themeColor.backgroundEffectsColors ??
            <int>[
              Colors.yellow.value,
              Colors.white.value,
            ];
    backgroundEnableXMovements =
        ThemeModeHandler.of(context)?.themeColor.backgroundEnableXMovements ??
            true;
    backgroundEnableYMovements =
        ThemeModeHandler.of(context)?.themeColor.backgroundEnableYMovements ??
            false;
    selectedMaxSpeed =
        ThemeModeHandler.of(context)?.themeColor.backgroundMaxSpeed ?? 1.0;
    selectedMinSpeed =
        ThemeModeHandler.of(context)?.themeColor.backgroundMinSpeed ?? 0.5;
    selectedMaxSize =
        ThemeModeHandler.of(context)?.themeColor.backgroundMaxSize ?? 30;

    currentTheme = [
      ThemeModeHandler.of(context)?.themeMode,
      ThemeModeHandler.of(context)?.themeColor
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width > 1000
                    ? 900
                    : MediaQuery.of(context).size.width < 500
                        ? MediaQuery.of(context).size.width
                        : 500,
                child: Column(
                  children: [
                    Expanded(
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
                          _colorsSection(),
                          _backgroundSection(),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          OkCancel(
            onSave: () {
              validateSave();
            },
            onCancel: () {
              resetState();
              Navigator.maybePop(context);
            },
            onOptional: () async {
              bool result = await defaultThemeMessage(context);

              if (result) {
                if (mounted) {
                  var themeModeHandler = ThemeModeHandler.of(context);
                  themeModeHandler?.saveThemeMode(ThemeMode.system,
                      const ThemeColor(colorType: ThemeColors.green));

                  setState(() {
                    loadData();
                  });
                }
              }
            },
            optionalText: "DEFAULT",
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.circular(2)),
            elevation: 8,
            okFocusNode: saveFocusNode,
          ),
        ],
      ),
    );
    /* return Container(
      color: getAppBackgroundColor(context),
      child:
      SettingsScroll(
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

      )

      Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const DialogHeader(
                      "Modalità colore",
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    ),
                    themeModeSelect(),
                    divider(),
                    const SizedBox(
                      height: 8,
                    ),
                    const DialogHeader(
                      "Colori",
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    ),
                    colorSelect(),
                    divider(),
                    const SizedBox(
                      height: 8,
                    ),
                    const DialogHeader(
                      "Sfondo",
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    ),
                    imageSelect(),
                    divider(),
                    const SizedBox(
                      height: 8,
                    ),
                    const DialogHeader(
                      "Sfocatura",
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    ),
                    sigmaXSelect(),
                    sigmaYSelect(),
                    divider(),
                    const SizedBox(
                      height: 8,
                    ),
                    const DialogHeader(
                      "Opacità sfondo",
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    ),
                    opacitySelect(),
                    divider(),
                    const SizedBox(
                      height: 8,
                    ),
                    const DialogHeader(
                      "Filtro colore sfondo",
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    ),
                    backgroundColorFilterSelect(),
                    divider(),
                    const SizedBox(
                      height: 8,
                    ),
                    const DialogHeader(
                      "Modalità fusione",
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    ),
                    blendModeSelect(),
                    divider(),
                  ],
                ),
              )),

        ],
      ),
    );*/
  }

  SettingsScrollSection _colorsSection() {
    return SettingsScrollSection(
      title: const Text(
        'Colori',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: [
        _themeModeSelectSettingTile(),
        _colorSelectSettingTile(),
      ],
    );
  }

  SettingsScrollSection _backgroundSection() {
    return SettingsScrollSection(
      title: const Text(
        'Immagine di sfondo',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: [
        _backgroundSettingTile(),
        _effectsSettingTile(),
        _blurSettingTile(),
        _opacitySettingTile(),
        _colorFilterSettingTile(),
        //_blendModeSelectSettingTile(),
      ],
    );
  }

  SettingsTile _themeModeSelectSettingTile() {
    return getCustomSettingTile(
        title: 'Luminosità colore',
        hint: 'Modalità colore',
        description: 'Seleziona la luminosità del colore',
        child: themeModeSelect());
  }

  SettingsTile _colorSelectSettingTile() {
    return getCustomSettingTile(
        title: 'Colore tema',
        hint: 'Colore tema',
        description: 'Seleziona il colore del tema',
        child: colorSelect());
  }

  SettingsTile _backgroundSettingTile() {
    return getCustomSettingTile(
        title: 'Seleziona immagine sfondo',
        hint: 'Immagine di sfondo',
        description: 'Immagine di sfondo dell\'applicazione',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: showBackground,
                  onChanged: (value) {
                    setState(() {
                      showBackground = value!;
                      onThemeShowBackgroundChanged(showBackground);
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text("Attiva immagine sfondo"),
              ],
            ),
            imageSelect(),
            imageGeneration()
          ],
        ));
  }

  SettingsTile _effectsSettingTile() {
    return getCustomSettingTile(
        title: 'Seleziona effetto sfondo',
        hint: 'Effetto di sfondo',
        description: 'Effetto di sfondo dell\'applicazione',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                children: [
                  Checkbox(
                    value: showBackgroundEffects,
                    onChanged: (value) {
                      setState(() {
                        showBackgroundEffects = value!;
                        onThemeShowEffectsChanged(showBackgroundEffects);
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text("Attiva effetto sfondo"),
                ],
              ),
            ),
            Flexible(child: _selectedIcons()),
            const SizedBox(height: 8),
            _minSpeedSelect(),
            const Divider(),
            _maxSpeedSelect(),
            const Divider(),
            _maxSizeSelect(),
            const Divider(),
            _enableYMovements(),
            const Divider(),
            _enableXMovements(),
            const Divider(),
            _selectedColors(),
          ],
        ));
  }

  Widget sigmaXSelect() {
    return Column(children: [
      Slider(
        value: selectedSigmaX / 100,
        max: 1.0,
        min: 0.0,

        //divisions: 75,

        onChangeEnd: (double value) {
          setState(() {
            selectedSigmaX = value * 100;
            onThemeSigmaXChanged(selectedSigmaX);
          });
        },
        onChanged: (double value) {
          setState(() {
            selectedSigmaX = value * 100;
          });
        },
      ),
      Text((selectedSigmaX)
          .toStringAsPrecision(selectedSigmaX.toInt().toString().length + 1))
    ]);
  }

  Widget _minSpeedSelect() {
    return Column(children: [
      const Text("Velocità minima"),
      Slider(
        value: selectedMinSpeed,
        max: 5.00,
        min: 0.01,

        //divisions: 9,

        onChangeEnd: (double value) {
          setState(() {
            selectedMinSpeed = value;
            onThemeMinSpeedChanged(value);
          });
        },
        onChanged: (double value) {
          setState(() {
            selectedMinSpeed = value;
          });
        },
      ),
      Text((selectedMinSpeed).toStringAsPrecision(4))
    ]);
  }

  Widget _maxSpeedSelect() {
    return Column(children: [
      const Text("Velocità massima"),
      Slider(
        value: selectedMaxSpeed,
        max: 5.00,
        min: 0.01,

        //divisions: 9,

        onChangeEnd: (double value) {
          setState(() {
            selectedMaxSpeed = value;
            onThemeMaxSpeedChanged(value);
          });
        },
        onChanged: (double value) {
          setState(() {
            selectedMaxSpeed = value;
          });
        },
      ),
      Text((selectedMaxSpeed).toStringAsPrecision(4))
    ]);
  }

  Widget _maxSizeSelect() {
    return Column(children: [
      const Text("Dimensione massima"),
      Slider(
        value: selectedMaxSize,
        max: 1000,
        min: 5,

        //divisions: 9,

        onChangeEnd: (double value) {
          setState(() {
            selectedMaxSize = value;
            onThemeMaxSizeChanged(value);
          });
        },
        onChanged: (double value) {
          setState(() {
            selectedMaxSize = value;
          });
        },
      ),
      Text((selectedMaxSize).toStringAsPrecision(5))
    ]);
  }

  Widget _enableYMovements() {
    return Row(children: [
      Checkbox(
        value: backgroundEnableYMovements,
        onChanged: (value) {
          setState(() {
            backgroundEnableYMovements = value!;
            onThemeEnabledYMovementsChanged(backgroundEnableYMovements);
          });
        },
      ),
      const SizedBox(width: 8),
      const Text("Attiva scrolling verticale"),
    ]);
  }

  Widget _enableXMovements() {
    return Row(children: [
      Checkbox(
        value: backgroundEnableXMovements,
        onChanged: (value) {
          setState(() {
            backgroundEnableXMovements = value!;
            onThemeEnabledXMovementsChanged(backgroundEnableXMovements);
          });
        },
      ),
      const SizedBox(width: 8),
      const Text("Attiva scrolling orizzontale"),
    ]);
  }

  Widget _selectedIcons() {
    return Column(
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (selectedBackgroundIcons[index].shape == ShapeType.Icon) {
                return ListTile(
                  leading: Icon(icons[selectedBackgroundIcons[index].icon!]),
                  title: Text(selectedBackgroundIcons[index].icon ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.clear,
                        color: Theme.of(context).colorScheme.error),
                    onPressed: () {
                      setState(() {
                        selectedBackgroundIcons.removeAt(index);
                        onThemeShapeBackgroundChanged(selectedBackgroundIcons);
                      });
                    },
                  ),
                );
              } else {
                return ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(selectedBackgroundIcons[index].shape.name),
                  trailing: IconButton(
                    icon: Icon(Icons.clear,
                        color: Theme.of(context).colorScheme.error),
                    onPressed: () {
                      setState(() {
                        selectedBackgroundIcons.removeAt(index);
                        onThemeShapeBackgroundChanged(selectedBackgroundIcons);
                      });
                    },
                  ),
                );
              }
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: selectedBackgroundIcons.length),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                String? result = await showIconSelector(context);
                if (result != null) {
                  setState(() {
                    selectedBackgroundIcons.add(
                        BackgroundShape(shape: ShapeType.Icon, icon: result));
                  });
                }
              }),
        )
      ],
    );
  }

  Widget _selectedColors() {
    return Column(
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                    width: 32,
                    height: 32,
                    color: Color(selectedBackgroundColors[index])),
                title: Text(Color(selectedBackgroundColors[index]).toString()),
                trailing: IconButton(
                  icon: Icon(Icons.clear,
                      color: Theme.of(context).colorScheme.error),
                  onPressed: () {
                    setState(() {
                      selectedBackgroundColors.removeAt(index);
                      onThemeBackgroundColorsChanged(selectedBackgroundColors);
                    });
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: selectedBackgroundColors.length),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                Color? result = await selectColorPicker(context: context);
                if (result != null) {
                  setState(() {
                    selectedBackgroundColors.add(result.value);
                  });
                }
              }),
        )
      ],
    );
  }

  SettingsTile _opacitySettingTile() {
    return getCustomSettingTile(
      title: 'Seleziona opacità',
      hint: 'Imposta l\'opacità dell\'applicazione',
      description:
          'Rende più o meno visibile lo sfondo applicando una trasparenza all\'applicazione',
      child: opacitySelect(),
    );
  }

  SettingsTile _colorFilterSettingTile() {
    return getCustomSettingTile(
      title: 'Seleziona filtro colore',
      hint: 'Seleziona filtro colore',
      description:
          'Imposta il comportamento del filtro colorato applicato allo sfondo',
      child: backgroundColorFilterSelect(),
    );
  }

  SettingsTile _blendModeSelectSettingTile() {
    return getCustomSettingTile(
      title: 'Seleziona modalità di fusione',
      hint: 'Seleziona modalità di fusione',
      description: 'Imposta la modalità di fusione del colore',
      child: blendModeSelect(),
    );
  }

  SettingsTile _blurSettingTile() {
    return getCustomSettingTile(
        title: 'Seleziona sfocatura',
        hint: 'Imposta sfocatura sfondo',
        description:
            'Seleziona la sfocatura da applicare all\'immagine di sfondo',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: sigmaXSelect()),
            Flexible(child: sigmaYSelect()),
          ],
        ));
  }

  Future<bool> defaultThemeMessage(BuildContext context) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          title: 'Default',
          message: 'Reimpostare il tema ai valori iniziali?',
          type: MessageDialogType.yesNo,
          yesText: 'SI',
          noText: 'NO',
          okPressed: () {
            Navigator.pop(context, true);
          },
          noPressed: () {
            Navigator.pop(context, false);
          },
        );
      },
    ).then((value) async {
      return value;
//return value
    });
    return result;
  }

  Widget sigmaYSelect() {
    return Column(children: [
      Slider(
        value: selectedSigmaY / 100,
        max: 1.0,
        min: 0.0,

        //divisions: 200,

        onChangeEnd: (double value) {
          setState(() {
            selectedSigmaY = value * 100;
            onThemeSigmaYChanged(selectedSigmaY);
          });
        },

        onChanged: (double value) {
          setState(() {
            selectedSigmaY = value * 100;
          });
        },
      ),
      Text((selectedSigmaY)
          .toStringAsPrecision(selectedSigmaY.toInt().toString().length + 1))
    ]);
  }



  Widget opacitySelect() {
    return Column(children: [
      Slider(
        value: selectedOpacity,
        max: 1.00,
        min: 0.50,

        //divisions: 9,

        onChangeEnd: (double value) {
          setState(() {
            selectedOpacity = value;
            onThemeOpacityChanged(value);
          });
        },
        onChanged: (double value) {
          setState(() {
            selectedOpacity = value;
          });
        },
      ),
      Text((selectedOpacity).toStringAsPrecision(4))
    ]);
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Divider(
        height: 0.1,
      ),
    );
  }

  Widget themeModeSelect() {
    return ListTile(
      title: SizedBox(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeModeChanged(ThemeMode.system),
                    title: const Text('Sistema'),
                    leading: Radio<ThemeMode>(
                        value: ThemeMode.system,
                        groupValue: themeType,
                        onChanged: onThemeModeChanged),
                  ),
                ),
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeModeChanged(ThemeMode.light),
                    title: const Text('Chiaro'),
                    leading: Radio<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: themeType,
                      onChanged: onThemeModeChanged,
                    ),
                  ),
                ),
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeModeChanged(ThemeMode.dark),
                    title: const Text('Scuro'),
                    leading: Radio<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: themeType,
                      onChanged: onThemeModeChanged,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget backgroundColorFilterSelect() {
    return ListTile(
      title: SizedBox(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeFilterColorChanged(
                        ThemeFilterColors.system,
                        Theme.of(context).colorScheme.primary.value),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Tema'),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                            height: 30,
                            width: 30,
                            color: Theme.of(context).colorScheme.primary)
                      ],
                    ),
                    leading: Radio<ThemeFilterColors>(
                        value: ThemeFilterColors.system,
                        groupValue: selectedFilterColor,
                        onChanged: (value) => onThemeFilterColorChanged(
                            ThemeFilterColors.system,
                            Theme.of(context).colorScheme.primary.value)),
                  ),
                ),
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeFilterColorChanged(
                        ThemeFilterColors.custom, customFilterColor),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Custom'),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                            height: 30,
                            width: 30,
                            color: Color(customFilterColor ?? 0))
                      ],
                    ),
                    leading: Radio<ThemeFilterColors>(
                      value: ThemeFilterColors.custom,
                      groupValue: selectedFilterColor,
                      onChanged: (value) => onThemeFilterColorChanged(
                          ThemeFilterColors.custom, customFilterColor),
                    ),
                  ),
                ),
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeFilterColorChanged(
                        ThemeFilterColors.transparent,
                        Colors.transparent.value),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Nessun filtro'),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                            height: 30, width: 30, color: Colors.transparent)
                      ],
                    ),
                    leading: Radio<ThemeFilterColors>(
                      value: ThemeFilterColors.transparent,
                      groupValue: selectedFilterColor,
                      onChanged: (value) => onThemeFilterColorChanged(
                          ThemeFilterColors.transparent,
                          Colors.transparent.value),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget blendModeSelect() {
    return ListTile(
      title: SizedBox(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    BlendMode.values.length,
                        (index) => IntrinsicWidth(
                      child: ListTile(
                        onTap: () => onThemeBlendModeChanged(
                            BlendMode.values[index]),
                        title: Text(BlendMode.values[index]
                            .toString()
                            .replaceAll("BlendMode.", "")),
                        leading: Radio<BlendMode>(
                            value: BlendMode.values[index],
                            groupValue: selectedBlendMode,
                            onChanged: (value) => onThemeBlendModeChanged(
                                BlendMode.values[index])),
                      ),
                    ))),
          )),
    );
  }

  Widget colorSelect() {
    return ListTile(
      title: SizedBox(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeColorChanged(ThemeColors.green),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Default'),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(height: 30, width: 30, color: kGreenMultiTech)
                      ],
                    ),
                    leading: Radio<ThemeColors>(
                        value: ThemeColors.green,
                        groupValue: themeColor,
                        onChanged: onThemeColorChanged),
                  ),
                ),
                /* IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeColorChanged(ThemeColors.red),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Rosso'),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(height: 30, width: 30, color: Colors.red)
                      ],
                    ),
                    leading: Radio<ThemeColors>(
                      value: ThemeColors.red,
                      groupValue: themeColor,
                      onChanged: onThemeColorChanged,
                    ),
                  ),
                ),
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeColorChanged(ThemeColors.blue),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Blu'),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(height: 30, width: 30, color: Colors.blue)
                      ],
                    ),
                    leading: Radio<ThemeColors>(
                      value: ThemeColors.blue,
                      groupValue: themeColor,
                      onChanged: onThemeColorChanged,
                    ),
                  ),
                ),*/
                IntrinsicWidth(
                  child: ListTile(
                    onTap: () => onThemeColorChanged(ThemeColors.custom),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Custom'),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          color: Color(ThemeModeHandler.of(context)!
                              .themeColor
                              .customColor ??
                              Colors.green.value),
                        )
                      ],
                    ),
                    leading: Radio<ThemeColors>(
                      value: ThemeColors.custom,
                      groupValue: themeColor,
                      onChanged: onThemeColorChanged,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  int getImageIndex(String name) {
    for (int index = 0; index < backgroundImages!.length; index++) {
      if (backgroundImages![index].name == name) {
        return index;
      }
    }
    return -1;
  }

  Widget waitImage() {
    return ListTile(
      title: SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    shimmerCondensedComboLoading(context,
                        height: 150, width: 300),
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(selectedIndex < 0 ||
                                  selectedIndex >=
                                      (backgroundImages?.length ?? 0)
                              ? ''
                              : (backgroundImages?[selectedIndex].name ?? ''))),
                    ),
                  ],
                ),
                arrows(),
              ],
            ),
          )),
    );
  }

  Widget imageSelect() {
    return BlocListener<ResourceBloc, ResourceState>(
      listener: (context, ResourceState state) async {
        if (state is ResourceInitState) {}
        if (state is ResourceFetchCompletedState) {
          backgroundImages = state.nameList;
          if (selectedIndex == -1) {
            selectedIndex = getImageIndex(selectedBackgroundName);
          }
          if (state.event.status != ResourceEvents.fetchNameList) {
            if (state.items[0].name != selectedBackgroundName) {
              onThemeBackgroundImageChanged(state.items[0]);
            }
          }
        }
      },
      child: BlocBuilder<ResourceBloc, ResourceState>(
        builder: (context, ResourceState state) {
          Widget? child = waitImage();
          if (state is ResourceInitState) {
            child = waitImage();
          }

          if (state is ResourceError) {
            child = Text(state.error.toString());
          }
          if (state is ResourceFetchCompletedState) {
            ResourceResponse? image;
            if (state.event.status == ResourceEvents.fetchNameList) {
              image = ThemeModeHandler.of(context)?.themeColor.backgroundImage;
              image ??= ResourceResponse(
                  name: 'default.webp',
                  decodedContents: defaultBackgroundBytes!);
            } else {
              if (state.items[0].name != selectedBackgroundName) {
                image = state.items[0];
              } else {
                image =
                    ThemeModeHandler.of(context)?.themeColor.backgroundImage;
              }
            }

            child = ListTile(
              title: SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (image != null)
                                SizedBox(
                                    width: 300,
                                    child: imagePreviewFromResourceResponse(
                                        image)),
                            ],
                          ),
                        ),
                        arrows(),
                      ],
                    ),
                  )),
            );
          }

          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350), child: child);
          if (state is ResourceInitState) {
            return const SizedBox();
          }
          if (state is ResourceFetchCompletedState) {}
        },
      ),
    );
  }

  Widget imageGeneration() {
    return BlocListener<ResourceBloc, ResourceState>(
      listener: (context, ResourceState state) async {
        if (state is ResourceInitState) {}
        if (state is ResourceFetchCompletedState) {
          backgroundImages = state.nameList;
          if (selectedIndex == -1) {
            selectedIndex = getImageIndex(selectedBackgroundName);
          }
          if (state.event.status != ResourceEvents.fetchNameList) {
            if (state.items[0].name != selectedBackgroundName) {
              onThemeBackgroundImageChanged(state.items[0]);
            }
          }
        }
      },
      child: BlocBuilder<ResourceBloc, ResourceState>(
        builder: (context, ResourceState state) {
          Widget? child = imageGenerationWidget(true);
          if (state is ResourceInitState) {
            child = imageGenerationWidget(true);
          }

          if (state is ResourceError) {
            child = Text(state.error.toString());
          }
          if (state is ResourceFetchCompletedState) {
            child = imageGenerationWidget(false);
          }

          /* return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350), child: child);*/
          return child;
          if (state is ResourceInitState) {
            return const SizedBox();
          }
          if (state is ResourceFetchCompletedState) {}
        },
      ),
    );
  }

  Widget imageGenerationWidget(bool loading) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          key: _promptKey,
          /*autovalidateMode: _autovalidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,*/
          controller: _promptController,
          maxLength: 500,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Inserisci un testo',
            hintText: 'Inserisci un testo dettagliato per generare un immagine',
          ),
          validator: (str) {
            return null;
          },
          textInputAction: TextInputAction.next,
          onChanged: (value) => editState = true,
        ),
        if (!loading) const SizedBox(height: 8),
        if (!loading)
          ElevatedButton(
              onPressed: () {
                if (_promptController.text.isNotEmpty) {
                  _generateImage(_promptController.text);
                }
              },
              child: const Text("Genera")),
      ],
    );
  }

  Widget arrows() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 50,
              height: 50,
              child: Material(
                type: MaterialType.transparency,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      /*prefs!.setString(
                                    'currentImage', selectedIndex.toString());*/
                      setState(() {
                        if (selectedIndex - 1 < 0) {
                          selectedIndex = (backgroundImages?.length ?? 1 - 1);
                        } else {
                          selectedIndex--;
                        }
                        _loadImage(backgroundImages![selectedIndex].name);

                        //_loadImage(backgroundImages![selectedIndex].name);

                        //onThemeImageChanged(selectedIndex);
                        //currentBackground = selectedIndex;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_left,
                      size: 45,
                    )),
              )),
          SizedBox(
            width: 50,
            height: 50,
            child: Material(
              type: MaterialType.transparency,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    /*prefs!.setString(
                                    'currentImage', selectedIndex.toString());*/
                    setState(() {
                      if (selectedIndex + 1 < (backgroundImages?.length ?? 0)) {
                        selectedIndex++;
                      } else {
                        selectedIndex = 0;
                      }
                      _loadImage(backgroundImages![selectedIndex].name);
                      //onThemeImageChanged(selectedIndex);

                      //currentBackground = selectedIndex;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_right,
                    size: 45,
                  )),
            ),
          ),
        ],
      ),
    );
  }
  InputDecoration _blurSigmaDecoration(String text) {
    return textFieldInputDecoration(labelText: text);
  }

  Widget blurSigmaX() {
    return SizedBox(
      width: 200,
      child: ListTile(
        title: SpinBox(
          max: 1000,
          min: 1,
          acceleration: 1,
          step: 1,
          value: ThemeModeHandler.of(context)!.themeColor.backgroundBlurSigmaX,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            onThemeSigmaXChanged(value);
            editState = true;

            /*editState = true;
            widthValue = value;*/
          },
          decoration: _blurSigmaDecoration("Sigma X"),
        ),
      ),
    );
  }

  Widget blurSigmaY() {
    return ListTile(
      title: SizedBox(
        width: 200,
        child: SpinBox(
          max: 1000,
          min: 1,
          acceleration: 1,
          step: 1,
          value: ThemeModeHandler.of(context)!.themeColor.backgroundBlurSigmaY,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            onThemeSigmaYChanged(value);
            editState = true;
            /*editState = true;
            widthValue = value;*/
          },
          decoration: _blurSigmaDecoration("Sigma Y"),
        ),
      ),
    );
  }

  void onThemeSigmaXChanged(double? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;
    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor.copyWith(backgroundBlurSigmaX: value));
      }
    }
  }

  void onThemeMinSpeedChanged(double? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;
    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor.copyWith(backgroundMinSpeed: value));
      }
    }
  }

  void onThemeMaxSpeedChanged(double? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;
    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor.copyWith(backgroundMaxSpeed: value));
      }
    }
  }

  void onThemeMaxSizeChanged(double? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;
    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor.copyWith(backgroundMaxSize: value));
      }
    }
  }

  void onThemeEnabledXMovementsChanged(bool value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;
    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor
                .copyWith(backgroundEnableXMovements: value));
      }
    }
  }

  void onThemeBackgroundColorsChanged(List<int> value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;
    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor
                .copyWith(backgroundEffectsColors: value));
      }
    }
  }

  void onThemeEnabledYMovementsChanged(bool value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;
    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor
                .copyWith(backgroundEnableYMovements: value));
      }
    }
  }

  void onThemeShowBackgroundChanged(bool value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (themeModeHandler != null) {
      await ThemeModeHandler.of(context)?.saveThemeMode(
          themeModeHandler.themeMode,
          themeModeHandler.themeColor
              .copyWith(backgroundShowBackground: value));
    }
  }

  void onThemeShapeBackgroundChanged(List<BackgroundShape> value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (themeModeHandler != null) {
      await ThemeModeHandler.of(context)?.saveThemeMode(
          themeModeHandler.themeMode,
          themeModeHandler.themeColor.copyWith(backgroundSelectedIcons: value));
    }
  }

  void onThemeShowEffectsChanged(bool value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (themeModeHandler != null) {
      await ThemeModeHandler.of(context)?.saveThemeMode(
          themeModeHandler.themeMode,
          themeModeHandler.themeColor.copyWith(backgroundShowEffects: value));
    }
  }

  void onThemeSigmaYChanged(double? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor.copyWith(backgroundBlurSigmaY: value));
      }
    }
  }

  void onThemeModeChanged(ThemeMode? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)
            ?.saveThemeMode(value, themeModeHandler.themeColor);
      }
    }

    setState(() {
      if (value != null) {
        themeType = value;
      }
    });
  }

  void onThemeOpacityChanged(double value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (themeModeHandler != null) {
      await ThemeModeHandler.of(context)?.saveThemeMode(
          themeModeHandler.themeMode,
          themeModeHandler.themeColor.copyWith(backgroundOpacity: value));
    }

    /*setState(() {
      if (value != null) {
        themeType = value;

      }
    });*/
  }

/*  void onThemeImageChanged(int? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor.copyWith(backgroundImageIndex: value));
      }
    }

    */ /*setState(() {
      if (value != null) {
        themeColor = value;

      }
    });*/ /*
  }*/
  void onThemeBackgroundImageChanged(ResourceResponse? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (value != null) {
      selectedBackgroundName = value.name;
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor.copyWith(
                backgroundImage: value, backgroundImageName: value.name));
      }
    }

    /*setState(() {
      if (value != null) {
        themeColor = value;

      }
    });*/
  }

  void onThemeBlendModeChanged(BlendMode blendMode) async {
    var themeModeHandler = ThemeModeHandler.of(context);
    editState = true;

    if (themeModeHandler != null) {
      await ThemeModeHandler.of(context)?.saveThemeMode(
          themeModeHandler.themeMode,
          themeModeHandler.themeColor.copyWith(backgroundBlendMode: blendMode));
    }

    setState(() {
      selectedBlendMode = blendMode;
    });
  }

  void onThemeColorChanged(ThemeColors? value) async {
    editState = true;
    var themeModeHandler = ThemeModeHandler.of(context);

    if (value != null && value == ThemeColors.custom) {
      setState(() {
        themeColor = value;
      });
      if (themeModeHandler != null) {
        onThemeCustomColorChanged(
            themeModeHandler.themeColor.customColor ?? Colors.green.value);
      }

      await _selectColorPicker();
    } else {
      if (value != null) {
        if (themeModeHandler != null) {
          await ThemeModeHandler.of(context)?.saveThemeMode(
              themeModeHandler.themeMode,
              themeModeHandler.themeColor.copyWith(colorType: value));
        }
      }
    }

    setState(() {
      if (value != null) {
        themeColor = value;
      }
    });
  }

  void onThemeFilterColorChanged(ThemeFilterColors filterColors, int? value) async {
    selectedFilterColor = filterColors;
    //customFilterColor=value;
    editState = true;

    if (filterColors == ThemeFilterColors.custom) {
      setState(() {
        selectedFilterColor = filterColors;
      });
      onThemeFilterColorUpdate(ThemeFilterColors.custom, value);

      await _selectFilterColorPicker();
    } else {
      onThemeFilterColorUpdate(filterColors, value);
    }

    setState(() {
      if (value != null) {
        selectedFilterColor = filterColors;
      }
    });
  }

  void onThemeFilterColorUpdate(ThemeFilterColors filterColors, int? value) async {
    var themeModeHandler = ThemeModeHandler.of(context);

    if (value != null) {
      if (themeModeHandler != null) {
        await ThemeModeHandler.of(context)?.saveThemeMode(
            themeModeHandler.themeMode,
            themeModeHandler.themeColor.copyWith(
                backgroundFilterColors: filterColors,
                backgroundCustomFilterColor: value));
      }
    }
  }

  Widget imagePreview(int index) {
    if (backgroundImages != null) {
      return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.memory(backgroundImages![index].decodedContents!,
                        filterQuality: FilterQuality.medium,
                        fit: BoxFit.contain)
                    .image,
                /*Image.asset(assetsImages[index], fit: BoxFit.contain).image,*/
                fit: BoxFit.cover),
          ),
          child: ClipRRect(
              // make sure we apply clip it properly
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Center(
                      child: Stack(
                    children: [
                      /* Image.asset(assetsImages[index], fit: BoxFit.cover),*/
                      Image.memory(backgroundImages![index].decodedContents!,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium),
                      Positioned(
                        bottom: 20,
                        child: Container(
                            color: Colors.black.withAlpha(100),
                            child: Text(assetsImages[index])),
                      )
                    ],
                  )))));
    }
    return const SizedBox();
  }

  Widget imagePreviewFromResourceResponse(ResourceResponse response) {
    if (response.decodedContents != null) {
      return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image:
                Image.memory(response.decodedContents!,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium)
                    .image,
                /*Image.asset(assetsImages[index], fit: BoxFit.contain).image,*/
                fit: BoxFit.cover),
          ),
          child: ClipRRect(
              // make sure we apply clip it properly
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Center(
                      child: Stack(
                    children: [
                      /* Image.asset(assetsImages[index], fit: BoxFit.cover),*/
                      Image.memory(response.decodedContents!,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium),
                      Positioned(
                        bottom: 20,
                        child: Container(
                            color: Colors.black.withAlpha(100),
                            child: Text(response.name)),
                      )
                    ],
                  )))));
    }
    return const SizedBox();
  }

  /*Widget scaffold(
      {required Text title,
      required Widget child,
      double appBarHeight = 60,
      Color? backgroundColor}) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: appBarHeight,
                child: AppBar(
                    backgroundColor: isDarkTheme(context)
                        ? Color.alphaBlend(
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withAlpha(240),
                            Theme.of(context).colorScheme.primary)
                        : null,
                    shape: const CustomAppBarShape(),
                    title: title)),
          ),
          body: child),
    );
  }
*/
  int currentColor = 0;

  Future<void> _selectColorPicker() async {
    var themeModeHandler = ThemeModeHandler.of(context);
    currentColor =
        themeModeHandler?.themeColor.customColor ?? Colors.green.value;
    // raise the [showDialog] widget
    await showDialog(
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
                if (themeModeHandler != null) {
                  setState(() {
                    onThemeCustomColorChanged(color.value);
                  });
                }
              },
              onColorChanged: (color) {
                currentColor = color.value;
                if (themeModeHandler != null) {
                  setState(() {
                    onThemeCustomColorChanged(color.value);
                  });
                }
                /*setState(() {
                currentColor = color.value;
                ThemeModeHandler.of(context)?.saveThemeMode(mode, ThemeColor(colorType: ThemeColors.custom, customColor:  currentColor));
              });*/
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
  }

  void onThemeCustomColorChanged(int value) {
    var themeModeHandler = ThemeModeHandler.of(context);
    if (themeModeHandler != null) {
      ThemeModeHandler.of(context)?.saveThemeMode(
          themeModeHandler.themeMode,
          themeModeHandler.themeColor
              .copyWith(colorType: ThemeColors.custom, customColor: value));
    }
  }

  Future<void> _selectFilterColorPicker() async {
    var themeModeHandler = ThemeModeHandler.of(context);

    // raise the [showDialog] widget
    await showDialog(
      context: context,
      builder: (context) {
        return multiDialog(
          title: const Text('Seleziona un colore'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: Color(customFilterColor ?? 0),
              portraitOnly: true,
              enableLabel: false,
              onPrimaryChanged: (color) {
                customFilterColor = color.value;
                if (themeModeHandler != null) {
                  setState(() {
                    onThemeFilterColorUpdate(
                        ThemeFilterColors.custom, color.value);

                    /*ThemeModeHandler.of(context)?.saveThemeMode(
                        themeModeHandler.themeMode,
                        themeModeHandler.themeColor.copyWith(
                            backgroundFilterColors: ThemeFilterColors.custom,
                            backgroundCustomFilterColor: color.value));*/
                  });
                }
              },
              onColorChanged: (color) {
                customFilterColor = color.value;
                if (themeModeHandler != null) {
                  setState(() {
                    onThemeFilterColorUpdate(
                        ThemeFilterColors.custom, color.value);
                  });
                }
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
  }

  void validateSave() {
    Navigator.pop(context);
  }

  void resetState() {
    var themeModeHandler = ThemeModeHandler.of(context);
    themeModeHandler?.saveThemeMode(currentTheme![0], currentTheme![1]);
  }
}

/*Future selectTheme(context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return const ThemeSelect();
    },
  );
}*/

Future selectTheme(context) async {
  var formKey = GlobalKey<ThemeSelectState>(debugLabel: "ThemeSelectStateKey");
  var result = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return dialogScaffold(
            title: const Text("Seleziona tema"),
            form: MultiBlocProvider(providers: [
              BlocProvider<ResourceBloc>(
                lazy: false,
                create: (context) => ResourceBloc(),
              ),
            ], child: ThemeSelect(key: formKey)));
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}

Widget dialogScaffold({required Text title, required Widget form, double appBarHeight = 60}) {
  return WillPopScope(
    onWillPop: () async {
      if (form.key != null) {
/*var status = (form.key as GlobalKey<ReportEditFormState>)
                  .currentState
                  ?.editSummaryFormKey
                  ?.currentState
                  ?.compressStatus ??
              0;

          return status == 0 ? true : false;*/
        Key? key = form.key;

        if (key is GlobalKey<ThemeSelectState>) {
          var status = key.currentState?.editState ?? false;

          if (status) {
//on edit
            if (key.currentContext != null) {
              String? result = await exitScreen(key.currentContext!);
              if (result != null) {
                switch (result) {
                  case '0': //si
                    key.currentState?.validateSave();
                    break;
                  case '1': //no
                    if (key.currentContext != null) {
                      key.currentState?.resetState();
                      Navigator.of(key.currentContext!).pop();
                    }
                    break;
                  case '2': //annulla
                    break;
                }
              }
            }
          }

          ///se editState è true blocco l'uscita
          return !status;
        }
      }
      return true;
    },
    child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: appBarHeight,
              child: AppBar(
                  backgroundColor: isDarkTheme(navigatorKey!.currentContext!)
                      ? Color.alphaBlend(
                      Theme.of(navigatorKey!.currentContext!)
                          .colorScheme
                          .surface
                          .withAlpha(240),
                      Theme.of(navigatorKey!.currentContext!)
                          .colorScheme
                          .primary)
                      : null,
                  shape: const CustomAppBarShape(),
                  title: title)),
        ),
        body: form),
  );
}
