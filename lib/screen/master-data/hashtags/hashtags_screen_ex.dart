import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/hashtag.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtag_global.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'hashtag_edit_screen.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class HashTagsScreen extends StatefulWidget {
  const HashTagsScreen(
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
  _HashTagsScreenState createState() => _HashTagsScreenState();
}

class _HashTagsScreenState extends State<HashTagsScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<HashTag>(
      keyName: 'hashTagId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          repoName: "HashTags",
          title: widget.title,
          useIntrinsicRowHeight: true,
          addButtonToolTipText: "Aggiungi hashtag",
          deleteButtonToolTipText: "Elimina hashtag selezionati",
          columns: [
            DataScreenColumnConfiguration(
                id: 'name',
                label: 'Etichetta',
                labelType: LabelType.itemValue,
                customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.useProvidedTextStyle,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
                onRenderRowField: (dynamic item, {bool? forList}) {
                  return Builder(
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        controller: ScrollController(),
                        key: ValueKey(item),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: IgnorePointer(
                              child: getHashTagItem(
                                  tag: item,
                                  selected: () {
                                    return false;
                                  },
                                  onSelected: (selected) {}),
                            )),
                      );
                    },
                  );
                }),
            DataScreenColumnConfiguration(
              id: 'description',
              label: 'Descrizione',
              labelType: LabelType.subItemValue,
            ),
          ].toList(),
          menu: widget.menu),
      openNew: HashTagsActions.openNew,
      openDetail: HashTagsActions.openDetail,
      delete: HashTagsActions.delete,
    );
  }
}

class HashTagsActions {
  static Future<HashTag?> openNewAndSave(context) async {
    HashTag? value;
    try {
      value = await openNew(context);
      MultiService<HashTag> service =
          MultiService<HashTag>(HashTag.fromJsonModel, apiName: 'HashTag');
      await service.add(value!);
    } catch (e) {
      debugPrint(e.toString());
    }
    return value;
  }

  static Future openNew(context) async {
    final GlobalKey<HashTagEditFormState> formKey =
        GlobalKey<HashTagEditFormState>(debugLabel: "formKey");

    var result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: HashTagEditForm(
                  key: formKey, element: null, title: "Nuovo hashtag"));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic openDetail(context, HashTag item) async {
    final GlobalKey<HashTagEditFormState> formKey =
        GlobalKey<HashTagEditFormState>(debugLabel: "formKey");
    var result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: HashTagEditForm(
                  key: formKey, element: item, title: "Modifica hashtag"));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic delete(context, List<HashTag> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare gli hashtag selezionati?',
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
