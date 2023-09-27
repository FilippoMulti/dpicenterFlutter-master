import 'package:delta_e/delta_e.dart';
import 'package:dpicenter/blocs/chatgpt_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/widgets/chatbot/chatgpt_bot.dart';
import 'package:dpicenter/screen/widgets/dashboard_menu_config.dart';
import 'package:dpicenter/screen/widgets/report_problem/report_problem.dart';
import 'package:dpicenter/screen/widgets/chatbot/chat_bot.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

disconnectUser(BuildContext context, {bool confirmRequest = true}) async {
  String? result;
  if (confirmRequest) {
    result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Logout',
            message: 'Disconnettersi da Dpi Center?',
            type: MessageDialogType.yesNo,
            yesText: 'SI',
            noText: 'NO',
            okPressed: () {
              Navigator.pop(context, "0");
            },
            noPressed: () {
              Navigator.pop(context, "1");
            });
      },
    ).then((value) async {
      return value;
      //return value
    });
  } else {
    ///ok di default
    result = '0';
  }

  if (result != null) {
    if (result == "0") {
      prefs!.setString('token', "");
      eventBus.fire(RestartHubEvent(newUrl: MultiService.baseUrl));
      await Navigator.pushReplacementNamed(context, "/");
    }
  }
}

dynamic showDashboardConfigDialog(context) async {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;

  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return multiDialog(
          title: const Text("Seleziona menu della Dashboard"),
          content: Builder(builder: (context) {
            return Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10)),
                height: height - 0,
                width: width - 0,
                child: DashboardMenuConfig(
                    dashboardMenu: dashBoardMenu ??
                        const Menu(
                            code: "dashboard",
                            menuId: -3,
                            label: 'dashboard',
                            subMenus: [])));
          }),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Annulla")),
            ElevatedButton(
                onPressed: () async {
                  await LocalSearchService.saveDashboardMenu(dashBoardMenu!);
                  Navigator.of(context).pop(dashBoardMenu!);
                },
                child: const Text("Salva")),
          ],
        );
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}

/*dynamic reportProblem(context) async {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;

  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return multiDialog(
          title: const Text("Segnala un problema"),
          content: Builder(builder: (context) {
            return Text("Under construction");
          }),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Annulla")),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(dashBoardMenu!);
                },
                child: const Text("Salva")),
          ],
        );
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}*/

Widget multiDialog(
    {EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    Widget? content,
    Widget? title,
    List<Widget>? actions,
    final WillPopCallback? onWillPop}) {
  return WillPopScope(
    onWillPop: onWillPop,
    child: AlertDialog(
      clipBehavior: Clip.antiAlias,
      backgroundColor: isDarkTheme(navigatorKey!.currentContext!)
          ? Color.alphaBlend(
              Theme.of(navigatorKey!.currentContext!)
                  .colorScheme
                  .surface
                  .withAlpha(240),
              Theme.of(navigatorKey!.currentContext!).colorScheme.primary)
          : Theme.of(navigatorKey!.currentContext!).colorScheme.surface,
      insetPadding: insetPadding ?? const EdgeInsets.all(0),
      titlePadding: titlePadding ?? const EdgeInsets.all(0),
      contentPadding: contentPadding ?? const EdgeInsets.all(0),
      content: content,
      title: title,
      actions: actions,
    ),
  );
}

Widget multiDialogCustom(
    {EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    Widget? content,
    Widget? title,
    List<Widget>? actions,
    final WillPopCallback? onWillPop}) {
  return WillPopScope(
    onWillPop: onWillPop,
    child: Dialog(
      backgroundColor: isDarkTheme(navigatorKey!.currentContext!)
          ? Color.alphaBlend(
              Theme.of(navigatorKey!.currentContext!)
                  .colorScheme
                  .surface
                  .withAlpha(240),
              Theme.of(navigatorKey!.currentContext!).colorScheme.primary)
          : Theme.of(navigatorKey!.currentContext!).colorScheme.surface,
      insetPadding: insetPadding ?? const EdgeInsets.all(1),
      child: content,

      /*titlePadding: titlePadding ?? const EdgeInsets.all(1),
      contentPadding: contentPadding ?? const EdgeInsets.all(1),
      content: content,
      title: title,
      actions: actions,*/
    ),
  );
}

Color getBottomNavigatorBarForegroundColor(BuildContext context) {
  Color colorBase = Colors.white;

  if (isDarkTheme(context)) {
    colorBase = Color.alphaBlend(
        Theme.of(context).colorScheme.surface.withAlpha(240),
        Theme.of(context).colorScheme.primary);
  } else {
    colorBase = Theme.of(context).colorScheme.primary;
  }

  LabColor labColorPrimary = getLabColor(colorBase);
  Color colorToCheck =
      colorBase.computeLuminance() > 0.5 ? Colors.black87 : Colors.white70;

  LabColor labColorDefault = getLabColor(colorToCheck);

  //double difference = computeColorDistance(primary, menuDefaultColor);
  double difference = deltaE76(labColorDefault, labColorPrimary);
  //print('difference: ' + difference.toString());
  //print('compute luminance: ' + colorBase.computeLuminance().toString());
  if (difference < 50) {
    return colorBase.computeLuminance() > 0.5 ? Colors.white70 : Colors.black87;
  }
  return colorToCheck;
}

dynamic openReportProblem(BuildContext context) async {
  final GlobalKey<ReportProblemFormState> formKey =
      GlobalKey<ReportProblemFormState>(debugLabel: "formKey");

  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return multiDialog(
            onWillPop: () async {
              return await onWillPop(formKey);
            },
            content: ReportProblemForm(key: formKey));
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}

dynamic openChatBot(BuildContext context) async {
  final GlobalKey<ChatBotFormState> formKey =
      GlobalKey<ChatBotFormState>(debugLabel: "formKey");

  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<ChatGptBloc>(
                  lazy: false,
                  create: (context) => ChatGptBloc(key: openAIKey)),
            ],
            child: multiDialog(
                onWillPop: () async {
                  return await onWillPop(formKey);
                },
                content: ChatBotForm(key: formKey)));
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}

dynamic openChatGPTBot(BuildContext context) async {
  final GlobalKey<ChatGPTBotFormState> formKey =
      GlobalKey<ChatGPTBotFormState>(debugLabel: "formKey");

  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<ChatGptBloc>(
                  lazy: false,
                  create: (context) => ChatGptBloc(key: openAIKey)),
            ],
            child: multiDialog(
                onWillPop: () async {
                  return await onWillPop(formKey);
                },
                content: ChatGPTBotForm(key: formKey)));
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}