
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:dpicenter/models/server/report_user.dart';
import 'package:dpicenter/screen/master-data/application_users/application_user_global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

Widget getReportItem(
    {required Report report,
    required Function() selected,
    required Function() onSelected,
    double? fontSize,
    double? letterSpacing,
    EdgeInsets? labelPadding,
    EdgeInsets? padding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    FontWeight? fontWeight,
    VisualDensity? visualDensity,
    Key? key}) {
  try {
    /// lunghezza < 18 (minore di 18, significa che sto cercando una data senza ora)
    /// Non è il massimo ma a volte, non ho ancora individuato quando, salva solo la data e non l'ora 00.00.00
    /// TODO: trovare il motivo in ReportEditScreen per cui, a volte, non viene salvata l'ora ma solo la data
    ///
    ///
    ///
    DateTime? creationDate = DateTime.tryParse(
        '${(report.creationDate?.length ?? 0) < 18 ? "${report.creationDate} 00:00:00" : report.creationDate}Z');
    String customer = report.customer?.description ?? '';
    String infoString = "Lavori totali: ${report.reportDetails?.length ?? 0}";
    intl.DateFormat format = intl.DateFormat("dd/MM/yyyy");
    String creationDateString = '';
    if (creationDate != null) {
      creationDateString = format.format(creationDate);
    }
    /*   String factories = "";
    if (report.reportDetails != null) {
      for (ReportDetail detail in report.reportDetails!) {
        factories += "${detail.factory}\r\n";
      }
    }*/
    /* List<ApplicationUser> users = <ApplicationUser>[];
    if (report.reportUsers != null) {
      for (ReportUser user in report.reportUsers!) {
        if (user.applicationUser != null) {
          users.add(user.applicationUser!);
        }
      }
    }*/
    return Theme(
      data: Theme.of(navigationScreenKey!.currentState!.context)
          .copyWith(canvasColor: Colors.transparent),
      child: ElevatedButton(
        //padding: EdgeInsets.zero,

        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(
                color: Theme.of(navigationScreenKey!.currentState!.context)
                    .colorScheme
                    .primary
                    .withAlpha(150))),
        key: key,
        /*selected: selected.call(),
          selectedColor: Theme.of(navigationScreenKey!.currentState!.context)
              .colorScheme
              .primary
              .withAlpha(200)
              .lighten(),*/
        onPressed: onSelected,

        // backgroundColor:
        //     Theme.of(navigationScreenKey!.currentState!.context).colorScheme.primary.withAlpha(200),
        //
        child: Padding(
          padding: padding!,
          child: Card(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Text(
                        "$creationDateString\r\n$customer\r\n$infoString",
                        textAlign: TextAlign.start)),
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                    child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      // const Flexible(child: SizedBox()),
                      ...List.generate(report.reportUsers!.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Tooltip(
                              message:
                                  "${report.reportUsers![index].applicationUser?.surname} ${report.reportUsers![index].applicationUser?.name}",
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.person,
                                  size: 16,
                                ),
                                iconSize: 24,
                                padding: EdgeInsets.zero,
                                constraints:
                                    BoxConstraints(maxHeight: 16, maxWidth: 16),
                                splashRadius: 16,
                              ) //_avatarBytes!=null ? CircleAvatar(foregroundImage: Image.memory(_avatarBytes).image,) : const CircleAvatar(child: Icon(Icons.person)),
                              ),
                        );
                      })
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
    return Theme(
      data: Theme.of(navigationScreenKey!.currentState!.context)
          .copyWith(canvasColor: Colors.transparent),
      child: ElevatedButton(
        //padding: EdgeInsets.zero,

        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(
                color: Theme.of(navigationScreenKey!.currentState!.context)
                    .colorScheme
                    .primary
                    .withAlpha(150))),
        key: key,
        /*selected: selected.call(),
          selectedColor: Theme.of(navigationScreenKey!.currentState!.context)
              .colorScheme
              .primary
              .withAlpha(200)
              .lighten(),*/
        onPressed: onSelected,

        // backgroundColor:
        //     Theme.of(navigationScreenKey!.currentState!.context).colorScheme.primary.withAlpha(200),
        //
        child: Padding(
            padding: padding!,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: getStrokedText(
                          "$creationDateString\r\n$customer\r\n$infoString",
                          textAlign: TextAlign.start)),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
            /*Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: getStrokedText(
                            "$creationDateString\r\n$customer\r\n$infoString",
                            textAlign: TextAlign.start)),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const Flexible(child: SizedBox()),
                          ...List.generate(report.reportUsers!.length, (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Tooltip(
                                message:
                                    "${report.reportUsers![index].applicationUser?.surname} ${report.reportUsers![index].applicationUser?.name}",
                                child: getOperatorAvatar(
                                    user: report.reportUsers![index].applicationUser!,
                                    maxRadius: 8,
                                    iconSize: 14,
                                    iconColor:
                                        Theme.of(navigatorKey!.currentContext!)
                                            .colorScheme
                                            .primary
                                            .withAlpha(200),
                                    backgroundColor:
                                        Theme.of(navigatorKey!.currentContext!)
                                            .colorScheme
                                            .background),

                                //_avatarBytes!=null ? CircleAvatar(foregroundImage: Image.memory(_avatarBytes).image,) : const CircleAvatar(child: Icon(Icons.person)),
                              ),
                            );
                          })
                        ]
                        */ /*[
IconButton(onPressed: (){}, icon: Icon(Icons.person, size: 24,),iconSize: 24,padding: EdgeInsets.zero,constraints: BoxConstraints(maxHeight: 32, maxWidth: 32),)
                      ],*/ /*
                        ),
                  ),
                )
              ],
            )*/
            ),
        /*
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Align(
                        alignment: Alignment.topLeft,
                          child: getStrokedText("$creationDateString\r\n$customer\r\n$infoString", textAlign: TextAlign.start))
                    ),
                    //Flexible(child: getStrokedText(factories, fontSize: 12)),
                    Flexible(child: Align(
                        alignment: Alignment.topLeft, child: getStrokedText(users, fontSize: 12, textAlign: TextAlign.start))),
                  ],
                ),)*/
        //getStrokedText("$creationDateString\r\n$customer\r\n$infoString\r\n$factories\r\n$users"),
      ),
    );
  } catch (e) {
    return Text(e.toString());
  }
}

TextStyle _reportTextStyleStandard(Color tagColor,
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

TextStyle _reportTextStyleStandardStroke(Color tagColor,
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
