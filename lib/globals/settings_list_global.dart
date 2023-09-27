import 'dart:ui';

import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/screen/widgets/image_loader/image_loader.dart';
import 'package:dpicenter/screen/widgets/text_input_dialog/text_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:reorderables/reorderables.dart';
import 'package:settings_ui/settings_ui.dart';

const lightTileDescriptionTextColor = Color.fromARGB(255, 70, 70, 70);
const darkTileDescriptionTextColor = Color.fromARGB(154, 160, 166, 198);

Future<String?> displayUpDownInputDialog(BuildContext context,
    {String? title,
      String? hint,
      required String initialValue,
      double min = 1,
      double max = 100,
      double step = 1,
      double acceleration = 1,
      int decimals = 0,
      Function(dynamic)? onChanged,
      TextEditingController? controller}) async {
  debugPrint(
      "controller ${controller != null ? "exist" : "is null and will be created"}");
  bool toDispose = controller == null;
  controller ??= TextEditingController(text: initialValue);
  controller.text = initialValue;

  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? ''),
          content: SpinBox(
            max: max,
            min: min,
            decimals: decimals,
            acceleration: acceleration,
            step: step,
            value: double.parse(
                (controller?.text != null && controller!.text.isNotEmpty)
                    ? controller!.text
                    : '0.0'),
            //focusNode: _vmcWidthFocusNode,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              controller?.text = value.toString();
              onChanged?.call(value);
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
                Navigator.of(context).pop(null);
              },
              child: Text(
                'ANNULLA',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  String? result = controller?.text;
                  Navigator.of(context).pop(result);
                },
                child: const Text('SALVA')),
          ],
        );
      }).then((value) {
    debugPrint(
        "controller ${toDispose ? "will be disposed: toDispose=true" : "will not be disposed: toDispose=false"}");
    if (toDispose) {
      controller?.dispose();
    }
    return value;
  });
}

InputDecoration _upDownInputDecoration({String? labelText, String? hintText}) {
  return textFieldInputDecoration(labelText: labelText, hintText: hintText);
}

SettingsTile getUpDownSettingTile({
  Key? key,
  String? title,
  String? hint,
  required String initialValue,
  TextEditingController? controller,
  double min = 1,
  double max = 100,
  double step = 1,
  Function(String? result)? onResult,
  int quarterTurns = 0,
  Widget? icon,
  String? description,
  int decimals = 0,
  bool enabled = true,
  bool readOnly = false,
}) {
  return SettingsTile.navigation(
    key: key,
    enabled: enabled,
    onPressed: (context) async {
      if (!readOnly) {
        String? result = await displayUpDownInputDialog(context,
            controller: controller,
            title: title,
            hint: hint,
            initialValue: initialValue,
            decimals: decimals,
            min: min,
            step: step,
            max: max);
        onResult?.call(result);
      }
    },
    leading: RotatedBox(
      quarterTurns: quarterTurns,
      child: icon,
    ),
    title: Text(title ?? ''),
    value: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) Text(description, style: itemSubtitleStyle()),
        if (description != null)
          const SizedBox(
            height: 8,
          ),
        Text(initialValue, style: itemValueTextStyle()),
      ],
    ),
  );
}

Widget itemData(String content,
    {String? label, TextStyle? labelTextStyle, TextStyle? contentTextStyle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null)
        const SizedBox(
          height: 8,
        ),
      if (label != null)
        Text("$label:",
            style:
            labelTextStyle ?? itemValueTextStyle().copyWith(fontSize: 12)),
      Text(content, style: contentTextStyle ?? itemValueTextStyle()),
    ],
  );
}

Widget itemDataCustom(Widget child,
    {String? label, TextStyle? labelTextStyle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null)
        const SizedBox(
          height: 8,
        ),
      if (label != null)
        Text("$label:",
            style:
            labelTextStyle ?? itemValueTextStyle().copyWith(fontSize: 12)),
      child,
    ],
  );
}

TextStyle itemValueTextStyle({BuildContext? context}) {
  context ??= navigationScreenKey?.currentContext;
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: isTinyWidth(navigatorKey!.currentContext!) ? 20 : 24,
      color: getTextColor(context: context));
}

Color getTextColor({BuildContext? context}) {
  context ??= navigationScreenKey?.currentContext;
  return Color.alphaBlend(
      isDarkTheme(context)
          ? Colors.white.withAlpha(150)
          : Colors.black.withAlpha(150),
      context != null ? Theme.of(context).colorScheme.primary : Colors.green);
}

SettingsTile getImagesSettingTile({String? title,
  String? description,
  Widget? icon,
  String? hint,
  required GlobalKey<ImageLoaderState> loaderKey,
  required List<ItemPicture> itemPictures,
  required Function(List<ItemPicture> value) onChanged,
  required Function(List<ItemPicture> value) onLoaded,
  bool enabled = true,
  bool readOnly = false}) {
  return SettingsTile.navigation(
    enabled: enabled,
    onPressed: null,
    leading: icon,
    title: Text(hint ?? ''),
    value: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) Text(description, style: itemSubtitleStyle()),
        if (description != null)
          const SizedBox(
            height: 8,
          ),
        ImageLoader(
          key: loaderKey,
          itemPictures: itemPictures,
          //sampleItemConfig?[1],
          onChanged: onChanged,
          onLoaded: onLoaded,
        ),
      ],
    ),
  );
}

SettingsTile getSelectionSettingTile({
  String? title,
  String? description,
  Widget? icon,
  final Icon? currentValueIcon,
  String? hint,
  required String initialValue,
  required List<Widget> children,
  TextEditingController? controller,
  Key? key,
  bool enabled = true,
  bool readOnly = false,
}) {
  return SettingsTile.navigation(
    key: key,
    enabled: enabled,
    onPressed: (context) async {
      if (!readOnly) {
        await displaySelectionDialog(context, title ?? '', hint ?? '',
            initialValue, children, controller);
      }
    },
    leading: icon,
    title: Text(hint ?? ''),
    value: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) Text(description, style: itemSubtitleStyle()),
        if (description != null)
          const SizedBox(
            height: 8,
          ),
        Row(
          children: [
            if (currentValueIcon != null) currentValueIcon,
            if (currentValueIcon != null)
              const SizedBox(
                width: 16,
              ),
            Text(
              initialValue,
              style: itemValueTextStyle(),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> displaySelectionDialog(BuildContext context,
    String title,
    String hint,
    String initialValue,
    List<Widget> children,
    TextEditingController? controller) async {
  bool toDispose = controller == null;
  controller ??= TextEditingController(text: initialValue);
  controller.text = initialValue;

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
      }).then((item) {
    //controller?.text=item.value;
    if (toDispose) {
      controller?.dispose();
    }
  });
}

SettingsTile getSwitchSettingTile({Key? key,
  required String title,
  required bool? initialValue,
  Widget? icon,
  String? description,
  required String textWhenTrue,
  required String textWhenFalse,
  Color? defaultTextColor,
  Function(bool value)? onToggle,
  bool enabled = true,
  bool readOnly = false,
  Widget? confirmIcon}) {
  return SettingsTile.switchTile(
    key: key,
    onToggle: (value) {
      if (!readOnly) {
        onToggle?.call(value);
      }
    },
    initialValue: initialValue,
    leading: icon,
    enabled: enabled,
    title: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              if (description != null)
                DefaultTextStyle(
                  style: itemSubtitleStyle()!,
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
                style: itemValueTextStyle(),
              ),
            ],
          ),
        ),

        if (confirmIcon != null) SizedBox.square(
            dimension: 64, child: confirmIcon),
      ],
    ),
  );
}

Future<String?> displayTextInputDialog({required BuildContext context,
  required String title,
  String? hint,
  required String initialValue,
  TextEditingController? controller,
  List<TextInputFormatter>? inputFormatters}) async {
  /*bool toDispose = controller == null;
  controller ??= TextEditingController(text: initialValue);
  controller.text = initialValue;*/
  GlobalKey<TextInputDialogState> textInputDialogKey =
  GlobalKey(debugLabel: '_textInputDialogKey');

  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextInputDialog(
            key: textInputDialogKey,
            title: title,
            initialValue: initialValue,
            hint: hint,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: standardNoButtonBackgroundColor(context)),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text(
                'ANNULLA',
                style: TextStyle(color: standardNoButtonTextColor(context)),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: standardYesButtonBackgroundColor(context)),
                onPressed: () {
                  String? result =
                      textInputDialogKey.currentState?.currentValue ?? '';

                  Navigator.of(context).pop(result);
                },
                child: Text(
                  'SALVA',
                  style: TextStyle(color: standardYesButtonTextColor(context)),
                )),
          ],
        );
      });
}

SettingsTile getCustomSettingTile({
  Key? key,
  String? title,
  String? description,
  Widget? icon,
  Widget? titleWidget,
  String? hint,
  required Widget child,
  bool enabled = true,
  bool readOnly = false,
  Function(BuildContext context)? onPressed,
  Function(BuildContext context)? onDoublePressed,
  Function(BuildContext context)? onLongPress,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  Color? color,
}) {
  return SettingsTile.navigation(
    key: key,
    enabled: enabled,
    onPressed: onPressed,
    onDoublePressed: onDoublePressed,
    onLongPress: onLongPress,
    leading: icon,
    color: color,
    title: titleWidget ?? (hint != null ? Text(hint) : null),
    value: Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (description != null) Text(description, style: itemSubtitleStyle()),
        if (description != null)
          const SizedBox(
            height: 8,
          ),
        child,
      ],
    ),
  );
}

TextStyle? itemSubtitleStyle() {
  return isLightTheme(navigatorKey!.currentContext!)
      ? Theme.of(navigatorKey!.currentContext!).textTheme.bodySmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black.withAlpha(180))
      : Theme.of(navigatorKey!.currentContext!).textTheme.bodySmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.white.withAlpha(180));
}

TextStyle? itemTitleStyle() {
  return isLightTheme(navigatorKey!.currentContext!)
      ? Theme.of(navigatorKey!.currentContext!)
      .textTheme
      .headlineSmall
      ?.copyWith(
    //fontSize: 14,
    //fontWeight: FontWeight.w300,
      color: Colors.black.withAlpha(180))
      : Theme.of(navigatorKey!.currentContext!)
      .textTheme
      .headlineSmall
      ?.copyWith(
    //fontSize: 14,
    //fontWeight: FontWeight.w300,
      color: Colors.white.withAlpha(180));
}

TextStyle? itemMiniSubtitleStyle() {
  return isLightTheme(navigatorKey!.currentContext!)
      ? Theme.of(navigatorKey!.currentContext!).textTheme.bodySmall?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.black.withAlpha(180))
      : Theme.of(navigatorKey!.currentContext!).textTheme.bodySmall?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.white.withAlpha(180));
}

TextStyle? itemMiniSubtitle2Style() {
  return isLightTheme(navigatorKey!.currentContext!)
      ? Theme.of(navigatorKey!.currentContext!).textTheme.bodySmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: Colors.black.withAlpha(180))
      : Theme.of(navigatorKey!.currentContext!).textTheme.bodySmall?.copyWith(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
          color: Colors.white.withAlpha(180));
}

SettingsTile getTextInputSettingTile({
  bool enabled = true,
  bool readOnly = false,
  String? title,
  String? hint,
  required String initialValue,
  TextEditingController? controller,
  Function(String? result)? onResult,
  int quarterTurns = 0,
  Widget? icon,
  String? description,
  Key? key,
}) {
  return SettingsTile.navigation(
    key: key,
    enabled: enabled,
    onPressed: (context) async {
      if (!readOnly) {
        String? result = await displayTextInputDialog(
            context: context,
            title: title ?? '',
            hint: hint,
            initialValue: initialValue);
        onResult?.call(result);
      }
    },
    leading: RotatedBox(quarterTurns: quarterTurns, child: icon),
    title: Text(title ?? ''),
    value: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) Text(description, style: itemSubtitleStyle()),
        if (description != null)
          const SizedBox(
            height: 8,
          ),
        Text(initialValue, style: itemValueTextStyle()),
      ],
    ),
  );
}

Widget getSettingItem(VmcSettingField item,
    {BuildContext? context,
      bool showClearButton = false,
      VoidCallback? onClearButtonPressed,
      bool dense = false}) {
  context ??= navigatorKey!.currentContext!;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
    child: Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme
              .of(context)
              .primaryColor
              .withAlpha(50)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category?.name ?? '',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall,
                ),
                if (!dense)
                  Text(item.name!, style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge),
                if (dense)
                  Text(item.name!, style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall),
              ],
            ),
          ),
          if (showClearButton)
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, color: Theme
                  .of(context)
                  .colorScheme
                  .error),
              onPressed: onClearButtonPressed,
            )
        ],
      ),
    ),
  );
}

Widget getProductionItem(VmcProductionField item,
    {BuildContext? context,
    bool showClearButton = false,
    VoidCallback? onClearButtonPressed,
    bool dense = false}) {
  context ??= navigatorKey!.currentContext!;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
    child: Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor.withAlpha(50)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category?.name ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (!dense)
                  Text(item.name!,
                      style: Theme.of(context).textTheme.titleLarge),
                if (dense)
                  Text(item.name!,
                      style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
          if (showClearButton)
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              icon:
                  Icon(Icons.close, color: Theme.of(context).colorScheme.error),
              onPressed: onClearButtonPressed,
            )
        ],
      ),
    ),
  );
}

Widget getMachineSettingItem(MachineSetting item,
    {BuildContext? context,
      bool showClearButton = false,
      VoidCallback? onClearButtonPressed}) {
  context ??= navigatorKey!.currentContext!;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
    child: Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor.withAlpha(50)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.categoryName ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: -0.5, wordSpacing: -1, fontSize: 12),
                ),
                Text(item.name!,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontSize: 16, letterSpacing: -0.5, wordSpacing: -1)),
              ],
            ),
          ),
          if (showClearButton)
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close),
              onPressed: onClearButtonPressed,
            )
        ],
      ),
    ),
  );
}

SettingsThemeData getSettingsDarkTheme(BuildContext context,
    {Color? settingsListBackground}) {
  return SettingsThemeData(
    settingsListBackground: settingsListBackground ??
        (isDarkTheme(context)
            ? Color.alphaBlend(
            Theme.of(context).colorScheme.surface.withAlpha(240),
            Theme.of(context).colorScheme.primary)
            : Theme.of(context).colorScheme.surface),
  );
}

SettingsThemeData getSettingsLightTheme(BuildContext context) {
  return const SettingsThemeData(settingsListBackground: Colors.transparent);
}

Widget getMachineProductionItem(MachineProduction item,
    {BuildContext? context,
      bool showClearButton = false,
      VoidCallback? onClearButtonPressed}) {
  context ??= navigatorKey!.currentContext!;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
    child: Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor.withAlpha(50)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.categoryName ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: -0.5, wordSpacing: -1, fontSize: 12),
                ),
                Text(item.name!,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontSize: 16, letterSpacing: -0.5, wordSpacing: -1)),
              ],
            ),
          ),
          if (showClearButton)
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close),
              onPressed: onClearButtonPressed,
            )
        ],
      ),
    ),
  );
}