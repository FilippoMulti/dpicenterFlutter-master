import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/changelog/change_log_screen.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:flutter/material.dart';

List<dynamic> getIconAndFontSize(BuildContext context) {
  double fontSize = 18;
  double iconSize = 24;
  var queryData = MediaQuery.of(context);
  if (queryData.size.width >= 300) {
    fontSize = 28;
    iconSize = 32;
  }

  if (queryData.size.width >= 400) {
    fontSize = 18;
    iconSize = 24;
  }

  if (queryData.size.width >= 450) {
    fontSize = 26;
    iconSize = 32;
  }

  if (queryData.size.width >= 500) {
    fontSize = 28;
    iconSize = 36;
  }
  if (queryData.size.width >= 800) {
    fontSize = 18;
    iconSize = 24;
  }
  if (queryData.size.width >= 900) {
    fontSize = 22;
    iconSize = 32;
  }
  if (queryData.size.width >= 1000) {
    fontSize = 28;
    iconSize = 36;
  }
  if (queryData.size.width >= 1100) {
    fontSize = 32;
    iconSize = 48;
  }
  if (queryData.size.width >= 1200) {
    fontSize = 18;
    iconSize = 24;
  }
  if (queryData.size.width >= 1300) {
    fontSize = 22;
    iconSize = 28;
  }
  if (queryData.size.width >= 1400) {
    fontSize = 28;
    iconSize = 32;
  }
  if (queryData.size.width >= 1500) {
    fontSize = 32;
    iconSize = 36;
  }

  if (queryData.size.width > 1800) {
    fontSize = 48;
    iconSize = 56;
  }

  if (queryData.size.width > 2400) {
    fontSize = 64;
  }
  return [iconSize, fontSize];
}

double getFontSize(BuildContext context) {
  var queryData = MediaQuery.of(context);

  if (queryData.size.width >= 2000) {
    return 20;
    //10
  }

  if (queryData.size.width >= 1600) {
    return 18;
    //8
  }

  if (queryData.size.width >= 1200) {
    return 18;
    //6
  }
  if (queryData.size.width >= 800) {
    return 16;
    //4
  }
  if (queryData.size.width >= 600) {
    return 14;
    //3
  }
  if (queryData.size.width >= 400) {
    return 14;
    //2
  }

  //1
  return 20;
}

List<dynamic> getDashboardIconAndFontSize(BuildContext context) {
  double fontSize = 10;
  double iconSize = 16;
  var queryData = MediaQuery.of(context);
  if (queryData.size.width >= 400) {
    fontSize = 11;
    iconSize = 16;
  }

  if (queryData.size.width >= 800) {
    fontSize = 12;
    iconSize = 24;
  }

  if (queryData.size.width >= 1200) {
    fontSize = 14;
    iconSize = 24;
  }

  if (queryData.size.width >= 1600) {
    fontSize = 16;
    iconSize = 32;
  }
  if (queryData.size.width >= 2000) {
    fontSize = 18;
    iconSize = 36;
  }

  return [iconSize, fontSize];
}

int getCrossAxisCount(BuildContext context) {
  var queryData = MediaQuery.of(context);

  if (queryData.size.width >= 2000) {
    return 10;
  }

  if (queryData.size.width >= 1600) {
    return 8;
  }

  if (queryData.size.width >= 1200) {
    return 6;
  }
  if (queryData.size.width >= 800) {
    return 4;
  }
  if (queryData.size.width >= 600) {
    return 3;
  }
  if (queryData.size.width >= 400) {
    return 2;
  }

  return 1;
}

double getAppBarHeightForWeb(BuildContext context) {
  var queryData = MediaQuery.of(context);
  if (queryData.size.height >= tinyHeight && queryData.size.width > midWidth) {
    return 60;
  }
  if (queryData.size.height >= tinyHeight && queryData.size.width <= midWidth) {
    return 60;
  }
  if (queryData.size.height >= tinyHeight && queryData.size.width < tinyWidth) {
    return 60;
  }

  return 40;
}

double getAppBarHeight(BuildContext context) {
  var queryData = MediaQuery.of(context);
  var themeModeHandler = ThemeModeHandler.of(context);
  if (themeModeHandler?.themeColor.menuType == 0) {
    if (queryData.size.height >= tinyHeight &&
        queryData.size.width > midWidth) {
      return 111;
    }
    if (queryData.size.height >= tinyHeight &&
        queryData.size.width <= midWidth) {
      return 111;
    }
    if (queryData.size.height >= tinyHeight &&
        queryData.size.width < tinyWidth) {
      return 111;
    }

    return 111;
  } else {
    return 60;
  }
}

double getActionButtonsHeight(BuildContext context) {
  var queryData = MediaQuery.of(context);
  if (queryData.size.height >= tinyHeight) {
    return 45;
  }
  if (queryData.size.height >= tinyHeight * 2) {
    return 45;
  }
  if (queryData.size.height >= tinyHeight * 3) {
    return 45;
  }

  return 30;
}

double getActionButtonsIconSize(BuildContext context) {
  var queryData = MediaQuery.of(context);
  if (queryData.size.height >= tinyHeight) {
    return 24;
  }
  if (queryData.size.height >= tinyHeight * 2) {
    return 24;
  }
  if (queryData.size.height >= tinyHeight * 3) {
    return 24;
  }

  return 16;
}

double getDashboardPadding(BuildContext context) {
  var queryData = MediaQuery.of(context);
  if (queryData.size.width >= 400) {
    return 16;
  }
  if (queryData.size.width >= 800) {
    return 16;
  }
  if (queryData.size.width >= 1200) {
    return 16;
  }

  return 8;
}

double getDashboardHeight(BuildContext context) {
  double height = 100;
  var queryData = MediaQuery.of(context);

  if (queryData.size.width >= 400) {
    height = 125;
  }

  if (queryData.size.width >= 800) {
    height = 135;
  }

  if (queryData.size.width >= 1200) {
    height = 145;
  }

  if (queryData.size.width >= 1600) {
    height = 155;
  }
  if (queryData.size.width >= 2000) {
    height = 165;
  }

  return height;
}

List<double> getDialogMargin(BuildContext context) {
  double marginWidth = 200;
  double marginHeight = 200;

  var queryData = MediaQuery.of(context);

  if (queryData.size.width <= 500) {
    marginWidth = 0;
    marginHeight = 0;
  }

  List<double> result = [];
  result.add(marginWidth);
  result.add(marginHeight);
  return result;
}

Widget getDashboardItem(Menu menu, double fontSize, double iconSize, Function? onPressed) {
  return Hero(
      tag: '${menu.label}HeroDb',
      child: Material(
          type: MaterialType.transparency,
          child: Container(
              constraints: BoxConstraints(
                  minWidth: iconSize + 16 + 48,
                  minHeight: iconSize + 16 + 48,
                  maxWidth: iconSize + 16 + 48,
                  maxHeight: iconSize + 16 + 48),
              child: Column(children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: getMenuColor(menu.color),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () => onPressed != null ? onPressed(menu) : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //Center Column contents vertically,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _getIcons(menu, iconSize),
                  ),
/*
                        Expanded(
                          child: Text(
                            menu.text,
                            style: TextStyle(
                              fontSize: fontSize,
                              overflow: TextOverflow.clip,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
*/
                ),
                Flexible(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                color: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Center(
                                child: Text(menu.label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: fontSize)))))),
              ]))));
}

List<Widget> _getIcons(Menu menu, double iconSize) {
  var list = <Widget>[];

  if (menu.icon != null) {
    list.add(Icon(icons[menu.icon], size: iconSize));
  }
  if (menu.overlayIcon != null) {
    list.add(Icon(icons[menu.overlayIcon], size: iconSize));
  }
  if (menu.icon == null && menu.overlayIcon == null) {
    list.add(Icon(icons['contact_support'], size: iconSize));
  }
  return list;
}

void openChangeLog(BuildContext context) async {
  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return multiDialog(
          content: const ChangeLogScreen(),
        );
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}
