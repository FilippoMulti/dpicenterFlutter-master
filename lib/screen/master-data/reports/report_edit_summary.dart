import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dpicenter/blocs/chatgpt_bloc.dart';
import 'package:dpicenter/blocs/image_gallery_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/hashtag.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/openai/completion_input.dart';
import 'package:dpicenter/models/server/openai/prediction_input.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:dpicenter/models/server/report_detail_hashtag.dart';
import 'package:dpicenter/models/server/report_detail_image.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtag_edit_screen.dart';
import 'package:dpicenter/screen/master-data/hashtags/hashtag_global.dart';
import 'package:dpicenter/screen/master-data/machines/machine_screen_ex.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/date_time_picker_multi.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dropdown_search/dropdown_search.dart';

//import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

/*import 'package:universal_io/io.dart' show File;*/

// Define a custom Form widget.
class ReportEditSummaryForm extends StatefulWidget {
  final ReportDetail? element;
  final Report? parent;
  final String? title;
  final Customer customer;
  final List<Machine>? machines;
  final List<ReportDetail>? currentDetails;

//  final List<Customer> customers;
  ///inizio
  final DateTime minDate;

  ///lista di tutti i clienti
  final List<Customer> customers;

  final bool readonly;

  const ReportEditSummaryForm({Key? key,
    required this.element,
    required this.title,
    required this.minDate,
    required this.parent,
    required this.customer,
    required this.currentDetails,
    this.machines,
    this.readonly = false,
    required this.customers})
      : super(key: key);

  @override
  ReportEditSummaryFormState createState() {
    return ReportEditSummaryFormState();
  }
}

class ReportEditSummaryFormState extends State<ReportEditSummaryForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _startDateFocusNode =
      FocusNode(debugLabel: '_startDateFocusNode');
  final FocusNode _endDateFocusNode =
      FocusNode(debugLabel: '_endDateFocusNode');

  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;

  ///inizio
  DateTime startDate = DateTime.now();

  ///Controller per data di inizio
  late TextEditingController _startDateController;

  ///fine
  DateTime? endDate;

  ///Controller per data fine
  late TextEditingController _endDateController;

  ///messaggio corrente da mandare al modello openAi
  String currentQuestion = "";

/*  ///orario inizio
  TimeOfDay startTime = TimeOfDay.now();

  ///orario fine
  TimeOfDay? endTime;*/

/*
  ///date e orari formattati secondo il Locale di default del sistema
  String startDateFormatted = "";
  String endDateFormatted = "";
  String startTimeFormatted = "";
  String endTimeFormatted = "";
*/

  ///lista degli stabilimenti tra cui selezionare
  //List<DropdownMenuItem<Customer>>? factories = <DropdownMenuItem<Customer>>[];
  List<Customer>? factories = <Customer>[];

  ///stabilimento selezionato
  Customer? selectedFactory;

  ///lista dei dispositivi presenti in stabilimento
  List<Machine>? machines;

  ///lista dei dispositivi passati dalla schermata padre
  List<Machine>? parentMachines;

  ///rappresenta la sede della Multi-Tech
  Customer? multitechCustomer;

  ///dispositivo selezionato
  Machine? selectedMachine;

  ///item da creare/modificare
  ReportDetail? element;

  ///descrizione del lavoro svolto
  String summary = "";

  ///hashtag disponibili
  List<HashTag> hashTags = <HashTag>[];

  ///hashtag selezionati
  List<ReportDetailHashTag>? selectedHashTags;

  ///immagini selezionate
  List<ReportDetailImage>? selectedImages;

  ///stato dettaglio
  int? status;

  ///controller per la descrizione
  late TextEditingController _summaryController;

  ///stato compressione immagini
  int compressStatus = 0;

  ///controller per i campi di ricerca delle dropdown
/*  final TextEditingController _searchCustomersController =
      TextEditingController();
  final TextEditingController _searchHashTagsController =
      TextEditingController();
  final TextEditingController _searchMachinesController =
      TextEditingController();*/

  ///lista delle immagini associate al lavoro
  List<ReportDetailImage>? _compressingImages;

  /*///lista delle immagini associate al lavoro
  List<Uint8List>? _fullSizeSummaryImages;*/

  ///HashTahEditForm key
  final GlobalKey<HashTagEditFormState> _hashTagEditFormKey =
  GlobalKey<HashTagEditFormState>(debugLabel: "HashTagEditFormState");

  ///chiavi per i campi da compilare
  final GlobalKey _factoryDropDownKey =
  GlobalKey(debugLabel: 'FactoryDropDownKey');
  final GlobalKey<DropdownSearchState<HashTag>> _hashTagDropDownKey =
  GlobalKey<DropdownSearchState<HashTag>>(debugLabel: 'HashTagDropDownKey');
  final GlobalKey _machineDropDownKey =
  GlobalKey(debugLabel: 'MachineDropDownKey');
  final GlobalKey _summaryKey = GlobalKey(debugLabel: 'SummaryKey');
  late List<KeyValidationState> _keyStates;
  final ScrollController _scrollController =
  ScrollController(debugLabel: 'ScrollController');

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///variabile temporanea per memorizzare l'hashtag inserito e selezionarlo al successivo reload degli hashtags
  HashTag? lastAddedHashTag;

  ///Focus Nodes per i dropdown
  final FocusNode _factoryFocusNode =
      FocusNode(debugLabel: '_factoryFocusNode');
  final FocusNode _machineFocusNode =
      FocusNode(debugLabel: '_machineFocusNode');
  final FocusNode _hashTagFocusNode =
      FocusNode(debugLabel: '_hashTagFocusNode');

  ///CompletionInput -> input corrente da inviare al modello per generare una descrizione
  ///currentInput = const CompletionInput(
  //         completionInputId: 0,
  //         instruction:
  //         "When answering questions, Johnny Mnemonic is a skilled and friendly technician who uses the provided context to respond in italian with precision. If there is uncertainty about the relevancy of the context to the question, rather than providing information, Johnny Mnemonic advises to contact Chuck Norris and provides a relevant fact from Chuck Norris. Use markdown formatting for lists, images and instructions"
  //        );

  String istruction =
      "Fai il riassunto di questa lista come se fosse la registrazione del lavoro appena svolto scritta da un tecnico. Combina le righe simili in un unica frase.";

  @override
  void initState() {
    super.initState();
    initKeys();
    element = widget.element;

    _summaryController = TextEditingController(text: element?.summary);

    //_summaryListScrollController = ScrollController(debugLabel: "summaryListScrollController");
    startDate = widget.minDate;

    _startDateController =
        TextEditingController(text: element?.startDate ?? startDate.toString());
    _endDateController =
        TextEditingController(text: element?.endDate ?? startDate.toString());

    ///inizializzazione di selectedFactory
    if (selectedFactory == null && element != null) {
      selectedFactory = element!.factory;
    }

    ///inizializzazione di selectedMachine
    if (selectedMachine == null && element != null) {
      selectedMachine = element!.machine;
    }

    ///inizializzazione di selectedHashTags
    if (selectedHashTags == null && element != null) {
      selectedHashTags = element!.hashTags;
    }

    ///macchine ricevuto da ReportEditScreen
    parentMachines = widget.machines ?? <Machine>[];
    var listFactories = parentMachines?.groupBy((element) => element.stabId);
    try {
      listFactories?.forEach((key, value) {
        if (value.isNotEmpty) {
          factories!.add(value[0].stabilimento as Customer);
        }
      });
      factories!.sort((a, b) => a.description!.compareTo(b.description!));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    ///trovo la multitech tra i clienti
    multitechCustomer =
        widget.customers.firstWhere((element) => element.code == 'S0025MT');
    if (multitechCustomer != null) {
      factories!.insert(0, multitechCustomer!);
    }
    //factories = widget.customers.map((e) => DropdownMenuItem(child: e));
    /*Future.delayed(Duration(milliseconds: 125), () {
      _loadFactories();
    });
    Future.delayed(Duration(milliseconds: 125), () {
      _loadMachines();
    });*/

    eventBusSubscription = eventBus.on<OpenAiEvent>().listen((hubEvent) {
      responseReceived(hubEvent.message);
    });

    Future.delayed(const Duration(milliseconds: 125), () {
      _loadHashTags();
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      _loadImages();
    });
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _factoryDropDownKey),
      KeyValidationState(key: _machineDropDownKey),
      KeyValidationState(key: _summaryKey),
      KeyValidationState(key: _hashTagDropDownKey)
    ];
  }

/*
  _loadFactories() {

    _fac
  }

  _loadMachines() {
    var bloc = BlocProvider.of<ServerDataBloc<Machine>>(context);
    bloc.add(ServerDataEvent<Machine>(status: ServerDataEvents.fetch));
  }
*/
  responseReceived(String response) {
    var bloc = BlocProvider.of<ChatGptBloc>(context);

    bloc.add(ChatGPTEvent(
      status: ChatGPTEvents.showCompletion,
      question: currentQuestion,
      response: response,
    ));
  }

  makeAQuestion() {
    List<HashTag>? hashtags =
        _hashTagDropDownKey.currentState?.getSelectedItems;
    if (hashtags != null && hashtags.isNotEmpty) {
      String hashTags = "";
      for (var element in hashtags) {
        hashTags += "${element.name}: ${element.description}\n";
      }

      currentQuestion = "$istruction.\n\n $hashTags.\n";

      var bloc = BlocProvider.of<ChatGptBloc>(context);
      bloc.add(ChatGPTEvent(
        status: ChatGPTEvents.reset,
        question: currentQuestion,
        temperature: 0.1,
        assistMode: 1,
        engine: "text-davinci-003",
        tokens: 1024,
      ));

      bloc.add(ChatGPTEvent(
        status: ChatGPTEvents.completion,
        question: currentQuestion,
        temperature: 0.1,
        assistMode: 1,
        engine: "text-davinci-003",
        tokens: 1024,
      ));
    }
  }

  _loadHashTags() {
    var bloc = BlocProvider.of<ServerDataBloc<HashTag>>(context);
    bloc.add(const ServerDataEvent<HashTag>(
        status: ServerDataEvents.fetch, withComplete: true));
  }

  _addHashTag(HashTag item) {
    var bloc = BlocProvider.of<ServerDataBloc<HashTag>>(context);
    bloc.add(ServerDataEvent<HashTag>(
        status: ServerDataEvents.add, item: item, withComplete: true));
  }

  _loadImages() {
/*
    var bloc = BlocProvider.of<ServerDataBloc<ReportDetailImage>>(context);
    bloc.add(const ServerDataEvent<ReportDetailImage>(
        status: ServerDataEvents.fetch));
*/
  }

/*  _compressFiles(List<FilePickerCross> filesPicked) async {
    List<File?> _files =
        filesPicked.map((e) => e.path != null ? File(e.path!) : null).toList();
    */ /* var _files = <File>[];
    for (var element in filesPicked){
      if ( await element.saveToPath(path: '/my/path/${element.path}')){
        _files.add(File('/my/path/${element.path}'));
      }
    }*/ /*

    _files.removeWhere((element) => element == null);
    var bloc = BlocProvider.of<ImageGalleryBloc>(context);
   */ /* bloc.add(ImageGalleryEvent(
        status: ImageGalleryEvents.compressList, fileList: _files, bytesList: <Uint8List>[]));*/ /*
  }*/

  idle() {
    var bloc = BlocProvider.of<ImageGalleryBloc>(context);
    bloc.add(const ImageGalleryEvent(
        status: ImageGalleryEvents.idle, bytesList: <Uint8List>[]));
  }

  ///formattazione della data secondo la cultura corrente
  ///le date che verranno formattate: [startDate], [endDate]
/*  _formatDateTimes() {
    try {
      Future.sync(() => initializeDateFormatting(Intl.defaultLocale!, null));
      startDateFormatted = DateFormat.yMMMMd().format(startDate);

      if (endDate != null) {
        Future.sync(() => initializeDateFormatting(Intl.defaultLocale!, null));
        endDateFormatted = DateFormat.yMMMMd().format(endDate!);
      }

      startTimeFormatted = startTime.format(context);
      endTimeFormatted = endTime?.format(context) ?? '';
    } catch (e) {
      print(e);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    /*_formatDateTimes();*/

    try {
      if (parentMachines != null) {
        if (selectedFactory != null) {
          machines = (parentMachines!
              .where((element) => element.stabId == selectedFactory!.customerId)
              .toList());

          machines?.sort((a, b) => a.matricola!.compareTo(b.matricola!));
        } else {
          machines = <Machine>[];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    ///form contenente i dati da compilare
    return FocusScope(
      child: Container(
        color: getAppBackgroundColor(context),
        child: Column(children: [
          Expanded(
              child: Scaffold(
                  backgroundColor: getAppBackgroundColor(context),
                  body: Form(
                      key: _formKey,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),

                          ///permette al widget di essere scrollato
                          child: Column(
                              children: [
                                Expanded(
                                  child: SettingsScroll(
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
                                      _configurationSection(),
                                      _hashtagSection(),
                                    ],
                                  ),
                                )
                              ]))))),
          OkCancel(
              onCancel: () {
                //TODO: mettere messaggio compressione in corso
                if (compressStatus != 0) {
                  //return;
                }
                /* ///reimposto l'oggetto com'era prima delle modifiche
                  element = widget.element;*/
                Navigator.maybePop(context, null);
              },
              onSave: widget.readonly
                  ? null
                  : () {
                validateSave();
              },
              onOptional: widget.readonly
                  ? null
                  : (element?.reportDetailId ?? 0) > 0
                  ? () {
                validateSave(asNew: true);
              }
                  : null)
        ]),
      ),
    );
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(title: const Text("Inserimento dati"), tiles: [
      _startDateSelectSettingTile(),
      _endDateSelectSettingTile(),
      _factoryDropDownSettingTile(),
      _machineDropDownSettingTile(),
      _summaryTextSettingTile(),
    ]);
  }

  SettingsScrollSection _hashtagSection() {
    return SettingsScrollSection(title: const Text("Hashtags"), tiles: [
      _hashtagSettingTile(),
    ]);
  }

  SettingsTile _startDateSelectSettingTile() {
    return getCustomSettingTile(
        title: 'Inizio',
        hint: 'Inizio',
        description: 'Inserisci la data e l\'ora dell\'inizio dell\'intervento',
        child: _startDateSelect());
  }

  SettingsTile _endDateSelectSettingTile() {
    return getCustomSettingTile(
        title: 'Fine',
        hint: 'Fine',
        description: 'Inserisci la data e l\'ora della fine dell\'intervento',
        child: _endDateSelect());
  }

  SettingsTile _factoryDropDownSettingTile() {
    return getCustomSettingTile(
        title: 'Stabilimento',
        hint: 'Stabilimento',
        description:
        'Seleziona lo stabilimento in cui stai eseguendo l\'intervento',
        child: _factoryDropDown());
  }

  SettingsTile _machineDropDownSettingTile() {
    return getCustomSettingTile(
        title: 'Macchina',
        hint: 'Macchina',
        description:
        'Seleziona l\'eventuale macchina su cui hai eseguito l\'intervento',
        child: _machineDropDown());
  }

  SettingsTile _summaryTextSettingTile() {
    return getCustomSettingTile(
        title: 'Descrizione',
        hint: 'Descrizione',
        description: 'Inserisci una descrizione sintetica del lavoro svolto',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryTextEditBloc(),
            if (selectedMachine != null) const SizedBox(height: 8),
            if (selectedMachine != null)
              TextButton(
                  onPressed: () {
                    var result = MachineActions.openDetailAndSave(
                        context, selectedMachine!,
                        selectedCategory: 'Promemoria');
                    print(result);
                  },
                  child: const Text("Aggiungi promemoria"))
          ],
        ));
  }

  SettingsTile _hashtagSettingTile() {
    return getCustomSettingTile(
        title: 'Hashtag',
        hint: 'Hashtag',
        description: 'Seleziona uno o più hashtags da associare al lavoro',
        child: _hashTagDropDown());
  }

  /*Widget _attachImages() {
    return BlocBuilder<ImageGalleryBloc, ImageGalleryState>(
        builder: (BuildContext context, ImageGalleryState state) {
      List<Widget> children = <Widget>[];
      if (state is ImageGalleryError) {
        for (var element in state.compressedFilesStatus!) {
          children.add(Text(element));
        }
      }
      switch (state.event!.status) {
        case ImageGalleryEvents.compressList:
          if (state is ImageGalleryInitState) {}
          if (state is ImageGalleryFileCompressed) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }

          }
          if (state is ImageGalleryFileCompressedError) {
            for (var element in state.compressedFilesStatus!) {
              children.add(Text(element));
            }
          }
          if (state is ImageGalleryCompressCompleted) {
            */ /*  for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/ /*
          }
          if (state is ImageGalleryEndState) {
            */ /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/ /*
            children.add(addImagesButton());
          }
          break;
        case ImageGalleryEvents.idle:
          children.add(addImagesButton());
          break;
        default:
          break;
      }
      children.add(addStopButton());
      return Column(
        children: children,
      );
    });
  }

  Widget _detailImagesWidget() {
    return BlocListener<ImageGalleryBloc, ImageGalleryState>(
        listener: (BuildContext context, ImageGalleryState state) {
      if (state is ImageGalleryCompressStarted) {
        _compressingImages = state.images;
        compressStatus = 1;
      }
      if (state is ImageGalleryFileCompressed) {
        _compressingImages = state.images;
      }
      if (state is ImageGalleryCompressCompleted) {
        _compressingImages = state.images;
        compressStatus = 0;
      }
    }, child: BlocBuilder<ImageGalleryBloc, ImageGalleryState>(
            builder: (BuildContext context, ImageGalleryState state) {
      List<Widget> children = <Widget>[];
      if (state is ImageGalleryError) {
        return Text("error: " + state.error.toString());
      }
      switch (state.event!.status) {
        case ImageGalleryEvents.compressList:
          if (state is ImageGalleryInitState) {}
          if (state is ImageGalleryCompressStarted) {}
          if (state is ImageGalleryFileCompressed) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }

          }
          if (state is ImageGalleryFileCompressedError) {
            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
          }
          if (state is ImageGalleryCompressCompleted) {
            */ /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/ /*
          }
          if (state is ImageGalleryEndState) {
            */ /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/ /*
          }
          break;
        case ImageGalleryEvents.idle:
          //children.add(addImagesButton());
          break;
        default:
          break;
      }
      var grid = _buildImagesGrid("key");

      var container = Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: getCurrentCalcThemeMode(context) == ThemeMode.dark
                      ? Colors.grey
                      : Theme.of(context).textTheme.bodySmall!.color!)),
          child: Center(child: grid));

      var padding =
          Padding(padding: const EdgeInsets.all(16), child: container);
      children.add(padding);

      return Column(
        children: children,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      );
    }));
  }
*/
  Widget addImagesButton() {
    return ElevatedButton(
        onPressed: () async {
          /*List<FilePickerCross>? myFiles =
              await FilePickerCross.importMultipleFromStorage(
                      type: kIsWeb ? FileTypeCross.any : FileTypeCross.custom,
                      // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
                      fileExtension:
                          'png, jpg, jpeg' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
                      )
                  .then((value) async {
            await _compressFiles(value);
            */ /*value.forEach((element) async {
                  print("Before: " + element.length.toString());
                  File result = await compressPicture(File(element.path!));
                  print("After: " + result.length.toString());
                });*/ /*
            return value;
          }).onError((error, _) {
            String _exceptionData = error.toString();
            if (kDebugMode) {
              print('----------------------');
            }
            if (kDebugMode) {
              print('REASON: ${_exceptionData}');
            }
            if (_exceptionData == 'read_external_storage_denied') {
              if (kDebugMode) {
                print('Permission was denied');
              }
            } else if (_exceptionData == 'selection_canceled') {
              if (kDebugMode) {
                print('User canceled operation');
              }
            }
            if (kDebugMode) {
              print('----------------------');
            }
            return <FilePickerCross>[];
          });*/
        },
        child: const Text("Seleziona immagini da associare all'intervento"));
  }

  Widget addStopButton() {
    return ElevatedButton(
        onPressed: () async {
          await idle();
        },
        child: const Text("Stop"));
  }

  String currentText = "";

  Widget _summaryTextEditBloc() {
    return BlocListener<ChatGptBloc, ChatGPTState>(
        listener: (BuildContext context, ChatGPTState state) {
      var bloc = BlocProvider.of<ChatGptBloc>(context);

      if (state.event != null) {
        switch (state.event!.status) {
          case ChatGPTEvents.completion:
          case ChatGPTEvents.showCompletion:
          case ChatGPTEvents.reset:
            if (state is ChatGPTInitState) {
              currentText = "";
            }
            if (state is ChatGPTError) {
              _summaryController.text += " Error: ${state.error.toString()}";
            }
            if (state is ChatGPTCompletionResponseState) {
              if (bloc.completionsInputIds.isNotEmpty) {
                currentText = bloc.completionInputState.result?.data ?? "";
                _summaryController.text =
                    currentText.replaceAll('\n', ' ').replaceAll('\r\n', ' ');
              }
            } else {
              _summaryController.text = "";
            }
            break;
          default:
            break;
        }
      }
    }, child: BlocBuilder<ChatGptBloc, ChatGPTState>(
            builder: (BuildContext context, ChatGPTState state) {
      var bloc = BlocProvider.of<ChatGptBloc>(context);

      if (state.event != null) {
        switch (state.event!.status) {
          case ChatGPTEvents.completion:
          case ChatGPTEvents.showCompletion:
          case ChatGPTEvents.reset:
            return _summaryTextEdit();
          default:
            break;
        }
      }
      return _summaryTextEdit();
    }));
  }

  Widget _summaryTextEdit() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        enabled: !isClosed(),
        //isEnabled(),
        key: _summaryKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _summaryController,
        maxLength: 2000,
        onChanged: (value) => editState = true,
        //PREDICE GLI HASHTAG
        /*onEditingComplete: () async {
          MultiService<HashTag> service =
              MultiService<HashTag>(HashTag.fromJsonModel, apiName: 'OpenAi');
          List<HashTag>? result = await service.retrieveCommand(
              '/api/OpenAi/predictHashtags',
              PredictionInput(prompt: _summaryController.text),
              HashTag.fromJsonModel);

          List<HashTag>? selected =
              _hashTagDropDownKey.currentState?.getSelectedItems;
          if (result != null) {
            if (selected != null) {
              selected.addAll(result);
              _hashTagDropDownKey.currentState?.changeSelectedItems(selected);
            }
          }
        },
*/
        decoration: const InputDecoration(
          //enabledBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
          labelText: 'Descrizione lavoro',
          hintText: 'Inserisci una descrizione per il lavoro svolto',
        ),
        validator: (str) {
          if (str!.isEmpty) {
            KeyValidationState state =
                _keyStates.firstWhere((element) => element.key == _summaryKey);
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            KeyValidationState state =
            _keyStates.firstWhere((element) => element.key == _summaryKey);
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
      ),
    );
  }

  /*Widget _okCancel() {
    return Center(
      child: Wrap(
        spacing: 10,
        children: [
          TextButton(
            onPressed: () {
           */ /*
              if (compressStatus != 0) {
                //return;
              }*/ /*
              */ /* ///reimposto l'oggetto com'era prima delle modifiche
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

  validateSave({bool asNew = false}) {
    //TODO: inserire messaggio compressione in corso
    if (compressStatus != 0) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      ///salvataggio
      _save(asNew: asNew);
      Navigator.pop(context, element);
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
        );*/
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  _save({bool asNew = false}) {
    //if (element == null) {
    if (asNew) {
      element = ReportDetail(
          reportDetailId: 0,
          factoryId: selectedFactory!.customerId,
          factory: selectedFactory,
          reportId: widget.parent?.reportId ?? 0,
          report: widget.parent,
          summary: _summaryController.text,
          startDate: _startDateController.text,
          endDate: _endDateController.text,
          matricola: selectedMachine?.matricola,
          machine: selectedMachine,
          hashTags: selectedHashTags
              ?.map((e) => e.copyWith(
              reportDetailId: 0,
              reportHashTagId: 0,
              reportDetail: null,
              hashTagId: e.hashTagId))
              .toList(growable: false),
          images: selectedImages);
    } else {
      element = ReportDetail(
          reportDetailId: element?.reportDetailId ?? 0,
          factoryId: selectedFactory!.customerId,
          factory: selectedFactory,
          reportId: widget.parent?.reportId ?? 0,
          report: widget.parent,
          summary: _summaryController.text,
          startDate: _startDateController.text,
          endDate: _endDateController.text,
          matricola: selectedMachine?.matricola,
          machine: selectedMachine,
          hashTags: selectedHashTags,
          images: selectedImages);
    }
  }

//#region date and time select
/*
  ///richiama il date picker per selezionare la data dell'intervento
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: widget.minDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  ///richiama il date picker per selezionare la data dell'intervento
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: widget.minDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }*/

/*  ///richiama il time picker per selezionare la data dell'intervento
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    //initialEntryMode: TimePickerEntryMode.);
    try {
      if (picked != null && picked != startTime)
        setState(() {
          startTime = picked;
        });
    } catch (e) {
      print(e);
    }
  }*/

/*  ///richiama il time picker per selezionare la data dell'intervento
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    //initialEntryMode: TimePickerEntryMode.);
    if (picked != null && picked != endTime)
      setState(() {
        endTime = picked;
      });
  }*/

/*  BoxDecoration _errorDecoration() {
    return const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.pink,
            spreadRadius: 4,
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.pink,
            spreadRadius: -4,
            blurRadius: 5,
          )
        ]);
  }*/

/*  ///value: startDateFormatted.isEmpty ? 'Data inizio' : startDateFormatted
  ///() async {
  ///           await _selectStartDate(context);
  ///         },
  Widget _dateButton(
      {required Function(dynamic) onChanged,
      String value = "",
      required dynamic validator}) {
    return Container(
        child: DateTimeButtonFormField(
      onChanged: onChanged,
      initialValue: startDate,
      firstDate: startDate,
      buttonChild: Text(value),
      buttonStyle: ElevatedButton.styleFrom(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      withTime: true,
    )
        */ /*ElevatedButton(
        onPressed: onPressed,
        child: Text(value),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        )),
      ),*/ /*
        );
  }*/

  Widget _startDateSelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DateTimePicker(
        focusNode: _startDateFocusNode,
        timePickerEntryModeInput: isWindows,
        initialEntryMode: isWindows
            ? DatePickerEntryMode.input
            : DatePickerEntryMode.calendar,
        enabled: isEnabled(),
        decoration: getInputDecoration(context, 'Data inizio',
            'Seleziona un orario per l\'inizio del lavoro'),
        type: DateTimePickerType.dateTime,
        dateMask: 'd MMM, yyyy HH:mm',
        controller: _startDateController,
        //initialValue: startDateFormatted,
        firstDate: widget.minDate,
        lastDate: DateTime(2100),
        icon: const Icon(Icons.event),
        dateLabelText: 'Data inizio',
        timeLabelText: "Ora inizio",
        //use24HourFormat: false,
        //locale: Locale('pt', 'BR'),
        selectableDayPredicate: (date) {
          /*
          Per disabilitare il sabato e la domenica
          if (date.weekday == 6 || date.weekday == 7) {
            return false;
          }*/
          return true;
        },

        onChanged: (val) {
          setState(() {
            editState = true;
            startDate = DateTime.parse(val);
            if (endDate != null) {
              ///se la data di fine è precedente a quella di inizio aggiorno la data di fine
              if (endDate!.isBefore(startDate)) {
                endDate = startDate;

                _endDateController.text = val;
              }
            } else {
              endDate = startDate.add(const Duration(hours: 1));
              _endDateController.text = endDate!.toString();
            }
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

      /*Row(children: [
        SizedBox(
          width: 60,
          child: Text("Inizio: ",
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16)),
        ),
        SizedBox(
            width: 280,
            child: DateTimeButtonFormField(
              onChanged: (value) {
                setState(() {
                  startDate = value;
                  startTime =
                      TimeOfDay(hour: startDate.hour, minute: startDate.minute);
                });
              },
              initialValue: startDate,
              firstDate: startDate,
              buttonChild:
                Text(startDateFormatted.isEmpty
                  ? 'Data inizio'
                  : startDateFormatted + ' ' + startTimeFormatted,
              maxLines: 2,),
              buttonStyle: ElevatedButton.styleFrom(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value is! DateTime) {
                  return "Selezionare una data di inizio";
                }
              },
              withTime: true,
            )),
      ]),*/
    );
  }

  Widget _endDateSelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DateTimePicker(
        focusNode: _endDateFocusNode,
        timePickerEntryModeInput: isWindows,
        initialEntryMode: isWindows
            ? DatePickerEntryMode.input
            : DatePickerEntryMode.calendar,
        enabled: isEnabled(),
        decoration: getInputDecoration(
            context, 'Data fine', 'Seleziona un orario per la fine del lavoro'),
        autovalidate: endDate == null ? false : true,
        type: DateTimePickerType.dateTime,
        dateMask: 'd MMM, yyyy HH:mm',
        controller: _endDateController,
        firstDate: startDate,
        lastDate: DateTime(2100),
        icon: const Icon(Icons.event),
        dateLabelText: 'Data fine',
        timeLabelText: "Ora fine",
        //use24HourFormat: false,
        //locale: Locale('pt', 'BR'),
        selectableDayPredicate: (date) {
          /*
          Per disabilitare il sabato e la domenica
          if (date.weekday == 6 || date.weekday == 7) {
            return false;
          }*/
          return true;
        },
        onChanged: (val) => setState(() {
          editState = true;
          endDate = DateTime.parse(val);
        }),
        validator: (val) {
          if (kDebugMode) {
            print(val);
          }
          if (val == null || val.isEmpty) {
            return "Selezionare una data di fine";
          }
          DateTime startTime = DateTime.parse(_startDateController.text);
          DateTime endTime = DateTime.parse(val);
          if (endTime.isBefore(startTime) ||
              endTime.isAtSameMomentAs(startTime)) {
            return "Selezionare una data di fine successiva a quella di inizio";
          }
/*
          if (_startDateController.text == val) {
            return "Selezionare una data di fine diversa da quella di inizio";
          }
*/

          /*setState(() => _valueToValidate1 = val ?? '');*/
          return null;
        },
        /*
        onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),*/
      ),
      /*Row(children: [
        SizedBox(
            width: 60,
            child: Text(
              "Fine: ",
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),
            )),
        SizedBox(
            width: 280,
            child: DateTimeButtonFormField(
              onChanged: (value) {
                setState(() {
                  endDate = value;
                  endTime = TimeOfDay(
                      hour: endDate?.hour ?? 0, minute: endDate?.minute ?? 0);
                });
              },
              initialValue: null,
              firstDate: startDate,
              buttonChild: Text(endDateFormatted.isEmpty
                  ? 'Data fine'
                  : endDateFormatted + ' ' + endTimeFormatted),
              buttonStyle: ElevatedButton.styleFrom(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value is! DateTime) {
                  return "Selezionare una data di fine";
                }
              },
              withTime: true,
            ))
      ]),*/
    );
  }

  //#endregion

  Widget _factoryDropDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DropdownSearch<Customer>(
        key: _factoryDropDownKey,
        popupProps: PopupProps.dialog(
          scrollbarProps: const ScrollbarProps(thickness: 0),
          dialogProps:
          DialogProps(backgroundColor: getAppBackgroundColor(context)),
          emptyBuilder: (context, searchEntry) =>
          const Center(child: Text('Nessun risultato')),
          searchFieldProps: TextFieldProps(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              autofocus: isWindows || isWindowsBrowser ? true : false,
              //controller: _searchCustomersController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Cerca")),
          showSelectedItems: true,
          showSearchBox: true,
        ),

        /*focusNode: isWindows || isWindowsBrowser ? null : _factoryFocusNode,*/
        enabled: isEnabled(),

/*
        popupBackgroundColor: getAppBackgroundColor(context),
*/
        compareFn: (item, selectedItem) =>
        item.customerId == selectedItem.customerId,
        clearButtonProps: const ClearButtonProps(isVisible: true),
        itemAsString: (Customer? c) => c!.toString(withSpace: false),
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectedItem: selectedFactory,
        onChanged: (Customer? newValue) {
          setState(() {
            editState = true;
            selectedFactory = newValue;
          });
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            //enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            labelText: 'Stabilimento',
            hintText: 'Seleziona un stabilimento',
          ),
        ),
        validator: (item) {
          if (item == null) {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _factoryDropDownKey);
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            KeyValidationState state = _keyStates
                .firstWhere((element) => element.key == _factoryDropDownKey);
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        /*dropdownBuilder: (BuildContext context) {
                  return state.items!.map<Widget>((customer) {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width - 128,
                        child: Text(customer.description,
                            overflow: TextOverflow.ellipsis));
                  }).toList();
                },*/
        items: factories ?? <Customer>[],
      ),
    );
  }

  Widget _machineDropDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DropdownSearch<Machine>(
        key: _machineDropDownKey,
        popupProps: PopupProps.dialog(
          scrollbarProps: const ScrollbarProps(thickness: 0),
          dialogProps:
          DialogProps(backgroundColor: getAppBackgroundColor(context)),
          emptyBuilder: (context, searchEntry) =>
          const Center(child: Text('Nessun risultato')),
          /*focusNode: isWindows || isWindowsBrowser ? null : _machineFocusNode,  */
          searchFieldProps: TextFieldProps(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              autofocus: isWindows || isWindowsBrowser ? true : false,
              //controller: _searchMachinesController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Cerca")),
          showSelectedItems: true,
          showSearchBox: true,
        ),
        enabled: isEnabled(),

        /*popupBackgroundColor: getAppBackgroundColor(context),*/

        compareFn: (item, selectedItem) =>
        item.matricola == selectedItem.matricola,
        clearButtonProps: const ClearButtonProps(isVisible: true),
        itemAsString: (Machine? c) => c!.toStringWithoutAddress(false),
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectedItem: selectedMachine,
        onChanged: (Machine? newValue) {
          setState(() {
            editState = true;
            selectedMachine = newValue;
          });
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            //enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            labelText: 'Dispositivo',
            hintText: 'Seleziona dispositivo',
          ),
        ),
        validator: (item) {
          return null;

          /*if (item == null) {
                    return "Campo obbligatorio";
                  }*/
        },
        /*dropdownBuilder: (BuildContext context) {
                  return state.items!.map<Widget>((customer) {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width - 128,
                        child: Text(customer.description,
                            overflow: TextOverflow.ellipsis));
                  }).toList();
                },*/
        items: machines ?? <Machine>[],
      ),
    );
  }

  Widget _hashTagDropDown() {
    /*   var box = _hashTagDropDownKey.currentContext?.findRenderObject();
    Size? size;
    if (box!=null){
      size =  (box as RenderBox).size;
      print(size ?? 'size is null');
    }*/

    return BlocListener<ServerDataBloc<HashTag>, ServerDataState<HashTag>>(
        listener: (BuildContext context, ServerDataState state) {
          if (state is ServerDataAdded) {
            lastAddedHashTag = state.item;
          }
          if (state is ServerDataLoaded) {
            hashTags = state.items! as List<HashTag>;
            try {
              hashTags
                  .sort((value1, value2) => value1.name!.compareTo(value2.name!));
            } catch (e) {
              debugPrint(e.toString());
            }
          }
          if (state is ServerDataLoadedCompleted) {
            /*if (lastAddedHashTag != null) {
          selectedHashTags?.add(ReportDetailHashTag(
              hashTag: lastAddedHashTag,
              hashTagId: lastAddedHashTag!.hashTagId,
              reportHashTagId: 0));
          _hashTagDropDownKey.currentState?.setState(() {});
          lastAddedHashTag = null;
        }*/
            if (state.items != null && state.items is List<HashTag>) {
              hashTags = state.items! as List<HashTag>;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                ///necessaria per accedere alla chiave dopo che che è stata creata
                List<HashTag>? selected =
                    _hashTagDropDownKey.currentState?.getSelectedItems;
                if (selected != null && lastAddedHashTag != null) {
                  selected.add(lastAddedHashTag!);
                  lastAddedHashTag = null;
                  _hashTagDropDownKey.currentState?.changeSelectedItems(selected);
                }
              });
            }
          }
        }, child: BlocBuilder<ServerDataBloc<HashTag>, ServerDataState<HashTag>>(
        builder: (BuildContext context, ServerDataState state) {
          if (state is ServerDataLoaded) {
            return _hashTagDropDownWidget();
          }
          if (state is ServerDataLoadedCompleted) {
            return _hashTagDropDownWidget();
          }
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
          switch (state.event!.status) {
            case ServerDataEvents.fetch:
              if (state is ServerDataError) {
                return const Text("Errore Caricamento");
              }
              break;

            case ServerDataEvents.add:
              if (state is ServerDataAdded) {
                return Stack(children: [
                  //_hashTagDropDownWidget(),
                  shimmerComboLoading(context)
                ]);
              }

              break;
            default:
              break;
          }
          return const Text("Stato sconosciuto");
        }));
  }

  Widget _hashTagDropDownWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: DropdownSearch<HashTag>.multiSelection(
          key: _hashTagDropDownKey,

          popupProps: PopupPropsMultiSelection.dialog(
            scrollbarProps: const ScrollbarProps(thickness: 0),
            dialogProps:
            DialogProps(backgroundColor: getAppBackgroundColor(context)),
            searchFieldProps: TextFieldProps(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                autofocus: isWindows || isWindowsBrowser ? true : false,
                //controller: _searchHashTagsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Cerca")),
            showSelectedItems: true,
            showSearchBox: true,
            emptyBuilder: (BuildContext context, String? item) {
              return Center(
                  child: HashTagEditForm(
                    key: _hashTagEditFormKey,
                    element: HashTag(name: item, hashTagId: 0),
                    title: "Nuovo hashtag",
                    roundedActionsContainer: true,
                    onSave: (HashTag? value) {
                      if (value != null) {
                        _hashTagDropDownKey.currentState?.closeDropDownSearch();
                        _addHashTag(value);
                      }
                    },
                  ));
            },
            itemBuilder: (BuildContext context, HashTag item, bool isSelected) {
              return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  title: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: getHashTagItem(
                              tag: item,
                              selected: () {
                                return isSelected;
                              },
                              onSelected: (value) {}))),
                  subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                      child: Text(item.description!)));
            },
          ),
          /*focusNode: isWindows || isWindowsBrowser ? null : _hashTagFocusNode,*/
          enabled: !isClosed(),

          ///Verificare quando e se disabilitare //isEnabled(),

          /*popupBackgroundColor: getAppBackgroundColor(context),*/

          autoValidateMode: selectedHashTags == null
              ? AutovalidateMode.disabled
              : AutovalidateMode.onUserInteraction,
          compareFn: (item, selectedItem) =>
          item.hashTagId == selectedItem.hashTagId,
          clearButtonProps: const ClearButtonProps(isVisible: true),

          itemAsString: (HashTag? c) => c!.name!,
          onChanged: (List<HashTag>? newValue) {
            setState(() {
              editState = true;
              selectedHashTags = newValue!
                  .map((e) => ReportDetailHashTag(
                  reportHashTagId: 0,
                  reportDetailId: 0,
                  hashTagId: e.hashTagId,
                  hashTag: e))
                  .toList();
            });
            //makeAQuestion();
          },
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              //enabledBorder: OutlineInputBorder(),
              border: OutlineInputBorder(),
              labelText: 'HashTags',
              hintText: 'Seleziona hashtags da associare al lavoro',
            ),
          ),

          validator: (items) {
            if (items != null && items.isEmpty) {
              KeyValidationState state = _keyStates
                  .firstWhere((element) => element.key == _hashTagDropDownKey);
              _keyStates[_keyStates.indexOf(state)] =
                  state.copyWith(state: false);
              return "Seleziona almeno un hashtag";
            } else {
              KeyValidationState state = _keyStates
                  .firstWhere((element) => element.key == _hashTagDropDownKey);
              _keyStates[_keyStates.indexOf(state)] =
                  state.copyWith(state: true);
            }
            return null;
          },

          /*popupCustomMultiSelectionWidget: (context, list) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: OutlinedButton(
                    onPressed: () async {
                      // How should I unselect all items in the list?
                      //_multiKey.currentState?.closeDropDownSearch();
                      //_hashTagDropDownKey.currentState?.changeSelectedItems(selectedItems)

                      */ /* HashTag? result = await HashTagsActions.openNew(context);
                      if (result != null) {
                        _addHashTag(result);
                        */ /* */ /*debugPrint(result.toString());
                                  _loadHashTags();
*/ /* */ /*
                      } else {
                        debugPrint("result is null!!");
                      }*/ /*
                    },
                    child: const Text('Nuovo'),
                  ),
                ),
                */ /*Padding(
                            padding: EdgeInsets.all(8),
                            child: OutlinedButton(
                              onPressed: () {
                                // How should I select all items in the list?
                                //_multiKey.currentState?.popupSelectAllItems();
                              },
                              child: const Text('All'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: OutlinedButton(
                              onPressed: () {
                                // How should I unselect all items in the list?
                                //_multiKey.currentState?.popupDeselectAllItems();
                              },
                              child: const Text('None'),
                            ),
                          ),*/ /*
              ],
            );
          },*/
          dropdownBuilder: (context, selectedItems) {
            Widget item(HashTag ht) => Padding(
                padding: const EdgeInsets.all(4),
                child: getHashTagItem(
                    tag: ht,
                    selected: () {
                      return false;
                    },
                    onSelected: (value) {}));
            return Wrap(
              children: selectedItems.isNotEmpty
                  ? selectedItems.map((e) => item(e)).toList()
                  : [
                Text("Selezionare hashtags",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        color: isDarkTheme(context)
                            ? Colors.white60
                            : Colors.black54))
              ],
            );
          },
          /*dropdownBuilder: (BuildContext context) {
                  return state.items!.map<Widget>((customer) {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width - 128,
                        child: Text(customer.description,
                            overflow: TextOverflow.ellipsis));
                  }).toList();
                },*/
          items: hashTags,
          selectedItems:
          selectedHashTags?.map((e) => e.hashTag!).toList() ?? <HashTag>[],
        ));
  }

/*  ///main screen
  Widget _buildImagesGrid(String key) {
    return AnimationLimiter(
        key: ValueKey(key),
        child: SingleChildScrollView(
            child: Wrap(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.

                children: _buildGridImagesList())));
  }*/

  /*List<Widget> _buildGridImagesList([double size = 128]) {
    return AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 375),
        childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: widget,
              ),
            )),
        children: List.generate(_compressingImages?.length ?? 0, (int i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent),
                  child: _compressingImages![i].previewBytes != null
                      ? Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: Image.memory(
                                _compressingImages![i].previewBytes!,
                                fit: BoxFit.cover,
                              ).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              */ /*Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return imagePreview(i);
                              }));*/ /*
                              showImagePreview(i);
                            },
                          ),
                        )
                      : Container(
                          color: Colors.grey,
                          child: Center(
                              child: Text(
                            "Compressione...",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 8),
                          )),
                        )),
            ),
          );
        }));
  }
*/
  Widget imagePreview(int index) {
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.memory(_compressingImages![index].bytes!,
                  filterQuality: FilterQuality.medium, fit: BoxFit.contain)
                  .image,
              fit: BoxFit.cover),
        ),
        child: ClipRRect(
          // make sure we apply clip it properly
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    body: Center(
                        child: Image.memory(_compressingImages![index].bytes!,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium))))));
  }

  void showImagePreview(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return imagePreview(index);
        });
  }

  bool isClosed() {
    return widget.parent?.status == Status.closed.index ? true : false;
  }

  bool isEnabled() {
    bool isClosed = widget.parent?.status == Status.closed.index ? true : false;
    bool isLast = widget.currentDetails != null &&
        element != null &&
        widget.currentDetails?.last == element;

    //se il report è  chiuso è disabilitato
    if (isClosed) {
      return false;
    }
    //se il dettaglio esiste e non è l'ultimo è disabilitato
    if (element != null && !isLast) {
      return false;
    }

    return true;
  }
}

