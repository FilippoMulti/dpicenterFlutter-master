import 'dart:async';

import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/maps_utils.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_reminder.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/media_item.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/vmc_file.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtag_global.dart';
import 'package:dpicenter/screen/master-data/machines/machine_edit_screen.dart';
import 'package:dpicenter/screen/master-data/machines/machine_productions_view.dart';
import 'package:dpicenter/screen/master-data/machines/machine_screen_ex.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/master-data/vmcs/vmcs_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/useful/info_screen.dart';
import 'package:dpicenter/screen/useful/loading_screen.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select_container.dart';
import 'package:dpicenter/screen/widgets/dashboard/pusher.dart';
import 'package:dpicenter/screen/widgets/dashboard/reports_stat.dart';
import 'package:dpicenter/screen/widgets/dashboard/reportstat_container.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/file_loader/file_loader.dart';
import 'package:dpicenter/screen/widgets/note_editor/reminder_list.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

// Define a custom Form widget.
class DashboardNavigator extends StatefulWidget {
  const DashboardNavigator({Key? key}) : super(key: key);

  @override
  DashboardNavigatorState createState() => DashboardNavigatorState();
}

class DashboardNavigatorState extends State<DashboardNavigator> {
  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  //final ScrollController _machineFilterScrollController = ScrollController(debugLabel: '_machineFilterScrollController');
  final GlobalKey _searchFieldKey = GlobalKey(debugLabel: '_searchFieldKey');
  final GlobalKey _searchFieldScrollKey =
      GlobalKey(debugLabel: '_searchFieldScrollKey');

  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;

  ///chiavi per i campi da compilare
  final GlobalKey _statsKey = GlobalKey(debugLabel: '_statsKey');
  final GlobalKey _reminderKey = GlobalKey(debugLabel: '_reminderKey');
  final GlobalKey _docsKey = GlobalKey(debugLabel: '_docsKey');
  final GlobalKey<ReminderListState> _reminderListKey =
      GlobalKey<ReminderListState>(debugLabel: '_reminderListKey');

  late List<KeyValidationState> _keyStates;
  late ApplicationUser _user;

  List<MediaItem> selectedFiles = <MediaItem>[];

  List<Machine> selectedMachines = <Machine>[];
  List<Machine> totalMachines = <Machine>[];

  int totalReminders = 0;
  int totalDocuments = 0;

  /*///eventi MessageHub
  StreamSubscription? eventBusSubscription;*/

  bool ignoreRemindersMessage = false;
  final TextEditingController _searchMachineController =
      TextEditingController();
  final GlobalKey<FileLoaderState> _loaderKey =
      GlobalKey<FileLoaderState>(debugLabel: '_loaderKey');
  final GlobalKey<PusherState> _loaderPusherKey =
      GlobalKey<PusherState>(debugLabel: '_loaderPusherKey');
  final GlobalKey<PusherState> _machinePusherKey =
      GlobalKey<PusherState>(debugLabel: '_machinePusherKey');
  final GlobalKey _statSettingTileKey =
      GlobalKey(debugLabel: '_statSettingTileKey');
  final GlobalKey _docsSettingTileKey =
      GlobalKey(debugLabel: '_docsSettingTileKey');
  final GlobalKey _reminderSettingTileKey =
      GlobalKey(debugLabel: '_reminderSettingTileKey');
  final GlobalKey _machineSettingTileKey =
      GlobalKey(debugLabel: '_machineSettingTileKey');
  final GlobalKey _searchMachineFieldKey =
      GlobalKey(debugLabel: '_searchMachineFieldKey');

  @override
  void initState() {
    super.initState();
    initKeys();

    debugPrint("getUserFromSettings");
    _user = ApplicationUser.getUserFromSetting()!;
    //_connectToMessageHub();
    //_loadMachines();
  }

  @override
  void dispose() {
    ///eventi MessageHub
    eventBusSubscription?.cancel();
    _searchMachineController.dispose();
    //_machineFilterScrollController.dispose();

    _scrollController.dispose();
    /*eventBusSubscription?.cancel();*/
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _statsKey),
      KeyValidationState(key: _reminderKey),
      KeyValidationState(key: _docsKey),
    ];
  }

/*  _loadMachines() {
    var bloc = BlocProvider.of<ServerDataBloc<Machine>>(context);
    bloc.add(const ServerDataEvent<Machine>(
      status: ServerDataEvents.fetch,
    ));
  }*/

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return MultiSelectorContainer(
      useScrollable: false,
      scrollController: _scrollController,
      headerSectionsMap: {
        MultiSelectorItem(
            text: 'Macchine',
            icon: const Icon(Icons.bar_chart),
            elementCount: selectedMachines.isNotEmpty
                ? selectedMachines.length
                : null): _machineSettingTileKey,
        MultiSelectorItem(
                text: 'Promemoria',
                icon: const Icon(Icons.notifications),
                elementCount: totalReminders > 0 ? totalReminders : null):
            _reminderSettingTileKey,
        MultiSelectorItem(
                text: 'Documenti',
                icon: const Icon(Icons.description),
                elementCount: totalDocuments > 0 ? totalDocuments : null):
            _docsSettingTileKey,
        const MultiSelectorItem(
            text: 'Statistiche',
            icon: Icon(Icons.bar_chart)): _statSettingTileKey,
      },
      title: "Ciao ${_user.name}",
      child: FocusScope(
        child: Container(
          //constraints: const BoxConstraints(minWidth: 500, maxHeight: 800),
          decoration: BoxDecoration(
              color: getScaffoldBackgroundColor(),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  child: Scaffold(
                backgroundColor: getScaffoldBackgroundColor(),
                body: Container(
                  color: getScaffoldBackgroundColor(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Material(
                          type: MaterialType.transparency,
                          elevation: 8,
                          child: Container(
                            padding: EdgeInsets.zero,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: SettingsScroll(
                              controller: _scrollController,
                              darkTheme: SettingsThemeData(
                                settingsListBackground:
                                    getScaffoldBackgroundColor(),
                              ),
                              lightTheme: const SettingsThemeData(
                                  settingsListBackground: Colors.transparent),
                              //contentPadding: EdgeInsets.zero,
                              platform: DevicePlatform.web,
                              sections: [
                                _infoSection(),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //floatingActionButton: getFloatingActionButton(),
              )),

              ///qui posso aggiungere un footer
            ],
          ),
        ),
      ),
    );
  }

  Color getScaffoldBackgroundColor() {
    return isDarkTheme(context)
        ? Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(230),
            Theme.of(context).colorScheme.primary)
        : Color.alphaBlend(
            Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
            Theme.of(context).colorScheme.primary);
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
            //key: _reportStatKey,
            tinyWidth: tinyWidth,
            onLoaded: () {
              /*setState(() {
              reportStatLoaded = true;
            });*/
            }) /*LayoutBuilder(builder: (context, constraints) {
          return getResizableContainer(ReportStat(), "reportStat",
              maxWidth ?? constraints.maxWidth, maxHeight ?? constraints.maxHeight);
        })*/
        );
  }

  SettingsScrollSection _infoSection() {
    return SettingsScrollSection(margin: EdgeInsetsDirectional.zero, tiles: [
      _machinesSettingTile(),
      _reminderSettingTile(),
      _docsSettingTile(),
      _statsSettingTile(),
    ]);
  }

  SettingsTile _statsSettingTile() {
    var stat = Scaffold(
        appBar: AppBar(
            title: getHeroTitle('Statistiche assistenze', 'STATASS',
                Theme.of(context).textTheme.headlineSmall)),
        body: const ReportStatContainer());
    return getCustomSettingTile(
        key: _statSettingTileKey,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.bar_chart,
              color: Theme.of(context).textTheme.headlineSmall?.color,
            ),
            const SizedBox(
              width: 8,
            ),
            getHeroTitle('Statistiche assistenze', 'STATASS',
                Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        hint: 'Mostra le statistiche delle assistenza',
        description: 'Statistiche e grafici riguardanti i lavori effettuati',
        onPressed: (context) async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => stat),
          );
        },
        child: const SizedBox());
  }

  SettingsTile _docsSettingTile() {
    /*var docs = Scaffold(
        appBar: AppBar(
            title: getHeroTitle('Ricerca documenti', 'DOCS',
                Theme.of(context).textTheme.headlineSmall)),
        body: const ReportStatContainer());*/
    return getCustomSettingTile(
        key: _docsSettingTileKey,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.description,
              color: Theme.of(context).textTheme.headlineSmall?.color,
            ),
            const SizedBox(
              width: 8,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: getHeroTitle('Ricerca documenti', 'DOCS',
                    Theme.of(context).textTheme.headlineSmall),
                onPressed: () {
                  _loaderPusherKey.currentState?.callCommand();
                  //_loadMachines();
                }),
          ],
        ),
        hint: '',
        description: 'Ricerca tra la documentazione tecnica',
        onPressed: (context) async {
          //_loaderPusherKey.currentState?.callCommand();
        },
        child: docsWidget());
  }

  SettingsTile _machinesSettingTile() {
    /*var docs = Scaffold(
        appBar: AppBar(
            title: getHeroTitle('Ricerca documenti', 'DOCS',
                Theme.of(context).textTheme.headlineSmall)),
        body: const ReportStatContainer());*/
    return getCustomSettingTile(
        key: _machineSettingTileKey,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.developer_board,
              color: Theme.of(context).textTheme.headlineSmall?.color,
            ),
            const SizedBox(
              width: 8,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: getHeroTitle('Macchine in preparazione', 'MACHINES',
                    Theme.of(context).textTheme.headlineSmall),
                onPressed: () {
                  _machinePusherKey.currentState?.callCommand();
                  //_loadMachines();
                }),
          ],
        ),
        hint: '',
        description: 'Lista delle macchine in preparazione',
        child: machinesWidget());
  }

  Widget _reminderSettingTile() {
    return _getRemindersSettingTile(
      key: _reminderSettingTileKey,
      withAddButton: false,
      titleWidget: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications,
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
          const SizedBox(
            width: 8,
          ),
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: getHeroTitle('Promemoria', 'PROMEM',
                Theme.of(context).textTheme.headlineSmall),
            onPressed: () {
              _reminderListKey.currentState?.loadReminders();
              //_loadMachines();
            },
          ),
        ],
      ),
      hint: 'Promemoria',
      description:
          'Lista di promemoria relativi ad interventi da effettuare o informazioni importanti da ricordare.',
    );
  }

  SettingsTile _getRemindersSettingTile(
      {String? title,
      String? description,
      Icon? icon,
      Widget? titleWidget,
      String? hint,
      bool withAddButton = true,
      Key? key}) {
    return getCustomSettingTile(
        key: key,
        onPressed: null,
        icon: icon,
        titleWidget: titleWidget,
        title: title ?? '',
        hint: hint,
        description: description,
        child: MultiBlocProvider(
            providers: [
              BlocProvider<ServerDataBloc<MachineReminder>>(
                lazy: false,
                create: (context) => ServerDataBloc<MachineReminder>(
                    repo: MultiService<MachineReminder>(
                        MachineReminder.fromJsonModel,
                        apiName: 'MachineReminder')),
              ),
            ],
            child: ReminderList(
              key: _reminderListKey,
              reorderable: false,
              maxElement: 2,
              onLoaded: (List<MachineReminder> reminders) {
                setState(() {
                  totalReminders = reminders.length;
                });
              },
            )));
  }

  Widget _fileLoader() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServerDataBloc<Media>>(
          lazy: false,
          create: (context) => ServerDataBloc<Media>(
              repo: MultiService<Media>(Media.fromJsonModel, apiName: "Media")),
        ),
        BlocProvider<MediaBloc>(
          lazy: false,
          create: (context) => MediaBloc(),
        ),
      ],
      child: FileLoader(
          key: _loaderKey,
          showButtons: true,
          canRemove: false,
          canAdd: false,
          canEdit: false,
          dense: true,
          height: 500,
          onLoaded: (List<MediaItem> values) {},
          itemFiles: selectedFiles),
    );
  }

  Widget docsWidget() {
    return MultiBlocProvider(
        //key: _reportStatBlocKey,
        providers: [
          BlocProvider<ServerDataBloc<Media>>(
            lazy: false,
            create: (context) => ServerDataBloc<Media>(
                repo:
                    MultiService<Media>(Media.fromJsonModel, apiName: 'Media')),
          ),
        ],
        child: Pusher(
          key: _loaderPusherKey,
          command: (context) {
            var bloc = BlocProvider.of<ServerDataBloc<Media>>(context);

            bloc.add(ServerDataEvent<Media>(
                status: ServerDataEvents.command,
                queryModel: QueryModel(id: "0", downloadContent: false),
                command: (bloc) async {
                  String url = "api/Media/get-all-files";
                  MultiService baseServiceEx =
                      MultiService<Media>(null, apiName: 'Media');

                  List<Media> medias = await baseServiceEx.retrieveCommand(
                      url,
                      QueryModel(id: "-1", downloadContent: false),
                      Media.fromJson) as List<Media>;

                  return medias;
                }));
          },
          child: BlocListener<ServerDataBloc<Media>, ServerDataState>(
              listener: (BuildContext context, ServerDataState state) {
            if (state is ServerDataCommandCompleted) {
              List<Media> items = state.items as List<Media>;
              selectedFiles = items.map((e) => e.toMediaItem()).toList();
              totalDocuments = selectedFiles.length;
              /*for (Vmc vmc in items){
                    if (vmc.vmcFiles!=null) {
                      selectedFiles.addAll(vmc.vmcFiles!);
                    }
                  }*/
            }
          }, child: BlocBuilder<ServerDataBloc<Media>, ServerDataState>(
                  builder: (BuildContext context, ServerDataState state) {
            if (state is ServerDataCommandCompleted) {
              return _fileLoader();
            }

            if (state is ServerDataError) {
              final error = state.error;
              String message = '${error.message}';
              String event = state.event?.status.toString() ?? '';
              return SizedBox(
                width: 700,
                height: 800,
                child: InfoScreen(
                  message: 'Errore durante $event',
                  errorMessage: message,
                  //emoticonText: !kIsWeb ? '(╯°□°）╯︵ ┻━┻' : '💔',
                  image: Image.asset(angryImage).image,
                  onPressed: () {
                    //print("error screen onPressed");
                    //reload();
                  },
                ),
              );
            }

            return LoadingScreen(
              borderRadius: BorderRadius.circular(20),
              message: 'Caricamento documenti in corso...',
            );
          })),
        ));
  }

  bool _searchMachineFilter(Machine element) {
    String searchValue = _searchMachineController.text;

    if (((element.stabilimento?.toString().removePunctuation().toLowerCase() ??
                    '')
                .contains(searchValue.toLowerCase()) ||
            ((element.customer?.toString().removePunctuation().toLowerCase() ??
                    '')
                .contains(searchValue.toLowerCase())) ||
            ((element.matricola?.toLowerCase() ?? '')
                .contains(searchValue.toLowerCase())) ||
            ((element.machineId?.toLowerCase() ?? '')
                .contains(searchValue.toLowerCase()))) &&
        (selectedStatusIndex > 0
            ? ((element.stato ?? 0) == selectedStatusIndex - 1)
            : true)) {
      return true;
    }
    return false;
  }

  Widget machinesWidget() {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ServerDataBloc<Machine>>(
            //lazy: false,
            create: (context) => ServerDataBloc<Machine>(
                repo: MultiService<Machine>(Machine.fromJsonModel,
                    apiName: 'VMMachine')),
          ),
        ],
        child: Pusher(
          key: _machinePusherKey,
          hubReloadMessage: const ['Machines', 'Reminders'],
          command: (context) {
            var bloc = BlocProvider.of<ServerDataBloc<Machine>>(context);
            bloc.add(ServerDataEvent<Machine>(
              status: ServerDataEvents.fetch,
              queryModel: QueryModel(
                  id: "5",
                  fieldName: 'Stato',
                  compareType: 3 /* < (minore) */,
                  downloadContent: true),
            ));
          },
          child: BlocListener<ServerDataBloc<Machine>, ServerDataState>(
              listener: (BuildContext context, ServerDataState state) {
            if (state is ServerDataLoaded) {
              List<Machine> items = state.items as List<Machine>;
              totalMachines = items;
              _updateSelectedMachines();
            }
          }, child: BlocBuilder<ServerDataBloc<Machine>, ServerDataState>(
                  builder: (BuildContext context, ServerDataState state) {
            if (state is ServerDataLoaded) {
              return machinesViewer();
            }

            if (state is ServerDataError) {
              final error = state.error;
              String message = '${error.message}';
              String event = state.event?.status.toString() ?? '';
              return SizedBox(
                width: 700,
                height: 800,
                child: InfoScreen(
                  message: 'Errore durante $event',
                  errorMessage: message,
                  //emoticonText: !kIsWeb ? '(╯°□°）╯︵ ┻━┻' : '💔',
                  image: Image.asset(angryImage).image,
                  onPressed: () {
                    //print("error screen onPressed");
                    //reload();
                  },
                ),
              );
            }
            if (state is ServerDataLoadingSendProgress) {
              return LoadingScreen(
                  message:
                      "Richiesta macchine in corso (${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)})");
            }
            if (state is ServerDataLoadingReceiveProgress) {
              return LoadingScreen(
                  message:
                      "Ricezione macchine in corso (${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)})");
            }
            return LoadingScreen(
              borderRadius: BorderRadius.circular(20),
              message: 'Caricamento macchine in corso...',
            );
          })),
        ));
  }

  int selectedStatusIndex = 0;

  Widget _searchField() {
    return Column(
      key: _searchFieldKey,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            key: _searchMachineFieldKey,
            controller: _searchMachineController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              labelText: 'Cerca tra le macchine in preparazione',
              hintText: 'Cerca',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchMachineController.text = "";
                    _updateSelectedMachines();
                  }),
            ),
            onChanged: (value) {
              _updateSelectedMachines();
            },
          ),
        ),
        SingleChildScrollView(
          key: _searchFieldScrollKey,
          //controller: _machineFilterScrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(
            6,
            (index) {
              Color backgroundColor = index == 0
                  ? Colors.blue
                  : MachineEditFormState.getStatusColor(index - 1);

              Color textColor = selectedStatusIndex != index
                  ? (backgroundColor.computeLuminance() > 0.5
                      ? Colors.black87
                      : Colors.white70)
                      : (Colors.green.withAlpha(200).computeLuminance() > 0.5
                      ? Colors.black87
                      : Colors.white70);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: index == 0
                        ? FilterChip(
                        showCheckmark: true,
                        selectedColor: Colors.green.withAlpha(200),
                        checkmarkColor: textColor,
                        selected: selectedStatusIndex == index,
                        backgroundColor: Colors.blue,
                        label: Text('Tutti',
                            style: TextStyle(
                              color: textColor,
                            )),
                        onSelected: (value) {
                          if (value) {
                            selectedStatusIndex = index;
                            _updateSelectedMachines();
                          }
                        })
                        : FilterChip(
                        showCheckmark: true,
                        selected: selectedStatusIndex == index,
                        selectedColor: Colors.green.withAlpha(200),
                        checkmarkColor: textColor,
                        backgroundColor:
                        MachineEditFormState.getStatusColor(index - 1),
                        label: Text(
                            MachineEditFormState.getStatusText(index - 1),
                            style: TextStyle(color: textColor)),
                        onSelected: (value) {
                          if (value) {
                            selectedStatusIndex = index;
                            _updateSelectedMachines();
                          }
                        }),
                  );
                },
              )),
        )
      ],
    );
  }

  void _updateSelectedMachines() {
    selectedMachines = totalMachines
        .where((element) => _searchMachineFilter(element))
        .toList();
    setState(() {});
  }

  Widget machineItem(Machine machine) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: getCustomSettingTile(
        onPressed: (context) async {
          var result = await MachineActions.openDetailAndSave(context, machine);
          if (result != null) {
            _machinePusherKey.currentState?.callCommand();
          }
        },
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.developer_board,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color),
                              const SizedBox(width: 8),
                              FilterChip(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 0),
                                labelPadding: EdgeInsets.zero,
                                label: Text(machine.matricola ?? '?'),
                                onSelected: (bool value) async {
                                  var result =
                                      await MachineActions.openDetailAndSave(
                                          context, machine);
                                  if (result != null) {
                                    _machinePusherKey.currentState
                                        ?.callCommand();
                                  }
                                },
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.window,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color),
                              const SizedBox(width: 8),
                              FilterChip(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 0),
                                labelPadding: EdgeInsets.zero,
                                label: Text(machine.vmc?.description ?? '?'),
                                onSelected: (bool value) async {
                                  if (machine.vmcId != null) {
                                    if (machine.vmc?.vmcSettings == null ||
                                        machine.vmc?.vmcProductions == null) {
                                      List<Vmc> vmcs = await showPusher(
                                          context,
                                          _modelLoader(
                                              machine.vmcId!.toString()));
                                      machine = machine.copyWith(vmc: vmcs[0]);
                                    }
                                    if (mounted) {
                                      var result =
                                          await VmcsActions.openDetailAndSave(
                                              context, machine.vmc!);
                                    }
                                  }

                                  //_machinePusherKey.currentState?.callCommand();
                                },
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (MediaQuery.of(context).size.width < 1200)
                          MachineEditFormState.getStatusBadge(
                              context, machine.stato ?? 0),
                        const SizedBox(
                          height: 8,
                        ),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  tooltip: machine.customer != null
                                      ? "Apri in Google Maps"
                                      : '',
                                  constraints: const BoxConstraints(
                                      maxWidth: 32, maxHeight: 32),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.factory,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withAlpha(150)),
                                  onPressed: machine.customer != null
                                      ? () {
                                          MapUtils.openMapLocation(
                                              machine.customer!.toString());
                                        }
                                      : null),
                              const SizedBox(width: 8),
                              Flexible(
                                  child: Text(
                                machine.customer?.toString() ??
                                    'Cliente non assegnato',
                                style: itemTitleStyle()?.copyWith(fontSize: 18),
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  tooltip: machine.stabilimento != null
                                      ? "Apri in Google Maps"
                                      : null,
                                  //constraints: BoxConstraints(maxWidth: 32, maxHeight: 32),
                                  padding: EdgeInsets.zero,
                                  //splashRadius: 64,
                                  constraints: const BoxConstraints(
                                      maxWidth: 32, maxHeight: 32),
                                  icon: Icon(Icons.radar,
                                      size: 24,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withAlpha(150)),
                                  onPressed: machine.stabilimento != null
                                      ? () {
                                          MapUtils.openMapLocation(
                                              machine.stabilimento!.toString());
                                        }
                                      : null),
                              const SizedBox(width: 8),
                              Flexible(
                                  child: Text(
                                machine.stabilimento?.toString() ??
                                    'Stabilimento non assegnato',
                                style: itemTitleStyle()?.copyWith(fontSize: 18),
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (MediaQuery.of(context).size.width >= 1200)
                    MachineEditFormState.getStatusBadge(
                        context, machine.stato ?? 0)
                ],
              ),
              Stack(
                children: [
                  Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: FAProgressBar(
                          borderRadius: BorderRadius.circular(20),
                          animatedDuration: const Duration(milliseconds: 750),
                          maxValue: 100,
                          changeColorValue: 100,
                          changeProgressColor: Colors.green.withAlpha(200),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .background
                              .withAlpha(100),
                          progressColor: Theme.of(context).colorScheme.primary,
                          currentValue:
                              MachineProductionsViewState.getCompletePercentage(
                                  machine.machineProductions ?? []))),
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
                          '${MachineProductionsViewState.getCompletePercentage(machine.machineProductions ?? []).round().toString()}%',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: hashTagTextStyleStandardStroke(
                              isDarkTheme(context)
                                  ? Colors.black
                                  : Colors.white,
                              strokeWidth: 2)),
                      Text(
                        '${MachineProductionsViewState.getCompletePercentage(machine.machineProductions ?? []).round().toString()}%',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: hashTagTextStyleStandard(
                            isDarkTheme(context) ? Colors.black : Colors.white),
                      )
                    ]),
                  )
                ],
              ),
            ]),
      ),
    );
  }

  Widget machinesViewer() {
    if (selectedMachines.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(child: _searchField()),
          const Divider(),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return machineItem(selectedMachines[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: selectedMachines.length),
        ],
      );
      /*if (MediaQuery.of(context).size.width<800){
        return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return machineItem(selectedMachines[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: selectedMachines.length
        );
      }
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2,
        crossAxisCount: 2,children: List.generate(selectedMachines.length, (index) =>
              machineItem(selectedMachines[index]),
      ),);*/
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _searchField(),
          const SizedBox(height: 8),
          Text(
            "Nessuna macchina con i parametri richiesti trovata",
            style: itemValueTextStyle(),
          ),
        ],
      );
    }
  }
/*  _connectToMessageHub() {
    try {
      //_detachMessageHub();
      //messageHub!.on('ReceiveMessage', messageHubCallback);
      eventBusSubscription = eventBus.on<MessageHubEvent>().listen((event) {
        List<String> messageData = event.message?.split(';') ?? <String>[];
        String message = '';
        String sessionId = '';

        if (messageData.length == 2) {
          message = messageData[0];
          sessionId = messageData[1];
        }
        var currentSessionId = prefs!.getString(sessionIdSetting);

        print("Message: $message");

        if (message.toLowerCase().contains("vmcfiles")) {
          if (ignoreRemindersMessage) {
            debugPrint("ignoreRemindersMessage=true");
            ignoreRemindersMessage = false;
          } else {
            debugPrint("ignoreRenindersMessage=false: loadMachines()");
            loadMachines(refresh: true);
          }

          //await _loadAsync();

          */
  /*ScaffoldMessenger.of(context).hideCurrentSnackBar();

          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: const Duration(days: 365),
            elevation: 6,
            content:
            const Text("I dati sono stati modificati da un altro utente"),
            action: SnackBarAction(
              label: "Ricarica",
              onPressed: () async {
                await reload();
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
  /*
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }*/

  Future showPusher(BuildContext context, Widget pusher) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return multiDialog(content: pusher);
        }).then((returningValue) {
      if (returningValue != null) {
        return returningValue;
      }
    });
    return result;
  }

  Widget _modelLoader(String id) {
    return MultiBlocProvider(
        //key: _reportStatBlocKey,
        providers: [
          BlocProvider<ServerDataBloc<Vmc>>(
            lazy: false,
            create: (context) => ServerDataBloc<Vmc>(
                repo: MultiService<Vmc>(Vmc.fromJsonModel, apiName: 'Vmc')),
          ),
        ],
        child: Pusher(
          command: (context) {
            var bloc = BlocProvider.of<ServerDataBloc<Vmc>>(context);
            bloc.add(ServerDataEvent<Vmc>(
              status: ServerDataEvents.fetch,
              queryModel: QueryModel(id: id),
            ));
          },
          child: BlocListener<ServerDataBloc<Vmc>, ServerDataState>(
              listener: (BuildContext context, ServerDataState state) {
            if (state.event is ServerDataLoaded) {
              Navigator.pop(context, state.event?.items);
            }
          }, child: BlocBuilder<ServerDataBloc<Vmc>, ServerDataState>(
                  builder: (BuildContext context, ServerDataState state) {
            if (state is ServerDataLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pop(context, state.items);
              });
              // return const Text("OK!");
            }
            return Container(
              constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    pacman(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (state is ServerDataLoading)
                      const Text("Caricamento modello in corso..."),
                    if (state is ServerDataLoadingSendProgress)
                      Text(
                          "Richiesta ${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)}..."),
                    if (state is ServerDataLoadingReceiveProgress)
                      Text(
                          "Ricezione ${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)}..."),
                    const SizedBox(
                      height: 16,
                    ),
                    /* OkCancel(onCancel: (){
                if (mounted) {
                  Navigator.of(context).maybePop(null);
                }

              },)*/
                  ],
                ),
              ),
            );
          })),
        ));
  }
}
