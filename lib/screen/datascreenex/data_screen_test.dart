/*
import 'dart:async';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/datagrid/data_grid_column.dart';
import 'package:dpicenter/datagrid/data_grid_date_column.dart';
import 'package:dpicenter/datagrid/data_grid_selection_column.dart';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/navigation_global.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/anim/animated_icon.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_item.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/useful/data_title_helper.dart';
import 'package:dpicenter/screen/useful/info_screen.dart';
import 'package:dpicenter/screen/useful/loading_screen.dart';
import 'package:dpicenter/screen/widgets/expandable_fab/expandable_fab.dart';
import 'package:dpicenter/screen/widgets/selection_button_toggle/selection_toggle.dart';
import 'package:dpicenter/scroll_controller/adjustable_scroll_controller.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:gato/gato.dart' as gato;
import 'package:scroll_to_index/scroll_to_index.dart';

import 'data_screen_global.dart';

class DataScreenConfiguration {
  String? title;
  String? addButtonToolTipText;
  String? deleteButtonToolTipText;
  bool? showFloatingActionButton;
  String? repoName;
  Menu menu;
  bool? useIntrinsicRowHeight;

  bool showFooter;
  double? footerHeight;
  List<DataScreenColumnConfiguration> columns;
  final bool withBackButton;

  Widget Function(List items)? onFooterBuild;

  DataScreenConfiguration(
      {this.title,
      required this.repoName,
      required this.withBackButton,
      this.addButtonToolTipText,
      this.deleteButtonToolTipText,
      this.showFloatingActionButton,
      required this.columns,
      required this.menu,
      this.useIntrinsicRowHeight,
      this.showFooter = false,
      this.footerHeight,
      this.onFooterBuild});
}

class DataScreen<T extends JsonPayload> extends StatefulWidget {
  final DataScreenConfiguration configuration;

  //final Color? Function(T)? rowColorCallback;

  final VoidCallback? loadCommand;
  final Function? openNew;

  //final Function? openNewForSave;
  final Function? openDetail;

  //final Function? openDetailForSave;
  final Function? delete;
  final VoidCallback? customBackClick;
  final Function(T)? onSave;

  ///callback proveniente dal bloc alla richiesta di effettuare un inserimento
  ///permette di customizzare il comportamento dell'inserimento
  final Function(Bloc bloc, ServerDataEvent event, Emitter emit)? onAdd;

  ///callback proveniente dal bloc alla richiesta di effettuare una modifica
  ///permette di customizzare il comportamento della modifica
  final Function(Bloc bloc, ServerDataEvent event, Emitter emit)? onUpdate;

  ///callback proveniente dal bloc alla richiesta di effettuare un'eliminazione
  ///permette di customizzare il comportamento dell'eliminazione
  final Function(Bloc bloc, ServerDataEvent event, Emitter emit)? onDelete;

  ///callback che avviene all'inserimento di un nuovo elemento
  final Function(T item)? onAdded;

  ///callback che avviene alla modifica di un elemento
  final Function(T item)? onUpdated;

  ///callback che avviene all'eliminazione di uno più elementi
  final Function(List<T> items)? onDeleted;

  ///callback che avviene al termine del caricamento (stato ServerDataLoaded
  final Function(List<T>? items)? onLoaded;

  final Function(Bloc bloc, ServerDataEvent event, Emitter emit)? onLoad;

  final List<Widget>? bottomActions;

  final Function(List<DataGridRow> selectedRows, T? lastSelectedRow)?
      onSelectionChanged;

  final List<Widget>? actions;



  const DataScreen({
    Key? key,
    required this.configuration,
    this.loadCommand,
    this.openNew,
    this.openDetail,
    this.onSelectionChanged,
    this.actions,
    //this.openNewForSave,
    //this.openDetailForSave,
    this.delete,
    this.customBackClick,
    this.onSave,
    this.onAdd,
    this.onUpdate,
    this.onDelete,
    this.onAdded,
    this.onUpdated,
    this.onDeleted,
    this.onLoaded,
    this.onLoad,
    this.bottomActions,
  }) : super(key: key);

  @override
  DataScreenState<T> createState() => DataScreenState<T>();
}

class DataScreenState<T extends JsonPayload> extends State<DataScreen<T>>
    with AutomaticKeepAliveClientMixin<DataScreen<T>> {
  final GlobalKey _printPreviewKey = GlobalKey(debugLabel: '_printPreviewKey');

  final AutoScrollController _autoScrollTagController =
      AutoScrollController(debugLabel: '_autoScrollTagController');

  ScrollController? _horizontalScrollController;
  ScrollController? _verticalScrollController;
  final ScrollController _scrollController =
      ScrollController(debugLabel: '_scrollController');

  final isFABOpen = ValueNotifier<bool>(false);
  final GlobalKey<ExpandableFabState> _fabKey =
      GlobalKey<ExpandableFabState>(debugLabel: '_FABKEY');

  //final buttonsState = ValueNotifier<Map<String, bool>>({});
  bool showButton = false;
  final showButton2 = ValueNotifier<bool>(false);

  bool _showFooter = false;

  final GlobalKey _sfGridKey = GlobalKey(debugLabel: "sfGridKey");
  final GlobalKey _footerKey = GlobalKey(debugLabel: "footerKey");
  List<T>? currentItems;
  AnimateIconController? controller;

  DefaultDataSource<T>? source;

  //DataGridAdapter? adapter;

  StreamSubscription? eventBusSubscription;

  ///item da selezionare al termine del load della PlutoGrid
  T? itemToSelect;

  ///quando viene messo a true vengono ignorati i messaggi del messageHub
  //bool? disableNotify;

  ///la pagina dell'anteprima di stampa è aperta
  bool isPrintPage = false;
  Map<String, double>? columnWidths;
  Map<String, Filter>? columnFilters;
  Map<String, bool Function(dynamic searchValue, dynamic item)?>? customFilters;

  final GlobalKey _scaffoldKey = GlobalKey(debugLabel: "dataScreenScaffold");
  List<GridColumn>? gridColumns;

  Map<String, GlobalKey<dynamic>>? columnsKeys;

  ///per nascondere o visualizzare la bottom bar (gestisce il caso in cui arrivanti in fondo allo scrolling l'ultima riga rimane nascosta (bodyExtent:True dello scaffold, utilizzato per visualizzare il notch sul fab)
  */
/*bool _hideBottomBar = false;
  bool _scrollBarVisible = false;

  */ /*


  ///indice per iterare all'interno delle righe selezionate
  int? currentSelectedIndex;

  ///indice della colonna attualmente ordinata (sort)
  int currentSortIndex = 0;
  DataGridSortDirection? currentSortDirection;
  int oldSortIndex = -1;
  List<SortColumnDetails>? currentSort;
  List<SortColumnDetails>? currentSortedColumns;
  bool _isPopupVisible = false;

  final GlobalKey<SelectionToggleState> _selectionToggleKey = GlobalKey<SelectionToggleState>(debugLabel: '_selectionToggleKey');

  @override
  void initState() {
    super.initState();

    controller = AnimateIconController();

    ///ripristinare una volta definito il funzionamento esatto
    _showFooter = widget.configuration.showFooter;

    */
/*buttonsState.value = {
      'showNew': true,
      'showEdit': false,
      'showDelete': false
    };*/ /*

    //_customSelection = RowSelectionManager();

    //var window = WidgetsBinding.instance!.window;

    //ripristino lo stato in caso il bloc abbia già dei dati
*/
/*
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    if (bloc.items is List<T>){
      currentItems = bloc.items as List<T>;
      adapter = DataGridAdapter(
          listLocale: currentItems,
          columns: widget.configuration.columns);
      rows = adapter!.rows;
    }
*/ /*

    _connectToMessageHub();

    if (columnWidths == null) {
      columnWidths = <String, double>{};
      for (var element in widget.configuration.columns) {
        columnWidths!.addAll({element.id: double.nan});
      }
      */
/*columnWidths = widget.configuration.columns.map((e) => {e.id, double.nan}) as Map<String, double>;
      columnWidths = <String, double>{};*/ /*

    }

    if (columnFilters == null) {
      columnFilters = <String, Filter>{};
      for (var element in widget.configuration.columns) {
        switch (element.filterType) {
          case MultiFilterType.containsText:
            columnFilters!.addAll({
              element.id: Filter(
                  filterType: MultiFilterType.containsText,
                  value: element.defaultFilterValue ?? '',
                  defaultValue: '',
                  isSetted: element.defaultFilterValue != null)
            });
            break;
          case MultiFilterType.betweenDate:
            columnFilters!.addAll({
              element.id: Filter(
                  filterType: MultiFilterType.betweenDate,
                  value: element.defaultFilterValue ?? <String>['', ''],
                  defaultValue: <String>['', ''],
                  isSetted: element.defaultFilterValue != null)
            });
            break;
          case MultiFilterType.selection:
            columnFilters!.addAll({
              element.id: Filter(
                  filterType: MultiFilterType.selection,
                  value: element.defaultFilterValue ?? <String>[],
                  defaultValue: <String>[],
                  isSetted: element.defaultFilterValue != null)
            });
            break;
          default:
            break;
        }
      }
    }

    if (customFilters == null) {
      customFilters =
          <String, bool Function(dynamic searchValue, dynamic item)?>{};
      for (var element in widget.configuration.columns) {
        customFilters!.addAll({element.id: element.customFilter});
      }
    }

    columnsKeys ??= {
      for (var e in widget.configuration.columns)
        e.id: e.filterType == MultiFilterType.containsText
            ? GlobalKey<DataGridColumnState>(debugLabel: e.id)
            : e.filterType == MultiFilterType.betweenDate
                ? GlobalKey<DataGridDateColumnState>(debugLabel: e.id)
                : e.filterType == MultiFilterType.selection
                    ? GlobalKey<DataGridColumnSelectionState>(debugLabel: e.id)
                    : GlobalKey<DataGridColumnState>(debugLabel: e.id)
    };

    if (kIsWeb) {
      Future.delayed(const Duration(milliseconds: 500), () {
        reload(withSetState: false);
      });
    } else {
      reload(withSetState: false);
    }
  }

  reload({bool withSetState = true}) {
    if (withSetState) {
      setState(() {
        showLoadContainer = true;
        _loadAsync(true);
      });
    } else {
      showLoadContainer = true;
      _loadAsync(true);
    }
  }

  _loadAsync(bool refresh) {
    //print(T);

    */
/*if (kDebugMode) {
      print(context);
    }*/ /*

    isPrintPage = false;
    //BlocProvider.of<ServerDataBloc<T>>(context).add(ServerDataEvent(status: ServerDataEvents.fetch));

    var bloc = BlocProvider.of<ServerDataBloc>(context);

    bloc.add(ServerDataEvent<T>(
        status: ServerDataEvents.fetch,
        refresh: refresh,
        columnFilters: columnFilters,
        customFilters: customFilters,
        onDataLoaded: widget.onLoaded,
        onEvent: widget.onLoad));
    //var bloc1=context.read<ServerDataBloc>();
    */
/*context.read<ServerDataBloc>().add(
        ServerDataEvent(status: ServerDataEvents.fetch));*/ /*

  }

  _add(T item,
      {Function(Bloc bloc, ServerDataEvent event, Emitter emit)? onEvent}) {
    //disableNotify = true;
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    bloc.add(ServerDataEvent<T>(
        status: ServerDataEvents.add,
        item: item,
        columnFilters: columnFilters,
        customFilters: customFilters,
        onEvent: onEvent,
        onDataLoaded: widget.onLoaded));
*/
/*
    context.read<ServerDataBloc<T>>().add(
        ServerDataEvent(status: ServerDataEvents.add, item: item));
*/ /*

  }

*/
/*  _save(T item) async {
    //disableNotify = true;
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    bloc.add(ServerDataEvent<T>(status: ServerDataEvents.save, item: item));
*/ /*
 */
/*
    context.read<ServerDataBloc<T>>().add(
        ServerDataEvent(status: ServerDataEvents.add, item: item));
*/ /*
 */
/*
  }*/ /*


  update(T item,
      {Function(Bloc bloc, ServerDataEvent event, Emitter emit)? onEvent}) {
    //disableNotify = true;
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    bloc.add(ServerDataEvent<T>(
        status: ServerDataEvents.update,
        item: item,
        columnFilters: columnFilters,
        customFilters: customFilters,
        onEvent: onEvent,
        onDataLoaded: widget.onLoaded));
    */
/*context.read<ServerDataBloc<T>>().add(
        ServerDataEvent(status: ServerDataEvents.update, item: item));*/ /*

  }

  _delete(List<T>? items,
      {Function(Bloc bloc, ServerDataEvent event, Emitter emit)?
          onEvent}) async {
    //disableNotify = true;
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    bloc.add(ServerDataEvent<T>(
        status: ServerDataEvents.delete,
        items: items,
        item: items![0],
        columnFilters: columnFilters,
        customFilters: customFilters,
        onEvent: onEvent,
        onDataLoaded: widget.onLoaded));
    // show the dialog
  }

  _printClick() {
    if (source!.effectiveRows.isNotEmpty) {
      var printList = <T>[];

      for (var row in source!.effectiveRows) {
        if (row is DataGridRowWithItem) {
          //var element = adapter!.listLocale![row.sortIdx!];
          printList.add(row.item);
        }
      }

      _printThis(printList);
    }
  }

  _printThis(List<T> items) {
    isPrintPage = true;
    //disableNotify = true;
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    bloc.add(ServerDataEvent<T>(
        status: ServerDataEvents.exportPdf,
        item: null,
        items: items,
        columnFilters: columnFilters));
  }

  _titleClick() {
    reload();
  }

  _controlledCustomBackClick() {
    if (isPrintPage) {
      isPrintPage = false;
      reload();
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();

    widget.customBackClick?.call();
  }

  bool isLittleWidth({BuildContext? passedContext}) =>
      MediaQuery.of(passedContext ?? context).size.width <= 800;

  Widget scaffoldBloc(){
    return BlocListener<ServerDataBloc, ServerDataState>(
        listener: (BuildContext context, ServerDataState state) async {
          _animateToStart();
          if (state is ServerDataLoading) {
            _horizontalScrollController = ScrollController(
              debugLabel: 'horizontalScrollController',
            );
            _verticalScrollController =
                ScrollController(debugLabel: 'verticalScrollController');
          }

          try {
            if (state is ServerDataAdded<T>) {
              itemToSelect = state.item;
              if (widget.onSave != null) {
                widget.onSave!.call(itemToSelect!);
              }
            }
            if (state is ServerDataUpdated<T>) {
              itemToSelect = state.item;
              if (widget.onSave != null) {
                widget.onSave!.call(itemToSelect!);
              }
            }
            if (state is ServerDataDeleted<T>) {
              itemToSelect = null;
            }
            if (state is ServerDataLoaded<T>) {
              //gridController = DataGridController();
              _horizontalScrollController = ScrollController(
                debugLabel: 'horizontalScrollController',
              );

              _verticalScrollController =
                  ScrollController(debugLabel: 'verticalScrollController');
              currentItems = state.items;

              List<SortColumnDetails>? oldSortedColumns;
              if (source != null) {
                oldSortedColumns = source!.sortedColumns;
              }
              source =
                  DefaultDataSource<T>(list: currentItems!, columns: gridColumns!);

              if (kDebugMode) {
                print('rows: ${source!.rows.length}');
                print('effective rows: ${source!.effectiveRows.length}');
              }

              ///scroll all'item selezionato
              WidgetsBinding.instance.addPostFrameCallback((_) {
                //if (gridController!.selectedRows.isNotEmpty) {
                //}
                if (kDebugMode) {
                  //print(source!.effectiveRows.length);
                }
                if (itemToSelect != null) {
                  int index = 0;
                  for (var row in source!.effectiveRows) {
                    if (row is DataGridRowWithItem) {
                      if (row.item == itemToSelect) {
                        gridController?.selectedIndex = index;
                        gridController?.scrollToRow(index.toDouble(),
                            canAnimate: true);
                        _fabKey.currentState?.setAllState(true);
                        setState(() {});
                        break;
                      }
                    }
                    index++;
                  }
                } else {
                  _fabKey.currentState?.setAllState(false);
                  setState(() {});
                }
              });

              if (oldSortedColumns != null) {
                source!.sortedColumns.clear();
                source!.sortedColumns.addAll(oldSortedColumns);
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }, child: BlocBuilder<ServerDataBloc, ServerDataState>(
        builder: (BuildContext context, ServerDataState state) {
          try {
            ///C'è un qualche tipo di errore, lo visualizzo e esco
            if (state is ServerDataError<T>) {
              final error = state.error;
              String message = '${error.message}';
              String event = state.event?.status.toString() ?? '';
              return InfoScreen(
                message: 'Errore durante $event',
                errorMessage: message,
                emoticonText: '(╯°□°）╯︵ ┻━┻',
                onPressed: () {
                  //print("error screen onPressed");
                  reload();
                },
              );
            }

            switch (state.event!.status) {
              case ServerDataEvents.fetch:
                if (state is ServerDataLoaded<T>) {
                  //currentItems = state.items;
                  break;
                }

                ///stato diverso da loaded, mostro schermata di caricamento
                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    scaffold(loading: true),
                    LoadingScreen(
                        message:
                        "Caricamento ${widget.configuration.title!.toLowerCase()}"),
                  ],
                );

              case ServerDataEvents.update:
                String message = "Salvataggio in corso";
                if (state is ServerDataUpdated<T>) {
                  message = "Salvataggio completato";
                }
                if (state is ServerDataLoaded<T>) {
                  //currentItems = state.items;
                  break;
                }
                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    scaffold(loading: true),
                    LoadingScreen(message: message),
                  ],
                );

              case ServerDataEvents.add:
                String message = "Salvataggio in corso";
                if (state is ServerDataAdded<T>) {
                  message = "Salvataggio completato";
                }

                if (state is ServerDataLoaded<T>) {
                  //currentItems = state.items;
                  break;
                }

                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    scaffold(loading: true),
                    LoadingScreen(message: message),
                  ],
                );

              case ServerDataEvents.exportPdf:
                if (state is ServerDataExported<T>) {
                  return Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      clipBehavior: Clip.antiAlias,
                      child: PdfPreview(
                        key: _printPreviewKey,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        build: (PdfPageFormat format) {
                          return state.file!;
                        },
                      ));
                }

                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [

                    LoadingScreen(
                        message:
                        "Creazione anteprima di stampa ${widget.configuration.title!.toLowerCase()} in corso"),
                  ],
                );

              case ServerDataEvents.delete:
                String message = "Cancellazione in corso";
                if (state is ServerDataDeleted<T>) {
                  message = "Cancellazione completata";
                }
                if (state is ServerDataLoaded<T>) {
                  break;
                }

                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    scaffold(loading: true),
                    LoadingScreen(message: message),
                  ],
                );
              default:
                break;
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }

          return scaffold(loading: false);

          //return unknownState(state.event!.status!);
        }));
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    //var mediaData = MediaQuery.of(context);
*/
/*WidgetsBinding.instance?.addPostFrameCallback(
        (timeStamp) {
          setState(() {
            isFABOpen.value=true;
          });
});*/ /*



    _customColumnSizer = CustomColumnSizer(columnsStyles: {
      for (var e in widget.configuration.columns) e.id: e.customSizer
    });

    gridColumns = widget.configuration.columns
        .map((e) => GridColumnWithWidget(
      id: e.id,
              width: columnWidths![e.id]!,
              columnName: e.label,
              allowSorting: e.allowSorting,
              autoFitPadding: e.autoFitPadding,
              onRenderRowField: e.onRenderRowField,
              onQueryRowColor: e.onQueryRowColor,
              onQueryRowDecoration: e.onQueryRowDecoration,
              onQueryTextColor: e.onQueryTextColor,
              label: Builder(builder: (context) {
                return _buildDataGridColumn(e);
              }),
            ))
        .toList();


    return scaffoldBloc();
  }

  Widget _dataView(){
    if (source != null) {
      if (!isLittleWidth()) {
          return _grid(false);
      } else {
          return _list(false);
      }
    }
    return const LoadingScreen(message: 'Caricamento');
  }
  Widget scaffold({bool loading=false}){
    return WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).clearSnackBars();
          //  openedMenu.remove(widget.configuration.menu);
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            extendBody: false,
            resizeToAvoidBottomInset: false,
            appBar: _titleAppBar(loading),
            body: _dataView(),
            bottomNavigationBar: _getBottomNavigatorBar(withNotch: !loading),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation: _fabKey.currentState?.currentState
                .any((element) => element.value == true) ??
                false
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.endDocked,

            //_fabKey.currentState?.currentState.any((element) => element.value==true) ?? false ? FloatingActionButtonLocation.endFloat : FloatingActionButtonLocation.endDocked,
            floatingActionButton: _getFloatingActionButton3(loading)));
  }
  Widget _getBottomNavigatorBarBuilder() {
    return BlocBuilder<ServerDataBloc, ServerDataState>(
        builder: (BuildContext context, ServerDataState state) {
          if (state is ServerDataLoaded<T>) {
            return _getBottomNavigatorBar(withNotch: true);
          }

          return _getBottomNavigatorBar(withNotch: false);

        });
  }


  Widget _getBottomNavigatorBar({bool withNotch = false}) {
    return Container(
      color: Colors.transparent, //getBackgroundColor(context),
      child: BottomAppBar(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        color: isLightTheme(context)
            ? Theme
            .of(context)
            .colorScheme
            .primary
            : Color.alphaBlend(
            Theme
                .of(context)
                .colorScheme
                .surface
                .withAlpha(240),
            Theme
                .of(context)
                .colorScheme
                .primary),
        shape:

        isActionsEnabled() && withNotch */
/*&&
                        (_fabKey.currentState?.currentState
                                .any((element) => element.value == true) ==
                            false)*/ /*

            ? const CircularNotchedRectangle()
            : null,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: Row(
                children: <Widget>[
                  IconButton(
                      tooltip: 'Stampa',
                      onPressed: _printClick,
                      icon: Icon(
                        Icons.print,
                        color: getBottomNavigatorBarForegroundColor(context),
                        //size: mediaData.size.height < tinyHeight ? 16 : 24,
                      )),
                  */
/*if (((gridController?.selectedRows.isNotEmpty ?? false) ||
                      (selectedGridRows?.isNotEmpty ?? false)))*/ /*

                  SelectionToggle(
                    key: _selectionToggleKey,
                    foregroundColor: getBottomNavigatorBarForegroundColor(context),
                    initialValue: _getCurrentSelectionText(),
                    onTap: () {
                      List<DataGridRow>? selectedRows = gridController!=null ? gridController!.selectedRows : selectedGridRows;
                      if (selectedRows!=null && selectedRows.isNotEmpty){
                        if (currentSelectedIndex == null) {
                          currentSelectedIndex = 0;
                        } else if (currentSelectedIndex ==
                            selectedRows.length - 1) {
                          currentSelectedIndex = 0;
                        } else {
                          currentSelectedIndex = currentSelectedIndex! + 1;
                        }
                        scrollToItem((selectedRows[currentSelectedIndex!]
                        as DataGridRowWithItem)
                            .item,
                            listSelect: gridController!=null);
                        _selectionToggleKey.currentState?.currentValue=_getCurrentSelectionText();
                      } else {
                        if (currentSelectedIndex==null||currentSelectedIndex==0) {
                          currentSelectedIndex = source?.effectiveRows
                              .length ?? source?.rows.length ?? 0;
                          currentSelectedIndex = currentSelectedIndex! > 0 ? currentSelectedIndex!-1 : 0;
                        } else {
                          currentSelectedIndex =0;
                        }
                        scrollToItem((source?.effectiveRows[currentSelectedIndex!]
                        as DataGridRowWithItem)
                            .item ?? (source?.rows[currentSelectedIndex!]
                        as DataGridRowWithItem)
                            .item,
                            listSelect: false);

                        _selectionToggleKey.currentState?.currentValue=_getCurrentSelectionText();
                      }

                    },
                  ),

                  if (columnFilters?.entries
                      .any((element) => element.value.isSetted ?? false) ??
                      false)
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          if (gridController != null) {
                            columnsKeys?.forEach((key, value) {
                              if (value
                              is GlobalKey<DataGridColumnSelectionState>) {
                                value.currentState?.filterKey.currentState
                                    ?.clear();
                                value.currentState?.widget.onFilterChange
                                    ?.call(null);
                              }
                              if (value is GlobalKey<DataGridColumnState>) {
                                value.currentState?.filterController.clear();
                                value.currentState?.widget.onFilterChange
                                    ?.call('');
                              }
                              if (value is GlobalKey<DataGridDateColumnState>) {
                                value.currentState?.startFilterController
                                    .clear();
                                value.currentState?.endFilterController.clear();
                                value.currentState?.widget.onFilterChange
                                    ?.call('', '');
                              }
                            });
                          } else {
                            columnFilters?.forEach((key, value) {
                              columnFilters![key] = Filter(
                                  filterType: value.filterType,
                                  filterSeachLogic: value.filterSeachLogic,
                                  value: '',
                                  isSetted: false,
                                  defaultValue: value.defaultValue);
                            });
                            _loadAsync(false);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list_off,
                              color:
                              getBottomNavigatorBarForegroundColor(context),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Rimuovi filtro',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color:
                                  getBottomNavigatorBarForegroundColor(
                                      context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.configuration.showFooter)
                    IconButton(
                        tooltip: 'Visualizza/Nasconde totali',
                        onPressed: () {
                          setState(() {
                            _showFooter = !_showFooter;
                          });
                        },
                        icon: Icon(
                          Icons.calculate,
                          color: getBottomNavigatorBarForegroundColor(context),
                          semanticLabel: 'Mostra pannello totali',
                          //size: mediaData.size.height < tinyHeight ? 16 : 24,
                        )),


                  if (widget.bottomActions != null) ...widget.bottomActions!,
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _getBottomNavigatorBarBloc() {

    return BlocListener<ServerDataBloc, ServerDataState>(
      listener: (BuildContext context, ServerDataState state) {
        if (state is ServerDataAdded<T>) {}
        if (state is ServerDataUpdated<T>) {}
        if (state is ServerDataDeleted<T>) {}
        if (state is ServerDataLoaded<T>) {}
      },
      child: BlocBuilder<ServerDataBloc, ServerDataState>(
          builder: (BuildContext context, ServerDataState state) {
            try {
              switch (state.event!.status) {
                case ServerDataEvents.fetch:
                case ServerDataEvents.add:
                case ServerDataEvents.update:
                case ServerDataEvents.delete:
              }
              if (state is ServerDataLoaded || state is ServerDataLoadedCompleted){
                return _getBottomNavigatorBar(withNotch: true);
              } else {
                return shimmerComboLoading(context, height: 20);
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
  String _getCurrentSelectionText() {
    String result = '';
    int tot = gridController != null
        ? gridController!.selectedRows.length
        : (selectedGridRows?.length ?? 0);
    if (tot>0) {
      result = '$tot';
      if (currentSelectedIndex != null) {
        result += ' [${currentSelectedIndex! + 1}]';
      }
      result += tot == 1 ? ' selezionata' : ' selezionate';
    } else {
      result = 'Nessuna selezione';
    }
    return result;
  }

  //_getFloatingActionButton2()
  Widget _buildDataGridColumn(DataScreenColumnConfiguration col,
      {DataType dataType = DataType.grid}) {
    switch (col.filterType) {
      case MultiFilterType.betweenDate:
        return getDataGridDateColumn(col, dataType: dataType);

      case MultiFilterType.selection:
        //print(col.elementType);

        //List? distinctList;
        var bloc = BlocProvider.of<ServerDataBloc>(context);

        List result = col.getItemsForFilter?.call(col, bloc.totalItems ?? []) ??
            _getItemsForFilter(col);

        //List result = _getItemsForFilter(col);
        ///rimuove i doppioni (equivalente a DISTINCT in sql)
        List distinctList = [
          ...{...result}
        ];
        distinctList.sort((a, b) {
          return a.compareTo(b);
        });
        return getDataGridSelectionColumn(col, distinctList,
            dataType: dataType);

      case MultiFilterType.containsText:
      default:
      return getDataGridColumn(col, dataType: dataType);
    }
  }

  List _getItemsForFilter(DataScreenColumnConfiguration col) {
    //print(col.elementType);

    List result = [];

    if (source != null) {
      var bloc = BlocProvider.of<ServerDataBloc>(context);
      if (bloc.totalItems != null) {
        for (T item in bloc.totalItems!) {
          var valueReaded = gato.get(item.json, col.id);
          result.add(valueReaded);
        }
      }
    }
    return result;
  }

  ///Reimposta la posizione di horizontal scroll controller della datagrid
  ///serve per risolvere un problema che nasce dopo l'impostazione di un filtro mentre è stato effettuato uno scrolling verso destra
  ///(il posizionamento della grid e diverso rispetto gli l'headers)
  ///questo comando reimposta la posizione della scrollbar permettendo di mantenere la posizione precedente al filtro e l'allineamento con gli headers
  ///rimuovere l'aggiunta di 0.1 per ottenere un animazione ad ogni restore
  void horizontalScrollControllerRestorePosition() {
    print('hoffset: ${gridController!.horizontalOffset}');
    if (_horizontalScrollController!.offset == 0) {
      gridController!.scrollToHorizontalOffset(
          _horizontalScrollController!.offset + 0.0000001,
          canAnimate: false);
    } else {
      gridController!.scrollToHorizontalOffset(
          _horizontalScrollController!.offset - 0.0000001,
          canAnimate: false);
    }

    */
/* try {
      //_horizontalScrollController!.position.restoreOffset(_horizontalScrollController!.offset);
      _horizontalScrollController!
          .jumpTo(_horizontalScrollController!.offset + 0.00000000001);
    } catch (e) {
      debugPrint(
          'errore horizontalScrollController jumpTo ${_horizontalScrollController?.offset ?? 0 + 0.00000000001} ${e.toString()}');
    }*/ /*

  }

  */
/* void verticalScrollControllerRestorePosition() {
     */ /*
 */
/*gridController!.scrollToVerticalOffset(_verticalScrollController!.offset-0.0000001);*/ /*
 */
/*
    try {
      _verticalScrollController!
          .jumpTo(_verticalScrollController!.offset + 0.00000000001);
    } catch (e) {
      debugPrint(
          'errore horizontalScrollController jumpTo ${_verticalScrollController?.offset ?? 0 + 0.00000000001} ${e.toString()}');
    }
  }*/ /*


  void restoreScrollControllerPosition() {
    if (!isLittleWidth()) {
      try {
        horizontalScrollControllerRestorePosition();
        //verticalScrollControllerRestorePosition();
      } catch (e) {
        print(e);
      }
    }
  }

  getDataGridColumn(DataScreenColumnConfiguration col,
      {DataType dataType = DataType.grid}) {
    print(columnFilters![col.id]!.value.toString());
    return DataGridColumn(
      key: columnsKeys![col.id],
      text: col.label,
      dataType: dataType,
      filterText: columnFilters![col.id]!.value.toString(),
      onFilterChange: (value) {
        setState(() {
          restoreScrollControllerPosition();

          _verticalScrollController
              ?.jumpTo(_verticalScrollController?.offset ?? 0 + 0.00000000001);

          columnFilters![col.id] = Filter(
              filterType: columnFilters![col.id]!.filterType,
              value: value,
              defaultValue: columnFilters![col.id]!.defaultValue,
              isSetted: value.isNotEmpty);

          _loadAsync(false);
        });

        columnFilters!.forEach((key, value) {
          debugPrint('filter $key: $value');
        });
      },
    );
  }

  Widget getDataGridDateColumn(DataScreenColumnConfiguration col,
      {DataType dataType = DataType.grid}) {
    return DataGridDateColumn(
      key: columnsKeys![col.id],
      dataType: dataType,
      text: col.label,
      startFilterText: columnFilters?[col.id]?.value[0],
      endFilterText: columnFilters?[col.id]?.value[1],
      onFilterChange: (startValue, endValue) {
        setState(() {
          restoreScrollControllerPosition();
          _verticalScrollController
              ?.jumpTo(_verticalScrollController?.offset ?? 0 + 0.00000000001);
          columnFilters![col.id] = Filter(
              filterType: columnFilters![col.id]!.filterType,
              value: <String>[startValue, endValue],
              defaultValue: columnFilters![col.id]!.defaultValue,
              isSetted: (startValue.isNotEmpty || endValue.isNotEmpty));
          _loadAsync(false);
        });

        columnFilters!.forEach((key, value) {
          debugPrint('filter $key: $value');
        });
      },
    );
  }

  Widget getDataGridSelectionColumn(
      DataScreenColumnConfiguration col, List<dynamic> list,
      {DataType dataType = DataType.grid}) {
    return DataGridSelectionColumn<dynamic, dynamic>(
      key: columnsKeys![col.id],
      id: col.id,
      text: col.label,
      dataType: dataType,
      //startFilterText: columnFilters?[col.id]?.value[0],
      //endFilterText: columnFilters?[col.id]?.value[1],
      dropdownBuilder: col.dropdownBuilder,
      popupItemBuilder: col.popupItemBuilder,
      itemAsString: col.itemAsString,
      onFilterChange: (List<dynamic>? values) {
        setState(() {
          restoreScrollControllerPosition();
          _verticalScrollController
              ?.jumpTo(_verticalScrollController?.offset ?? 0 + 0.00000000001);
          columnFilters![col.id] = Filter(
              filterType: columnFilters![col.id]!.filterType,
              value: values,
              defaultValue: columnFilters![col.id]!.defaultValue,
              isSetted: values?.isNotEmpty ?? false);
          _loadAsync(false);
        });

        columnFilters!.forEach((key, value) {
          debugPrint('filter $key: $value');
        });
      },
      filterValues: columnFilters![col.id]?.value,
      items: list,
    );
  }

  PreferredSizeWidget _titleBloc() {
    var mediaData = MediaQuery.of(context);

    return PreferredSize(
        preferredSize:
            Size.fromHeight(mediaData.size.height < tinyHeight ? 30 : 56),
        child: BlocListener<ServerDataBloc, ServerDataState>(
          listener: (BuildContext context, ServerDataState state) {
            if (state is ServerDataAdded<T>) {}
            if (state is ServerDataUpdated<T>) {}
            if (state is ServerDataDeleted<T>) {}
            if (state is ServerDataLoaded<T>) {}
          },
          child: BlocBuilder<ServerDataBloc, ServerDataState>(
              builder: (BuildContext context, ServerDataState state) {
            try {
              switch (state.event!.status) {
                case ServerDataEvents.fetch:
                case ServerDataEvents.add:
                case ServerDataEvents.update:
                case ServerDataEvents.delete:
                  if (state is ServerDataLoaded<T>) {
                    String subTitle = currentItems!.length.toString() +
                        (currentItems!.length == 1 ? " elemento" : " elementi");

                    return TitleHelper.getAppBar(
                      title: widget.configuration.title!,
                      subTitle: subTitle,
                      offline: false,
                      icon: widget.configuration.menu.icon,
                      color: getMenuColor(widget.configuration.menu.color),
                      titleClick: _titleClick,
                      printClick: _printClick,
                      customBackClick: _controlledCustomBackClick,
                      context: context,
                      withBackButton: widget.configuration.withBackButton,
                      actions: [
                        if (widget.actions != null) ...widget.actions!,
                        if (isLittleWidth())
                          PopupMenuButton(
                            onCanceled: () {
                              _isPopupVisible = false;
                            },
                            position: PopupMenuPosition.under,
                            tooltip: 'Filtro',
                            constraints: const BoxConstraints(maxWidth: 1500),
                            icon: const Icon(Icons.filter_list,
                                color: Colors.white70),
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              itemBuilder: (BuildContext context) {
                                _isPopupVisible = true;
                              return List.generate(
                                widget.configuration.columns.length,
                                (index) => PopupMenuItem(
                                    value: index,
                                    child: _buildDataGridColumn(
                                        widget.configuration.columns[index],
                                        dataType: DataType.list)

                                    */
/*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/ /*

                                    ),
                              );
                            },
                          ),
                        if (isLittleWidth())
                          PopupMenuButton(
                            position: PopupMenuPosition.under,
                            tooltip: 'Ordinamento',
                            constraints: const BoxConstraints(maxWidth: 1500),
                            icon: Row(
                              children: [
                                const Icon(Icons.sort_by_alpha,
                                    color: Colors.white70),
                                if (source?.sortedColumns.isNotEmpty ?? false)
                                  const SizedBox(width: 8),
                                if (source?.sortedColumns.isNotEmpty ?? false)
                                  Text(
                                    source!.sortedColumns.first.name,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  )
                              ],
                            ),
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            itemBuilder: (BuildContext context) =>
                                List.generate(
                              widget.configuration.columns.length,
                              (index) => PopupMenuItem(
                                value: index,
                                child: Text(
                                    widget.configuration.columns[index].label),
                                onTap: () {
                                  currentSort = source?.sortedColumns
                                      .where((element) =>
                                          element.name ==
                                          widget.configuration.columns[index]
                                              .label)
                                      .toList(growable: false);

                                  ///questa colonna è da ordinare
                                  if (currentSortIndex != index) {
                                    ///questa colonna è da ordinare per la prima volta
                                    source?.sortedColumns.clear();
                                    source?.sortedColumns.add(SortColumnDetails(
                                        name: widget
                                            .configuration.columns[index].label,
                                        sortDirection:
                                            DataGridSortDirection.ascending));
                                  } else {
                                    ///questa colonna è già stata ordinata prima
                                    if (currentSort != null &&
                                        currentSort!.isNotEmpty) {
                                      int sortIndex = source?.sortedColumns
                                              .indexOf(currentSort!.first) ??
                                          -1;
                                      if (sortIndex != -1) {
                                        source?.sortedColumns[sortIndex] =
                                            SortColumnDetails(
                                                name: widget.configuration
                                                    .columns[index].label,
                                                sortDirection: source
                                                            ?.sortedColumns[
                                                                sortIndex]
                                                            .sortDirection ==
                                                        DataGridSortDirection
                                                            .ascending
                                                    ? DataGridSortDirection
                                                        .descending
                                                    : DataGridSortDirection
                                                        .ascending);
                                      }
                                    }
                                  }
                                  setState(() {
                                    oldSortIndex = currentSortIndex;
                                    currentSortIndex = index;
                                    //_loadAsync(false);
                                  });
                                },

                                */
/*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/ /*

                              ),
                            ),
                          ),
                      ],
                    );
                  } else {
                    return TitleHelper.getAppBar(
                        title: widget.configuration.title!,
                        subTitle: '',
                        offline: false,
                        icon: widget.configuration.menu.icon,
                        color: getMenuColor(widget.configuration.menu.color),
                        titleClick: _titleClick,
                        printClick: _printClick,
                        customBackClick: _controlledCustomBackClick,
                        context: context,
                        withBackButton: widget.configuration.withBackButton);
                  }
                default:
                  return TitleHelper.getAppBar(
                      title: widget.configuration.title!,
                      subTitle: '',
                      offline: false,
                      icon: widget.configuration.menu.icon,
                      color: getMenuColor(widget.configuration.menu.color),
                      titleClick: _titleClick,
                      printClick: _printClick,
                      customBackClick: _controlledCustomBackClick,
                      context: context,
                      withBackButton: widget.configuration.withBackButton);
              }
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
              return Container();
            }
          }),
        ));
  }
  PreferredSizeWidget _titleAppBar(bool loading) {
    var mediaData = MediaQuery.of(context);


    if (!loading){
      String subTitle = currentItems!.length.toString() +
          (currentItems!.length == 1 ? " elemento" : " elementi");
      return PreferredSize(
          preferredSize:
          Size.fromHeight(mediaData.size.height < tinyHeight ? 30 : 56),
          child:
        TitleHelper.getAppBar(
        title: widget.configuration.title!,
        subTitle: subTitle,
        offline: false,
        icon: widget.configuration.menu.icon,
        color: getMenuColor(widget.configuration.menu.color),
        titleClick: _titleClick,
        printClick: _printClick,
        customBackClick: _controlledCustomBackClick,
        context: context,
        withBackButton: widget.configuration.withBackButton,
        actions: [
          if (widget.actions != null) ...widget.actions!,
          if (isLittleWidth())
            PopupMenuButton(
              onCanceled: () {
                _isPopupVisible = false;
              },
              position: PopupMenuPosition.under,
              tooltip: 'Filtro',
              constraints: const BoxConstraints(maxWidth: 1500),
              icon: const Icon(Icons.filter_list,
                  color: Colors.white70),
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              itemBuilder: (BuildContext context) {
                _isPopupVisible = true;
                return List.generate(
                  widget.configuration.columns.length,
                      (index) => PopupMenuItem(
                      value: index,
                      child: _buildDataGridColumn(
                          widget.configuration.columns[index],
                          dataType: DataType.list)

                    */
/*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/ /*

                  ),
                );
              },
            ),
          if (isLittleWidth())
            PopupMenuButton(
              position: PopupMenuPosition.under,
              tooltip: 'Ordinamento',
              constraints: const BoxConstraints(maxWidth: 1500),
              icon: Row(
                children: [
                  const Icon(Icons.sort_by_alpha,
                      color: Colors.white70),
                  if (source?.sortedColumns.isNotEmpty ?? false)
                    const SizedBox(width: 8),
                  if (source?.sortedColumns.isNotEmpty ?? false)
                    Text(
                      source!.sortedColumns.first.name,
                      style:
                      const TextStyle(color: Colors.white70),
                    )
                ],
              ),
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              itemBuilder: (BuildContext context) =>
                  List.generate(
                    widget.configuration.columns.length,
                        (index) => PopupMenuItem(
                      value: index,
                      child: Text(
                          widget.configuration.columns[index].label),
                      onTap: () {
                        currentSort = source?.sortedColumns
                            .where((element) =>
                        element.name ==
                            widget.configuration.columns[index]
                                .label)
                            .toList(growable: false);

                        ///questa colonna è da ordinare
                        if (currentSortIndex != index) {
                          ///questa colonna è da ordinare per la prima volta
                          source?.sortedColumns.clear();
                          source?.sortedColumns.add(SortColumnDetails(
                              name: widget
                                  .configuration.columns[index].label,
                              sortDirection:
                              DataGridSortDirection.ascending));
                        } else {
                          ///questa colonna è già stata ordinata prima
                          if (currentSort != null &&
                              currentSort!.isNotEmpty) {
                            int sortIndex = source?.sortedColumns
                                .indexOf(currentSort!.first) ??
                                -1;
                            if (sortIndex != -1) {
                              source?.sortedColumns[sortIndex] =
                                  SortColumnDetails(
                                      name: widget.configuration
                                          .columns[index].label,
                                      sortDirection: source
                                          ?.sortedColumns[
                                      sortIndex]
                                          .sortDirection ==
                                          DataGridSortDirection
                                              .ascending
                                          ? DataGridSortDirection
                                          .descending
                                          : DataGridSortDirection
                                          .ascending);
                            }
                          }
                        }
                        setState(() {
                          oldSortIndex = currentSortIndex;
                          currentSortIndex = index;
                          //_loadAsync(false);
                        });
                      },

                      */
/*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/ /*

                    ),
                  ),
            ),
        ],
      )
      );
    } else {
      return TitleHelper.getAppBar(
          title: widget.configuration.title!,
          subTitle: '',
          offline: false,
          icon: widget.configuration.menu.icon,
          color: getMenuColor(widget.configuration.menu.color),
          titleClick: _titleClick,
          printClick: _printClick,
          customBackClick: _controlledCustomBackClick,
          context: context,
          withBackButton: widget.configuration.withBackButton);
    }

  }
  */
/* void handleVerticalScrollMaxExtent() {
    if (_verticalScrollController!.position.pixels ==
        _verticalScrollController!.position.maxScrollExtent) {
      if (!_hideBottomBar) {
        setState(() {
          _hideBottomBar = true;
        });
      }
    } else {
      if (_hideBottomBar) {
        setState(() {
          _hideBottomBar = false;
        });
      }
    }

    checkScrollbarState();
  }*/ /*


*/
/*  void checkScrollbarState() {
    if (_scrollBarVisible !=
        (_verticalScrollController?.position.maxScrollExtent != 0)) {
      setState(() {
        _scrollBarVisible =
            (_verticalScrollController?.position.maxScrollExtent != 0);
      });
    }
  }*/ /*


*/
/*  Widget _gridListBloc() {
    return BlocListener<ServerDataBloc, ServerDataState>(
        listener: (BuildContext context, ServerDataState state) async {
      _animateToStart();

      if (state is ServerDataLoading) {
        _horizontalScrollController = ScrollController(
          debugLabel: 'horizontalScrollController',
        );

        //_verticalScrollController?.removeListener(handleVerticalScrollMaxExtent);

        _verticalScrollController =
            ScrollController(debugLabel: 'verticalScrollController');
        //_verticalScrollController!.addListener(handleVerticalScrollMaxExtent);
      }
      */ /*
 */
/*  if (itemToSelect!=null){
                            int index = 0;
                            for (var row in source!.effectiveRows){
                              if (row is DataGridRowWithItem){
                                if (row.item==itemToSelect){
                                  gridController.selectedIndex = index;
                                  _animateToEnd();
                                }
                              }
                              index++;
                            }
                          }*/ /*
 */
/*

      try {
        if (state is ServerDataAdded<T>) {
          itemToSelect = state.item;
          if (widget.onSave != null) {
            widget.onSave!.call(itemToSelect!);
          }
        }
        if (state is ServerDataUpdated<T>) {
          itemToSelect = state.item;
          if (widget.onSave != null) {
            widget.onSave!.call(itemToSelect!);
          }
        }
        if (state is ServerDataDeleted<T>) {
          itemToSelect = null;
        }
        if (state is ServerDataLoaded<T>) {
          gridController = DataGridController();
          _horizontalScrollController = ScrollController(
            debugLabel: 'horizontalScrollController',
          );

          //_verticalScrollController?.removeListener(handleVerticalScrollMaxExtent);

          _verticalScrollController =
              ScrollController(debugLabel: 'verticalScrollController');
          currentItems = state.items;

          List<SortColumnDetails>? oldSortedColumns;
          if (source != null) {
            oldSortedColumns = source!.sortedColumns;
          }
          source =
              DefaultDataSource<T>(list: currentItems!, columns: gridColumns!);

          */ /*
 */
/*if (source == null) {
                            source = DefaultDataSource<T>(
                                list: currentItems!, columns: gridColumns!);
                          } else {
                            source!.dataGridRows = DefaultDataSource.toDataGridRows(
                                gridColumns!, currentItems!);
                          }*/ /*
 */
/*
          if (kDebugMode) {
            print('effective rows: ${source!.rows.length}');
          }

          */ /*
 */
/*if (itemToSelect != null) {
                            int index = 0;
                            for (var row in source!.effectiveRows) {
                              if (row is DataGridRowWithItem) {
                                if (row.item == itemToSelect) {
                                  gridController?.selectedIndex = index;
                                  _animateToEnd();
                                  break;
                                }
                              }
                              index++;
                            }
                          }*/ /*
 */
/*

          //if (!isLittleWidth()) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              //if (gridController!.selectedRows.isNotEmpty) {

              //}
              if (kDebugMode) {
                //print(source!.effectiveRows.length);
              }

              if (itemToSelect != null) {
                if (gridController!=null) {
                  int index = 0;
                  for (var row in source!.effectiveRows) {
                    if (row is DataGridRowWithItem) {
                      if (row.item == itemToSelect) {
                        gridController?.selectedIndex = index;
                        gridController?.scrollToRow(index.toDouble(),
                            canAnimate: true);
                        _fabKey.currentState?.setAllState(true);
                        setState(() {});
                        break;
                      }
                    }
                    index++;
                  }
                } else {
                  for (var row in source!.effectiveRows) {
                    if (row is DataGridRowWithItem) {
                      if (row.item == itemToSelect) {
                        scrollToItem(row.item);
                        _fabKey.currentState?.setAllState(true);

                        setState(() {});
                        break;
                      }
                    }
                  }
                }
              } else {

                _fabKey.currentState?.setAllState(false);
                setState(() {});
              }
            });
          //}
          if (oldSortedColumns != null) {
            source!.sortedColumns.clear();
            source!.sortedColumns.addAll(oldSortedColumns);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }, child: BlocBuilder<ServerDataBloc, ServerDataState>(
            builder: (BuildContext context, ServerDataState state) {
      try {
        if (state is ServerDataError<T>) {
          //print("server data error");
          //disableNotify = false;
          final error = state.error;
          String message = '${error.message}';
          String event = state.event?.status.toString() ?? '';
          return InfoScreen(
            message: 'Errore durante $event',
            errorMessage: message,
            emoticonText: '(╯°□°）╯︵ ┻━┻',
            onPressed: () {
              //print("error screen onPressed");
              reload();
            },
          );
        }

        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(
                    message:
                        "Caricamento ${widget.configuration.title!.toLowerCase()}"),
              ],
            );

          case ServerDataEvents.update:
            String message = "Salvataggio in corso";
            if (state is ServerDataUpdated<T>) {
              message = "Salvataggio completato";
            }
            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }
            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                Visibility(
                  visible: isLittleWidth(),
                  child: _list(false),
                ),
                Visibility(visible: !isLittleWidth(), child: _grid(false)),
                LoadingScreen(message: message),
              ],
            );

          case ServerDataEvents.add:
            String message = "Salvataggio in corso";
            if (state is ServerDataAdded<T>) {
              message = "Salvataggio completato";
            }

            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(message: message),
              ],
            );

          case ServerDataEvents.exportPdf:
            if (state is ServerDataExported<T>) {
              */ /*
 */
/*var pdfController = PdfController(
                                document: PdfDocument.openData(base64Decode(response.resultFile!)),
                              );*/ /*
 */
/*
              //final pdf = Future.sync(() => rootBundle.load('document.pdf'));
              //var data = await http.get(url);
              //Printing.layoutPdf(onLayout: (_) => base64Decode(response.resultFile!));
              //await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
              return Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  clipBehavior: Clip.antiAlias,
                  child: PdfPreview(
                    key: _printPreviewKey,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    build: (PdfPageFormat format) {
                      return state.file!;
                    },
                  ));
*/ /*
 */
/*
//                          launchThisUrl(response.path!);
                              final blob = html.Blob(
                                  [base64Decode(response.resultFile!)],
                                  'application/pdf');
                              final url = html.Url.createObjectUrlFromBlob(blob);
                              html.window.open(url, "_blank");
                              //html.Url.revokeObjectUrl(url);

                              _load();*/ /*
 */
/*
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(
                    message:
                        "Creazione anteprima di stampa ${widget.configuration.title!.toLowerCase()} in corso"),
              ],
            );

          case ServerDataEvents.delete:
            String message = "Cancellazione in corso";
            if (state is ServerDataDeleted<T>) {
              message = "Cancellazione completata";
              //disableNotify = false;
              //_animateToStart();

              //  _load();
            }
            if (state is ServerDataLoaded<T>) {
              //disableNotify = false;
              //print("load after update");
              //_load();
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                if (isLittleWidth()) _list(false),
                if (!isLittleWidth()) _grid(false),
                LoadingScreen(message: message),
              ],
            );
          default:
            break;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      if (source != null) {
        if (isLittleWidth()) {
          return _list(false);
        } else {
          return _grid(false);
        }
      } else {
        return const LoadingScreen(message: 'Caricamento');
      }

      //return unknownState(state.event!.status!);
    }));
  }*/ /*


  Widget _gridBloc() {
    return BlocListener<ServerDataBloc, ServerDataState>(
        listener: (BuildContext context, ServerDataState state) async {
          _animateToStart();

          if (state is ServerDataLoading) {
            _horizontalScrollController = ScrollController(
              debugLabel: 'horizontalScrollController',
            );

            //_verticalScrollController?.removeListener(handleVerticalScrollMaxExtent);

            _verticalScrollController =
                ScrollController(debugLabel: 'verticalScrollController');
            //_verticalScrollController!.addListener(handleVerticalScrollMaxExtent);
          }
          */
/*  if (itemToSelect!=null){
                            int index = 0;
                            for (var row in source!.effectiveRows){
                              if (row is DataGridRowWithItem){
                                if (row.item==itemToSelect){
                                  gridController.selectedIndex = index;
                                  _animateToEnd();
                                }
                              }
                              index++;
                            }
                          }*/ /*


          try {
            if (state is ServerDataAdded<T>) {
              itemToSelect = state.item;
              if (widget.onSave != null) {
                widget.onSave!.call(itemToSelect!);
              }
            }
            if (state is ServerDataUpdated<T>) {
              itemToSelect = state.item;
              if (widget.onSave != null) {
                widget.onSave!.call(itemToSelect!);
              }
            }
            if (state is ServerDataDeleted<T>) {
              itemToSelect = null;
            }
            if (state is ServerDataLoaded<T>) {
              gridController = DataGridController();
              _horizontalScrollController = ScrollController(
                debugLabel: 'horizontalScrollController',
              );

              //_verticalScrollController?.removeListener(handleVerticalScrollMaxExtent);

              _verticalScrollController =
                  ScrollController(debugLabel: 'verticalScrollController');
              currentItems = state.items;

              List<SortColumnDetails>? oldSortedColumns;
              if (source != null) {
                oldSortedColumns = source!.sortedColumns;
              }
              source =
                  DefaultDataSource<T>(list: currentItems!, columns: gridColumns!);

              */
/*if (source == null) {
                            source = DefaultDataSource<T>(
                                list: currentItems!, columns: gridColumns!);
                          } else {
                            source!.dataGridRows = DefaultDataSource.toDataGridRows(
                                gridColumns!, currentItems!);
                          }*/ /*

              if (kDebugMode) {
                print('effective rows: ${source!.rows.length}');
              }

              */
/*if (itemToSelect != null) {
                            int index = 0;
                            for (var row in source!.effectiveRows) {
                              if (row is DataGridRowWithItem) {
                                if (row.item == itemToSelect) {
                                  gridController?.selectedIndex = index;
                                  _animateToEnd();
                                  break;
                                }
                              }
                              index++;
                            }
                          }*/ /*


              WidgetsBinding.instance.addPostFrameCallback((_) {
                //if (gridController!.selectedRows.isNotEmpty) {

                //}
                if (kDebugMode) {
                  //print(source!.effectiveRows.length);
                }
                if (itemToSelect != null) {
                  int index = 0;
                  for (var row in source!.effectiveRows) {
                    if (row is DataGridRowWithItem) {
                      if (row.item == itemToSelect) {
                        gridController?.selectedIndex = index;
                        gridController?.scrollToRow(index.toDouble(),
                            canAnimate: true);
                        _fabKey.currentState?.setAllState(true);
                        setState(() {});
                        break;
                      }
                    }
                    index++;
                  }
                } else {
                  _fabKey.currentState?.setAllState(false);
                  setState(() {});
                }
              });

              if (oldSortedColumns != null) {
                source!.sortedColumns.clear();
                source!.sortedColumns.addAll(oldSortedColumns);
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }, child: BlocBuilder<ServerDataBloc, ServerDataState>(
        builder: (BuildContext context, ServerDataState state) {
          try {
            if (state is ServerDataError<T>) {
              //print("server data error");
              //disableNotify = false;
              final error = state.error;
              String message = '${error.message}';
              String event = state.event?.status.toString() ?? '';
              return InfoScreen(
                message: 'Errore durante $event',
                errorMessage: message,
                emoticonText: '(╯°□°）╯︵ ┻━┻',
                onPressed: () {
                  //print("error screen onPressed");
                  reload();
                },
              );
            }

            switch (state.event!.status) {
              case ServerDataEvents.fetch:
                if (state is ServerDataLoaded<T>) {
                  //currentItems = state.items;
                  break;
                }

                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    LoadingScreen(
                        message:
                        "Caricamento ${widget.configuration.title!.toLowerCase()}"),
                  ],
                );

              case ServerDataEvents.update:
                String message = "Salvataggio in corso";
                if (state is ServerDataUpdated<T>) {
                  message = "Salvataggio completato";
                }
                if (state is ServerDataLoaded<T>) {
                  //currentItems = state.items;
                  break;
                }
                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    _grid(false),
                    LoadingScreen(message: message),
                  ],
                );

              case ServerDataEvents.add:
                String message = "Salvataggio in corso";
                if (state is ServerDataAdded<T>) {
                  message = "Salvataggio completato";
                }

                if (state is ServerDataLoaded<T>) {
                  //currentItems = state.items;
                  break;
                }

                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    LoadingScreen(message: message),
                  ],
                );

              case ServerDataEvents.exportPdf:
                if (state is ServerDataExported<T>) {
                  */
/*var pdfController = PdfController(
                                document: PdfDocument.openData(base64Decode(response.resultFile!)),
                              );*/ /*

                  //final pdf = Future.sync(() => rootBundle.load('document.pdf'));
                  //var data = await http.get(url);
                  //Printing.layoutPdf(onLayout: (_) => base64Decode(response.resultFile!));
                  //await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
                  return Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      clipBehavior: Clip.antiAlias,
                      child: PdfPreview(
                        key: _printPreviewKey,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        build: (PdfPageFormat format) {
                          return state.file!;
                        },
                      ));
*/
/*
//                          launchThisUrl(response.path!);
                              final blob = html.Blob(
                                  [base64Decode(response.resultFile!)],
                                  'application/pdf');
                              final url = html.Url.createObjectUrlFromBlob(blob);
                              html.window.open(url, "_blank");
                              //html.Url.revokeObjectUrl(url);

                              _load();*/ /*

                }

                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    LoadingScreen(
                        message:
                        "Creazione anteprima di stampa ${widget.configuration.title!.toLowerCase()} in corso"),
                  ],
                );

              case ServerDataEvents.delete:
                String message = "Cancellazione in corso";
                if (state is ServerDataDeleted<T>) {
                  message = "Cancellazione completata";
                  //disableNotify = false;
                  //_animateToStart();

                  //  _load();
                }
                if (state is ServerDataLoaded<T>) {
                  //disableNotify = false;
                  //print("load after update");
                  //_load();
                  //currentItems = state.items;
                  break;
                }

                return Stack(
                  alignment: const Alignment(0.6, 0.6),
                  children: [
                    _grid(false),
                    LoadingScreen(message: message),
                  ],
                );
              default:
                break;
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }

          if (source != null) {
            return _grid(false);
          } else {
            return const LoadingScreen(message: 'Caricamento');
          }

          //return unknownState(state.event!.status!);
        }));
  }

  Widget _listBloc() {
    return BlocListener<ServerDataBloc, ServerDataState>(
        listener: (BuildContext context, ServerDataState state) async {
      _animateToStart();

      if (state is ServerDataLoading) {}

      try {
        if (state is ServerDataAdded<T>) {
          itemToSelect = state.item;
          if (widget.onSave != null) {
            widget.onSave!.call(itemToSelect!);
          }
        }
        if (state is ServerDataUpdated<T>) {
          itemToSelect = state.item;
          if (widget.onSave != null) {
            widget.onSave!.call(itemToSelect!);
          }
        }
        if (state is ServerDataDeleted<T>) {
          itemToSelect = null;
        }
        if (state is ServerDataLoaded<T>) {
          gridController = DataGridController();
          currentItems = state.items;

          List<SortColumnDetails>? oldSortedColumns;
          if (source != null) {
            oldSortedColumns = source!.sortedColumns;
          }
          source =
              DefaultDataSource<T>(list: currentItems!, columns: gridColumns!);

          if (kDebugMode) {
            print('effective rows: ${source!.rows.length}');
          }

          */
/*if (!isLittleWidth()) {*/ /*

          WidgetsBinding.instance.addPostFrameCallback((_) {
              //if (gridController!.selectedRows.isNotEmpty) {

              //}
              if (kDebugMode) {
                //print(source!.effectiveRows.length);
              }
              if (itemToSelect != null) {
              if (gridController != null) {
                int index = 0;
                for (var row in source!.effectiveRows) {
                  if (row is DataGridRowWithItem) {
                    if (row.item == itemToSelect) {
                      gridController?.selectedIndex = index;
                      gridController?.scrollToRow(index.toDouble(),
                          canAnimate: true);
                      _fabKey.currentState?.setAllState(true);
                      setState(() {});
                      break;
                    }
                  }
                  index++;
                }
              } else {
                for (var row in source!.effectiveRows) {
                  if (row is DataGridRowWithItem) {
                    if (row.item == itemToSelect) {
                      scrollToItem(row.item);
                      _fabKey.currentState?.setAllState(true);
                      setState(() {});
                      break;
                    }
                  }
                }
              }
            } else {
                _fabKey.currentState?.setAllState(false);
                setState(() {});
              }
            });
          */
/*}*/ /*

          if (oldSortedColumns != null) {
            source!.sortedColumns.clear();
            source!.sortedColumns.addAll(oldSortedColumns);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }, child: BlocBuilder<ServerDataBloc, ServerDataState>(
            builder: (BuildContext context, ServerDataState state) {
      try {
        if (state is ServerDataError<T>) {
          //print("server data error");
          //disableNotify = false;
          final error = state.error;
          String message = '${error.message}';
          String event = state.event?.status.toString() ?? '';
          return InfoScreen(
            message: 'Errore durante $event',
            errorMessage: message,
            emoticonText: '(╯°□°）╯︵ ┻━┻',
            onPressed: () {
              //print("error screen onPressed");
              reload();
            },
          );
        }

        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(
                    message:
                        "Caricamento ${widget.configuration.title!.toLowerCase()}"),
              ],
            );

          case ServerDataEvents.update:
            String message = "Salvataggio in corso";
            if (state is ServerDataUpdated<T>) {
              message = "Salvataggio completato";
            }
            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }
            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                _list(false),
                LoadingScreen(message: message),
              ],
            );

          case ServerDataEvents.add:
            String message = "Salvataggio in corso";
            if (state is ServerDataAdded<T>) {
              message = "Salvataggio completato";
            }

            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(message: message),
              ],
            );

          case ServerDataEvents.exportPdf:
            if (state is ServerDataExported<T>) {
              */
/*var pdfController = PdfController(
                                document: PdfDocument.openData(base64Decode(response.resultFile!)),
                              );*/ /*

              //final pdf = Future.sync(() => rootBundle.load('document.pdf'));
              //var data = await http.get(url);
              //Printing.layoutPdf(onLayout: (_) => base64Decode(response.resultFile!));
              //await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
              return Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  clipBehavior: Clip.antiAlias,
                  child: PdfPreview(
                    key: _printPreviewKey,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    build: (PdfPageFormat format) {
                      return state.file!;
                    },
                  ));
*/
/*
//                          launchThisUrl(response.path!);
                              final blob = html.Blob(
                                  [base64Decode(response.resultFile!)],
                                  'application/pdf');
                              final url = html.Url.createObjectUrlFromBlob(blob);
                              html.window.open(url, "_blank");
                              //html.Url.revokeObjectUrl(url);

                              _load();*/ /*

            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(
                    message:
                        "Creazione anteprima di stampa ${widget.configuration.title!.toLowerCase()} in corso"),
              ],
            );

          case ServerDataEvents.delete:
            String message = "Cancellazione in corso";
            if (state is ServerDataDeleted<T>) {
              message = "Cancellazione completata";
              //disableNotify = false;
              //_animateToStart();

              //  _load();
            }
            if (state is ServerDataLoaded<T>) {
              //disableNotify = false;
              //print("load after update");
              //_load();
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                _list(false),
                LoadingScreen(message: message),
              ],
            );
          default:
            break;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      if (source != null) {
        return _list(false);
      } else {
        return const LoadingScreen(message: 'Caricamento');
      }

      //return unknownState(state.event!.status!);
    }));
  }

*/
/*  Widget _listBloc() {
    return BlocListener<ServerDataBloc, ServerDataState>(
        listener: (BuildContext context, ServerDataState state) async {
      _animateToStart();

      if (state is ServerDataLoading) {
        */ /*
 */
/*_horizontalScrollController = ScrollController(
              debugLabel: 'horizontalScrollController',
            );



            _verticalScrollController =
                ScrollController(debugLabel: 'verticalScrollController');
            */ /*
 */
/*
      }

      try {
        if (state is ServerDataAdded<T>) {
          itemToSelect = state.item;
          if (widget.onSave != null) {
            widget.onSave!.call(itemToSelect!);
          }
        }
        if (state is ServerDataUpdated<T>) {
          itemToSelect = state.item;
          if (widget.onSave != null) {
            widget.onSave!.call(itemToSelect!);
          }
        }
        if (state is ServerDataDeleted<T>) {
          itemToSelect = null;
        }
        if (state is ServerDataLoaded<T>) {
          gridController = DataGridController();

          currentItems = state.items;

          List<SortColumnDetails>? oldSortedColumns;
          if (source != null) {
            oldSortedColumns = source!.sortedColumns;
          }
          source =
              DefaultDataSource<T>(list: currentItems!, columns: gridColumns!);

          if (kDebugMode) {
            print('effective rows: ${source!.rows.length}');
          }

*/ /*
 */
/*
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (itemToSelect != null) {
                  int index = 0;
                  for (var row in source!.effectiveRows) {
                    if (row is DataGridRowWithItem) {
                      if (row.item == itemToSelect) {
                        gridController?.selectedIndex = index;
                        gridController?.scrollToRow(index.toDouble(),
                            canAnimate: true);
                        _fabKey.currentState?.setAllState(true);
                        setState(() {});
                        break;
                      }
                    }
                    index++;
                  }
                } else {
                  _fabKey.currentState?.setAllState(false);
                  setState(() {});
                }
              });
*/ /*
 */
/*
          if (oldSortedColumns != null) {
            source!.sortedColumns.clear();
            source!.sortedColumns.addAll(oldSortedColumns);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }, child: BlocBuilder<ServerDataBloc, ServerDataState>(
            builder: (BuildContext context, ServerDataState state) {
      try {
        if (state is ServerDataError<T>) {
          //print("server data error");
          //disableNotify = false;
          final error = state.error;
          String message = '${error.message}';
          String event = state.event?.status.toString() ?? '';
          return InfoScreen(
            message: 'Errore durante $event',
            errorMessage: message,
            emoticonText: '(╯°□°）╯︵ ┻━┻',
            onPressed: () {
              //print("error screen onPressed");
              reload();
            },
          );
        }

        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(
                    message:
                        "Caricamento ${widget.configuration.title!.toLowerCase()}"),
              ],
            );

          case ServerDataEvents.update:
            String message = "Salvataggio in corso";
            if (state is ServerDataUpdated<T>) {
              message = "Salvataggio completato";
            }
            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }
            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                if (isLittleWidth()) _list(false),
                if (!isLittleWidth()) _grid(false),
                LoadingScreen(message: message),
              ],
            );

          case ServerDataEvents.add:
            String message = "Salvataggio in corso";
            if (state is ServerDataAdded<T>) {
              message = "Salvataggio completato";
            }

            if (state is ServerDataLoaded<T>) {
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(message: message),
              ],
            );

          case ServerDataEvents.exportPdf:
            if (state is ServerDataExported<T>) {
              */ /*
 */
/*var pdfController = PdfController(
                                document: PdfDocument.openData(base64Decode(response.resultFile!)),
                              );*/ /*
 */
/*
              //final pdf = Future.sync(() => rootBundle.load('document.pdf'));
              //var data = await http.get(url);
              //Printing.layoutPdf(onLayout: (_) => base64Decode(response.resultFile!));
              //await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
              return Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  clipBehavior: Clip.antiAlias,
                  child: PdfPreview(
                    key: _printPreviewKey,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    build: (PdfPageFormat format) {
                      return state.file!;
                    },
                  ));
*/ /*
 */
/*
//                          launchThisUrl(response.path!);
                              final blob = html.Blob(
                                  [base64Decode(response.resultFile!)],
                                  'application/pdf');
                              final url = html.Url.createObjectUrlFromBlob(blob);
                              html.window.open(url, "_blank");
                              //html.Url.revokeObjectUrl(url);

                              _load();*/ /*
 */
/*
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                LoadingScreen(
                    message:
                        "Creazione anteprima di stampa ${widget.configuration.title!.toLowerCase()} in corso"),
              ],
            );

          case ServerDataEvents.delete:
            String message = "Cancellazione in corso";
            if (state is ServerDataDeleted<T>) {
              message = "Cancellazione completata";
              //disableNotify = false;
              //_animateToStart();

              //  _load();
            }
            if (state is ServerDataLoaded<T>) {
              //disableNotify = false;
              //print("load after update");
              //_load();
              //currentItems = state.items;
              break;
            }

            return Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                if (isLittleWidth()) _list(false),
                if (!isLittleWidth()) _grid(false),
                LoadingScreen(message: message),
              ],
            );
          default:
            break;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      if (source != null) {
        return _list(false);
      } else {
        return const LoadingScreen(message: 'Caricamento');
      }

      //return unknownState(state.event!.status!);
    }));
  }*/ /*


*/
/*  launchThisUrl(String url) async {
    await launchThisUrlAsync(url);
  }

  launchThisUrlAsync(String url) async {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  }*/ /*


  _getFloatingActionButton() {
    return BlocBuilder<ServerDataBloc, ServerDataState>(
        builder: (BuildContext context, ServerDataState state) {
      try {
        //FAB disabilitato
        if (!isActionsEnabled()) {
          return _getFAB(false, false);
        }
        if (state is ServerDataLoaded<T>) {
          return _getFAB(true, true);
        }

        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataError<T>) {
              return _getFAB(false, false);
            }
            */
/*               if (state is ServerDataLoaded<T>) {
                  return _getFAB(true, true);
                }*/ /*


            return _getFAB(true, false);

          case ServerDataEvents.update:
            */
/*           if (state is ServerDataUpdated<T>) {
                  return _getFAB(true, true);
                }*/ /*

            if (state is ServerDataError<T>) {
              return _getFAB(false, false);
            }
            return _getFAB(true, false);
          case ServerDataEvents.add:
            */
/*          if (state is ServerDataAdded<T>) {
                  return _getFAB(true, true);
                }*/ /*

            if (state is ServerDataError<T>) {
              return _getFAB(false, false);
            }

            return _getFAB(false, false);
          case ServerDataEvents.delete:
            */
/*          if (state is ServerDataDeleted<T>) {
                  return _getFAB(true, true);
                }*/ /*

            if (state is ServerDataError<T>) {
              return _getFAB(false, false);
            }

            return _getFAB(true, false);
          default:
            break;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      return _getFAB(false, false);
    });
  }

  _getFloatingActionButton2() {
    return BlocBuilder<ServerDataBloc, ServerDataState>(
        builder: (BuildContext context, ServerDataState state) {
      try {
        //FAB disabilitato
        if (!isActionsEnabled()) {
          return _getFAB2(isVisible: false, isEnabled: false);
        }
        if (state is ServerDataLoaded<T>) {
          return _getFAB2(isVisible: true, isEnabled: true);
        }

        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataError<T>) {
              return _getFAB2(isVisible: false, isEnabled: false);
            }
            */
/*               if (state is ServerDataLoaded<T>) {
                  return _getFAB(true, true);
                }*/ /*


            return _getFAB2(isVisible: false, isEnabled: false);

          case ServerDataEvents.update:
            */
/*           if (state is ServerDataUpdated<T>) {
                  return _getFAB(true, true);
                }*/ /*

            if (state is ServerDataError<T>) {
              return _getFAB2(isVisible: false, isEnabled: false);
            }
            return _getFAB2(isVisible: false, isEnabled: false);
          case ServerDataEvents.add:
            */
/*          if (state is ServerDataAdded<T>) {
                  return _getFAB(true, true);
                }*/ /*

            if (state is ServerDataError<T>) {
              return _getFAB2(isVisible: false, isEnabled: false);
            }

            return _getFAB2(isVisible: false, isEnabled: false);
          case ServerDataEvents.delete:
            */
/*          if (state is ServerDataDeleted<T>) {
                  return _getFAB(true, true);
                }*/ /*

            if (state is ServerDataError<T>) {
              return _getFAB2(isVisible: false, isEnabled: false);
            }

            return _getFAB2(isVisible: false, isEnabled: false);

          default:
            return _getFAB2(isVisible: false, isEnabled: false);
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      return _getFAB2(isVisible: false, isEnabled: false);
    });
  }
  _getFloatingActionButton3(bool loading) {
    if (!isActionsEnabled()) {
      return _getFAB2(isVisible: false, isEnabled: false);
    }
    if (loading){
      return _getFAB2(isVisible: false, isEnabled: false);
    } else {
      return _getFAB2(isVisible: true, isEnabled: true);
    }
  }

  _getFAB(bool isVisible, bool isEnabled) {
    return Visibility(
        visible: isVisible,
        child: AnimateIcons(
          startIcon: Icons.add_outlined,
          endIcon: Icons.close_outlined,
          controller: controller!,
          startTooltip: widget.configuration.addButtonToolTipText,
          endTooltip: widget.configuration.deleteButtonToolTipText,
          onStartIconPress: () {
            return isEnabled ? onStartIconPress() : false;
          },
          onEndIconPress: () {
            return isEnabled ? onEndIconPress() : false;
          },
          startIconColor: Theme.of(context).colorScheme.primary,
          endIconColor: Colors.red,
          duration: const Duration(milliseconds: 250),
          startIconSize: 30,
          endIconSize: 26,
          clockwise: false,
        ));
  }

  Widget _getFAB2(
      {bool? isVisible,
      bool? isEnabled,
      bool customDialRoot = false,
      Size buttonSize = const Size(56.0, 56.0),
      bool extend = true,
      Size childrenButtonSize = const Size(56.0, 56.0),
     // SpeedDialDirection speedDialDirection = SpeedDialDirection.up,
      bool switchLabelPosition = false}) {
    return Visibility(
      visible: isVisible ?? true,
      child: AnimatedContainer(
        */
/* decoration: BoxDecoration(
            color: Color.alphaBlend(
                    isDarkTheme(context)
                        ? Colors.black.withAlpha(90)
                        : Colors.white.withAlpha(90),
                    Theme.of(context).colorScheme.primary)
                .withAlpha(90),
            borderRadius: BorderRadius.circular(120)),*/ /*

        duration: const Duration(milliseconds: 550),
        height: _fabKey.currentState?.currentState
                    .any((element) => element.value == true) ??
                false
            ? 220
            : 56,
        width: _fabKey.currentState?.currentState
                    .any((element) => element.value == true) ??
                false
            ? 220
            : 56,
        child: ExpandableFab(
          key: _fabKey,
          openCloseSwitch: isFABOpen,
          distance: 112.0,
          onCustomOpen: () {
            List<DataGridRow>? selectedRows = gridController != null
                ? gridController!.selectedRows
                : selectedGridRows;
            if (selectedRows?.isNotEmpty ?? false) {
              if ((selectedRows?.length ?? 0) > 1) {
                //posso solo eliminare e inserire
              } else {
                //posso eliminare, modificare e inserire
              }
            } else {
              //posso solo inserire
              if (isEnabled ?? false) {
                var element = _fabKey.currentState!.widget.children[0];
                if (element is ActionButton) {
                  element.onPressed?.call();
                }
              }
            }
          },
          onCustomClose: () {
            setState(() {
              _fabKey.currentState?.setAllState(false);
              itemToSelect = null;

              //TEST:
              gridController?.selectedRows.clear();
              selectedGridRows?.clear();
              try {
                gridController?.selectedRows = [];
              } catch (e) {
                print(e);
              }

              listRowKeyMap.forEach((key, value) {
                if (value.currentState!=null) {
                  print("currentState: ${value.currentState?.isSelected}");
                }
                //if (value.currentState?.isSelected ?? false){
                  value.currentState?.isSelected=false;

                //}
              });
              _selectionToggleKey.currentState?.currentValue = _getCurrentSelectionText();
            });
          },
          children: [
            ActionButton(
              color: Color.alphaBlend(Colors.green.withAlpha(200),
                  Theme.of(context).colorScheme.primary),
              onPressed: () {
                openNew();
                //_fabKey.currentState?.toggleStateSingle(0);
              },
              icon: const Icon(Icons.add),
              text: 'Aggiungi',
            ),
            ActionButton(
              color: Color.alphaBlend(Colors.blue.withAlpha(200),
                  Theme.of(context).colorScheme.primary),
              onPressed: () {
                DataGridRow? row;

                if ((gridController != null &&
                    gridController!.selectedRows.isNotEmpty)) {
                  row = gridController!.selectedRows[0];
                } else if (selectedGridRows != null &&
                    selectedGridRows!.isNotEmpty) {
                  row = selectedGridRows![0];
                }

                if (row != null && row is DataGridRowWithItem) {
                  if (widget.configuration.menu.status != null &&
                      widget.configuration.menu.status == 2) {
                    openDetail(row.item);
                  }
                }
              },
              icon: const Icon(Icons.edit),
              text: 'Modifica',
            ),
            ActionButton(
              color: Color.alphaBlend(Colors.red.withAlpha(200),
                  Theme.of(context).colorScheme.primary),
              onPressed: () {
                _deleteItems();
                //_fabKey.currentState?.toggleStateSingle(2);
              },
              icon: const Icon(Icons.delete),
              text: 'Elimina',
            ),
          ],
        ),
      ),
    );
  }

  bool onStartIconPress() {
    openNew();

    return false;
  }

  bool onEndIconPress() {
    _deleteItems();
    return false;
  }

  _deleteItems() {
    if (widget.delete != null) {
      List<DataGridRow> selectedRows = <DataGridRow>[];
      if (gridController != null) {
        selectedRows = gridController!.selectedRows;
      } else {
        selectedRows = selectedGridRows ?? <DataGridRow>[];
      }
      if (selectedRows.isNotEmpty) {
        var deleteList = <T>[];

        for (DataGridRow row in selectedRows) {
          if (row is DataGridRowWithItem) {
            deleteList.add(row.item);
          }
        }

        _requestDelete(deleteList, onEvent: widget.onDelete);
      }
    }
  }

  _requestDelete(List<T> items,
      {Function(Bloc bloc, ServerDataEvent event, Emitter emit)?
          onEvent}) async {
    try {
      if (widget.delete != null) {
        var result = await widget.delete!.call(context, items);
        switch (result) {
          case "0":
            try {
              _delete(items, onEvent: onEvent);
              widget.onDeleted?.call(items);
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
            break;
          default:
            itemToSelect = items.last;
            _loadAsync(false);
            break;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget unknownState(ServerDataEvents event) {
    return InfoScreen(
      message: "Stato sconosciuto o non gestito!",
      //errorMessage: message,
      emoticonText: '¯\\_( ツ )_/¯',
      onPressed: () {
        //print("error screen onPressed");
        reload();
      },
    );
  }

*/
/*  int oldRowIdx = -1;
  int oldTrueIdx = -1;*/ /*

  //bool _rowIndexIsChanged = false;
*/
/*  bool sortChanged = false;
  PlutoColumn? oldSortedColumn;
  PlutoColumnSort? oldSortDirection;*/ /*


  */
/*void handleCurrentSelectionState() {
//    _setCurrentRow();
    */ /*
 */
/* print(_stateManager!.currentCell!.value);
    print(_stateManager!.currentRow!.key);
    print(_stateManager!.currentColumn!.title);
    print("SelectingRows: " +
        _stateManager!.currentSelectingPositionList.length.toString());*/ /*
 */
/*
    try {
      */ /*
 */
/*widget.stateManager.setCurrentCell(widget.stateManager.firstCell, 0);
      widget.stateManager.setCurrentSelectingPositionByCellKey(
        widget.stateManager.rows[1]!.cells.entries.last.value.key,
      );*/ /*
 */
/*

      ///trovo l'item, lo seleziono e calcolo direzione scroll
      PlutoMoveDirection? direction;

*/ /*
 */
/*
      Object elemento = adapter!.listLocale![oldTrueIdx];
      Object elemento2 = adapter!.listLocale![_stateManager!.rows[oldRowIdx]!.sortIdx!];
      Object elemento3 = adapter!.listLocale![_stateManager!.currentRow!.sortIdx!];
      Object elemento4 = adapter!.listLocale![_stateManager!.currentRowIdx!];


      if (elemento2 != elemento3){
        _rowIndexIsChanged=true;
      } else {
        _rowIndexIsChanged=false;
      }

*/ /*
 */
/*

      if (oldRowIdx != _stateManager!.currentRowIdx!) {
        if (oldRowIdx < _stateManager!.currentRowIdx!) {
          direction = PlutoMoveDirection.down;
        } else if (oldRowIdx > _stateManager!.currentRowIdx!) {
          direction = PlutoMoveDirection.up;
        }
        oldRowIdx = _stateManager!.currentRowIdx!;
        itemToSelect =
            adapter!.listLocale![_stateManager!.currentRow!.sortIdx!];
      }

      ///se l'item è stato trovato o selezionato in precedenza
      ///trovo il vero valore dell'index basato su sortIndex e la direzione di scroll
      if (itemToSelect != null) {
        if (_stateManager!.getSortedColumn != null) {
          if (oldSortedColumn == null ||
              oldSortedColumn != _stateManager!.getSortedColumn! ||
              oldSortDirection != _stateManager!.getSortedColumn!.sort) {
            sortChanged = true;
          } else {
            sortChanged = false;
          }
          oldSortedColumn = _stateManager!.getSortedColumn;
          oldSortDirection = _stateManager!.getSortedColumn!.sort;

          ///sort in corso
          int trueIndex = _getTrueIndex(itemToSelect);

          if (direction == null) {
            if (oldTrueIdx < trueIndex) {
              direction = PlutoMoveDirection.down;
            } else {
              direction = PlutoMoveDirection.up;
            }
          }
          oldTrueIdx = trueIndex;
          //_stateManager!.moveScrollByRow(direction, trueIndex);
          if (sortChanged == true) {
            _stateManager!.moveScrollByRow(direction, trueIndex);
          }
          //widget.headerOnTap(stateManager.getSortedColumn.field);
        } else if (_stateManager!.getSortedColumn == null) {
          ///nessun sort

          if (oldSortedColumn != null) {
            sortChanged = true;
          } else {
            sortChanged = false;
          }
          oldSortedColumn = null;
          oldSortDirection = null;

          int trueIndex = _getTrueIndex(itemToSelect);

          if (direction == null) {
            if (oldTrueIdx < trueIndex) {
              direction = PlutoMoveDirection.down;
            } else {
              direction = PlutoMoveDirection.up;
            }
          }
          oldTrueIdx = trueIndex;
          */ /*
 */
/*_stateManager!.moveScrollByRow(
        direction, trueIndex);*/ /*
 */
/*
          if (sortChanged == true) {
            _stateManager!.moveScrollByRow(direction, trueIndex);
          }
        }
      }

      */ /*
 */
/*if (_stateManager!.isSelecting) {
        for (var element in _stateManager!.rows) {
          element.setChecked(false);
        }

        String value = '';
        for (var element in _stateManager!.currentSelectingRows) {
          setState(() {
            element.setChecked(true);
          });
          //_stateManager!.checkedRows.add(element);
          //value += 'first cell value of row: $cellValue\n';
        }
        if (kDebugMode) {
          print("Value: " + value);
        }
      }*/ /*
 */
/*
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void handleSelectionState() {
    String value = '';

    for (var element in _stateManager!.currentSelectingRows) {
      final cellValue = element.cells.entries.first.value.value.toString();

      value += 'first cell value of row: $cellValue\n';
    }

    if (value.isEmpty) {
      value = 'No rows are selected.';
    }
  }*/ /*

  //late RowSelectionManager _customSelection;
  DataGridController? gridController;

  bool showLoadContainer = true;
  late CustomColumnSizer _customColumnSizer;

  Map<RowColumnIndex, int> doubleTapState = {};
  final Stopwatch swClickCount = Stopwatch();
  int clickCount = 0;

  List<DataGridRow>? selectedGridRows=<DataGridRow>[];
  double verticalOffset = 0;
  double horizontalOffset = 0;

  final Map<T, GlobalKey<DataScreenItemState>> listRowKeyMap = {};

  Color getScaffoldBackgroundColor() {
    return isDarkTheme(context)
        ? Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(230),
            Theme.of(context).colorScheme.primary)
        : Color.alphaBlend(
            Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
            Theme.of(context).colorScheme.primary);
  }

  Color getDataGridBackgroundColor() {
    return isDarkTheme(context)
        ? Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(230),
                Theme.of(context).colorScheme.primary)
            .darken()
            .darken()
        : Color.alphaBlend(
            Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
            Theme.of(context).colorScheme.primary);
  }

  Widget _grid(bool? offline) {
    currentSortedColumns = null;
    gridController ??= DataGridController(
      selectedRows: selectedGridRows ?? <DataGridRow>[],
    );
    _horizontalScrollController ??= ScrollController(
      debugLabel: 'horizontalScrollController',
    );

    //_verticalScrollController?.removeListener(handleVerticalScrollMaxExtent);

    _verticalScrollController ??=
        ScrollController(debugLabel: 'verticalScrollController');
*/
/*    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      restoreScrollControllerPosition();
    });*/ /*

    //bool isSmall = MediaQuery.of(context).size.width<1000 || MediaQuery.of(context).size.height < 800;
    bool isSmall = true;
    return Padding(
      padding: EdgeInsets.all(isSmall ? 0 : 16.0),
      child: Material(
        type: MaterialType.card,
        elevation: isSmall ? 0 : 20,
        shadowColor: Theme.of(context).shadowColor.withAlpha(200),
        borderRadius: BorderRadius.circular(isSmall ? 0 : 20),
        clipBehavior: Clip.antiAlias,
        child: Container(
          //duration: const Duration(milliseconds: 500),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: getDataGridBackgroundColor(),
            borderRadius: BorderRadius.circular(isSmall ? 0 : 20),
          ),
          child: SfDataGridTheme(
              data: SfDataGridThemeData(
                headerColor: isDarkTheme(context)
                    ? Color.alphaBlend(Colors.black.withAlpha(180),
                        Theme.of(context).colorScheme.primary)
                    : Theme.of(context).backgroundColor,
                sortIconColor: Color.alphaBlend(
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                    Theme.of(context).colorScheme.primary.withAlpha(90)),
                selectionColor:
                Theme.of(context).colorScheme.primary.withAlpha(120),
                //columnResizeIndicatorStrokeWidth: 5,
                gridLineStrokeWidth: 1,
                frozenPaneLineWidth: 2,
                frozenPaneElevation: 0,

                currentCellStyle: DataGridCurrentCellStyle(
                    borderWidth: 4,
                    borderColor: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withAlpha(120)),
                frozenPaneLineColor: Color.alphaBlend(
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                    Theme.of(context).colorScheme.primary.withAlpha(90)),
                gridLineColor: Color.alphaBlend(
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                    Theme.of(context).colorScheme.primary.withAlpha(90)),
                //currentCellStyle: DataGridCurrentCellStyle(borderColor: Color.alphaBlend(Theme.of(context).colorScheme.onSurface.withOpacity(0.12), Theme.of(context).colorScheme.primary.withAlpha(90)), borderWidth: 5)
                */
/*rowHoverColor: Colors.yellow,
              rowHoverTextStyle: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),*/ /*

              ),
              child: SfDataGrid(
                key: _sfGridKey,
                rowsCacheExtent: source!.list.length,
                columnSizer: _customColumnSizer,
                horizontalScrollController: _horizontalScrollController,
                verticalScrollController: _verticalScrollController,
                controller: gridController,
                frozenColumnsCount: 1,
                frozenRowsCount: 0,
                columnResizeMode: ColumnResizeMode.onResize,
                //selectionManager: _customSelection,
                allowColumnsResizing: true,
                allowTriStateSorting: true,
                headerRowHeight: 100,
                allowSorting: true,
                showCheckboxColumn: true,
                isScrollbarAlwaysShown:
                isWindowsBrowser || isWindows ? true : false,
                columnWidthMode: ColumnWidthMode.auto,
                source: source!,
                columns: gridColumns!,
                selectionMode: SelectionMode.multiple,
                onColumnResizeStart: (details) {
                  print(details.column.columnName.toString());
                  if (details.column.columnName.isEmpty) {
                    return false;
                  }

                  return true;
                },
                onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                  setState(() {
                    if (details.width > 0) {
                      if (details.column is GridColumnWithWidget) {
                        columnWidths![(details.column as GridColumnWithWidget)
                            .id] = details.width;
                      }
                    }
                  });
                  return true;
                },
                onQueryRowHeight: (details) {
                  // Set the row height as 100.0 to the column header row.
                  //debugPrint('details.rowIndex: ${details.rowIndex}');

                  return details.rowIndex == 0
                      ? 100.0
                      : widget.configuration.useIntrinsicRowHeight ?? false
                      ? details.getIntrinsicRowHeight(details.rowIndex) - 10
                      : isMobile
                      ? 50
                      : 40;
                },

                ///TODO: fornire un callback per decidere se confermare la selezione in corso oppure no
                */
/*onSelectionChanging: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
              if (gridController!.selectedRows.isNotEmpty) {

                ///se almeno uno di quelli selezionati è chiuso, blocco la selezione
                if (addedRows.any((element) {
                  if (element is DataGridRowWithItem){
                    if (element.item is Report){
                      Status status = Status.values[element.item.status];
                       return status == Status.closed;
                    }
                  }
                  return false;
                }
                )) {
                  return false;
                }

              }
              return true;
            },*/ /*

                onSelectionChanged: (List<DataGridRow> addedRows,
                    List<DataGridRow> removedRows) {
*/
/*        print(addedRows.length.toString());
              print(removedRows.length.toString());*/ /*

                  for (DataGridRow element in gridController!.selectedRows) {
                    print((element as DataGridRowWithItem).item.toString());
                  }
                  if (kDebugMode) {
                    print(
                        'selected rows lenght: ${gridController!.selectedRows.length.toString()}');
                  }
                  updateFAB(gridController!.selectedRows);
                },

                onCellTap: (cell) {
                  onTap(cell);
                },
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,

                footer: widget.configuration.showFooter
                    ? _showFooter
                    ? Builder(builder: (context) {
                  */
/* WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {

                      Future.delayed(Duration.zero, () {
                        RenderBox box = _footerKey.currentContext!.findRenderObject() as RenderBox;
                        Offset position = box.localToGlobal(Offset.zero); //this is global position
                        double y = position.dy;
                        _verticalScrollController!.animateTo(y, duration: Duration(milliseconds: 350), curve: Curves.linearToEaseOut);
                      });
                      restoreScrollControllerPosition();
                      */ /*
 */
/*_verticalScrollController!.animateTo(
                                      _verticalScrollController!
                                          .position.maxScrollExtent,
                                      duration: const Duration(milliseconds: 350),
                                      curve: Curves.elasticInOut);*/ /*
 */
/*

                  });*/ /*

                  return Container(
                    key: _footerKey,
                    child: widget.configuration.onFooterBuild
                        ?.call(source!.effectiveRows) ??
                        const SizedBox(),
                  );
                })
                    : null //_scrollBarVisible ? const SizedBox(height: 50,) : null
                    : null,
                //_scrollBarVisible ? const SizedBox(height: 50,) : null,

                footerHeight: widget.configuration.footerHeight ??
                    49.0, //widget.configuration.footerHeight ?? (_scrollBarVisible ? 49.0 : 0.0),

                */
/*
                ///Commentato perchè il double click è necessario farlo troppo velocemente su windows
                onCellDoubleTap: (cell) {
              if (cell.rowColumnIndex.rowIndex != 0) {
                DataGridRow row =
                    source!.effectiveRows[cell.rowColumnIndex.rowIndex - 1];
                if (row is DataGridRowWithItem) {
                  openDetail(row.item);
                }
              } else {}
            },*/ /*

              )),
        ),
      ),
    );
  }

  void updateFAB(List<DataGridRow> selectedRows) {
    if (selectedRows.isNotEmpty) {
      */
/*DataGridRowWithItem last = gridController!.selectedRows.last as DataGridRowWithItem;
                gridController!.selectedIndex=last.;
                gridController!.selectedRows.add(last);*/ /*


      var row = selectedRows.last;
      if (row is DataGridRowWithItem) {
        itemToSelect = row.item;
        widget.onSelectionChanged?.call(selectedRows, itemToSelect);
      }

      if (selectedRows.length == 1) {
        _fabKey.currentState?.setStateSingle(0, true);
        _fabKey.currentState?.setStateSingle(1, true);
        _fabKey.currentState?.setStateSingle(2, true);
      } else {
        _fabKey.currentState?.setStateSingle(0, true);
        _fabKey.currentState?.setStateSingle(1, false);
        _fabKey.currentState?.setStateSingle(2, true);
      }

      //_animateToEnd();
    } else {
      itemToSelect = null;
      widget.onSelectionChanged?.call(selectedRows, itemToSelect);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //_animateToStart();
        _fabKey.currentState?.setStateSingle(0, false);
        _fabKey.currentState?.setStateSingle(1, false);
        _fabKey.currentState?.setStateSingle(2, false);

        */
/*setState(() {
          */ /*
 */
/*buttonsState.value = {
                          'showNew': true,
                          'showEdit': false,
                          'showDelete': false
                        };*/ /*
 */
/*
        });*/ /*

      });
    }
    setState(() {
      currentSelectedIndex = null;
    });
    _selectionToggleKey.currentState?.currentValue=_getCurrentSelectionText();

  }

  Widget _list(bool? offline) {
    if (gridController != null) {
      selectedGridRows = gridController?.selectedRows;
      verticalOffset = gridController?.verticalOffset ?? 0;
      horizontalOffset = gridController?.horizontalOffset ?? 0;

      gridController?.dispose();
      gridController = null;
    }

    _horizontalScrollController = null;
    _verticalScrollController = null;

    source?.sort();
    */
/*if (currentSortedColumns!=source?.sortedColumns){
      currentSortedColumns = source?.sortedColumns;

      for (int columnIndex = 0; columnIndex < widget.configuration.columns.length; columnIndex++) {
        currentSort = source?.sortedColumns.where((element) => element.name==widget.configuration.columns[columnIndex].label).toList(growable: false);
        if (currentSort!=null && currentSort!.isNotEmpty){
          currentSortIndex=columnIndex;
          break;
        }
      }
      if (currentSort!=null && currentSort!.isNotEmpty) {
        oldSortIndex=currentSortIndex;
        source?.rows.sort((DataGridRow row1, DataGridRow row2) {

          if (row1 is DataGridRowWithItem && row2 is DataGridRowWithItem) {
            String a = gato.get(
                row1.item.json, widget.configuration.columns[currentSortIndex].id)
                .toString();
            String b = gato.get(
                row2.item.json, widget.configuration.columns[currentSortIndex].id)
                .toString();
            if (currentSort!.isNotEmpty && currentSort!.first.sortDirection ==
                DataGridSortDirection.descending) {
              return b.compareTo(
                  a.toString()
              );
            } else {
              return a.compareTo(
                  b.toString()
              );
            }
          }
          return 0;
        });
      }
    }
*/ /*


    return cardItems(); */
/*Column(
      children: [
        SizedBox(height: 40,
        child: Row(children: [
          IconButton(
              onPressed:(){},
              icon: const Icon(Icons.filter),
               ),
        ],),
        ),
        Expanded(child: cardItems()),
      ],
    );*/ /*

  }

  Widget cardItems() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      color: isDarkTheme(context)
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withAlpha(240),
              Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.surface,
      child: SeparatedSettingsList(
          controller: _autoScrollTagController,
          shrinkWrap: true,
          contentPadding: EdgeInsets.zero,
          //contentPadding: EdgeInsets.zero,
          platform: DevicePlatform.web,
          automaticKeepAlive: true,
          sections: List.generate(source?.effectiveRows.length ?? 0, (index) {
            DataGridRowWithItem row =
                source?.effectiveRows[index] as DataGridRowWithItem;
            if (!listRowKeyMap.containsKey(row.item)){
                //  print("create key: ${row.item} - $index");
                  listRowKeyMap.addAll({row.item : GlobalKey(debugLabel: row.item.toString())});
                } else {
              //    print("Key ${row.item} already created!");
                }
            //print("Total keys: ${listRowKeyMap.length}");
            */
/* String content2 =
                gato.get(row.item.json, widget.configuration.columns[1].id).toString();*/ /*

            return AutoScrollTag(
              key: ValueKey(index),
              controller: _autoScrollTagController,
              index: index,
              child: DataScreenItem(
                key: listRowKeyMap[row.item]!,//ValueKey(row.item),
                onCheckedChanged: (BuildContext context, bool? newValue) {
                  if (newValue ?? false) {
                    if (!(selectedGridRows?.contains(row) ?? false)) {
                      print("add");
                      selectedGridRows?.add(row);
              */
/*        listRowKeyMap[row.item]?.currentState?.setState(() {
                        listRowKeyMap[row.item]?.currentState?.isSelected=true;
                      });*/ /*


                    } else {
                      print("row already added");
                    }
                  } else {
                    if (selectedGridRows?.contains(row) ?? false) {
                      print("remove!!");
                      selectedGridRows?.remove(row);
        */
/*              listRowKeyMap[row.item]?.currentState?.setState(() {
                        listRowKeyMap[row.item]?.currentState?.isSelected=false;
                      });*/ /*


                    } else {
                      print("row not found!!!!!!!!!!!!!!!");
                    }

                  }
                  if (selectedGridRows != null) {
                    print("update fab");
                    updateFAB(selectedGridRows!);

                    _loadAsync(false);
                  } else {
                    print("selectedGridRows==null");
                  }
                },
                onPressed: (context) {
                  selectedGridRows?.clear();
                  selectedGridRows?.add(row);
                  if (selectedGridRows != null) {
                    updateFAB(selectedGridRows!);
                  }
                },
                onDoublePressed: (context) {
                  openDetail(row.item);
                },
                columns: widget.configuration.columns,
                item: row.item,
                isSelected: selectedGridRows?.contains(row) ?? false,
              ),
            );
          })),
    );
  }

  Widget itemData(String content,
      {String? label, TextStyle? labelTextStyle, TextStyle? contentTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text("$label:",
              style: labelTextStyle ??
                  itemValueTextStyle().copyWith(fontSize: 10)),
        Text(content, style: contentTextStyle ?? itemValueTextStyle()),
      ],
    );
  }

  void onTap(cell) {
    try {
      if (cell.rowColumnIndex.columnIndex != 0 &&
          cell.rowColumnIndex.rowIndex != 0) {
        //gridController!.selectedIndex = -1;
        if (gridController!.selectedRows.length > 1 ||
            gridController!.selectedRows.contains(
                    source!.effectiveRows[cell.rowColumnIndex.rowIndex - 1]) ==
                false) {
          gridController!.selectedRows = <DataGridRow>[];
        }
        //gridController!.selectedRows.add(source!.effectiveRows[cell.rowColumnIndex.rowIndex-1]);

        //}

        if (doubleTapState.isNotEmpty) {
          //precedentemente è stata cliccata una cella...

          //gridController!.selectedRow = source!.effectiveRows[cell.rowColumnIndex.rowIndex-1];

          //trovo la chiave
          List<RowColumnIndex> keys = doubleTapState.keys
              .where((value) => value.rowIndex == cell.rowColumnIndex.rowIndex)
              .toList();

          if (keys.isNotEmpty) {
            //...la riga era uguale alla precedente

            //trovo quanto tempo è passato tra un tap e l'altro
            int elapsed = DateTime.now().millisecondsSinceEpoch -
                (doubleTapState[keys[0]] ?? 0);

            if (elapsed < 450) {
              //double tap
              if (cell.rowColumnIndex.rowIndex != 0) {
                DataGridRow row =
                    source!.effectiveRows[cell.rowColumnIndex.rowIndex - 1];
                if (row is DataGridRowWithItem) {
                  if (widget.configuration.menu.status != null &&
                      widget.configuration.menu.status == 2) {
                    openDetail(row.item);
                  }
                }
              } else {
                //riga 0, quella degli header di colonna
              }

              //double tap completato, cancello storia
              doubleTapState.clear();
            } else {
              //è passato troppo tempo, cancello tutto e reinserisco la cella
              doubleTapState.clear();
              doubleTapState.addAll(
                  {cell.rowColumnIndex: DateTime.now().millisecondsSinceEpoch});
            }
          } else {
            //cliccata una riga diversa dalla precedente
            //cancello tutto e inserisco la nuova riga
            doubleTapState.clear();
            doubleTapState.addAll(
                {cell.rowColumnIndex: DateTime.now().millisecondsSinceEpoch});
          }
        } else {
          //primo tap
          doubleTapState.addAll(
              {cell.rowColumnIndex: DateTime.now().millisecondsSinceEpoch});
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  */
/* try {
      return Stack(
        children: [
          PlutoGrid(

                //key: ValueKey(T.toString() + Random().nextInt(1000).toString()),
                columns: widget.configuration.columns!,
                rows: rows!,
                rowColorCallback: (rowColorContext) {
                  if (_stateManager != null) {
                    try {
                      T? element = adapter?.listLocale![
                          _stateManager!.rows[rowColorContext.rowIdx].sortIdx!];
                      if (element != null) {
                        Color? color = widget.rowColorCallback?.call(element);
                        return color ??
                            rowColorContext
                                .stateManager.configuration!.gridBackgroundColor;
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                  return rowColorContext.stateManager.configuration!.gridBackgroundColor;
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  try {
                    setState(() {
                      showLoadContainer=true;
                    });
                    _stateManager = event.stateManager;
                    event.stateManager.setShowColumnFilter(true);
                    event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);

                    ///auto column fit
                    for (var element in event.stateManager.columns) {
                      ///se è stato definito un callback, richiamo il callback
                      ///dal callback ci si aspetta un valore double che rappresenta la dimensione
                      ///se viene restituito null eseguo l'autofit classico
                      if (widget.onAutoFit != null) {
                        double? size = widget.onAutoFit?.call(element);
                        if (size == null) {
                          autoFitColumn(context, element);
                        } else {
                          autoFitColumnWithSize(context, element, size);
                        }
                      }
                    }

                    ///ripristino lo stato del sort dopo il reload
                    if (_stateManager!.getSortedColumn != null) {
                                    if (_stateManager!.getSortedColumn!.sort ==
                                        PlutoColumnSort.ascending) {
                                      _stateManager!.sortAscending(_stateManager!.getSortedColumn!);
                                    } else {
                                      _stateManager!.sortDescending(_stateManager!.getSortedColumn!);
                                    }
                                  }

                    _setCurrentRow();
                    // Select range by row index.
                    //widget.stateManager.setCurrentSelectingRowsByRange(0, 2);

                    _stateManager!.addListener(handleCurrentSelectionState);

                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    showLoadContainer=false;
                  });
                },
                */ /*
 */
/*onRowSecondaryTap: (PlutoGridOnRowSecondaryTapEvent event) {
                    if (event.row != null) {
                      print(event.row!.state.index);
                      var element = adapter!.listLocale![event.row!.sortIdx!];

                      openDetail(event.row, element);
                    }
                  },*/ /*
 */
/*
                onChanged: (PlutoGridOnChangedEvent event) {
                  if (kDebugMode) {
                    print(event);
                  }
                },
                onSelected: (PlutoGridOnSelectedEvent event) {
                  if (event.row != null) {
                    if (kDebugMode) {
                      print(event.row!.state.index);
                    }
                    var element = adapter!.listLocale![event.row!.sortIdx!];

                    openDetail(event.row, element);
                  }
                },
          */ /*
 */
/*      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
                  _stateManager!.setRowChecked(
                    event.row!,
                    event.row?.checked == true ? false : true,
                  );
                    if (event.row != null) {
                      print(event.row!.state.index);
                      var element = adapter!.listLocale![event.row!.sortIdx!];

                      openDetail(event.row, element);
                    }
                  },*/ /*
 */
/*
                */ /*
 */
/*onTap: (PlutoGridOnTapEvent event) {
                    print(event.cell!.value.toString());
                    if (swClickCount.isRunning && swClickCount.elapsedMilliseconds>500){
                      //troppo tardi
                      clickCount=0;
                      swClickCount.stop();
                      lastClickRow=null;
                    }
                    if (lastClickRow==null || lastClickRow!=event.row) {
                      lastClickRow=event.row;
                      clickCount=1;
                      swClickCount.reset();
                      swClickCount.start();
                    } else {
                      //doppio click
                      if (event.row != null) {
                        print(event.row!.state.index);
                        var element = adapter!.listLocale![event.row!.sortIdx!];

                        openDetail(event.row, element);
                      }
                      lastClickRow=null;
                      clickCount=0;
                      swClickCount.stop();
                    }
                  },*/ /*
 */
/*
                onRowChecked: (PlutoGridOnRowCheckedEvent event) {
                  if (_stateManager!.checkedRows.isNotEmpty) {
                    _animateToEnd();
                  } else {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _animateToStart();
                    });
                  }
                },
                configuration: PlutoGridConfigurationHelper.defaultGridConfiguration(
                    context, offline, ThemeModeHandler.of(context)!.themeMode),
                mode: PlutoGridMode.select,
              ),

          if (showLoadContainer)

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: LoadingScreen(
                color: Theme.of(context).primaryColor,
                  message: "Caricamento " +
                      widget.configuration.title!.toLowerCase()),
            ),
        ],
      );*/ /*


  */
/* int _getTrueIndex(item) {
    int trueIndex = -1;

    if (item != null) {
      //var element = adapter!.listLocale![event.row!.sortIdx!];
      int elementIndex = -1;

      for (int i = 0; i < adapter!.listLocale!.length; i++) {
        var element = adapter!.listLocale![i];
        if (element == item) {
          elementIndex = i;
          break;
        }
      }

      //trovo l'elemento tra i sortIndex
      for (int rowIdx = 0; rowIdx < _stateManager!.rows.length; rowIdx++) {
        if (_stateManager!.rows[rowIdx].sortIdx == elementIndex) {
          trueIndex = rowIdx;
        }
        //debugPrint("myIdx=$myIdx: _stateManager!.rows[$myIdx].sortIndex=${_stateManager!.rows[myIdx]?.sortIdx}");

      }
    }
    return trueIndex;
  }*/ /*

*/
/*

  _setCurrentRow() {
    ///Stampa il sortIndex do ogni index
    ///utile per debuggare la ricerca dell'item
    */ /*

*/
/*for(int myIdx=0; myIdx<_stateManager!.rows.length; myIdx++){
    debugPrint("myIdx=$myIdx: _stateManager!.rows[$myIdx].sortIndex=${_stateManager!.rows[myIdx]?.sortIdx}");

  }*/ /*
 */
/*


*/ /*

*/
/*    if (itemToSelect != null) {
      int trueIndex = _getTrueIndex(itemToSelect);

      if (trueIndex!= -1 && trueIndex < _stateManager!.rows.length){
        _stateManager!.clearCurrentCell();
        _stateManager!.setCurrentCell(
            _stateManager!.rows[trueIndex].cells.entries.first.value, trueIndex);
        */ /*
 */
/*
 */ /*

*/
/*_stateManager!.setCurrentSelectingPositionByCellKey(
      _stateManager!.rows[trueIndex]!.cells.entries.last.value.key,
    );*/ /*
 */
/*
 */ /*

*/
/*
        _stateManager!.moveScrollByRow(PlutoMoveDirection.down, trueIndex);
        //_stateManager!.setCurrentSelectingRowsByRange(index, index);
        //_stateManager!.checkedRows.add(_stateManager!.rows[index]);
      }

    }*/ /*
 */
/*

  }
*/ /*


  _animateToEnd() {
    if (controller != null && isActionsEnabled()) {
      //controller!.animateToEnd();
    }
  }

  _animateToStart() {
    if (controller != null && isActionsEnabled()) {
      //isFABOpen.value=true;
      //controller!.animateToStart();
    }
  }

  bool isActionsEnabled() {
    if (widget.configuration.menu.status == null ||
        widget.configuration.menu.status! < 2 ||
        widget.openNew == null ||
        widget.openDetail == null ||
        widget.delete == null) {
      return false;
    }
    return true;
  }

  void openDetail(T element) async {
    if (widget.openDetail != null) {
      var retValue = await widget.openDetail!.call(context, element);
      if (retValue != null) {
        update(retValue, onEvent: widget.onUpdate);
        widget.onUpdated?.call(retValue);
        itemToSelect = retValue;
        widget.onSelectionChanged
            ?.call(gridController!.selectedRows, itemToSelect);
      } else {
        itemToSelect = element;
        _loadAsync(false);
      }
      */
/*} else if (widget.openDetailForSave != null) {
      var retValue = await widget.openDetail!.call(context, row, element);
      if (retValue != null) {
        _save(retValue);
      }*/ /*

    }
    */
/*String? value =*/ /*

*/
/*    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              content: ManufacturerEditForm(
                  row: row, element: element, title: "Modifica produttore"));
        }).then((returningValue) {
      if (returningValue != null) {
        _update(returningValue);
      }
    });*/ /*

  }

  void openNew() async {
    if (widget.openNew != null) {
      var retValue = await widget.openNew!.call(context);
      if (retValue != null) {
        _add(retValue, onEvent: widget.onAdd);
        widget.onAdded?.call(retValue);
        itemToSelect = retValue;
        widget.onSelectionChanged
            ?.call(gridController!.selectedRows, itemToSelect);
      } else {
        _loadAsync(false);
      }
      */
/* } else if(widget.openNewForSave!=null){
      var retValue = await widget.openNewForSave!.call(context);
      if (retValue != null) {
        _save(retValue);
      }*/ /*

    }
  }

  _connectToMessageHub() {
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
        if (message == widget.configuration.repoName &&
            sessionId != currentSessionId) {
          //await _loadAsync();

          ScaffoldMessenger.of(context).hideCurrentSnackBar();

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
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  */
/*void messageHubCallback(List? message) {
    message?.forEach((element) async {
      if ((disableNotify == null || disableNotify == false) &&
          element == widget.configuration.repoName) {
        //await _loadAsync();

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(days: 365),
          elevation: 6,
          content: Text("I dati sono stati modificati da un altro utente"),
          action: SnackBarAction(
            label: "Ricarica",
            onPressed: () async {
              await _load();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }*/ /*


  void _detachMessageHub() {
    try {
      eventBusSubscription?.cancel();

      //messageHub!.off('ReceiveMessage', method: messageHubCallback);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    _detachMessageHub();
    //_verticalScrollController?.removeListener(handleVerticalScrollMaxExtent);
    gridController?.dispose();
    _scrollController.dispose();
    _autoScrollTagController.dispose();
    //_horizontalScrollController?.dispose();
    //_verticalScrollController?.dispose();

    */
/*   try {
      _stateManager!.removeListener(handleCurrentSelectionState);
    } catch (e) {
      print(e);
    }*/ /*

    super.dispose();
  }

  static DataScreenState of(BuildContext context) {
    final DataScreenState? result =
        context.findAncestorStateOfType<DataScreenState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'DataScreenState.of() called with a context that does not contain a Scaffold.',
      ),
      ErrorDescription(
        'No DataScreenState ancestor could be found starting from the context that was passed to DataScreenState.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the Scaffold widget being sought.',
      ),
      ErrorHint(
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
        'context that is "under" the DataScreenState. For an example of this, please see the '
        'documentation for Scaffold.of():\n'
        '  https://api.flutter.dev/flutter/material/Scaffold/of.html',
      ),
      ErrorHint(
        'A more efficient solution is to split your build function into several widgets. This '
        'introduces a new context from which you can obtain the DataScreenState. In this solution, '
        'you would have an outer widget that creates the DataScreenState populated by instances of '
        'your new inner widgets, and then in these inner widgets you would use DataScreenState.of().\n'
        'A less elegant but more expedient solution is assign a GlobalKey to the DataScreenState, '
        'then use the key.currentState property to obtain the ScaffoldState rather than '
        'using the DataScreenState.of() function.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  @override
  void didChangeDependencies() {
    */
/*print("DataScreen didChangeDependencies");
    if (_isPopupVisible && isDesktop) {
      _isPopupVisible = false;
      Navigator.of(context).maybePop();
    }*/ /*

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant DataScreen<T> oldWidget) {
    //checkScrollbarState();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void setState(VoidCallback fn) {
    */
/* _horizontalScrollController =
        ScrollController(debugLabel: 'horizontalScrollController');

    _verticalScrollController =
        ScrollController(debugLabel: 'verticalScrollController');*/ /*


    restoreScrollControllerPosition();

    super.setState(fn);
  }

  @override
  bool get wantKeepAlive => true;

  void scrollToItem(T item, {bool listSelect = true}) async {
    if (gridController != null) {
      int index = 0;
      for (var row in source!.effectiveRows) {
        if (row is DataGridRowWithItem) {
          if (row.item == item) {
            if (listSelect) {
              gridController?.selectedIndex = index;
            }
            gridController?.scrollToRow(index.toDouble(), canAnimate: true);
            //  _fabKey.currentState?.setAllState(true);
            //setState(() {});
            break;
          }
        }
        index++;
      }
    } else {
      for (int index = 0; index < source!.effectiveRows.length; index++) {
        DataGridRow row = source!.effectiveRows[index];
        if (row is DataGridRowWithItem) {
          if (row.item == item) {
            if (listSelect) {
              selectedGridRows?.clear();
              selectedGridRows?.add(row);
            }
*/
/*

            if (listRowKeyMap[row.item]?.currentContext!=null) {
              print("currentContext!=null");
             await Scrollable.ensureVisible(listRowKeyMap[row.item]!.currentContext!,
                  duration: const Duration(milliseconds: 1000), alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart);
              print("Scrollable.ensureVisible finished");
            }
*/ /*



            _autoScrollTagController.scrollToIndex(index,
                preferPosition: AutoScrollPosition.begin,
                duration: const Duration(seconds: 1));
            break;
          }
        }
      }
    }
  }

*/
/*void autoFitColumn(BuildContext context, PlutoColumn column) {
    final String maxValue =
        _stateManager!.rows.fold(column.title, (previousValue, element) {
      final value = column.formattedValueForDisplay(
        element.cells.entries
            .firstWhere((element) => element.key == column.field)
            .value
            .value,
      );

      if (previousValue.length < value.length) {
        return value;
      }

      return previousValue;
    });

    // Get size after rendering virtually
    // https://stackoverflow.com/questions/54351655/flutter-textfield-width-should-match-width-of-contained-text
    TextSpan textSpan = TextSpan(
      style: DefaultTextStyle.of(context).style,
      text: maxValue,
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    double cellPadding =
        column.cellPadding ?? _stateManager!.configuration!.defaultCellPadding;

    _stateManager!.resizeColumn(
      column,
      textPainter.width - column.width + (cellPadding * 2) + 2 + (80),
    );
  }

  void autoFitColumnWithSize(
      BuildContext context, PlutoColumn column, double size) {
    _stateManager!.resizeColumn(column, size - column.width);
  }*/ /*

}

String applyFormat(dynamic value, String format) {
  final parseValue = DateTime.tryParse('${value}Z');

  if (parseValue == null) {
    return '';
  }

  return intl.DateFormat(format).format(DateTime.parse('${value}Z').toLocal());
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
}

*/
/*
class DataScreenController<T> extends ChangeNotifier {
List<T> currentItems=<T>[];
DataGridAdapter? adapter;
List<PlutoRow>? rows;

VoidCallback reloadFunction;

DataScreenController({required this.reloadFunction});

void setItems(List<T> items){
  currentItems = items;
  notifyListeners();
}

void reload(List<T> items){
  reloadFunction.call();
}

}*/ /*


enum DataScreenColumnType {
  text,
  date,
}

class DataScreenColumnConfiguration<TList extends JsonPayload,
    TFilter extends JsonPayload> {
  final String id;
  final String label;
  final Widget Function(dynamic value, {bool? forList})? onRenderRowField;
  final Color Function(dynamic value)? onQueryRowColor;
  final Decoration Function(dynamic value)? onQueryRowDecoration;
  final Color? Function(dynamic value)? onQueryTextColor;
  final bool Function(dynamic searchValue, dynamic item)? customFilter;
  final ColumnSizerRule? customSizer;
  final EdgeInsets autoFitPadding;
  final DataScreenColumnType columnType;
  final MultiFilterType filterType;
  final dynamic defaultFilterValue;

  final LabelType labelType;

  final List Function(DataScreenColumnConfiguration col, List items)?
      getItemsForFilter;

  ///to customize selected item
  final DropdownSearchBuilderMultiSelection<dynamic>? dropdownBuilder;
  final DropdownSearchPopupItemBuilder<dynamic>? popupItemBuilder;

  ///customize the fields the be shown
  final DropdownSearchItemAsString<dynamic>? itemAsString;

  final bool allowSorting;

  DataScreenColumnConfiguration({
    required this.id,
    required this.label,
    this.defaultFilterValue,
    this.allowSorting = true,
    this.onRenderRowField,
    this.onQueryTextColor,
    this.onQueryRowDecoration,
    this.onQueryRowColor,
    this.customFilter,
    this.customSizer,
    this.autoFitPadding = const EdgeInsets.symmetric(horizontal: 6.0),
    this.columnType = DataScreenColumnType.text,
    this.filterType = MultiFilterType.containsText,
    this.itemAsString,
    this.dropdownBuilder,
    this.popupItemBuilder,
    this.getItemsForFilter,
    this.labelType = LabelType.none,
  });

  Type get elementType => TFilter;

  Type get listType => TList;
}
enum LabelType {
  itemValue,
  subItemValue,
  miniItemValue,
  none,
}*/
