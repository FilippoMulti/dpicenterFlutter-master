import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/hashtag.dart';
import 'package:flutter/material.dart';

Widget getHashTagItem(
    {required HashTag tag,
    required Function() selected,
    required Function(bool) onSelected,
    double? fontSize,
    double? letterSpacing,
    EdgeInsets? labelPadding,
    EdgeInsets? padding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    FontWeight? fontWeight,
    VisualDensity? visualDensity,
    Key? key}) {
  try {
    return Theme(
      data: Theme.of(navigationScreenKey!.currentState!.context)
          .copyWith(canvasColor: Colors.transparent),
      child: FilterChip(
          //padding: EdgeInsets.zero,
          side: BorderSide(color: Color(int.parse(tag.color!))),
          key: key,
          visualDensity: visualDensity,
          labelPadding:
              labelPadding ?? const EdgeInsets.symmetric(horizontal: 0),
          padding: EdgeInsets.zero,
          backgroundColor:
              isDarkTheme(navigationScreenKey!.currentState!.context)
                  ? Color(int.parse(tag.color!)).withAlpha(80)
                  : Color(int.parse(tag.color!)).withAlpha(130),
          label: Padding(
            padding: padding!,
            child: Stack(children: [
              Text(tag.name!.isEmpty ? 'ESEMPIO' : tag.name!.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: hashTagTextStyleStandardStroke(
                      Color(int.parse(tag.color!)),
                      fontSize: fontSize,
                      letterSpacing: letterSpacing,
                      fontWeight: fontWeight)),
              Text(tag.name!.isEmpty ? 'ESEMPIO' : tag.name!.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: hashTagTextStyleStandard(Color(int.parse(tag.color!)),
                      fontSize: fontSize,
                      letterSpacing: letterSpacing,
                      fontWeight: fontWeight)),
            ]),
          ),
          showCheckmark: false,
          selected: selected.call(),
          selectedColor: Color(int.parse(tag.color!)).lighten(),
          onSelected: onSelected),
    );
  } catch (e) {
    return Text(e.toString());
  }
}

TextStyle hashTagTextStyleStandard(Color tagColor,
    {double? fontSize, double? letterSpacing, FontWeight? fontWeight}) {
  return TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      color: isDarkTheme(navigatorKey!.currentContext!)
          ? Colors.white
          : Colors.black
      //color: tagColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      );
}

TextStyle hashTagTextStyleStandardStroke(Color tagColor,
    {double? fontSize,
    double? letterSpacing,
    FontWeight? fontWeight,
    double strokeWidth = 1}) {
  return TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = tagColor);
}

TextStyle hashTagTextStyle(Color tagColor,
    {double? fontSize, double? letterSpacing, FontWeight? fontWeight}) {
  return TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      color: tagColor.computeLuminance() > 0.5
          ? Color.alphaBlend(tagColor.withAlpha(0), Colors.black)
          : Color.alphaBlend(tagColor.withAlpha(0), Colors.white));
}

Widget getHashTagItemStandard(
    {required HashTag tag,
    required Function() selected,
    required Function(bool) onSelected,
    double? fontSize,
    double? letterSpacing,
    EdgeInsets? labelPadding,
    EdgeInsets? padding = EdgeInsets.zero,
    FontWeight? fontWeight,
    VisualDensity? visualDensity,
    Key? key}) {
  try {
    return FilterChip(
        //padding: EdgeInsets.zero,

        key: key,
        visualDensity: visualDensity,
        labelPadding: labelPadding,
        padding: EdgeInsets.zero,
        backgroundColor: Color(int.parse(tag.color!)),
        label: Padding(
          padding: padding!,
          child: Text(tag.name!.isEmpty ? 'ESEMPIO' : tag.name!.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: hashTagTextStyle(Color(int.parse(tag.color!)),
                  fontSize: fontSize,
                  letterSpacing: letterSpacing,
                  fontWeight: fontWeight)),
        ),
        selected: selected.call(),
        selectedColor: Color(int.parse(tag.color!)).lighten(),
        onSelected: onSelected);
  } catch (e) {
    return Text(e.toString());
  }
}