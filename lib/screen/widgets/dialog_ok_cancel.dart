import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:flutter/material.dart';

class OkCancel extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final VoidCallback? onOptional;
  final String okText;
  final String cancelText;
  final double elevation;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final FocusNode? okFocusNode;
  final FocusNode? cancelFocusNode;
  final FocusNode? optionalFocusNode;
  final String optionalText;
  final Color? color;

  const OkCancel({
    Key? key,
    this.onSave,
    this.onCancel,
    this.onOptional,
    this.okText = 'SALVA',
    this.cancelText = 'ANNULLA',
    this.optionalText = 'SALVA COME NUOVO',
    this.elevation = 8,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(20), bottom: Radius.circular(2)),
    this.border,
    this.okFocusNode,
    this.cancelFocusNode,
    this.optionalFocusNode,
    this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => OkCancelState();
}

class OkCancelState extends State<OkCancel> {
  @override
  Widget build(BuildContext context) {
    return _okCancelContainer();
  }

  Widget _okCancelContainer() {
    MediaQueryData queryData = MediaQuery.of(context);
    return Material(
      elevation: widget.elevation,
      color: widget.color ??
          (isDarkTheme(context)
              ? Color.alphaBlend(
              Theme.of(context).colorScheme.background.withAlpha(240),
              Theme.of(context).colorScheme.primary)
              : Theme.of(context).colorScheme.surface),
      /*color: isDarkTheme(context)
          ? Color.alphaBlend(Theme.of(context).colorScheme.background.withAlpha(240), Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.surface,*/
      borderRadius: widget.borderRadius,
      clipBehavior: Clip.antiAlias,
      type: MaterialType.card,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            border: widget.border ??
                Border.all(color: Theme.of(context).dividerColor, width: 0.1),
          ),
          clipBehavior: Clip.antiAlias,
          height: queryData.size.height < tinyHeight ? 35 : 50,
          child: _okCancel()),
    );
  }

  Widget _okCancel() {
    return Center(
      child: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ElevatedButton(
              onPressed: widget.onCancel,
              focusNode: widget.cancelFocusNode,
              style: ElevatedButton.styleFrom(
                  primary: standardNoButtonBackgroundColor(context)),
              child: Text(
                widget.cancelText,
                style: TextStyle(
                  color: standardNoButtonTextColor(context),
                ),
              )),
          if (widget.onSave != null)
            ElevatedButton(
              onPressed: widget.onSave,
              focusNode: widget.okFocusNode,
              style: ElevatedButton.styleFrom(
                  primary: standardYesButtonBackgroundColor(context)),
              child: Text(
                widget.okText,
                style: TextStyle(
                  color: standardYesButtonTextColor(context),
                ),
              ),
            ),
          if (widget.onOptional != null)
            ElevatedButton(
              onPressed: widget.onOptional,
              focusNode: widget.optionalFocusNode,
              style: ElevatedButton.styleFrom(
                  primary: standardCustomButtonBackgroundColor(context)),

              /*isLightTheme(context)
                  ? ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onTertiary,
                  onPrimary: Theme.of(context).colorScheme.tertiary)
                  : ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary: Theme.of(context).colorScheme.onSecondary),*/
              child: Text(
                widget.optionalText,
                style: TextStyle(
                  color: standardCustomButtonTextColor(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
