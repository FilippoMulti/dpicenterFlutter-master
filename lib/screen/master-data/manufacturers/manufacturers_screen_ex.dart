import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/manufacturers/manufacturer_edit_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:flutter/material.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class ManufacturersScreen extends StatefulWidget {
  const ManufacturersScreen(
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
  _ManufacturersScreenState createState() => _ManufacturersScreenState();
}

class _ManufacturersScreenState extends State<ManufacturersScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<Manufacturer>(
      keyName: 'manufacturerId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          useIntrinsicRowHeight: true,
          repoName: "Manufacturers",
          title: widget.title,
          addButtonToolTipText: "Aggiungi produttore",
          deleteButtonToolTipText: "Elimina produttori selezionati",
          columns: [
            DataScreenColumnConfiguration(
                id: 'description',
                label: 'Produttore',
                labelType: LabelType.itemValue),
            DataScreenColumnConfiguration(
                id: 'referente',
                label: 'Referente',
                labelType: LabelType.itemValue),
          ].toList(),
          menu: widget.menu),
      openNew: ManufacturersActions.openNew,
      openDetail: ManufacturersActions.openDetail,
      delete: ManufacturersActions.delete,
    );
  }
}

class ManufacturersActions {
  static Future openNew(context) async {
    final GlobalKey<ManufacturerEditFormState> formKey =
        GlobalKey<ManufacturerEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: ManufacturerEditForm(
                  key: formKey, element: null, title: "Nuovo produttore"));
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
              content: ManufacturerEditForm(
                  key: formKey, element: item, title: "Modifica produttore"));
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
            message: 'Eliminare i produttori selezionati?',
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
