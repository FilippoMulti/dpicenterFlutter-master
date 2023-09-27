import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/item_category.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/master-data/items/item_edit_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class ItemsScreen extends StatefulWidget {
  const ItemsScreen(
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
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<Item>(
      keyName: 'itemId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          useIntrinsicRowHeight: true,
          repoName: "Items",
          title: widget.title,
          addButtonToolTipText: "Aggiungi articolo",
          deleteButtonToolTipText: "Elimina articolo",
          columns: [
            DataScreenColumnConfiguration(
                id: 'code', label: 'Codice', labelType: LabelType.itemValue),
            DataScreenColumnConfiguration(
                id: 'description',
                label: 'Descrizione',
                labelType: LabelType.itemValue),
            DataScreenColumnConfiguration(
                id: 'barcode',
                label: 'Barcode',
                labelType: LabelType.miniItemValue),
            itemCategoryColumnConfiguration(),
          ].toList(),
          menu: widget.menu),
      openNew: ItemsActions.openNew,
      openDetail: ItemsActions.openDetail,
      delete: ItemsActions.delete,
      onAdd: ItemsActions.onAdd,
      onUpdate: ItemsActions.onUpdate,
    );
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload>
      itemCategoryColumnConfiguration() {
    return DataScreenColumnConfiguration(
        id: 'itemCategory.description',
        label: 'Categoria',
        labelType: LabelType.miniItemValue,
        filterType: MultiFilterType.selection,
        itemAsString: (dynamic item) => (item as ItemCategory).description);
  }



}

class ItemsActions {
  static Future openNew(context) async {
    final GlobalKey<ItemEditFormState> formKey =
        GlobalKey<ItemEditFormState>(debugLabel: "_formKey");

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
                  BlocProvider<ServerDataBloc<ItemCategory>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<ItemCategory>(
                        repo: MultiService<ItemCategory>(
                            ItemCategory.fromJsonModel,
                            apiName: "ItemCategory")),
                  ),
                  BlocProvider<ServerDataBloc<Media>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<Media>(
                        repo: MultiService<Media>(Media.fromJsonModel,
                            apiName: "Media")),
                  ),
                  BlocProvider<PictureBloc>(
                    lazy: false,
                    create: (context) => PictureBloc(),
                  ),
                ],
                child: ItemEditForm(
                    key: formKey, element: null, title: "Nuovo articolo"),
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic openDetail(context, Item item) async {
    final GlobalKey<ItemEditFormState> formKey =
        GlobalKey<ItemEditFormState>(debugLabel: "formKey");

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
                    BlocProvider<ServerDataBloc<ItemCategory>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<ItemCategory>(
                          repo: MultiService<ItemCategory>(
                              ItemCategory.fromJsonModel,
                              apiName: "ItemCategory")),
                    ),
                    BlocProvider<ServerDataBloc<Media>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<Media>(
                          repo: MultiService<Media>(Media.fromJsonModel,
                              apiName: "Picture")),
                    ),
                    BlocProvider<PictureBloc>(
                      lazy: false,
                      create: (context) => PictureBloc(),
                    ),
                  ],
                  child: ItemEditForm(
                      key: formKey,
                      element: item,
                      title: "Modifica articolo")));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic delete(context, List<Vmc> items) async {
    /*var result = await showDialog(
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
    return result;*/
  }

  static dynamic onAdd(Bloc bloc, ServerDataEvent event, Emitter emit) async {
    MultiService<Media> picturesService =
        MultiService<Media>(Media.fromJsonModel, apiName: "Media");
    MultiService<Item> itemsService =
        MultiService<Item>(Item.fromJsonModel, apiName: "Item");
    if (event.item is Item && event.item.itemPictures != null) {
      emit(ServerDataLoading<Item>(event: event));
      Item item = event.item;

      for (int index = 0; index < item.itemPictures!.length; index++) {
        /// mediaId == -1 -> cancellato
        /// mediaId == 0 -> nuovo
        /// mediaId >= 1 -> già inserito
        ///
        ItemPicture itemPicture = item.itemPictures![index];
        if (itemPicture.mediaId == 0 && itemPicture.picture != null) {
          ///solo le immagini nuove
          ///
          ///codifica in base64
          String? encoded = await encodeBase64(itemPicture.picture!.bytes!);
          if (encoded != null) {
            itemPicture = itemPicture.copyWith(
                picture: itemPicture.picture?.copyWith(
                    content: encoded,
                    mediaId: itemPicture.picture?.mediaId ?? 0));
          }

          var result = await picturesService.add(itemPicture.picture!);
          if (result != null && result.isNotEmpty) {
            emit(ServerDataLoading<Item>(event: event));
            debugPrint(
                "Salvataggio picture ${result[0].mediaId.toString()} riuscito");
            item.itemPictures![index] =
                itemPicture.copyWith(mediaId: result[0].mediaId, picture: null);
          }
        }
      }
      var result = await itemsService.add(item);

      if (result != null && result.isNotEmpty) {
        emit(ServerDataAdded<Item>(event: event, item: result[0]));
        return result;
      }
    }
  }

  static dynamic onUpdate(
      Bloc bloc, ServerDataEvent event, Emitter emit) async {
    MultiService<Media> mediaService =
        MultiService<Media>(Media.fromJsonModel, apiName: "Media");
    MultiService<Item> itemsService =
        MultiService<Item>(Item.fromJsonModel, apiName: "Item");

    if (event.item is Item && event.item.itemPictures != null) {
      emit(ServerDataLoading<Item>(event: event));
      Item item = event.item;

      //List<ItemPicture> toRemove=<ItemPicture>[];

      for (int index = 0; index < item.itemPictures!.length; index++) {
        /// mediaId == -1 -> cancellato
        /// mediaId == 0 -> nuovo
        /// mediaId >= 1 -> già inserito
        ///
        ItemPicture itemPicture = item.itemPictures![index];
        switch (itemPicture.mediaId) {
          case -1: //da eliminare
            ///vado a rimuovere itemPicture.pictureId dalla tabella Pictures
            ///questa azione rimuoverà anche l'itemPicture dalla tabella itemPictures
            //toRemove.add(itemPicture);
            await mediaService.deleteList(<Media>[itemPicture.picture!]);

            break;
          case 0: //nuovo
            ///codifica in base64
            String? encoded = await encodeBase64(itemPicture.picture!.bytes!);
            if (encoded != null) {
              itemPicture = itemPicture.copyWith(
                  picture: itemPicture.picture?.copyWith(
                      content: encoded,
                      mediaId: itemPicture.picture?.mediaId ?? 0));
            }

            var result = await mediaService.add(itemPicture.picture!);
            if (result != null && result.isNotEmpty) {
              emit(ServerDataLoading<Item>(event: event));
              debugPrint(
                  "Salvataggio picture ${result[0].mediaId.toString()} riuscito");
              item.itemPictures![index] = itemPicture.copyWith(
                  mediaId: result[0].mediaId, picture: null);
            }
            break;

          default: //già inserito
            ///per ora non faccio nulla, successivamente vorrei gestire un campo descrizione
            break;
        }
      }

      ///rimuovo le picture dall'items (non ho bisogno di reinviarle al server)
      List<ItemPicture> newList = <ItemPicture>[];
      for (ItemPicture itemPicture in item.itemPictures!) {
        if (itemPicture.mediaId != -1) {
          ///solo le immagini non cancellate
          newList.add(itemPicture.copyWith(itemId: item.itemId, picture: null));
        }
      }
      item = item.copyWith(itemPictures: newList);
      //item = item.copyWith(itemPictures: item.itemPictures!.map((e) => e.copyWith(itemId: item.itemId, picture: null)).toList(growable: false));
      var result = await itemsService.update(item);

      if (result != null && result.isNotEmpty) {
        emit(ServerDataAdded<Item>(event: event, item: result[0]));
        return result;
      }
    }
  }

  static Future<String?>? encodeBase64(Uint8List bytes) {
    try {
      return compute(base64Encode, bytes);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
