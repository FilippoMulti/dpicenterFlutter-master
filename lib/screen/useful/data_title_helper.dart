import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class TitleHelper {
  static Widget appBarTitle(String title, String subTitle, bool? offline) {
    if (subTitle.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Hero(
                    tag: '${title}Hero',
                    child: Material(
                        type: MaterialType.transparency, child: Text(title)),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(subTitle,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.start),
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                offline != null && offline ? "OFFLINE" : "",
                style: const TextStyle(color: Colors.red),
              )
            ],
          )
        ],
      );
    } else {
      return Hero(
          tag: '${title}Hero',
          child: Material(type: MaterialType.transparency, child: Text(title)));
    }
  }

  static AppBar getAppBar(
      {required String title,
      bool withBackButton = true,
      String? subTitle,
      bool? offline,
      String? icon,
      dynamic color,
      VoidCallback? titleClick,
      VoidCallback? printClick,
      VoidCallback? customBackClick,
      List<Widget>? actions,
      required BuildContext context}) {
    var mediaData = MediaQuery.of(context);

    List<Widget> items = <Widget>[];

    if (customBackClick != null && withBackButton) {
      items.add(IconButton(
          onPressed: customBackClick,
          icon: Icon(
            Icons.arrow_back,
            size: mediaData.size.height < tinyHeight ? 16 : 24,
          )));
      items.add(const SizedBox(width: 16));
    }

    Color? backgroundColor;
    if (isDarkTheme(context)) {
      backgroundColor = Color.alphaBlend(
          Theme.of(context).colorScheme.surface.withAlpha(240),
          Theme.of(context).colorScheme.primary);
    } else {
      backgroundColor = Theme.of(context).colorScheme.primary;
    }

    items.add(TitleHelper.listItem(
        title: title,
        direction: isTinyHeight(context) ? Axis.horizontal : Axis.vertical,
        subTitle: subTitle ?? '',
        offline: offline,
        titleFontSize: mediaData.size.height < tinyHeight ? 12 : 16,
        iconSize: mediaData.size.height < tinyHeight ? 16 : 22,
        icon: icon,
        color: color,
        titleClick: titleClick,
        subTitleFontSize: mediaData.size.height < tinyHeight ? 8 : 10,
        buttonHeight: mediaData.size.height < tinyHeight ? 30 : 40));

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(
        color: getBottomNavigatorBarForegroundColor(
            context), //change your color here
      ),
//automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      //shape: const CustomAppBarShape(),
      /*shape: const RoundedRectangleBorder(

          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),*/
/*
      backgroundColor: offline != null && offline
          ? Colors.black.withGreen(50)
          : Colors.green,
*/
      /*title: TitleHelper.appBarTitle(title, subTitle, offline),*/
      title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (withBackButton) items[0],
            Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: items.sublist(withBackButton ? 1 : 0))),
            ),
          ]),

      actions: actions,
      /*actions: [
        IconButton(
            onPressed: printClick,
            icon: Icon(
              Icons.print,
              size: mediaData.size.height < tinyHeight ? 16 : 24,
            )),
        const SizedBox(
          width: 16,
        )
      ],*/
    );
  }

/*  static Widget getListIteme(String title,
      String subTitle,
      bool? offline,
      double fontSize,
      double iconSize,
      dynamic icon,
      dynamic color,
      VoidCallback? titleClick) {
    return Hero(
      tag: '${title}Hero',
      transitionOnUserGestures: true,
      child: Material(
          type: MaterialType.transparency,
          child: IntrinsicWidth(
              child: ElevatedButton(
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: color,
                minimumSize: const Size(1, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
                onPressed: titleClick,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: iconSize,
                          color: Colors.white,
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                          child:
                              Text(title, style: TextStyle(fontSize: fontSize)),
                        ),
                            Align(
                              alignment: Alignment.centerLeft,
                          child: Text(subTitle,
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.start),
                        )
                          ],
                        ),
                      ),
                    ),
                    */ /*Column(
                        children: <Widget>[
                          Text(
                            offline != null && offline ? "OFFLINE" : "",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      )*/ /*
              ],
            ),
          ))),
    );
  }*/

  static Widget verticalLayout(String title, String? subTitle,
      double titleFontSize, double subTitleFontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        itemText(title, titleFontSize),
        if (subTitle != null) itemText(subTitle ?? '', subTitleFontSize)
      ],
    );
  }

  static Widget horizontalLayout(String title, String? subTitle,
      double titleFontSize, double subTitleFontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        itemText(title, titleFontSize),
        if (subTitle != null)
          const SizedBox(
            width: 16,
          ),
        if (subTitle != null) itemText(subTitle ?? '', subTitleFontSize)
      ],
    );
  }

  static itemText(String? text, double fontSize) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text ?? '',
          style: TextStyle(fontSize: fontSize), textAlign: TextAlign.start),
    );
  }

  static Widget listItem({
    required String title,
    Axis direction = Axis.vertical,
    String? subTitle,
    bool? offline,
    required double titleFontSize,
    required double subTitleFontSize,
    required double iconSize,
    required double buttonHeight,
    String? icon,
    Color? color,
    VoidCallback? titleClick,
    Color foregroundColor = Colors.white,
  }) {
/*    return Hero(
      tag: '${title}Hero',
      transitionOnUserGestures: true,
      child: Material(
          type: MaterialType.transparency,
          child: IntrinsicWidth(
              child: ElevatedButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: color,
                minimumSize: Size(1, buttonHeight),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
                onPressed: titleClick,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icons[icon],
                      size: iconSize,
                      color: Colors.white,
                    )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 2, 4),
                      child: direction == Axis.horizontal
                          ? horizontalLayout(
                              title, subTitle, titleFontSize, subTitleFontSize)
                          : verticalLayout(title, subTitle, titleFontSize,
                              subTitleFontSize)),
                    ),
                  ],
                ),
              ))),
    );*/
    return TitleWidget(
      title: title,
      direction: direction,
      subTitleFontSize: subTitleFontSize,
      subTitle: subTitle,
      offline: offline,
      titleFontSize: titleFontSize,
      titleClick: titleClick,
      icon: icon,
      color: color,
      buttonHeight: buttonHeight,
      iconSize: iconSize,
      foregroundColor: foregroundColor,
    );
  }
}
