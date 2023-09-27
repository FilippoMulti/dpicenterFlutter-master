import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/vmc_configuration.dart';
import 'package:dpicenter/screen/autogeneration/auto_generation_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/manufacturers/manufacturer_edit_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/app_bar.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class VmcConfigurationScreen extends StatefulWidget {
  const VmcConfigurationScreen(
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
  _VmcConfigurationScreenState createState() => _VmcConfigurationScreenState();
}

class _VmcConfigurationScreenState extends State<VmcConfigurationScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<VmcConfiguration>(
      keyName: 'vmcConfigurationId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          useIntrinsicRowHeight: true,
          repoName: "VmcConfiguration",
          title: widget.title,
          addButtonToolTipText: "Aggiungi configurazione distributore",
          deleteButtonToolTipText: "Elimina configurazioni selezionate",
          columns: [
            DataScreenColumnConfiguration(
                id: 'description', label: 'Descrizione'),
          ].toList(),
          menu: widget.menu),
      openNew: VmcConfigurationsActions.openNew,
      openDetail: VmcConfigurationsActions.openDetail,
      delete: VmcConfigurationsActions.delete,
    );
  }
}

class VmcConfigurationsActions {
  static Future openNew(context) async {
    final GlobalKey<ManufacturerEditFormState> formKey =
        GlobalKey<ManufacturerEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return scaffold(
            form: AutoGenerationScreen(
                key: formKey, title: "Nuova configurazione"),
            title: const Text("Nuova configurazione"),
          );
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic openDetail(context, Manufacturer item) async {
    final GlobalKey<ManufacturerEditFormState> formKey =
        GlobalKey<ManufacturerEditFormState>(debugLabel: "formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: AutoGenerationScreen(
                  key: formKey,
                  //element: item,
                  title: "Modifica configurazione"));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic delete(context, List<Manufacturer> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare le configurazioni selezionate?',
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

  static Widget scaffold(
      {required Text title,
      required AutoGenerationScreen form,
      double appBarHeight = 60}) {
    return WillPopScope(
      onWillPop: () async {
        /*if (form.key != null) {
          */ /*var status = (form.key as GlobalKey<ReportEditFormState>)
                  .currentState
                  ?.editSummaryFormKey
                  ?.currentState
                  ?.compressStatus ??
              0;

          return status == 0 ? true : false;*/ /*
          Key? key = form.key;

          if (key is GlobalKey<AutoGenerationScreenState>) {
            var status = key.currentState?.editState ?? false;

            if (status) {
              //on edit
              if (key.currentContext != null) {
                String? result = await exitScreen(key.currentContext!);
                if (result != null) {
                  switch (result) {
                    case '0': //si
                      key.currentState?.validateSave();
                      break;
                    case '1': //no
                      if (key.currentContext != null) {
                        Navigator.of(key.currentContext!).pop();
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
          }
        }*/
        return true;
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: appBarHeight,
                child: AppBar(
                    elevation: 0,
                    backgroundColor: isDarkTheme(navigatorKey!.currentContext!)
                        ? Color.alphaBlend(
                            Theme.of(navigatorKey!.currentContext!)
                                .colorScheme
                                .surface
                                .withAlpha(240),
                            Theme.of(navigatorKey!.currentContext!)
                                .colorScheme
                                .primary)
                        : null,
                    shape: const CustomAppBarShape(),
                    title: title)),
          ),
          body: MultiBlocProvider(providers: [
            BlocProvider<ServerDataBloc>(
              lazy: false,
              create: (context) => ServerDataBloc(
                  repo: MultiService<VmcConfiguration>(
                      VmcConfiguration.fromJsonModel,
                      apiName: 'VmcConfiguration')),
            ),
            BlocProvider<ServerDataBloc<VmcConfiguration>>(
              lazy: false,
              create: (context) => ServerDataBloc<VmcConfiguration>(
                  repo: MultiService<VmcConfiguration>(
                      VmcConfiguration.fromJsonModel,
                      apiName: 'VmcConfiguration')),
            ),
          ], child: form)),
    );
  }
}
