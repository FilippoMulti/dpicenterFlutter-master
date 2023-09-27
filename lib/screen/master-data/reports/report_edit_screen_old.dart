import 'dart:convert';

import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/locals/multi_point_list.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/application_user_detail.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/intervention_cause.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:dpicenter/models/server/report_detail_hashtag.dart';
import 'package:dpicenter/models/server/report_user.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/application_users/application_user_global.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtag_global.dart';
import 'package:dpicenter/screen/master-data/reports/report_edit_summary.dart';
import 'package:dpicenter/screen/master-data/reports/report_screen_ex.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/date_time_picker_multi.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/signature_dialog.dart';
import 'package:dpicenter/screen/widgets/signature_form_field.dart';
import 'package:dpicenter/screen/widgets/signature_multi.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dpicenter/signature/signature_info.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// Define a custom Form widget.
class ReportEditForm extends StatefulWidget {
  final Report? element;
  final bool readonly;

  const ReportEditForm({Key? key, required this.element, this.readonly = false})
      : super(key: key);

  @override
  ReportEditFormState createState() {
    return ReportEditFormState();
  }
}

class ReportEditFormState extends State<ReportEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///data selezionata
  DateTime selectedDate = DateTime.now();

  ///Controller per data di inizio
  late TextEditingController _selectedDateController;

  ///data selezionata formattata secondo il Locale di default del sistema
  String selectedFormattedDate = "";

  ///lista dei clienti tra cui selezionare (utilizzo Machine perchè mi interessano solo i clienti che hanno un distributore)
  List<Customer>? customers = <Customer>[];

  ///lista dei motivi di intervento tra cui selezionare
  List<InterventionCause>? interventionCauses = <InterventionCause>[];

  ///item da creare/modificare
  Report? element;

  ///cliente selezionato
  Customer? selectedCustomer;

  ///motivo intervento selezionato
  InterventionCause? selectedInterventionCause;

  ///lista dei lavori eseguiti
  List<ReportDetail>? details = <ReportDetail>[];

  ///dettaglio lavoro selezionato
  ReportDetail? selectedReportDetail;

  ///operatori selezionati
  List<ReportUser>? selectedOperators;

  ///operatori selezionati
  List<ApplicationUser>? operators;

  ///stato report
  int? status;

  ///macchine scaricate, utilizzate per trovare i clienti e passare le macchine del cliente alla ReportEditSummary
  List<Machine>? machines;

  ///chiave per la gestione dei summary
  GlobalKey<ReportEditSummaryFormState>? editSummaryFormKey;

  ///chiave per la dell fab quando la lista è vuota
  final GlobalKey _emptyFloatingButtonKey =
      GlobalKey(debugLabel: 'EmptyFloatingButtonKey');

/*
  ///Customer focus node (utile per scrollare fino al campo in caso di errore. EDIT: purtroppo non funziona correttamente a causa di un problema in flutter, c'è un issue aperto a riguardo)
  final FocusNode customerFocusNode = FocusNode(debugLabel: "customerFocusNode");
  FocusNode? operatorsFocusNode;
*/

  final TextEditingController _searchCustomerController =
      TextEditingController();
  final TextEditingController _searchInterventionCausesController =
      TextEditingController();
  final TextEditingController _searchOperatorsController =
      TextEditingController();

  /*late Signature _signatureCanvas;*/

  //late ScrollController _summaryListScrollController;
  late SignatureController _signatureController;

  ///vecchia lista punti prima della modifica
  late List<Point> oldSignaturePoints;

  ///gestisce lo stato di validazione di SignatureFormField
  bool validateCalled = false;
  SignatureEditingController? _signatureEditingController;
  TextEditingController? _signatureTextController;

  final ScrollController _scrollController =
      ScrollController(debugLabel: 'ScrollController');

  ///chiavi per i campi da compilare
  final GlobalKey _customerDropDownKey =
      GlobalKey(debugLabel: 'CustomerDropDownKey');
  final GlobalKey _interventionCauseDropDownKey =
      GlobalKey(debugLabel: 'InterventionCauseDropDownKey');
  final GlobalKey _operatorsDropDownKey =
      GlobalKey(debugLabel: 'OperatorsDropDownKey');
  final GlobalKey _signatureFieldKey =
      GlobalKey(debugLabel: 'SignatureFieldKey');
  late List<KeyValidationState> _keyStates;

  final FocusNode _customerFocusNode =
      FocusNode(debugLabel: '_customerFocusNode');
  final FocusNode _interventionCauseFocusNode =
      FocusNode(debugLabel: '_interventionCauseFocusNode');
  final FocusNode _operatorsFocusNode =
      FocusNode(debugLabel: '_operatorsFocusNode');

  ///altre chiavi
  final GlobalKey _signatureKey = GlobalKey(debugLabel: "SignatureKey");

  final GlobalKey _signatureCaptionTextKey =
      GlobalKey(debugLabel: "SignatureCaptionTextKey");

  final GlobalKey _summaryListContainerKey =
      GlobalKey(debugLabel: "SummaryListContainerKey");

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  @override
  void initState() {
    super.initState();

    initKeys();

    ///creo una copia dell'elemento in modo da poter annullare le modifiche
    ///in caso l'utente decida di non salvare
    try {
      element = widget.element?.copyWith();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (kDebugMode) {
      print(element.hashCode.toString());
    }
    if (element == null) {
      _selectedDateController =
          TextEditingController(text: selectedDate.toString());

      if (selectedOperators == null || selectedOperators!.isEmpty) {
        int? currentUserId = prefs!.getInt(applicationUserIdSetting);
        String? currentUserName = prefs!.getString(usernameSetting);

        selectedOperators = <ReportUser>[
          ReportUser(
              applicationUserId: currentUserId,
              reportId: 0,
              reportUserId: 0,
              applicationUser: ApplicationUser(
                  applicationUserId: currentUserId, userName: currentUserName))
        ];
      }
      _signatureTextController = TextEditingController();
    } else {
      selectedDate = DateTime.parse(element!.creationDate!);
      _selectedDateController =
          TextEditingController(text: selectedDate.toString());

      selectedInterventionCause = element!.interventionCause!;
      selectedCustomer = element!.customer!;
      selectedOperators = element!.reportUsers!;
      /* .map((e) => e.applicationUser)
          .cast<ApplicationUser>()
          .toList();*/
      details = element!.reportDetails
          ?.map((e) => e.copyWith())
          .cast<ReportDetail>()
          .toList();

      // Initialise a controller. It will contains signature points, stroke width and pen color.
      // It will allow you to interact with the widget
      _signatureTextController =
          TextEditingController(text: element?.referent ?? '');
    }

    // Initialise a controller. It will contains signature points, stroke width and pen color.
    // It will allow you to interact with the widget

    _signatureController = SignatureController(
        penStrokeWidth: 1,
        penColor: Colors.black,
        exportBackgroundColor: Colors.transparent,
        points: element != null
            ? MultiPointList.fromZippedString(element!.signaturePoints!)
                .toPoints()
            : null);

    signatureInfo = element != null && element!.signature != null
        ? SignatureInfo(
            signature: base64Decode(element!.signature!),
            contactPerson: element?.referent)
        : const SignatureInfo();
    _signatureEditingController =
        SignatureEditingController(info: signatureInfo);

    //_summaryListScrollController = ScrollController(debugLabel: "summaryListScrollController");
    /*   ///formattazione della data secondo la cultura corrente
    try {

_formatDate();


  prefs!.setInt(ApplicationUserIdSetting, applicationUserId ?? -1);
    prefs!.setString(UsernameSetting, name ?? "");

    } catch (e) {
      print(e);
    }*/
    //element = widget.element;
    Future.delayed(const Duration(milliseconds: 300), () {
      _loadCustomers();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _loadInterventionCauses();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _loadSummaryList();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _loadOperators();
    });
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _customerDropDownKey),
      KeyValidationState(key: _interventionCauseDropDownKey),
      KeyValidationState(key: _operatorsDropDownKey),
      KeyValidationState(key: _signatureFieldKey)
    ];
  }

  /*_formatDate(){
    Future.sync(() => initializeDateFormatting(Intl.defaultLocale!, null));
    selectedFormattedDate = DateFormat.yMMMMd().format(selectedDate);
  }*/
  _loadCustomers() {
    var bloc = BlocProvider.of<ServerDataBloc<Machine>>(context);
    bloc.add(const ServerDataEvent<Machine>(status: ServerDataEvents.fetch));
  }

  _loadOperators() {
    var bloc = BlocProvider.of<ServerDataBloc<ApplicationUser>>(context);
    bloc.add(
        const ServerDataEvent<ApplicationUser>(status: ServerDataEvents.fetch));
  }

  _loadInterventionCauses() {
    var bloc = BlocProvider.of<ServerDataBloc<InterventionCause>>(context);
    bloc.add(const ServerDataEvent<InterventionCause>(
        status: ServerDataEvents.fetch));
  }

  _loadSummaryList() {
    var bloc = BlocProvider.of<ServerDataBloc<ReportDetail>>(context);
    bloc.add(const ServerDataEvent<ReportDetail>(
        status: ServerDataEvents.fetch, withComplete: true));
  }

  double canvasHeight = 300;
  double canvasWidth = 600;
  double dividerWidth = 0;

  @override
  void didChangeDependencies() {
    var mediaData = MediaQuery.of(context);
    final double newWidth =
        mediaData.size.width >= 600 ? 600 : mediaData.size.width - 10;
    final double newHeight = canvasWidth < 600 ? canvasWidth / 2 : 300;

    setState(() {
      dividerWidth = MediaQuery.of(context).size.width - 400;
      canvasWidth = newWidth;
      canvasHeight = newHeight;
    });

    super.didChangeDependencies();
  }

  ///richiesta chiusura intervento
  ///
  bool _closeIntervention = false;

  @override
  Widget build(BuildContext context) {
    //operatorsFocusNode = FocusNode(debugLabel: "operatorsFocusNode");

    // Build a Form widget using the _formKey created above.

    // ///idealmente la dimensione per la firma è w600 x h300
    // ///se la dimensione orrizzontale è < 600, l'altezza sarà uguale a width\2
    // _signatureCanvas = Signature(
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(20), color: Colors.white),
    //   controller: _signatureController,
    //   backgroundColor: Colors.white,
    //   width: canvasWidth,
    //   height: canvasHeight,
    // );

    ///form contenente i dati da compilare

    return FocusScope(
      child: Container(
        color: getAppBackgroundColor(context),
        child: Column(
          children: [
            Expanded(
                child: Scaffold(
              backgroundColor: getAppBackgroundColor(context),
              body: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

                    ///permette al widget di essere scrollato
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dateSelect(),
                          const Divider(),
                          _customerDropDown(),
                          _interventionCauseDropDown(),
                          _operatorsDropDown(),
                          const Divider(),
                          _interventionSummaryList(),
                          const Divider(),
                          //_signatureRequest(),
                          !_closeIntervention &&
                                  !(element != null &&
                                      element!.status == Status.closed.index) &&
                                  !(signatureInfo != null &&
                                      signatureInfo!.signature != null)
                              ? _closeRequest()
                              : _signatureRequest(),
                        ],
                      ),
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            //const Divider(),
            OkCancel(
                onCancel: () {
                  Navigator.maybePop(context, null);
                },
                onSave: widget.readonly
                    ? null
                    : () {
                        validateSave();
                      })
          ],
        ),
      ),
    );
  }

  SignatureInfo? signatureInfo;

  Widget _signatureRequest() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ///se il documento non è chiuso definitivamente,
            ///mostro la possibilità di annullare la chiusura richiesta
            if ((element != null && element!.status == Status.closed.index) ==
                false)
              _closeSignatureRequest(),

            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: getCurrentCalcThemeMode(context) == ThemeMode.light
                        ? Theme.of(context).textTheme.bodySmall!.color!
                        : Colors.grey,
                  )),
              child: Center(
                child: Column(
                  children: [
                    ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 250,
                          minWidth: 400,
                          maxHeight: 250.0,
                          maxWidth: 400.0,
                        ),
                        child: SignatureFormField(
                          key: _signatureFieldKey,
                          autovalidateMode: validateCalled
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          signatureController: _signatureEditingController,
                          controller: _signatureTextController,
                          decoration: const InputDecoration(
                            //enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                            labelText: 'Referente',
                            hintText: 'Inserisci nome e cognome del referente',
                          ),
                          onChanged: (value) => editState = true,
                          validator: (info) {
                            if (info != null) {
                              ///ne tengo traccia per abilitare l'autovalidazione solo se in precedenza è stata eseguita almeno una validazione
                              validateCalled = true;

                              KeyValidationState state = _keyStates.firstWhere(
                                  (element) =>
                                      element.key == _signatureFieldKey);
                              _keyStates[_keyStates.indexOf(state)] =
                                  state.copyWith(state: false);

                              if (info.contactPerson?.isEmpty ?? true) {
                                return "Inserire nome e cognome per il referente";
                              }
                              if (info.signature?.isEmpty ?? true) {
                                return "Far firmare l'intervento";
                              }
                            } else {
                              KeyValidationState state = _keyStates.firstWhere(
                                  (element) =>
                                      element.key == _signatureFieldKey);
                              _keyStates[_keyStates.indexOf(state)] =
                                  state.copyWith(state: true);
                            }
                            return null;
                          },
                        )),
                    /*signatureImage == null
                        ? Container()
                        : Container(
                            width: 300,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.memory(signatureImage!,
                                  fit: BoxFit.scaleDown),
                            )),*/
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          oldSignaturePoints = _signatureController.points
                              .map((e) => Point(e.offset, e.type))
                              .toList();

                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight
                          ]);
                          await showDialog(
                              useSafeArea: false,
                              context: context,
                              builder: (BuildContext ctx) {
                                return StatefulBuilder(
                                    builder: (context, state) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    titlePadding: EdgeInsets.zero,
                                    insetPadding: EdgeInsets.zero,
                                    shape: getBorderShape(),
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Firma intervento",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                    content: Builder(builder: (context) {
                                      //var height = MediaQuery.of(context).size.height;
                                      //var width = MediaQuery.of(context).size.width;
                                      return SignatureDialog(
                                        key: _signatureKey,
                                        startWidth: canvasWidth,
                                        startHeight: canvasHeight,
                                        controller: _signatureController,
                                      );
                                      /*return SizedBox(
                                      height: canvasHeight,
                                      width: canvasWidth,
                                      child: Center(
                                          child: Column(children: [
                                            _signatureCanvas,
                                          ],)
                                      )
                                  );*/
                                    }),

                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _signatureController.points =
                                                  oldSignaturePoints;
                                            });

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Annulla")),
                                      ElevatedButton(
                                          onPressed: () {
                                            _signatureController.clear();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.yellow),
                                          child: const Text("Riprova")),
                                      ElevatedButton(
                                        onPressed: () {
                                          editState = true;
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Salva"),
                                      ),
                                    ],
                                    //insetPadding: const EdgeInsets.all(10),
                                    elevation: 8,
                                  );
                                });
                              }).then((returningValue) async {
                            if (returningValue != null) {
                              return returningValue;
                            }

                            var image = await _signatureController.toPngBytes();

                            setState(() {
                              signatureInfo = _signatureEditingController
                                  ?.value.copyWith
                                  .signature(image);
                            });

                            _signatureEditingController?.value = signatureInfo!;

                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.landscapeRight,
                              DeviceOrientation.portraitDown,
                              DeviceOrientation.portraitUp
                            ]);
                          });
                        },
                        child: Text(
                          "Firma",
                          key: _signatureCaptionTextKey,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _closeSignatureRequest() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.red,
          size: 25,
        ),
        onPressed: () async {
          bool close = await showCancelCloseInterventionMessage();
          if (close) {
            setState(() {
              signatureInfo = const SignatureInfo();
              _signatureEditingController?.value = signatureInfo!;
              _closeIntervention = false;
            });
          }

          //Navigator.pop(context);
        },
      ),
    );
  }

  Widget _closeRequest() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SizedBox(
          height: 40,
          width: double.maxFinite,
          child: TextButton(
            style: TextButton.styleFrom(
                primary: isLightTheme(context)
                    ? Colors.white
                    : ThemeModeHandler.of(context)!.isCustomColor
                        ? Colors.black87
                        : Colors.white70,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                )),
            onPressed: () async {
              /*showDialog(context:  context, builder: (context){
                return AlertDialog(content: _signatureRequest());

              });*/
              if (details == null || details!.isEmpty) {
                await showDetailsEmptyErrorMessage();

                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await _scrollController.position.ensureVisible(
                    _summaryListContainerKey.currentContext!
                        .findRenderObject()!,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );

                  await tapTargetWithEffect(_emptyFloatingButtonKey);
                });
              } else {
                bool result = await showCloseInterventionMessage();
                if (result) {
                  setState(() {
                    _closeIntervention = true;
                  });
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_signatureCaptionTextKey.currentContext != null) {
                    _scrollController.position.ensureVisible(
                      _signatureCaptionTextKey.currentContext!
                          .findRenderObject()!,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                });
              }
            },
            child: const Text("Chiudi intervento"),
          ),
        ),
      ),
    );
  }

  showDetailsEmptyErrorMessage() async {
    var result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Lavori mancanti',
            message:
                'Per chiudere un intervento è necessario che sia presente almeno un lavoro',
            type: MessageDialogType.okOnly,
            okText: 'OK',
            okPressed: () {
              Navigator.pop(context, "0");
            });
      },
    ).then((value) async {
      return value;
      //return value
    });
    if (kDebugMode) {
      print(result);
    }
  }

  showCustomerEmptyErrorMessage() async {
    var result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Seleziona un cliente',
            message:
                'Per poter inserire un lavoro è necessario selezionare prima un cliente',
            type: MessageDialogType.okOnly,
            okText: 'OK',
            okPressed: () {
              Navigator.pop(context, "0");
            });
      },
    ).then((value) async {
      return value;
      //return value
    });
    if (kDebugMode) {
      print(result);
    }
  }

  showCloseInterventionMessage() async {
    bool result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Conferma chiusura intervento',
            message: 'Chiudere l\'intervento?',
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
    return result;
  }

  showCancelCloseInterventionMessage() async {
    bool result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Annulla chiusura intervento',
            message: 'Annullare la chiusura dell\'intervento?',
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
    return result;
  }

  Widget getFloatingActionButton() {
    return FloatingActionButton(
      key: _emptyFloatingButtonKey,
      onPressed: () async {
        bool result =
            await _addEditSummaryItem(detail: null, currentDetails: details);
        if (result == false) {
          try {
            if (_customerDropDownKey.currentState is DropdownSearchState) {
              await _scrollController.position.ensureVisible(
                _customerDropDownKey.currentContext!.findRenderObject()!,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
              await tapTargetWithEffect(_customerDropDownKey);
              /*(_customerDropDownKey.currentState as DropdownSearchState)
                  .openDropDownSearch();*/
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: isDarkTheme(context)
          ? ThemeModeHandler.of(context)!.isCustomColor
              ? Colors.black87
              : Colors.white
          : Colors.white,
      child: const Icon(Icons.add),
    );
  }

  /*Widget _okCancelContainer() {
    MediaQueryData queryData = MediaQuery.of(context);
    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      type: MaterialType.card,
      child: AnimatedContainer(duration: const Duration(milliseconds: 250), decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), border: Border.all(
          color: Theme.of(context).dividerColor),
      ), clipBehavior: Clip.antiAlias, height: queryData.size.height<400 ? 35 : 50, child: _okCancel()),
    );
  }
  Widget _okCancel() {
    return Center(
      child: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              */ /*      print(element!.reportUsers!.length.toString());
              print(element!.reportDetails!.length.toString());
              ///reimposto l'elemento com'era prima delle modifiche
              element = widget.element;*/ /*
              Navigator.maybePop(context, null);
            },
            child: const Text('ANNULLA'),
          ),
          ElevatedButton(
            onPressed: () {
              validateSave();
            },
            child: const Text(
              'SALVA',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  validateSave() {
    ///validazione
    if (_formKey.currentState!.validate()) {
      ///salvataggio
      if (_save()) {
        editState = false;

        Navigator.pop(context, element);
      } else {
        debugPrint("ReportEditScreen: Salvataggio non riuscito");
      }
    } else {
      /*Scrollable.ensureVisible(servicesKey.currentContext,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeOut);*/
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
  }

  bool _save() {
    /*List<int> list = convert.json.encode(MultiPointList.fromPoints(_signatureController.points).toJson()).codeUnits;
    var gzipBytes = GZipEncoder().encode(list);
    var signaturePoints = base64Encode(gzipBytes!);
*/
    var signaturePoints =
        MultiPointList.fromPoints(_signatureController.points).toZippedString();

    /*var zipbytes = base64Decode(signaturePoints);

    List<int> codeMetrics = GZipDecoder().decodeBytes(zipbytes);
    Uint8List bytes = Uint8List.fromList(codeMetrics);
    String json=String.fromCharCodes(bytes);
    var decodeddJson = jsonDecode(json);*/

    if (kDebugMode) {
      print("Urrà!");
    }

    //Uint8List bytes = Uint8List.fromList(list);
    //var signaturePoints = base64Encode(bytes);

    /*try {
      var list = MultiPointList.fromPoints(_signatureController.points);

      //List<MultiPoint> multiPoints =  points.map((e) => MultiPoint(dx:e.offset.dx, dy: e.offset.dy, type: e.type)).toList();
      //var multiList = MultiPointList(points: multiPoints);

      //var encoded = multiList.toJson();
      var encoded = list.toJson();

      if (kDebugMode) {
        print(encoded);
      }
      var newList = MultiPointList.fromJson(encoded);

      //var result = newList.points.map((e) => Point(Offset(e.dx, e.dy), e.type)).toList();
      var result = newList.toPoints();
      if (kDebugMode) {
        print(result);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }*/

    //Map<String, dynamic> map = jsonDecode(encoded);

    //Person person = Person.fromJson(map);

//    var newPoints = jsonDecode(encoded,<Point>[]);

    try {
      if (element == null) {
        var elabDetails = details
            ?.map((e) => ReportDetail(
                reportId: 0,
                reportDetailId: 0,
                factoryId: e.factory?.customerId,
                summary: e.summary,
                startDate: e.startDate,
                endDate: e.endDate,
                matricola: e.matricola,
                hashTags: e.hashTags
                    ?.map((e) => ReportDetailHashTag(
                        reportDetailId: 0,
                        reportHashTagId: 0,
                        hashTagId: e.hashTagId))
                    .toList()))
            .toList();

        element = Report(
            reportId: 0,
            creationDate: _selectedDateController.value.text,
            customerId: selectedCustomer!.customerId,
            interventionCauseId: selectedInterventionCause!.interventionCauseId,
            reportUsers: List.generate(
                selectedOperators!.length,
                (index) => ReportUser(
                    reportUserId: 0,
                    reportId: 0,
                    applicationUserId:
                        selectedOperators![index].applicationUserId)),
            reportDetails: elabDetails,
            signature: signatureInfo != null && signatureInfo!.signature != null
                ? base64Encode(signatureInfo!.signature!)
                : null,
            signaturePoints: signaturePoints,
            status: Status.initState.index,
            referent: _signatureTextController?.text);

        element = element!.copyWith(status: element!.getStatus().index);
      } else {
        element = element!.copyWith(
            creationDate: _selectedDateController.value.text,
            customerId: selectedCustomer!.customerId,
            interventionCauseId: selectedInterventionCause!.interventionCauseId,
            interventionCause: null,
            signature: signatureInfo != null && signatureInfo!.signature != null
                ? base64Encode(signatureInfo!.signature!)
                : null,
            signaturePoints: signaturePoints,
            referent: _signatureTextController?.text,
            reportUsers: selectedOperators
                ?.map(
                    (e) => e.copyWithNull(applicationUser: true, report: true))
                .toList(),
            reportDetails: details
                ?.map((e) => e
                    .copyWith(
                        hashTags: e.hashTags
                            ?.map((e) => e.copyWithNull(
                                reportDetail: true, hashTag: true))
                            .toList())
                    .copyWithNull(
                      factory: true,
                      machine: true,
                      report: true,
                    ))
                .toList());

        //element = element!.copyWith(status: element!.getStatus().index);
        element = element!.copyWith(status: element!.getStatus().index);

        //debugPrint("Element.status: ${element?.status.toString()}");

      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

/*  ///richiama il date picker per selezionare la data dell'intervento
  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 1),
        lastDate: DateTime(2101));

    return picked;
  }*/

  bool isEnabled() {
    return (details != null && details!.isNotEmpty) ||
            (element != null && element!.status == Status.closed.index)
        ? false
        : true;
  }

  Widget _dateSelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DateTimePicker(
        initialEntryMode: isWindows
            ? DatePickerEntryMode.input
            : DatePickerEntryMode.calendar,
        decoration: getInputDecoration(context, 'Data', 'Seleziona una data'),
        enabled: isEnabled(),

        type: DateTimePickerType.date,
        dateMask: 'd MMM, yyyy',
        controller: _selectedDateController,
        //initialValue: startDateFormatted,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        icon: const Icon(Icons.event),
        dateLabelText: 'Data',

        onChanged: (val) {
          setState(() {
            editState = true;
            selectedDate = DateTime.parse(val);

            ///
            /// !!!!controllare che la data non venga più modificata dopo che sono stati inseriti
            /// dei lavori nella lista

            /*if (endDate!=null){
              ///se la data di fine è precedente a quella di inizio aggiorno la data di fine
              if (endDate!.isBefore(startDate)){
                endDate=startDate;
                _endDateController.text = val;
              }
            }*/
          });
        },
        validator: (val) {
          if (kDebugMode) {
            print(val);
          }
          /*setState(() => _valueToValidate1 = val ?? '');*/
          return null;
        },
        /*
        onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),*/
      ),
    );

    /*return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(children: [
        Text(selectedFormattedDate),
        SizedBox(
          width: 20,
        ),
        Flexible(
            child: ElevatedButton(
                onPressed: () async {
                  var newDate = await _selectDate(context);
                  if (newDate != null && newDate != selectedDate){
                    setState(() {
                      selectedDate = newDate;
                      _formatDate();
                    });



                  }

                },
                child: Text("Seleziona data")))
      ]),
    );*/
  }

  Widget _customerDropDown() {
    return BlocBuilder<ServerDataBloc<Machine>, ServerDataState<Machine>>(
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
            customers!.clear();

            machines = state.items as List<Machine>;

            ///ottengo i customer padri
            var list =
                (state.items! as List<Machine>).groupBy((m) => m.customerId);

            try {
              list.forEach((key, value) {
                if (value.isNotEmpty) {
                  customers!.add(value[0].customer as Customer);
                }
              });
              customers!
                  .sort((a, b) => a.description!.compareTo(b.description!));
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DropdownSearch<Customer>(
                key: _customerDropDownKey,
                popupProps: PopupProps.dialog(
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  dialogProps: DialogProps(
                      backgroundColor: getAppBackgroundColor(context)),
                  emptyBuilder: (context, searchEntry) =>
                      const Center(child: Text('Nessun risultato')),
                  searchFieldProps: TextFieldProps(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      autofocus: isWindows || isWindowsBrowser ? true : false,
                      //controller: _searchCustomerController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  showSelectedItems: true,
                  showSearchBox: true,
                ),

                /*mode: isWindows || isWindowsBrowser
                    ? Mode.BOTTOM_SHEET
                    : Mode.DIALOG,
                focusNode:
                    isWindows || isWindowsBrowser ? null : _customerFocusNode,*/
                enabled: isEnabled(),

                /*,*/

                compareFn: (item, selectedItem) =>
                    item.customerId == selectedItem.customerId,
                clearButtonProps: const ClearButtonProps(isVisible: true),
                itemAsString: (Customer? c) => c!.description!,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectedItem: selectedCustomer,
                onChanged: (Customer? newValue) {
                  editState = true;
                  setState(() {
                    selectedCustomer = newValue;
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
                validator: (item) {
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
                },
                items: customers ?? <Customer>[],
                filterFn: (Customer? item, String? filter) {
                  String json = jsonEncode(item?.json);
                  String newString = json.removePunctuation();
                  print(newString);
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

  /*Widget _customerDropDown() {
    return BlocBuilder<ServerDataBloc<Machine>, ServerDataState<Machine>>(
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
            customers!.clear();

            var list =
                (state.items! as List<Machine>).groupBy((m) => m.customerId);

            try {
              list.forEach((key, value) {
                if (value.length > 0) {
                  customers!.add(DropdownMenuItem(
                      value: value[0].customer,
                      child: Text((value[0]).customer!.description ?? "null",
                          maxLines: 2, overflow: TextOverflow.ellipsis)));
                }
              });
              customers!.sort((a, b) =>
                  a.value!.description!.compareTo(b.value!.description!));
            } catch (e) {
              print(e);
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DropdownButtonFormField<Customer>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                value: (() {
                  if (element != null) {
                    return element!.customer;
                  } else {
                    return null;
                  }
                }()),
                onChanged: (Customer? newValue) {
                  setState(() {
                    selectedCustomer = newValue;
                  });
                },
                decoration: InputDecoration(
                  //enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  labelText: 'Cliente',
                  hintText: 'Selezione un cliente',
                ),
                validator: (item) {
                  if (item == null) {
                    return "Campo obbligatorio";
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return state.items!.map<Widget>((customer) {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width - 128,
                        child: Text(customer.customer.description,
                            overflow: TextOverflow.ellipsis));
                  }).toList();
                },
                items: customers,
              ),
            );
          }
          if (state is ServerDataError) {
            return Text("Errore Caricamento");
          }
      }
      return Text("Stato sconosciuto");
    });
  }*/

  Widget _interventionCauseDropDown() {
    return BlocBuilder<ServerDataBloc<InterventionCause>,
            ServerDataState<InterventionCause>>(
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
            interventionCauses = state.items! as List<InterventionCause>;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DropdownSearch<InterventionCause>(
                key: _interventionCauseDropDownKey,
                popupProps: PopupProps.dialog(
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  dialogProps: DialogProps(
                      backgroundColor: getAppBackgroundColor(context)),
                  emptyBuilder: (context, searchEntry) =>
                      const Center(child: Text('Nessun risultato')),
                  searchFieldProps: TextFieldProps(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      autofocus: isWindows || isWindowsBrowser ? true : false,
                      //controller: _searchInterventionCausesController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  showSelectedItems: true,
                  showSearchBox: true,
                ),

                /*focusNode: isWindows || isWindowsBrowser
                    ? null
                    : _interventionCauseFocusNode,*/
                enabled:
                    (element != null && element!.status == Status.closed.index)
                        ? false
                        : true,

                /*popupBackgroundColor: getAppBackgroundColor(context),*/

                compareFn: (item, selectedItem) =>
                    item.interventionCauseId ==
                    selectedItem.interventionCauseId,
                clearButtonProps: const ClearButtonProps(isVisible: true),
                itemAsString: (InterventionCause? c) => c!.cause!,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectedItem: selectedInterventionCause,
                onChanged: (InterventionCause? newValue) {
                  editState = true;
                  setState(() {
                    selectedInterventionCause = newValue;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Motivo intervento',
                    hintText: 'Seleziona un motivo per l\'intervento',
                  ),
                ),
                validator: (item) {
                  if (item == null) {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) =>
                            element.key == _interventionCauseDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: false);
                    return "Campo obbligatorio";
                  } else {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) =>
                            element.key == _interventionCauseDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: true);
                  }
                  return null;
                },
                items: interventionCauses ?? <InterventionCause>[],
              ),
            );
/*
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DropdownButtonFormField<InterventionCause>(
                  value: (() {
                    if (element != null) {
                      return element!.interventionCause;
                    } else {
                      return null;
                    }
                  }()),
                  onChanged: (InterventionCause? newValue) {
                    setState(() {
                      selectedInterventionCause = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Motivo intervento',
                    hintText: 'Seleziona motivo intervento',
                  ),
                  validator: (item) {
                    if (item == null) {
                      return "Campo obbligatorio";
                    }
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return (state.items! as List<InterventionCause>).map<Widget>((interventionCause) {
                      return SizedBox(
                          width: MediaQuery.of(context).size.width - 128,
                          child: Text(interventionCause.cause ?? '',
                              overflow: TextOverflow.ellipsis));
                    }).toList();
                  },
                  items: interventionCauses),
            );
*/
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

  Widget _operatorsDropDown() {
    return BlocListener<ServerDataBloc<ApplicationUser>,
            ServerDataState<ApplicationUser>>(
        listener: (BuildContext context, ServerDataState state) {
      if (state is ServerDataLoaded<ApplicationUser>) {
        operators = state.items!;
        operators = operators!
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

        ///carico l'operatore ricevuto dal bloc ApplicationUser al posto di quello contenuto nella struttura di Report
        selectedOperators = selectedOperators
            ?.map((e) {
              ApplicationUser? result = operators?.firstWhere((operator) =>
                  operator.applicationUserId == e.applicationUserId);
              if (result != null) {
                return e.copyWith(applicationUser: result);
              } else {
                return e;
              }
            })
            .cast<ReportUser>()
            .toList();

        /*selectedOperators?.forEach((element) {
                ApplicationUser result = operators!.firstWhere((operator) => operator.applicationUserId == element.applicationUserId);
                element=element.copyWith(applicationUser: result);


              });*/

      }
    }, child: BlocBuilder<ServerDataBloc<ApplicationUser>,
                ServerDataState<ApplicationUser>>(
            builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerComboLoading(context);
          }
          if (state is ServerDataLoaded<ApplicationUser>) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DropdownSearch<ApplicationUser>.multiSelection(
                key: _operatorsDropDownKey,
                popupProps: PopupPropsMultiSelection.dialog(
                  scrollbarProps: const ScrollbarProps(thickness: 0),
                  dialogProps: DialogProps(
                      backgroundColor: getAppBackgroundColor(context)),
                  emptyBuilder: (context, searchEntry) =>
                      const Center(child: Text('Nessun risultato')),
                  searchFieldProps: TextFieldProps(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      autofocus: isWindows || isWindowsBrowser ? true : false,
                      //controller: _searchOperatorsController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Cerca")),
                  showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: (BuildContext context, ApplicationUser item,
                      bool isSelected) {
                    return ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: getOperatorItem(
                                  user: item,
                                  selected: () {
                                    return isSelected;
                                  },
                                  onSelected: (value) {})),
                          /*subtitle:
                          Padding(padding: EdgeInsets.symmetric(vertical: 8), child:
                          Text(item.userName!))*/
                        ));
                  },
                ),

                /*focusNode:
                    isWindows || isWindowsBrowser ? null : _operatorsFocusNode,*/
                enabled:
                    (element != null && element!.status == Status.closed.index)
                        ? false
                        : true,

                /*popupBackgroundColor: getAppBackgroundColor(context),*/

                autoValidateMode: selectedOperators == null
                    ? AutovalidateMode.disabled
                    : AutovalidateMode.onUserInteraction,
                compareFn: (item, selectedItem) =>
                    item.applicationUserId == selectedItem.applicationUserId,
                clearButtonProps: const ClearButtonProps(isVisible: true),
                itemAsString: (ApplicationUser? c) => c!.userName!,
                onChanged: (List<ApplicationUser>? newValue) {
                  editState = true;

                  setState(() {
                    selectedOperators = newValue
                        ?.map((e) => ReportUser(
                            reportUserId: 0,
                            reportId: element?.reportId ?? 0,
                            applicationUserId: e.applicationUserId,
                            applicationUser: e))
                        .toList();
                    //selectedOperators.add(valueRe) = newValue!;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Operatori',
                    hintText:
                        'Seleziona operatori da associare all\'intervento',
                  ),
                ),
                validator: (items) {
                  if (items != null && items.isEmpty) {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) => element.key == _operatorsDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: false);

                    return "Seleziona almeno un operatore";
                  } else {
                    KeyValidationState state = _keyStates.firstWhere(
                        (element) => element.key == _operatorsDropDownKey);
                    _keyStates[_keyStates.indexOf(state)] =
                        state.copyWith(state: true);
                  }
                  return null;
                },
                dropdownBuilder: (context, selectedItems) {
                  Widget item(ApplicationUser operator) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: getOperatorItem(
                          user: operator,
                          selected: () {
                            return false;
                          },
                          onSelected: (value) {}));
                  return Wrap(
                    children: selectedItems.isNotEmpty
                        ? selectedItems.map((e) => item(e)).toList()
                        : [
                            Text(
                                'Seleziona operatori da associare all\'intervento',
                                style: Theme.of(context).textTheme.titleMedium)
                          ],
                  );
                },
                items: operators ?? <ApplicationUser>[],
                selectedItems: selectedOperators
                        ?.map((e) =>
                            e.applicationUser ??
                            ApplicationUser(
                                applicationUserId: e.applicationUserId))
                        .toList() ??
                    <ApplicationUser>[],
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
    }));
  }

  Widget _interventionSummaryList() {
    return Padding(
      key: _summaryListContainerKey,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Inserisci i lavori svolti",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
              padding: const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white60,
                  )),
              child: _interventionSummaryListBloc()),
        ],
      ),
    );
  }

  Widget _interventionSummaryListBloc() {
    return BlocBuilder<ServerDataBloc<ReportDetail>,
            ServerDataState<ReportDetail>>(
        builder: (BuildContext context, ServerDataState state) {
      switch (state.event!.status) {
        case ServerDataEvents.fetch:
          if (state is ServerDataInitState) {
            return shimmerListLoading(context);
          }
          if (state is ServerDataLoading) {
            return shimmerListLoading(context);
          }
          if (state is ServerDataLoaded) {
            details = state.items! as List<ReportDetail>;
            /*SizedBox(height: 300,
                    child: AnimationLimiter(
                    key: ValueKey("animationLimiter1"),
                    child: ReorderableListView(
                      key: ValueKey("listLavori"),
                      scrollController: _summaryListScrollController,
                        buildDefaultDragHandles: false,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(16),
                        onReorder: (int oldIndex, int newIndex) {},
                        children: _buildSummaryList())));*/

          }
          if (state is ServerDataLoadedCompleted) {
            if (kDebugMode) {
              print("ServerDataLoadedCompleted!");
            }
          }
          if (state is ServerDataError) {
            return const Text("Errore Caricamento");
          }

          if (details != null && details!.isNotEmpty) {
            return SizedBox(
              height: 400,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  floatingActionButton: ((element == null ||
                              element?.status != Status.closed.index) &&
                          !widget.readonly)
                      ? getFloatingActionButton()
                      : null,
                  body: AnimationLimiter(
                      key: const ValueKey("animationLimiter1"),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: _summaryList3()))),
            );
          } else {
            return SizedBox(
                height: 300,
                child: Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        const TextSpan(
                          text: 'Selezionare un cliente e poi premere ',
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Align(
                                alignment: Alignment.center,
                                child: IgnorePointer(
                                    ignoring: (element != null &&
                                        element?.status == Status.closed.index),
                                    child: getFloatingActionButton())),
                          ),
                        ),
                        const TextSpan(text: 'per inserire un nuovo lavoro'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                )

              //Center(child: TextSpan("Premere + per inserire un nuovo lavoro", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall,))
                );
          }
        default:
          break;
      }
      return const Text("Stato sconosciuto");
    });
  }

  Widget _summaryList3() {
    //final theme = Theme.of(context);
    bool isCustomColor = ThemeModeHandler.of(context)!.isCustomColor;

    ListTile buildListTile(ReportDetail detail) {
      return ListTile(
        key: ValueKey(detail.hashCode),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTile(detail),
          ],
        ),
      );
    }

    return ListView(
      children: List.generate(
          details!.length, (index) => buildListTile(details![index])),
    );
  }

  /*Widget _summaryList2() {
    //final theme = Theme.of(context);
    bool isCustomColor = ThemeModeHandler.of(context)!.isCustomColor;

    Reorderable buildReorderable(
      ReportDetail detail,
      Widget Function(Widget tile) transition,
    ) {
      return Reorderable(
        key: ValueKey(detail.hashCode),
        builder: (context, dragAnimation, inDrag) {
          final tile = Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTile(detail),
            ],
          );

          return AnimatedBuilder(
            animation: dragAnimation,
            builder: (context, _) {
              final t = dragAnimation.value;
              //final color = Color.lerp(Colors.white, Colors.grey.shade100, t);

              ///qui si può impostare lo sfondo della tile
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.alphaBlend(
                      isDarkTheme(context)
                          ? Theme.of(context)
                              .colorScheme
                              .background
                              .withAlpha(200)
                          : isCustomColor
                              ? Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withAlpha(200)
                              : Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withAlpha(200),
                      Theme.of(context).colorScheme.primary),
                  elevation: lerpDouble(0, 8, t)!,
                  child: transition(tile),
                ),
              );
            },
          );
        },
      );
    }

    return ImplicitlyAnimatedReorderableList<ReportDetail>(
      items: details!,
      shrinkWrap: true,
      reorderDuration: const Duration(milliseconds: 200),
      liftDuration: const Duration(milliseconds: 300),
      //physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
      onReorderStarted: (item, index) => setState(() => inReorder = true),
      onReorderFinished: (movedLanguage, from, to, newItems) {
        // Update the underlying data when the item has been reordered!
        onDetailsReorderFinished(newItems);
      },
      itemBuilder: (context, itemAnimation, lang, index) {
        return buildReorderable(lang, (tile) {
          return SizeFadeTransition(
            sizeFraction: 0.7,
            curve: Curves.easeInOut,
            animation: itemAnimation,
            child: tile,
          );
        });
      },
      updateItemBuilder: (context, itemAnimation, lang) {
        return buildReorderable(lang, (tile) {
          return FadeTransition(
            opacity: itemAnimation,
            child: tile,
          );
        });
      },

      //footer: _buildFooter(context, theme.textTheme),
    );
  }*/

  bool inReorder = false;

  //ScrollController scrollController = ScrollController();

  void onDetailsReorderFinished(List<ReportDetail> newItems) {
    //scrollController.jumpTo(scrollController.offset);
    setState(() {
      inReorder = false;

      details!
        ..clear()
        ..addAll(newItems);
    });
  }

  Widget _buildTile(ReportDetail detail) {
    //final theme = Theme.of(context);
    //final textTheme = theme.textTheme;

    /* final List<Widget> actions = [
      SlidableMultiAction(
        autoClose: true,
        backgroundColor: Colors.redAccent,
        icon: Icons.delete,
        onPressed: (BuildContext context) async {
          deleteJob(detail);
        },
      ),
    ];*/

    return
        /*startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: actions
      ),*/
        /*endActionPane: ActionPane(
          motion: const BehindMotion(), extentRatio: 0.15, children: actions),*/
        Column(
      children: [
        Container(
          alignment: Alignment.center,
          // For testing different size item. You can comment this line
          /*padding: lang.englishName == 'English'
                ? const EdgeInsets.symmetric(vertical: 16.0)
                : EdgeInsets.zero,*/
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            shape: getBorderShape(),
            onTap: () {
              _addEditSummaryItem(detail: detail, currentDetails: details);
            },
            title: _getSummaryItem(detail),
            /*subtitle:
              Padding(padding: EdgeInsets.symmetric(vertical: 8),
                child:
                    Wrap(
                      children: detail.hashTags!=null ? detail.hashTags!
                          .map((tag) => getHashTagItem(
                          tag: tag,
                          selected: () {
                            return false;
                          },
                          onSelected: (value) {}))
                          .toList() : [],
                    ),
              ),*/
            /*leading: Container(
    height: double.infinity,
    child: const Icon(Icons.work)),*/

            /*leading:
              SizedBox(
                width: 180,
                child: Center(child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: [
                        Icon(Icons.event),
                        Text(detail.startDate.toString(), style: Theme.of(context).textTheme.titleMedium,)
                      ],
                      ),
                      Row(children: [
                        Icon(Icons.event),
                        Text(detail.endDate.toString(), style: Theme.of(context).textTheme.titleMedium,)
                      ]),

                ]))
              ),*/

            // ///INFO:
            // ///aggiungendo un container con height: double.infinity il child viene centrato
            // trailing: Handle(
            //       delay: Duration(milliseconds: 0),
            //       capturePointer: true,
            //       child: Container(
            //         height: double.infinity,
            //         child: Icon(
            //         Icons.drag_handle,
            //         color: Colors.grey,
            //       ),
            // ),
            // ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: getCurrentCalcThemeMode(context) == ThemeMode.dark
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).colorScheme.primary),
            duration: const Duration(milliseconds: 250),
            height: 5,
            width: dividerWidth < 100 ? 100 : dividerWidth,
          ),
        ),
      ],
    );
  }

  /*Widget _summaryList() {
    if (details != null) {
      return ImplicitlyAnimatedReorderableList<ReportDetail>(
        items: details!,
        areItemsTheSame: (oldItem, newItem) =>
            oldItem.reportDetailId == newItem.reportDetailId,
        onReorderFinished: (item, from, to, newItems) {
          // Remember to update the underlying data when the list has been
          // reordered.
          setState(() {
            details!
              ..clear()
              ..addAll(newItems);
          });
        },
        itemBuilder: (context, itemAnimation, item, index) {
          // Each item must be wrapped in a Reorderable widget.
          return Reorderable(
            // Each item must have an unique key.
              key: ValueKey(item),
              // The animation of the Reorderable builder can be used to
              // change to appearance of the item between dragged and normal
              // state. For example to add elevation when the item is being dragged.
              // This is not to be confused with the animation of the itemBuilder.
              // Implicit animations (like AnimatedContainer) are sadly not yet supported.
              builder: (context, dragAnimation, inDrag) {
                final t = dragAnimation.value;
                final elevation = lerpDouble(0, 8, t);
                final color =
                    Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);

                return SizeFadeTransition(
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  animation: itemAnimation,
                  child: Material(
                    color: color,
                    elevation: elevation!,
                    type: MaterialType.transparency,
                    child: ListTile(
                      onTap: () {},
                      title: _getSummaryItem(details![index]),
                      // The child of a Handle can initialize a drag/reorder.
                      // This could for example be an Icon or the whole item itself. You can
                      // use the delay parameter to specify the duration for how long a pointer
                      // must press the child, until it can be dragged.
                      trailing: const Handle(
                        delay: Duration(milliseconds: 100),
                        child: Icon(
                          Icons.list,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
                */ /*return AnimationConfiguration.staggeredList(
                  key: ValueKey(index),
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: ScaleAnimation(
                      child: FadeInAnimation(
                          child:
                          ListTile(title:
                          _getSummaryItem(
                              details![index]),
                              trailing: Handle(
                                delay: const Duration(milliseconds: 100),
                                child: Icon(
                                  Icons.list,
                                  color: Colors.grey,
                                ),
                              )))));*/ /*
              });
        },
      );

      // Since version 0.2.0 you can also display a widget
      // before the reorderable items...
      */ /*header: Container(
          height: 200,
          color: Colors.red,
        ),*/ /*
      */ /*  // ...and after. Note that this feature - as the list itself - is still in beta!
        footer: Container(
          height: 200,
          color: Colors.green,
        ),*/ /*
      // If you want to use headers or footers, you should set shrinkWrap to true
      //shrinkWrap: true,

    } else {
      return Text("details is null");
    }
  }

  List<Widget> _buildSummaryList() {
    return List.generate(details?.length ?? 0, (int i) {
      return AnimationConfiguration.staggeredList(
          key: ValueKey(i),
          position: i,
          duration: const Duration(milliseconds: 375),
          child: ScaleAnimation(
              child: FadeInAnimation(
            child: _getSummaryItem(details![i]),
          )));
    });
  }*/

  void deleteJob(ReportDetail detail) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Elimina',
            message: 'Eliminare il lavoro selezionato?',
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

    if (result == "0") {
      setState(() {
        details!.remove(detail);
      });
    }
  }

  void cloneJob(ReportDetail detail) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Duplica',
            message: 'Duplicare il lavoro selezionato?',
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

    if (result == "0") {
      setState(() {
        details!.add(detail.cloneAsNew());
      });
    }
  }

  Widget _getSummaryItemMini(
      ReportDetail detail, String startDateFormatted, String endDateFormatted) {
    return Material(
        key: const ValueKey(2),
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(
                children: [
                  Row(children: [
                    Icon(Icons.business,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Text(
                      detail.factory.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    )),
                  ]),
                  const Divider(),
                  Row(children: [
                    Icon(
                      Icons.event,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      startDateFormatted,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.event,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(endDateFormatted,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ]),
                  const Divider(
                    thickness: 0,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(detail.summary ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w700)),
                  ),
                  const Divider(
                    thickness: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      children: detail.hashTags != null
                          ? detail.hashTags!
                              .map((tag) => Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: getHashTagItem(
                                      tag: tag.hashTag!,
                                      selected: () {
                                        return false;
                                      },
                                      onSelected: (value) {})))
                              .toList()
                          : [],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 40, child: _itemActions(detail)),
            /*const IntrinsicWidth(
              child: Handle(
                delay: Duration(milliseconds: 0),
                capturePointer: true,
                child: Icon(
                  Icons.drag_handle,
                  color: Colors.grey,
                ),
              ),
            ),*/
          ]),
        ));
  }

  Widget _getSummaryItemStandard(
      ReportDetail detail, String startDateFormatted, String endDateFormatted) {
    return Material(
        key: const ValueKey(1),
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Icon(Icons.business,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Text(
                      detail.factory.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    )),
                  ]),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.event,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'INIZIO',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      startDateFormatted,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ]),
                          const Divider(
                            thickness: 1,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FINE',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(endDateFormatted,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ],
                                ),
                              ]),
                        ],
                      ),
                      const VerticalDivider(
                        thickness: 5,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(detail.summary ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Wrap(
                              children: detail.hashTags != null
                                  ? detail.hashTags!
                                      .map((tag) => Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: getHashTagItem(
                                              tag: tag.hashTag!,
                                              selected: () {
                                                return false;
                                              },
                                              onSelected: (value) {})))
                                      .toList()
                                  : [],
                            ),
                          ),
                        ],
                      )),

                      /*SizedBox(width:32, height: 64, child:
                    Handle(
                      delay: Duration(milliseconds: 0),
                      capturePointer: true,
                      child: Icon(
                          Icons.drag_handle,
                          color: Colors.grey,
                        ),
                      ),
                    )*/
                    ],
                  )
                ]),
              ),
              SizedBox(width: 40, child: _itemActions(detail)),
              /*Material(
                type: MaterialType.transparency,
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 50,
                  child: IconButton(icon: const Icon(Icons.close), onPressed: (){*/

              /*const Padding(
                padding: EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Handle(
                    delay: Duration(milliseconds: 0),
                    capturePointer: true,
                    child: Icon(
                      Icons.drag_handle,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ));
  }

  Widget _itemActions(ReportDetail detail) {
    return SingleChildScrollView(
      child: Column(
        children: [
          IconButton(
            tooltip: 'Duplica',
            splashRadius: 25,
            splashColor: Theme.of(context).colorScheme.primary.withAlpha(60),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: () => {cloneJob(detail)},
            icon: Icon(
              Icons.copy,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          IconButton(
            tooltip: 'Elimina',
            splashRadius: 25,
            splashColor: Theme.of(context).colorScheme.primary.withAlpha(60),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: () => {deleteJob(detail)},
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSummaryItem(ReportDetail detail) {
    {
      MediaQueryData mq = MediaQuery.of(context);

      Future.sync(() => initializeDateFormatting(Intl.defaultLocale!, null));

      String startDateFormatted = DateFormat.yMMMMd()
          .add_jm()
          .format(DateTime.parse(detail.startDate!));
      String endDateFormatted =
          DateFormat.yMMMMd().add_jm().format(DateTime.parse(detail.endDate!));

      Widget widgetToShow;
      if (mq.size.width <= 600) {
        widgetToShow =
            _getSummaryItemMini(detail, startDateFormatted, endDateFormatted);
      } else {
        widgetToShow = _getSummaryItemStandard(
            detail, startDateFormatted, endDateFormatted);
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: widgetToShow,
      );
    }
  }

  Future<bool> _addEditSummaryItem(
      {ReportDetail? detail,
      required List<ReportDetail>? currentDetails}) async {
    editSummaryFormKey =
        GlobalKey<ReportEditSummaryFormState>(debugLabel: "editSummaryFormKey");
    if (selectedCustomer == null) {
      await showCustomerEmptyErrorMessage();
      return false;
    }
    if (selectedCustomer != null && machines != null) {
      ///ottengo i customer padri
      var list = machines
          ?.where((element) =>
              element.customer!.customerId == selectedCustomer!.customerId)
          .toList();

      var date = selectedDate;
      if (details?.isNotEmpty ?? false) {
        date = DateTime.parse(details!.last.endDate!);
      }
      var result = await ReportActions.addEditSummary(
        context,
        date,
        selectedCustomer!,
        customers!,
        list!,
        editSummaryFormKey!,
        parent: element,
        detail: detail,
        details: currentDetails,
        readonly: widget.readonly,
      );

      if (result != null) {
        editState = true;
        int index = detail != null ? details!.indexOf(detail) : 0;

        setState(() {
          if (detail != null) {
            // && result.reportDetailId != 0 {
            if (kDebugMode) {
              //print("before: " + details![index].hashCode.toString());
            }
            details![index] = result;
            if (kDebugMode) {
              //print("after: " + details![index].hashCode.toString());
            }
            //details!.insert(index, result);
          } else {
            //result = result?.copyWith(reportDetailId: details!.length + 1);
            details!.add(result);
          }
        });
      }
      return true;
    }
    return false;
  }
}
