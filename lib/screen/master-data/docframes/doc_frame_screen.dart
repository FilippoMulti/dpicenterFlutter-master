import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/openai/data_frame.dart';
import 'package:dpicenter/models/server/openai/doc_frame.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/string_response.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/dataframes/data_frame_edit_screen.dart';
import 'package:dpicenter/screen/master-data/docframes/doc_frame_edit_screen.dart';
import 'package:dpicenter/screen/master-data/manufacturers/manufacturer_edit_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class DocFrameScreen extends StatefulWidget {
  const DocFrameScreen(
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
  DocFrameScreenState createState() => DocFrameScreenState();
}

class DocFrameScreenState extends State<DocFrameScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<DocFrame>(
        keyName: 'id',
        customBackClick: widget.customBackClick,
        configuration: DataScreenConfiguration(
            withBackButton: widget.withBackButton,
            useIntrinsicRowHeight: true,
            repoName: "Docframes",
            title: widget.title,
            addButtonToolTipText: "Aggiungi un doc frame",
            deleteButtonToolTipText: "Elimina i doc frame selezionati",
            columns: [
              DataScreenColumnConfiguration(
                  id: 'section',
                  label: 'Sezione',
                  labelType: LabelType.itemValue,
                  customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.recalculateCellValue,
                  )),
              DataScreenColumnConfiguration(
                  id: 'title',
                  label: 'Titolo',
                  labelType: LabelType.itemValue,
                  customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.recalculateCellValue,
                  )),
              DataScreenColumnConfiguration(
                  id: 'content',
                  label: 'Contenuto',
                  labelType: LabelType.itemValue,
                  customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.recalculateCellValue,
                  )),
              DataScreenColumnConfiguration(
                  id: 'generate',
                  label: 'Genera',
                  labelType: LabelType.itemValue),
            ].toList(),
            menu: widget.menu),
        openNew: DocFramesActions.openNew,
        openDetail: DocFramesActions.openDetail,
        delete: DocFramesActions.delete,
        printCallback: (list) async {
          MultiService<StringResponse> service = MultiService<StringResponse>(
              DocFrame.fromJsonModel,
              apiName: "DocFrame");
          List<StringResponse>? result = await service.retrieveCommand(
              "api/Lab/generate_documentation_from_list",
              list,
              StringResponse.fromJsonModel);
          launchUrl(
              Uri.parse(
                  "https://${MultiService.baseUrl}/api/Lab/showdoc?docName=${result?.first.response}"),
              mode: LaunchMode.externalApplication);
        });
  }
}

class DocFramesActions {
  static Future openNew(context) async {
    final GlobalKey<DocFrameEditFormState> formKey =
        GlobalKey<DocFrameEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: DocFrameEditForm(
                  key: formKey, element: null, title: "Nuovo doc frame"));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic openDetail(context, DocFrame item) async {
    final GlobalKey<DocFrameEditFormState> formKey =
        GlobalKey<DocFrameEditFormState>(debugLabel: "formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: DocFrameEditForm(
                  key: formKey, element: item, title: "Modifica doc frame"));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static Future<DocFrame?> openDetailAndSave(context, DocFrame item) async {
    DocFrame? value;
    try {
      value = await openDetail(context, item);
      if (value != null) {
        MultiService<DocFrame> service =
            MultiService<DocFrame>(DocFrame.fromJsonModel, apiName: 'DocFrame');
        await service.update(value);
        List<DocFrame>? list =
            await service.get(QueryModel(id: item.id!.toString()));
        if (list != null) {
          //DataFrame itemReloaded = list[0];
          //prefs!.setString(userInfoSetting, jsonEncode(itemReloaded.toJson()));

          try {
            var bloc = BlocProvider.of<ServerDataBloc<DocFrame>>(
                navigationScreenKey!.currentContext!);

            bloc.add(const ServerDataEvent<DocFrame>(
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

  static Future<DocFrame?> openNewAndSave(context) async {
    DocFrame? value;
    try {
      value = await openNew(context);
      if (value != null) {
        MultiService<DocFrame> service = MultiService<DocFrame>(
            DataFrame.fromJsonModel,
            apiName: 'DocFrame');
        var list = await service.add(value);
        //List<DataFrame>? list =
        //await service.get(QueryModel(result.id!.toString()));
        if (list != null) {
          //DataFrame itemReloaded = list[0];
          //prefs!.setString(userInfoSetting, jsonEncode(itemReloaded.toJson()));

          try {
            var bloc = BlocProvider.of<ServerDataBloc<DocFrame>>(
                navigationScreenKey!.currentContext!);

            bloc.add(const ServerDataEvent<DocFrame>(
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

  static dynamic delete(context, List<DocFrame> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare i data frames selezionati?',
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
