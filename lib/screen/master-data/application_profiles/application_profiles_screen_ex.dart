import 'dart:convert';

import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_profile.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/application_profiles/application_profile_edit_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/navigation/navigation_screen_ex2.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationProfilesScreen extends StatefulWidget {
  const ApplicationProfilesScreen({Key? key,
    required this.title,
    required this.menu,
    this.customBackClick,
    this.withBackButton = true})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Menu menu;
  final VoidCallback? customBackClick;
  final bool withBackButton;

  @override
  _ApplicationProfilesScreenState createState() =>
      _ApplicationProfilesScreenState();
}

class _ApplicationProfilesScreenState extends State<ApplicationProfilesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return DataScreen<ApplicationProfile>(
      keyName: 'applicationProfileId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
        withBackButton: widget.withBackButton,
        repoName: "ApplicationProfiles",
        title: widget.title,
        addButtonToolTipText: "Aggiungi profilo",
        deleteButtonToolTipText: "Elimina profili selezionati",
        menu: widget.menu,
        columns: [
          DataScreenColumnConfiguration(
              id: 'profileName', label: 'Nome profilo'),
          DataScreenColumnConfiguration(id: 'specialType', label: 'Tipo'),
        ].toList(),
      ),
      openNew: openNew,
      openDetail: openDetail,
      delete: delete,
    );
  }

  static Widget _getForm(BuildContext context,
      ApplicationProfile? item,
      String title, {
        Key? key,
      }) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ServerDataBloc>(
            lazy: false,
            create: (context) => ServerDataBloc<ApplicationProfile>(
                repo: MultiService<ApplicationProfile>(
                    ApplicationProfile.fromJsonModel,
                    apiName: 'ApplicationProfile')),
          )
        ],
        child:
        ApplicationProfileEditForm(key: key, element: item, title: title));
  }

  static dynamic openNew(context) async {
    GlobalKey<ApplicationProfileEditFormState> formKey =
        GlobalKey<ApplicationProfileEditFormState>(
            debugLabel: "applicationProfileEditFormState");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: _getForm(context, null, "Nuovo profilo", key: formKey));
        }).then((element) {
      ///controllo se devo aggiornare l'utente connesso
      checkReturningValue(context, element);
      return element;
    });
    return result;
  }

  static void checkReturningValue(context, ApplicationProfile? element) {
    if (element != null) {
      ///controllo se l'utente connesso ha lo stesso profilo che è stato modificato, in caso affernativo
      ///aggiorno lo user salvato nei settings e ricarico l'interfaccia
      ApplicationUser? user = ApplicationUser.getUserFromSetting();
      if (user != null) {
        if (element.applicationProfileId == user.applicationProfileId) {
          //element=element.copyWith(enabledMenus: element.enabledMenus?.map((e) => e.copyWith(menu: Menu.findMenu(e.menuId))).toList());
          user = user.copyWith(
              profile:
                  user.profile?.copyWith(enabledMenus: element.enabledMenus));
          prefs!.setString(userInfoSetting, jsonEncode(user.toJson()));
          var nav = NavigationScreenPageEx.of(context);

          NavigationScreenPageEx.of(context)?.reload();
        }
      }
      //return element;
    }
  }

  dynamic openDetail(context, ApplicationProfile item) async {
    GlobalKey<ApplicationProfileEditFormState> formKey =
        GlobalKey<ApplicationProfileEditFormState>(
            debugLabel: "applicationProfileEditFormState");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content:
                  _getForm(context, item, "Modifica profilo", key: formKey));
        }).then((element) {
      checkReturningValue(context, element);
      return element;
    });
    return result;
  }

  dynamic delete(List<ApplicationProfile> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare i profili selezionati?',
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
    ).then((value) {
      return value;
      //return value
    });
    return result;
  }
}
