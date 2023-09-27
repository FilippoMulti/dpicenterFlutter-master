import 'dart:convert';

import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:flutter/material.dart';

Widget getOperatorItem({
  required ApplicationUser user,
  required Function() selected,
  required Function(bool) onSelected,
  double? fontSize,
  double? letterSpacing,
  EdgeInsets? labelPadding,
  EdgeInsets? padding,
  FontWeight? fontWeight,
  VisualDensity? visualDensity,
  bool showLabel = true,
}) {
  try {
    var imageProvider = (user.userDetails != null &&
            user.userDetails!.isNotEmpty &&
            user.userDetails![0].image != null &&
            user.userDetails![0].imageProvider == null)
        ? Image.memory(base64Decode(user.userDetails![0].image!),
                filterQuality: FilterQuality.medium)
            .image
        : (user.userDetails != null &&
                user.userDetails!.isNotEmpty &&
                user.userDetails![0].image != null &&
                user.userDetails![0].imageProvider != null)
            ? user.userDetails![0].imageProvider
            : null;

    return FilterChip(
        visualDensity: visualDensity,
        labelPadding: labelPadding,
        padding: padding,
        avatar: CircleAvatar(
            backgroundColor: user.userDetails != null &&
                    user.userDetails!.isNotEmpty &&
                    user.userDetails![0].image != null
                ? null
                : Colors.red,
            backgroundImage: imageProvider,
            child: user.userDetails != null &&
                    user.userDetails!.isNotEmpty &&
                    user.userDetails![0].image != null
                ? null
                : const Icon(Icons.person, color: Colors.white)),
        backgroundColor:
        Theme.of(navigatorKey!.currentContext!).chipTheme.backgroundColor,
        selectedColor:
        Theme.of(navigatorKey!.currentContext!).colorScheme.primary,
        //Color(int.parse(tag.color!)),
        label: showLabel
            ? Text(
                user.userName!.isEmpty
                    ? 'ESEMPIO'
                    : '${user.name!.toUpperCase()} ${user.surname!.toUpperCase()}',
                overflow: TextOverflow.ellipsis,
                style: operatorTextStyle(
                    fontSize: fontSize,
                    letterSpacing: letterSpacing,
                    fontWeight: fontWeight),
              )
            : const SizedBox(),
        selected: selected.call(),
        showCheckmark: false,
        //selectedColor: Color(int.parse(tag.color!)).lighten(),
        onSelected: onSelected);
  } catch (e) {
    return Text(e.toString());
  }
}

Widget getOperatorAvatar({
  required ApplicationUser user,
  double? maxRadius,
  double? iconSize,
  Color? iconColor,
  Color? backgroundColor,
}) {
  try {
    var imageProvider = (user.userDetails != null &&
            user.userDetails!.isNotEmpty &&
            user.userDetails![0].image != null &&
            user.userDetails![0].imageProvider == null)
        ? Image.memory(base64Decode(user.userDetails![0].image!),
                filterQuality: FilterQuality.medium)
            .image
        : (user.userDetails != null &&
                user.userDetails!.isNotEmpty &&
                user.userDetails![0].image != null &&
                user.userDetails![0].imageProvider != null)
            ? user.userDetails![0].imageProvider
            : null;

    return CircleAvatar(
      maxRadius: maxRadius,
      backgroundColor: user.userDetails != null &&
              user.userDetails!.isNotEmpty &&
              user.userDetails![0].image != null
          ? null
          : backgroundColor ?? Colors.red,
      backgroundImage: imageProvider,
      child: user.userDetails != null &&
              user.userDetails!.isNotEmpty &&
              user.userDetails![0].image != null
          ? null
          : Icon(
              Icons.person,
              color: iconColor ?? Colors.white,
              size: iconSize,
            ),
    );
  } catch (e) {
    return Text(e.toString());
  }
}

TextStyle operatorTextStyle(
    {double? fontSize, double? letterSpacing, FontWeight? fontWeight}) {
  return TextStyle(
    fontSize: fontSize,
    letterSpacing: letterSpacing,
    fontWeight:
        fontWeight, /* color: tagColor.computeLuminance() > 0.5 ? Colors.black : Colors.white*/
  );
}
