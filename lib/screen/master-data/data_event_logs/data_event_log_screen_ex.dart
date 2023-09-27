import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/data_event_log.dart';
import 'package:dpicenter/models/server/event_type_enum.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class DataEventLogScreen extends StatefulWidget {
  const DataEventLogScreen(
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
  _DataEventLogScreenState createState() => _DataEventLogScreenState();
}

class _DataEventLogScreenState extends State<DataEventLogScreen> {
  @override
  void initState() {
    super.initState();
  }

/*  String applyFormat(dynamic value, String format) {
    final parseValue = DateTime.tryParse('${value}Z');

    if (parseValue == null) {
      return '';
    }

    return intl.DateFormat(format)
        .format(DateTime.parse('${value}Z').toLocal());
  }

  dynamic makeCompareValue(dynamic v, String format) {
    final dateFormat = intl.DateFormat(format);

    DateTime? dateFormatValue;

    try {
      dateFormatValue = dateFormat.parse(v.toString(), true).toLocal();
    } catch (e) {
      dateFormatValue = null;
    }

    return dateFormatValue;
  }*/

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return DataScreen<DataEventLog>(
      keyName: 'dataEventLogId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
        withBackButton: widget.withBackButton,
        useIntrinsicRowHeight: true,
        repoName: "DataEventLogs",
        title: widget.title,
        addButtonToolTipText: "Aggiungi evento",
        deleteButtonToolTipText: "Elimina eventi selezionati",
        columns: [
          DataScreenColumnConfiguration(
              id: 'date',
              label: 'Data',
              labelType: LabelType.itemValue,
              onRenderRowField: (item, {bool? forList}) {
                String value = '';
                try {
                  value = applyFormat(
                      (item as DataEventLog).date, 'dd/MM/yyyy HH:mm:ss')
                      .toString();
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }

                return Builder(
                  builder: (BuildContext context) {
/*                    var screen = DataScreenState.of(context);

                   var element = screen
                            .adapter!.listLocale![rendererContext.row!.sortIdx!]
                        as DataEventLog;*/
                    return DefaultDataSource.getText(value, null);
                    /*   return Align(
                        alignment: Alignment.centerLeft, child: Text(value));*/
                  },
                );
              }),
          DataScreenColumnConfiguration(
            id: 'controller',
            label: 'Controller',
            labelType: LabelType.miniItemValue,
          ),
          DataScreenColumnConfiguration(
              id: 'applicationUser.userName',
              label: 'Utente',
              labelType: LabelType.miniItemValue),
          DataScreenColumnConfiguration(
            id: 'origin',
            label: 'Origine',
            labelType: LabelType.itemValue,
          ),
          DataScreenColumnConfiguration(
            id: 'eventString',
            label: 'Evento',
            labelType: LabelType.itemValue,
          ),
          DataScreenColumnConfiguration(
              id: 'eventType',
              label: 'Tipo',
              labelType: LabelType.miniItemValue,
              onRenderRowField: (item, {bool? forList}) {
                String value = '';
                switch ((item as DataEventLog).eventType) {
                  case EventTypeEnum.add:
                    value = 'Add';
                    break;
                  case EventTypeEnum.delete:
                    value = 'Delete';
                    break;
                  case EventTypeEnum.update:
                    value = 'Update';
                    break;
                  case EventTypeEnum.other:
                    value = 'Other';
                    break;
                  default:
                    value = 'Unknown';
                }
                return DefaultDataSource.getText(value, null);
              }),
          DataScreenColumnConfiguration(
              id: 'userAgent',
              label: 'User Agent',
              labelType: LabelType.miniItemValue),
          //DataScreenColumnConfiguration(id: 'jsonObject', label: 'Json'),
        ].toList(),
        menu: widget.menu,
      ),
      openNew: null,
      openDetail: null,
      delete: null,
    );
  }
}

class DataEventLogsActions {
  static dynamic openNew(context) async {
/*
    var result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              content: BlocProvider<ServerDataBloc>(
                  lazy: false,
                  create: (context) => ServerDataBloc<ApplicationProfile>(
                      repo: ApplicationProfileServices()),
                  child: ApplicationUserEditForm(
                      row: null, element: null, title: "Nuovo operatore")));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
*/
  }

  static dynamic openDetail(context, ApplicationUser item) async {
/*
    var result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              content: BlocProvider<ServerDataBloc>(
                  lazy: false,
                  create: (context) => ServerDataBloc<ApplicationProfile>(
                      repo: ApplicationProfileServices()),
                  child: ApplicationUserEditForm(
                      row: row, element: item, title: "Modifica operatore")));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
*/
  }

  static dynamic delete(context, List<ApplicationUser> items) async {
/*
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
*/
  }
}
