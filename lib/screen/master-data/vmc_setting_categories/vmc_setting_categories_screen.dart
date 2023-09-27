import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/manufacturers/manufacturer_edit_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_setting_categories/vmc_setting_category_edit_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_setting_fields/vmc_setting_field_edit_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class VmcSettingCategoriesScreen extends StatefulWidget {
  const VmcSettingCategoriesScreen(
      {Key? key,
      required this.title,
      required this.menu,
      this.customBackClick,
      this.withBackButton = true})
      : super(key: key);

  final String title;
  final Menu menu;
  final VoidCallback? customBackClick;
  final bool withBackButton;

  @override
  VmcSettingCategoriesScreenState createState() =>
      VmcSettingCategoriesScreenState();
}

class VmcSettingCategoriesScreenState
    extends State<VmcSettingCategoriesScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<VmcSettingCategory>(
      keyName: 'vmcSettingCategoryId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          useIntrinsicRowHeight: false,
          repoName: "VmcSettingCategories",
          title: widget.title,
          addButtonToolTipText: "Aggiungi categoria",
          deleteButtonToolTipText: "Elimina categoria",
          columns: [
            DataScreenColumnConfiguration(
              id: 'name',
              label: 'Etichetta',
              labelType: LabelType.itemValue,
            ),
            DataScreenColumnConfiguration(
              id: 'color',
              label: 'Colore',
              labelType: LabelType.miniItemValue,
            ),
          ].toList(),
          menu: widget.menu),
      openNew: VmcSettingFieldsActions.openNew,
      openDetail: VmcSettingFieldsActions.openDetail,
      delete: VmcSettingFieldsActions.delete,
    );
  }
}

class VmcSettingFieldsActions {
  static Future openNew(context) async {
    final GlobalKey<VmcSettingCategoryEditFormState> formKey =
        GlobalKey<VmcSettingCategoryEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
            onWillPop: () async {
              return await onWillPop(formKey);
            },
            content: VmcSettingCategoryEditForm(
                key: formKey, element: null, title: "Nuova categoria"),
          );
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic openDetail(context, VmcSettingCategory item) async {
    final GlobalKey<VmcSettingCategoryEditFormState> formKey =
        GlobalKey<VmcSettingCategoryEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
            onWillPop: () async {
              return await onWillPop(formKey);
            },
            content: VmcSettingCategoryEditForm(
                key: formKey, element: item, title: "Modifica categoria"),
          );
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic delete(context, List<VmcSettingCategory> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message:
                'L\'eliminazione delle categorie selezionate comporterà l\'eliminazione delle stesse categorie e delle rispettive impostazioni dalla configurazione delle nuove macchine.\r\nContinuare?',
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
