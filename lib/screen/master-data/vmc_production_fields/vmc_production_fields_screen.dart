import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/vmc_production_category.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/manufacturers/manufacturer_edit_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_production_fields/vmc_production_field_edit_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dpicenter/models/server/setting_type.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class VmcProductionFieldsScreen extends StatefulWidget {
  const VmcProductionFieldsScreen(
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
  VmcProductionFieldsScreenState createState() =>
      VmcProductionFieldsScreenState();
}

class VmcProductionFieldsScreenState extends State<VmcProductionFieldsScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<VmcProductionField>(
      keyName: 'vmcProductionFieldId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          useIntrinsicRowHeight: false,
          repoName: "VmcProductionFields",
          title: widget.title,
          addButtonToolTipText: "Aggiungi operazione",
          deleteButtonToolTipText: "Elimina operazione",
          columns: [
            DataScreenColumnConfiguration(
              id: 'name',
              label: 'Etichetta',
              labelType: LabelType.itemValue,
            ),
            DataScreenColumnConfiguration(
              id: 'description',
              label: 'Descrizione',
              labelType: LabelType.miniItemValue,
            ),
            DataScreenColumnConfiguration(
              id: 'category.name',
              label: 'Categoria',
              labelType: LabelType.itemValue,
            ),
            DataScreenColumnConfiguration(
                id: 'type',
                label: 'Tipo',
                customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.recalculateCellValue,
                    recalculateCellValue: (item) {
                      int type = (item as VmcProductionField).type ?? 0;
                      String cellValue = Type.fromType(type).toString();

                      return ColumnSizerRecalculateResult(
                          result: cellValue,
                          textStyle: Theme.of(context).textTheme.bodyLarge!);
                      cellValue;
                    }),
                onRenderRowField: (item, {bool? forList}) {
                  int type = (item as VmcProductionField).type ?? 0;

                  return Builder(
                    builder: (BuildContext context) {
                      return DefaultDataSource.getTextWithoutIntrinsic(
                          Type.fromType(type).toString(), null,
                          textAlign: TextAlign.center);
                      /*return Align(
                    alignment: Alignment.centerLeft, child: Text(value));*/
                    },
                  );
                }),
          ].toList(),
          menu: widget.menu),
      openNew: VmcProductionFieldsActions.openNew,
      openDetail: VmcProductionFieldsActions.openDetail,
      delete: VmcProductionFieldsActions.delete,
    );
  }
}

class VmcProductionFieldsActions {
  static Future openNew(context) async {
    final GlobalKey<VmcProductionFieldEditFormState> formKey =
        GlobalKey<VmcProductionFieldEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: MultiBlocProvider(
                providers: [
                  BlocProvider<ServerDataBloc>(
                    lazy: false,
                    create: (context) => ServerDataBloc<VmcProductionCategory>(
                        repo: MultiService<VmcProductionCategory>(
                            VmcProductionCategory.fromJson,
                            apiName: 'VmcProductionCategory')),
                  ),
                ],
                child: VmcProductionFieldEditForm(
                    key: formKey, element: null, title: "Nuova operazione"),
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic openDetail(context, VmcProductionField item) async {
    final GlobalKey<VmcProductionFieldEditFormState> formKey =
        GlobalKey<VmcProductionFieldEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: MultiBlocProvider(
                providers: [
                  BlocProvider<ServerDataBloc>(
                    lazy: false,
                    create: (context) => ServerDataBloc<VmcProductionCategory>(
                        repo: MultiService<VmcProductionCategory>(
                            VmcProductionCategory.fromJson,
                            apiName: 'VmcProductionCategory')),
                  )
                ],
                child: VmcProductionFieldEditForm(
                    key: formKey, element: item, title: "Modifica operazione"),
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic delete(context, List<VmcProductionField> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message:
                'L\'eliminazione delle operazioni selezionate comporterà l\'eliminazione delle stesse operazioni dalla configurazione delle nuove macchine.\r\nContinuare?',
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
