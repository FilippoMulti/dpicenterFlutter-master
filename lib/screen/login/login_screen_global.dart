import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/screen/dialogs/url_server_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';

dynamic manageSettings(BuildContext context) async {
  var result = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return multiDialog(
            content: UrlEditForm(
/*
TODO: ripristinare questo pezzo di codice, attualmente carico l'url sempre dai prefence per test
                                        url: kIsWeb ? BaseServiceEx.baseUrl :
                                                      prefs!.getString("url")!,
*/
                url: prefs!.getString(urlSetting)!,
                showBackground:
                    prefs!.getBool(showBackgroundImageSetting) ?? false,
                backgroundOpacity:
                    prefs!.getDouble(backgroundOpacitySetting) ?? 0.97,
                usePreRelease: prefs!.getBool(preReleaseSetting) ?? false,
                title: "Impostazioni"));
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  if (result != null && result is List) {
    prefs!.setString(urlSetting, result[0] as String);
    prefs!.setBool(showBackgroundImageSetting, result[1] as bool);
    prefs!.setDouble(backgroundOpacitySetting, result[2] as double);
    prefs!.setBool(preReleaseSetting, result[3] as bool);
    MultiService.baseUrl = prefs!.getString(urlSetting)!;

    eventBus.fire(RestartHubEvent(newUrl: MultiService.baseUrl));
  }
  return result;
}
