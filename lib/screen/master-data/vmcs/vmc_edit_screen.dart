import 'dart:convert';

import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_physics_configuration.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/media_item.dart';
import 'package:dpicenter/models/server/vmc_file.dart';
import 'package:dpicenter/models/server/vmc_production.dart';
import 'package:dpicenter/models/server/vmc_production_field.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_field.dart';
import 'package:dpicenter/models/server/vmc_type_enum.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/autogeneration/edit_vmc_ex.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/file_loader/file_loader.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:settings_ui/settings_ui.dart';

// Define a custom Form widget.
class VmcEditForm extends StatefulWidget {
  final Vmc? element;
  final String? title;

  ///salva direttamente senza passare l'informazione a data_screen
  final bool saveDirectly;

  const VmcEditForm(
      {Key? key,
      required this.element,
      required this.title,
      this.saveDirectly = false})
      : super(key: key);

  @override
  VmcEditFormState createState() {
    return VmcEditFormState();
  }
}

class VmcEditFormState extends State<VmcEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController codeController;
  late TextEditingController descriptionController;
  late TextEditingController settingFieldsController = TextEditingController();
  late TextEditingController productionFieldsController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  Vmc? element;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');
  final FocusNode _codeFocusNode = FocusNode(debugLabel: '_codeFocusNode');
  final FocusNode _descriptionFocusNode =
      FocusNode(debugLabel: '_descriptionFocusNode');

  final GlobalKey<FileLoaderState> loaderKey =
      GlobalKey<FileLoaderState>(debugLabel: 'loaderKey');
  final GlobalKey<DropdownSearchState> _vmcTypeDropDownKey =
      GlobalKey<DropdownSearchState>(debugLabel: 'vmcDropDownKey');

  VmcTypeEnum selectedVmcType = VmcTypeEnum.vendingMachine;

  /* final FocusNode _vmcWidthFocusNode =
      FocusNode(debugLabel: '_vmcWidthFocusNode');
  final FocusNode _vmcHeightFocusNode =
      FocusNode(debugLabel: '_vmcHeightFocusNode');
  final FocusNode _vmcDepthFocusNode =
      FocusNode(debugLabel: '_vmcDepthFocusNode');
  final FocusNode _drawerHeightFocusNode =
      FocusNode(debugLabel: '_drawerHeightFocusNode');
  final FocusNode _contentHeightFocusNode =
      FocusNode(debugLabel: '_contentHeightFocusNode');
  final FocusNode _contentWidthFocusNode =
      FocusNode(debugLabel: '_contentWidthFocusNode');
  final FocusNode _maxRowsFocusNode =
      FocusNode(debugLabel: '_maxRowsFocusNode');
  final FocusNode _maxWidthSpacesFocusNode =
      FocusNode(debugLabel: '_maxWidthSpacesFocusNode');*/
  final FocusNode _tickInSingleSpaceFocusNode =
      FocusNode(debugLabel: '_tickInSingleSpaceFocusNode');

  List<VmcSetting> selectableSettingFields = <VmcSetting>[];
  List<VmcSetting> selectedSettings = <VmcSetting>[];

  List<VmcProduction> selectableProductionFields = <VmcProduction>[];
  List<VmcProduction> selectedProductions = <VmcProduction>[];

  ///chiavi per i campi da compilare
  final GlobalKey _codeKey = GlobalKey(debugLabel: '_codeKey');
  final GlobalKey _descriptionKey = GlobalKey(debugLabel: '_descriptionKey');
  final GlobalKey _vmcWidthKey = GlobalKey(debugLabel: '_vmcWidthKey');
  final GlobalKey _vmcHeightKey = GlobalKey(debugLabel: '_vmcHeightKey');
  final GlobalKey _vmcDepthKey = GlobalKey(debugLabel: '_vmcDepthKey');
  final GlobalKey _drawerHeightKey = GlobalKey(debugLabel: '_drawerHeightKey');
  final GlobalKey _vmcTypeSettingKey =
      GlobalKey(debugLabel: '_vmcTypeSettingKey');
  final GlobalKey _contentHeightKey =
      GlobalKey(debugLabel: '_contentHeightKey');
  final GlobalKey _contentWidthKey = GlobalKey(debugLabel: '_contentWidthKey');
  final GlobalKey _maxRowsKey = GlobalKey(debugLabel: '_maxRowsKey');
  final GlobalKey _maxWidthSpaceKey =
      GlobalKey(debugLabel: '_maxWidthSpaceKey');
  final GlobalKey _tickInSingleSpaceKey =
      GlobalKey(debugLabel: '_tickInSingleSpaceKey');

  final GlobalKey _vmcSettingFieldKey =
      GlobalKey(debugLabel: '_vmcSettingFieldKey');
  final GlobalKey _fileSettingFieldKey =
      GlobalKey(debugLabel: '_fileSettingFieldKey');
  final GlobalKey _vmcProductionFieldKey =
      GlobalKey(debugLabel: '_vmcProductionFieldKey');

  final GlobalKey<DropdownSearchState> _vmcSettingFieldDropdownKey =
      GlobalKey(debugLabel: '_vmcSettingFieldDropdownKey');

  final GlobalKey<DropdownSearchState> _vmcProductionFieldDropdownKey =
      GlobalKey(debugLabel: '_vmcProductionFieldDropdownKey');

  late List<KeyValidationState> _keyStates;

  late List<VmcFile> selectedFiles = <VmcFile>[];

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///dati da salvare
  double vmcWidthValue = 0;
  double vmcHeightValue = 0;
  double vmcDepthValue = 0;
  double drawerHeightValue = 0;
  double contentHeightValue = 0;
  double contentWidthValue = 0;
  int maxRowsValue = 0;
  int maxWidthSpacesValue = 0;
  int tickInSingleSpaceValue = 0;

/*  ///gestione expansion panel
  bool _physicsPanelIsExpanded = true;
  bool _logicPanelIsExpanded = true;*/

  bool _validateCalled = false;
  bool _validateProductionCalled = false;
  bool _settingsLoaded = false;

  final GlobalKey<EditVmcExState> _editVmcKey =
      GlobalKey<EditVmcExState>(debugLabel: '_editVmcKey');

  @override
  void initState() {
    super.initState();
    initKeys();
    element = widget.element;
    _loadSettingFields();
    _loadProductionFields();

    settingFieldsController = TextEditingController();
    productionFieldsController = TextEditingController();

    if (element != null) {
      codeController = TextEditingController(text: element!.code);
      descriptionController = TextEditingController(text: element!.description);
      if (element!.vmcSettings != null) {
        selectedSettings = element!.vmcSettings!;
      }
      if (element!.vmcProductions != null) {
        selectedProductions = element!.vmcProductions!;
      }
      if (element!.vmcType != null) {
        selectedVmcType = element!.vmcType!;
      }
      vmcWidthValue = element!.vmcPhysicsConfiguration?.vmcWidthMm ?? 0.0;
      vmcHeightValue = element!.vmcPhysicsConfiguration?.vmcHeightMm ?? 0.0;
      vmcDepthValue = element!.vmcPhysicsConfiguration?.vmcDepthMm ?? 0.0;
      drawerHeightValue = element!.vmcPhysicsConfiguration?.drawerHeight ?? 0.0;
      contentHeightValue =
          element!.vmcPhysicsConfiguration?.contentHeight ?? 0.0;
      contentWidthValue = element!.vmcPhysicsConfiguration?.contentWidth ?? 0.0;
      maxRowsValue = element!.vmcConfiguration?.maxRows ?? 0;
      maxWidthSpacesValue = element!.vmcConfiguration?.maxWidthSpaces ?? 1;
      tickInSingleSpaceValue =
          element!.vmcConfiguration?.tickInSingleSpace ?? 4;

      selectedFiles = element!.vmcFiles ?? <VmcFile>[];
    } else {
      codeController = TextEditingController();
      descriptionController = TextEditingController();
      vmcWidthValue = 0.0;
      vmcHeightValue = 0.0;
      vmcDepthValue = 0.0;
      drawerHeightValue = 0.0;
      contentHeightValue = 0.0;
      contentWidthValue = 0.0;
      maxRowsValue = 8;
      maxWidthSpacesValue = 9;
      tickInSingleSpaceValue = 4;
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    descriptionController.dispose();
    _saveFocusNode.dispose();
    _codeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    productionFieldsController.dispose();
    try {
      settingFieldsController.dispose();
    } catch (e) {
      print(e);
    }
    //_widthFocusNode.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  _loadSettingFields() {
    var bloc = BlocProvider.of<ServerDataBloc<VmcSettingField>>(context);
    bloc.add(
        const ServerDataEvent<VmcSettingField>(status: ServerDataEvents.fetch));
  }

  _loadProductionFields() {
    var bloc = BlocProvider.of<ServerDataBloc<VmcProductionField>>(context);
    bloc.add(const ServerDataEvent<VmcProductionField>(
        status: ServerDataEvents.fetch));
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _codeKey),
      KeyValidationState(key: _descriptionKey),
      KeyValidationState(key: _vmcTypeDropDownKey),
      KeyValidationState(key: _vmcWidthKey),
      KeyValidationState(key: _vmcHeightKey),
      KeyValidationState(key: _vmcDepthKey),
      KeyValidationState(key: _drawerHeightKey),
      KeyValidationState(key: _contentHeightKey),
      KeyValidationState(key: _contentWidthKey),
      KeyValidationState(key: _maxRowsKey),
      KeyValidationState(key: _maxWidthSpaceKey),
      KeyValidationState(key: _tickInSingleSpaceKey),
      KeyValidationState(key: _vmcSettingFieldKey),
      KeyValidationState(key: _vmcProductionFieldKey),
    ];
  }

  InputDecoration _codeInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Codice', hintText: 'Inserisci il codice del modello');
  }

  InputDecoration _descriptionInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Descrizione',
        hintText: 'Inserisci la descrizione del modello');
  }

/*
  InputDecoration _vmcWidthInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Largezza in millimetri',
        hintText:
            'Inserisci la larghezza del distributore in millimetri (spazio utile)');
  }

  InputDecoration _vmcHeightInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Altezza in millimetri',
        hintText:
            'Inserisci l\'altezza  del distributore in millimetri (spazio utile)');
  }

  InputDecoration _vmcDepthInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Profondità in millimetri',
        hintText:
            'Inserisci la profondità  del distributore in millimetri (spazio utile)');
  }

  InputDecoration _drawerHeightInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Altezza cassetto in millimetri',
        hintText: 'Inserisci l\'altezza del cassetto in millimetri');
  }

  InputDecoration _contentHeightInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Spazio utile verticale cassetto in millimetri',
        hintText:
            'Inserisci l\'altezza dello spazio utile verticale a contenere un articolo nel cassetto');
  }

  InputDecoration _contentWidthInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Largezza singola spirale',
        hintText: 'Inserisci lo spazio orizzontale per singola selezione');
  }

  InputDecoration _maxRowsInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Numero massimo cassetti',
        hintText: 'Inserisci il numero massimo di cassetti disponibili');
  }

  InputDecoration _maxWidthSpacesInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Numero massimo motori',
        hintText: 'Inserisci il numero massimo dei motori per cassetto');
  }
*/

  InputDecoration _tickInSingleSpaceInputDecoration() {
    return textFieldInputDecoration(
        labelText: 'Numero suddivisioni singolo spazio',
        hintText:
            'Numero di suddivisioni in cui può essere divisa una singola selezione');
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return FocusScope(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Form(
                key: _formKey,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width > 1000
                        ? 900
                        : MediaQuery.of(context).size.width < 800
                            ? MediaQuery.of(context).size.width
                            : 800,
                    child: Column(
                      children: [
                        //if (widget.title != null) DialogTitle(widget.title!),

                        /*              panels(),
                        const Divider(),*/
                        Expanded(
                            child: EditVmcEx(
                              title: widget.title,
                          scrollController: _scrollController,
                          key: _editVmcKey,
                          vmcConfiguration: element?.vmcConfiguration,
                          vmcPhysicsConfiguration:
                              element?.vmcPhysicsConfiguration,
                          onSave: (values) {
                            editState = true;
                          },
                          showPhysicsSettings:
                              selectedVmcType == VmcTypeEnum.vendingMachine,
                          showLogicSettings:
                              selectedVmcType == VmcTypeEnum.vendingMachine,
                          textInputSettingsTileChildren: [
                            _codeSettingTile(),
                            _descriptionSettingTile(),
                            _vmcTypeSettingTile(),
                          ],
                          filesSettingsTileChildren: [
                            _filesSettingTile(),
                          ],
                          settingListSettingsTileChildren: [
                            _listSettingTile(),
                          ],
                          productionListSettingsTileChildren: [
                            _listProductionTile(),
                          ],
                        )),
                      ],
                    ))

              /*Container(
                  padding: const EdgeInsets.all(5),
                  constraints: BoxConstraints(
                      minWidth: isTinyWidth(context) ? 1200 : 1500),
                  //width: 500,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DialogTitle(widget.title!),
                        codeField(),
                        descriptionField(),
                        const Divider(),
                        EditVmcEx(vmcConfiguration: element?.vmcConfiguration, vmcPhysicsConfiguration: element?.vmcPhysicsConfiguration,),
                        //panels(),
                        const Divider(),
                        const DialogHeader("Selezioni disponibili"),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )*/
                ),
          ),
          OkCancel(
              okFocusNode: _saveFocusNode,
              onCancel: () {
                Navigator.maybePop(context, null);
              },
              onSave: () {
                validateSave();
              })
        ],
      ),
    );
  }

  SettingsTile _listSettingTile() {
    return getCustomSettingTile(
      title: 'Seleziona impostazioni',
      hint: 'Impostazioni',
      description:
          'Seleziona le impostazioni da compilare quando si configura un nuovo distributore',
      child: Container(key: _vmcSettingFieldKey, child: _settingsDropDown()),
    );
  }

  SettingsTile _listProductionTile() {
    return getCustomSettingTile(
      title: 'Seleziona operazioni',
      hint: 'Operazioni',
      description:
          'Seleziona le operazioni da compiere quando si configura un nuovo distributore',
      child:
          Container(key: _vmcProductionFieldKey, child: _productionsDropDown()),
    );
  }

  SettingsTile _filesSettingTile() {
    return getCustomSettingTile(
      title: 'Seleziona files',
      hint: 'Documenti',
      description: 'Seleziona i documenti da allegare a questo modello',
      child: Container(key: _fileSettingFieldKey, child: _fileLoader()),
    );
  }

/*
  Widget _getSettingItem(VmcSettingField item, bool showClearButton) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor.withAlpha(50)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category?.name ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(item.name!,
                      style: Theme.of(context).textTheme.headline6),
                ],
              ),
            ),
            if (showClearButton)
              IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close),
                onPressed: () {
                  List? items = _vmcSettingFieldDropdownKey
                      .currentState?.getSelectedItems;
                  if (items != null) {
                    items.removeWhere((element) =>
                        element.vmcSettingFieldId == item.vmcSettingFieldId);
                    _vmcSettingFieldDropdownKey.currentState
                        ?.changeSelectedItems(items);
                  }
                },
              )
          ],
        ),
      ),
    );
  }
*/

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
          key: loaderKey,
          showButtons: true,
          onLoaded: (List<MediaItem> values) {},
          itemFiles: selectedFiles.map((e) => e.toMediaItem()).toList()),
    );
  }

  Widget _settingsDropDown() {
    return BlocListener<ServerDataBloc<VmcSettingField>,
        ServerDataState<VmcSettingField>>(
      listener: (BuildContext context, ServerDataState<VmcSettingField> state) {
        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataInitState<VmcSettingField>) {}
            if (state is ServerDataLoading<VmcSettingField>) {}
            if (state is ServerDataLoaded<VmcSettingField>) {
              if (state.items != null && state.items is List<VmcSettingField>) {
                List<VmcSettingField> items =
                    state.items as List<VmcSettingField>;

                /*for(VmcSetting setting in selectedSettings){
                items.removeWhere((element) => element.vmcSettingFieldId==setting.settingField!.vmcSettingFieldId);
              }*/
                selectableSettingFields = items
                    .map((e) => VmcSetting(
                        vmcId: element?.vmcId ?? 0,
                        vmcSettingFieldId: e.vmcSettingFieldId,
                        settingField: e))
                    .toList(growable: false);
              }
            }
          default:
            break;
        }
      },
      child: BlocBuilder<ServerDataBloc<VmcSettingField>,
              ServerDataState<VmcSettingField>>(
          builder:
              (BuildContext context, ServerDataState<VmcSettingField> state) {
        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataInitState<VmcSettingField>) {
              return shimmerComboLoading(context,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
            }
            if (state is ServerDataLoading<VmcSettingField>) {
              return shimmerComboLoading(context,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
            }
            if (state is ServerDataLoaded<VmcSettingField>) {
              if (!_settingsLoaded) {
                _settingsLoaded = true;
              }
              /*if (state.items != null && state.items is List<VmcSettingField>) {
                vmcSettingFields = state.items as List<VmcSettingField>;
              }*/

              return Padding(
                padding: getPadding(),
                child: DropdownSearch<VmcSetting>.multiSelection(
                  key: _vmcSettingFieldDropdownKey,

/*                focusNode:
                      isWindows || isWindowsBrowser ? null : _categoriesFocusNode,*/
                  enabled: true,
                  //isEnabled(),
                  popupProps: PopupPropsMultiSelection.dialog(
                    containerBuilder: (context, child) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: child);
                    },
                    itemBuilder: (context, item, isSelected) {
                      return getSettingItem(item.settingField!,
                          context: context, showClearButton: false);
                    },
                    scrollbarProps: const ScrollbarProps(thickness: 0),
                    dialogProps: DialogProps(
                        backgroundColor: getAppBackgroundColor(context),
                        actions: [
                          TextButton(
                              child: const Text('Seleziona tutto'),
                              onPressed: () {
                                _vmcSettingFieldDropdownKey.currentState
                                    ?.popupSelectAllItems();
                              }),
                          TextButton(
                            child: const Text('Deseleziona tutto'),
                            onPressed: () {
                              _vmcSettingFieldDropdownKey.currentState
                                  ?.popupDeselectAllItems();
                            },
                          )
                        ]),
                    showSelectedItems: true,
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        autofocus: isWindows || isWindowsBrowser ? true : false,
                        //controller: settingFieldsController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Cerca")),
                    emptyBuilder: (context, searchEntry) =>
                        const Center(child: Text('Nessun risultato')),
                  ),
                  //popupBackgroundColor: getAppBackgroundColor(context),

                  compareFn: (item, selectedItem) =>
                      item.vmcSettingFieldId == selectedItem.vmcSettingFieldId,
                  //showClearButton: true,
                  clearButtonProps: const ClearButtonProps(isVisible: true),
                  itemAsString: (VmcSetting? c) =>
                      c?.settingField?.name ?? 'no name',
                  autoValidateMode: _validateCalled
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  selectedItems: selectedSettings,
                  onChanged: (List<VmcSetting>? newValue) {
                    editState = true;
                    setState(() {
                      selectedSettings = newValue ?? <VmcSetting>[];
                    });
                  },
                  dropdownBuilder: (context, List<VmcSetting> items) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          items.length,
                          (index) {
                            print("indice: $index");
                            return getSettingItem(items[index].settingField!,
                                dense: true,
                                context: context,
                                showClearButton: true,
                                onClearButtonPressed: () {
                              if (_vmcSettingFieldDropdownKey.currentState !=
                                  null) {
                                List<VmcSetting> newFields =
                                    (_vmcSettingFieldDropdownKey
                                                .currentState!.getSelectedItems
                                            as List<VmcSetting>)
                                        .where((element) =>
                                            element.vmcSettingFieldId !=
                                            items[index].vmcSettingFieldId)
                                        .toList();
                                _vmcSettingFieldDropdownKey.currentState
                                    ?.changeSelectedItems(newFields);
                                editState = true;
                              }
                            });
                          },
                        ));
                  },
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      //enabledBorder: OutlineInputBorder(),
                      isDense: true,
                      border: OutlineInputBorder(),
                      labelText: 'Impostazioni',
                      hintText:
                          'Seleziona tutte le impostazioni da compilare per questo modello',
                    ),
                  ),
                  validator: (item) {
                    if (_validateCalled == false) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        if (mounted) {
                          setState(() {
                            _validateCalled = true;
                          });
                        }
                      });
                    }
                    if (item == null || item.isEmpty) {
                      KeyValidationState state = _keyStates.firstWhere(
                          (element) => element.key == _vmcSettingFieldKey);
                      _keyStates[_keyStates.indexOf(state)] =
                          state.copyWith(state: false);
                      return "Campo obbligatorio";
                    } else {
                      KeyValidationState state = _keyStates.firstWhere(
                          (element) => element.key == _vmcSettingFieldKey);
                      _keyStates[_keyStates.indexOf(state)] =
                          state.copyWith(state: true);
                    }
                    return null;
                  },
                  items: selectableSettingFields,
                  filterFn: (VmcSetting item, String filter) {
                    String json = jsonEncode(item.settingField!.json);
                    String newString = json.removePunctuation();
                    debugPrint(newString);
                    String filterString = filter.removePunctuation();
                    return newString
                        .toLowerCase()
                        .contains(filterString.toLowerCase());
                  },
                ),
              );
            }
            if (state is ServerDataError<VmcSettingField>) {
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

  Widget _productionsDropDown() {
    return BlocListener<ServerDataBloc<VmcProductionField>,
        ServerDataState<VmcProductionField>>(
      listener:
          (BuildContext context, ServerDataState<VmcProductionField> state) {
        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataInitState<VmcProductionField>) {}
            if (state is ServerDataLoading<VmcProductionField>) {}
            if (state is ServerDataLoaded<VmcProductionField>) {
              if (state.items != null &&
                  state.items is List<VmcProductionField>) {
                List<VmcProductionField> items =
                    state.items as List<VmcProductionField>;

                /*for(VmcSetting setting in selectedSettings){
                items.removeWhere((element) => element.vmcSettingFieldId==setting.settingField!.vmcSettingFieldId);
              }*/
                selectableProductionFields = items
                    .map((e) => VmcProduction(
                        vmcId: element?.vmcId ?? 0,
                        vmcProductionFieldId: e.vmcProductionFieldId,
                        productionField: e))
                    .toList(growable: false);
              }
            }
          default:
            break;
        }
      },
      child: BlocBuilder<ServerDataBloc<VmcProductionField>,
              ServerDataState<VmcProductionField>>(
          builder: (BuildContext context,
              ServerDataState<VmcProductionField> state) {
        switch (state.event!.status) {
          case ServerDataEvents.fetch:
            if (state is ServerDataInitState<VmcProductionField>) {
              return shimmerComboLoading(context,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
            }
            if (state is ServerDataLoading<VmcProductionField>) {
              return shimmerComboLoading(context,
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
            }
            if (state is ServerDataLoaded<VmcProductionField>) {
              if (!_settingsLoaded) {
                _settingsLoaded = true;
              }
              /*if (state.items != null && state.items is List<VmcSettingField>) {
                vmcSettingFields = state.items as List<VmcSettingField>;
              }*/

              return Padding(
                padding: getPadding(),
                child: DropdownSearch<VmcProduction>.multiSelection(
                  key: _vmcProductionFieldDropdownKey,

/*                focusNode:
                      isWindows || isWindowsBrowser ? null : _categoriesFocusNode,*/
                  enabled: true,
                  //isEnabled(),
                  popupProps: PopupPropsMultiSelection.dialog(
                    containerBuilder: (context, child) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: child);
                    },
                    itemBuilder: (context, item, isSelected) {
                      return getProductionItem(item.productionField!,
                          context: context, showClearButton: false);
                    },
                    scrollbarProps: const ScrollbarProps(thickness: 0),
                    dialogProps: DialogProps(
                        backgroundColor: getAppBackgroundColor(context),
                        actions: [
                          TextButton(
                              child: const Text('Seleziona tutto'),
                              onPressed: () {
                                _vmcProductionFieldDropdownKey.currentState
                                    ?.popupSelectAllItems();
                              }),
                          TextButton(
                            child: const Text('Deseleziona tutto'),
                            onPressed: () {
                              _vmcProductionFieldDropdownKey.currentState
                                  ?.popupDeselectAllItems();
                            },
                          )
                        ]),
                    showSelectedItems: true,
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        autofocus: isWindows || isWindowsBrowser ? true : false,
                        //controller: productionFieldsController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Cerca")),
                    emptyBuilder: (context, searchEntry) =>
                        const Center(child: Text('Nessun risultato')),
                  ),
                  //popupBackgroundColor: getAppBackgroundColor(context),

                  compareFn: (item, selectedItem) =>
                      item.vmcProductionFieldId ==
                      selectedItem.vmcProductionFieldId,
                  //showClearButton: true,
                  clearButtonProps: const ClearButtonProps(isVisible: true),
                  itemAsString: (VmcProduction? c) =>
                      c?.productionField?.name ?? 'no name',
                  autoValidateMode: _validateProductionCalled
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  selectedItems: selectedProductions,
                  onChanged: (List<VmcProduction>? newValue) {
                    editState = true;
                    setState(() {
                      selectedProductions = newValue ?? <VmcProduction>[];
                    });
                  },
                  dropdownBuilder: (context, List<VmcProduction> items) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          items.length,
                          (index) => getProductionItem(
                              dense: true,
                              items[index].productionField!,
                              context: context,
                              showClearButton: true, onClearButtonPressed: () {
                            if (_vmcProductionFieldDropdownKey.currentState !=
                                null) {
                              List<VmcProduction> newFields =
                                  (_vmcProductionFieldDropdownKey
                                              .currentState!.getSelectedItems
                                          as List<VmcProduction>)
                                      .where((element) =>
                                          element.vmcProductionFieldId !=
                                          items[index].vmcProductionFieldId)
                                      .toList();
                              _vmcProductionFieldDropdownKey.currentState
                                  ?.changeSelectedItems(newFields);
                              editState = true;
                            }
                          }),
                        ));
                  },
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      //enabledBorder: OutlineInputBorder(),
                      isDense: true,
                      border: OutlineInputBorder(),
                      labelText: 'Operazioni',
                      hintText:
                          'Seleziona tutte le operazioni da compiere per preparare questo modello',
                    ),
                  ),
                  validator: (item) {
                    if (_validateProductionCalled == false) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        if (mounted) {
                          setState(() {
                            _validateProductionCalled = true;
                          });
                        }
                      });
                    }
                    if (item == null || item.isEmpty) {
                      KeyValidationState state = _keyStates.firstWhere(
                          (element) => element.key == _vmcProductionFieldKey);
                      _keyStates[_keyStates.indexOf(state)] =
                          state.copyWith(state: false);
                      return "Campo obbligatorio";
                    } else {
                      KeyValidationState state = _keyStates.firstWhere(
                          (element) => element.key == _vmcProductionFieldKey);
                      _keyStates[_keyStates.indexOf(state)] =
                          state.copyWith(state: true);
                    }
                    return null;
                  },
                  items: selectableProductionFields,
                  filterFn: (VmcProduction item, String filter) {
                    String json = jsonEncode(item.productionField!.json);
                    String newString = json.removePunctuation();
                    debugPrint(newString);
                    String filterString = filter.removePunctuation();
                    return newString
                        .toLowerCase()
                        .contains(filterString.toLowerCase());
                  },
                ),
              );
            }
            if (state is ServerDataError<VmcProductionField>) {
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

  SettingsTile _codeSettingTile() {
    return getCustomSettingTile(
        key: _codeKey,
        title: 'Inserisci codice',
        hint: 'Codice',
        description: 'Codice identificativo modello distributore',
        child: codeField());
  }

  SettingsTile _vmcTypeSettingTile() {
    return getCustomSettingTile(
        key: _vmcTypeSettingKey,
        title: 'Seleziona tipo',
        hint: 'Tipo macchina',
        description:
            'Seleziona il tipo macchina. Utilizzare \'Distributore\' per i distributori e \'Altro\' per tutto il resto.',
        child: vmcTypeDropDown());
  }

  Widget vmcTypeDropDown() {
    return Padding(
      padding: getPadding(),
      child: DropdownSearch<VmcTypeEnum>(
        key: _vmcTypeDropDownKey,
        popupProps: PopupProps.menu(
          scrollbarProps: const ScrollbarProps(thickness: 0),
          menuProps: MenuProps(backgroundColor: getAppBackgroundColor(context)),
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
        compareFn: (item, selectedItem) => item.index == selectedItem.index,
        clearButtonProps: const ClearButtonProps(isVisible: true),
        itemAsString: (VmcTypeEnum? c) => (c?.index ?? -1) == -1
            ? 'Sconosciuto'
            : (c?.index ?? -1) == 0
                ? 'Distributore'
                : (c?.index ?? -1) == 1
                    ? 'Altro'
                    : 'Sconosciuto',
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectedItem: selectedVmcType,
        onChanged: (VmcTypeEnum? newValue) {
          editState = true;

          setState(() {
            if (newValue != null) {
              if (selectedVmcType.index != newValue.index) {
                selectedVmcType = newValue;
              }
            } else {
              selectedVmcType = VmcTypeEnum.vendingMachine;
            }
          });
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            //enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            labelText: 'Tipo macchina',
            hintText: 'Seleziona un tipo macchina',
          ),
        ),
        validator: (item) {
          if (item == null) {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _vmcTypeDropDownKey);
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _vmcTypeDropDownKey);
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        items: VmcTypeEnum.values,
        filterFn: (VmcTypeEnum? item, String? filter) {
          String searchText = item?.name ?? '';

          String filterString = filter?.removePunctuation() ?? '';
          return searchText.toLowerCase().contains(filterString.toLowerCase());
        },
      ),
    );
  }

  SettingsTile _descriptionSettingTile() {
    return getCustomSettingTile(
        key: _descriptionKey,
        title: 'Inserisci descrizione',
        hint: 'Descrizione',
        description: 'Descrizione modello distributore',
        child: descriptionField());
  }

  void generateLogicValues() {
    setState(() {
      maxRowsValue = drawerHeightValue != 0
          ? (vmcHeightValue / drawerHeightValue).truncate()
          : 0;
      maxWidthSpacesValue = contentWidthValue != 0
          ? (vmcWidthValue / contentWidthValue).truncate()
          : 0;
      tickInSingleSpaceValue = 2;
    });
  }

/*  Widget verticalPanels() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: MultiExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            switch (panelIndex) {
              case 0: //fisici
                _physicsPanelIsExpanded = !_physicsPanelIsExpanded;
                break;
              case 1: //logici
                _logicPanelIsExpanded = !_logicPanelIsExpanded;
                break;
            }

            setState(() {});
          },
          children: [
            MultiExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: _physicsPanelIsExpanded,
                canTapOnHeader: false,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const SizedBox(
                      height: 80, child: DialogHeader("Parametri fisici"));
                },
                body: Column(
                  children: [
                    vmcWidthField(),
                    vmcHeightField(),
                    vmcDepthField(),
                    drawerHeightField(),
                    contentHeightField(),
                    contentWidthField(),
                  ],
                )),
            MultiExpansionPanel(
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
                )),
          ],
        ),
      ),
    );
  }*/

/*  Widget horizontalPanels() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MultiExpansionPanelList(
                animationDuration: const Duration(milliseconds: 500),
                elevation: 0,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (panelIndex, isExpanded) {
                  switch (panelIndex) {
                    case 0: //fisici
                      _physicsPanelIsExpanded = !_physicsPanelIsExpanded;
                      break;
                  }

                  setState(() {});
                },
                children: [
                  MultiExpansionPanel(
                      backgroundColor: Colors.transparent,
                      isExpanded: _physicsPanelIsExpanded,
                      canTapOnHeader: false,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return const SizedBox(
                            height: 80,
                            child: DialogHeader("Parametri fisici"));
                      },
                      body: Column(
                        children: [
                          vmcWidthField(),
                          vmcHeightField(),
                          vmcDepthField(),
                          drawerHeightField(),
                          contentHeightField(),
                          contentWidthField(),
                        ],
                      )),
                ],
              ),
            ),
            Expanded(
              child: MultiExpansionPanelList(
                animationDuration: const Duration(milliseconds: 500),
                expandedHeaderPadding: EdgeInsets.zero,
                elevation: 0,
                expansionCallback: (panelIndex, isExpanded) {
                  switch (panelIndex) {
                    case 0: //logici
                      _logicPanelIsExpanded = !_logicPanelIsExpanded;
                      break;
                  }

                  setState(() {});
                },
                children: [
                  MultiExpansionPanel(
                      backgroundColor: Colors.transparent,
                      isExpanded: _logicPanelIsExpanded,
                      canTapOnHeader: false,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return const SizedBox(
                            height: 80,
                            child: DialogHeader("Parametri logici"));
                      },
                      body: Column(
                        children: [
                          generateButton(),
                          maxRowsField(),
                          maxWidthSpacesField(),
                          tickInSingleSpaceField(),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  /*Widget panels() {
    if (MediaQuery.of(context).size.width <= 700) {
      return verticalPanels();
    } else {
      return horizontalPanels();
    }
  }*/

  Widget generateButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 64.0, right: 16.0, bottom: 32.0),
      child: Center(
          child: ElevatedButton(
        onPressed: () => generateLogicValues(),
        child: const Text(
          "GENERA DA PARAMETRI FISICI",
          textAlign: TextAlign.center,
        ),
      )),
    );
  }

  Widget codeField() {
    return Padding(
      padding: getPadding(),
      child: TextFormField(
        focusNode: _codeFocusNode,
        maxLines: null,
        //autofocus: isDesktop ? true : false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: codeController,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _codeInputDecoration(),
        validator: (str) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == _codeKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
      ),
    );
  }

  Widget descriptionField() {
    return Padding(
      padding: getPadding(),
      child: TextFormField(
        /*fieldKey: _descriptionKey,*/
        focusNode: _descriptionFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: descriptionController,
        textInputAction: TextInputAction.next,
        maxLength: 500,
        onChanged: (value) => editState = true,
        decoration: _descriptionInputDecoration(),
        validator: (str) {
          KeyValidationState state = _keyStates
              .firstWhere((element) => element.key == _descriptionKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        onFieldSubmitted: (str) {
          _saveFocusNode.requestFocus();
        },
      ),
    );
  }

  /*Widget vmcWidthField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.expand),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _vmcWidthKey,
              max: 100000,
              min: 1,
              acceleration: 1,
              step: 1,
              value: vmcWidthValue,
              focusNode: _vmcWidthFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                vmcWidthValue = value;
              },
              decoration: _vmcWidthInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _vmcWidthKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget vmcHeightField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.expand),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _vmcHeightKey,
              max: 100000,
              min: 1,
              value: vmcHeightValue,
              acceleration: 1,
              step: 1,
              focusNode: _vmcHeightFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                vmcHeightValue = value;
              },
              decoration: _vmcHeightInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _vmcHeightKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget vmcDepthField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.keyboard_double_arrow_right),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _vmcDepthKey,
              max: 100000,
              min: 1,
              acceleration: 1,
              step: 1,
              value: vmcDepthValue,
              focusNode: _vmcDepthFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                vmcDepthValue = value;
              },
              decoration: _vmcDepthInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _vmcDepthKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerHeightField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.keyboard_double_arrow_right),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _drawerHeightKey,
              max: 100000,
              min: 1,
              acceleration: 1,
              step: 1,
              value: drawerHeightValue,
              focusNode: _drawerHeightFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                drawerHeightValue = value;
              },
              decoration: _drawerHeightInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _drawerHeightKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget contentHeightField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.keyboard_double_arrow_right),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _contentHeightKey,
              max: 100000,
              min: 1,
              acceleration: 1,
              step: 1,
              value: contentHeightValue,
              focusNode: _contentHeightFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                contentHeightValue = value;
              },
              decoration: _contentHeightInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _contentHeightKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget contentWidthField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.keyboard_double_arrow_right),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _contentWidthKey,
              max: 100000,
              min: 1,
              acceleration: 1,
              step: 1,
              value: contentWidthValue,
              focusNode: _contentWidthFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                contentWidthValue = value;
              },
              decoration: _contentWidthInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _contentWidthKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget maxRowsField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.keyboard_double_arrow_right),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _maxRowsKey,
              max: 99,
              min: 1,
              acceleration: 1,
              step: 1,
              value: maxRowsValue.toDouble(),
              focusNode: _maxRowsFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                maxRowsValue = value.toInt();
              },
              decoration: _maxRowsInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _maxRowsKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget maxWidthSpacesField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.keyboard_double_arrow_right),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _maxWidthSpaceKey,
              max: 99,
              min: 1,
              acceleration: 1,
              step: 1,
              value: maxWidthSpacesValue.toDouble(),
              focusNode: _maxWidthSpacesFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                maxWidthSpacesValue = value.toInt();
              },
              decoration: _maxWidthSpacesInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _maxWidthSpaceKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }*/

  EdgeInsets getPadding() {
    if (MediaQuery.of(context).size.width > 1000) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    } else {
      return const EdgeInsets.symmetric(horizontal: 0, vertical: 8);
    }
  }

  Widget tickInSingleSpaceField() {
    return Padding(
      padding: getPadding(),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.keyboard_double_arrow_right),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: SpinBox(
              key: _tickInSingleSpaceKey,
              max: 99,
              min: 1,
              acceleration: 1,
              step: 1,
              value: tickInSingleSpaceValue.toDouble(),
              focusNode: _tickInSingleSpaceFocusNode,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editState = true;
                tickInSingleSpaceValue = value.toInt();
              },
              decoration: _tickInSingleSpaceInputDecoration(),
              validator: (str) {
                KeyValidationState state = _keyStates.firstWhere(
                    (element) => element.key == _tickInSingleSpaceKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /*void validateSave() {
    if (_formKey.currentState!.validate()) {
      if (element == null) {
        List? vmcConfig = _editVmcKey.currentState?.vmcConfig;
        element = Vmc(
            vmcId: 0,
            code: codeController.text,
            description: descriptionController.text,
            vmcPhysicsConfigurationId: 0,
            vmcPhysicsConfiguration:


            VmcPhysicsConfiguration(
                vmcPhysicsConfigurationId: 0,
                vmcWidthMm: vmcWidthValue,
                vmcDepthMm: vmcDepthValue,
                vmcHeightMm: vmcHeightValue,
                drawerHeight: drawerHeightValue,
                contentHeight: contentHeightValue,
                contentWidth: contentWidthValue),
            vmcConfigurationId: 0,
            vmcConfiguration: VmcConfiguration(
                vmcConfigurationId: 0,
                maxRows: maxRowsValue,
                maxWidthSpaces: maxWidthSpacesValue,
                tickInSingleSpace: tickInSingleSpaceValue));
      } else {
        element = element!.copyWith(
            code: codeController.text,
            description: descriptionController.text,
            vmcConfiguration: element!.vmcConfiguration?.copyWith(
                maxRows: maxRowsValue,
                maxWidthSpaces: maxWidthSpacesValue,
                tickInSingleSpace: tickInSingleSpaceValue),
            vmcPhysicsConfiguration: element!.vmcPhysicsConfiguration?.copyWith(
                vmcWidthMm: vmcWidthValue,
                vmcDepthMm: vmcDepthValue,
                vmcHeightMm: vmcHeightValue,
                drawerHeight: drawerHeightValue,
                contentHeight: contentHeightValue,
                contentWidth: contentWidthValue));
      }
      Navigator.pop(context, element);
    } else {
      try {
        KeyValidationState state =
        _keyStates.firstWhere((element) => element.state == false);

        _scrollController.position.ensureVisible(
          state.key.currentContext!.findRenderObject()!,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }*/

  bool _save() {
    try {
      List? vmcConfig = _editVmcKey.currentState?.vmcConfig;

      List<VmcFile> itemFiles = <VmcFile>[];

      if (loaderKey.currentState != null &&
          loaderKey.currentState!.selectedFiles != null) {
        for (var file in loaderKey.currentState!.selectedFiles!) {
          VmcFile itemFile = file.toVmcFile().copyWith(
              vmcId: element?.vmcId ?? 0,
              file: file.media!.copyWith(mediaId: file.media?.mediaId ?? 0));
          itemFiles.add(itemFile);
        }
      }

      ///rimuovo la categoria per poterlo salvare senza errori
      for (int index = 0; index < selectedSettings.length; index++) {
        VmcSetting setting = selectedSettings[index];
        setting = setting.copyWith(settingField: null);
        selectedSettings[index] = setting;
      }

      ///rimuovo la categoria per poterlo salvare senza errori
      for (int index = 0; index < selectedProductions.length; index++) {
        VmcProduction production = selectedProductions[index];
        production = production.copyWith(productionField: null);
        selectedProductions[index] = production;
      }

      if (element == null) {
        element = Vmc(
          vmcId: 0,
          code: codeController.text,
          description: descriptionController.text,
          vmcPhysicsConfigurationId: 0,
          vmcPhysicsConfiguration:
              (vmcConfig?[0] as VmcPhysicsConfiguration).copyWith(),
          vmcConfigurationId: 0,
          vmcConfiguration: (vmcConfig?[1] as VmcConfiguration).copyWith(),
          vmcSettings: selectedSettings,
          vmcFiles: itemFiles,
          vmcProductions: selectedProductions,
          vmcType: selectedVmcType,
        );
      } else {
        element = element!.copyWith(
          code: codeController.text,
          description: descriptionController.text,
          vmcPhysicsConfiguration:
              (vmcConfig?[0] as VmcPhysicsConfiguration).copyWith(),
          vmcConfiguration: (vmcConfig?[1] as VmcConfiguration).copyWith(),
          vmcSettings: selectedSettings,
          vmcFiles: itemFiles,
          vmcProductions: selectedProductions,
          vmcType: selectedVmcType,
        );
      }

      if (widget.saveDirectly) {
        _saveVmc(element!);
      }
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void validateSave() {
    if (!_settingsLoaded) {
      return;
    }

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
      try {
        KeyValidationState state =
            _keyStates.firstWhere((element) => element.state == false);
        Scrollable.ensureVisible(state.key.currentContext!,
            duration: const Duration(milliseconds: 500));
        /*_scrollController.position.ensureVisible(
          state.key.currentContext!.findRenderObject()!,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          targetRenderObject:state.key.currentContext!.findRenderObject()!,
        );*/
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  _saveVmc(Vmc item) {
    var bloc = BlocProvider.of<ServerDataBloc<Vmc>>(context);
    bloc.add(ServerDataEvent<Vmc>(
      status: ServerDataEvents.update,
      keyName: 'vmcId',
      item: item,
    ));
  }
}
