import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import "package:collection/collection.dart";
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/pdf.global.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_note.dart';
import 'package:dpicenter/models/server/machine_production.dart';
import 'package:dpicenter/models/server/machine_production_picture.dart';
import 'package:dpicenter/models/server/machine_reminder.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/machine_setting_picture.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/reminder.dart';
import 'package:dpicenter/models/server/reminder_configuration.dart';
import 'package:dpicenter/models/server/vmc_production.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/machines/machine_productions_view.dart';
import 'package:dpicenter/screen/master-data/machines/machine_screen_ex.dart';
import 'package:dpicenter/screen/master-data/machines/machine_settings_view.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/master-data/vmc_production_fields/vmc_production_fields_screen.dart';
import 'package:dpicenter/screen/master-data/vmc_setting_fields/vmc_setting_fields_screen.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/useful/info_screen.dart';
import 'package:dpicenter/screen/useful/loading_screen.dart';
import 'package:dpicenter/screen/useful/loading_screen_2.dart';
import 'package:dpicenter/screen/widgets/clippy/clippy.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select.dart';
import 'package:dpicenter/screen/widgets/dashboard/pusher.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/dynamic_qr_button.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list.dart';
import 'package:dpicenter/screen/widgets/note_editor/note.dart';
import 'package:dpicenter/screen/widgets/note_editor/note_editor.dart';
import 'package:dpicenter/screen/widgets/note_editor/reminder_editor.dart';
import 'package:dpicenter/screen/widgets/print_qrcode/print_qr_options.dart';
import 'package:dpicenter/screen/master-data/machines/matricola_change_screen.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:universal_io/io.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

// Define a custom Form widget.
class MachineEditForm extends StatefulWidget {
  final Machine? element;
  final String? title;

  ///categoria di MultiSelector in cui spostarsi
  final String? selectCategory;

  ///salva direttamente senza passare l'informazione a data_screen
  final bool saveDirectly;

  const MachineEditForm(
      {Key? key,
      required this.element,
      this.title,
      this.saveDirectly = false,
      this.selectCategory})
      : super(key: key);

  @override
  MachineEditFormState createState() {
    return MachineEditFormState();
  }
}

class MachineEditFormState extends State<MachineEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey _notesSettingSectionKey =
      GlobalKey(debugLabel: '_notesSettingSectionKey');
  final GlobalKey _notesSettingTileKey =
      GlobalKey(debugLabel: '_notesSettingTileKey');
  final GlobalKey _statusSettingSectionKey =
      GlobalKey(debugLabel: '_statusSettingSectionKey');

  ///lista dei clienti tra cui selezionare (utilizzo Machine perchè mi interessano solo i clienti che hanno una macchina)
  List<Customer>? customers = <Customer>[];

  ///lista dei motivi di intervento tra cui selezionare
  List<Customer>? factories = <Customer>[];

  ///lista dei modelli disponibili
  List<Vmc>? models = <Vmc>[];

  ///item da creare/modificare
  Machine? element;

  ///cliente selezionato
  Customer? selectedCustomer;

  ///motivo intervento selezionato
  Customer? selectedFactory;

  ///modello macchina selezionato
  Vmc? selectedModel;

  List<SelectorData>? _selectorData;
  final TextEditingController _searchCustomerController =
      TextEditingController();
  final TextEditingController _searchFactoryController =
      TextEditingController();
  final TextEditingController _searchModelController = TextEditingController();

  /*late Signature _signatureCanvas;*/

  final ScrollController _scrollController =
      ScrollController(debugLabel: 'ScrollController');

  ///chiavi per i campi da compilare
  final GlobalKey<FormFieldState> _matricolaKey =
      GlobalKey<FormFieldState>(debugLabel: '_matricolaKey');
  final GlobalKey<FormFieldState> _matricolaChangeKey =
      GlobalKey<FormFieldState>(debugLabel: '_matricolaChangeKey');
  final GlobalKey<FormFieldState> _customMatricolaKey =
      GlobalKey<FormFieldState>(debugLabel: '_customMatricolaKey');

  final GlobalKey<DropdownSearchState> _modelDropDownKey =
      GlobalKey<DropdownSearchState>(debugLabel: '_modelDropDownKey');

  final GlobalKey _customerDropDownKey =
      GlobalKey(debugLabel: '_customerDropDownKey');
  final GlobalKey _factoryDropDownKey =
      GlobalKey(debugLabel: '_factoryDropDownKey');
  final GlobalKey _settingsKey = GlobalKey(debugLabel: '_settingsKey');

  final GlobalKey<DialogTitleExState> _dialogTitleKey =
      GlobalKey<DialogTitleExState>(debugLabel: '_dialogTitleKey');
  final GlobalKey _dialogNavigationKey =
      GlobalKey(debugLabel: '_dialogNavigationKey');

  ///chiavi delle tile
  final GlobalKey _customMatricolaSettingTileKey =
      GlobalKey(debugLabel: '_customMatricolaSettingTileKey');
  final GlobalKey _matricolaSettingTileKey =
      GlobalKey(debugLabel: '_matricolaTileKey');
  final GlobalKey _modelSettingTileKey = GlobalKey(debugLabel: '_modelTileKey');
  final GlobalKey _qrCodeSettingTileKey =
      GlobalKey(debugLabel: '_qrCodeSettingTileKey');

  late List<KeyValidationState> _keyStates;

  final Map<String, GlobalKey> categoryKeysMap = <String, GlobalKey>{};
  final List<MapSettingKey> categorySettingsList = <MapSettingKey>[];

  final Map<String, GlobalKey> categoryProductionsKeysMap =
      <String, GlobalKey>{};
  final List<MapProductionKey> categoryProductionsList = <MapProductionKey>[];

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  late TextEditingController _matricolaChangeController =
      TextEditingController();
  late TextEditingController _matricolaController = TextEditingController();
  late TextEditingController _customMatricolaController =
      TextEditingController();

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');

  List<MachineSetting> selectableSettings = <MachineSetting>[];
  List<MachineSetting> selectedSettings = <MachineSetting>[];
  List<MachineProduction> selectableProductions = <MachineProduction>[];
  List<MachineProduction> selectedProductions = <MachineProduction>[];

  List<MachineNote> currentNotes = <MachineNote>[];

  List<SettingsScrollSection> settingsSections = <SettingsScrollSection>[];
  List<SettingsScrollSection> productionsSections = <SettingsScrollSection>[];

  ///stato della barra di navigazione
  int statNavStatus = -1;

  ///scorre alla posizione di toNavStatus e poi viene impostato statNavStatus
  int toNavStatus = -1;

  final Map<GlobalKey, RenderBox> _boxes = <GlobalKey, RenderBox>{};
  final GlobalKey<MultiSelectorExState> _multiSelectorKey =
      GlobalKey<MultiSelectorExState>(debugLabel: '_multiSelectorKey');

  MapSettingKey? _selectedMapSettingKey;
  final TextEditingController _searchFieldsController = TextEditingController();

  bool reloadModelSettings = false;
  bool reloadModelProductions = false;

  String title = "";
  bool _settingsPanelIsExpanded = false;
  bool _productionsPanelIsExpanded = false;

  Timer? _matricolaSearchTimer;
  bool _matricolaAlreadyExist = false;
  bool _matricolaCheckPending = false;

  Timer? _customMatricolaSearchTimer;
  bool _customMatricolaAlreadyExist = false;
  bool _customMatricolaCheckPending = false;

  final GlobalKey _assignSectionKey =
      GlobalKey(debugLabel: "_assignSectionKey");
  final GlobalKey _textInputSectionKey =
      GlobalKey(debugLabel: "_textInputSectionKey");
  final GlobalKey _operationsSectionKey =
      GlobalKey(debugLabel: "_reminderSectionKey");
  final GlobalKey _reminderSectionKey =
      GlobalKey(debugLabel: "_operationsSectionKey");
  final GlobalKey _settingsSectionKey =
      GlobalKey(debugLabel: "_settingsSectionKey");
  late Map<String, GlobalKey>? firstHeaderSectionsMap;
  final GlobalKey _productionSectionKey =
      GlobalKey(debugLabel: "_productionSectionKey");

  final ScrollController _multiSelectorScrollController =
      ScrollController(debugLabel: '_multiSelectorScrollController');

  int currentStato = 0;

  ui.Image? qrImage;

  ///promemoria attuali
  List<MachineReminder> _currentReminders = <MachineReminder>[];

  final ScrollController reminderListScrollController =
      ScrollController(debugLabel: 'reminderListScrollController');
  final ScrollController noteListScrollController =
      ScrollController(debugLabel: 'noteListScrollController');

  @override
  void initState() {
    super.initState();

    title = widget.title ?? "";
    initKeys();
    firstHeaderSectionsMap = {
      'Dati generali': _textInputSectionKey,
      'Assegnazione': _assignSectionKey,
      'Impostazioni': _settingsSectionKey,
      'Produzione': _productionSectionKey,
      'Operazioni': _operationsSectionKey,
      'Promemoria': _reminderSectionKey,
      'Note': _notesSettingSectionKey,
    };

/*
    ///impostazione guida
    Clippy.of(context).schedule = {
      _matricolaSettingTileKey: Positioned(
          width: 100,
          height: 40,
          child: ElevatedButton(
              onPressed: () => Clippy.of(context).page = 1,
              child: const Center(child: Text('PAGE 0')))),
      _customMatricolaSettingTileKey: Positioned(
          width: 100,
          height: 40,
          child: ElevatedButton(
              onPressed: () => Clippy.of(context).page = 2,
              child: const Center(child: Text('PAGE 1')))),
      _modelSettingTileKey: Positioned(
          width: 100,
          height: 40,
          child: ElevatedButton(
              onPressed: () => Clippy.of(context).page = 3,
              child: const Center(child: Text('PAGE 2')))),
      _qrCodeSettingTileKey: Positioned(
          width: 100,
          height: 40,
          child: ElevatedButton(
              onPressed: () => Clippy.of(context).currentState = 0,
              child: const Center(child: Text('PAGE 3')))),
    };
*/

    ///creo una copia dell'elemento in modo da poter annullare le modifiche
    ///in caso l'utente decida di non salvare
    try {
      element = widget.element?.copyWith();
      currentStato = element?.stato ?? 0;
      currentStato = element?.stato ?? 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (kDebugMode) {
      print(element.hashCode.toString());
    }
    if (element == null) {
      _matricolaController = TextEditingController();
      _customMatricolaController = TextEditingController();
      reloadModelSettings = true;
      reloadModelProductions = true;
      _loadVmcSettings(-1);
      _loadVmcProductions(-1);
    } else {
      _matricolaController = TextEditingController(text: element!.matricola);
      _customMatricolaController =
          TextEditingController(text: element!.machineId);
      selectedCustomer = element!.customer;
      selectedFactory = element!.stabilimento;
      selectedModel = element!.vmc;
      if (element!.machineSettings != null &&
          element!.machineSettings!.isNotEmpty) {
        selectedSettings = element!.machineSettings!;
        reloadModelSettings = false;
      } else {
        reloadModelSettings = true;
      }
      if (element!.machineProductions != null &&
          element!.machineProductions!.isNotEmpty) {
        selectedProductions = element!.machineProductions!;
        reloadModelProductions = false;
      } else {
        reloadModelProductions = true;
      }

      if (element!.machineReminders != null) {
        _currentReminders = element!.machineReminders!;
        _currentReminders
            .sort((a, b) => a.position?.compareTo(b.position ?? 0) ?? 0);
      }

      if (element!.machineNotes != null) {
        currentNotes = element!.machineNotes!;
      }

      if (element!.vmc != null) {
        Future.delayed(const Duration(milliseconds: 50), () {
          _loadVmcSettings(element!.vmc!.vmcId);
        });
      }

      if (element!.vmc != null) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _loadVmcProductions(element!.vmc!.vmcId);
        });
      }
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      _loadCustomers();
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      _loadModels();
    });

    /*   Future.delayed(const Duration(milliseconds: 400), () {
      _loadVmcCategories();
    });*/

    _scrollController.addListener(scrollListener);
    _updateStato();

    if (widget.selectCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (_multiSelectorKey.currentState != null) {
          for (int index = 0;
              index < _multiSelectorKey.currentState!.selectorData.length;
              index++) {
            SelectorData data =
                _multiSelectorKey.currentState!.selectorData[index];
            if (data.periodString == widget.selectCategory!) {
              toNavStatus = index;
              await _scrollToCurrentNavStatus();
              _multiSelectorKey.currentState?.setState(() {
                _multiSelectorKey.currentState?.status = index;
              });
              break;
            }
          }
        }
      });
    }
  }

  _loadVmcSettings(int vmcId) {
    _boxes.clear();
    var bloc = BlocProvider.of<ServerDataBloc<VmcSetting>>(context);
    bloc.add(ServerDataEvent<VmcSetting>(
        status: ServerDataEvents.fetch,
        queryModel: QueryModel(id: vmcId.toString())));
  }

  _loadVmcProductions(int vmcId) {
    var bloc = BlocProvider.of<ServerDataBloc<VmcProduction>>(context);
    bloc.add(ServerDataEvent<VmcProduction>(
        status: ServerDataEvents.fetch,
        queryModel: QueryModel(id: vmcId.toString())));
  }

  /*_loadVmcCategories() {
    var bloc = BlocProvider.of<ServerDataBloc<VmcSetting>>(context);
    bloc.add(const ServerDataEvent<VmcSetting>(status: ServerDataEvents.fetch));
  }*/

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _matricolaKey),
      KeyValidationState(key: _matricolaChangeKey),
      KeyValidationState(key: _customMatricolaKey),
      KeyValidationState(key: _modelDropDownKey),
      KeyValidationState(key: _customerDropDownKey),
      KeyValidationState(key: _factoryDropDownKey),
      KeyValidationState(key: _settingsKey),
    ];
  }

  /*_formatDate(){
    Future.sync(() => initializeDateFormatting(Intl.defaultLocale!, null));
    selectedFormattedDate = DateFormat.yMMMMd().format(selectedDate);
  }*/
  _loadCustomers() {
    var bloc = BlocProvider.of<ServerDataBloc<Customer>>(context);
    bloc.add(const ServerDataEvent<Customer>(status: ServerDataEvents.fetch));
  }

  _loadModels() {
    var bloc = BlocProvider.of<ServerDataBloc<Vmc>>(context);
    bloc.add(const ServerDataEvent<Vmc>(status: ServerDataEvents.fetch));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  static Widget getStatusBadge(BuildContext context, int currentStatus) {
    return Material(
      type: MaterialType.card,
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(20),
      elevation: 8,
      shadowColor: Colors.black87,
      child: Container(
          decoration: BoxDecoration(
              color: getStatusColor(currentStatus),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              getStatusText(currentStatus),
              style: TextStyle(
                  color: getStatusColor(currentStatus).computeLuminance() > 0.5
                      ? Colors.black87
                      : Colors.white70),
            ),
          )),
    );
  }

  Widget mainWidget({Widget? loadingScreen}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        DialogTitleEx(
          null,
          key: _dialogTitleKey,
          subTitleWidget:
              isLittleWidth() ? getStatusBadge(context, currentStato) : null,
          titleAlignment: CrossAxisAlignment.start,
          trailingChild: loadingScreen == null
              ? (isLittleWidth()
                  ? _popupCategoryButton()
                  : getStatusBadge(context, currentStato))
              : null,
        ),
        Expanded(
          child: Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  constraints: BoxConstraints(
                      maxWidth: 1200,
                      maxHeight: MediaQuery.of(context).size.height > 700
                          ? MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).size.height / 3)
                          : MediaQuery.of(context).size.height),
                  child: loadingScreen ?? _mainLayout()
                  /*AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child:
                        MediaQuery.of(context).size.width<=800 ?
                    _horizontalLayout() :
                        _verticalLayout()
                  )*/

                  )),
        ),
        if (loadingScreen == null)
          OkCancel(
              okFocusNode: _saveFocusNode,
              onCancel: () async {
                Navigator.maybePop(context, null);
              },
              onSave: () async {
                validateSave();
              })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ///form contenente i dati da compilare
    return FocusScope(
        child: BlocListener<ServerDataBloc<Machine>, ServerDataState<Machine>>(
            listener: (BuildContext context, ServerDataState state) {
      if (state is ServerDataUpdated) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Future.delayed(const Duration(milliseconds: 2000),
              () => Navigator.pop(context, element));
        });
      }
      /*if (state is ServerDataLoaded) {
              if (state.items != null && state.items is List<VmcSetting>) {
                List<VmcSetting> items = state.items as List<VmcSetting>;

                createSelectableSettings(items);
              }
            }*/
    }, child: BlocBuilder<ServerDataBloc<Machine>, ServerDataState<Machine>>(
                builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.update:
          if (state is ServerDataUpdated) {
            /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Future.delayed(const Duration(milliseconds: 500), ()=> Navigator.pop(context, element));

            });*/
            return mainWidget();
          }
          if (state is ServerDataError) {
            final error = state.error;
            String message = '${error.message}';
            String event = state.event?.status.toString() ?? '';
            return mainWidget(
              loadingScreen: InfoScreen(
                message: 'Errore durante $event',
                errorMessage: message,
                //emoticonText: !kIsWeb ? '(╯°□°）╯︵ ┻━┻' : '💔',
                image: Image
                    .asset(angryImage)
                    .image,
                onPressed: () {
                  //print("error screen onPressed");
                  //reload();
                },
              ),
            );
          }
          return mainWidget(
              loadingScreen: const LoadingScreen2(
            message: 'Salvataggio in corso...',
          ));
        default:
          break;
      }
      return mainWidget();
    })));
  }

  Widget _popupCategoryButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: const CircleBorder(),
        type: MaterialType.transparency,
        child: PopupMenuButton(
          elevation: 0,
          icon: Icon(
            Icons.more_vert,
            color: ((isDarkTheme(context)
                            ? Color.alphaBlend(
                                Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withAlpha(240),
                                Theme.of(context).colorScheme.primary)
                            : Theme.of(context).colorScheme.surface))
                        .computeLuminance() >
                    0.5
                ? Colors.black87
                : Colors.white70,
          ),
          color: Colors.transparent,
          position: PopupMenuPosition.under,
          tooltip: 'Categorie',
          constraints: const BoxConstraints(maxWidth: 1500),
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          itemBuilder: (BuildContext context) => List.generate(
            1,
            (index) => PopupMenuItem(
                value: index,
                enabled: false,
                child: MultiBlocProvider(
                  providers: [
                    ///passo il bloc provider ServerDataBloc<VmcSetting> di questa schermata al popup
                    BlocProvider.value(
                      value:
                          BlocProvider.of<ServerDataBloc<VmcSetting>>(context),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<ServerDataBloc<VmcProduction>>(
                          context),
                    ),
                  ],
                  child: _categorySelector(),
                )

                /*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/
                ),
          ),
        ),
      ),
    );
  }

  bool isLittleWidth() => MediaQuery.of(context).size.width <= 800;

  /*Widget _horizontalLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DialogTitleEx(key: _dialogTitleKey, title),
        SingleChildScrollView(
          key: _dialogNavigationKey,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IntrinsicWidth(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _multiSelectorWidget(),
                      ),
                      IntrinsicWidth(
                        child: _fieldsDropDown(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: _settingsScrollBlocWidget(),
          */ /*SettingsScroll(
                          darkTheme: SettingsThemeData(
                            settingsListBackground: isDarkTheme(context)
                                ? Color.alphaBlend(
                                    Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withAlpha(240),
                                    Theme.of(context).colorScheme.primary)
                                : Theme.of(context).colorScheme.surface,
                          ),
                          lightTheme: const SettingsThemeData(
                              settingsListBackground: Colors.transparent),
                          //contentPadding: EdgeInsets.zero,
                          platform: DevicePlatform.web,
                          sections: [
                            _textInputSection(),
                            _assignSection(),
                            if (element != null && element!.matricola != "")
                              _operationsSection(),
                            _settingsSection(),
                            _settingsBlocWidget(),
                          ],
                        )*/ /*
        ),
        const SizedBox(height: 20),
      ],
    );
  }*/

  Widget _mainLayout() {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: _settingsScroll(),
                  ),
                  const SizedBox(height: 20),
                ]),
          ),
          if (!isLittleWidth()) _categorySelector(),
        ]);
  }

  Widget _settingsScroll() {
    return SettingsScroll(
      controller: _scrollController,
      darkTheme: getSettingsDarkTheme(context),
      lightTheme: getSettingsLightTheme(context),
      // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      //contentPadding: EdgeInsets.zero,
      platform: DevicePlatform.web,
      sections: [
        _textInputSection(),
        if (currentStato >= 1) _assignSection(),
        if (currentStato >= 2) settingsSectionWithBloc(),
        if (currentStato >= 2) productionSectionWithBloc(),
        if (element != null && currentStato >= 2) _operationsSection(),
        _reminderSection(),
        _notesSection(),
        //_statusSection(),
      ],
    );
  }

/*  Widget settingsSectionBloc(){
    return
      BlocListener<ServerDataBloc<VmcSetting>,
          ServerDataState<VmcSetting>>(
          listener: (BuildContext context, ServerDataState state) {
            if (state is ServerDataLoaded) {
              if (state.items != null && state.items is List<VmcSetting>) {
                List<VmcSetting> items = state.items as List<VmcSetting>;

                createSelectableSettings(items);
              }
            }
          },
          child: BlocBuilder<ServerDataBloc<VmcSetting>,
              ServerDataState<VmcSetting>>(
              builder: (BuildContext context, ServerDataState state) {
                switch (state.event!.status) {
                  case ServerDataEvents.fetch:
                    if (state is ServerDataInitState) {
                      return shimmerComboLoading(context);
                    }
                    if (state is ServerDataLoading) {
                      return shimmerComboLoading(context);
                    }
                    if (state is ServerDataLoaded) {
                      return   settingsSection();
                    }
                    if (state is ServerDataError) {
                      return const Text("Errore Caricamento");
                    }
                    break;
                  default:
                    break;
                }
                return const Text("Stato sconosciuto");
              }));
  }*/
  Widget productionSectionWithBloc() {
    return SettingsScrollSection(
        title: const Text("Produzione"), tiles: [productionSectionTileBloc()]);
  }

  Widget settingsSectionTileBloc() {
    return BlocListener<ServerDataBloc<VmcSetting>,
            ServerDataState<VmcSetting>>(
        listener: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded) {
        if (state.items != null && state.items is List<VmcSetting>) {
          List<VmcSetting> items = state.items as List<VmcSetting>;

          createSelectableSettings(items);
        }
      }
    }, child: BlocBuilder<ServerDataBloc<VmcSetting>,
                ServerDataState<VmcSetting>>(
            builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            return getCustomSettingTile(
                key: _settingsSectionKey,
                onPressed: (context) async {
                  List<MachineSetting> machineSettingCopy = selectedSettings
                      .map((e) => e.copyWith(
                          images: e.images
                              ?.map((e) => e.copyWith())
                              .toList(growable: false)))
                      .toList(growable: false);
                  Machine? machineCopy =
                      element?.copyWith(machineSettings: machineSettingCopy);
                  element = machineCopy;
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return multiDialog(
                            content:
                                BlocProvider<ServerDataBloc<VmcProduction>>(
                                    create: (BuildContext context) =>
                                        ServerDataBloc<VmcProduction>(
                                            repo: MultiService<VmcProduction>(
                                                VmcProduction.fromJsonModel,
                                                apiName: 'VmcProduction')),
                                    child: MachineSettingsView(
                                      title:
                                          "${_matricolaController.text} - ${selectedFactory?.description ?? ''}",
                                      machine: element,
                                      machineSettings: selectedSettings,
                                      savePressed: () {
                                        editState = true;
                                        return true;
                                      },
                                    )));
                      }).then((value) {
                    if (value != null) {
                      setState(() {
                        selectedSettings = value;
                        element = element?.copyWith(machineSettings: value);
                      });
                    } else {
                      setState(() {
                        selectedSettings = machineSettingCopy;
                        element = machineCopy;
                      });
                    }
                  });

                  setState(() {});
                },
                child: const Text("Seleziona per vedere le impostazioni"),
                title: "Impostazioni macchina",
                hint: "Com'è impostata la macchina",
                description:
                    "Com'è impostata la macchina, il server ed eventuali altre impostazioni");
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    }));
  }

  Widget productionSectionTileBloc() {
    return BlocListener<ServerDataBloc<VmcProduction>,
            ServerDataState<VmcProduction>>(
        listener: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded) {
        if (state.items != null && state.items is List<VmcProduction>) {
          List<VmcProduction> items = state.items as List<VmcProduction>;

          createSelectableProductions(items);
        }
      }
    }, child: BlocBuilder<ServerDataBloc<VmcProduction>,
                ServerDataState<VmcProduction>>(
            builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            return productionSectionTile();
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    }));
  }

  Widget _categorySelector() {
    return SizedBox(
      width: 330,
      child: SingleChildScrollView(
          controller: _multiSelectorScrollController,
          key: _dialogNavigationKey,
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                /*  _fieldsDropDown(),
                const SizedBox(
                  height: 16,
                ),*/
                Padding(
                  padding: getPadding(),
                  child: _multiSelector(),
                ),
              ],
            ),
          )),
    );
  }

  Widget _multiSelector() {
    _selectorData = _getSelectorData(direction: Axis.vertical);
    return MultiSelectorEx(
      direction: Axis.vertical,
      key: _multiSelectorKey,
      onPressed: (index) async {
        if (isLittleWidth()) {
          if (!mounted) return;
          Navigator.of(context).pop();
        }

        toNavStatus = index;
        //statNavStatus = index;
        /*setState(() {
                        statNavStatus = index;
                    });*/
        await _scrollToCurrentNavStatus(); //_scrollToCurrentStatus();
        statNavStatus = index;
        _multiSelectorKey.currentState?.setState(() {
          _multiSelectorKey.currentState?.status = statNavStatus;
        });

        //widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
      },
      status: statNavStatus,
      selectorData: _selectorData!,
    );
  }

  bool _checkCategoryKey(String key) {
    switch (key) {
      case 'Assegnazione':
        return currentStato >= 1;
      case 'Impostazioni':
        return currentStato >= 2;
      case 'Produzione':
        return currentStato >= 2;
      case 'Operazioni':
        return currentStato >= 2 && element != null;

      default:
        return true;
    }
  }

  Map<String, GlobalKey> _getMapIndexKey() {
    Map<String, GlobalKey> mapIndexKey = {};

    firstHeaderSectionsMap?.forEach((key, value) {
      if (_checkCategoryKey(key)) {
        mapIndexKey.addAll({key: value});
      }
    });

    mapIndexKey.addAll(categoryKeysMap);
    return mapIndexKey;
  }

  Future _scrollToCurrentNavStatus() async {
    GlobalKey? key;

    Map<String, GlobalKey> mapIndexKey = _getMapIndexKey();

    if (toNavStatus >= 0 && toNavStatus < mapIndexKey.entries.length) {
      key = mapIndexKey.entries.elementAt(toNavStatus).value;
      if (key.currentContext != null) {
        await Scrollable.ensureVisible(key.currentContext!,
            duration: const Duration(milliseconds: 500));
      }
    }

    /*if (toNavStatus >= 0) {
      if (toNavStatus >= (firstHeaderSectionsMap?.length ?? 0)) {
        int index = toNavStatus - (firstHeaderSectionsMap?.length ?? 0);
        key = categoryKeysMap.entries.elementAt(index).value;
      } else {
        key = firstHeaderSectionsMap?.entries.elementAt(toNavStatus).value;
      }
      if (key != null) {
        await Scrollable.ensureVisible(key.currentContext!,
            duration: const Duration(milliseconds: 500));
      }
    }*/
  }

  Future scrollTo(RenderObject renderObj) async {
    // _mainScrollController.removeListener(scrollListener);
    await _scrollController.position.ensureVisible(renderObj,
        alignment: 0.0,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOut,
        targetRenderObject: renderObj,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
    // _mainScrollController.addListener(scrollListener);
  }

  List<SelectorData> _getSelectorData({Axis direction = Axis.horizontal}) {
    /* Map mapSettings = selectedSettings.groupBy((p0) => p0.categoryName);
    Map mapProductions = selectedProductions.groupBy((p0) => p0.categoryName);
*/
    List<SelectorData> result = <SelectorData>[];

    firstHeaderSectionsMap?.forEach((key, value) {
      if (_checkCategoryKey(key)) {
        result.add(getSelectorDataItem(
            text: key,
            direction: direction,
            color:
                Theme.of(context).colorScheme.primaryContainer.withAlpha(150)));
      }
    });

/*    if (_settingsPanelIsExpanded) {
      for (var element in mapSettings.keys) {
        result.add(getSelectorDataItem(
            text: element,
            direction: direction,
            color: Color(int.parse(selectedSettings
                    .firstWhere((selSet) => selSet.categoryName == element)
                    .categoryColor!))
                .withAlpha(150)));
      }*/
/*      List<SelectorData> subItems = <SelectorData>[];

      for (var element in mapSettings.keys) {
        subItems.add(getSelectorDataItem(
            text: element,
            direction: direction,
            color: Color(int.parse(selectedSettings
                .firstWhere((selSet) => selSet.categoryName == element)
                .categoryColor!))
                .withAlpha(150)));
      }
      SelectorData last = result[result.length-1];
      result[result.length-1] = SelectorData(periodString: last.periodString, selectedColor: last.selectedColor, dataChildren: subItems, child: last.child,);
    }*/
    /*secondHeaderSectionsMap?.forEach((key, value) {
      if ((key != 'Produzione' || currentStato > 1)) {
        result.add(getSelectorDataItem(
            text: key,
            direction: direction,
            color:
            Theme
                .of(context)
                .colorScheme
                .primaryContainer
                .withAlpha(150)));
      }
    });*/

/*    if (_productionsPanelIsExpanded ) {
      for (var element in mapProductions.keys) {
        result.add(getSelectorDataItem(
            text: element,
            direction: direction,
            color: Color(int.parse(selectableProductions
                    .firstWhere((selSet) => selSet.categoryName == element)
                    .categoryColor!))
                .withAlpha(150)));
      }
    }*/
    return result;
  }

  SelectorData getSelectorDataItem({
    required String text,
    Axis direction = Axis.horizontal,
    required Color color,
  }) {
    return SelectorData(
        periodString: text,
        selectedColor: color,
        child: Container(
          constraints: direction == Axis.horizontal
              ? null
              : const BoxConstraints(maxHeight: 50, minWidth: 290),
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            /*  const SizedBox(width: 8),
                    const Icon(Icons.category),*/
            const SizedBox(width: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: direction == Axis.horizontal
                  ? Text(text,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(letterSpacing: 0, wordSpacing: 0))
                  : Text(text, style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(width: 8),
          ]),
        ));
  }

  ///se esiste, aggiungo alle chiavi da navigare la chiave e il box relativo
  void addToBoxes(GlobalKey key) {
    if (!_boxes.containsKey(key)) {
      var box = key.currentContext?.findRenderObject();
      if (box != null && box is RenderBox) {
        _boxes.addAll({key: box});
      }
    }
  }

  Map? categoriesMap;

  void scrollListener() {
    categoriesMap = selectedSettings.groupBy((p0) => p0.categoryName);

    bool isNavigationOnTop = MediaQuery.of(context).size.width <= 800;

    Map<String, GlobalKey> mapIndexKey = _getMapIndexKey();

    ///se esistono, aggiungo alle chiavi da navigare i relativi boxes
    _boxes.clear();
    for (var item in mapIndexKey.keys) {
      addToBoxes(mapIndexKey[item]!);
    }

    int index = -1;
    int nCycle = 0;

    double dy =
        0; //(_reportStatBlocKey.currentContext!.findRenderObject()! as RenderBox).localToGlobal(Offset.zero).dy + (_isTinyWidth() ? 66 : 0);

    RenderBox? currentBox = context.findRenderObject() as RenderBox?;
    Offset mainBoxOffset =
        currentBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    RenderBox? currentDialogTitleBox =
        _dialogTitleKey.currentContext?.findRenderObject() as RenderBox?;
    Offset currentDialogTitleBoxOffset =
        currentDialogTitleBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    RenderBox? currentDialogNavigationBox =
        _dialogNavigationKey.currentContext?.findRenderObject() as RenderBox?;

    Offset currentDialogNavigationBoxOffset =
        currentDialogNavigationBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    //print("Dy: $dy");
    //print("mainBoxOffset.dy: ${mainBoxOffset.dy+4}");
    dy = (mainBoxOffset.dy +
        currentDialogTitleBoxOffset.dy +
        (currentDialogTitleBox?.size.height ?? 0) +
        (isNavigationOnTop
            ? (currentDialogNavigationBox?.size.height ?? 0)
            : 0));

    for (MapEntry entry in _boxes.entries) {
      if ((entry.value.localToGlobal(Offset.zero).dy - dy) < 10) {
        index = nCycle;
      } else {
        if (nCycle == 0) {
          if ((entry.value.localToGlobal(Offset.zero).dy - dy) > 100) {
            index = -1;
          }
        }
      }
      nCycle++;
    }

    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent) {
      title = "${widget.title ?? ''} - ${mapIndexKey.keys.elementAt(0)}";
      _setTitle(title);
    } else if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      title = "${widget.title ?? ''} - ${mapIndexKey.keys.last}";
      _setTitle(title);
    } else {
      if (index == -1) {
        if (title != (widget.title ?? '')) {
          title = widget.title ?? '';
          _setTitle(title);
        }
      } else {
        if (index < mapIndexKey.length) {
          if (index < mapIndexKey.keys.length) {
            int localIndex = index - firstHeaderSectionsMap!.length;
            String desiredTitle = "";
            if (localIndex < 0 || localIndex >= categoriesMap!.length) {
              desiredTitle =
                  "${widget.title ?? ''} - ${mapIndexKey.keys.elementAt(index)}";
            } else {
              desiredTitle =
                  "${widget.title ?? ''} - ${categoriesMap!.keys.elementAt(localIndex)}";
            }
            if (title != desiredTitle) {
              title = desiredTitle;
              _setTitle(title);
            }
          }
        }
      }
    }

    if (statNavStatus != index) {
      statNavStatus = index;

      if (index != -1) {
        if (_multiSelectorKey.currentState?.mounted ?? false) {
          _multiSelectorKey.currentState?.setState(() {
            _multiSelectorKey.currentState?.status = index;
          });
        }
      }
    }
  }

  void _setTitle(String title) {
    if (_dialogTitleKey.currentState?.mounted ?? false) {
      _dialogTitleKey.currentState?.setState(() {
        _dialogTitleKey.currentState?.title = title;
      });
    }
  }

  Widget _retirePanel() {
    return BlocBuilder<ServerDataBloc<Customer>, ServerDataState<Customer>>(
        builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            customers = state.items as List<Customer>;

            var multitechCustomer =
                customers?.firstWhere((element) => element.code == 'S0025MT');
            if (multitechCustomer != null) {
              return _panelContainer(
                [
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (validateForRetire()) {
                              if (await retireMachineMessage()) {
                                selectedSettings = selectableSettings
                                    .map((e) => e.copyWith(
                                        matricola:
                                            _matricolaController.value.text))
                                    .toList(growable: false);
                                selectedProductions = selectableProductions
                                    .map((e) => e.copyWith(
                                        matricola:
                                            _matricolaController.value.text))
                                    .toList(growable: false);

                                ///metto machineProductions e machineSettings a null
                                ///e poi imposto il valore. Impostare direttamente il valore non funzionava,
                                ///manteneva quello vecchio, forse è un problema che ha a che fare con Equatable <--- Era proprio cosi
                                ///ho modificato ulteriormente per salvare la Machine in un unico copyWith

                                Machine? newElement = element?.copyWith(
                                  machineId:
                                      _customMatricolaController.value.text,
                                  matricola: _matricolaController.value.text,
                                  customerId: multitechCustomer.customerId,
                                  stabId: multitechCustomer.customerId,
                                  vmcId: selectedModel?.vmcId,
                                  stato: 0,
                                  machineProductions: selectedProductions,
                                  machineSettings: selectedSettings,
                                );
                                /*        newElement = newElement?.copyWith(
                                  machineProductions: selectedProductions,
                                  machineSettings: selectedSettings,
                                );*/
                                editState = false;
                                setState(() {
                                  currentStato = 6;
                                  _updateStato();
                                });
                                if (mounted) {
                                  Navigator.pop(context, newElement);
                                }
                              }
                            }
                          },
                          child: const Text("RITIRA")),
                    ),
                  ),
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "RITIRA LA MACCHINA E LA SPOSTA IN MULTI-TECH",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                  )
                ],
              );
            }
            return const SizedBox();
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    });

    ///trovo la multitech tra i clienti
  }

  bool validateForRetire() {
    if (_customMatricolaKey.currentState != null) {
      if (_customMatricolaKey.currentState!.validate()) {
        if (_customMatricolaController.text.trim().isNotEmpty) {}
        return true;
      }
    }
    return false;
  }

  Future<bool> retireMachineMessage() async {
    BuildContext context = navigatorKey!.currentContext!;
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          title: 'Ritiro macchina',
          message: 'Ritirare la macchina e spostarla in Multi-Tech?',
          type: MessageDialogType.yesNo,
          yesText: 'RITIRA',
          noText: 'NON RITIRARE',
          okPressed: () {
            Navigator.pop(context, true);
          },
          noPressed: () {
            Navigator.pop(context, false);
          },
        );
      },
    ).then((value) async {
      return value;
//return value
    });
    return result;
  }

  Future<bool> scrapMachineMessage() async {
    BuildContext context = navigatorKey!.currentContext!;
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          title: 'Rottamare macchina',
          message: 'Rottamare la macchina?',
          type: MessageDialogType.yesNo,
          yesText: 'ROTTAMA',
          noText: 'NON ROTTAMARE',
          okPressed: () {
            Navigator.pop(context, true);
          },
          noPressed: () {
            Navigator.pop(context, false);
          },
        );
      },
    ).then((value) async {
      return value;
//return value
    });
    return result;
  }

  Future<bool> installedMachineMessage() async {
    BuildContext context = navigatorKey!.currentContext!;
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          title: 'Installare macchina',
          message: 'Considerare la macchina come installata?',
          type: MessageDialogType.yesNo,
          yesText: 'INSTALLATA',
          noText: 'NON INSTALLATA',
          okPressed: () {
            Navigator.pop(context, true);
          },
          noPressed: () {
            Navigator.pop(context, false);
          },
        );
      },
    ).then((value) async {
      return value;
//return value
    });
    return result;
  }

  Future<bool> inPreparationMachineMessage() async {
    BuildContext context = navigatorKey!.currentContext!;
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          title: 'Preparazione macchina',
          message: 'Considerare la macchina come in preparazione?',
          type: MessageDialogType.yesNo,
          yesText: 'PREPARAZIONE',
          noText: 'NON IN PREPARAZIONE',
          okPressed: () {
            Navigator.pop(context, true);
          },
          noPressed: () {
            Navigator.pop(context, false);
          },
        );
      },
    ).then((value) async {
      return value;
//return value
    });
    return result;
  }

  Widget _panelContainer(List<Widget> children) {
    if (isTinyWidth(context)) {
      return Row(children: children);
    } else {
      return Row(children: children);
    }
  }

  Widget _scrapPanel() {
    return _panelContainer([
      SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () async {
                if (await scrapMachineMessage()) {
                  setState(() {
                    currentStato = 7;
                    _updateStato();
                  });
                }
              },
              child: const Text("ROTTAMA")),
        ),
      ),
      const Flexible(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("ROTTAMA LA MACCHINA",
              overflow: TextOverflow.ellipsis, maxLines: 4),
        ),
      )
    ]);
  }

  Widget _setInstalledPanel() {
    return _panelContainer([
      SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () async {
                if (await installedMachineMessage()) {
                  setState(() {
                    currentStato = 5;
                    _updateStato();
                  });
                }
              },
              child: const Text("INSTALLATA")),
        ),
      ),
      const Flexible(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("SEGNA LA MACCHINA COME INSTALLATA",
              overflow: TextOverflow.ellipsis, maxLines: 4),
        ),
      )
    ]);
  }

  Widget _setInPreparationPanel() {
    return _panelContainer([
      SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () async {
                if (await inPreparationMachineMessage()) {
                  setState(() {
                    currentStato = 3;
                    _updateStato();
                  });
                }
              },
              child: const Text("PREPARAZIONE")),
        ),
      ),
      const Flexible(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("SEGNA LA MACCHINA COME IN PREPARAZIONE",
              overflow: TextOverflow.ellipsis, maxLines: 4),
        ),
      )
    ]);
  }

  SettingsScrollSection _textInputSection() {
    return SettingsScrollSection(
      key: _textInputSectionKey,
      title: const Text(
        'Dati generali',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _matricolaSettingTile(),
        _customMatricolaSettingTile(),
        _modelSettingTile(),
        _qrCodeSettingTile(),
      ],
    );
  }

  SettingsScrollSection _textInputSection2() {
    return SettingsScrollSection(
      title: const Text(
        'Dati generali',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _matricolaSettingTile2(),
      ],
    );
  }

  SettingsScrollSection _assignSection() {
    return SettingsScrollSection(
      key: _assignSectionKey,
      title: const Text(
        'Assegnazione',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _customerSettingTile(),
        _factorySettingTile(),
      ],
    );
  }

/*  SettingsScrollSection _statusSection() {
    return SettingsScrollSection(
      key: _statusSettingSectionKey,
      title: const Text(
        'Stato',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _statusSettingTile(),
      ],
    );
  }*/

  SettingsScrollSection _operationsSection() {
    return SettingsScrollSection(
      key: _operationsSectionKey,
      title: const Text(
        'Operazioni',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _retireSettingTile(),
        _scrapSettingTile(),
        _setInstalledSettingTile(),
        _setInPreparationSettingTile(),
      ],
    );
  }

  SettingsScrollSection _reminderSection() {
    return SettingsScrollSection(
      key: _reminderSectionKey,
      title: const Text(
        'Promemoria',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _reminderSettingTile(),
      ],
    );
  }

/*  SettingsTile _reminderSettingTile() {
    return getCustomSettingTile(
        title: 'Promemoria',
        hint: 'Promemoria',
        description: 'Lista di promemoria relativi alla macchina',
        child: _reminderPanel());
  }*/
  SettingsTile _reminderSettingTile() {
    return _getRemindersSettingTile(
        // key: _notesSettingTileKey,
        title: 'Promemoria',
        hint: 'Promemoria',
        description: 'Lista di promemoria relativi alla macchina.',
        icon: const Icon(Icons.notes));
  }

  SettingsTile _getRemindersSettingTile(
      {String? title,
      String? description,
      required Icon icon,
      String? hint,
      Key? key}) {
    return getCustomSettingTile(
      key: key,
      onPressed: null,
      icon: icon,
      title: title ?? '',
      hint: hint,
      description: description,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReorderableWrap(
            controller: reminderListScrollController,
            spacing: 8,
            runSpacing: 8,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                editState = true;
                //SampleItemNote noteOld = _currentNotes[oldIndex];
                /*SampleItemNote noteNew = _currentNotes[newIndex];*/
                MachineReminder? noteOld = _currentReminders.removeAt(oldIndex);
                _currentReminders.insert(newIndex, noteOld);
                /*for (int index=0; index<)
                _currentNotes[newIndex] = noteOld;
                _currentNotes[oldIndex] = noteNew;*/

                //configuration = configuration!.copyWith(notes: _currentNotes);
              });
            },
            children: [
              ...List.generate(_currentReminders.length, (index) {
                return Note.fromReminder(
                  _currentReminders[index]?.reminder ??
                      const Reminder(reminderId: 0),
                  context,
                  onTap: () async {
                    ///modifica nota
                    Reminder? reminder = await addEditReminderDialog(
                        machineReminder: _currentReminders[index]);

                    if (reminder != null) {
                      setState(() {
                        editState = true;
                        if (_currentReminders[index] != null) {
                          _currentReminders[index] = _currentReminders[index]!
                              .copyWith(reminder: reminder);
                        }
                        /*configuration =
                            configuration!.copyWith(notes: _currentNotes);*/
                      });
                    }
                  },
                  onRemove: () async {
                    //if (_currentReminders[index] != null) {
                    bool result = await requestRemoveConfirmation(
                        _currentReminders[index]!
                            .reminder
                            ?.reminderConfiguration
                            ?.text ??
                            '');

                    if (result) {
                      editState = true;
                      setState(() {
                        _currentReminders.removeAt(index);
                      });
                    }
                    //}
                  },
                );
              }),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 80,
            child: Align(
              alignment: Alignment.center,
              child: FloatingActionButton(
                  onPressed: () async {
                    Reminder? note = await addEditReminderDialog();
                    if (note != null) {
                      setState(() {
                        editState = true;
                        _currentReminders.add(MachineReminder(
                            machineReminderId: 0, reminder: note));
                        /*configuration =
                            configuration!.copyWith(notes: _currentNotes);*/
                      });
                    }
                  },
                  child: const Icon(Icons.add)),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> requestRemoveConfirmation(String noteText) async {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Rimozione nota',
            message: 'Nota selezionata:\r\n$noteText\r\nRimuovere questa nota?',
            type: MessageDialogType.yesNo,
            yesText: 'SI',
            noText: 'NO',
            okPressed: () {
              Navigator.pop(context, true);
            },
            noPressed: () {
              Navigator.pop(context, false);
            });
      },
    ).then((value) async {
      return value;
      //return value
    });

    result ??= false;
    return result;
  }

  Future<Reminder?> addEditReminderDialog(
      {MachineReminder? machineReminder}) async {
    Reminder? result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return multiDialog(
              content: ReminderEditor(
            element: machineReminder?.reminder,
            title: 'Promemoria',
          ));
        }).then((returningValue) {
      return returningValue;
    });

    return result;
  }

  Future<ReminderConfiguration?> addEditNoteDialog(
      {MachineNote? machineNote}) async {
    ReminderConfiguration? result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return multiDialog(
              content: NoteEditor(
            note: machineNote?.noteConfiguration,
          ));
        }).then((returningValue) {
      return returningValue;
    });

    return result;
  }

  SettingsScrollSection _settingsOptionsSection() {
    return SettingsScrollSection(
      //key: _settingsSectionKey,
      title: const Text(
        'Caricamento impostazioni da file excel',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _loadSettingTile(),
      ],
    );
  }

  SettingsScrollSection _notesSection() {
    return SettingsScrollSection(
      key: _notesSettingSectionKey,
      title: const Text(
        'Note',
        //  style: Theme.of(context).textTheme.bodyLarge,
      ),
      tiles: <SettingsTile>[
        _notesSettingTile(),
      ],
    );
  }

  SettingsTile _notesSettingTile() {
    return _getNotesSettingTile(
        key: _notesSettingTileKey,
        title: 'Note',
        hint: 'Note',
        description:
            'Inserisci eventuali note per ricordare cose importanti relative alla macchina',
        icon: const Icon(Icons.notes));
  }

  SettingsTile _getNotesSettingTile(
      {String? title,
      String? description,
      required Icon icon,
      String? hint,
      Key? key}) {
    return getCustomSettingTile(
      key: key,
      onPressed: null,
      icon: icon,
      title: title ?? '',
      hint: hint,
      description: description,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReorderableWrap(
            controller: noteListScrollController,
            spacing: 8,
            runSpacing: 8,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                MachineNote noteOld = currentNotes.removeAt(oldIndex);
                currentNotes.insert(newIndex, noteOld);
                editState = true;
              });
            },
            children: [
              ...List.generate(currentNotes.length, (index) {
                return Note.fromMachineNote(
                  currentNotes[index],
                  context,
                  onTap: () async {
                    ///modifica nota
                    ReminderConfiguration? note = await addEditNoteDialog(
                        machineNote: currentNotes[index]);

                    if (note != null) {
                      editState = true;
                      setState(() {
                        currentNotes[index] = currentNotes[index]
                            .copyWith(noteConfiguration: note);
                      });
                    }
                  },
                  onRemove: () async {
                    bool result = await requestRemoveConfirmation(
                        currentNotes[index].noteConfiguration?.text ?? '');

                    if (result) {
                      setState(() {
                        editState = true;
                        currentNotes.removeAt(index);
                      });
                    }
                  },
                );
              }),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 80,
            child: Align(
              alignment: Alignment.center,
              child: FloatingActionButton(
                  onPressed: () async {
                    ReminderConfiguration? note = await addEditNoteDialog();
                    if (note != null) {
                      setState(() {
                        editState = true;
                        /*_currentNotes.add(SampleItemNote(
                            text:
                                'Nota aggiunta tramite il pulsante + in fondo alla lista, esattamente in questo momento: ${DateTime.now().toString()}'));*/
                        currentNotes.add(MachineNote(
                            machineNoteId: 0,
                            reminderConfigurationId: 0,
                            noteConfiguration: note));
                      });
                    }
                  },
                  child: const Icon(Icons.add)),
            ),
          )
        ],
      ),
    );
  }

  SettingsTile _generateSettingTile() {
    return getCustomSettingTile(
        title: 'Crea impostazioni',
        hint: 'Crea impostazioni',
        description: 'Crea le impostazioni da compilare per questo modello',
        child: _generateButton());
  }

  SettingsTile _loadSettingTile() {
    return getCustomSettingTile(
        title: 'Carica impostazioni',
        hint: 'Carica impostazioni da file Excel',
        description: 'Carica impostazioni da file Excel',
        child: _loadButton());
  }

  SettingsTile _retireSettingTile() {
    return getCustomSettingTile(
        title: 'Ritira macchina',
        hint: 'Ritira macchina',
        description: 'Ritira la macchina e la sposta in Multi-Tech',
        child: _retirePanel());
  }

  SettingsTile _scrapSettingTile() {
    return getCustomSettingTile(
        title: 'Rottama macchina',
        hint: 'Rottama macchina',
        description: 'Rottama la macchina',
        child: _scrapPanel());
  }

  SettingsTile _setInstalledSettingTile() {
    return getCustomSettingTile(
        title: 'Imposta come installata',
        hint: 'Imposta come installata',
        description: 'Considera la macchina installata presso cliente',
        child: _setInstalledPanel());
  }

  SettingsTile _setInPreparationSettingTile() {
    return getCustomSettingTile(
        title: 'Imposta come in preparazione',
        hint: 'Imposta la macchina come in preparazione',
        description: 'Considera la macchina in preparazione',
        child: _setInPreparationPanel());
  }

  SettingsTile _matricolaSettingTile() {
    return getCustomSettingTile(
        key: _matricolaSettingTileKey,
        title: 'Inserisci matricola',
        hint: 'Matricola',
        description:
            'Matricola univoca del produttore che identifica la macchina',
        child: _matricolaField());
  }

  SettingsTile _matricolaSettingTile2() {
    return getCustomSettingTile(
        title: 'Inserisci matricola',
        hint: 'Matricola',
        description:
            'Matricola univoca del produttore che identifica la macchina',
        child: _matricolaField2());
  }

  SettingsTile _customMatricolaSettingTile() {
    return getCustomSettingTile(
      key: _customMatricolaSettingTileKey,
      title: 'Inserisci matricola Multi-Tech',
      hint: 'Matricola Multi-Tech',
/*      onPressed: (context) {
        Clippy.of(context).page = 0;
        Clippy.of(context).currentState = 1;
      },*/
      description: 'Matricola interna a Multi-Tech che identifica la macchina',
      child: _customMatricolaField(),
    );
  }

  SettingsTile _qrCodeSettingTile() {
    return getCustomSettingTile(
        key: _qrCodeSettingTileKey,
        title: 'QR Code',
        hint: 'Identifica la macchina',
        description:
            'Utilizzare il qr code per ricercare la macchina.\r\nClicca sul qr code per ottenere un immagine stampabile.',
        child: _qrCodeField());
  }

  SettingsTile _modelSettingTile() {
    return getCustomSettingTile(
      key: _modelSettingTileKey,
      title: 'Modello',
      hint: 'Modello',
      description: 'Seleziona modello macchina',
      child: _modelDropDown(),
    );
  }

  SettingsTile _customerSettingTile() {
    return getCustomSettingTile(
        title: 'Seleziona cliente',
        hint: 'Cliente',
        description: 'Seleziona cliente da associare alla macchina',
        child: _customerDropDown());
  }

/*  SettingsTile _statusSettingTile() {
    return getCustomSettingTile(
        title: 'Stato macchina',
        hint: 'Stato macchina',
        description: 'In che stato si trova la macchina',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 200,
                  child: Text(getStatusText(currentStato)),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStato = 5;
                        _updateStato();
                      });
                    },
                    child: Text("Segna come installata")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStato = 3;
                        _updateStato();
                      });
                    },
                    child: Text("Segna come in preparazione")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStato = 6;
                        _updateStato();
                      });
                    },
                    child: Text("Segna come in multi-tech")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStato = 7;
                        _updateStato();
                      });
                    },
                    child: Text("Segna come rottamata")),
              ],
            ),
          ],
        ));
  }*/

  SettingsTile _factorySettingTile() {
    return getCustomSettingTile(
        title: 'Seleziona stabilimento',
        hint: 'Stabilimento',
        description:
            'Seleziona stabilimento da associare alla macchina. Rappresenta lo stabilimento in cui effettivamente si trova la macchina.',
        child: _factoryDropDown());
  }

/*  SettingsTile _settingSettingTile(MachineSetting item) {
    return getCustomSettingTile(
        title: item.name,
        hint: item.name,
        description: item.description,
        child: _settingWidget(item));
  }*/

  SettingsTile _settingSettingTile(MachineSetting item) {
    switch (item.type) {
      case 6:

      ///double input
        break;
      case 5:

      ///int input
        break;
      case 4:

      ///check box
        List<String> valuesToSelect = <String>[];

        if (item.params != null) {
          valuesToSelect = item.params!.split('|');
        }

        return getSwitchSettingTile(
            key: categorySettingsList
                .firstWhereOrNull(
                    (element) => element.fieldId == item.vmcSettingFieldId)
                ?.key,
            title: item.name ?? '',
            description: item.description,
            icon: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _editMachineSetting(item)),
            initialValue: valuesToSelect.isEmpty
                ? item.value.toLowerCase() == "vero"
                    ? true
                    : false
                : item.value.toLowerCase() == valuesToSelect[0].toLowerCase()
                    ? true
                    : false,
            textWhenTrue: valuesToSelect.isEmpty ? 'Vero' : valuesToSelect[0],
            textWhenFalse: valuesToSelect.isEmpty ? 'Falso' : valuesToSelect[1],
            onToggle: (value) {
              for (int index = 0; index < selectedSettings.length; index++) {
                if (selectedSettings[index].vmcSettingFieldId ==
                    item.vmcSettingFieldId) {
                  setState(() {
                    String trueString = 'Vero';
                    String falseString = 'Falso';
                    if (valuesToSelect.isNotEmpty) {
                      trueString = valuesToSelect[0];
                      falseString = valuesToSelect[1];
                    }
                    selectedSettings[index] = selectedSettings[index]
                        .copyWith(value: value ? trueString : falseString);
                  });
                  break;
                }
              }
            },
            defaultTextColor: isDarkTheme(context)
                ? darkTileDescriptionTextColor
                : lightTileDescriptionTextColor);

      case 3:

      ///Image
        break;
      case 2:

      ///UpDown

        List<String> valuesToSelect = <String>[];
        if (item.params != null) {
          ///min|max|step|fractionDigits
          valuesToSelect = item.params!.split('|');
        }
        return getUpDownSettingTile(
          key: categorySettingsList
              .firstWhereOrNull(
                  (element) => element.fieldId == item.vmcSettingFieldId)
              ?.key,
          title: item.name ?? '',
          hint: item.name ?? '',
          description: item.description,
          initialValue: item.value.isEmpty ? "0" : item.value,
          quarterTurns: 0,
          icon: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _editMachineSetting(item)),
          min: valuesToSelect.isEmpty ? 0 : double.parse(valuesToSelect[0]),
          step: valuesToSelect.isEmpty ? 1 : double.parse(valuesToSelect[2]),
          max: valuesToSelect.isEmpty ? 1000 : double.parse(valuesToSelect[1]),
          onResult: (String? result) {
            if (result != null) {
              for (int index = 0; index < selectedSettings.length; index++) {
                if (selectedSettings[index].vmcSettingFieldId ==
                    item.vmcSettingFieldId) {
                  setState(() {
                    selectedSettings[index] = selectedSettings[index].copyWith(
                        value: double.parse(result).toStringAsFixed(
                            valuesToSelect.isEmpty
                                ? 0
                                : int.parse(valuesToSelect[3])));
                  });
                  break;
                }
              }
            }
          },
        );
        break;
      case 1:

      ///Selection

        if (item.params != null) {
          List<String> valuesToSelect = <String>[];
          valuesToSelect = item.params!.split('|');
          return getSelectionSettingTile(
            key: categorySettingsList
                .firstWhereOrNull(
                    (element) => element.fieldId == item.vmcSettingFieldId)
                ?.key,
            title: item.name,
            hint: item.name,
            description: item.description,
            icon: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _editMachineSetting(item)),
            initialValue: item.value.isEmpty ? '' : item.value,
            children: [
              ...valuesToSelect.map((e) {
                return SimpleDialogOption(
                    onPressed: () {
                      for (int index = 0;
                          index < selectedSettings.length;
                          index++) {
                        if (selectedSettings[index].vmcSettingFieldId ==
                            item.vmcSettingFieldId) {
                          setState(() {
                            selectedSettings[index] =
                                selectedSettings[index].copyWith(value: e);
                          });
                          break;
                        }
                      }

                      if (!mounted) return;
                      Navigator.of(context).maybePop();
                    },
                    //
                    child: Row(
                      children: [
                        /*type.toIcon(),
                      const SizedBox(
                      width: 8,
                      ),*/
                        Text(e),
                      ],
                    ));
              })
            ],
          );
        }
        break;
      case 0:
      default:

    ///TextInput

        return getTextInputSettingTile(
          key: categorySettingsList
              .firstWhereOrNull(
                  (element) => element.fieldId == item.vmcSettingFieldId)
              ?.key,
          title: item.name,
          hint: item.name,
          description: item.description,
          onResult: (String? result) {
            if (result != null) {
              for (int index = 0; index < selectedSettings.length; index++) {
                if (selectedSettings[index].vmcSettingFieldId ==
                    item.vmcSettingFieldId) {
                  setState(() {
                    selectedSettings[index] =
                        selectedSettings[index].copyWith(value: result);
                  });
                  break;
                }
              }
            }
          },
          initialValue: item.value.isEmpty ? '' : item.value,
          icon: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _editMachineSetting(item)),
        );
    }
    return getCustomSettingTile(child: const Text('Errore'));
  }

  _editMachineSetting(MachineSetting item) async {
    dynamic editedItem = await VmcSettingFieldsActions.openDetail(
        context, VmcSettingField.fromMachineSetting(item));

    if (editedItem is VmcSettingField) {
      for (int index = 0; index < selectedSettings.length; index++) {
        MachineSetting candidateItem = selectedSettings.elementAt(index);
        if (candidateItem.machineSettingId == item.machineSettingId) {
          MachineSetting editedSetting =
              MachineSetting.fromVmcSettingField(editedItem).copyWith(
                  machine: item.machine,
                  vmcSettingFieldId: item.vmcSettingFieldId,
                  vmcSettingId: item.vmcSettingId,
                  value: item.value,
                  machineSettingId: item.machineSettingId,
                  matricola: item.matricola);
          editedSetting = editedSetting.copyWith(json: editedSetting.toJson());
          setState(() {
            selectedSettings[index] = editedSetting;
          });
          break;
        }
      }
    }
  }

  _editProductionSetting(MachineProduction item) async {
    dynamic editedItem = await VmcProductionFieldsActions.openDetail(
        context, VmcProductionField.fromMachineProduction(item));

    if (editedItem is VmcProductionField) {
      for (int index = 0; index < selectedProductions.length; index++) {
        MachineProduction candidateItem = selectedProductions.elementAt(index);
        if (candidateItem.machineProductionId == item.machineProductionId) {
          MachineProduction editedSetting =
              MachineProduction.fromVmcProductionField(
                      editedItem,
                      ApplicationUser.getUserFromSetting()?.applicationUserId,
                      ApplicationUser.getUserFromSetting())
                  .copyWith(
                      machine: item.machine,
                      vmcProductionFieldId: item.vmcProductionFieldId,
                      vmcProductionId: item.vmcProductionId,
                      value: item.value,
                      machineProductionId: item.machineProductionId,
                      matricola: item.matricola);
          editedSetting = editedSetting.copyWith(json: editedSetting.toJson());
          setState(() {
            selectedProductions[index] = editedSetting;
          });
          break;
        }
      }
    }
  }

  Widget _matricolaTextFormField(GlobalKey key,
      {bool readOnly = false,
      TextEditingController? controller,
      bool includeThisMatricola = false}) {
    return TextFormField(
      key: key,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLength: 50,
      onChanged: (value) {
        bool makeCheck = false;
        if (includeThisMatricola) {
          makeCheck = true;
        } else {
          if (value != element?.matricola) {
            makeCheck = true;
          }
        }

        if (makeCheck) {
          _matricolaSearchTimer?.cancel();
          if (value.isNotEmpty) {
            _matricolaCheckPending = true;
            print("Value to check: $value");
            _matricolaSearchTimer =
                Timer(const Duration(milliseconds: 500), () async {
              bool newValue = await _doesMatricolaAlreadyExist(value);
              _matricolaCheckPending = false;

              setState(() {
                _matricolaAlreadyExist = newValue;
              });
            });
          } else {
            setState(() {
              _matricolaAlreadyExist = false;
            });
          }
        }

        setState(() {
          _updateStato();
        });

        editState = true;
      },
      decoration: InputDecoration(
        enabled: true,
        //enabledBorder: OutlineInputBorder(),
        border: const OutlineInputBorder(),
        labelText: 'Matricola',
        hintText: 'Inserisci matricola della macchina',
        suffixIcon: (controller?.text.isNotEmpty ?? false)
            ? IconButton(
                onPressed: () {
                  setState(() {
                    Pasteboard.writeText(controller?.text ?? '');
                  });
                },
                icon: const Icon(
                  Icons.copy,
                  size: 16,
                ),
              )
            : null,
      ),
      validator: (str) {
        if (str!.isEmpty) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == key);
          _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: false);
          return "Campo obbligatorio";
        } else if (_matricolaAlreadyExist) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == key);
          _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: false);
          return "Matricola già utilizzata";
        } else {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == key);
          _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
        }
        return null;
      },
    );
  }

  Widget _matricolaField() {
    return Padding(
      padding: getPadding(),
      child: Column(
        children: [
          _matricolaTextFormField(
            _matricolaKey,
            readOnly: !isEnabled(),
            controller: _matricolaController,
          ),
          if (!isEnabled()) const SizedBox(height: 8),
          if (!isEnabled())
            TextButton(
                onPressed: () async {
                  _matricolaChangeController.text = _matricolaController.text;
                  var result = await showPusher(
                      context,
                      Pusher(
                          command: (BuildContext context) {},
                          child: MultiBlocProvider(
                              providers: [
                                BlocProvider<ServerDataBloc<Machine>>(
                                  lazy: false,
                                  create: (context) => ServerDataBloc<Machine>(
                                      repo: MultiService<Machine>(
                                          Machine.fromJsonModel,
                                          apiName: 'VMMachine')),
                                ),
                              ],
                              child: MatricolaChange(
                                  currentMatricola:
                                      _matricolaController.text))));
                  if (result != null && result is List<Machine>) {
                    setState(() {
                      _matricolaController.text = result[0].matricola ?? '';
                      element = result[0];
                    });
                  }
                },
                child: const Text("Cambia matricola")),
        ],
      ),
    );
  }

  /*bool _matricolaAlreadyExist = false;
  checkMatricola<bool>(String matricola) async {

    return await _doesMatricolaAlreadyExist(matricola);

    _doesMatricolaAlreadyExist(matricola).then((val){
      if(val){
        print ("Matricola Already Exits");
        _matricolaAlreadyExist = val;
      }
      else{
        print ("Matricola is Available");
        _matricolaAlreadyExist = val;
      }
    });
    return _matricolaAlreadyExist;
  }
*/
  Future<bool> _doesMatricolaAlreadyExist(String matricola) async {
    MultiService<Machine> service =
        MultiService<Machine>(Machine.fromJson, apiName: "VMMachine");

    List<Machine>? result = await service.get(QueryModel(id: matricola));

    ///ritorno vero se la lista non è vuota
    return result?.isNotEmpty ?? false;
  }

  Future<bool> _doesCustomMatricolaAlreadyExist(String matricola) async {
    MultiService<Machine> service =
        MultiService<Machine>(Machine.fromJson, apiName: "VMMachine");

    List<Machine>? result =
        await service.get(QueryModel(id: matricola, fieldName: 'MachineId'));

    ///ritorno vero se la lista non è vuota
    return result?.isNotEmpty ?? false;
  }

  Widget _matricolaField2() {
    return Padding(
      padding: getPadding(),
      child: TextFormField(
        enabled: isEnabled(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _matricolaController,
        maxLength: 50,
        onChanged: (value) => editState = true,
        decoration: const InputDecoration(
          //enabledBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
          labelText: 'Matricola',
          hintText: 'Inserisci matricola della macchina',
        ),
        validator: (str) {
          if (str!.isEmpty) {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _matricolaKey);
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _matricolaKey);
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
      ),
    );
  }

  Widget _generateButton() {
    return Padding(
      padding: getPadding(),
      child: ElevatedButton(
        child: const Text("Genera"),
        onPressed: () {
          setState(() {
            //selectedSettings = selectableSettings;
            if (selectedModel != null) {
              Future.delayed(const Duration(milliseconds: 0), () {
                _loadVmcSettings(selectedModel!.vmcId);
              });
            }
          });
        },
      ),
    );
  }

  Widget _loadButton() {
    return Padding(
      padding: getPadding(),
      child: ElevatedButton(
        child: const Text("Carica"),
        onPressed: () {
          _loadFileExcel(context);
        },
      ),
    );
  }

  _loadFileExcel(BuildContext context) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      allowedExtensions: ["xls", "xlsx"],
      type: FileType.custom,
    );
    if (file != null) {
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
              title: 'Importazione parametri',
              message: 'Importare i parametri delle macchine da un file excel?',
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
      ).then((value) async {
        return value;
        //return value
      });
      if (result is String) {
        if (result == "0") {
          Uint8List? bytes;
          if (file.files[0].bytes != null) {
            bytes = file.files[0].bytes!;
          } else {
            File fileToRead = File(file.files[0].path!);
            bytes = fileToRead.readAsBytesSync();
          }

          if (bytes != null) {
            int result = await _importExcelFile(bytes);
          }
        }
      }
    }
  }

  Future<int> _importExcelFile(Uint8List bytes) async {
    try {
      List<String> notImported = <String>[];
      Map<String, List<MachineSetting>> categoriesMap =
          selectedSettings.groupBy((p0) => p0.categoryName!);

      var excel = Excel.decodeBytes(bytes);
      String currentCategory = "";

      for (var table in excel.tables.keys) {
        print(table); //sheet Name
        print(excel.tables[table]?.maxCols);
        print(excel.tables[table]?.maxRows);
        for (var row in excel.tables[table]!.rows) {
          String? currentAValue;

          if (row.isNotEmpty) {
            if (row.elementAt(0) != null) {
              currentAValue = row.elementAt(0)!.value;

              dynamic currentBValue;
              if (row.length > 1) {
                currentBValue = row.elementAt(1)?.value.toString();
              }
              debugPrint("currentAValue: ${currentAValue}");

              if (categoriesMap.keys.firstWhereOrNull((element) =>
                      element.toLowerCase() == currentAValue!.toLowerCase()) !=
                  null) {
                currentCategory = currentAValue!;
              } else {
                if (currentCategory.isNotEmpty) {
                  ///sono all'interno di una categoria specifica
                  if (currentBValue != null) {
                    ///ci sono dati nella cella dei valori
                    for (int index = 0;
                        index < selectedSettings.length;
                        index++) {
                      if (selectedSettings[index].name!.toLowerCase() ==
                              currentAValue!.toLowerCase() &&
                          selectedSettings[index].categoryName!.toLowerCase() ==
                              currentCategory.toLowerCase()) {
                        ///c'è un impostazione con lo stesso nome e categoria di quella del file excel
                        setState(() {
                          ///esegui l'aggiornamento dell'importazione
                          selectedSettings[index] = selectedSettings[index]
                              .copyWith(value: currentBValue);
                        });
                        break;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
      return 1;
    }
    return 0;
  }

  EdgeInsets getPadding() {
    return const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
  }

  Widget _customMatricolaField() {
    return Padding(
      padding: getPadding(),
      child: TextFormField(
        enabled: true,
        //!isClosed(),
        //isEnabled(),
        key: _customMatricolaKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _customMatricolaController,
        maxLength: 50,
        onChanged: (value) {
          if (value != element?.machineId) {
            _customMatricolaSearchTimer?.cancel();
            if (value.isNotEmpty) {
              _customMatricolaCheckPending = true;
              print("Value to check: $value");
              _customMatricolaSearchTimer =
                  Timer(const Duration(milliseconds: 500), () async {
                bool newValue = await _doesCustomMatricolaAlreadyExist(value);
                _customMatricolaCheckPending = false;

                setState(() {
                  _customMatricolaAlreadyExist = newValue;
                });
              });
            } else {
              setState(() {
                _customMatricolaAlreadyExist = false;
              });
            }
          } else {
            setState(() {
              _customMatricolaAlreadyExist = false;
            });
          }
          setState(() {
            _updateStato();
          });

          editState = true;
        },
        decoration: InputDecoration(
          //enabledBorder: OutlineInputBorder(),
          border: const OutlineInputBorder(),
          labelText: 'Matricola Multi-Tech',
          hintText: 'Inserisci matricola Multi-Tech della macchina',
          suffixIcon: _customMatricolaController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      Pasteboard.writeText(_customMatricolaController.text);
                    });
                  },
                  icon: const Icon(
                    Icons.copy,
                    size: 16,
                  ),
                )
              : null,
        ),
        validator: (str) {
          if (str!.isEmpty) {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _customMatricolaKey);
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else if (_customMatricolaAlreadyExist) {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _customMatricolaKey);
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Matricola Multi-Tech già utilizzata";
          } else {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _customMatricolaKey);
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
      ),
    );
  }

  /* Widget _qrFromCode(String code, {required Color eyeColor, required Color moduleColor, String? title}) {
    return
      FutureBuilder<ui.Image>(
      future: getUiImage('graphics/triangle.png', 40, 40),
      builder: (ctx, snapshot) {
        double size = 200.0;
        if (!snapshot.hasData) {
          return SizedBox(width: size, height: size);
        }
        return Padding(
            padding: getPadding(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomPaint(
                      size: Size.square(size),
                      painter: QrPainter(
                        data: code,
                        version: QrVersions.auto,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: eyeColor,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: moduleColor,
                        ),
                        // size: 320.0,
                        embeddedImage: snapshot.data,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size.square(40),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    ByteData? image = await QrPainter(
                      data: code,
                      version: QrVersions.auto,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle,
                        color: Colors.black.withAlpha(200),
                      ),
                      // size: 320.0,
                      embeddedImage: snapshot.data,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size.square(40),
                        color: Colors.green.withAlpha(100),
                      ),
                    ).toImageData(220);

                    if (image != null) {
                      var pngBytes = image.buffer.asUint8List();
                      String newPath = 'qr.png';
                      if (!kIsWeb) {
                        var tempDir = await getTemporaryDirectory();
                        String tempPath = tempDir.path;
                        newPath = "$tempPath${Platform.pathSeparator}qr.png";
                        saveFile(newPath, pngBytes);
                      } else {}
                      openFilepath(newPath, bytes: pngBytes);
                    }
                  },
                ),
                if (title != null) Text(title),
              ],
            ));
      },
    );
  }
*/
  /*QrPaint qrPainterFromCode(){
    QrPainter(
      data: code,
      version: QrVersions.auto,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle,
        color: Colors.black.withAlpha(200),
      ),
      // size: 320.0,
      embeddedImage: snapshot.data,
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: const Size.square(40),
        color: Colors.green.withAlpha(100),
      ),
    )
  }*/
  Widget _qrCodeField() {
    return Padding(
      padding: getPadding(),
      child: Column(
        children: [
          MediaQuery.of(context).size.width <= 1000
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      DynamicQrButton(
                          code: "${_customMatricolaController.text}#STATE",
                          label: 'Stato produzione',
                          eyeColor: Theme.of(context).colorScheme.primary,
                          moduleColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(150)),
                      DynamicQrButton(
                          code: "${_customMatricolaController.text}#SETTINGS",
                          label: 'Impostazioni',
                          eyeColor: Theme.of(context).colorScheme.primary,
                          moduleColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(150)),
                    ])
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      DynamicQrButton(
                          code: "${_customMatricolaController.text}#STATE",
                          label: 'Stato produzione',
                          eyeColor: Theme.of(context).colorScheme.primary,
                          moduleColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(150)),
                      DynamicQrButton(
                          code: "${_customMatricolaController.text}#SETTINGS",
                          label: 'Impostazioni',
                          eyeColor: Theme.of(context).colorScheme.primary,
                          moduleColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(150)),
                    ]),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: () async {
                await showPrintOptions();
                /*Uint8List qr1 =
                    (await DynamicQrButtonState.imageToPrintFromCode(
                        "${_customMatricolaController.text}#STATE"))!;
                Uint8List qr2 =
                    (await DynamicQrButtonState.imageToPrintFromCode(
                        "${_customMatricolaController.text}#SETTINGS"))!;

                var pdf = await createQrCodePdf(qr1, qr2,
                    label1: 'Stato produzione', label2: 'Impostazioni');

                Uint8List bytes = await pdf.save();
                String newPath = '';

                if (!kIsWeb) {
                  var tempDir = await getTemporaryDirectory();
                  String tempPath = tempDir.path;
                  newPath = "$tempPath${Platform.pathSeparator}qr.pdf";
                  saveFile(newPath, bytes);
                } else {}
                openFilepath(newPath, bytes: bytes);*/
              },
              child: const Text('Stampa')),
        ],
      ),
    );
  }

  dynamic showPrintOptions() async {
    List<QrInfo> images = <QrInfo>[];
    Uint8List qr1 = (await DynamicQrButtonState.imageToPrintFromCode(
        "${_customMatricolaController.text}#STATE"))!;
    Uint8List qr2 = (await DynamicQrButtonState.imageToPrintFromCode(
        "${_customMatricolaController.text}#SETTINGS"))!;
    images.add(QrInfo(qrImage: qr1, label: 'Stato produzione'));
    images.add(QrInfo(qrImage: qr2, label: 'Impostazioni'));
    if (mounted) {
      var result = await showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return multiDialog(
                content: PrintQrOptions(
              qrImages: images,
            ));
          }).then((returningValue) {
        return returningValue;
      });

      return result;
    }
  }

  Future<bool> waitMatricolaCheck() async {
    while (_matricolaCheckPending) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return false;
  }

  Future<bool> waitCustomMatricolaCheck() async {
    while (_customMatricolaCheckPending) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return false;
  }

  validateSave() async {
    await waitMatricolaCheck();
    await waitCustomMatricolaCheck();

    ///validazione
    if (_formKey.currentState!.validate()) {
      ///salvataggio
      if (_save()) {
        editState = false;

        ///chiudo e passo al chiamante il risultato solo se non ho richiesto il salvataggio diretto
        if (!widget.saveDirectly) {
          if (mounted) {
            Navigator.pop(context, element);
          }
        }
      } else {
        debugPrint("MachineEditScreen: Salvataggio non riuscito");
      }
    } else {
      /*Scrollable.ensureVisible(servicesKey.currentContext,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeOut);*/
      try {
        KeyValidationState state =
            _keyStates.firstWhere((element) => element.state == false);

        Scrollable.ensureVisible(
          state.key.currentContext!,
          duration: const Duration(milliseconds: 500),
        );
        /*_scrollController.position.ensureVisible(
          state.key.currentContext!.findRenderObject()!,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );*/
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  bool _save() {
    if (kDebugMode) {
      print("Urrà!");
    }
    int index = 0;
    List<MachineReminder> result = _currentReminders.map((e) {
      index++;
      return e.copyWith(
          matricola: _matricolaController.value.text, position: index);
    }).toList(growable: false);

    try {
      if (element == null) {
        element = Machine(
            machineId: _customMatricolaController.value.text,
            matricola: _matricolaController.value.text,
            customerId: selectedCustomer?.customerId,
            stabId: selectedFactory?.customerId,
            vmcId: selectedModel?.vmcId,
            modelloId: 8,
            stato: currentStato,
            machineReminders: result,
            machineSettings: selectedSettings
                .map((e) => e.copyWith(
                    matricola: _matricolaController.text, machine: null))
                .toList(growable: false),
            machineProductions: selectedProductions
                .map(
                  (e) => e.copyWith(
                      matricola: _matricolaController.text, machine: null),
                )
                .toList(growable: false),
            machineNotes: currentNotes
                .map(
                  (e) => e.copyWith(
                      matricola: _matricolaController.text, machine: null),
                )
                .toList(growable: false));

        // if (widget.autoSave){
        //
        // }
      } else {
        element = element!.copyWith(
            machineId: _customMatricolaController.value.text,
            matricola: _matricolaController.value.text,
            customerId: selectedCustomer?.customerId,
            machineReminders: result,
            customer: null,
            stabId: selectedFactory?.customerId,
            stabilimento: null,
            vmcId: selectedModel?.vmcId,
            modelloId: 8,
            stato: currentStato,
            machineSettings: selectedSettings
                .map((e) => e.copyWith(
                    matricola: _matricolaController.text, machine: null))
                .toList(growable: false),
            machineProductions: selectedProductions
                .map((e) => e.copyWith(
                    matricola: _matricolaController.text, machine: null))
                .toList(growable: false),
            machineNotes: currentNotes
                .map(
                  (e) => e.copyWith(
                      matricola: _matricolaController.text, machine: null),
                )
                .toList(growable: false));
      }
      if (widget.saveDirectly) {
        _saveMachine(element!);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  _saveMachine(Machine item) {
    var bloc = BlocProvider.of<ServerDataBloc<Machine>>(context);
    bloc.add(ServerDataEvent<Machine>(
        status: ServerDataEvents.update,
        keyName: 'matricola',
        item: item,
        onEvent: (bloc, event, emit) {
          return MachineActions.onUpdate(bloc, event, emit);
        }));
  }

  bool isEnabled() {
    if (element != null) {
      return false;
    }
    /* return (details != null && details!.isNotEmpty) ||
            (element != null && element!.status == Status.closed.index)
        ? false
        : true;*/
    return true;
  }

  Widget _customerDropDown() {
    return BlocBuilder<ServerDataBloc<Customer>, ServerDataState<Customer>>(
        builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            customers = state.items as List<Customer>;

            return Padding(
              padding: getPadding(),
              child: DropdownSearch<Customer>(
                key: _customerDropDownKey,

                popupProps: PopupProps.dialog(
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  dialogProps: DialogProps(
                      backgroundColor: getAppBackgroundColor(context)),
                  emptyBuilder: (context, searchEntry) =>
                      const Center(child: Text('Nessun risultato')),
                  searchFieldProps: TextFieldProps(
                      padding: getPadding(),
                      //controller: _searchCustomerController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  showSelectedItems: true,
                  showSearchBox: true,
                ),

                enabled: true,
                //isEnabled(),

                /*popupBackgroundColor: getAppBackgroundColor(context),*/

                compareFn: (item, selectedItem) =>
                    item.customerId == selectedItem.customerId,
                clearButtonProps: const ClearButtonProps(isVisible: true),

                itemAsString: (Customer? c) => c!.toString(withSpace: false),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectedItem: selectedCustomer,
                onChanged: (Customer? newValue) {
                  editState = true;
                  setState(() {
                    selectedCustomer = newValue;
                    _updateStato();
                  });
                },

                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Cliente',
                    hintText: 'Seleziona un cliente',
                  ),
                ),
                /*validator: (item) {
                  if (item == null) {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) => element.key == _customerDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: false);
                    return "Campo obbligatorio";
                  } else {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) => element.key == _customerDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: true);
                  }
                  return null;
                },*/
                items: customers ?? <Customer>[],
                filterFn: (Customer? item, String? filter) {
                  String json = jsonEncode(item?.json);
                  String newString = json.removePunctuation();
                  if (kDebugMode) {
                    print(newString);
                  }
                  String filterString = filter?.removePunctuation() ?? '';
                  return newString
                      .toLowerCase()
                      .contains(filterString.toLowerCase());
                },
              ),
            );
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    });
  }

  Widget _factoryDropDown() {
    return BlocBuilder<ServerDataBloc<Customer>, ServerDataState<Customer>>(
        builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            factories = state.items as List<Customer>;

            return Padding(
              padding: getPadding(),
              child: DropdownSearch<Customer>(
                key: _factoryDropDownKey,

                popupProps: PopupProps.dialog(
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  dialogProps: DialogProps(
                      backgroundColor: getAppBackgroundColor(context)),
                  emptyBuilder: (context, searchEntry) =>
                      const Center(child: Text('Nessun risultato')),
                  searchFieldProps: TextFieldProps(
                      padding: getPadding(),
                      //controller: _searchFactoryController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  showSelectedItems: true,
                  showSearchBox: true,
                ),

                enabled: true,
                //isEnabled(),

                /*popupBackgroundColor: getAppBackgroundColor(context),*/

                compareFn: (item, selectedItem) =>
                    item.customerId == selectedItem.customerId,
                clearButtonProps: const ClearButtonProps(isVisible: true),

                itemAsString: (Customer? c) => c!.toString(withSpace: false),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectedItem: selectedFactory,
                onChanged: (Customer? newValue) {
                  editState = true;
                  setState(() {
                    selectedFactory = newValue;
                    _updateStato();
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Stabilimento',
                    hintText: 'Seleziona uno stabilimento',
                  ),
                ),

                validator: selectedCustomer != null
                    ? (item) {
                        if (item == null) {
                          KeyValidationState state = _keyStates.firstWhere(
                              (element) => element.key == _factoryDropDownKey);
                          _keyStates[_keyStates.indexOf(state)] =
                              state.copyWith(state: false);
                          return "Campo obbligatorio";
                        } else {
                          KeyValidationState state = _keyStates.firstWhere(
                              (element) => element.key == _factoryDropDownKey);
                          _keyStates[_keyStates.indexOf(state)] =
                              state.copyWith(state: true);
                        }
                        return null;
                      }
                    : null,
                items: factories ?? <Customer>[],
                filterFn: (Customer? item, String? filter) {
                  String json = jsonEncode(item?.json);
                  String newString = json.removePunctuation();
                  if (kDebugMode) {
                    print(newString);
                  }
                  String filterString = filter?.removePunctuation() ?? '';
                  return newString
                      .toLowerCase()
                      .contains(filterString.toLowerCase());
                },
              ),
            );
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    });
  }

  Widget _modelDropDown() {
    return BlocBuilder<ServerDataBloc<Vmc>, ServerDataState<Vmc>>(
        builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            models = state.items as List<Vmc>;

            return Padding(
              padding: getPadding(),
              child: DropdownSearch<Vmc>(
                key: _modelDropDownKey,

                popupProps: PopupProps.dialog(
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  dialogProps: DialogProps(
                      backgroundColor: getAppBackgroundColor(context)),
                  emptyBuilder: (context, searchEntry) =>
                      const Center(child: Text('Nessun risultato')),
                  searchFieldProps: TextFieldProps(
                      padding: getPadding(),
                      //controller: _searchModelController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  showSelectedItems: true,
                  showSearchBox: true,
                ),
                enabled: true,

                //isEnabled(),

                /*popupBackgroundColor: getAppBackgroundColor(context),*/

                compareFn: (item, selectedItem) =>
                    item.vmcId == selectedItem.vmcId,
                clearButtonProps: const ClearButtonProps(isVisible: true),

                itemAsString: (Vmc? c) => c!.description,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectedItem: selectedModel,
                onChanged: (Vmc? newValue) {
                  editState = true;

                  setState(() {
                    if (selectedModel != newValue) {
                      _boxes.clear();
                      selectedModel = newValue;
                      reloadModelSettings = true;
                      reloadModelProductions = true;
                      int oldStato = currentStato;
                      _updateStato();

                      ///se lo stato non è cambiato ricarico i modelli
                      if (currentStato == oldStato && selectedModel != null) {
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _loadVmcSettings(selectedModel!.vmcId);
                          _loadVmcProductions(selectedModel!.vmcId);
                        });
                      }
                    }
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Modello',
                    hintText: 'Seleziona un modello',
                  ),
                ),

                validator: (item) {
                  if (item == null) {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) => element.key == _factoryDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: false);
                    return "Campo obbligatorio";
                  } else {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) => element.key == _factoryDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: true);
                  }
                  return null;
                },
                items: models ?? <Vmc>[],
                filterFn: (Vmc? item, String? filter) {
                  String json = jsonEncode(item?.json);
                  String newString = json.removePunctuation();
                  if (kDebugMode) {
                    print(newString);
                  }
                  String filterString = filter?.removePunctuation() ?? '';
                  return newString
                      .toLowerCase()
                      .contains(filterString.toLowerCase());
                },
              ),
            );
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    });
  }

  Widget _settingsFieldsDropDownWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: getPadding(),
        child: DropdownSearch<MapSettingKey>(
          enabled: true,
          popupProps: PopupPropsMultiSelection.dialog(
            containerBuilder: (context, child) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: child);
            },
            itemBuilder: (context, item, isSelected) {
              return getMachineSettingItem(item.machineSetting,
                  context: context, showClearButton: false);
            },
            scrollbarProps: const ScrollbarProps(thickness: 0),
            dialogProps: DialogProps(
              backgroundColor: getAppBackgroundColor(context),
            ),
            showSelectedItems: true,
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                autofocus: isWindows || isWindowsBrowser ? true : false,
                //    controller: settingFieldsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Cerca")),
            emptyBuilder: (context, searchEntry) =>
                const Center(child: Text('Nessun risultato')),
          ),
          //popupBackgroundColor: getAppBackgroundColor(context),

          compareFn: (item, selectedItem) =>
              item.fieldId == selectedItem.fieldId,
          //showClearButton: true,
          clearButtonProps: const ClearButtonProps(isVisible: true),
          itemAsString: (MapSettingKey? c) =>
              c?.machineSetting.name ?? 'no name',

          dropdownBuilder: (context, MapSettingKey? item) {
            if (item != null) {
              return getMachineSettingItem(item.machineSetting,
                  context: context, showClearButton: false);
            } else {
              return const Text("Seleziona un campo");
            }
          },
          selectedItem: _selectedMapSettingKey,
          onChanged: (MapSettingKey? newValue) async {
            if (newValue != null && isLittleWidth()) {
              if (!mounted) return;
              Navigator.of(context).pop();
            }
            editState = true;
            setState(() {
              _selectedMapSettingKey = newValue;
            });
            if (_selectedMapSettingKey != null) {
              //RenderObject? renderObj = _selectedMapSettingKey?.key.currentContext?.findRenderObject();
              Scrollable.ensureVisible(
                  _selectedMapSettingKey!.key.currentContext!,
                  duration: const Duration(milliseconds: 500));
              Timer(const Duration(milliseconds: 500), () async {
                await tapTargetWithEffect(_selectedMapSettingKey!.key);
              });

              /*if (renderObj!=null) {
                await scrollTo(renderObj);
              }*/
            }
          },
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              //enabledBorder: OutlineInputBorder(),
              border: OutlineInputBorder(),
              labelText: 'Cerca impostazione',
              hintText: 'Seleziona un campo',
              isDense: true,
            ),
          ),

          validator: (item) {
            return null;
          },
          items: categorySettingsList,
          filterFn: (MapSettingKey? item, String? filter) {
            String json = item?.fieldName ?? '';
            String newString = json.removePunctuation();
            if (kDebugMode) {
              print(newString);
            }
            String filterString = filter?.removePunctuation() ?? '';
            return newString.toLowerCase().contains(filterString.toLowerCase());
          },
        ),
      ),
    );
  }

  Widget _fieldsDropDownWidget() {
    return Padding(
      padding: getPadding(),
      child: DropdownSearch<MapSettingKey>(
        popupProps: PopupProps.dialog(
          scrollbarProps: const ScrollbarProps(thickness: 0),
          dialogProps:
              DialogProps(backgroundColor: getAppBackgroundColor(context)),
          emptyBuilder: (context, searchEntry) =>
              const Center(child: Text('Nessun risultato')),
          searchFieldProps: TextFieldProps(
              padding: getPadding(),
              //controller: _searchFieldsController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Cerca")),
          showSelectedItems: true,
          showSearchBox: true,
        ),
        enabled: true,

        //isEnabled(),

        /*popupBackgroundColor: getAppBackgroundColor(context),*/

        compareFn: (item, selectedItem) => item.key == selectedItem.key,
        clearButtonProps: const ClearButtonProps(isVisible: true),

        itemAsString: (MapSettingKey c) => c.fieldName,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectedItem: _selectedMapSettingKey,
        onChanged: (MapSettingKey? newValue) async {
          editState = true;
          setState(() {
            _selectedMapSettingKey = newValue;
          });
          if (_selectedMapSettingKey != null) {
            //RenderObject? renderObj = _selectedMapSettingKey?.key.currentContext?.findRenderObject();
            Scrollable.ensureVisible(
                _selectedMapSettingKey!.key.currentContext!,
                duration: const Duration(milliseconds: 500));
            /*if (renderObj!=null) {
              await scrollTo(renderObj);
            }*/
          }
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            //enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            labelText: 'Cerca impostazione',
            hintText: 'Seleziona un campo',
            isDense: true,
          ),
        ),

        validator: (item) {
          return null;
        },
        items: categorySettingsList,
        filterFn: (MapSettingKey? item, String? filter) {
          String json = item?.fieldName ?? '';
          String newString = json.removePunctuation();
          if (kDebugMode) {
            print(newString);
          }
          String filterString = filter?.removePunctuation() ?? '';
          return newString.toLowerCase().contains(filterString.toLowerCase());
        },
      ),
    );
  }

  Widget _fieldsDropDown() {
    return BlocListener<ServerDataBloc<VmcSetting>,
            ServerDataState<VmcSetting>>(
        listener: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded) {
        /* if (state.items != null && state.items is List<VmcSetting>) {
                List<VmcSetting> items = state.items as List<VmcSetting>;
                createSelectableSettings(items);
              }*/
      }
    }, child: BlocBuilder<ServerDataBloc<VmcSetting>,
                ServerDataState<VmcSetting>>(
            builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded) {
            //return _fieldsDropDownWidget();
            return _settingsFieldsDropDownWidget();
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }
          break;
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    }));
  }

/*
  Widget _settingsWidget() {
    return BlocListener<ServerDataBloc<VmcSetting>,
        ServerDataState<VmcSetting>>(
      listener: (BuildContext context, ServerDataState state) {
        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataInitState) {}
            if (state is ServerDataLoading) {}
            if (state is ServerDataLoaded) {
              if (state.items != null && state.items is List<VmcSetting>) {
                List<VmcSetting> items = state.items as List<VmcSetting>;

                */
/*for(VmcSetting setting in selectedSettings){
                items.removeWhere((element) => element.vmcSettingFieldId==setting.settingField!.vmcSettingFieldId);
              }*/ /*

                selectableSettings = items
                    .map((e) => MachineSetting(
                          matricola: '',
                          name: e.settingField!.name,
                          description: e.settingField!.description,
                          categoryCode:
                              e.settingField!.vmcSettingCategoryCode,
                  categoryName:
                  e.settingField!.category?.name ?? 'category is null',
                  categoryColor: e.settingField!.category?.color,
                        ))
                    .toList(growable: false);
              }
            }
            break;
          default:
            break;
        }
      },
      child:
          BlocBuilder<ServerDataBloc<VmcSetting>, ServerDataState<VmcSetting>>(
              builder: (BuildContext context, ServerDataState state) {
        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataInitState) {
              return shimmerComboLoading(context,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
            }
            if (state is ServerDataLoading) {
              return shimmerComboLoading(context,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
            }
            if (state is ServerDataLoaded) {
              */
/* if (!_settingsLoaded){
                    _settingsLoaded=true;
                  }*/ /*

              */
/*if (state.items != null && state.items is List<VmcSettingField>) {
                vmcSettingFields = state.items as List<VmcSettingField>;
              }*/ /*


              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(selectedSettings.length,
                    (index) => Flexible(child: Text(index.toString()))),
              );
            }
            if (state is ServerDataError) {
              return const Text("Errore Caricamento");
            }
            break;
          default:
            break;
        }
        return const Text("Stato sconosciuto");
      }),
    );
  }
*/

/*  Widget _settingsBlocWidget() {
    return BlocListener<ServerDataBloc<VmcSetting>,
        ServerDataState<VmcSetting>>(
      listener: (BuildContext context, ServerDataState state) {
        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataInitState) {}
            if (state is ServerDataLoading) {}
            if (state is ServerDataLoaded) {
              if (state.items != null && state.items is List<VmcSetting>) {
                List<VmcSetting> items = state.items as List<VmcSetting>;

                */ /*for(VmcSetting setting in selectedSettings){
                items.removeWhere((element) => element.vmcSettingFieldId==setting.settingField!.vmcSettingFieldId);
              }*/ /*
                selectableSettings = items
                    .map((e) => MachineSetting(
                          matricola: '',
                          name: e.settingField!.name,
                          description: e.settingField!.description,
                          vmcCategoryCode:
                              e.settingField!.vmcSettingCategoryCode,
                        ))
                    .toList(growable: false);
              }
            }
            break;
          default:
            break;
        }
      },
      child:
          BlocBuilder<ServerDataBloc<VmcSetting>, ServerDataState<VmcSetting>>(
              builder: (BuildContext context, ServerDataState state) {
        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataInitState) {
              return shimmerComboLoading(context,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
            }
            if (state is ServerDataLoading) {
              return shimmerComboLoading(context,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
            }
            if (state is ServerDataLoaded) {
              */ /* if (!_settingsLoaded){
                    _settingsLoaded=true;
                  }*/ /*
              */ /*if (state.items != null && state.items is List<VmcSettingField>) {
                vmcSettingFields = state.items as List<VmcSettingField>;
              }*/ /*

              return SettingsScrollSection(
                title: const Text('Lista impostazioni'),
                tiles: selectedSettings.isNotEmpty
                    ? List.generate(
                        selectedSettings.length,
                        (index) => _settingSettingTile(selectedSettings[index]),
                      )
                    : List.generate(
                        1,
                        (index) => getCustomSettingTile(
                            child: const Text(
                                'Nessuna impostazione selezionata'))),
              );
            }
            if (state is ServerDataError) {
              return const Text("Errore Caricamento");
            }
            break;
          default:
            break;
        }
        return const Text("Stato sconosciuto");
      }),
    );
  }*/

  createSelectableSettings(List<VmcSetting> items) {
    selectableSettings = items
        .map((e) => MachineSetting(
              matricola: '',
              vmcSettingFieldId: e.settingField!.vmcSettingFieldId!,
              vmcSettingId: e.vmcSettingId!,
              name: e.settingField!.name,
              description: e.settingField!.description,
              categoryCode: e.settingField!.vmcSettingCategoryCode,
              categoryName:
                  e.settingField!.category?.name ?? 'category is null',
              categoryColor: e.settingField!.category?.color,
              params: e.settingField!.params,
              type: e.settingField!.type,
            ))
        .toList(growable: false);

    ///creo i settings per il modello selezionato
    List<MachineSetting> difference = selectableSettings
        .where((selectableItem) => !selectedSettings
            .where((element) =>
                element.vmcSettingFieldId == selectableItem.vmcSettingFieldId)
            .toList(growable: false)
            .isNotEmpty)
        .toList(growable: false);
    if (selectedModel != null && reloadModelSettings) {
      reloadModelSettings = false;
      selectedSettings = selectableSettings;
      return;
    }
    if (selectedModel != null && difference.isNotEmpty) {
      reloadModelSettings = false;

      ///per renderla growable
      selectedSettings = selectedSettings.map((e) => e).toList();
      setState(() {
        selectedSettings.addAll(difference);
      });
    }
  }

  createSelectableProductions(List<VmcProduction> items) {
    selectableProductions = items
        .map((e) => MachineProduction(
              matricola: '',
              vmcProductionFieldId: e.productionField!.vmcProductionFieldId!,
              vmcProductionId: e.vmcProductionId!,
              name: e.productionField!.name,
              description: e.productionField!.description,
              categoryCode: e.productionField!.vmcProductionCategoryCode,
              categoryName:
                  e.productionField!.category?.name ?? 'category is null',
              categoryColor: e.productionField!.category?.color,
              params: e.productionField!.params,
              type: e.productionField!.type,
            ))
        .toList(growable: false);

    ///creo i productions per il modello selezionato
    if (selectedModel != null && reloadModelProductions) {
      reloadModelProductions = false;
      selectedProductions = selectableProductions;
    }
  }

  Widget productionSectionTile() {
    double completePercentage = 0.0;
    //if (element != null) {
    int completeParts = selectedProductions
        .where((element) => element.type == MachineProductionItemType.image.type
            ? (element.images
                    ?.where((element) => element.mediaId != -1)
                    .isNotEmpty ??
                false)
            : element.type == MachineProductionItemType.file.type
                ? (element.files
                        ?.where((element) => element.mediaId != -1)
                        .isNotEmpty ??
                    false)
                : element.value.isNotEmpty)
        .length;
    int totalParts = selectedProductions.length;
    if (totalParts > 0) {
      completePercentage = (completeParts / totalParts) * 100;
    }
    //}

    List<MachineProduction> machineProductionCopy = selectedProductions
        .map((e) => e.copyWith(
            images: e.images?.map((e) => e.copyWith()).toList(growable: false)))
        .toList(growable: false);

    Machine? machineCopy =
        element?.copyWith(machineProductions: machineProductionCopy);
    return getCustomSettingTile(
        key: _productionSectionKey,
        onPressed: (context) async {
          await showDialog(
              context: context,
              builder: (context) {
                return multiDialog(
                    content: BlocProvider<ServerDataBloc<VmcProduction>>(
                        create: (BuildContext context) =>
                            ServerDataBloc<VmcProduction>(
                                repo: MultiService<VmcProduction>(
                                    VmcProduction.fromJsonModel,
                                    apiName: 'VmcProduction')),
                        child: MachineProductionsView(
                          title:
                              "${_matricolaController.text} - ${selectedFactory?.description ?? ''}",
                          machine: element,
                          machineProductions: selectedProductions
                              .map((e) => e.copyWith())
                              .toList(growable: false),
                          savePressed: () {
                            editState = true;
                            return true;
                          },
                        )));
              }).then((value) {
            if (value != null) {
              setState(() {
                selectedProductions = value;
                element = element?.copyWith(machineProductions: value);
                _updateStato();
              });
            } else {
              setState(() {
                selectedProductions = machineProductionCopy;
                element = machineCopy;
                _updateStato();
              });
            }
          });
        },
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: FAProgressBar(
                  animatedDuration: const Duration(milliseconds: 1000),
                  maxValue: double.parse(selectedProductions.length.toString()),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  progressColor: Theme.of(context).colorScheme.primary,
                  currentValue: double.parse(selectedProductions
                      .where((element) => element.type ==
                              MachineProductionItemType.image.type
                          ? (element.images
                                  ?.where((element) => element.mediaId != -1)
                                  .isNotEmpty ??
                              false)
                          : element.value.isNotEmpty)
                      .toList(growable: false)
                      .length
                      .toString())),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 30),
              alignment: Alignment.center,
              child: getStrokedText(completePercentage < 100
                  ? '${completePercentage.toStringAsFixed(2)}%'
                  : '100%'),
            )
          ],
        ),
        title: "Stato produzione",
        hint: "Stato produzione",
        description: "Situazione produzione macchina");
  }

  Widget settingsSectionWithBloc() {
    return SettingsScrollSection(
        title: const Text("Impostazioni"), tiles: [settingsSectionTileBloc()]);
  }

/*  Widget settingsSection() {
    return SettingsScrollSection(
        title: const Text("Impostazioni"),
        tiles: [
          getCustomSettingTile(
              key: _settingsSectionKey,
              onPressed: (context) async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return multiDialog(
                          content: BlocProvider<ServerDataBloc<VmcProduction>>(
                              create: (BuildContext context) =>
                                  ServerDataBloc<VmcProduction>(
                                      repo: BaseServiceEx<VmcProduction>(
                                          VmcProduction.fromJsonModel,
                                          apiName: 'VmcProduction')),
                              child: MachineSettingsView(
                                machine: element,
                                machineSettings: selectedSettings
                                    .map((e) => e.copyWith())
                                    .toList(growable: false),
                                savePressed: ({BuildContext? context}) {
                                  editState = true;
                                  return true;
                                },
                              )));
                    }).then((value) {
                  if (value != null) {
                    setState(() {
                      selectedSettings = value;
                    });
                  }
                });

                setState(() {});
              },
              child: const Text("Seleziona per vedere le impostazioni"),
              title: "Impostazioni macchina",
              hint: "Com'è impostata la macchina",
              description: "Com'è impostata la macchina, il server ed eventuali altre impostazioni")
        ]
    );
  }*/

  /* SettingsTile _productionSettingTile(MachineProduction item) {
    switch (item.type) {
      case 6:

        ///double input
        break;
      case 5:

        ///int input
        break;
      case 4:

        ///check box
        List<String> valuesToSelect = <String>[];

        if (item.params != null) {
          valuesToSelect = item.params!.split('|');
        }

        return getSwitchSettingTile(
            key: categoryProductionsList
                .firstWhereOrNull(
                    (element) => element.fieldId == item.vmcProductionFieldId)
                ?.key,
            title: item.name ?? '',
            description: item.description,
            icon: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _editProductionSetting(item)),
            initialValue: valuesToSelect.isEmpty
                ? item.value.toLowerCase() == "vero"
                    ? true
                    : false
                : item.value.toLowerCase() == valuesToSelect[0].toLowerCase()
                    ? true
                    : false,
            textWhenTrue: valuesToSelect.isEmpty ? 'Vero' : valuesToSelect[0],
            textWhenFalse: valuesToSelect.isEmpty ? 'Falso' : valuesToSelect[1],
            onToggle: (value) {
              for (int index = 0; index < selectedProductions.length; index++) {
                if (selectedProductions[index].vmcProductionFieldId ==
                    item.vmcProductionFieldId) {
                  setState(() {
                    String trueString = 'Vero';
                    String falseString = 'Falso';
                    if (valuesToSelect.isNotEmpty) {
                      trueString = valuesToSelect[0];
                      falseString = valuesToSelect[1];
                    }
                    selectedProductions[index] = selectedProductions[index]
                        .copyWith(value: value ? trueString : falseString);
                  });
                  break;
                }
              }
            },
            defaultTextColor: isDarkTheme(context)
                ? darkTileDescriptionTextColor
                : lightTileDescriptionTextColor);

      case 3:

        ///Image
        break;
      case 2:

        ///UpDown

        List<String> valuesToSelect = <String>[];
        if (item.params != null) {
          ///min|max|step|fractionDigits
          valuesToSelect = item.params!.split('|');
        }
        return getUpDownSettingTile(
          key: categoryProductionsList
              .firstWhereOrNull(
                  (element) => element.fieldId == item.vmcProductionFieldId)
              ?.key,
          title: item.name ?? '',
          hint: item.name ?? '',
          description: item.description,
          initialValue: item.value.isEmpty ? "0" : item.value,
          quarterTurns: 0,
          icon: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _editProductionSetting(item)),
          min: valuesToSelect.isEmpty ? 0 : double.parse(valuesToSelect[0]),
          step: valuesToSelect.isEmpty ? 1 : double.parse(valuesToSelect[2]),
          max: valuesToSelect.isEmpty ? 1000 : double.parse(valuesToSelect[1]),
          onResult: (String? result) {
            if (result != null) {
              for (int index = 0; index < selectedProductions.length; index++) {
                if (selectedProductions[index].vmcProductionFieldId ==
                    item.vmcProductionFieldId) {
                  setState(() {
                    selectedProductions[index] = selectedProductions[index]
                        .copyWith(
                            value: double.parse(result).toStringAsFixed(
                                valuesToSelect.isEmpty
                                    ? 0
                                    : int.parse(valuesToSelect[3])));
                  });
                  break;
                }
              }
            }
          },
        );
        break;
      case 1:

        ///Selection

        if (item.params != null) {
          List<String> valuesToSelect = <String>[];
          valuesToSelect = item.params!.split('|');
          return getSelectionSettingTile(
            key: categoryProductionsList
                .firstWhereOrNull(
                    (element) => element.fieldId == item.vmcProductionFieldId)
                ?.key,
            title: item.name,
            hint: item.name,
            description: item.description,
            icon: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _editProductionSetting(item)),
            initialValue: item.value.isEmpty ? '' : item.value,
            children: [
              ...valuesToSelect.map((e) {
                return SimpleDialogOption(
                    onPressed: () {
                      for (int index = 0;
                          index < selectedProductions.length;
                          index++) {
                        if (selectedProductions[index].vmcProductionFieldId ==
                            item.vmcProductionFieldId) {
                          setState(() {
                            selectedProductions[index] =
                                selectedProductions[index].copyWith(value: e);
                          });
                          break;
                        }
                      }

                      if (!mounted) return;
                      Navigator.of(context).maybePop();
                    },
                    //
                    child: Row(
                      children: [
                        */ /*type.toIcon(),
                      const SizedBox(
                      width: 8,
                      ),*/ /*
                        Text(e),
                      ],
                    ));
              })
            ],
          );
        }
        break;
      case 0:
      default:

        ///TextInput

        return getTextInputSettingTile(
          key: categoryProductionsList
              .firstWhereOrNull(
                  (element) => element.fieldId == item.vmcProductionFieldId)
              ?.key,
          title: item.name,
          hint: item.name,
          description: item.description,
          onResult: (String? result) {
            if (result != null) {
              for (int index = 0; index < selectedProductions.length; index++) {
                if (selectedProductions[index].vmcProductionFieldId ==
                    item.vmcProductionFieldId) {
                  setState(() {
                    selectedProductions[index] =
                        selectedProductions[index].copyWith(value: result);
                  });
                  break;
                }
              }
            }
          },
          initialValue: item.value.isEmpty ? '' : item.value,
          icon: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _editProductionSetting(item)),
        );
    }
    return getCustomSettingTile(child: const Text('Errore'));
  }*/

/*  SettingsTile settingsPanelsTile() {
    return getCustomSettingTile(
        title: "Impostazioni macchina",
        hint: "Com'è impostata la macchina",
        description:
            "Com'è impostata la macchina, il server ed eventuali altre impostazioni",
        child: settingsPanels());
  }*/

  SettingsTile productionsPanelsTile() {
    return getCustomSettingTile(child: productionsPanels());
  }

  Widget settingsPanels() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: MultiExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            switch (panelIndex) {
              case 0: //settings
                _settingsPanelIsExpanded = !_settingsPanelIsExpanded;
                _selectorData = _getSelectorData(
                    direction: isLittleWidth() == false
                        ? Axis.vertical
                        : Axis.horizontal);
                _multiSelectorKey.currentState?.selectorData = _selectorData!;
                if (_settingsPanelIsExpanded) {
                  try {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      try {
                        Future.delayed(const Duration(milliseconds: 250), () {
                          GlobalKey key =
                              categoryKeysMap.entries.elementAt(0).value;
                          Scrollable.ensureVisible(key.currentContext!,
                              duration: const Duration(milliseconds: 500));
                        });
                      } catch (e) {
                        print(e);
                      }
                    });
                  } catch (e) {
                    print(e);
                  }
                }
                break;
              case 1: //operations
                //_logicPanelIsExpanded = !_logicPanelIsExpanded;
                break;
            }
            setState(() {});
          },
          children: [
            MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: _settingsPanelIsExpanded,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        height: 30,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DefaultTextStyle(
                              style: TextStyle(
                                color: SettingsTheme.of(context)
                                    .themeData
                                    .titleTextColor,
                                fontSize: 15,
                              ),
                              child: Text(
                                  "${_settingsPanelIsExpanded ? 'Nascondi' : 'Mostra'} impostazioni macchina")),
                        )),
                  );
                },
                body: Column(
                  children: [
                    SettingsScroll(
                      darkTheme: getSettingsDarkTheme(context,
                          settingsListBackground: Colors.transparent),
                      lightTheme: getSettingsLightTheme(context),
                      platform: DevicePlatform.web,
                      sections: [
                        _settingsOptionsSection(),
                        ...settingsSections,
                      ],
                    )
                  ],
                )),
            /*MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: _logicPanelIsExpanded,
                canTapOnHeader: false,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const SizedBox(
                      height: 80, child: DialogHeader("Parametri logici"));
                },
                body: Column(
                  children: [
                    generateButton(),
                    maxRowsField(),
                    maxWidthSpacesField(),
                    tickInSingleSpaceField(),
                  ],
                )),*/
          ],
        ),
      ),
    );
  }

  Widget productionsPanels() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: MultiExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            switch (panelIndex) {
              case 0: //settings
                _productionsPanelIsExpanded = !_productionsPanelIsExpanded;
                if (_productionsPanelIsExpanded) {
                  /*try {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      try {
                        Future.delayed(const Duration(milliseconds: 250), () {
                          GlobalKey key =
                              categoryKeysMap.entries.elementAt(0).value;
                          Scrollable.ensureVisible(key.currentContext!,
                              duration: const Duration(milliseconds: 500));
                        });
                      } catch (e) {
                        print(e);
                      }
                    });
                  } catch (e) {
                    print(e);
                  }*/
                }
                break;
              case 1: //operations
                //_logicPanelIsExpanded = !_logicPanelIsExpanded;
                break;
            }
            setState(() {});
          },
          children: [
            MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: _productionsPanelIsExpanded,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        height: 30,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DefaultTextStyle(
                              style: TextStyle(
                                color: SettingsTheme.of(context)
                                    .themeData
                                    .titleTextColor,
                                fontSize: 15,
                              ),
                              child: const Text("Produzione macchina")),
                        )),
                  );
                },
                body: Column(
                  children: [
                    SettingsScroll(
                      darkTheme: getSettingsDarkTheme(context,
                          settingsListBackground: Colors.transparent),
                      lightTheme: getSettingsLightTheme(context),
                      platform: DevicePlatform.web,
                      sections: [
                        ...productionsSections,
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  static String getStatusText(int currentStato) {
    switch (currentStato) {
      case 0:
        return "Nuova";
      case 1:
        return "Assegnato modello";
      case 2:
        return "Assegnato cliente e stabilimento";
      case 3:
        return "In preparazione";
      case 4:
        return "Pronta";
      case 5:
        return "Installata";
      case 6:
        return "In sede";
      case 7:
        return "Rottamata";
    }
    return "Sconosciuto";
  }

  static Color getStatusColor(int currentStato) {
    switch (currentStato) {
      case 0:
        return Colors.white;
      case 1:
        return Colors.purple;
      case 2:
        return Colors.pink;
      case 3:
        return Colors.cyan;
      case 4:
        return Colors.yellow;
      case 5:
        return Colors.green;
      case 6:
        return Colors.teal;
      case 7:
        return Colors.black;
    }
    return Colors.grey;
  }

  _updateStato() {
    int stato = 0;

    ///0 - nuova
    ///1 - assegnato modello
    ///2 - assegnato cliente e stabilimento
    ///3 - in preparazione
    ///4 - pronta
    ///5 - installata
    ///6 - in Multi-Tech
    ///7 - Rottamata
    ///
    int oldStato = currentStato;

    if (currentStato < 5) {
      if (_matricolaController.text != "" &&
          _customMatricolaController.text != "" &&
          selectedModel != null) {
        ///assegnato modello
        stato = 1;
      }

      if (selectedCustomer != null && selectedFactory != null) {
        ///assegnato cliente
        stato = 2;
      }

      if (stato >= 1 &&
          selectedProductions
              .where((element) =>
                  element.type == MachineProductionItemType.image.type
                      ? element.images != null &&
                          (element.images?.isNotEmpty ?? false)
                      : element.value.isNotEmpty)
              .isNotEmpty) {
        ///in preparazione
        stato = 3;
      }
      if (stato >= 3 &&
          selectedProductions
              .whereNot((element) =>
                  element.type == MachineProductionItemType.image.type
                      ? element.images != null &&
                          (element.images?.isNotEmpty ?? false)
                      : element.value.isNotEmpty)
              .isEmpty) {
        ///in preparazione
        stato = 4;
      }
    } else {
      stato = currentStato;
    }

    currentStato = stato;
    //_loadVmcSettings(-1);

    if (oldStato != currentStato) {
      if (currentStato == 2 && selectedModel != null) {
        _loadVmcProductions(selectedModel!.vmcId);
        _loadVmcSettings(selectedModel!.vmcId);
      }
    }
    _multiSelectorKey.currentState?.setState(() {
      _selectorData = _getSelectorData(
          direction:
              isLittleWidth() == false ? Axis.vertical : Axis.horizontal);
      _multiSelectorKey.currentState?.selectorData = _selectorData!;
    });
  }

  @override
  void dispose() {
    _searchCustomerController.dispose();
    _searchFactoryController.dispose();

    _customMatricolaController.dispose();
    _matricolaController.dispose();
    _matricolaChangeController.dispose();

    _scrollController.removeListener(scrollListener);
    _boxes.clear();
    _scrollController.dispose();
    _searchFieldsController.dispose();
    _multiSelectorScrollController.dispose();
    reminderListScrollController.dispose();
    noteListScrollController.dispose();
    super.dispose();
  }
}

class MapSettingKey {
  final String fieldName;
  final int fieldId;
  final GlobalKey key;
  final MachineSetting machineSetting;

  const MapSettingKey(
      {required this.fieldId,
      required this.machineSetting,
      required this.fieldName,
      required this.key});
}

class MapProductionKey {
  final String fieldName;
  final int fieldId;
  final GlobalKey key;
  final MachineProduction machineProduction;

  const MapProductionKey(
      {required this.fieldId,
      required this.machineProduction,
      required this.fieldName,
      required this.key});
}
