import 'package:dpicenter/screen/widgets/slider_drawer_multi/alignment.dart';
import 'package:dpicenter/screen/widgets/slider_drawer_multi/slider_drawer_multi.dart';
import 'package:flutter/material.dart';

import 'menu_item.dart';

class SlideDrawerContainer extends StatelessWidget {
  final Widget? drawer;
  final Widget? head;
  final Widget? content;
  final List<SliderMenuItem> items;
  final double paddingRight;

  /// The gradient to use for the background.
  ///
  /// If this property is null, then [background] is used.
  final Gradient? backgroundGradient;

  /// The color to use for the background. Typically this should be set
  /// along with [brightness].
  ///
  /// If this property is null, then [ThemeData.primaryColor] is used.
  final Color? backgroundColor;

  /// The brightness of the app bar's material. Typically this is set along
  /// with [backgroundColor], [backgroundGradient].
  ///
  /// If this property is null, then [ThemeData.primaryColorBrightness] is used.
  final Brightness? brightness;

  /// Vertical alignment of content inside [SlideDrawerContainer]
  /// it can [start] from the top, or [center]
  final SlideDrawerAlignment? alignment;

  bool get _hasItems => items.isNotEmpty;

  bool get _hasDrawer => drawer != null;

  bool get _hasHead => head != null;

  bool get _hasContent => content != null;

  bool get _hasGradient => backgroundGradient != null;

  const SlideDrawerContainer({
    Key? key,
    required this.drawer,
    this.head,
    this.content,
    this.items = const [],
    this.brightness,
    this.backgroundColor,
    this.backgroundGradient,
    this.alignment,
    this.paddingRight = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SlideDrawerAlignment? alignment;

    alignment ??=
        _hasHead ? SlideDrawerAlignment.start : SlideDrawerAlignment.center;

    bool isAlignTop = alignment == SlideDrawerAlignment.start;

    return Material(
      child: _hasDrawer
          ? drawer
          : Container(
              decoration: _hasGradient
                  ? BoxDecoration(gradient: backgroundGradient)
                  : BoxDecoration(color: backgroundColor ?? theme.primaryColor),
              child: SafeArea(
                child: Theme(
                  data: ThemeData(brightness: brightness ?? theme.brightness),
                  child: Column(
                    mainAxisAlignment: isAlignTop
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
/*if (_hasHead) head!,*/

                      if (_hasHead)
                        Flexible(
                          flex: 0,
                          child: Container(
                            //constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                            margin: EdgeInsets.only(
                                right: paddingRight < 0 ? 0 : paddingRight),
                            child: head,
                          ),
                        ),
                      if (_hasContent)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                right: paddingRight < 0 ? 0 : paddingRight),
                            child: content,
                          ),
                        ),
                      if (!_hasContent && _hasItems)
                        for (SliderMenuItem item in items)
                          Container(
                            margin: EdgeInsets.only(
                                right: paddingRight < 0 ? 0 : paddingRight),
                            child: MenuItemWidget(item: item),
                          ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
/*class SlideDrawerContainer extends StatelessWidget {
  final Widget? drawer;
  final Widget? head;
  final Widget? content;
  final List<SliderMenuItem> items;
  final double paddingRight;

  /// The gradient to use for the background.
  ///
  /// If this property is null, then [background] is used.
  final Gradient? backgroundGradient;

  /// The color to use for the background. Typically this should be set
  /// along with [brightness].
  ///
  /// If this property is null, then [ThemeData.primaryColor] is used.
  final Color? backgroundColor;

  /// The brightness of the app bar's material. Typically this is set along
  /// with [backgroundColor], [backgroundGradient].
  ///
  /// If this property is null, then [ThemeData.primaryColorBrightness] is used.
  final Brightness? brightness;

  /// Vertical alignment of content inside [SlideDrawerContainer]
  /// it can [start] from the top, or [center]
  final SlideDrawerAlignment? alignment;

  bool get _hasItems => items.isNotEmpty;
  bool get _hasDrawer => drawer != null;
  bool get _hasHead => head != null;
  bool get _hasContent => content != null;
  bool get _hasGradient => backgroundGradient != null;

  const SlideDrawerContainer({
    Key? key,
    required this.drawer,
    this.head,
    this.content,
    this.items = const [],
    this.brightness,
    this.backgroundColor,
    this.backgroundGradient,
    this.alignment,
    this.paddingRight = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SlideDrawerAlignment? _alignment = alignment;

    if (_alignment == null) {
      _alignment =
      _hasHead ? SlideDrawerAlignment.start : SlideDrawerAlignment.center;
    }

    bool _isAlignTop = _alignment == SlideDrawerAlignment.start;

    return Material(
      child: _hasDrawer
          ? drawer
          : Container(
        decoration: _hasGradient
            ? BoxDecoration(gradient: backgroundGradient)
            : BoxDecoration(color: backgroundColor ?? theme.primaryColor),
        child: SafeArea(
          child: Theme(
            data: ThemeData(
                brightness: brightness ?? theme.primaryColorBrightness),
            child: Column(
              mainAxisAlignment: _isAlignTop
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_hasHead) head!,
                if (_hasContent)
                  Container(
                    margin: EdgeInsets.only(right: paddingRight),
                    child: content,
                  ),
                if (!_hasContent && _hasItems)
                  for (SliderMenuItem item in items)
                    Container(
                      margin: EdgeInsets.only(right: paddingRight),
                      child: MenuItemWidget(item: item),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/

class MenuItemWidget extends StatelessWidget {
  final SliderMenuItem item;

  const MenuItemWidget({Key? key, required this.item}) : super(key: key);

  Widget? get _leading {
    if (item.hasLeading) return item.leading!;
    if (item.hasIcon) return Icon(item.icon);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _leading,
      contentPadding: EdgeInsets.only(left: _leading == null ? 24 : 16),
      title: Text(item.title),
      onTap: () {
        if (item.isCloseDrawerWhenTapped) {
          SlideDrawerMulti.of(context)?.close();
        }

        item.onTap?.call();
      },
    );
  }
}
