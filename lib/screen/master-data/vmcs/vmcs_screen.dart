import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagrid/data_grid_selection_column.dart';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_accessory.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_engine.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_physics_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_selection.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_separator.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/vmc_file.dart';
import 'package:dpicenter/models/server/vmc_production.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/models/server/vmc_type_enum.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/vmcs/vmc_edit_screen.dart';
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

class VmcsScreen extends StatefulWidget {
  const VmcsScreen(
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
  _VmcsScreenState createState() => _VmcsScreenState();
}

class _VmcsScreenState extends State<VmcsScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<Vmc>(
      keyName: 'vmcId',
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          useIntrinsicRowHeight: false,
          repoName: "Vmcs",
          title: widget.title,
          addButtonToolTipText: "Aggiungi modello macchina",
          deleteButtonToolTipText: "Elimina modelli selezionati",
          columns: [
            codeColumn(),
            descriptionColumn(),
            typeColumn(),
          ].toList(),
          menu: widget.menu),
      openNew: VmcsActions.openNew,
      openDetail: VmcsActions.openDetail,
      delete: VmcsActions.delete,
      onAdd: VmcsActions.onAdd,
      onUpdate: VmcsActions.onUpdate,
    );
  }

  DataScreenColumnConfiguration codeColumn() {
    return DataScreenColumnConfiguration(
      id: 'code',
      label: 'Codice',
      labelType: LabelType.itemValue,
    );
  }

  DataScreenColumnConfiguration descriptionColumn() {
    return DataScreenColumnConfiguration(
      id: 'description',
      label: 'Descrizione',
      labelType: LabelType.itemValue,
    );
  }

  DataScreenColumnConfiguration typeColumn() {
    return DataScreenColumnConfiguration(
        id: 'vmcType',
        label: 'Tipo',
        labelType: LabelType.itemValue,
        itemAsString: (dynamic item) =>
            getTypeString((item as Vmc).vmcType ?? VmcTypeEnum.vendingMachine),
        customSizer: ColumnSizerRule(
            ruleType: ColumnSizerRuleType.recalculateCellValue,
            recalculateCellValue: (value) {
              return ColumnSizerRecalculateResult(
                  result: const Text("0000000000"));
            }),
        dropdownBuilder: (context, List<dynamic> list) {
          List<Widget> selected = <Widget>[];
          for (var item in list) {
            selected.add(
              IgnorePointer(
                child: DataGridColumnSelectionState.getFilterChip(
                    text: getTypeString(VmcTypeEnum.values[item]),
                    selected: () {
                      return false;
                    },
                    onSelected: (value) {},
                    context: context),
              ),
            );
          }

          if (selected.isNotEmpty) {
            return DataGridColumnSelectionState.getContainerRow(
                context, selected);
          } else {
            return DataGridColumnSelectionState.getEmptySelectionText(context);
          }
        },
        popupItemBuilder: (BuildContext context, item, bool isSelected) {
          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            title: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child:
                        Text(getTypeString(VmcTypeEnum.values[item as int])))),
          );
        },
        customFilter: (dynamic searchValue, dynamic item) {
          if (searchValue is List && searchValue.isNotEmpty) {
            if (item is Vmc) {
              String toShow =
                  getTypeString(item.vmcType ?? VmcTypeEnum.vendingMachine);
              return searchValue
                  .map((e) => getTypeString(VmcTypeEnum.values[e]))
                  .contains(toShow);
            }
          }
          return true;
        },
        filterType: MultiFilterType.selection,
        //onQueryRowColor: (item) => onQueryRowColor(context, item as Report),
        onRenderRowField: (item, {bool? forList}) {
          String toShow = '';
          if (item is Vmc) {
            toShow = getTypeString(item.vmcType ?? VmcTypeEnum.vendingMachine);
          }

          return Builder(
            builder: (BuildContext context) {
/*                    var screen = DataScreenState.of(context);

                   var element = screen
                            .adapter!.listLocale![rendererContext.row!.sortIdx!]
                        as DataEventLog;*/
              if (forList ?? false) {
                return itemDataCustom(
                    Text(toShow, style: itemMiniSubtitleStyle()),
                    label: 'Stato');
              } else {
                return DefaultDataSource.getText(toShow, null);
              }

              /*  return Align(
                    alignment: Alignment.centerLeft, child: Text(toShow));*/
            },
          );
        });
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload> vmcWidthMmColumn() {
    return DataScreenColumnConfiguration<JsonPayload, JsonPayload>(
      id: 'vmcPhysicsConfiguration.vmcWidthMm',
      label: 'Larghezza',
      filterType: MultiFilterType.selection,
      labelType: LabelType.miniItemValue,
      /*itemAsString: (dynamic item) =>
          (item as VmcPhysicsConfiguration).vmcWidthMm.toString().trim() + 'bella li',*/
    );
  }

  DataScreenColumnConfiguration vmcHeightMmColumn() {
    return DataScreenColumnConfiguration(
      id: 'vmcPhysicsConfiguration.vmcHeightMm',
      label: 'Altezza',
      labelType: LabelType.miniItemValue,
    );
  }

  DataScreenColumnConfiguration drawerHeightColumn() {
    return DataScreenColumnConfiguration(
      id: 'vmcPhysicsConfiguration.drawerHeight',
      label: 'Altezza cassetto',
      labelType: LabelType.miniItemValue,
    );
  }

  DataScreenColumnConfiguration contentHeightColumn() {
    return DataScreenColumnConfiguration(
      id: 'vmcPhysicsConfiguration.contentHeight',
      label: 'Altezza singola',
      labelType: LabelType.miniItemValue,
    );
  }

  DataScreenColumnConfiguration contentWidthColumn() {
    return DataScreenColumnConfiguration(
      id: 'vmcPhysicsConfiguration.contentWidth',
      label: 'Largezza singola',
      labelType: LabelType.miniItemValue,
    );
  }

  String getTypeString(VmcTypeEnum value) {
    switch (value.index) {
      case 0:
        return 'Distributore';
      case 1:
        return 'Altro';

      default:
        return 'Sconosciuto';
    }
  }
}

class VmcsActions {
  static Future openNew(context) async {
    final GlobalKey<VmcEditFormState> formKey =
    GlobalKey<VmcEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              insetPadding: isTinyWidth(context)
                  ? const EdgeInsets.symmetric(horizontal: 0)
                  : const EdgeInsets.symmetric(horizontal: 50),
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: MultiBlocProvider(
                providers: [
                  BlocProvider<ServerDataBloc<VmcSettingField>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<VmcSettingField>(
                        repo: MultiService<VmcSettingField>(
                            VmcSettingField.fromJson,
                            apiName: 'VmcSettingField')),
                  ),
                  BlocProvider<ServerDataBloc<VmcProductionField>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<VmcProductionField>(
                        repo: MultiService<VmcProductionField>(
                            VmcProductionField.fromJson,
                            apiName: 'VmcProductionField')),
                  ),
                ],
                child: VmcEditForm(
                    key: formKey,
                    element: null,
                    title: "Nuovo modello macchina"),
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic openDetail(context, Vmc item) async {
    final GlobalKey<VmcEditFormState> formKey =
    GlobalKey<VmcEditFormState>(debugLabel: "formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              insetPadding: isTinyWidth(context)
                  ? const EdgeInsets.symmetric(horizontal: 0)
                  : const EdgeInsets.symmetric(horizontal: 50),
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: MultiBlocProvider(
                providers: [
                  BlocProvider<ServerDataBloc<VmcSettingField>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<VmcSettingField>(
                        repo: MultiService<VmcSettingField>(
                            VmcSettingField.fromJson,
                            apiName: 'VmcSettingField')),
                  ),
                  BlocProvider<ServerDataBloc<VmcProductionField>>(
                    lazy: false,
                    create: (context) => ServerDataBloc<VmcProductionField>(
                        repo: MultiService<VmcProductionField>(
                            VmcProductionField.fromJson,
                            apiName: 'VmcProductionField')),
                  ),
                ],
                child: VmcEditForm(
                    key: formKey,
                    element: item,
                    title: "Modifica modello macchina"),
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static dynamic editItem(GlobalKey<VmcEditFormState> key, Vmc item,
      {bool saveDirectly = false, String? selectedCategory}) {
    return multiDialog(
        onWillPop: () async {
          return await onWillPop(key);
        },
        content: MultiBlocProvider(
          providers: [
            BlocProvider<ServerDataBloc<VmcSettingField>>(
              lazy: false,
              create: (context) => ServerDataBloc<VmcSettingField>(
                  repo: MultiService<VmcSettingField>(VmcSettingField.fromJson,
                      apiName: 'VmcSettingField')),
            ),
            BlocProvider<ServerDataBloc<VmcProductionField>>(
              lazy: false,
              create: (context) => ServerDataBloc<VmcProductionField>(
                  repo: MultiService<VmcProductionField>(
                      VmcProductionField.fromJson,
                      apiName: 'VmcProductionField')),
            ),
          ],
          child: VmcEditForm(
              key: key,
              element: item,
              saveDirectly: true,
              title: "Modifica modello macchina"),
        ));
  }

  static dynamic openDetailAndSave(context, Vmc item,
      {String? selectedCategory}) async {
    final GlobalKey<VmcEditFormState> formKey =
        GlobalKey<VmcEditFormState>(debugLabel: "formKey");

    Vmc itemCopy = cloneVmc(item);
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return editItem(formKey, itemCopy,
              saveDirectly: true, selectedCategory: selectedCategory);
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static Vmc cloneVmc(Vmc item) {
    return item.copyWith(
      vmcPhysicsConfiguration: item.vmcPhysicsConfiguration?.copyWith(),
      vmcConfiguration: item.vmcConfiguration?.copyWith(),
      vmcEngines: item.vmcEngines?.map((e) => e.copyWith()).toList(),
      vmcAccessory: item.vmcAccessory?.map((e) => e.copyWith()).toList(),
      vmcProductions: item.vmcProductions?.map((e) => e.copyWith()).toList(),
      vmcSettings: item.vmcSettings?.map((e) => e.copyWith()).toList(),
      vmcFiles: item.vmcFiles
          ?.map((e) => e.copyWith(file: e.file?.copyWith()))
          .toList(),
      vmcSelections: item.vmcSelections?.map((e) => e.copyWith()).toList(),
      vmcSeparators: item.vmcSeparators?.map((e) => e.copyWith()).toList(),
    );
  }

  static dynamic delete(context, List<Vmc> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare i modelli selezionati?',
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

  static dynamic onAdd(Bloc bloc, ServerDataEvent event, Emitter emit) async {
    MultiService<Media> picturesService =
        MultiService<Media>(Media.fromJsonModel, apiName: "Media");
    MultiService<Vmc> itemsService =
        MultiService<Vmc>(Vmc.fromJsonModel, apiName: "Vmc");
    if (event.item is Vmc && event.item.vmcFiles != null) {
      emit(ServerDataLoading<Vmc>(event: event));
      Vmc item = event.item;

      for (int index = 0; index < item.vmcFiles!.length; index++) {
        /// mediaId == -1 -> cancellato
        /// mediaId == 0 -> nuovo
        /// mediaId >= 1 -> già inserito
        ///
        VmcFile itemFile = item.vmcFiles![index];
        if (itemFile.mediaId == 0 && itemFile.file != null) {
          ///solo le immagini nuove
          ///
          ///codifica in base64
          String? encoded = await encodeBase64(itemFile.file!.bytes!);
          if (encoded != null) {
            itemFile = itemFile.copyWith(
                file: itemFile.file?.copyWith(
                    content: encoded, mediaId: itemFile.file?.mediaId ?? 0));
          }

          ///TODO: rivedere pictureService per renderlo mediaService
          var result = await picturesService.add(itemFile.file!);
          if (result != null && result.isNotEmpty) {
            emit(ServerDataLoading<Vmc>(event: event));
            debugPrint(
                "Salvataggio file ${result[0].mediaId.toString()} riuscito");
            item.vmcFiles![index] =
                itemFile.copyWith(mediaId: result[0].mediaId, file: null);
          }
        }
      }
      var result = await itemsService.add(item);

      if (result != null && result.isNotEmpty) {
        emit(ServerDataAdded<Vmc>(event: event, item: result[0]));
        return result;
      }
    }
  }

  static dynamic onUpdate(
      Bloc bloc, ServerDataEvent event, Emitter emit) async {
    MultiService<Media> picturesService =
        MultiService<Media>(Media.fromJsonModel, apiName: "Media");
    MultiService<Vmc> itemsService =
        MultiService<Vmc>(Vmc.fromJsonModel, apiName: "Vmc");

    if (event.item is Vmc && event.item.vmcFiles != null) {
      emit(ServerDataLoading<Vmc>(event: event));
      Vmc item = event.item;

      //List<ItemPicture> toRemove=<ItemPicture>[];

      for (int index = 0; index < item.vmcFiles!.length; index++) {
        /// mediaId == -1 -> cancellato
        /// mediaId == 0 -> nuovo
        /// mediaId >= 1 -> già inserito
        ///
        VmcFile itemFile = item.vmcFiles![index];
        switch (itemFile.mediaId) {
          case -1: //da eliminare
            ///vado a rimuovere itemPicture.pictureId dalla tabella Pictures
            ///questa azione rimuoverà anche l'itemPicture dalla tabella itemPictures
            //toRemove.add(itemPicture);
            await picturesService.deleteList(<Media>[itemFile.file!]);

            break;
          case 0: //nuovo
            ///codifica in base64
            String? encoded = await encodeBase64(itemFile.file!.bytes!);
            if (encoded != null) {
              itemFile = itemFile.copyWith(
                  file: itemFile.file?.copyWith(
                      content: encoded, mediaId: itemFile.file?.mediaId ?? 0));
            }

            ///TODO Aggiornare pictureService e farlo diventare mediaService
            var result = await picturesService.add(itemFile.file!);
            if (result != null && result.isNotEmpty) {
              emit(ServerDataLoading<Vmc>(event: event));
              debugPrint(
                  "Salvataggio file ${result[0].mediaId.toString()} riuscito");
              item.vmcFiles![index] =
                  itemFile.copyWith(mediaId: result[0].mediaId, file: null);
            }
            break;

          default: //già inserito
            ///per ora non faccio nulla, successivamente vorrei gestire un campo descrizione
            break;
        }
      }

      ///rimuovo le picture dall'items (non ho bisogno di reinviarle al server)
      List<VmcFile> newList = <VmcFile>[];
      for (VmcFile itemFile in item.vmcFiles!) {
        if (itemFile.mediaId != -1) {
          ///solo i file non cancellati
          newList.add(itemFile.copyWith(vmcId: item.vmcId, file: null));
        }
      }
      item = item.copyWith(vmcFiles: newList);
      //item = item.copyWith(itemPictures: item.itemPictures!.map((e) => e.copyWith(itemId: item.itemId, picture: null)).toList(growable: false));
      var result = await itemsService.update(item);

      if (result != null && result.isNotEmpty) {
        emit(ServerDataAdded<Vmc>(event: event, item: result[0]));
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
