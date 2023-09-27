import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/connected_client_info.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_history.dart';
import 'package:dpicenter/models/server/machine_note.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_production_file.dart';
import 'package:dpicenter/models/server/machine_production_picture.dart';
import 'package:dpicenter/models/server/machine_reminder.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/machine_setting_file.dart';
import 'package:dpicenter/models/server/machine_setting_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/media_item.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/vmc_production.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/connected_clients/connected_clients_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/machines/machine_edit_screen.dart';
import 'package:dpicenter/screen/master-data/machines/machine_productions_view.dart';
import 'package:dpicenter/screen/master-data/machines/machine_settings_view.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dialog_header.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:intl/intl.dart' as intl;
import 'package:barcode_scan2/barcode_scan2.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class MachinesScreen extends StatefulWidget {
  const MachinesScreen(
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
  _MachinesScreenState createState() => _MachinesScreenState();
}

class _MachinesScreenState extends State<MachinesScreen> {
  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;

  String? deviceConnected;

  bool _showHistory = false;

  Machine? _currentLastSelectedItem;
  MapSettingKey? _selectedMapSettingKey;

  final ScrollController _gridViewScrollController =
      ScrollController(debugLabel: "_gridViewScrollController");
  final ScrollController _historyItemScrollController =
      ScrollController(debugLabel: "_historyItemScrollController");

  final GlobalKey<DataScreenState> _machineScreenKey =
      GlobalKey<DataScreenState>(debugLabel: 'machineScreenKey');

  int currentMillis = 350;

  @override
  void initState() {
    super.initState();
    _connectToMessageHub();
  }

  @override
  void dispose() {
    super.dispose();
    eventBusSubscription?.cancel();
    _gridViewScrollController.dispose();
    _historyItemScrollController.dispose();
  }

  _connectToMessageHub() {
    try {
      eventBusSubscription = eventBus.on<ScanHubEvent>().listen((event) {
        List<String> result = (event.scanResult ?? '').split("\t");
        if (result.length == 2 && result.first == 'machine_screen_ex') {
          searchByQrCode(result[1]);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void didUpdateWidget(covariant MachinesScreen oldWidget) {
    print("didUpdateWidget");

    ///per evitare che si attivino le animazioni quando si ridimensiona la finestra
    currentMillis = 0;
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentMillis = 350;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return LayoutBuilder(builder: (context, constraints) {
      if (kDebugMode) {
        print("constraints: $constraints");
      }
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            AnimatedPositioned(
                width: _showHistory
                    ? constraints.maxWidth < 500
                        ? constraints.maxWidth
                        : constraints.maxWidth - 300
                    : constraints.maxWidth,
                height: constraints.maxHeight,
                duration: Duration(milliseconds: currentMillis),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  child: _dataScreen(),
                )),
            AnimatedPositioned(
                duration: Duration(milliseconds: currentMillis),
                curve: Curves.easeIn,
                left: _showHistory
                    ? constraints.maxWidth < 500
                        ? 0
                        : constraints.maxWidth - 300
                    : constraints.maxWidth,
                width: constraints.maxWidth < 500 ? constraints.maxWidth : 300,
                height: constraints.maxHeight,
                child: BlocListener<ServerDataBloc<MachineHistory>,
                    ServerDataState<MachineHistory>>(
                  listener: (BuildContext context,
                      ServerDataState<MachineHistory> state) {},
                  child: BlocBuilder<ServerDataBloc<MachineHistory>,
                          ServerDataState<MachineHistory>>(
                      builder: (BuildContext context,
                          ServerDataState<MachineHistory> state) {
                    Widget? child;
                    if (state is ServerDataLoaded<MachineHistory>) {
                      child = Column(
                        children: [
                          SizedBox(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0),
                                child: ListTile(
                                  title: DialogHeader(
                                    "Storia ${state.event?.queryModel?.id}",
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
                                              _showHistory = !_showHistory;
                                            });
                                          })),
                                ),
                              )),
                          Expanded(child: _historyList(state.items!)),
                        ],
                      );
                    } else {
                      child = _showHistory
                          ? Column(
                              children: [
                                SizedBox(
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 0),
                                      child: ListTile(
                                        title: DialogHeader(
                                          "Storia ${state.event?.queryModel?.id}",
                                          style:
                                              _matricolaTextStyle(fontSize: 24),
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
                                                    _showHistory =
                                                        !_showHistory;
                                                  });
                                                })),
                                      ),
                                    )),
                                Expanded(
                                    child: Center(
                                        key: const ValueKey("center"),
                                        child: SizedBox(
                                            width: 128,
                                            height: 128,
                                            child: LoadingIndicator(
                                              indicatorType: Indicator.pacman,
                                              colors: [
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                Colors.red,
                                                Colors.blue,
                                              ],
                                            )))),
                              ],
                            )
                          : null;
                    }
                    return Container(
                      color: isDarkTheme(context)
                          ? Color.alphaBlend(
                              Theme.of(context).primaryColor.withAlpha(230),
                              Theme.of(context).colorScheme.primary)
                          : Color.alphaBlend(
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withAlpha(230),
                              Theme.of(context).colorScheme.primary),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: child,
                      ),
                    );
                  }),
                )),
          ],
        ),
      );
    });
  }

  Widget _historyList(List<MachineHistory> historyItems) {
    return ListView(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        //crossAxisCount: 1,
        // Generate 100 widgets that display their index in the List.
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        //childAspectRatio: 1,
        //mainAxisSpacing: 4,
        //crossAxisSpacing: 4,
        controller: _gridViewScrollController,
        children: List.generate(historyItems.length,
            (index) => _historyItem(historyItems.reversed.toList(), index)));
  }

  Widget _historyItem(List<MachineHistory> historyItems, int index) {
    MachineHistory item = historyItems[index];
    Map<int, List<bool>> map = <int, List<bool>>{};
    int customerField = 2;
    int factoryField = 3;
    int machineIdField = 5;

    bool customerChanged = false;
    bool factoryChanged = false;
    bool machineIdChanged = false;

    if (index < historyItems.length - 1) {
      MachineHistory oldItem = historyItems[index + 1];
      List<bool> fieldsChanged = <bool>[];
      for (int field = 0; field < item.props.length; field++) {
        if (item.props[field] != oldItem.props[field]) {
          if (field == customerField) {
            customerChanged = true;
          }
          if (field == factoryField) {
            factoryChanged = true;
          }
          if (field == machineIdField) {
            machineIdChanged = true;
          }
          fieldsChanged.add(true);
        } else {
          fieldsChanged.add(false);
        }
      }
      map.addAll({index: fieldsChanged});
    }

    String date = applyFormat(item.date, 'dd/MM/yyyy HH:mm:ss').toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: InkWell(
            onTap: () {},
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Text("Data", style: _headerTextStyle()),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Text(
                            date,
                            textAlign: TextAlign.center,
                            style: _dataTextStyle(),
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Text("Cliente ${customerChanged ? '*' : ''}",
                              style: _headerTextStyle()),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Flexible(
                            child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          decoration: _fieldBoxDecoration(customerChanged),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Text(item.customer?.toString() ?? '',
                                style: _dataTextStyle()),
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Text(
                              "Stabilimento ${factoryChanged ? '*' : ''}",
                              style: _headerTextStyle()),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Flexible(
                            child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          decoration: _fieldBoxDecoration(factoryChanged),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Text(item.stabilimento?.toString() ?? '',
                                style: _dataTextStyle()),
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Text(
                              "Matricola Multi-Tech ${machineIdChanged ? '*' : ''}",
                              style: _headerTextStyle()),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Flexible(
                            child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          decoration: _fieldBoxDecoration(factoryChanged),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Text(
                                item.machineId?.toString() ?? 'Non impostata',
                                style: _matricolaTextStyle()),
                          ),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 30,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.person,
                                color: Color.alphaBlend(
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withAlpha(100),
                                    isDarkTheme(context)
                                        ? Colors.white
                                        : Colors.black),
                                size: 16,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                  "${item.name?.toString() ?? 'Non impostata'} ${item.surname?.toString() ?? 'Non impostata'}",
                                  style: _matricolaTextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _fieldBoxDecoration(bool highlight) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: highlight
            ? Border.all(
                color: Color.alphaBlend(
                    Theme.of(context).highlightColor.withAlpha(100),
                    Colors.yellow))
            : null);
  }

  TextStyle _headerTextStyle() {
    return TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary.withAlpha(150));
  }

  TextStyle _dataTextStyle() {
    return TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color.alphaBlend(
            Theme.of(context).colorScheme.primary.withAlpha(100),
            isDarkTheme(context) ? Colors.white : Colors.black));
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

  Widget _dataScreen() {
    return DataScreen<Machine>(
      keyName: 'matricola',
      key: _machineScreenKey,
      actions: [
        IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () async {
            String? qrCodeString;
            if (isMobile) {
              qrCodeString = await scanCodeWithCamera2();
            } else {
              if (deviceConnected == null) {
                var result = await openConnectedClients(context,
                    userFilter:
                        ApplicationUser.getUserFromSetting()?.userName ?? '',
                    openType: ConnectedClientsScreenOpenType.select);
                if (result != null && result is ConnectedClientInfo) {
                  setState(() {
                    deviceConnected = result.sessionId;
                    sendCommandToUser(messageHub, "ScanRequest",
                        deviceConnected!, "machine_screen_ex");
                  });
                }
              } else {
                sendCommandToUser(messageHub, "ScanRequest", deviceConnected!,
                    "machine_screen_ex");
              }
            }

            searchByQrCode(qrCodeString);
          },
        ),
        if (deviceConnected != null)
          IconButton(
            icon: const Icon(Icons.phonelink_erase),
            onPressed: () async {
              await showMessage(context,
                  title: 'Disconnessione dispositivo',
                  message: 'Disconnettersi dal dispositivo',
                  type: MessageDialogType.yesNo, okPressed: () {
                setState(() {
                  deviceConnected = null;
                  Navigator.of(context).pop(true);
                });
              });
            },
          ),
      ],
      bottomActions: [
        IconButton(
          tooltip: "Storia macchina",
          icon: const Icon(
            Icons.history,
          ),
          color: getBottomNavigatorBarForegroundColor(context),
          onPressed: () {
            setState(() {
              _showHistory = !_showHistory;
              if (_showHistory) {
                _loadHistory();
              }
            });
          },
        ),
        IconButton(
          tooltip: "Impostazioni macchina",
          icon: const Icon(
            Icons.settings,
          ),
          color: getBottomNavigatorBarForegroundColor(context),
          onPressed: () async {
            if (_currentLastSelectedItem != null) {
              if (_currentLastSelectedItem!.machineSettings == null) {
                List<Machine>? machinesDownloaded = await downloadMachine(
                    context, _currentLastSelectedItem!.matricola ?? '');
                if (machinesDownloaded != null &&
                    machinesDownloaded.isNotEmpty) {
                  _currentLastSelectedItem = machinesDownloaded[0];
                }
              }
              showMachineSettings(_currentLastSelectedItem!);
            }
          },
        ),
        IconButton(
          tooltip: "Preparazione macchina",
          icon: const Icon(
            Icons.checklist,
          ),
          color: getBottomNavigatorBarForegroundColor(context),
          onPressed: () async {
            if (_currentLastSelectedItem != null) {
              if (_currentLastSelectedItem!.machineSettings == null) {
                List<Machine>? machinesDownloaded = await downloadMachine(
                    context, _currentLastSelectedItem!.matricola ?? '');
                if (machinesDownloaded != null &&
                    machinesDownloaded.isNotEmpty) {
                  _currentLastSelectedItem = machinesDownloaded[0];
                }
              }
              showMachineState(_currentLastSelectedItem!);
            }
          },
        ),
      ],
      customBackClick: widget.customBackClick,
      configuration: DataScreenConfiguration(
          withBackButton: widget.withBackButton,
          repoName: "Machines",
          title: widget.title,
          useIntrinsicRowHeight: false,
          columns: [
            DataScreenColumnConfiguration(
                id: 'matricola',
                label: 'Matricola',
                labelType: LabelType.itemValue,
                customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.recalculateCellValue,
                    recalculateCellValue: (value) {
                      return ColumnSizerRecalculateResult(
                          result: const Text("00000000000000"));
                    })),
            DataScreenColumnConfiguration(
                id: 'machineId',
                label: 'Matr. Multi-Tech',
                labelType: LabelType.miniItemValue,
                customSizer: ColumnSizerRule(
                    ruleType: ColumnSizerRuleType.recalculateCellValue,
                    recalculateCellValue: (value) {
                      return ColumnSizerRecalculateResult(
                          result: const Text("00000000000000"));
                    })),
            DataScreenColumnConfiguration(
                id: 'vmc.description',
                label: 'Modello',
                labelType: LabelType.itemValue),
            /* DataScreenColumnConfiguration(
                id: 'modello.descrizione', label: 'Modello (old)'),*/
            DataScreenColumnConfiguration(
                id: 'customer.description',
                label: 'Cliente',
                filterType: MultiFilterType.selection,
                itemAsString: (dynamic item) =>
                (item as Machine).customer?.description ?? '',
                labelType: LabelType.itemValue),
            DataScreenColumnConfiguration(
                id: 'stabilimento.description',
                label: 'Stabilimento',
                labelType: LabelType.itemValue),
            DataScreenColumnConfiguration(
                id: 'stabilimento.indirizzo',
                label: 'Indirizzo',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'stabilimento.cap',
                label: 'CAP',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'stabilimento.provincia',
                label: 'Provincia',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'stabilimento.comune',
                label: 'Comune',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'stato',
                label: 'Stato',
                labelType: LabelType.miniItemValue),
            DataScreenColumnConfiguration(
                id: 'reparto',
                label: 'Reparto',
                labelType: LabelType.miniItemValue),
          ].toList(),
          menu: widget.menu),
      openNew: MachineActions.openNew,
      openDetail: MachineActions.openDetail,
      delete: MachineActions.delete,
      onAdd: MachineActions.onAdd,
      onUpdate: MachineActions.onUpdate,
      onSelectionChanged: (list, item) {
        try {
          if (_currentLastSelectedItem != item) {
            setState(() {
              _currentLastSelectedItem = item;
            });
            if (_showHistory) {
              _loadHistory();
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
      onLoaded: (items) => _reloadHistory(),
    );
  }

  void searchByQrCode(String? qrCodeString) {
    if (qrCodeString != null) {
      List<String> data = qrCodeString.split('#');

      if (data.length == 2) {
        String customMatricola = data[0];
        String type = data[1];
        if (_machineScreenKey.currentState != null &&
            _machineScreenKey.currentState!.currentItems != null) {
          for (Machine element in _machineScreenKey.currentState!.currentItems!
              as List<Machine>) {
            if (element.machineId != null &&
                element.machineId == customMatricola) {
              switch (type.toUpperCase()) {
                case 'SETTINGS':
                  _machineScreenKey.currentState?.scrollToItem(element);
                  _currentLastSelectedItem = element;
                  showMachineSettings(element);
                  return;
                case 'STATE':
                  _machineScreenKey.currentState?.scrollToItem(element);
                  _currentLastSelectedItem = element;
                  showMachineState(element);
                  return;
              }
            }
          }
        }
      }
      showQrReadErrorMessage(
          'Codice non trovato', 'Il codice $qrCodeString non è stato trovato');
    } else {}
  }

  Future<String?> scanCodeWithCamera2() async {
    var result = await BarcodeScanner.scan();
    if (result.type != ResultType.Cancelled) {
      return result.rawContent;
    } else {
      //player?.play(AssetSource('audio/se_non_bestemmio.mp3'));
      debugPrint("scan cancelled");
    }
    return null;
  }

  void showMachineSettings(Machine machine) {
    Machine clonedMachine = MachineActions.cloneMachine(machine);
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkTheme(context)
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withAlpha(240),
              Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.surface,
      builder: (BuildContext bottomSheetContext) {
        return SizedBox(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Center(
                    child: MachineSettingsView(
              topPadding: 40,
              title:
                  "${clonedMachine.matricola} - ${clonedMachine.stabilimento?.description ?? ''}",
              machine: clonedMachine,
              closePressed: () {
                Navigator.pop(bottomSheetContext);
                return false;
              },
              savePressed: () {
                _machineScreenKey.currentState
                    ?.update(clonedMachine, onEvent: MachineActions.onUpdate);
                _currentLastSelectedItem = clonedMachine;
                return true;
              },
            ))),
          ],
        ));
      },
    );
  }

  void showQrReadErrorMessage(String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: title,
            message: message,
            type: MessageDialogType.okOnly,
            okText: 'OK',
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
  }

  void showMachineState(Machine machine) {
    Machine clonedMachine = MachineActions.cloneMachine(machine);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: isDarkTheme(context)
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withAlpha(240),
              Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.surface,
      builder: (BuildContext bottomSheetContext) {
        return SizedBox(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Center(
                    child: MachineProductionsView(
              title:
                  "${clonedMachine.matricola} - ${clonedMachine.stabilimento?.description ?? ''}",
              topPadding: 40,
              maxWidth: null,
              machine: clonedMachine,
              closePressed: () {
                Navigator.pop(bottomSheetContext);
                return false;
              },
              savePressed: () {
                _machineScreenKey.currentState
                    ?.update(clonedMachine, onEvent: MachineActions.onUpdate);
                _currentLastSelectedItem = clonedMachine;
                return true;
                //Navigator.pop(bottomSheetContext);
              },
            ))),
          ],
        ));
      },
    );
  }

  _reloadHistory() {
    if (_showHistory) {
      _loadHistory();
    }
  }

  _loadHistory() {
    //print(T);

    /*if (kDebugMode) {
      print(context);
    }*/

    //BlocProvider.of<ServerDataBloc<T>>(context).add(ServerDataEvent(status: ServerDataEvents.fetch));
    if (_currentLastSelectedItem != null &&
        _currentLastSelectedItem!.matricola != null) {
      var bloc = BlocProvider.of<ServerDataBloc<MachineHistory>>(context);

      bloc.add(ServerDataEvent<MachineHistory>(
          status: ServerDataEvents.fetch,
          queryModel: QueryModel(id: _currentLastSelectedItem!.matricola!),
          refresh: true,
          columnFilters: null,
          customFilters: null));
    }
  }

  String applyFormat(dynamic value, String format) {
    final parseValue = DateTime.tryParse('${value}Z');

    if (parseValue == null) {
      return '';
    }

    return intl.DateFormat(format)
        .format(DateTime.parse('${value}Z').toLocal());
  }
}

class MachineActions {
  static Future openNew(context) async {
    final GlobalKey<MachineEditFormState> formKey =
        GlobalKey<MachineEditFormState>(debugLabel: "_formKey");

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(
              onWillPop: () async {
                return await onWillPop(formKey);
              },
              content: MultiBlocProvider(
                providers: getProviders(),
                child: MachineEditForm(
                    key: formKey, element: null, title: "Nuova macchina"),
              ));
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  static List<BlocProvider> getProviders() {
    return [
      BlocProvider<ServerDataBloc<Customer>>(
        lazy: false,
        create: (context) => ServerDataBloc<Customer>(
            repo: MultiService<Customer>(Customer.fromJsonModel,
                apiName: "Customer")),
      ),
      BlocProvider<ServerDataBloc<Machine>>(
        lazy: false,
        create: (context) => ServerDataBloc<Machine>(
            repo: MultiService<Machine>(Machine.fromJsonModel,
                apiName: "VMMachine")),
      ),
      BlocProvider<ServerDataBloc<Vmc>>(
        lazy: false,
        create: (context) => ServerDataBloc<Vmc>(
            repo: MultiService<Vmc>(Vmc.fromJsonModel, apiName: "Vmc")),
      ),
      BlocProvider<ServerDataBloc<VmcSetting>>(
        lazy: false,
        create: (context) => ServerDataBloc<VmcSetting>(
            repo: MultiService<VmcSetting>(VmcSetting.fromJsonModel,
                apiName: "VmcSetting")),
      ),
      BlocProvider<ServerDataBloc<VmcProduction>>(
        lazy: false,
        create: (context) => ServerDataBloc<VmcProduction>(
            repo: MultiService<VmcProduction>(VmcProduction.fromJsonModel,
                apiName: "VmcProduction")),
      ),
      BlocProvider<ServerDataBloc<VmcSettingCategory>>(
        lazy: false,
        create: (context) => ServerDataBloc<VmcSettingCategory>(
            repo: MultiService<VmcSettingCategory>(
                VmcSettingCategory.fromJsonModel,
                apiName: "VmcSettingCategory")),
      ),
    ];
  }

  static Machine cloneMachine(Machine item) {
    return item.copyWith(
      machineSettings: item.machineSettings
          ?.map((e) => e.copyWith(
              images:
                  e.images?.map((e) => e.copyWith()).toList(growable: true)))
          .toList(growable: false),
      machineProductions: item.machineProductions
          ?.map((e) => e.copyWith(
              images:
                  e.images?.map((e) => e.copyWith()).toList(growable: true)))
          .toList(growable: false),
      machineNotes:
          item.machineNotes?.map((e) => e.copyWith()).toList(growable: true),
      machineReminders: item.machineReminders
          ?.map((e) => e.copyWith())
          .toList(growable: true),
    );
  }

  static dynamic openDetail(context, Machine item) async {
    final GlobalKey<MachineEditFormState> formKey =
        GlobalKey<MachineEditFormState>(debugLabel: "formKey");

    if (item.machineSettings == null) {
      List<Machine>? machinesDownloaded =
          await downloadMachine(context, item.matricola ?? '');
      if (machinesDownloaded != null && machinesDownloaded.isNotEmpty) {
        item = machinesDownloaded[0];
      }
    }

    Machine itemCopy = cloneMachine(item);

    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return editItem(formKey, itemCopy);
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });

    return result;
  }

  static dynamic editItem(GlobalKey<MachineEditFormState> key, Machine item,
      {bool saveDirectly = false, String? selectedCategory}) {
    return multiDialog(
        onWillPop: () async {
          return await onWillPop(key);
        },
        content: MultiBlocProvider(
            providers: getProviders(),
            child: MachineEditForm(
                key: key,
                element: item,
                saveDirectly: saveDirectly,
                selectCategory: selectedCategory,
                title: "Modifica macchina")));
  }

  static dynamic openDetailAndSave(context, Machine item,
      {String? selectedCategory}) async {
    final GlobalKey<MachineEditFormState> formKey =
        GlobalKey<MachineEditFormState>(debugLabel: "formKey");

    Machine itemCopy = cloneMachine(item);

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
    MultiService<Media> mediasService =
        MultiService<Media>(Media.fromJsonModel, apiName: "Media");
    MultiService<Machine> machinesService =
        MultiService<Machine>(Machine.fromJsonModel, apiName: "VMMachine");

    Machine item = event.item as Machine;
    emit(ServerDataLoading<Machine>(event: event));

    ///ci sono delle immagini da salvare nei productions?
    try {
      if (item.machineProductions != null &&
          item.machineProductions!
              .where((element) => element.images?.isNotEmpty ?? false)
              .isNotEmpty) {
        for (int index = 0; index < item.machineProductions!.length; index++) {
          if (item.machineProductions![index].images != null &&
              item.machineProductions![index].images!.isNotEmpty) {
            for (int imageIndex = 0;
                imageIndex < item.machineProductions![index].images!.length;
                imageIndex++) {
              MachineProductionPicture machineProductionPicture =
                  item.machineProductions![index].images![imageIndex];

              /// mediaId == -1 -> cancellato
              /// mediaId == 0 -> nuovo
              /// mediaId >= 1 -> già inserito
              if (machineProductionPicture.mediaId == 0 &&
                  machineProductionPicture.picture != null) {
                ///solo le immagini nuove

                ///codifica in base64
                String? encoded = await encodeBase64(
                    machineProductionPicture.picture!.bytes!);
                if (encoded != null) {
                  machineProductionPicture = machineProductionPicture.copyWith(
                      picture: machineProductionPicture.picture?.copyWith(
                          content: encoded,
                          mediaId:
                              machineProductionPicture.picture?.mediaId ?? 0));
                  item.machineProductions![index].images![imageIndex] =
                      machineProductionPicture;
                }
              }
            }
          }
        }
      }

      ///ci sono dei file da salvare nei productions?
      if (item.machineProductions != null &&
          item.machineProductions!
              .where((element) => element.files?.isNotEmpty ?? false)
              .isNotEmpty) {
        for (int index = 0; index < item.machineProductions!.length; index++) {
          if (item.machineProductions![index].files != null &&
              item.machineProductions![index].files!.isNotEmpty) {
            for (int fileIndex = 0;
                fileIndex < item.machineProductions![index].files!.length;
                fileIndex++) {
              MachineProductionFile itemFile =
                  item.machineProductions![index].files![fileIndex];

              /// mediaId == -1 -> cancellato
              /// mediaId == 0 -> nuovo
              /// mediaId >= 1 -> già inserito
              if (itemFile.mediaId == 0 && itemFile.file != null) {
                ///codifica in base64
                String? encoded = await encodeBase64(itemFile.file!.bytes!);
                if (encoded != null) {
                  itemFile = itemFile.copyWith(
                      file: itemFile.file?.copyWith(
                          content: encoded,
                          mediaId: itemFile.file?.mediaId ?? 0));
                }

                var result = await mediasService.add(itemFile.file!,
                    onSendProgress: (sent, total) {
                  emit(ServerDataLoadingSendProgress<Machine>(
                      event: event, sent: sent, total: total));
                }, onReceiveProgress: (sent, total) {
                  emit(ServerDataLoadingReceiveProgress<Machine>(
                      event: event, sent: sent, total: total));
                });
                if (result != null && result.isNotEmpty) {
                  emit(ServerDataLoading<Machine>(event: event));
                  debugPrint(
                      "Salvataggio file ${result[0].mediaId.toString()} riuscito");
                  itemFile =
                      itemFile.copyWith(mediaId: result[0].mediaId, file: null);
                  item.machineProductions![index].files![fileIndex] = itemFile;
                }
              }
            }
          }
        }
      }

      ///ci sono delle immagini da salvare nei settings?
      if (item.machineSettings != null &&
          item.machineSettings!
              .where((element) => element.images?.isNotEmpty ?? false)
              .isNotEmpty) {
        for (int index = 0; index < item.machineSettings!.length; index++) {
          if (item.machineSettings![index].images != null &&
              item.machineSettings![index].images!.isNotEmpty) {
            for (int imageIndex = 0;
                imageIndex < item.machineSettings![index].images!.length;
                imageIndex++) {
              MachineSettingPicture machineSettingPicture =
                  item.machineSettings![index].images![imageIndex];

              /// mediaId == -1 -> cancellato
              /// mediaId == 0 -> nuovo
              /// mediaId >= 1 -> già inserito
              if (machineSettingPicture.mediaId == 0 &&
                  machineSettingPicture.picture != null) {
                ///solo le immagini nuove

                ///codifica in base64
                String? encoded =
                    await encodeBase64(machineSettingPicture.picture!.bytes!);
                if (encoded != null) {
                  machineSettingPicture = machineSettingPicture.copyWith(
                      picture: machineSettingPicture.picture?.copyWith(
                          content: encoded,
                          mediaId:
                              machineSettingPicture.picture?.mediaId ?? 0));
                  item.machineSettings![index].images![imageIndex] =
                      machineSettingPicture;
                }
              }
            }
          }
        }
      }

      ///ci sono dei file da salvare nei settings?
      if (item.machineSettings != null &&
          item.machineSettings!
              .where((element) => element.files?.isNotEmpty ?? false)
              .isNotEmpty) {
        for (int index = 0; index < item.machineSettings!.length; index++) {
          if (item.machineSettings![index].files != null &&
              item.machineSettings![index].files!.isNotEmpty) {
            for (int fileIndex = 0;
                fileIndex < item.machineSettings![index].files!.length;
                fileIndex++) {
              MachineSettingFile itemFile =
                  item.machineSettings![index].files![fileIndex];

              /// mediaId == -1 -> cancellato
              /// mediaId == 0 -> nuovo
              /// mediaId >= 1 -> già inserito
              if (itemFile.mediaId == 0 && itemFile.file != null) {
                ///codifica in base64
                String? encoded = await encodeBase64(itemFile.file!.bytes!);
                if (encoded != null) {
                  itemFile = itemFile.copyWith(
                      file: itemFile.file?.copyWith(
                          content: encoded,
                          mediaId: itemFile.file?.mediaId ?? 0));
                }

                var result = await mediasService.add(itemFile.file!,
                    onSendProgress: (sent, total) {
                  emit(ServerDataLoadingSendProgress<Machine>(
                      event: event, sent: sent, total: total));
                }, onReceiveProgress: (sent, total) {
                  emit(ServerDataLoadingReceiveProgress<Machine>(
                      event: event, sent: sent, total: total));
                });
                if (result != null && result.isNotEmpty) {
                  emit(ServerDataLoading<Machine>(event: event));
                  debugPrint(
                      "Salvataggio file ${result[0].mediaId.toString()} riuscito");
                  itemFile =
                      itemFile.copyWith(mediaId: result[0].mediaId, file: null);
                  item.machineSettings![index].files![fileIndex] = itemFile;
                }
              }
            }
          }
        }
      }

      var result =
      await machinesService.add(item, onSendProgress: (sent, total) {
        emit(ServerDataLoadingSendProgress<Machine>(
            event: event, sent: sent, total: total));
      }, onReceiveProgress: (sent, total) {
        emit(ServerDataLoadingReceiveProgress<Machine>(
            event: event, sent: sent, total: total));
      });

      if (result != null && result.isNotEmpty) {
        emit(ServerDataAdded<Machine>(event: event, item: result[0]));
        return result;
      }
    } catch (e) {
      print(e);

      /*emit(ServerDataError<Machine>(
        event: event,
        error: e, //InvalidFormatException('Invalid Response format'),
      ));*/
      rethrow;
    }
  }

  static dynamic onUpdate(
      Bloc bloc, ServerDataEvent event, Emitter emit) async {
    MultiService<Media> mediasService =
        MultiService<Media>(Media.fromJsonModel, apiName: "Media");
    MultiService<Machine> machinesService =
        MultiService<Machine>(Machine.fromJsonModel, apiName: "VMMachine");

    Machine item = event.item as Machine;
    emit(ServerDataLoading<Machine>(event: event));

    ///ci sono delle immmagini da salvare nei productions?
    if (item.machineProductions != null &&
        item.machineProductions!
            .where((element) => element.images?.isNotEmpty ?? false)
            .isNotEmpty) {
      for (int index = 0; index < item.machineProductions!.length; index++) {
        if (item.machineProductions![index].images != null &&
            item.machineProductions![index].images!.isNotEmpty) {
          for (int imageIndex = 0;
              imageIndex < item.machineProductions![index].images!.length;
              imageIndex++) {
            MachineProductionPicture machineProductionPicture =
                item.machineProductions![index].images![imageIndex];

            /// mediaId == -1 -> cancellato
            /// mediaId == 0 -> nuovo
            /// mediaId >= 1 -> già inserito

            switch (machineProductionPicture.mediaId) {
              case -1: //da eliminare
                ///vado a rimuovere itemPicture.pictureId dalla tabella Medias
                ///questa azione rimuoverà anche l'itemPicture dalla tabella itemPictures
                //toRemove.add(itemPicture);
                await mediasService
                    .deleteList(<Media>[machineProductionPicture.picture!]);

                break;
              case 0: //nuovo
                ///codifica in base64

                String? encoded = await encodeBase64(
                    machineProductionPicture.picture!.bytes!);
                if (encoded != null) {
                  machineProductionPicture = machineProductionPicture.copyWith(
                      picture: machineProductionPicture.picture?.copyWith(
                          content: encoded,
                          mediaId:
                              machineProductionPicture.picture?.mediaId ?? 0));

                  var result = await mediasService
                      .add(machineProductionPicture.picture!,
                          onSendProgress: (sent, total) {
                    emit(ServerDataLoadingSendProgress<Machine>(
                        event: event, sent: sent, total: total));
                  }, onReceiveProgress: (sent, total) {
                    emit(ServerDataLoadingReceiveProgress<Machine>(
                        event: event, sent: sent, total: total));
                  });
                  if (result != null && result.isNotEmpty) {
                    emit(ServerDataLoading<Machine>(event: event));
                    debugPrint(
                        "Salvataggio picture ${result[0].mediaId.toString()} riuscito");
                    item.machineProductions![index].images![imageIndex] =
                        machineProductionPicture.copyWith(
                            mediaId: result[0].mediaId, picture: null);
                  }
                  break;
                }
            }
          }
        }

        ///rimuovo le picture dall'items (non ho bisogno di reinviarle al server)
        if (item.machineProductions![index].images != null) {
          List<MachineProductionPicture> newList = <MachineProductionPicture>[];
          for (MachineProductionPicture itemPicture
              in item.machineProductions![index].images!) {
            if (itemPicture.mediaId != -1) {
              ///solo le immagini non cancellate
              newList.add(itemPicture.copyWith(
                  machineProductionId:
                      item.machineProductions![index].machineProductionId,
                  picture: null));
            }
          }
          item.machineProductions![index] =
              item.machineProductions![index].copyWith(images: newList);
        }
      }

      //item = item.copyWith(itemPictures: item.itemPictures!.map((e) => e.copyWith(itemId: item.itemId, picture: null)).toList(growable: false));
    }

    ///ci sono dei file da salvare nei productions?
    if (item.machineProductions != null &&
        item.machineProductions!
            .where((element) => element.files?.isNotEmpty ?? false)
            .isNotEmpty) {
      for (int index = 0; index < item.machineProductions!.length; index++) {
        if (item.machineProductions![index].files != null &&
            item.machineProductions![index].files!.isNotEmpty) {
          for (int fileIndex = 0;
              fileIndex < item.machineProductions![index].files!.length;
              fileIndex++) {
            MachineProductionFile itemFile =
                item.machineProductions![index].files![fileIndex];
            switch (itemFile.mediaId) {
              case -1: //da eliminare
                ///vado a rimuovere itemFile.mediaId dalla tabella Medias
                ///questa azione rimuoverà anche l'machineProductionFile dalla tabella MachineProductionFiles
                await mediasService.deleteList(<Media>[itemFile.file!]);
                break;
              case 0: //nuovo
                ///codifica in base64
                String? encoded = await encodeBase64(itemFile.file!.bytes!);
                if (encoded != null) {
                  itemFile = itemFile.copyWith(
                      file: itemFile.file?.copyWith(
                          content: encoded,
                          mediaId: itemFile.file?.mediaId ?? 0));
                }

                var result = await mediasService.add(itemFile.file!,
                    onSendProgress: (sent, total) {
                  emit(ServerDataLoadingSendProgress<Machine>(
                      event: event, sent: sent, total: total));
                }, onReceiveProgress: (sent, total) {
                  emit(ServerDataLoadingReceiveProgress<Machine>(
                      event: event, sent: sent, total: total));
                });
                if (result != null && result.isNotEmpty) {
                  emit(ServerDataLoading<Machine>(event: event));
                  debugPrint(
                      "Salvataggio file ${result[0].mediaId.toString()} riuscito");
                  itemFile =
                      itemFile.copyWith(mediaId: result[0].mediaId, file: null);
                  item.machineProductions![index].files![fileIndex] = itemFile;
                }
                break;

              default: //già inserito
              ///per ora non faccio nulla, successivamente vorrei gestire un campo descrizione
                break;
            }
          }

          ///rimuovo i files dall'items (non ho bisogno di reinviarle al server)
          if (item.machineProductions![index].files != null) {
            List<MachineProductionFile> newList = <MachineProductionFile>[];
            for (MachineProductionFile itemFile
                in item.machineProductions![index].files!) {
              if (itemFile.mediaId != -1) {
                ///solo le immagini non cancellate
                newList.add(itemFile.copyWith(
                    machineProductionId:
                        item.machineProductions![index].machineProductionId,
                    file: null));
              }
            }
            item.machineProductions![index] =
                item.machineProductions![index].copyWith(files: newList);
          }
        }
      }
    }

    ///ci sono delle immagini da salvare nei settings?
    if (item.machineSettings != null &&
        item.machineSettings!
            .where((element) => element.images?.isNotEmpty ?? false)
            .isNotEmpty) {
      for (int index = 0; index < item.machineSettings!.length; index++) {
        if (item.machineSettings![index].images != null &&
            item.machineSettings![index].images!.isNotEmpty) {
          for (int imageIndex = 0;
              imageIndex < item.machineSettings![index].images!.length;
              imageIndex++) {
            MachineSettingPicture machineSettingPicture =
                item.machineSettings![index].images![imageIndex];

            /// mediaId == -1 -> cancellato
            /// mediaId == 0 -> nuovo
            /// mediaId >= 1 -> già inserito

            switch (machineSettingPicture.mediaId) {
              case -1: //da eliminare
                ///vado a rimuovere itemPicture.pictureId dalla tabella Medias
                ///questa azione rimuoverà anche l'itemPicture dalla tabella itemPictures
                //toRemove.add(itemPicture);
                await mediasService
                    .deleteList(<Media>[machineSettingPicture.picture!]);

                break;
              case 0: //nuovo
                ///codifica in base64

                String? encoded =
                    await encodeBase64(machineSettingPicture.picture!.bytes!);
                if (encoded != null) {
                  machineSettingPicture = machineSettingPicture.copyWith(
                      picture: machineSettingPicture.picture?.copyWith(
                          content: encoded,
                          mediaId:
                              machineSettingPicture.picture?.mediaId ?? 0));

                  var result = await mediasService
                      .add(machineSettingPicture.picture!,
                          onSendProgress: (sent, total) {
                    emit(ServerDataLoadingSendProgress<Machine>(
                        event: event, sent: sent, total: total));
                  }, onReceiveProgress: (sent, total) {
                    emit(ServerDataLoadingReceiveProgress<Machine>(
                        event: event, sent: sent, total: total));
                  });
                  if (result != null && result.isNotEmpty) {
                    emit(ServerDataLoading<Machine>(event: event));
                    debugPrint(
                        "Salvataggio picture ${result[0].mediaId.toString()} riuscito");
                    item.machineSettings![index].images![imageIndex] =
                        machineSettingPicture.copyWith(
                            mediaId: result[0].mediaId, picture: null);
                  }
                  break;
                }
            }
          }
        }

        ///rimuovo le picture dall'items (non ho bisogno di reinviarle al server)
        if (item.machineSettings![index].images != null) {
          List<MachineSettingPicture> newList = <MachineSettingPicture>[];
          for (MachineSettingPicture itemPicture
              in item.machineSettings![index].images!) {
            if (itemPicture.mediaId != -1) {
              ///solo le immagini non cancellate
              newList.add(itemPicture.copyWith(
                  machineSettingId:
                      item.machineSettings![index].machineSettingId,
                  picture: null));
            }
          }
          item.machineSettings![index] =
              item.machineSettings![index].copyWith(images: newList);
        }
      }

      //item = item.copyWith(itemPictures: item.itemPictures!.map((e) => e.copyWith(itemId: item.itemId, picture: null)).toList(growable: false));
    }

    ///ci sono dei file da salvare nei settings?
    if (item.machineSettings != null &&
        item.machineSettings!
            .where((element) => element.files?.isNotEmpty ?? false)
            .isNotEmpty) {
      for (int index = 0; index < item.machineSettings!.length; index++) {
        if (item.machineSettings![index].files != null &&
            item.machineSettings![index].files!.isNotEmpty) {
          try {
            for (int fileIndex = 0;
                fileIndex < item.machineSettings![index].files!.length;
                fileIndex++) {
              MachineSettingFile itemFile =
                  item.machineSettings![index].files![fileIndex];
              switch (itemFile.mediaId) {
                case -1: //da eliminare
                  ///vado a rimuovere itemFile.mediaId dalla tabella Medias
                  ///questa azione rimuoverà anche l'machineProductionFile dalla tabella MachineProductionFiles
                  await mediasService.deleteList(<Media>[itemFile.file!]);
                  break;
                case 0: //nuovo
                  ///codifica in base64
                  String? encoded = await encodeBase64(itemFile.file!.bytes!);
                  if (encoded != null) {
                    itemFile = itemFile.copyWith(
                        file: itemFile.file?.copyWith(
                            content: encoded,
                            mediaId: itemFile.file?.mediaId ?? 0));
                  }

                  var result = await mediasService.add(itemFile.file!,
                      onSendProgress: (sent, total) {
                    emit(ServerDataLoadingSendProgress<Machine>(
                        event: event, sent: sent, total: total));
                  }, onReceiveProgress: (sent, total) {
                    emit(ServerDataLoadingReceiveProgress<Machine>(
                        event: event, sent: sent, total: total));
                  });
                  if (result != null && result.isNotEmpty) {
                    emit(ServerDataLoading<Machine>(event: event));
                    debugPrint(
                        "Salvataggio file ${result[0].mediaId.toString()} riuscito");
                    itemFile = itemFile.copyWith(
                        mediaId: result[0].mediaId, file: null);
                    item.machineSettings![index].files![fileIndex] = itemFile;
                  }
                  break;

                default: //già inserito
                ///per ora non faccio nulla, successivamente vorrei gestire un campo descrizione
                  break;
              }
            }
          } catch (e) {
            print(e);
          }

          ///rimuovo i files dall'items (non ho bisogno di reinviarle al server)
          try {
            if (item.machineSettings![index].files != null) {
              List<MachineSettingFile> newList = <MachineSettingFile>[];
              for (MachineSettingFile itemFile
                  in item.machineSettings![index].files!) {
                if (itemFile.mediaId != -1) {
                  ///solo le immagini non cancellate
                  newList.add(itemFile.copyWith(
                      machineSettingId:
                          item.machineSettings![index].machineSettingId,
                      file: null));
                }
              }
              item.machineSettings![index] =
                  item.machineSettings![index].copyWith(files: newList);
            }
          } catch (e) {
            print(e);
          }
        }
      }
    }

    var result =
    await machinesService.update(item, onSendProgress: (sent, total) {
      emit(ServerDataLoadingSendProgress<Machine>(
          event: event, sent: sent, total: total));
    }, onReceiveProgress: (sent, total) {
      emit(ServerDataLoadingReceiveProgress<Machine>(
          event: event, sent: sent, total: total));
    });

    if (result != null && result.isNotEmpty) {
      emit(ServerDataUpdated<Machine>(event: event, item: result[0]));
      return result;
    }
    return null;
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
