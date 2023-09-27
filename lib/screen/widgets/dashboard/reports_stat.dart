import 'dart:math';

import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagrid/data_grid_selection_column.dart';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/hashtag.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:dpicenter/models/server/report_detail_hashtag.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtag_global.dart';
import 'package:dpicenter/screen/master-data/reports/report_global.dart';
import 'package:dpicenter/screen/master-data/reports/report_screen_ex.dart';
import 'package:dpicenter/screen/useful/loading_screen.dart';
import 'package:dpicenter/screen/widgets/dashboard/period_select.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import "package:collection/collection.dart";
import 'package:gato/gato.dart' as gato;

class ReportStat extends StatefulWidget {
  /*final Function(BuildContext context)? onNavigationPressed;*/
  const ReportStat(
      {this.tinyWidth,
      this.showFilters = true,
      this.isReportsOpen = false,
      this.isChartsOpen = false,
      this.isHashTagsOpen = false,
      this.onLoaded,
      Key? key})
      : super(key: key);

  final double? tinyWidth;
  final VoidCallback? onLoaded;
  final bool showFilters;
  final bool isReportsOpen;
  final bool isHashTagsOpen;
  final bool isChartsOpen;

  @override
  State<ReportStat> createState() => ReportStatState();
}

class ReportStatState extends State<ReportStat>
    with AutomaticKeepAliveClientMixin<ReportStat> {
  final ScrollController _scrollController =
  ScrollController(debugLabel: '_ReportStatState');
  List<Report>? items;
  List<ReportFooterResult>? footerResult;
  List<ReportDetail>? jobs;
  Map<ApplicationUser, List<Report>>? userReports;

  Map? groupItemsForChart;
  Map? groupJobsForChart;
  Map? groupUsersForChart;

  int reportChartStatus = 1;
  int jobsChartStatus = 1;
  int usersChartStatus = 1;

  List<IntChartData> reportsChartDataList = <IntChartData>[];
  List<IntChartData> jobsChartDataList = <IntChartData>[];
  List<IntChartData> usersPChartDataList = <IntChartData>[];
  List<IntChartDataEx> usersChartDataList = [];
  List<ListIntChartData> usersTimeChartDataList = [];

  late TooltipBehavior _reportsTooltipBehavior;
  late TooltipBehavior _jobsTooltipBehavior;
  late TooltipBehavior _usersTooltipBehavior;

  Map<String, Filter>? columnFilters;
  Map<String, bool Function(dynamic searchValue, dynamic item)?>? customFilters;

  final GlobalKey containerKey = GlobalKey(debugLabel: 'containerKey');
  final GlobalKey _hashtagsKey = GlobalKey(debugLabel: '_hashTagsKey');
  final GlobalKey _customersKey = GlobalKey(debugLabel: '_customersKey');
  final GlobalKey filterKey = GlobalKey(debugLabel: 'filterKey');
  final GlobalKey chartKey = GlobalKey(debugLabel: 'chartKey');
  final GlobalKey reportsListKey = GlobalKey(debugLabel: 'reportsListKey');
  final GlobalKey hashtagsListKey = GlobalKey(debugLabel: 'hashtagsListKey');
  final GlobalKey chartListKey = GlobalKey(debugLabel: 'chartListKey');

  bool _reportsPanelIsExpanded = false;
  bool _hashtagsPanelIsExpanded = false;
  bool _chartsPanelIsExpanded = false;

  _loadAsync(bool refresh) {
    var bloc = BlocProvider.of<ServerDataBloc<Report>>(context);

    bloc.add(ServerDataEvent<Report>(
      status: ServerDataEvents.fetch,
      refresh: refresh,
      customFilters: customFilters,
      columnFilters: columnFilters,
    ));
  }

  List<ChartSeriesController?>? _chartSeriesControllers;

  @override
  void initState() {
    super.initState();

    _reportsPanelIsExpanded = widget.isReportsOpen;
    _hashtagsPanelIsExpanded = widget.isHashTagsOpen;
    _chartsPanelIsExpanded = widget.isChartsOpen;

    _reportsTooltipBehavior = TooltipBehavior(
      enable: true,
    );
    _jobsTooltipBehavior = TooltipBehavior(
      enable: true,
    );
    _usersTooltipBehavior = TooltipBehavior(
      enable: true,
    );

    List<String> columns = <String>['customer.description', 'hashtags'];
    if (columnFilters == null) {
      columnFilters = <String, Filter>{};
      for (var element in columns) {
        columnFilters!.addAll({
          element: Filter(
              filterType: MultiFilterType.selection,
              value: <String>[],
              defaultValue: <String>[],
              isSetted: false)
        });
      }
    }

    if (customFilters == null) {
      customFilters =
      <String, bool Function(dynamic searchValue, dynamic item)?>{};
      for (var element in columns) {
        customFilters!.addAll({element: getColumnCustomFilter(element)});
      }
    }

    _loadAsync(true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<ServerDataBloc<Report>, ServerDataState<Report>>(
      listener: (BuildContext context, ServerDataState state) {
        if (state is ServerDataError<Report>) {
          print("Error ReportStat");
        }
        if (state is ServerDataAdded<Report>) {}
        if (state is ServerDataUpdated<Report>) {}
        if (state is ServerDataDeleted<Report>) {}
        if (state is ServerDataLoaded<Report>) {
          print("ServerDataLoaded<Report>");
          Stopwatch sw = Stopwatch();
          sw.start();
          items = state.items!;

          jobs = <ReportDetail>[];
          for (Report report in items!) {
            if (report.reportDetails != null) {
              jobs!.addAll(report.reportDetails!);
            }
          }
          var filter = columnFilters!['hashtags']!.value;
          if (filter == null) {
            filter = <HashTag>[];
          } else {
            //filter = (filter as Filter).value ?? <HashTag>[];
          }
          jobs = filterJobs(filter ?? <HashTag>[], jobs!);

          switch (reportChartStatus) {
            case 0: //year
              groupItemsForChart = groupReportsByYear(items!);
              break;
            case 1: //month
              groupItemsForChart = groupReportsByMonth(items!);
              break;
            case 2: //week
              groupItemsForChart = groupReportsByWeek(items!);
              break;
          }

          switch (jobsChartStatus) {
            case 0: //year
              groupJobsForChart = groupJobsByYear(jobs!);
              break;
            case 1: //month
              groupJobsForChart = groupJobsByMonth(jobs!);
              break;
            case 2: //week
              groupJobsForChart = groupJobsByWeek(jobs!);
              break;
          }

          userReports = mapUsersFromReports(items!);

          usersPChartDataList.clear();
          for (var user in userReports!.entries) {
            usersPChartDataList.add(IntChartData(
                "${user.key.surname} ${user.key.name!}", user.value.length));
          }

          usersTimeChartDataList.clear();
          DateTime minDate = DateTime.now();
          DateTime maxDate = DateTime.now();
          if (items != null && items!.isNotEmpty) {
            Report jobMinDate = items!.reduce((a, b) =>
                DateTime.parse(a.creationDate!)
                        .isBefore(DateTime.parse(b.creationDate!))
                    ? a
                    : b);
            Report jobMaxDate = items!.reduce((a, b) =>
                DateTime.parse(a.creationDate!)
                        .isAfter(DateTime.parse(b.creationDate!))
                    ? a
                    : b);

            minDate = DateTime.parse(jobMinDate.creationDate!);
            maxDate = DateTime.parse(jobMaxDate.creationDate!);
            for (var user in userReports!.entries) {
              List<IntChartData> userChartData = <IntChartData>[];
              int totalValue = 0;
              Map<dynamic, List<Report>> grouped = groupReportsByDay(items!
                  .where((element) =>
                      element.reportUsers!.firstWhereOrNull((element) =>
                          element.applicationUserId ==
                          user.key.applicationUserId!) !=
                      null)
                  .toList(growable: false)) as Map<dynamic, List<Report>>;

              for (DateTime currentDate = minDate;
                  (currentDate.isBefore(maxDate) || currentDate == maxDate);
                  currentDate = currentDate.add(const Duration(days: 1))) {
                var exist = grouped.entries.firstWhereOrNull((element) =>
                    element.key.toString() ==
                    getFormattedDayByDate(currentDate));
                if (exist != null) {
                  totalValue = totalValue + exist.value.length;
                } else {}
                print("totalValue: $totalValue");
                userChartData.add(IntChartData(
                    getFormattedDayByDate(currentDate), totalValue));
              }
              usersTimeChartDataList
                  .add(ListIntChartData(userChartData, user.key.userName!));
            }
          }

// Get student having minimum mark from the list (one liner)

          /*usersChartDataList.clear();
          userReports = mapUsersFromReports(items!);
          //Map<String, List<int>> result = {};
          for (var user in userReports!.entries){
            Map? grouped;
            switch (usersChartStatus) {
              case 0: //year
                grouped = groupReportsByYear(user.value);
                break;
              case 1: //month
                grouped = groupReportsByMonth(user.value);
                break;
              case 2: //week
                grouped = groupReportsByWeek(user.value);
                break;
            }

            if (grouped!=null){
              for (var key in grouped.keys){
                if (!usersChartDataList.any((element) => element.x==key.toString())){
                  usersChartDataList.add(IntChartDataEx(key.toString(),[(grouped[key] as List).length] ));
                } else {
                  for (int index = 0; index<usersChartDataList.length; index++){
                    if (usersChartDataList[index].x==key.toString()){
                      usersChartDataList[index].y.add((grouped[key] as List).length);
                    }
                  }
                }
              }

            }
          }
*/
          reportsChartDataList.clear();
          for (var item in groupItemsForChart!.entries) {
            reportsChartDataList.add(
                IntChartData(item.key.toString(), (item.value as List).length));
          }

          jobsChartDataList.clear();
          for (var item in groupJobsForChart!.entries) {
            jobsChartDataList.add(
                IntChartData(item.key.toString(), (item.value as List).length));
          }

          /*  int totalJobs = 0;
            int totalReports = items!.length;
            List<ReportFooterResult> result = <ReportFooterResult>[];
            Map<HashTag, int> inJobsMap = <HashTag, int>{};


            for (var row in items!) {

              row.reportDetails?.forEach((detail) {
                totalJobs++;
                detail.hashTags?.forEach((hashtag) {
                  int value = inJobsMap[hashtag.hashTag] ?? 0;
                  inJobsMap[hashtag.hashTag!] = value + 1;
                });
              });

            }*/

          if (items != null) {
            int totalJobs = jobs?.length ?? 0;
            footerResult = <ReportFooterResult>[];
            Map<HashTag, int> inJobsMap = <HashTag, int>{};
            for (var row in jobs!) {
              row.hashTags?.forEach((hashtag) {
                int value = inJobsMap[hashtag.hashTag] ?? 0;
                inJobsMap[hashtag.hashTag!] = value + 1;
              });
            }

            footerResult = inJobsMap.entries
                .map((e) => ReportFooterResult(
                hashTag: e.key, inJobs: e.value, totalJobs: totalJobs))
                .toList();
            footerResult?.sort();
            footerResult = footerResult?.reversed.toList(growable: false);
          }
          //usersChartDataList.clear();

          /*for (var item in userReports!.entries) {


            usersChartDataList.add(
                IntChartData("${item.key.surname} ${item.key.name ?? ''}", item.value.length));
            usersChartDataList.add(list2);
          }*/

          print("ServerDataLoaded<Report>: ${sw.elapsedMilliseconds}");
          widget.onLoaded?.call();
          print(
              "ServerDataLoaded<Report> after call: ${sw.elapsedMilliseconds}");
        }
      },
      child: BlocBuilder<ServerDataBloc<Report>, ServerDataState<Report>>(
          builder: (BuildContext context, ServerDataState state) {
            try {
              if (state is ServerDataLoaded && footerResult != null) {
            return LayoutBuilder(
                key: containerKey,
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      if (constraints.maxWidth <=
                          (widget.tinyWidth ?? tinyWidth))
                        _footerScreenMobile(
                            footerResult!, items?.length ?? 0, items!),
                      if (constraints.maxWidth >
                          (widget.tinyWidth ?? tinyWidth))
                            _footerScreenDesktop(
                                footerResult!, items?.length ?? 0, items!),
                          /*if (widget.onNavigationPressed!=null)
                        Positioned(
                          left: 20,
                          top: 100,
                          child: MultiSelector(
                              onPressed: (index) async {
                                setState((){
                                  statNavStatus=index;
                                });
                                widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
                              },
                              status: statNavStatus,
                              periodData: [
                                SelectorData(periodString: "HashTags", icon: Icon(Icons.tag)),
                                SelectorData(periodString: "Grafici", icon: Icon(Icons.bar_chart)),
                              ]),
                        )*/
                        ],
                      );
                      /*if (constraints.maxWidth < tinyWidth) {
                    return _footerScreenMobile(result, totalReports, items!);
                  } else {
                    return _footerScreenDesktop(result, totalReports, items!);
                  }*/
                    });
              } else {
                return LoadingScreen(
                  color: Colors.transparent,
                  textColor: isLightTheme(context) ? Colors.black : null,
                  message: 'Caricamento statistiche interventi',
                );
                /*return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Nessuna assistenza con hashtags trovata",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );*/
          }
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
              return Container();
            }
          }),
    );
  }

  List<ReportDetail> filterJobs(List? value, List<ReportDetail> jobs) {
    ///seleziono solo gli elementi che con contengono il valore value di columnFilters
    ///la ricerca del campo avviene grazie alla proprietà json di T
    if (value == null || value.isEmpty) {
      return jobs;
    }

    return jobs.where((ReportDetail element) {
      try {
        for (HashTag selected in value) {
          if (element.hashTags != null) {
            for (ReportDetailHashTag reportDetailHashTag in element.hashTags!) {
              if (reportDetailHashTag.hashTag == selected) {
                return true;
              }
            }
          }
        }
        return false;
      } catch (e) {
        print(e);
      }
      return false;
    }).toList(growable: false);
  }

  List<Widget> _getFooterHeader(int jobsCount,
      int reportsCount, {
        TextAlign textAlign = TextAlign.start,
      }) {
    return [
      Text(
        'STATISTICHE',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.start,
      ),
      /*Text(
        'utilizzo HashTags',
        style: Theme.of(context).textTheme.titleSmall,
        textAlign: TextAlign.start,
      ),*/
      RichText(
          textAlign: textAlign,
          text: TextSpan(
              text: 'Basate su ',
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

  Widget _footerScreenDesktop(List<ReportFooterResult> result, int totalReports, List<Report> items) {
    List<Widget> widgets = <Widget>[];
    widgets.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () {
                _loadAsync(true);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ..._getFooterHeader(
                        result.isNotEmpty ? result[0].totalJobs : 0,
                        totalReports),
                  ],
                ),
              ),
            )),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        if (widget.showFilters)
          Flexible(
              flex: 2,
              key: filterKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  getCustomersSelectionColumn('customer.description', 'Cliente',
                      getCustomerForFilter(items),
                      key: _customersKey),
                  const SizedBox(
                    height: 8,
                  ),
                  getHashTagsSelectionColumn(
                      'hashtags', 'HashTag', getItemsForFilter(items),
                      key: _hashtagsKey)
                  /*..._getFooterHeader(
                              result.isNotEmpty ? result[0].totalJobs : 0,
                              totalReports,
                              textAlign: TextAlign.end),*/
                ],
              )),
      ],
    ));
    widgets.addAll(getContent(result, type: Type.desktop));

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: isDarkTheme(context) ? Colors.white12 : Colors.black12,
            borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 16,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return widgets[index];
              },
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              itemCount: widgets.length,
            )),
      ),
    );
  }

/*  Widget _footerScreenDesktop(
      List<ReportFooterResult> result, int totalReports, List<Report> items) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: isDarkTheme(context) ? Colors.white12 : Colors.black12,
            borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._getFooterHeader(
                            result.isNotEmpty ? result[0].totalJobs : 0,
                            totalReports),
                      ],
                    )),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    if (widget.showFilters)
                      Flexible(
                          key: filterKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              getCustomersSelectionColumn(
                                  'customer.description',
                                  'Cliente',
                                  getCustomerForFilter(items),
                                  key: _customersKey),
                              const SizedBox(
                                height: 8,
                              ),
                              getHashTagsSelectionColumn('hashtags', 'HashTag',
                                  getItemsForFilter(items),
                                  key: _hashtagsKey)
                              */ /*..._getFooterHeader(
                              result.isNotEmpty ? result[0].totalJobs : 0,
                              totalReports,
                              textAlign: TextAlign.end),*/ /*
                            ],
                          )),
                  ],
                )),
                const SizedBox(
                  height: 16,
                ),
                ...getContent(result, type: Type.desktop),
              ],
            ),
          ),
        ),
      ),
    );
  }*/

  List<Color> getChartPalette() {
    return <Color>[
      Theme.of(context).colorScheme.primary.withAlpha(200),
      Color.alphaBlend(
          Colors.blue.withAlpha(100), Theme.of(context).colorScheme.primary)
          .withAlpha(200),
    ];
  }

  Widget summarySubTitle(List<String> subTitle, {Function()? onPressed}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: onPressed,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primary.withAlpha(50),
                border: Border.all(
                    color:
                        Theme.of(context).colorScheme.primary.withAlpha(200))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      subTitle.length,
                      (index) => Text(
                            subTitle[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w300),
                            textAlign: TextAlign.start,
                          ))
                ],
              ),
            ),
          ),
        ));
  }

  Widget getReportsChart({int labelRotation = 0}) {
    return SfCartesianChart(
      enableAxisAnimation: true,
      // Initialize category axis
      palette: getChartPalette(),
      //Enables the tooltip for all the series
      tooltipBehavior: _reportsTooltipBehavior,
      /*title: ChartTitle(
          text: title,
          // Aligns the chart title to left
          alignment: ChartAlignment.near,

      ),*/
      primaryXAxis: CategoryAxis(labelRotation: labelRotation),
      primaryYAxis: NumericAxis(
        interval: 1,
        title: AxisTitle(text: 'Interventi'),
        //minorTicksPerInterval: 0,
      ),
      series: <ChartSeries>[
        // Initialize line series
        ColumnSeries<IntChartData, String>(
            name: 'Mese: interventi',
            enableTooltip: true,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            dataSource: reportsChartDataList,
            xValueMapper: (IntChartData data, _) => data.x,
            yValueMapper: (IntChartData data, _) => data.y)
      ],
    );
  }

  Widget getJobsChart({int labelRotation = 0}) {
    return SfCartesianChart(
      enableAxisAnimation: true,
      // Initialize category axis
      palette: getChartPalette(),
      //Enables the tooltip for all the series
      tooltipBehavior: _jobsTooltipBehavior,
      primaryXAxis: CategoryAxis(
        // Axis labels will be rotated to 90 degree
          labelRotation: labelRotation),
      primaryYAxis: NumericAxis(
        interval: 1,

        title: AxisTitle(text: 'Lavori'),
        //minorTicksPerInterval: 0,
      ),
      series: <ChartSeries>[
        // Initialize line series
        ColumnSeries<IntChartData, String>(
            name: 'Mese: lavori',
            enableTooltip: true,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            dataSource: jobsChartDataList,
            xValueMapper: (IntChartData data, _) => data.x,
            yValueMapper: (IntChartData data, _) => data.y)
      ],
    );
  }

  Widget getUsersChart({int labelRotation = 0}) {
    return SfCartesianChart(
      enableAxisAnimation: true,
      // Initialize category axis
      palette: getChartPalette(),
      //Enables the tooltip for all the series
      tooltipBehavior: _usersTooltipBehavior,
      primaryXAxis: CategoryAxis(
        // Axis will be rendered based on the index values
          arrangeByIndex: true,
          // Axis labels will be rotated to 90 degree
          labelRotation: labelRotation),
      primaryYAxis: NumericAxis(
        interval: 1,

        title: AxisTitle(text: 'Interventi'),
        //minorTicksPerInterval: 0,
      ),

      series: <ChartSeries>[
        /*...List.generate(userReports?.length ?? 0, (index) =>*/
        ColumnSeries<IntChartData, String>(
            name: 'Operatori',
            enableTooltip: true,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            dataSource: usersPChartDataList,
            xValueMapper: (IntChartData data, _) => data.x,
            yValueMapper: (IntChartData data, _) => data.y)
        /*)*/
        // Initialize series
      ],
    );
  }

  Widget getUsersTimeChart({int labelRotation = 0}) {
    _chartSeriesControllers =
        List.generate(usersTimeChartDataList.length, (index) => null);

    return SfCartesianChart(
      enableAxisAnimation: true,

      // Initialize category axis
      //palette: getChartPalette(),
      //Enables the tooltip for all the series
      tooltipBehavior: _usersTooltipBehavior,
      primaryXAxis: CategoryAxis(

          /// Axis will be rendered based on the index values
          //arrangeByIndex: true,
          /// Axis labels will be rotated to [labelRotation] degree
          labelRotation: labelRotation),
      primaryYAxis: NumericAxis(
        interval: 1,

        title: AxisTitle(text: 'Interventi'),
        //minorTicksPerInterval: 0,
      ),
      legend: Legend(
          isVisible: true, toggleSeriesVisibility: true, isResponsive: true),
      series: <ChartSeries<IntChartData, String>>[
        ...List.generate(
          usersTimeChartDataList.length,
          (index) => LineSeries<IntChartData, String>(
              //markerSettings: MarkerSettings(shape: DataMarkerType.diamond),
              animationDuration: 2000,
              animationDelay: (usersTimeChartDataList.length - index) * 350,
              onRendererCreated: (controller) {
                _chartSeriesControllers?[index] = controller;
              },
              name: usersTimeChartDataList[index].name,
              enableTooltip: true,
              dataSource: usersTimeChartDataList[index].data,
              xValueMapper: (IntChartData data, currentIndex) => data.x,
              yValueMapper: (IntChartData data, currentIndex) => data.y),
        )
        // Initialize series
      ],
    );
  }

  Map groupReportsByYear(List<Report> items) =>
      groupBy(items, (Report e) => getFormattedYear(e.creationDate!));

  Map groupReportsByMonth(List<Report> items) =>
      groupBy(items, (Report e) => getFormattedMonth(e.creationDate!));

  Map groupReportsByWeek(List<Report> items) =>
      groupBy(items, (Report e) => getFormattedWeek(e.creationDate!));

  Map groupReportsByDay(List<Report> items) =>
      groupBy(items, (Report e) => "${getFormattedDay(e.creationDate!)}");

  Map groupJobsByYear(List<ReportDetail> items) =>
      groupBy(items, (ReportDetail e) => getFormattedYear(e.startDate!));

  Map groupJobsByMonth(List<ReportDetail> items) =>
      groupBy(items, (ReportDetail e) => getFormattedMonth(e.startDate!));

  Map groupJobsByWeek(List<ReportDetail> items) =>
      groupBy(items, (ReportDetail e) => getFormattedWeek(e.startDate!));

  Map groupJobsByDay(List<ReportDetail> items) => groupBy(items,
      (ReportDetail e) => "${e.startDate!}-${getFormattedDay(e.startDate!)}");

  /* Map groupReportsByUserYear(List<Report> items, ApplicationUser user) =>
      groupBy(items, (Report e) => "${getFormattedYear(e.creationDate!)}_${user.applicationUserId}");

  */ /*Map groupReportsByUsers(List<Report> items) {
    Map<ApplicationUser, List<Report>> resultMap = {};
    List<ApplicationUser> users = getUsersFromReports(items);

    for (ApplicationUser user in users){
      if (!resultMap.containsKey(user)){
        for (var report in items){

        }
        //raggruppo
        switch(period){
          case 0: //anno
            var mapResult = groupReportsByUserYear(items, user);
            resultMap.addAll({user : mapResult.entries as List<Report>});
            break;
          case 1:
            break;
          case 2:
            break;

        }
      }
    }

    return resultMap;
  }*/

  List<ApplicationUser> getUsersFromReports(List<Report> items) {
    List<ApplicationUser> users = <ApplicationUser>[];
    for (Report report in items) {
      if (report.reportUsers != null && report.reportUsers!.isNotEmpty) {
        for (var reportUser in report.reportUsers!) {
          if (reportUser.applicationUser != null) {
            if (!users.contains(reportUser.applicationUser!)) {
              users.add(reportUser.applicationUser!);
            }
          }
        }
      }
    }
    return users;
  }

  Map<ApplicationUser, List<Report>> mapUsersFromReports(List<Report> items) {
    Map<ApplicationUser, List<Report>> resultMap = {};

    for (Report report in items) {
      if (report.reportUsers != null && report.reportUsers!.isNotEmpty) {
        for (var reportUser in report.reportUsers!) {
          if (reportUser.applicationUser != null) {
            if (!resultMap.containsKey(reportUser.applicationUser!)) {
              resultMap.addAll({
                reportUser.applicationUser!: <Report>[report]
              });
            } else {
              if (!resultMap[reportUser.applicationUser!]!.contains(report)) {
                resultMap[reportUser.applicationUser!]!.add(report);
              }
            }
          }
        }
      }
    }
    return resultMap;
  }

  /*String getFormattedMonth(Report report){
    var data = DateTime.parse(report.creationDate!);
    DateFormat format = new DateFormat("MMMM, yyyy");
    return format.format(data);
  }*/
  String getFormattedDay(String date) {
    var data = DateTime.parse(date);
    DateFormat format = DateFormat("dd/MM/yyyy");
    return format.format(data);
  }

  String getFormattedDayByDate(DateTime data) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    return format.format(data);
  }

  String getFormattedMonth(String date) {
    var data = DateTime.parse(date);
    DateFormat format = DateFormat("MMMM, yyyy");
    return format.format(data);
  }

  String getFormattedYear(String date) {
    var data = DateTime.parse(date);
    DateFormat format = DateFormat("yyyy");
    return format.format(data);
  }

  /// The [weekday] may be 0 for Sunday, 1 for Monday, etc. up to 7 for Sunday.
  DateTime mostRecentWeekday(DateTime date, int weekday) =>
      DateTime(date.year, date.month, date.day - (date.weekday - weekday) % 7);

  String getFormattedWeek(String date) {
    var data = DateTime.parse(date);

    var startWeek = mostRecentWeekday(data, 1);

    DateFormat format = DateFormat("dd/MM/yyyy");
    String formatData = format.format(startWeek);
    //'Settimana ${data.weekNumber(data).toString()} ${format.format(data)}';
    return formatData;
  }

  Widget _footerScreenMobile(List<ReportFooterResult> result, int totalReports, List items) {
    List<Widget> widgets = <Widget>[];
    widgets.add(TextButton(
        onPressed: () {
          _loadAsync(true);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              children: _getFooterHeader(
                  result.isNotEmpty ? result[0].totalJobs : 0, totalReports)),
        )));

    widgets.add(Column(
      key: filterKey,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        getCustomersSelectionColumn(
            'customer.description', 'Clienti', getCustomerForFilter(items),
            key: _customersKey),
        const SizedBox(
          height: 8,
        ),
        getHashTagsSelectionColumn(
            'hashtags', 'HashTags', getItemsForFilter(items),
            key: _hashtagsKey)
        /*..._getFooterHeader(
                              result.isNotEmpty ? result[0].totalJobs : 0,
                              totalReports,
                              textAlign: TextAlign.end),*/
      ],
    ));
    widgets.addAll(getContent(result, type: Type.mobile));

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: isDarkTheme(context) ? Colors.white12 : Colors.black12,
            borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 16,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return widgets[index];
            },
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            itemCount: widgets.length,
          ),
        ),
      ),
    );
  }

  List<Widget> getContent(List<ReportFooterResult> result,
      {required Type type}) {
    return [

      ///interventi effettuati
      //const DialogTitle("Interventi"),
      _reportsPanel(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (items?.length ?? 0) == 0
                ? const Center(
                child: Text(
                  'Nessun intervento trovato',
                  textAlign: TextAlign.center,
                ))
                : Wrap(
              spacing: 8,
              runSpacing: 8,
              direction: Axis.horizontal,
              children: List.generate(
                items?.length ?? 0,
                    (index) => getReportItem(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 8.0),
                    labelPadding: const EdgeInsets.all(0),
                    report: items![index],
                    selected: () => false,
                    onSelected: () {
                      ReportActions.openDetail(context, items![index],
                          readonly: true);
                      return false;
                    }),
              ),
            )),
      ),

      const Divider(),

      ///hashtags

      //const DialogTitle("HashTags"),
      _hashtagsPanel(
          child: type == Type.mobile
              ? _hashTagMobilePanel(result)
              : _hashTagDesktopPanel(result)),
/*
      if (result.isEmpty)
            const Center(child: Text('Nessun hashtag trovato',textAlign: TextAlign.center,)),
*/

/*      if (result.isNotEmpty)*/

      const Divider(),

      /*  Flexible(
        child: Row(children: [

          Expanded(child: ElevatedButton(onPressed: (){},child: Text("Bella roba"),))
        ],),
      ),*/

      ///grafici
      _chartsPanel(
          child: Column(
            children: [
              DialogTitleEx(
                key: chartKey,
                "Interventi - ${_getPeriodString(reportChartStatus)}",
                trailingChild: MultiSelector(
                    status: reportChartStatus,
                    onPressed: (index) {
                      setState(() {
                        reportChartStatus = index;
                        _loadAsync(false);
                      });
                    },
                    selectorData: const [
                      SelectorData(
                          periodString: 'Anno',
                          icon: Icon(
                            Icons.edit_calendar,
                            /*color: _getSelectorColor(0),*/
                          )),
                      SelectorData(
                          periodString: 'Mese',
                          icon: Icon(
                            Icons
                                .calendar_view_month, /*color: _getSelectorColor(1)*/
                          )),
                      SelectorData(
                          periodString: 'Settimana',
                          icon: Icon(
                            Icons
                                .calendar_view_week, /*color: _getSelectorColor(2)*/
                          )),
                    ]),
              ),
              summarySubTitle(
                  ["Periodo: tutti", "Totale interventi: ${items?.length ?? 0}"]),
              const SizedBox(
                height: 8,
              ),
              getReportsChart(labelRotation: 45),
              DialogTitleEx(
                "Lavori - ${_getPeriodString(jobsChartStatus)}",
                trailingChild: MultiSelector(
                    status: jobsChartStatus,
                    onPressed: (index) {
                      setState(() {
                        jobsChartStatus = index;
                        _loadAsync(false);
                      });
                    },
                    selectorData: const [
                      SelectorData(
                          periodString: 'Anno',
                          icon: Icon(
                            Icons.edit_calendar,
                            /*color: _getSelectorColor(0),*/
                          )),
                      SelectorData(
                          periodString: 'Mese',
                          icon: Icon(
                            Icons
                                .calendar_view_month, /*color: _getSelectorColor(1)*/
                          )),
                      SelectorData(
                          periodString: 'Settimana',
                          icon: Icon(
                            Icons
                                .calendar_view_week, /*color: _getSelectorColor(2)*/
                          )),
                    ]),
              ),
              summarySubTitle(
                  ["Periodo: tutti", "Totale lavori: ${jobs?.length ?? 0}"]),
              const SizedBox(
                height: 8,
              ),
              getJobsChart(labelRotation: 45),
              const DialogTitleEx(
                "Operatori", // - ${_getPeriodString(usersChartStatus)}
                /*trailingChild: MultiSelector(
                status: usersChartStatus,
                onPressed: (index) {
                  setState(() {
                    usersChartStatus = index;
                    _loadAsync(false);
                  });
                },
                selectorData: const [
                  SelectorData(
                      periodString: 'Anno',
                      icon: Icon(
                        Icons.edit_calendar,
                        */ /*color: _getSelectorColor(0),*/ /*
                      )),
                  SelectorData(
                      periodString: 'Mese',
                      icon: Icon(Icons.calendar_view_month,
                        */ /*color: _getSelectorColor(1)*/ /*)),
                  SelectorData(
                      periodString: 'Settimana',
                      icon: Icon(Icons.calendar_view_week,
                        */ /*color: _getSelectorColor(2)*/ /*)),
                ]),*/
          ),
          summarySubTitle(
              ["Periodo: tutti", "Totale interventi: ${items?.length ?? 0}"]),
          const SizedBox(
            height: 8,
          ),
          getUsersChart(labelRotation: 45),
          const DialogTitleEx(
            "Interventi - operatori su tempo", //
          ),
          summarySubTitle(
              ["Periodo: tutti", "Totale interventi: ${items?.length ?? 0}"],
              onPressed: () {
            if (_chartSeriesControllers != null &&
                _chartSeriesControllers!.isNotEmpty) {
              for (int index = 0;
                  index < _chartSeriesControllers!.length;
                  index++) {
                if (_chartSeriesControllers![index] != null) {
                  _chartSeriesControllers![index]!.animate();
                }
              }
            }
          }),
          const SizedBox(
            height: 8,
          ),
          getUsersTimeChart(labelRotation: 45)
        ],
          ))
    ];
  }

  String _getPeriodString(int? status) {
    if (status != null) {
      switch (status) {
        case 0:
          return 'Anno';
        case 1:
          return 'Mese';
        case 2:
          return 'Settimana';
      }
    }
    return 'Sconosciuto';
  }

  Widget _hashTagDesktopPanel(result) {
    return result.isEmpty
        ? const Center(
        child: Text(
          'Nessun hashtag trovato',
          textAlign: TextAlign.center,
        ))
        : ListView.separated(
      shrinkWrap: true,
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      itemCount: result.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 16);
      },
      itemBuilder: (BuildContext context, int index) {
        return Row(
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
                  false, /*fontSize: 16.0 + result[index].inJobs*10*/
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
                          borderRadius: BorderRadius.circular(20)),
                      child: FAProgressBar(
                        animatedDuration:
                        const Duration(milliseconds: 1000),
                        maxValue: 100,
                        backgroundColor:
                        Theme.of(context).colorScheme.background,
                        progressColor:
                        Theme.of(context).colorScheme.primary,
                        currentValue: result[index].inJobsPercentage,
                        //displayText: '%',
                        //minHeight: 30,
                      )),
                  /*LinearProgressIndicator(
                                      value:
                                          result[index].inJobsPercentage / 100,
                                      minHeight: 30,
                                    )),*/
                  Container(
                    constraints: const BoxConstraints(minHeight: 30),
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
        );
      },
    );

/*    Column(
            children: [
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: FAProgressBar(
                                  animatedDuration:
                                      const Duration(milliseconds: 1000),
                                  maxValue: 100,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  progressColor:
                                      Theme.of(context).colorScheme.primary,
                                  currentValue: result[index].inJobsPercentage,
                                  //displayText: '%',
                                  //minHeight: 30,
                                )),
                            */ /*LinearProgressIndicator(
                                      value:
                                          result[index].inJobsPercentage / 100,
                                      minHeight: 30,
                                    )),*/ /*
                            Container(
                              constraints: const BoxConstraints(minHeight: 30),
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
              )
            ],
          );*/
  }

  Widget _hashTagMobilePanel(result) {
    return result.isEmpty
        ? const Center(
        child: Text(
          'Nessun hashtag trovato',
          textAlign: TextAlign.center,
        ))
        : ListView.separated(
        shrinkWrap: true,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: result.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 16);
        },
        itemBuilder: (BuildContext context, int index) {
          return Column(
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
                    false, /*fontSize: 16.0 + result[index].inJobs*10*/
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
                            borderRadius: BorderRadius.circular(20)),
                        child: FAProgressBar(
                          animatedDuration:
                          const Duration(milliseconds: 1000),
                          maxValue: 100,
                          backgroundColor:
                          Theme.of(context).colorScheme.background,
                          progressColor:
                          Theme.of(context).colorScheme.primary,
                          currentValue: result[index].inJobsPercentage,
                          //displayText: '%',
                          //minHeight: 30,
                        )),
                    /*LinearProgressIndicator(
                                          value:
                                          result[index].inJobsPercentage / 100,
                                          minHeight: 30,
                                        )),*/
                    Container(
                      constraints: const BoxConstraints(minHeight: 30),
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
                              strokeWidth: 2,
                            )),
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
          );
        });

/*    Column(
            children: [
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: FAProgressBar(
                                  animatedDuration:
                                      const Duration(milliseconds: 1000),
                                  maxValue: 100,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  progressColor:
                                      Theme.of(context).colorScheme.primary,
                                  currentValue: result[index].inJobsPercentage,
                                  //displayText: '%',
                                  //minHeight: 30,
                                )),
                            */ /*LinearProgressIndicator(
                                          value:
                                          result[index].inJobsPercentage / 100,
                                          minHeight: 30,
                                        )),*/ /*
                            Container(
                              constraints: const BoxConstraints(minHeight: 30),
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
                                      strokeWidth: 2,
                                    )),
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
              )
            ],
          );*/
  }

  /*Widget _collapsablePanel({required String title,
    required Widget child, required bool currentState, required Key key}) {

    return Padding(
      key: key,
      padding: const EdgeInsets.all(0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: MultiExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            switch (panelIndex) {
              case 0:
                currentState= !currentState;
                break;
            */ /* case 1: //logici
                _logicPanelIsExpanded = !_logicPanelIsExpanded;
                break;*/ /*
            }

            setState(() {});
          },
          children: [
            MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: currentState,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return SizedBox(
                      height: 80, child: DialogTitle(title));
                },
                body: child
            ),
          ],
        ),
      ),
    );
  }
*/
  Widget _reportsPanel({required Widget child}) {
    return Padding(
      key: reportsListKey,
      padding: const EdgeInsets.all(0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: MultiExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            switch (panelIndex) {
              case 0: //interventi
                _reportsPanelIsExpanded = !_reportsPanelIsExpanded;
                break;
              /* case 1: //logici
                _logicPanelIsExpanded = !_logicPanelIsExpanded;
                break;*/
            }

            setState(() {});
          },
          children: [
            MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: _reportsPanelIsExpanded,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const SizedBox(
                      height: 80, child: DialogTitle("Interventi"));
                },
                body: child),
          ],
        ),
      ),
    );
  }

  Widget _hashtagsPanel({required Widget child}) {
    return Padding(
      key: hashtagsListKey,
      padding: const EdgeInsets.all(0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: MultiExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            switch (panelIndex) {
              case 0: //interventi
                _hashtagsPanelIsExpanded = !_hashtagsPanelIsExpanded;
                break;
              /* case 1: //logici
                _logicPanelIsExpanded = !_logicPanelIsExpanded;
                break;*/
            }

            setState(() {});
          },
          children: [
            MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: _hashtagsPanelIsExpanded,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const SizedBox(
                      height: 80, child: DialogTitle("HashTags"));
                },
                body: child),
          ],
        ),
      ),
    );
  }

  Widget _chartsPanel({required Widget child}) {
    return Padding(
      key: chartListKey,
      padding: const EdgeInsets.all(0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: MultiExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            switch (panelIndex) {
              case 0: //interventi
                _chartsPanelIsExpanded = !_chartsPanelIsExpanded;
                break;
              /* case 1: //logici
                _logicPanelIsExpanded = !_logicPanelIsExpanded;
                break;*/
            }

            setState(() {});
          },
          children: [
            MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: _chartsPanelIsExpanded,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const SizedBox(
                      height: 80, child: DialogTitle("Grafici"));
                },
                body: child),
          ],
        ),
      ),
    );
  }

  Color _getSelectorColor(int? status) {
    return Color.alphaBlend(
        Colors.primaries[status ?? 0].withAlpha(100), Colors.grey);
  }

  List getItemsForFilter(List items) {
    List<HashTag> elements = <HashTag>[];

    for (var item in items) {
      if (item is Report) {
        item.reportDetails?.forEach((detail) {
          detail.hashTags?.forEach((hashtag) {
            elements.add(hashtag.hashTag!);
          });
        });
      }
    }
    List distinctList = [
      ...{...elements}
    ];
    distinctList.sort((a, b) {
      return a.compareTo(b);
    });
    return distinctList;
  }

  List getCustomerForFilter(List items) {
    List elements = [];

    for (var item in items) {
      if (item is Report) {
        var valueReaded = gato.get(item.json, 'customer.description');
        elements.add(valueReaded);
      }
    }
    List distinctList = [
      ...{...elements}
    ];
    distinctList.sort((a, b) {
      return a.compareTo(b);
    });
    return distinctList;
  }

  Widget getHashTagsSelectionColumn(dynamic id, String label, List<dynamic> list,
      {Key? key}) {
    return DataGridSelectionColumn<dynamic, dynamic>(
      key: key,
      id: id,
      text: label,
      //startFilterText: columnFilters?[col.id]?.value[0],
      //endFilterText: columnFilters?[col.id]?.value[1],
      dropdownBuilder: (context, List<dynamic> list) {
        List<Widget> selected = <Widget>[];

        for (var item in list) {
          selected.add(
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: getHashTagItem(
                    visualDensity: VisualDensity.compact.copyWith(
                        horizontal: VisualDensity.maximumDensity,
                        vertical: VisualDensity.minimumDensity),
                    tag: item,
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
        return ListTile(
          contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          title: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: item != null
                      ? getHashTagItem(
                      tag: item,
                      selected: () {
                        return false;
                      },
                      onSelected: (value) {})
                      : const Text("Errore"))),
        );
      },
      //itemAsString: col.itemAsString,
      onFilterChange: (List<dynamic>? values) {
        setState(() {
          columnFilters![id] = Filter(
              filterType: columnFilters![id]!.filterType,
              value: values,
              defaultValue: columnFilters![id]!.defaultValue,
              isSetted: values?.isNotEmpty ?? false);
          _loadAsync(false);
        });

        columnFilters!.forEach((key, value) {
          debugPrint('filter $key: $value');
        });
      },
      /*filterValues: columnFilters![col.id]?.value,*/
      items: list,
    );
  }

  Widget getCustomersSelectionColumn(dynamic id, String label, List<dynamic> list,
      {Key? key}) {
    return DataGridSelectionColumn<dynamic, dynamic>(
      id: id.toString(),
      itemAsString: (dynamic item) => (item as Customer).description ?? '',
      key: key,
      text: label,
      filterValues: columnFilters![id.toString()]?.value,
      popupItemBuilder: getCustomerPopupItemBuilder,
      onFilterChange: (List<dynamic>? values) {
        setState(() {
          columnFilters![id] = Filter(
              filterType: columnFilters![id]!.filterType,
              value: values,
              defaultValue: columnFilters![id]!.defaultValue,
              isSetted: values?.isNotEmpty ?? false);
          _loadAsync(false);
        });

        columnFilters!.forEach((key, value) {
          debugPrint('filter $key: $value');
        });
      },
      /*filterValues: columnFilters![col.id]?.value,*/
      items: list,
    );
  }

  /*DataScreenColumnConfiguration<JsonPayload, JsonPayload>
  hashTagsColumnConfiguration() {
    return DataScreenColumnConfiguration(
        id: 'hashtags',
        label: 'HashTags',
        filterType: MultiFilterType.selection,
        getItemsForFilter: (DataScreenColumnConfiguration col, List items) {
          List<HashTag> elements = <HashTag>[];

          for (var item in items) {
            if (item is Report) {
              item.reportDetails?.forEach((detail) {
                detail.hashTags?.forEach((hashtag) {
                  elements.add(hashtag.hashTag!);
                });
              });
            }
          }
*/ /*                //distinct (rimuovo gli elementi doppi)
                List distinctList = [
                  ...{...elements}
                ];
                //ordino
                distinctList.sort((a, b) {
                  return a.compareTo(b);
                });*/ /*
          return elements;
        },
        autoFitPadding: const EdgeInsets.all(32.0),
        customSizer: ColumnSizerRule(
            ruleType: ColumnSizerRuleType.recalculateCellValue,
            recalculateCellValue: (item) {
              String cellValue = '';
              int i = 0;
              (item as Report).reportDetails?.forEach((detail) {
                if (detail.hashTags != null) {
                  for (var hashtag in detail.hashTags!) {
                    cellValue += hashtag.hashTag!.name! + ' ';
                    i++;
                    if (i >= 3) {
                      break;
                    }
                  }
                }
              });

              return ColumnSizerRecalculateResult(
                  result: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                  textStyle: Theme.of(context).textTheme.bodySmall);
              cellValue;
            }),
        dropdownBuilder: (context, List<dynamic> list) {
          List<Widget> selected = <Widget>[];

          for (var item in list) {
            selected.add(
              IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: getHashTagItem(
                      visualDensity: VisualDensity.compact.copyWith(
                          horizontal: VisualDensity.maximumDensity,
                          vertical: VisualDensity.minimumDensity),
                      tag: item,
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
          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            title: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: item != null
                        ? getHashTagItem(
                        tag: item,
                        selected: () {
                          return false;
                        },
                        onSelected: (value) {})
                        : Text("Errore"))),
          );
        },
        customFilter: (dynamic searchValue, dynamic item) {
          if (searchValue != null &&
              (searchValue as List).isNotEmpty &&
              item != null) {
            if (item is Report) {
              List<HashTag> elements = <HashTag>[];
              item.reportDetails?.forEach((detail) {
                detail.hashTags?.forEach((hashtag) {
                  elements.add(hashtag.hashTag!);
                });
              });

              ///controlla se in searchValue è contenuto almeno un elemento presente in elements
              bool check(HashTag value) {
                return searchValue.contains(value);
              }

              return elements.any(check);
            }
          }
          return true;
        },
        onQueryRowColor: (item) => onQueryRowColor(context, item as Report),
        onRenderRowField: (item, {bool? forList}) {
          return hashTagRow(item);
        });
  }*/
  Widget getDropdownBuilder(context, List<dynamic> list, String id) {
    List<Widget> selected = <Widget>[];

    for (var item in list) {
      selected.add(
        IgnorePointer(
          child: DataGridColumnSelectionState.getFilterChip(
              text: item is JsonPayload
                  ? /*gato.get(item.json, id) ??*/ item.toString()
                  : item.toString(),
              selected: () {
                return false;
              },
              onSelected: (value) {},
              context: context),
        ),
      );
    }

    if (selected.isNotEmpty) {
      return DataGridColumnSelectionState.getContainerRow(context, selected);
    } else {
      return DataGridColumnSelectionState.getEmptySelectionText(context);
    }
  }

  Widget getCustomerPopupItemBuilder(BuildContext context, dynamic item, bool isSelected) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(item.toString()))),
    );
  }

  bool Function(dynamic searchValue, dynamic item)? getColumnCustomFilter(String id) {
    switch (id) {
      case 'hashtags':
        return (dynamic searchValue, dynamic item) {
          if (searchValue != null &&
              (searchValue as List).isNotEmpty &&
              item != null) {
            if (item is Report) {
              List<HashTag> elements = <HashTag>[];
              item.reportDetails?.forEach((detail) {
                detail.hashTags?.forEach((hashtag) {
                  elements.add(hashtag.hashTag!);
                });
              });

              ///controlla se in searchValue è contenuto almeno un elemento presente in elements
              bool check(HashTag value) {
                return searchValue.contains(value);
              }

              return elements.any(check);
            }
          }
          return true;
        };
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void setColumnFilter(String column, List<dynamic>? values) {
    columnFilters![column] = Filter(
        filterType: columnFilters![column]!.filterType,
        value: values,
        defaultValue: columnFilters![column]!.defaultValue,
        isSetted: values?.isNotEmpty ?? false);
    _loadAsync(false);
  }
}

/*class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}*/

class ListIntChartData {
  ListIntChartData(this.data, this.name);

  final String name;
  final List<IntChartData> data;
}

class IntChartData {
  IntChartData(this.x, this.y, {this.name});

  final String x;
  final int? y;
  final String? name;
}

class IntChartDataEx {
  IntChartDataEx(this.x, this.y, {this.names});

  final String x;
  final List<int> y;
  final List<String>? names;
}

enum Type {
  mobile,
  desktop,
}