import 'dart:convert';

import 'package:dpicenter/blocs/image_gallery_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_profile.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/report_detail_image.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application_user_edit_screen.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class ApplicationUsersScreen extends StatefulWidget {
  const ApplicationUsersScreen(
      {Key? key,
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
  _ApplicationUsersScreenState createState() => _ApplicationUsersScreenState();
}

class _ApplicationUsersScreenState extends State<ApplicationUsersScreen> {
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

    return DataScreen<ApplicationUser>(
      keyName: 'applicationUserId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
        withBackButton: widget.withBackButton,
        useIntrinsicRowHeight: false,
        repoName: "ApplicationUsers",
        title: widget.title,
        addButtonToolTipText: "Aggiungi operatore",
        deleteButtonToolTipText: "Elimina operatori selezionati",
        columns: [
          DataScreenColumnConfiguration(
            id: 'userName',
            label: 'Nome utente',
            labelType: LabelType.itemValue,
          ),
          DataScreenColumnConfiguration(
            id: 'surname',
            label: 'Cognome',
            labelType: LabelType.miniItemValue,
          ),
          DataScreenColumnConfiguration(
            id: 'name',
            label: 'Nome',
            labelType: LabelType.miniItemValue,
          ),
          DataScreenColumnConfiguration(
            id: 'profile.profileName',
            label: 'Profilo',
            labelType: LabelType.itemValue,
          ),
        ].toList(),
        menu: widget.menu,
      ),
      openNew: ApplicationUsersActions.openNew,
      openDetail: ApplicationUsersActions.openDetail,
      delete: ApplicationUsersActions.delete,
      onSave: ApplicationUsersActions.onSave,
    );
  }
}

class ApplicationUsersActions {
  static dynamic openNew(context) async {
    GlobalKey<ApplicationUserEditFormState> formKey =
        GlobalKey<ApplicationUserEditFormState>(
            debugLabel: "applicationUserEditFormState");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content:
                  _getForm(context, null, "Nuovo operatore", key: formKey));
          /*onWillPop: () async {return await onWillPop(formKey);}, */ /*() async {
                  var status = formKey.currentState?.editState ?? false;
                  if (status) {
                    //on edit
                    if (formKey.currentContext != null) {
                      String? result = await exitScreen(formKey.currentContext!);
                      if (result!=null) {
                        switch (result) {
                          case '0': //si
                            formKey.currentState?.validateSave();
                            break;
                          case '1': //no
                            if (formKey.currentContext != null) {
                              Navigator.of(formKey.currentContext!).pop();
                            }
                            break;
                          case '2': //annulla
                            break;
                        }
                      }
                    }
                  }

                  ///se editState è true blocco l'uscita
                  return !status;
                },*/ /*


              content: BlocProvider<ServerDataBloc>(
                  lazy: false,
                  create: (context) => ServerDataBloc<ApplicationProfile>(
                      repo: ApplicationProfileServices()),
                  child: ApplicationUserEditForm(
                    key: formKey,
                      row: null, element: null, title: "Nuovo operatore")));*/
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic openDetail(context, ApplicationUser item,
      {bool allowProfileChange = true}) async {
    GlobalKey<ApplicationUserEditFormState> formKey =
        GlobalKey<ApplicationUserEditFormState>(
            debugLabel: "applicationUserEditFormState");
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: _getForm(context, item, "Modifica operatore",
                  key: formKey, allowProfileChange: allowProfileChange));
          /*MultiBlocProvider(providers: [
              BlocProvider<ServerDataBloc>(
                  lazy: false,
                  create: (context) => ServerDataBloc<ApplicationProfile>(
                      repo: ApplicationProfileServices()),
              ),
                BlocProvider<ServerDataBloc>(
                  lazy: false,
                  create: (context) => ServerDataBloc<ApplicationProfile>(
                      repo: ApplicationProfileServices()),
                )], child: ApplicationUserEditForm(
                      row: row, element: item, title: "Modifica operatore")));*/
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static Future<ApplicationUser?> openDetailAndSave(
      context, ApplicationUser item) async {
    ApplicationUser? value;
    try {
      value = await openDetail(context, item, allowProfileChange: false);
      if (value != null) {
        MultiService<ApplicationUser> service = MultiService<ApplicationUser>(
            ApplicationUser.fromJsonModel,
            apiName: 'ApplicationUser');
        await service.update(value);
        List<ApplicationUser>? list = await service
            .get(QueryModel(id: item.applicationUserId!.toString()));
        if (list != null) {
          ApplicationUser itemReloaded = list[0];
          prefs!.setString(userInfoSetting, jsonEncode(itemReloaded.toJson()));

          try {
            var bloc = BlocProvider.of<ServerDataBloc<ApplicationUser>>(
                navigationScreenKey!.currentContext!);

            bloc.add(const ServerDataEvent<ApplicationUser>(
                status: ServerDataEvents.fetch));
          } catch (e) {
            print(e);
          }

          //var openedScreen =  DataScreen.of(context);
          //openedScreen?.reload();
          //applicationUserDataScreenKey.currentState?.reload();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return value;
  }

  static Widget _getForm(
    BuildContext context,
    ApplicationUser? item,
    String title, {
    bool allowProfileChange = true,
    Key? key,
  }) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ImageGalleryBloc>(
            lazy: false,
            create: (context) => ImageGalleryBloc(
                repo: MultiService<ReportDetailImage>(
                    ReportDetailImage.fromJsonModel,
                    apiName: 'ReportDetailImage')),
          ),
          BlocProvider<ServerDataBloc>(
            lazy: false,
            create: (context) => ServerDataBloc<ApplicationProfile>(
                repo: MultiService<ApplicationProfile>(
                    ApplicationProfile.fromJsonModel,
                    apiName: 'ApplicationProfile')),
          )
        ],
        child: ApplicationUserEditForm(
            key: key,
            element: item,
            title: title,
            allowProfileChange: allowProfileChange));
  }

  static dynamic onSave(ApplicationUser item) async {
    ///salvo nelle impostazioni l'utente aggiornato
    ApplicationUser? currentUser = ApplicationUser.getUserFromSetting();
    if (currentUser != null &&
        currentUser.applicationUserId == item.applicationUserId) {
      prefs!.setString(userInfoSetting, jsonEncode(item.toJson()));
      navigationScreenKey?.currentState?.reloadUser();
      ApplicationUser? loadedUser = ApplicationUser.getUserFromSetting();
      if (loadedUser != null) {
        navigationScreenKey?.currentState?.accountDrawerKey.currentState
            ?.updateUser(loadedUser);
        await ThemeModeHandler.of(navigatorKey!.currentContext!)?.update();
      }
    }
  }

  static dynamic delete(context, List<ApplicationUser> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare gli operatori selezionati?',
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
