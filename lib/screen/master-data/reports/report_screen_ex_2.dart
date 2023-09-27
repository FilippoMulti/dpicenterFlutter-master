import 'dart:convert';

import 'package:dpicenter/blocs/image_gallery_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagrid/data_grid_selection_column.dart';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/application_user_detail.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/hashtag.dart';
import 'package:dpicenter/models/server/intervention_cause.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:dpicenter/models/server/report_detail_hashtag.dart';
import 'package:dpicenter/models/server/report_detail_image.dart';
import 'package:dpicenter/models/server/report_header_view.dart';
import 'package:dpicenter/models/server/report_user.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/application_users/application_user_item.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtag_global.dart';
import 'package:dpicenter/screen/master-data/reports/report_edit_screen.dart';
import 'package:dpicenter/screen/master-data/reports/report_edit_summary.dart';
import 'package:dpicenter/screen/widgets/app_bar.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato/gato.dart' as gato;

class ReportScreenEx extends StatefulWidget {
  const ReportScreenEx(
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
  _ReportScreenExState createState() => _ReportScreenExState();
}

class _ReportScreenExState extends State<ReportScreenEx> {
  //final ScrollController _hashTagScrollController = ScrollController(debugLabel: '_hashTagScrollController');
/*  final ScrollController _footerScrollController =
      ScrollController(debugLabel: '_footerScrollController');*/
  List<ApplicationUserDetail>? usersDetails;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //_hashTagScrollController.dispose();
    /*_footerScrollController.dispose();*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DataScreen<ReportHeaderView>(
        keyName: 'reportId',
        customBackClick: widget.customBackClick,
        configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          repoName: "Report",
          title: widget.title,
          addButtonToolTipText: "Aggiungi intervento",
          deleteButtonToolTipText: "Elimina interventi selezionati",
          useIntrinsicRowHeight: true,

          //showFooter: true,
          //footerHeight: 500,
          /*onFooterBuild: (items) {
          int totalJobs = 0;
          int totalReports = items.length;
          List<ReportFooterResult> result = <ReportFooterResult>[];
          Map<HashTag, int> inJobsMap = <HashTag, int>{};

          if (items is List<DataGridRowWithItem>) {
            for (var row in items) {
              if (row.item is Report) {
                row.item.reportDetails?.forEach((detail) {
                  totalJobs++;
                  detail.hashTags?.forEach((hashtag) {
                    if (hashtag is ReportDetailHashTag) {
                      if (hashtag.hashTag != null) {
                        int value = inJobsMap[hashtag.hashTag] ?? 0;
                        inJobsMap[hashtag.hashTag!] = value + 1;
                      }
                    }
                  });
                });
              }
            }
          }

          result = inJobsMap.entries
              .map((e) => ReportFooterResult(
              hashTag: e.key, inJobs: e.value, totalJobs: totalJobs))
              .toList();
          result.sort();
          result = result.reversed.toList(growable: false);

          if (result.isNotEmpty) {
            if (isTinyWidth(context)) {
              return _footerScreenMobile(result, totalReports);
            } else {
              return _footerScreenDesktop(result, totalReports);
            }
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Nessuna assistenza con hashtags trovata",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
        },*/
          columns: [
            creationDateColumnConfiguration(),
            customerColumnConfiguration(),
            factoriesColumnConfiguration(),
            interventionCauseColumnConfiguration(),
            statusColumnConfiguration(),
            hashTagsColumnConfiguration(),
            reportUsersColumnConfiguration(),
          ].toList(),
          menu: widget.menu,
        ),
        openNew: ReportActions.openNew,
        openDetail: ReportActions.openDetail,
        delete: ReportActions.delete,
        onAdd: (Bloc bloc, ServerDataEvent event, Emitter emit) async {
          if (bloc is ServerDataBloc) {
            if (kDebugMode) {
              print("add");
            }
            List<Report>? result;

            if (kDebugMode) {
              print("add emit ServerDataLoading");
            }
            emit(ServerDataLoading<ReportHeaderView>(event: event));
            MultiService<Report> reportService =
                MultiService<Report>(Report.fromJsonModel, apiName: 'Report');
            MultiService<ReportHeaderView> reportViewService =
                MultiService<ReportHeaderView>(ReportHeaderView.fromJsonModel,
                    apiName: 'ReportView');
            if ((event.item as ReportHeaderView).report != null) {
              result = await reportService
                  .add((event.item as ReportHeaderView).report!,
                      onSendProgress: (sent, total) {
                emit(ServerDataLoadingSendProgress<ReportHeaderView>(
                    event: event, sent: sent, total: total));
              }, onReceiveProgress: (sent, total) {
                emit(ServerDataLoadingReceiveProgress<ReportHeaderView>(
                    event: event, sent: sent, total: total));
              });

              if (result != null && result.isNotEmpty) {
                if (kDebugMode) {
                  print("add result!");
                }
                if (kDebugMode) {
                  print("add emit ServerDataAdded");
                }
              } else {
                if (kDebugMode) {
                  print("add emit ServerDataError");
                }
                emit(ServerDataError(
                    event: event,
                    error: Exception('Inserimento non riuscito!')));
                return;
              }

              if (result != null && result.isNotEmpty) {
                List<ReportHeaderView>? rowUpdated = await reportViewService
                    .get(QueryModel(id: result.first.reportId.toString()));

                if (rowUpdated != null && rowUpdated.isNotEmpty) {
                  bloc.items?.add(rowUpdated.first);
                  emit(ServerDataAdded<ReportHeaderView>(
                      event: event,
                      item: rowUpdated.first,
                      items: bloc.items as List<ReportHeaderView>));
                }
              }

              emit(ServerDataLoading<ReportHeaderView>(event: event));

              //await fetch(event, emit);
              await bloc.fetch(
                  event.copyWith(refresh: bloc.items == null), emit);
              emit(ServerDataLoaded<ReportHeaderView>(
                  items: bloc.filteredItems as List<ReportHeaderView>,
                  event: event));
              event.onDataLoaded?.call(bloc.filteredItems);

              if (event.withComplete) {
                if (kDebugMode) {
                  print(
                      "event.withComplete -> fetch emit ServerDataLoadedCompleted");
                }
                emit(ServerDataLoadedCompleted<ReportHeaderView>(
                    items: bloc.filteredItems as List<ReportHeaderView>,
                    event: event));
              }
            }
          }
        },
        onUpdate: (Bloc bloc, ServerDataEvent event, Emitter emit) async {
          if (bloc is ServerDataBloc) {
            List<Report>? result;

            if (kDebugMode) {
              print("update emit ServerDataLoading");
            }
            emit(ServerDataLoading<ReportHeaderView>(event: event));
            if (kDebugMode) {
              print("try save");
            }

            MultiService<Report> reportService =
                MultiService<Report>(Report.fromJsonModel, apiName: 'Report');
            MultiService<ReportHeaderView> reportViewService =
                MultiService<ReportHeaderView>(ReportHeaderView.fromJsonModel,
                    apiName: 'ReportView');

            if ((event.item as ReportHeaderView).report != null) {
              result = await reportService
                  .update((event.item as ReportHeaderView).report!,
                      onSendProgress: (sent, total) {
                emit(ServerDataLoadingSendProgress<ReportHeaderView>(
                    event: event, sent: sent, total: total));
              }, onReceiveProgress: (sent, total) {
                emit(ServerDataLoadingReceiveProgress<ReportHeaderView>(
                    event: event, sent: sent, total: total));
              });
              if (result != null && result.isNotEmpty) {
                if (kDebugMode) {
                  print("add result!");
                }
                if (kDebugMode) {
                  print("add emit ServerDataUpdate");
                }
              } else {
                if (kDebugMode) {
                  print("add emit ServerDataError");
                }
                emit(ServerDataError(
                    event: event,
                    error: Exception('Salvataggio non riuscito!')));
                return;
              }
/*
                  if (currentIndex!=-1) {
                    items![currentIndex] = result[0];
                  }*/
            } else {
              if (kDebugMode) {
                print("add emit ServerDataError");
              }
              emit(ServerDataError<ReportHeaderView>(
                  event: event,
                  error: Exception(
                      'Salvataggio non riuscito: il parametro item.report è null!')));
            }

            if (result != null && result.isNotEmpty) {
              List<ReportHeaderView>? rowUpdated = await reportViewService.get(
                  QueryModel(
                      id: (event.item as ReportHeaderView)
                          .reportId
                          .toString()));

              int currentIndex = -1;
              for (int index = 0; index < (bloc.items?.length ?? 0); index++) {
                var item = bloc.items![index];
                if (item is JsonPayload) {
                  if (gato.get(item.json, event.keyName ?? '') ==
                      gato.get((result[0] as JsonPayload).json,
                          event.keyName ?? '')) {
                    currentIndex = index;
                    break;
                  }
                }
              }
              if (currentIndex != -1) {
                if (rowUpdated != null && rowUpdated.isNotEmpty) {
                  bloc.items![currentIndex] =
                      rowUpdated.first.copyWith(report: result.first);
                }
              }
              emit(ServerDataUpdated<ReportHeaderView>(
                  event: event,
                  item: bloc.items![currentIndex],
                  items: bloc.items as List<ReportHeaderView>));
            }

            await bloc.fetch(event.copyWith(refresh: bloc.items == null), emit);

            emit(ServerDataLoaded<ReportHeaderView>(
                items: bloc.filteredItems as List<ReportHeaderView>,
                event: event));
            event.onDataLoaded?.call(bloc.filteredItems);
            if (event.withComplete) {
              if (kDebugMode) {
                print(
                    "event.withComplete -> fetch emit ServerDataLoadedCompleted");
              }
              emit(ServerDataLoadedCompleted<ReportHeaderView>(
                  items: bloc.filteredItems as List<ReportHeaderView>,
                  event: event));
            }
          }
        },
        onDelete: (Bloc bloc, ServerDataEvent event, Emitter emit) async {
          if (bloc is ServerDataBloc) {
            if (kDebugMode) {
              print("delete");
            }

            emit(ServerDataLoading<ReportHeaderView>(event: event));

            MultiService<Report> reportService =
                MultiService<Report>(Report.fromJsonModel, apiName: 'Report');
            MultiService<ReportHeaderView> reportViewService =
                MultiService<ReportHeaderView>(ReportHeaderView.fromJsonModel,
                    apiName: 'ReportView');

            List<Report> toDelete = <Report>[];
            for (ReportHeaderView item
                in event.items as List<ReportHeaderView>) {
              toDelete
                  .add(Report(reportId: item.reportId, interventionCauseId: 0));
            }
            bool? result = await reportService.deleteList(toDelete);
            if (result!) {
              emit(ServerDataDeleted<ReportHeaderView>(
                  event: event, items: event.items as List<ReportHeaderView>));
            } else {
              emit(ServerDataError<ReportHeaderView>(
                  event: event,
                  error: Exception('Cancellazione non riuscita!')));
            }

            emit(ServerDataLoading<ReportHeaderView>(event: event));

            await bloc.fetch(event, emit);
            emit(ServerDataLoaded<ReportHeaderView>(
                items: bloc.filteredItems as List<ReportHeaderView>,
                event: event));
            event.onDataLoaded?.call(bloc.filteredItems);

            if (event.withComplete) {
              if (kDebugMode) {
                print(
                    "event.withComplete -> fetch emit ServerDataLoadedCompleted");
              }
              emit(ServerDataLoadedCompleted<ReportHeaderView>(
                  items: bloc.filteredItems as List<ReportHeaderView>,
                  event: event));
            }
          }
        });
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload>
      creationDateColumnConfiguration() {
    return DataScreenColumnConfiguration(
        id: 'date',
        label: 'Data',
        labelType: LabelType.itemValue,
        columnType: DataScreenColumnType.date,
        filterType: MultiFilterType.betweenDate,
        customSizer: ColumnSizerRule(
            ruleType: ColumnSizerRuleType.recalculateCellValue,
            recalculateCellValue: (item) {
              String cellValue = item!.date!;

              return ColumnSizerRecalculateResult(
                  result: cellValue,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 24, fontWeight: FontWeight.w400));
              cellValue;
            }),
        onQueryRowColor: (item) =>
            onQueryRowColor(context, item as ReportHeaderView),
        onRenderRowField: (item, {bool? forList}) {
          String value = '';
          try {
            if (item is ReportHeaderView) {
              value = applyFormat(DateTime.parse(item.date!), 'dd/MM/yyyy')
                  .toString();
            }
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
              if (forList == null || forList == false) {
                return Center(
                  child: DefaultDataSource.getTextWithoutIntrinsic(
                      value, onQueryTextColor(item as ReportHeaderView),
                      textAlign: TextAlign.center, fontSize: 24),
                );
              } else {
                return Text(
                  value,
                  style: itemValueTextStyle(),
                );
              }
              /*return Align(
                    alignment: Alignment.centerLeft, child: Text(value));*/
            },
          );
        });
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload>
      customerColumnConfiguration() {
    return DataScreenColumnConfiguration(
        id: 'customer',
        label: 'Cliente',
        labelType: LabelType.itemValue,
        filterType: MultiFilterType.selection,
        itemAsString: (dynamic item) => (item as Customer).description ?? '',
        onQueryTextColor: (item) => onQueryTextColor(item as ReportHeaderView),
        onQueryRowColor: (item) =>
            onQueryRowColor(context, item as ReportHeaderView));
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload>
      factoriesColumnConfiguration() {
    return DataScreenColumnConfiguration(
      id: 'factories',
      label: 'Stabilimenti',
      labelType: LabelType.itemValue,
      filterType: MultiFilterType.selection,
      getItemsForFilter: (DataScreenColumnConfiguration col, List items) {
        List<String> elements = <String>[];
        for (var item in items) {
          if (item is ReportHeaderView) {
            elements.addAll(item.factories?.split('\r\n') ?? <String>[]);
          }
        }

        //distinct (rimuovo gli elementi doppi)
        List<String> distinctList = [
          ...{...elements}
        ];
        //ordino
        distinctList.sort((a, b) {
          return a.compareTo(b);
        });
        distinctList =
            distinctList.where((element) => element.isNotEmpty).toList();

        return distinctList;
      },
      autoFitPadding: const EdgeInsets.all(8.0),
      customSizer: ColumnSizerRule(
          ruleType: ColumnSizerRuleType.recalculateCellValue,
          recalculateCellValue: (item) {
            return ColumnSizerRecalculateResult(
                result: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                textStyle: Theme.of(context).textTheme.bodyLarge);

            /*  List<Customer> elements = <Customer>[];

              String cellValue = '';

              (item as Report).reportDetails?.forEach((detail) {
                if (detail.factory != null) {
                  elements.add(detail.factory!);
                }
              });
              //distinct (rimuovo gli elementi doppi)
              List distinctList = [
                ...{...elements}
              ];
              //ordino
              distinctList.sort((a, b) {
                return a.compareTo(b);
              });

              for (Customer item in distinctList) {
                cellValue += "$item\r\n";
              }
              if (distinctList.isNotEmpty) {
                cellValue = cellValue.substring(0, cellValue.length - 2);
              }

              return ColumnSizerRecalculateResult(
                  result: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                  textStyle: Theme.of(context).textTheme.bodyLarge);*/
          }),
      dropdownBuilder: (context, List<dynamic> list) {
        List<Widget> selected = <Widget>[];

        for (var item in list) {
          selected.add(
            IgnorePointer(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: DefaultDataSource.getText(item.toString(),
                      Theme.of(context).textTheme.bodyLarge!.color)),
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
                  child: item != null
                      ? DefaultDataSource.getText(
                          item ?? 'Nessun stabilimento selezionato',
                          Theme.of(context).textTheme.bodyLarge!.color)
                      : const Text("Errore"))),
        );
      },
      customFilter: (dynamic searchValue, dynamic item) {
        if (searchValue != null &&
            (searchValue as List).isNotEmpty &&
            item != null) {
          if (item is ReportHeaderView) {
            List<String> elements = <String>[];
            if (item.factories != null) {
              elements.addAll(item.factories!.split("\r\n"));
            }

            ///controlla se in searchValue è contenuto almeno un elemento presente in elements
            bool check(String value) {
              return searchValue.contains(value);
            }

            return elements.any(check);
          }
        }
        return true;
      },
      onQueryRowColor: (item) =>
          onQueryRowColor(context, item as ReportHeaderView),
      /* onRenderRowField: (item, {bool? forList}) {
          return factoriesRow(item, forList ?? false);
        }*/
    );
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload>
      interventionCauseColumnConfiguration() {
    return DataScreenColumnConfiguration(
        id: 'interventionCause',
        label: 'Causa intervento',
        labelType: LabelType.miniItemValue,
        filterType: MultiFilterType.selection,
        //itemAsString: (dynamic item) => (item as InterventionCause).cause ?? '',
        onQueryTextColor: (item) => onQueryTextColor(item as ReportHeaderView),
        onQueryRowColor: (item) =>
            onQueryRowColor(context, item as ReportHeaderView));
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload>
      statusColumnConfiguration() {
    return DataScreenColumnConfiguration(
        id: 'status',
        label: 'Stato',
        labelType: LabelType.miniItemValue,
        itemAsString: (dynamic item) =>
            getStatusString(Status.values[item.status]),
        defaultFilterValue: <int>[0, 1, 2],
        dropdownBuilder: (context, List<dynamic> list) {
          List<Widget> selected = <Widget>[];
          for (var item in list) {
            selected.add(
              IgnorePointer(
                child: DataGridColumnSelectionState.getFilterChip(
                    text: getStatusString(Status.values[item as int]),
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
                    child: Text(getStatusString(Status.values[item])))),
          );
        },
        customFilter: (dynamic searchValue, dynamic item) {
          if (searchValue is List && searchValue.isNotEmpty) {
            if (item is ReportHeaderView) {
              Status status = Status.values[item.status ?? 0];
              String toShow = getStatusString(status);
              return searchValue
                  .map((e) => getStatusString(Status.values[e as int]))
                  .contains(toShow);

              /*    .toLowerCase()
                        .contains(searchValue.toLowerCase());*/
            }
          }
          return true;
        },
        filterType: MultiFilterType.selection,
        onQueryRowColor: (item) =>
            onQueryRowColor(context, item as ReportHeaderView),
        onRenderRowField: (item, {bool? forList}) {
          String toShow = '';
          if (item is ReportHeaderView) {
            Status status = Status.values[item.status ?? 0];
            toShow = getStatusString(status);
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
                return DefaultDataSource.getText(
                    toShow, onQueryTextColor(item as ReportHeaderView));
              }

              /*  return Align(
                    alignment: Alignment.centerLeft, child: Text(toShow));*/
            },
          );
        },
        customSizer: ColumnSizerRule(
            ruleType: ColumnSizerRuleType.recalculateCellValue,
            recalculateCellValue: (value) {
              return ColumnSizerRecalculateResult(
                  result: const Text("000000000000000"));
            }));
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload>
      hashTagsColumnConfiguration() {
    return DataScreenColumnConfiguration(
        id: 'hashtags',
        label: 'HashTags',
        labelType: LabelType.miniItemValue,
        filterType: MultiFilterType.selection,
        getItemsForFilter: (DataScreenColumnConfiguration col, List items) {
          List<String> elements = <String>[];

          for (ReportHeaderView item in items) {
            elements.addAll(item.hashtags?.split("\r\n") ?? <String>[]);
          }
          //distinct (rimuovo gli elementi doppi)
          List<String> distinctList = [
            ...{...elements}
          ];
          //ordino
          distinctList.sort((a, b) {
            return a.compareTo(b);
          });
          distinctList =
              distinctList.where((element) => element.isNotEmpty).toList();

          return distinctList;
        },
        autoFitPadding: const EdgeInsets.all(32.0),
        customSizer: ColumnSizerRule(
            ruleType: ColumnSizerRuleType.recalculateCellValue,
            recalculateCellValue: (item) {
              String cellValue = '';
              int i = 0;
              List<String> hashtagList =
                  (item as ReportHeaderView).hashtags?.split("\r\n") ??
                      <String>[];

              for (String hashtag in hashtagList) {
                cellValue += '$hashtag ';
                i++;
                if (i >= 3) {
                  break;
                }
              }

              return ColumnSizerRecalculateResult(
                  result: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                  textStyle: Theme.of(context).textTheme.bodySmall);
            }),
        dropdownBuilder: (context, List<dynamic> list) {
          List<Widget> selected = <Widget>[];

          for (var item in list) {
            List<String> params = item.toString().split("|");
            HashTag tag = HashTag(
                hashTagId: int.parse(params[0]),
                name: params[1],
                color: params[2]);
            selected.add(
              IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: getHashTagItem(
                      visualDensity: VisualDensity.compact.copyWith(
                          horizontal: VisualDensity.maximumDensity,
                          vertical: VisualDensity.minimumDensity),
                      tag: tag,
                      letterSpacing: -1,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                      selected: () {
                        return false;
                      },
                      onSelected: (selected) {}),
                ),
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
          List<String> params = item.toString().split("|");
          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            title: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: item != null
                        ? getHashTagItem(
                            tag: HashTag(
                                hashTagId: int.parse(params[0]),
                                name: params[1],
                                color: params[2]),
                            selected: () {
                              return false;
                            },
                            onSelected: (value) {})
                        : const Text("Errore"))),
          );
        },
        customFilter: (dynamic searchValue, dynamic item) {
          if (searchValue != null &&
              (searchValue as List).isNotEmpty &&
              item != null) {
            if (item is ReportHeaderView) {
              List<String> elements = <String>[];
              if (item.hashtags != null) {
                elements.addAll(item.hashtags?.split("\r\n") ?? <String>[]);
              }

              ///controlla se in searchValue è contenuto almeno un elemento presente in elements
              bool check(String value) {
                return searchValue.contains(value);
              }

              return elements.any(check);
            }
          }
          return true;
        },
        onQueryRowColor: (item) =>
            onQueryRowColor(context, item as ReportHeaderView),
        onRenderRowField: (item, {bool? forList}) {
          if (forList ?? false) {
            return itemDataCustom(hashTagRow(item), label: 'Hashtags');
          }
          return hashTagRow(item);
        });
  }

  DataScreenColumnConfiguration<JsonPayload, JsonPayload>
      reportUsersColumnConfiguration() {
    return DataScreenColumnConfiguration(
        id: 'reportUsers',
        label: 'Operatori',
        labelType: LabelType.miniItemValue,
        allowSorting: false,
        filterType: MultiFilterType.selection,
        getItemsForFilter: (DataScreenColumnConfiguration col, List items) {
          List<String> elements = <String>[];

          for (var item in items) {
            if (item is ReportHeaderView && item.reportUsers != null) {
              elements.addAll(item.reportUsers!.split("\r\n"));
            }
          }
          List<String> distinctList = [
            ...{...elements}
          ];
          //ordino
          distinctList.sort((a, b) {
            return a.compareTo(b);
          });
          distinctList =
              distinctList.where((element) => element.isNotEmpty).toList();

          //elements = loadOperatorsImage(elements);
          return elements;
        },
        autoFitPadding: const EdgeInsets.all(32.0),
        customSizer: ColumnSizerRule(
            ruleType: ColumnSizerRuleType.recalculateCellValue,
            recalculateCellValue: (item) {
              List<String> elements = <String>[];

              if (item is ReportHeaderView && item.reportUsers != null) {
                elements.addAll(item.reportUsers!.split("\r\n"));
              }

              String cellValue = '';
              for (var detail in elements) {
                cellValue += '$detail ';
              }

              return ColumnSizerRecalculateResult(
                  result: cellValue,
                  textStyle: Theme.of(context).textTheme.bodySmall);
            }),
        dropdownBuilder: (context, List<dynamic> list) {
          //list = loadOperatorsImage(list);
          List<Widget> selected = <Widget>[];
          int i = 0;
          for (var item in list) {
            List<String> params = item.toString().split("|");
            ApplicationUser user = ApplicationUser(
                applicationUserId: int.parse(params[0]),
                surname: params[2],
                name: params[1],
                userName: params[3]);

            i++;
            selected.add(
              IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: ApplicationUserItem(
                      key: ValueKey(item),
                      visualDensity: VisualDensity.compact.copyWith(
                          horizontal: VisualDensity.maximumDensity,
                          vertical: VisualDensity.minimumDensity),
                      user: user,
                      letterSpacing: -1,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                      selected: () {
                        return false;
                      },
                      onSelected: (selected) {}),
                ),
              ),
            );
          }

          if (selected.isNotEmpty) {
            return DataGridColumnSelectionState.getContainerRow(
                context, selected,
                key: ValueKey(selected.hashCode));
          } else {
            return DataGridColumnSelectionState.getEmptySelectionText(context);
          }
        },
        popupItemBuilder: (BuildContext context, item, bool isSelected) {
          List<String> params = item.toString().split("|");
          ApplicationUser user = ApplicationUser(
              applicationUserId: int.parse(params[0]),
              surname: params[2],
              name: params[1],
              userName: params[3]);

          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            title: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: item != null
                        ? ApplicationUserItem(
                            user: user,
                            selected: () {
                              return false;
                            },
                            onSelected: (value) {})
                        : const Text("Errore"))),
          );
        },
        customFilter: (dynamic searchValue, dynamic item) {
          if (searchValue != null &&
              (searchValue as List).isNotEmpty &&
              item != null) {
            if (item is ReportHeaderView && item.reportUsers != null) {
              List<String> elements = <String>[];
              elements.addAll(item.reportUsers!.split("\r\n"));

              ///controlla se in searchValue è contenuto almeno un elemento presente in elements
              bool check(String value) => searchValue.contains(value);
              return elements.any(check);
            }
          }
          return true;
        },
        onQueryRowColor: (item) =>
            onQueryRowColor(context, item as ReportHeaderView),
        onRenderRowField: (item, {bool? forList}) {
          if (forList ?? false) {
            return itemDataCustom(operatorsRow(item), label: 'Operatori');
          }
          return operatorsRow(item);
        });
  }

  List<ApplicationUser> loadOperatorsImage(List items) {
    items = items
        .map((e) => e.copyWith(
            userDetails: e.userDetails
                ?.map((e) => e.copyWith(
                    imageProvider: e.image != null
                        ? Image.memory(base64Decode(e.image!),
                                filterQuality: FilterQuality.medium)
                            .image
                        : null))
                .toList()))
        .toList();

    return items as List<ApplicationUser>;
  }

  List<Widget> _getFooterHeader(int jobsCount, int reportsCount) {
    return [
      Text(
        'PERCENTUALI',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.start,
      ),
      Text(
        'utilizzo HashTags',
        style: Theme.of(context).textTheme.titleSmall,
        textAlign: TextAlign.start,
      ),
      RichText(
          text: TextSpan(
              text: 'Basato su ',
              style: Theme.of(context).textTheme.titleSmall,
              children: [
            TextSpan(
                text: '$jobsCount',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary)),
            TextSpan(
              text: ' lavori eseguiti in ',
              style: Theme.of(context).textTheme.titleSmall!,
            ),
            TextSpan(
                text: '$reportsCount',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary)),
            TextSpan(
              text: ' interventi trovati',
              style: Theme.of(context).textTheme.titleSmall!,
            )
          ])),
    ];
  }

/*  Widget _footerScreenDesktop(
      List<ReportFooterResult> result, int totalReports) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Container(
        decoration: BoxDecoration(
            color: isDarkTheme(context) ? Colors.white12 : Colors.black12,
            borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
            controller: _footerScrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ..._getFooterHeader(
                      result.isNotEmpty ? result[0].totalJobs : 0,
                      totalReports),
                  const SizedBox(
                    height: 16,
                  ),
                  ...List.generate(
                    result.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: getHashTagItem(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 2.0),
                            labelPadding: EdgeInsets.zero,
                            tag: result[index].hashTag,
                            selected: () => false,
                            onSelected: (value) =>
                                false, */ /*fontSize: 16.0 + result[index].inJobs*10*/ /*
                          )),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: FAProgressBar(
                                      animatedDuration:
                                          const Duration(milliseconds: 1000),
                                      maxValue: 100,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      progressColor:
                                          Theme.of(context).colorScheme.primary,
                                      currentValue:
                                          result[index].inJobsPercentage,
                                      //displayText: '%',
                                      //minHeight: 30,
                                    )),
                                */ /*LinearProgressIndicator(
                                      value:
                                          result[index].inJobsPercentage / 100,
                                      minHeight: 30,
                                    )),*/ /*
                                Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 30),
                                  alignment: Alignment.center,
                                  child: Stack(children: [
                                    Text(
                                        '${result[index].inJobsPercentage.round().toString()}%',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: hashTagTextStyleStandardStroke(
                                            isDarkTheme(context)
                                                ? Colors.black
                                                : Colors.white,
                                            strokeWidth: 2)),
                                    Text(
                                      '${result[index].inJobsPercentage.round().toString()}%',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: hashTagTextStyleStandard(
                                          isDarkTheme(context)
                                              ? Colors.black
                                              : Colors.white),
                                    )
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    */ /*Row(
                          children: [
                            getHashTagItem(tag: result[index].hashTag, selected: ()=>false, onSelected: (value) => false),
                            //Text(result[index].inJobsPercentage.toString()),
                          ],
                        )*/ /*
                  ),
                ],
              ),
            )),
      ),
    );
  }*/

/*  Widget _footerScreenMobile(List result, int totalReports) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Container(
        decoration: BoxDecoration(
            color: isDarkTheme(context) ? Colors.white12 : Colors.black12,
            borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
            controller: _footerScrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ..._getFooterHeader(
                      result.isNotEmpty ? result[0].totalJobs : 0,
                      totalReports),
                  const SizedBox(
                    height: 16,
                  ),
                  ...List.generate(
                    result.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                              child: getHashTagItem(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 2.0),
                            labelPadding: EdgeInsets.zero,
                            tag: result[index].hashTag,
                            selected: () => false,
                            onSelected: (value) =>
                                false, */ /*fontSize: 16.0 + result[index].inJobs*10*/ /*
                          )),
                          const SizedBox(
                            height: 16,
                          ),
                          Flexible(
                            child: Stack(
                              children: [
                                Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: FAProgressBar(
                                      animatedDuration:
                                          const Duration(milliseconds: 1000),
                                      maxValue: 100,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      progressColor:
                                          Theme.of(context).colorScheme.primary,
                                      currentValue:
                                          result[index].inJobsPercentage,
                                      //displayText: '%',
                                      //minHeight: 30,
                                    )),
                                */ /*LinearProgressIndicator(
                                      value:
                                          result[index].inJobsPercentage / 100,
                                      minHeight: 30,
                                    )),*/ /*
                                Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 30),
                                  alignment: Alignment.center,
                                  child: Stack(children: [
                                    Text(
                                        '${result[index].inJobsPercentage.round().toString()}%',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: hashTagTextStyleStandardStroke(
                                            isDarkTheme(context)
                                                ? Colors.black
                                                : Colors.white,
                                            strokeWidth: 2)),
                                    Text(
                                      '${result[index].inJobsPercentage.round().toString()}%',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: hashTagTextStyleStandard(
                                          isDarkTheme(context)
                                              ? Colors.black
                                              : Colors.white),
                                    )
                                  ]),
                                )
                              ],
                            ),
                          ),
                          const Divider()
                        ],
                      ),
                    ),

                    */ /*Row(
                          children: [
                            getHashTagItem(tag: result[index].hashTag, selected: ()=>false, onSelected: (value) => false),
                            //Text(result[index].inJobsPercentage.toString()),
                          ],
                        )*/ /*
                  ),
                ],
              ),
            )),
      ),
    );
  }*/
}

Widget factoriesRow(item, bool forList) {
  return Builder(builder: (BuildContext context) {
    ScrollController factoriesScrollController = ScrollController(
        debugLabel: "_factoriesScrollController${item.hashCode}");
    // var screen = DataScreenState.of(context);
    List<Customer> elements = <Customer>[];
    (item as Report).reportDetails?.forEach((detail) {
      if (detail.factory != null) {
        elements.add(detail.factory!);
      }
    });
    //distinct (rimuovo gli elementi doppi)
    List distinctList = [
      ...{...elements}
    ];
    //ordino
    distinctList.sort((a, b) {
      return a.compareTo(b);
    });
    String toShow = "";
    for (Customer item in distinctList) {
      toShow += "$item\r\n";
    }
    if (distinctList.isNotEmpty) {
      toShow = toShow.substring(0, toShow.length - 2);
    }
    if (!forList) {
      return DefaultDataSource.getText(
          toShow, Theme.of(context).textTheme.bodyLarge!.color);
    } else {
      return itemData(
          label: 'Stabilimento', toShow, contentTextStyle: itemSubtitleStyle());
      Text(toShow, style: itemValueTextStyle());
    }
    /*SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _factoriesScrollController,
        child:
        DefaultDataSource.getText(toShow, Theme.of(context).textTheme.bodyLarge!.color)
        */
  } /*Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
                distinctList.length,
                    (index) => IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: DefaultDataSource.getText(distinctList[index].toString(), Theme.of(context).textTheme.bodyLarge!.color)
                  ),
                ))),*/ /*
      );*/
      );
}

Widget hashTagRow(item) {
  return Builder(
    builder: (BuildContext context) {
      ScrollController hashTagScrollController = ScrollController(
          debugLabel: "__hashTagScrollController${item.hashCode}");
      // var screen = DataScreenState.of(context);
      List<String> elements = <String>[];
      List<String> items =
          (item as ReportHeaderView).hashtags?.split("\r\n") ?? <String>[];
      for (String item in items) {
        elements.addAll(item.split("\r\n"));
      }

      print('list.size: ${elements.length.toString()}');
      //distinct (rimuovo gli elementi doppi)
      List<String> distinctList = [
        ...{...elements}
      ];
      print('distinctList.size: ${distinctList.length.toString()}');
      //ordino
      distinctList.sort((a, b) {
        return a.compareTo(b);
      });

      distinctList = distinctList.where((String s) => s.isNotEmpty).toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: hashTagScrollController,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(distinctList.length, (index) {
              List<String> params = distinctList[index].toString().split("|");
              return IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: getHashTagItem(
                      tag: HashTag(
                          hashTagId: int.parse(params[0]),
                          name: params[1],
                          color: params[2]),
                      selected: () {
                        return false;
                      },
                      onSelected: (selected) {}),
                ),
              );
            })),
      );
    },
  );
}

Widget operatorsRow(item) {
  return Builder(
    key: ValueKey(item),
    builder: (BuildContext context) {
      ScrollController operatorsController =
          ScrollController(debugLabel: "_operatorsController${item.hashCode}");
      // var screen = DataScreenState.of(context);
      List<String> elements = <String>[];
      if (item is ReportHeaderView && item.reportUsers != null) {
        elements.addAll(item.reportUsers!.split("\r\n"));
      }
      List<String> distinctList = [
        ...{...elements}
      ];
      //ordino
      distinctList.sort((a, b) {
        return a.compareTo(b);
      });
      distinctList =
          distinctList.where((element) => element.isNotEmpty).toList();

      return SingleChildScrollView(
        controller: operatorsController,
        scrollDirection: Axis.horizontal,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(elements.length, (index) {
              List<String> params = distinctList[index].split("|");
              ApplicationUser user = ApplicationUser(
                  applicationUserId: int.parse(params[0]),
                  surname: params[2],
                  name: params[1],
                  userName: params[3]);

              return IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: ApplicationUserItem(
                      user: user,
                      selected: () {
                        return false;
                      },
                      onSelected: (selected) {}),
                ),
              );
            })),
      );
    },
  );
}

String getStatusString(Status status) {
  String toShow = '';
  switch (status) {
    case Status.initState:
      toShow = 'Non ancora iniziato';
      break;
    case Status.started:
      toShow = 'Iniziato';
      break;
    case Status.open:
      toShow = 'Aperto';
      break;
    case Status.closed:
      toShow = 'Chiuso';
      break;
  }
  return toShow;
}

Color onQueryRowColor(BuildContext context, ReportHeaderView item) {
  Status status = Status.values[item.status ?? 0];

  switch (status) {
    case Status.initState:
      return Colors.transparent;

    case Status.open:
      return Color.alphaBlend(Colors.yellow.withAlpha(90),
          Theme.of(context).colorScheme.primary.withAlpha(90));
    case Status.closed:
      return Color.alphaBlend(Colors.red.withAlpha(90),
          Theme.of(context).colorScheme.primary.withAlpha(90));

    case Status.started:
      return Color.alphaBlend(Colors.green.withAlpha(90),
          Theme.of(context).colorScheme.primary.withAlpha(90));
    default:
      return Color.alphaBlend(Colors.purple.withAlpha(90),
          Theme.of(context).colorScheme.primary.withAlpha(90));
  }
}

Color? onQueryTextColor(ReportHeaderView item) {
  return null;
  /*Status status = Status.values[item.status];

  switch (status) {
    case Status.initState:
      return null;

    case Status.open:
      return Colors.white;
    case Status.closed:
      return Colors.white;
    case Status.started:
      return Colors.white;
    default:
      return null;
  }*/
}

class ReportActions {
  /*static dynamic openNew(context) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
          appBar:

          AppBar(

              shape: CustomAppBarShape(),
              title: const Text("Nuovo intervento")),
          body: MultiBlocProvider(
              providers: [
                BlocProvider<ServerDataBloc>(
                  lazy: false,
                  create: (context) => ServerDataBloc(repo: ReportServices()),
                ),
                BlocProvider<ServerDataBloc<ApplicationUser>>(
                  lazy: false,
                  create: (context) => ServerDataBloc<ApplicationUser>(
                      repo: ApplicationUserServices()),
                ),
                BlocProvider<ServerDataBloc<Report>>(
                  lazy: false,
                  create: (context) =>
                      ServerDataBloc<Report>(repo: ReportServices()),
                ),
                BlocProvider<ServerDataBloc<Customer>>(
                  lazy: false,
                  create: (context) =>
                      ServerDataBloc<Customer>(repo: CustomerServices()),
                ),
                BlocProvider<ServerDataBloc<Machine>>(
                  lazy: false,
                  create: (context) =>
                      ServerDataBloc<Machine>(repo: MachineServices()),
                ),
                BlocProvider<ServerDataBloc<InterventionCause>>(
                  lazy: false,
                  create: (context) => ServerDataBloc<InterventionCause>(
                      repo: InterventionCauseServices()),
                ),
                BlocProvider<ServerDataBloc<ReportDetail>>(
                  lazy: false,
                  create: (context) => ServerDataBloc<ReportDetail>(
                      repo: ReportDetailServices()),
                ),
              ],
              child: const ReportEditForm(
                  row: null, element: null, title: "Nuovo intervento")));
    }));
    return result;
  }*/
  static dynamic openNew(context) async {
    var formKey =
        GlobalKey<ReportEditFormState>(debugLabel: "editFormStateKey");
    var result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return scaffold(
              title: const Text("Nuovo intervento"),
              form: ReportEditForm(key: formKey, element: null));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    if (result == null) {
      return null;
    }

    if (result is Report) {
      return ReportHeaderView(reportId: result.reportId, report: result);
    }

    return result;
  }

  static dynamic openDetail(context, ReportHeaderView item,
      {bool readonly = false}) async {
    var formKey =
        GlobalKey<ReportEditFormState>(debugLabel: "editFormStateKey");

    if (item.report == null) {
      List<Report>? reports = await downloadReport(context, item.reportId ?? 0);

      if (reports != null && reports.isNotEmpty) {
        item = item.copyWith(report: reports[0]);
      }
    }

    var result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return scaffold(
              title: const Text("Modifica intervento"),
              form: ReportEditForm(
                  key: formKey, element: item.report, readonly: readonly));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    if (result == null) {
      return null;
    }
    return item.copyWith(report: result);
  }

  static Widget scaffold(
      {required Text title,
      required ReportEditForm form,
      double appBarHeight = 60}) {
    return WillPopScope(
      onWillPop: () async {
        if (form.key != null) {
          /*var status = (form.key as GlobalKey<ReportEditFormState>)
                  .currentState
                  ?.editSummaryFormKey
                  ?.currentState
                  ?.compressStatus ??
              0;

          return status == 0 ? true : false;*/
          Key? key = form.key;

          if (key is GlobalKey<ReportEditFormState>) {
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
        }
        return true;
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: appBarHeight,
                child: AppBar(
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
                  repo: MultiService<Report>(Report.fromJsonModel,
                      apiName: 'Report')),
            ),
            BlocProvider<ServerDataBloc<ApplicationUser>>(
              lazy: false,
              create: (context) => ServerDataBloc<ApplicationUser>(
                  repo: MultiService<ApplicationUser>(
                      ApplicationUser.fromJsonModel,
                      apiName: 'ApplicationUser')),
            ),
            BlocProvider<ServerDataBloc<Report>>(
              lazy: false,
              create: (context) => ServerDataBloc<Report>(
                  repo: MultiService<Report>(Report.fromJsonModel,
                      apiName: 'Report')),
            ),
            BlocProvider<ServerDataBloc<Customer>>(
              lazy: false,
              create: (context) => ServerDataBloc<Customer>(
                  repo: MultiService<Customer>(Customer.fromJsonModel,
                      apiName: 'Customer')),
            ),
            BlocProvider<ServerDataBloc<Machine>>(
              lazy: false,
              create: (context) => ServerDataBloc<Machine>(
                  repo: MultiService<Machine>(Machine.fromJsonModel,
                      apiName: 'VMMachine')),
            ),
            BlocProvider<ServerDataBloc<InterventionCause>>(
              lazy: false,
              create: (context) => ServerDataBloc<InterventionCause>(
                  repo: MultiService<InterventionCause>(
                      InterventionCause.fromJsonModel,
                      apiName: 'InterventionCause')),
            ),
            BlocProvider<ServerDataBloc<ReportDetail>>(
              lazy: false,
              create: (context) => ServerDataBloc<ReportDetail>(
                  repo: MultiService<ReportDetail>(ReportDetail.fromJsonModel,
                      apiName: 'ReportDetail')),
            ),
          ], child: form)),
    );
  }

  /*
  static dynamic openDetail(context, PlutoRow row, Report item) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Scaffold(
              appBar: AppBar(
                  shape: const CustomAppBarShape(),
                  title: const Text("Modifica intervento")),
              body: MultiBlocProvider(
                  providers: [
                    BlocProvider<ServerDataBloc>(
                      lazy: false,
                      create: (context) =>
                          ServerDataBloc(repo: ReportServices()),
                    ),
                    BlocProvider<ServerDataBloc<ApplicationUser>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<ApplicationUser>(
                          repo: ApplicationUserServices()),
                    ),
                    BlocProvider<ServerDataBloc<Report>>(
                      lazy: false,
                      create: (context) =>
                          ServerDataBloc<Report>(repo: ReportServices()),
                    ),
                    BlocProvider<ServerDataBloc<Customer>>(
                      lazy: false,
                      create: (context) =>
                          ServerDataBloc<Customer>(repo: CustomerServices()),
                    ),
                    BlocProvider<ServerDataBloc<Machine>>(
                      lazy: false,
                      create: (context) =>
                          ServerDataBloc<Machine>(repo: MachineServices()),
                    ),
                    BlocProvider<ServerDataBloc<InterventionCause>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<InterventionCause>(
                          repo: InterventionCauseServices()),
                    ),
                    BlocProvider<ServerDataBloc<ReportDetail>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<ReportDetail>(
                          repo: ReportDetailServices()),
                    ),
                  ],
                  child: ReportEditForm(
                      row: row, element: item, title: "Modifica intervento")));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }*/

  static showCantDeleteDialog(context) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message:
                'Non posso eliminare uno o alcuni interventi selezionati. E\' possibile eliminare solo interventi che non hanno lavori.',
            type: MessageDialogType.okOnly,
            okText: 'OK',
            okPressed: () {
              Navigator.pop(context, "1");
            });
      },
    ).then((value) {
      return value;
      //return value
    });
    return result;
  }

  static dynamic delete(context, List<ReportHeaderView> items) async {
    if (items.any((element) => element.hashtags?.isNotEmpty ?? false)) {
      return showCantDeleteDialog(context);
    }

    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare gli interventi selezionati?',
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

  ///[machines] rappresenta la lista delle macchine presenti dal cliente, da questa lista dedurrò anche gli stabilimenti
  static Future<ReportDetail?> addEditSummary(
      context,
      DateTime minDate,
      Customer selectedCustomer,
      List<Customer> customers,
      List<Machine> machines,
      GlobalKey<ReportEditSummaryFormState> key,
      {required List<ReportDetail>? details,
      Report? parent,
      ReportDetail? detail,
      bool readonly = false}) async {
    return await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async {
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
                      key.currentState?.idle();
                      if (key.currentContext != null) {
                        Navigator.of(key.currentContext!).pop();
                      }
                      break;
                    case '2': //annulla
                      break;
                  }
                }
              }

              return false;
            } else {
              key.currentState?.idle();
            }
            return true;
          },
          child: Scaffold(
              appBar: AppBar(
                  backgroundColor: isLightTheme(context)
                      ? null
                      : Color.alphaBlend(
                          Theme.of(context).colorScheme.surface.withAlpha(240),
                          Theme.of(context).colorScheme.primary),
                  shape: const CustomAppBarShape(),
                  title: const Text("Aggiungi lavoro")),
              body: MultiBlocProvider(
                  providers: [
                    BlocProvider<ServerDataBloc>(
                      lazy: false,
                      create: (context) => ServerDataBloc(
                          repo: MultiService<Report>(Report.fromJsonModel,
                              apiName: 'Report')),
                    ),
                    BlocProvider<ServerDataBloc<Report>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<Report>(
                          repo: MultiService<Report>(Report.fromJsonModel,
                              apiName: 'Report')),
                    ),
                    BlocProvider<ServerDataBloc<ReportDetail>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<ReportDetail>(
                          repo: MultiService<ReportDetail>(
                              ReportDetail.fromJsonModel,
                              apiName: 'ReportDetail')),
                    ),
                    BlocProvider<ServerDataBloc<ReportDetailImage>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<ReportDetailImage>(
                          repo: MultiService<ReportDetailImage>(
                              ReportDetailImage.fromJsonModel,
                              apiName: 'ReportDetailImage')),
                    ),
                    BlocProvider<ServerDataBloc<Customer>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<Customer>(
                          repo: MultiService<Customer>(Customer.fromJsonModel,
                              apiName: 'Customer')),
                    ),
                    BlocProvider<ServerDataBloc<Machine>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<Machine>(
                          repo: MultiService<Machine>(Machine.fromJsonModel,
                              apiName: 'VMMachine')),
                    ),
                    BlocProvider<ServerDataBloc<HashTag>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<HashTag>(
                          repo: MultiService<HashTag>(HashTag.fromJsonModel,
                              apiName: 'HashTag')),
                    ),
                    BlocProvider<ImageGalleryBloc>(
                      lazy: false,
                      create: (context) => ImageGalleryBloc(
                          repo: MultiService<ReportDetailImage>(
                              ReportDetailImage.fromJsonModel,
                              apiName: 'ReportDetailImage')),
                    ),
                  ],
                  child: ReportEditSummaryForm(
                    key: key,
                    element: detail,
                    title: "Nuovo lavoro",
                    minDate: minDate,
                    parent: parent,
                    customer: selectedCustomer,
                    machines: machines,
                    customers: customers,
                    currentDetails: details,
                    readonly: readonly,
                  ))));
    }));
  }
}

class ReportFooterResult implements Comparable {
  final HashTag hashTag;
  final int inJobs;
  final int totalJobs;

  const ReportFooterResult(
      {required this.hashTag, required this.inJobs, required this.totalJobs})
      : assert(totalJobs != 0, 'totalJobs must be != 0');

  ///x:100 = intJobs : totalJobs;

  double get inJobsPercentage => (100 * inJobs) / totalJobs;

  @override
  int compareTo(other) {
    if (other is ReportFooterResult) {
      return inJobsPercentage.compareTo(other.inJobsPercentage);
    }
    return -1;
  }
}
