import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/globals/maps_utils.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/customers/customers_edit_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dashboard/reports_stat.dart';
import 'package:dpicenter/screen/widgets/dialog_header.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key,
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
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool _isSync = false;
  Customer? _currentLastSelectedItem;
  bool _showStats = false;
  final GlobalKey<DataScreenState> _dataScreenKey =
      GlobalKey<DataScreenState>(debugLabel: 'dataScreenKey');

  final GlobalKey<ReportStatState> _reportStatKey =
      GlobalKey<ReportStatState>(debugLabel: '_reportStatKey');

  final ScrollController _gridViewScrollController =
      ScrollController(debugLabel: "_gridViewScrollController");
  final ScrollController _statsScrollController =
      ScrollController(debugLabel: "_statsScrollController");

  final double _flyoutSize = 500;
  final double _tinyWidth = 600;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _gridViewScrollController.dispose();
    _statsScrollController.dispose();
  }

  int currentMillis = 350;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
                width: _showStats
                    ? constraints.maxWidth <= _tinyWidth
                        ? constraints.maxWidth
                        : constraints.maxWidth - _flyoutSize
                    : constraints.maxWidth,
                height: constraints.maxHeight,
                //    duration: Duration(milliseconds: currentMillis),
                child: Container(
                  //duration: const Duration(milliseconds: 0),
                  child: _getDataScreen(),
                )),
            Positioned(
              //duration: Duration(milliseconds: currentMillis),
              //curve: Curves.easeIn,
              left: _showStats
                  ? constraints.maxWidth <= _flyoutSize
                      ? 0
                      : constraints.maxWidth - _tinyWidth
                  : constraints.maxWidth,
              width: constraints.maxWidth <= _flyoutSize
                  ? constraints.maxWidth
                  : _tinyWidth,
              height: constraints.maxHeight,
              child: _reportStat(),
            ),
          ],
        );
      },
    );
  }

  Widget _reportStat() {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: isDarkTheme(context)
            ? Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(230),
                Theme.of(context).colorScheme.primary)
            : Color.alphaBlend(
                Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
                Theme.of(context).colorScheme.primary),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                child: ListTile(
                  title: DialogHeader(
                    _currentLastSelectedItem?.description ?? '',
                    style: _matricolaTextStyle(fontSize: 24),
                  ),
                  trailing: Material(
                      type: MaterialType.transparency,
                      clipBehavior: Clip.antiAlias,
                      shape: const CircleBorder(),
                      child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Color.alphaBlend(
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(100),
                                Colors.red),
                          ),
                          onPressed: () {
                            setState(() {
                              _showStats = !_showStats;
                            });
                          })),
                ),
              ),
              Expanded(
                child: getReportStat(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _matricolaTextStyle({double fontSize = 16}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        wordSpacing: 0,
        color: Color.alphaBlend(
            Theme.of(context).colorScheme.primary.withAlpha(100),
            isDarkTheme(context) ? Colors.white : Colors.black));
  }

  Widget getReportStat({double? tinyWidth}) {
    return MultiBlocProvider(
        //key: _reportStatBlocKey,
        providers: [
          BlocProvider<ServerDataBloc<Report>>(
            lazy: false,
            create: (context) => ServerDataBloc<Report>(
                repo: MultiService<Report>(Report.fromJsonModel,
                    apiName: 'Report')),
          ),
        ],
        child: ReportStat(
          key: _reportStatKey,
          tinyWidth: tinyWidth,
          showFilters: false,
          isReportsOpen: true,
          /*onLoaded: () {
              setState(() {
                reportStatLoaded = true;
              });
            }*/
        ));
  }

  Widget _getDataScreen() {
    return DataScreen<Customer>(
      keyName: 'customerId',
      key: _dataScreenKey,
      bottomActions: [
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _isSync == false
                ? IconButton(
                    tooltip: "Importa clienti da file Excel",
                    icon: const Icon(Icons.sync),
                    color: getBottomNavigatorBarForegroundColor(context),
                    onPressed: () async {
                      setState(() {
                  _isSync = true;
                });
                await Menu.importaClienti(context);
                setState(() {
                  _isSync = false;
                });
                if (mounted) {
                  _dataScreenKey.currentState?.reload();
                }
              },
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox.square(
                dimension: 32,
                child: Tooltip(
                    message: "Importazione clienti in corso...",
                    child: LoadingIndicator(
                        indicatorType: Indicator.pacman,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Colors.red,
                          Colors.blue
                        ])),
              ),
            )),
        IconButton(
          tooltip: "Apri in Google Maps",
          icon: const Icon(
            Icons.place,
          ),
          color: getBottomNavigatorBarForegroundColor(context),
          onPressed: () {
            //MapUtils.openMap(-3.823216,-38.481700);
            MapUtils.openMapLocation(_currentLastSelectedItem.toString());
            //http://maps.google.com/?q=your+query
          },
        ),
        IconButton(
          tooltip: "Storia interventi",
          icon: const Icon(
            Icons.leaderboard,
          ),
          color: getBottomNavigatorBarForegroundColor(context),
          onPressed: () {
            setState(() {
              _showStats = !_showStats;
              if (_showStats) {
                //_loadHistory();
              }
            });
          },
        )
      ],
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          useIntrinsicRowHeight: false,
          repoName: "Customers",
          title: widget.title,
          columns: [
            DataScreenColumnConfiguration(
                id: 'customerId',
                label: 'Id',
                labelType: LabelType.none,
                customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.recalculateCellValue,
                    recalculateCellValue: (value) {
                      return ColumnSizerRecalculateResult(
                          result: const Text("0000000000"));
                    })),
            DataScreenColumnConfiguration(
                id: 'code',
                label: 'Codice',
                labelType: LabelType.itemValue,
                customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.recalculateCellValue,
                    recalculateCellValue: (value) {
                      return ColumnSizerRecalculateResult(
                          result: const Text("0000000000"));
                    })),
            DataScreenColumnConfiguration(
                id: 'description',
                label: 'Descrizione',
                labelType: LabelType.itemValue),
            DataScreenColumnConfiguration(
                id: 'pIva',
                label: 'Partita IVA',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'cFiscale',
                label: 'Codice Fiscale',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'indirizzo',
                label: 'Indirizzo',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'cap', label: 'CAP', labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'comune',
                label: 'Comune',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'provincia',
                label: 'Provincia',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'nazione',
                label: 'Nazione',
                labelType: LabelType.miniItemValue),
          ].toList(),
          menu: widget.menu,
          canDelete: (selectedRows) {
            bool can = selectedRows
                .where((element) {
              if (element is DataGridRowWithItem) {
                if (element.item is Customer) {
                  return element.item.isManualEntry == null ||
                      element.item.isManualEntry == false;
                }
              }
              return false;
            })
                .toList(growable: false)
                .isEmpty;

            return can;

            ///va controllato anche se nella tabella delle macchine questo codice non sia già utilizzato
            ///

            return false;

            ///BaseServiceEx<Machine> machineService = BaseServiceEx<Machine>(Machine.fromJsonModel, apiName: 'Machine');
            ///machineService.get(QueryModel())
          }),
      openNew: CustomerActions.openNew,
      openDetail: CustomerActions.openDetail,
      delete: CustomerActions.delete,
      onSelectionChanged: (list, item) {
        try {
          if (_currentLastSelectedItem != item) {
            setState(() {
              _currentLastSelectedItem = item;
              _reportStatKey.currentState?.setColumnFilter(
                  'customer.description', [item?.description ?? '']);
            });
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant CustomersScreen oldWidget) {
    ///per evitare che si attivino le animazioni quando si ridimensiona la finestra
    currentMillis = 0;
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentMillis = 350;
    });
  }
}

class CustomerActions {
  static Future openNew(context) async {
    final GlobalKey<CustomerEditFormState> formKey =
        GlobalKey<CustomerEditFormState>(debugLabel: "_formKey");
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: CustomerEditForm(
                key: formKey,
                element: null,
                title: "Nuovo cliente",
                customers:
                    bloc.items != null ? bloc.items! as List<Customer> : [],
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static Customer cloneCustomer(Customer item) {
    return item.copyWith();
  }

  static dynamic openDetail(context, Customer item) async {
    final GlobalKey<CustomerEditFormState> formKey =
        GlobalKey<CustomerEditFormState>(debugLabel: "formKey");

    Customer itemCopy = cloneCustomer(item);

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: CustomerEditForm(
                key: formKey,
                element: itemCopy,
                title: "Modifica macchina",
                customers: const <Customer>[],
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });

    return result;
  }

  static dynamic delete(context, List<Customer> items) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare i clienti selezionati?',
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