import 'package:dpicenter/blocs/resource_bloc.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/image_select.dart';
import 'package:dpicenter/theme_manager/theme_select.dart';
import 'package:dpicenter/theme_manager/theme_color.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ThemeModeOption {
  final String label;
  final ThemeMode value;
  final ThemeColor color;

  const ThemeModeOption(this.label, this.value, this.color);
}

const _themeModeOptions = [
  ThemeModeOption(
      'Sistema', ThemeMode.system, ThemeColor(colorType: ThemeColors.green)),
  ThemeModeOption(
      'Chiaro', ThemeMode.light, ThemeColor(colorType: ThemeColors.green)),
  ThemeModeOption(
      'Scuro', ThemeMode.dark, ThemeColor(colorType: ThemeColors.green)),
  ThemeModeOption(
      'Rosso chiaro', ThemeMode.light, ThemeColor(colorType: ThemeColors.red)),
  ThemeModeOption(
      'Rosso scuro', ThemeMode.dark, ThemeColor(colorType: ThemeColors.red)),
  ThemeModeOption(
      'Blu chiaro', ThemeMode.light, ThemeColor(colorType: ThemeColors.blue)),
  ThemeModeOption(
      'Blu scuro', ThemeMode.dark, ThemeColor(colorType: ThemeColors.blue)),
];

/// A `SimpleDialog` with `ThemeMode.values` as options.
class ThemePickerDialog extends StatefulWidget {
  final int startColor;

  /// Creates a `ThemePickerDialog`.
  const ThemePickerDialog({Key? key, required this.startColor})
      : super(key: key);

  @override
  ThemePickerDialogState createState() => ThemePickerDialogState();
}

class ThemePickerDialogState extends State<ThemePickerDialog> {
  late int currentColor = widget.startColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        backgroundColor: isDarkTheme(navigatorKey!.currentContext!)
            ? Color.alphaBlend(
            Theme.of(navigatorKey!.currentContext!)
                .colorScheme
                .surface
                .withAlpha(240),
            Theme.of(navigatorKey!.currentContext!).colorScheme.primary)
            : Theme.of(navigatorKey!.currentContext!).colorScheme.surface,
        title: const Text('Seleziona un tema'),
        children: [
          ..._themeModeOptions.map((option) {
            return SimpleDialogOption(
              onPressed: () =>
                  _saveThemeMode(context, option.value, option.color),
              child: Text(option.label),
            );
          }).toList(),
          SimpleDialogOption(
              onPressed: () {
                _selectColorPicker(ThemeMode.light);
              },
              child: const Text('Custom chiaro')),
          SimpleDialogOption(
              onPressed: () {
                _selectColorPicker(ThemeMode.dark);
              },
              child: const Text('Custom scuro')),
          SimpleDialogOption(
              onPressed: () async {
                await _selectImages();
                _update(context);
              },
              child: const Text('Seleziona immagine')),
          SimpleDialogOption(
              onPressed: () async {
                await _selectTheme();
                _update(context);
              },
              child: const Text('Seleziona tema [NEW]'))
        ]);
  }

  Future _selectImages() async {
    // raise the [showDialog] widget
    await showDialog(
      context: context,
      builder: (context) {
        return const ImageSelect();
      },
    );
  }

  Future _selectTheme() async {
    await showDialog(
      context: context,
      builder: (context) {
        return MultiBlocProvider(providers: [
          BlocProvider<ResourceBloc>(
            lazy: false,
            create: (context) => ResourceBloc(),
          ),
        ], child: const ThemeSelect());
      },
    );
  }

/*  Widget imagePreview(int index) {
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.memory(_compressingImages![index].bytes!,
                  fit: BoxFit.contain)
                  .image,
              fit: BoxFit.cover),
        ),
        child: ClipRRect(
          // make sure we apply clip it properly
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    body: Center(
                        child: Image.asset(_compressingImages![index].bytes!,
                            fit: BoxFit.cover))))));
  }*/
  void _selectColorPicker(ThemeMode mode) {
    // raise the [showDialog] widget
    showDialog(
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
                setState(() {
                  currentColor = color.value;
                  ThemeModeHandler.of(context)?.saveThemeMode(
                      mode,
                      ThemeColor(
                          colorType: ThemeColors.custom,
                          customColor: currentColor));
                });
              },
              onColorChanged: (color) {
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
}

///salvataggio del tema
void _saveThemeMode(BuildContext context, ThemeMode value, ThemeColor color) async {
  await ThemeModeHandler.of(context)?.saveThemeMode(value, color);

  //Navigator.pop(context, value);
}

void _update(BuildContext context) {
  ThemeModeHandler.of(context)?.update();
}

///Selezione del tema dall'esterno della classe
Future<ThemeMode?> selectThemeMode(BuildContext context, int currentColor, Key key) async {
  return await showThemePickerDialog(
      context: context, currentColor: currentColor, key: key);
  //print(newThemeMode);
}

Widget getThemeChangeIconButton(BuildContext context) {
  return IconButton(
    padding: const EdgeInsets.all(16),
    icon: Icon(Icons.brightness_4,
        color: getBottomNavigatorBarForegroundColor(context)),
    tooltip: 'Seleziona tema',
    onPressed: () async {
      // handle the press
      //_connectToMessageHub();
      //selectThemeMode(context, Colors.green.value, const ValueKey('10003'));
      await selectTheme(context);
    },
  );
}

/// Displays a `SimpleDialog` with `ThemeMode.values` as options.
Future<ThemeMode?> showThemePickerDialog({required BuildContext context,
  required int currentColor,
  Key? key}) async {
  var result = await showDialog(
    context: context,
    builder: (_) => ThemePickerDialog(
      key: key,
      startColor: currentColor,
    ),
  ).then((value) => value is ThemeMode ? value : null);

  return result;
}
