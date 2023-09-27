import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:dpicenter/blocs/chatgpt_bloc.dart';
import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/models/open_ai/chat_input_state.dart';
import 'package:dpicenter/blocs/models/open_ai/completion_input_state.dart';
import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/issue_attachment.dart';
import 'package:dpicenter/models/server/issue_model.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/openai/chat_input.dart';
import 'package:dpicenter/models/server/openai/completion_input.dart';
import 'package:dpicenter/models/server/openai/message.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/chatbot/chat_bot_item.dart';
import 'package:dpicenter/screen/widgets/chatbot/chatgpt_bot_item.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list_mini.dart';
import 'package:dpicenter/screen/widgets/image_loader/image_loader.dart';
import 'package:dpicenter/screen/widgets/markdown_editor/code_element_builder.dart';
import 'package:dpicenter/screen/widgets/markdown_editor/p_element_builder.dart';
import 'package:dpicenter/screen/widgets/search_field/search_file.dart';
import 'package:dpicenter/screen/widgets/settings_tiles/multi_setting_tile.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_azure_tts/flutter_azure_tts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dpicenter/globals/system_global.dart';

class ChatGPTBotForm extends StatefulWidget {
  const ChatGPTBotForm({Key? key}) : super(key: key);

  @override
  ChatGPTBotFormState createState() {
    return ChatGPTBotFormState();
  }
}

class ChatGPTBotFormState extends State<ChatGPTBotForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController questionController;
  late TextEditingController answerController;
  late TextEditingController instructionController;
  late TextEditingController exampleContextController;
  late TextEditingController exampleController;
  late TextEditingController modelController;

  List<String> oldQuestions = <String>[];

  ///eventi MessageHub
  StreamSubscription? eventBusSubscription;
  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');
  final FocusNode _titleFocusNode = FocusNode(debugLabel: '_titleFocusNode');
  final FocusNode _instructionFocusNode =
      FocusNode(debugLabel: '_instructionFocusNode');
  final FocusNode _exampleContextFocusNode =
      FocusNode(debugLabel: '_exampleContextFocusNode');
  final FocusNode _exampleFocusNode =
      FocusNode(debugLabel: '_exampleFocusNode');
  final FocusNode _modelFocusNode = FocusNode(debugLabel: '_modelFocusNode');

  final FocusNode _messageFocusNode =
      FocusNode(debugLabel: '_messageFocusNode');

  ///chiavi per i campi da compilare
  final GlobalKey _questionKey = GlobalKey(debugLabel: '_questionKey');
  final GlobalKey _instructionKey = GlobalKey(debugLabel: '_instructionKey');
  final GlobalKey _exampleContextKey =
      GlobalKey(debugLabel: '_exampleContextKey');
  final GlobalKey _exampleKey = GlobalKey(debugLabel: '_exampleKey');
  final GlobalKey _modelKey = GlobalKey(debugLabel: '_modelKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///gestisce lo stato del pannello moderazione input
  bool _inputModerationExpanded = false;

  ///gestisce lo stato del pannello moderazione ouput
  bool _outputModerationExpanded = false;

  ///0 - answer; 1 - free;
  int assistMode = 0;

  ///0 - completion; 1 - chatgpt;
  int engineMode = 1;

  ///abilitazione o disabilitazione della funzionalità completion. Se disabilitata è possibile ricevere solo i risultati delle ricerche semantiche
  bool completionEnabled = true;

  ///quando a true esegue la ricerca all'interno della guida di MultiDpi, quando è a false utilizza anche le informazioni delle impostazioni delle macchine
  bool onlyInfo = true;

  ///rappresenta l'input da inviare all'api
  late ChatInput currentInput;

  ///mostra/nasconde le opzioni avanzate
  bool hideAdvanced = true;

  @override
  void initState() {
    super.initState();
    initKeys();
    String userNameID =
        "${ApplicationUser.getUserFromSetting()?.applicationUserId ?? 0}_${ApplicationUser.getUserFromSetting()?.userName ?? ""}_";
    oldQuestions =
        prefs!.getStringList("${userNameID}_questionlist") ?? <String>[];

    questionController = TextEditingController();
    answerController = TextEditingController();

    currentInput = const ChatInput(
      chatInputId: 0,
      instruction:
          "You are a helpful assistant who responds in attending to the context provided.",
      //"Sei un tecnico esperto e simpatico che risponde in modo esaustivo, preciso e comprensibile utilizzando le informazioni presenti nel Context."
      //"Rispondi in modo simpatico, preciso e comprensibile utilizzando le informazioni presenti nel Context. Tuttavia se nel Context non sono presenti informazioni pertinenti alla domanda consiglia di rivolgersi a Chuck Norris citando uno dei suoi facts sempre diverso ma correlandolo alla domanda."
      //"Rispondi in modo simpatico, preciso e comprensibile utilizzando il Context. Se il Context non contiene informazioni correlate alla domanda consiglia di aggiungere più dettagli."
      //"When answering questions, Johnny Mnemonic is a skilled and friendly technician who uses the provided context to respond in italian with precision. If there is uncertainty about the relevancy of the context to the question, rather than providing information, Johnny Mnemonic advises to contact Chuck Norris and provides a relevant fact from Chuck Norris. Use markdown formatting for lists, images and instructions"
      engine: "gpt-3.5-turbo",
    );
    instructionController =
        TextEditingController(text: currentInput.instruction);
    exampleContextController =
        TextEditingController(text: currentInput.exampleContext);
    exampleController = TextEditingController(text: currentInput.example);
    modelController = TextEditingController(text: currentInput.engine);
    eventBusSubscription = eventBus.on<OpenAiChatEvent>().listen((hubEvent) {
      responseReceived(hubEvent.message);
    });

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      //print("Lo scroll viene spostato verso il basso");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        maxScroll = true;
      } else {
        maxScroll = false;
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      //print("Lo scroll viene spostato verso l'alto");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        maxScroll = true;
      } else {
        maxScroll = false;
      }
    }
  }

  @override
  void dispose() {
    eventBusSubscription?.cancel();
    questionController.dispose();
    answerController.dispose();
    instructionController.dispose();
    exampleContextController.dispose();
    exampleController.dispose();
    modelController.dispose();

    _scrollController.removeListener(_scrollListener);
    _saveFocusNode.dispose();
    _titleFocusNode.dispose();
    _modelFocusNode.dispose();
    _instructionFocusNode.dispose();
    _exampleContextFocusNode.dispose();
    _exampleFocusNode.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _questionKey),
      KeyValidationState(key: _instructionKey),
      KeyValidationState(key: _exampleContextKey),
      KeyValidationState(key: _exampleKey),
      KeyValidationState(key: _modelKey),
    ];
  }

  makeAChatQuestion() {
    var bloc = BlocProvider.of<ChatGptBloc>(context);

    if (oldQuestions
        .where((element) =>
            element.toLowerCase() == questionController.text.toLowerCase())
        .toList()
        .isEmpty) {
      oldQuestions.add(questionController.text);
    }
    String userNameID =
        "${ApplicationUser.getUserFromSetting()?.applicationUserId ?? 0}_${ApplicationUser.getUserFromSetting()?.userName ?? ""}_";
    prefs!.setStringList("${userNameID}_questionlist", oldQuestions);

    Message question = Message(role: "user", content: questionController.text);

    bloc.add(ChatGPTEvent(
      status: ChatGPTEvents.chat,
      questionMessage: <Message>[question],
      temperature: currentInput.temperature,
      instruction: currentInput.instruction,
      example: currentInput.example,
      exampleContext: currentInput.exampleContext,
      assistMode: assistMode,
      completionEnabled: completionEnabled,
      searchType: onlyInfo ? 0 : 1,
      engine: modelController.text,
      tokens: currentInput.tokens,
      thresholdModifer: currentInput.thresholdModifier,
    ));
  }

  createHtmlDoc(
      {required String question, required String answer, String? attachments}) {
    var bloc = BlocProvider.of<ChatGptBloc>(context);

    bloc.add(ChatGPTEvent(
      status: ChatGPTEvents.saveDoc,
      question: question,
      temperature: currentInput.temperature,
      instruction: currentInput.instruction,
      example: currentInput.example,
      exampleContext: currentInput.exampleContext,
      assistMode: assistMode,
      completionEnabled: completionEnabled,
      engine: modelController.text,
      tokens: currentInput.tokens,
      thresholdModifer: currentInput.thresholdModifier,
      attachments: attachments,
      response: answer,
      dataframeId: 0,
      section: "",
    ));
  }

  responseReceived(String response) {
    var bloc = BlocProvider.of<ChatGptBloc>(context);

    bloc.add(ChatGPTEvent(
      status: ChatGPTEvents.showChat,
      question: questionController.text,
      response: response,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 1500, maxHeight: 800),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DialogTitleEx(
              "Parla con l'assistente",
              subTitleWidget: Wrap(
                children: [
/*                  Tooltip(
                    message: (assistMode == 1
                        ? "Modalità conversazione"
                        : "Modalità assistente Multi-Tech"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: (assistMode == 1 ? true : false),
                          onChanged: (bool value) {
                            setState(() {
                              assistMode = value ? 1 : 0;
                              */ /*if (assistMode==1){
                                modelController.text= "davinci:ft-multi-tech-2023-01-27-17-31-22";
                              } else {
                                modelController.text= "davinci:ft-multi-tech-2023-01-27-17-31-22";
                              }*/ /*
                            });
                          },
                        ),
                        Text(assistMode == 1
                            ? "Modalità conversazione"
                            : "Modalità assistente Multi-Tech", style: Theme.of(context).textTheme.bodySmall,)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Tooltip(
                    message: (engineMode == 1
                        ? "Modalità ChatGPT"
                        : "Modalità Completion"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: (engineMode == 1 ? true : false),
                          onChanged: (bool value) {
                            setState(() {
                              engineMode = value ? 1 : 0;
                              modelController.text= value ? "gpt-3.5-turbo" : "text-davinci-003";
                            });
                          },
                        ),
                        Text(engineMode == 1
                            ? "Modalità ChatGPT"
                            : "Modalità Completion", style: Theme.of(context).textTheme.bodySmall,)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),*/
                  Tooltip(
                    message: (completionEnabled
                        ? "Modalità completa"
                        : "Solo ricerca semantica"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: completionEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              completionEnabled = value;
                            });
                          },
                        ),
                        Text(
                            completionEnabled
                                ? "Modalità completa"
                                : "Solo ricerca semantica",
                            style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Tooltip(
                    message:
                        (onlyInfo ? "Guida MultiDpi" : "Impostazioni macchine"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: onlyInfo,
                          onChanged: (bool value) {
                            setState(() {
                              onlyInfo = value;
                            });
                          },
                        ),
                        Text(
                          onlyInfo ? "Guida MultiDpi" : "Impostazioni macchine",
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: Scaffold(
              backgroundColor: getAppBackgroundColor(context),
              body: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

                    ///permette al widget di essere scrollato
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: SettingsScroll(
                            controller: _scrollController,
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
                              _configurationSectionBloc(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            OkCancel(
              okFocusNode: _saveFocusNode,
              onCancel: () {
                Navigator.maybePop(context, null);
              },
            )
          ],
        ),
      ),
    );
  }

  /*SettingsScrollSection _configurationSection(
      List<CompletionInputState> items) {
    var bloc = BlocProvider.of<ChatGptBloc>(context);
    List<Widget> tiles = [];
    bool inProgress = false;
    if (items.isNotEmpty) {
      for (int index = 0; index < items.length; index++) {
        CompletionInputState item = items[index];
        if (item.inProgress) {
          inProgress = true;
        }
        tiles.add(_questionSettingTile(item));
        tiles.add(_messageSettingTile(item));
      }
    } else {}
    if (!inProgress) {
      tiles.add(_questionSettingTile(CompletionInputState(
          completionId: bloc.completionInputState.completionId ?? 0)));
    }

    return SettingsScrollSection(
        //title: const Text("Inserisci una domanda"),
        tiles: tiles);
  }*/
  SettingsScrollSection _configurationSection(List<ChatInputState> items,
      {ChatGPTError? error}) {
    var bloc = BlocProvider.of<ChatGptBloc>(context);
    List<Widget> tiles = [];
    bool inProgress = false;
    if (items.isNotEmpty) {
      for (int index = 0; index < items.length; index++) {
        ChatInputState item = items[index];
        if (item.inProgress) {
          inProgress = true;
        }
        tiles.add(ChatGPTBotItem(
            state: item,
            onQuestionChanged: (value) => editState = true,
            onSend: (value) {},
            onCreateDoc: (String question, String answer, String attachments) {
              createHtmlDoc(
                  question: question, answer: answer, attachments: attachments);
            },
            onListen: (String text) async {
              await playAudio(text);
            }));
      }
    } else {}
    if (!inProgress) {
      tiles.add(_questionSettingTile(
          ChatInputState(chatId: bloc.chatInputState.chatId ?? 0)));
    }
    if (error != null) {
      tiles.insert(
          0,
          Container(
              color: Colors.red.withAlpha(30),
              padding: const EdgeInsets.all(8),
              child: Text("Errore: ${error.error.toString()}")));
    }

    return SettingsScrollSection(
        //title: const Text("Inserisci una domanda"),
        tiles: tiles);
  }

  final player = AudioPlayer();
  Random random = Random();

  Future playAudio(String text) async {
    String escaped = text.replaceAll("<", "[").replaceAll(">", "]");
    print(escaped);
    text = escaped;
    // Get available voices
    final voicesResponse = await AzureTts.getAvailableVoices() as VoicesSuccess;

    //Pick a Neural voice
    final voice = voicesResponse.voices
        .where((element) =>
            element.voiceType == "Neural" && element.locale.startsWith("it-"))
        .toList(growable: false)[0];

    //List all available voices
    print("${voicesResponse.voices}");

    //final text = "Microsoft Speech Service Text-to-Speech API";

    TtsParams params = TtsParams(
        voice: voice,
        audioFormat: AudioOutputFormat.audio48khz192kBitrateMonoMp3,
        rate: 1.0, // optional prosody rate (default is 1.0)
        text: text);
    final ttsResponse = await AzureTts.getTts(params);

    if (ttsResponse is AudioSuccess) {
      double randomDouble = random.nextDouble();
      String filename = "temp_$randomDouble.mp3";
      String newPath = filename;
      if (!kIsWeb) {
        var tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        newPath = "$tempPath${Platform.pathSeparator}$filename";
        await saveFile(newPath, ttsResponse.audio);
        print("started!");
        await player.play(DeviceFileSource(newPath),
            volume: 1.0, mode: PlayerMode.lowLatency);
        print("finished!");
      } else {
        openFilepath(newPath, bytes: ttsResponse.audio);
      }
    } else {
      if (ttsResponse is AudioFailedBadRequest) {
        print("${ttsResponse.code} - ${ttsResponse.reason}");
      }
    }

/*    await player.setSourceBytes(ttsResponse.audio);
    await player.resume();*/
    //Get the audio bytes.
    //print("${ttsResponse.audio}");
  }

  bool maxScroll = false;

  Widget _configurationSectionBloc() {
    if (_scrollController.positions.isNotEmpty) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // se lo scroll è in fondo alla lista, saltare alla posizione finale
        maxScroll = true;
      } else {
        maxScroll = false;
      }
    } else {
      maxScroll = true;
    }
    return BlocListener<ChatGptBloc, ChatGPTState>(
        listener: (BuildContext context, ChatGPTState state) {
      if (state.event != null) {
        switch (state.event!.status) {
          case ChatGPTEvents.saveDoc:
            if (state is ChatGPTSaveDocState) {
              if (state.finished && state.url != null) {
                launchUrl(
                    Uri.parse(
                        "https://${MultiService
                            .baseUrl}/api/Lab/showdoc?docName=${state.url}"),
                    mode: LaunchMode.externalApplication);
              }
            }
            break;
          default:
            break;
        }
      }
    }, child: BlocBuilder<ChatGptBloc, ChatGPTState>(
            builder: (BuildContext context, ChatGPTState state) {
      var bloc = BlocProvider.of<ChatGptBloc>(context);
      if (maxScroll) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
      if (state.event != null) {
        switch (state.event!.status) {
          case ChatGPTEvents.saveDoc:
          case ChatGPTEvents.completion:
          case ChatGPTEvents.showCompletion:
          case ChatGPTEvents.showChat:
          case ChatGPTEvents.chat:
          case ChatGPTEvents.reset:
          case ChatGPTEvents.resetChat:
            /*    if (state is ChatGPTError) {
                  return const Text("");
                }*/
            return _configurationSection(bloc.chatInputIds,
                error: state is ChatGPTError ? state : null);
          /*if (state is ChatGPTResponseState) {
                  return _configurationSection(bloc.completionsInputIds);
                } else {
                  return const Text("");
                }
*/
          default:
            break;
        }
      }
      return _configurationSection(bloc.chatInputIds,
          error: state is ChatGPTError ? state : null);
    }));
  }

  Widget _questionSettingTile(ChatInputState state) {
    if (state.finished || state.inProgress) {
      return _questionDisabled(state);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _question(state),
    );
    /*getCustomSettingTile(
        title: !state.finished ? 'Inserisci domanda' : null,
        hint: !state.finished ? 'Inserire una domanda' : null,
        description: !state.finished ? 'Poni una domanda all\'assistente' : null,
        child: _question(state));*/
  }

  /*Widget _questionBloc() {
    return BlocListener<ChatGptBloc, ChatGPTState>(
        listener: (BuildContext context, ChatGPTState state) {},
        child: BlocBuilder<ChatGptBloc, ChatGPTState>(
            builder: (BuildContext context, ChatGPTState state) {
          if (state.event != null) {
            switch (state.event!.status) {
              case ChatGPTEvents.completion:
              case ChatGPTEvents.showCompletion:
              case ChatGPTEvents.reset:
                if (state is ChatGPTError) {
                  return const Text("");
                }
                if (state is ChatGPTResponseState) {
                  return _question(state.started);
                } else {
                  return const Text("");
                }

              default:
                break;
            }
          }
          return _question(false);
        }));
  }
*/
  Widget _question(ChatInputState state) {
    bool disabled = state.finished;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!disabled)
            SearchField(
              key: _questionKey,
              suggestions: oldQuestions
                  .map((e) => SearchFieldListItem(e,
                      child: ListTile(
                        title: Text(e),
                        trailing: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              oldQuestions.remove(e);
                              String userNameID =
                                  "${ApplicationUser.getUserFromSetting()?.applicationUserId ?? 0}_${ApplicationUser.getUserFromSetting()?.userName ?? ""}_";
                              prefs!.setStringList(
                                  "${userNameID}_questionlist", oldQuestions);
                            });
                          },
                        ),
                        /*trailing: GestureDetector(
                          onPanDown: (_) {
                            setState(() {
                              oldQuestions.remove(e);
                            });
                          },
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {},
                          ),
                        ),*/
                      )))
                  .toList(),
              suggestionState: Suggestion.hidden,
              textInputAction: TextInputAction.newline,
              suggestionAction: SuggestionAction.unfocus,
              maxLenght: 5000,
              hint: 'Fai una domanda',
              hasOverlay: true,
              /* searchStyle: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.8),
              ),*/
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _questionKey);
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
              searchInputDecoration: textFieldInputDecoration(
                  labelText: 'Messaggio', hintText: 'Fai una domanda'),
              maxSuggestionsInViewPort: 6,
              itemHeight: 50,
              controller: questionController,
              onSubmit: (value) {
                setState(() {
                  questionController.text = value.toString();
                });
              },
              onSuggestionTap: (x) {
                setState(() {
                  questionController.text = x.searchKey.toString();
                });
              },
            ),

          const SizedBox(height: 4),
          Flexible(
              child: SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!disabled)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                          onPressed: validateSend, child: const Text("Invia")),
                    ),
                  if (!disabled)
                    ElevatedButton(
                        onPressed: resetConversation,
                        child: const Text("Resetta conversazione")),
                ]),
          )),

          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  hideAdvanced = !hideAdvanced;
                });
              },
              child: Text(hideAdvanced
                  ? 'Mostra opzioni avanzate'
                  : 'Nascondi opzioni avanzate')),
          if (assistMode == 0 && hideAdvanced == false) const Divider(),
          if (!disabled && assistMode == 0 && hideAdvanced == false)
            TextFormField(
              key: _instructionKey,
              focusNode: _instructionFocusNode,
              readOnly: disabled,
              maxLines: null,
              //autofocus: isDesktop ? true : false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: instructionController,
              maxLength: 5000,
              onChanged: (value) =>
                  currentInput = currentInput.copyWith(instruction: value),
              decoration: textFieldInputDecoration(
                  labelText: 'Istruzioni',
                  hintText:
                      'Fornire al bot istruzioni e indicazioni per svolgere un compito specifico.'),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _instructionKey);
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
          /*if (!disabled && assistMode==0 && hideAdvanced==false)
            TextFormField(
              fieldKey: _exampleContextKey,
              focusNode: _exampleContextFocusNode,
              readOnly: disabled,
              maxLines: null,
              //autofocus: isDesktop ? true : false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: exampleContextController,
              maxLength: 5000,
              onChanged: (value) => currentInput = currentInput.copyWith(exampleContext: value),
              decoration: textFieldInputDecoration(
                  labelText: 'Contesto di esempio', hintText: 'Fornire al bot un contesto di esempio'),
              validator: (str) {
                */ /*KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _exampleContextKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }*/ /*
                return null;
              },
            ),
          if (!disabled && assistMode==0 && hideAdvanced==false)
            TextFormField(
              fieldKey: _exampleKey,
              focusNode: _exampleFocusNode,
              readOnly: disabled,
              maxLines: null,
              //autofocus: isDesktop ? true : false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: exampleController,
              maxLength: 5000,
              onChanged: (value) => currentInput = currentInput.copyWith(example: value),
              decoration: textFieldInputDecoration(
                  labelText: 'Esempi', hintText: 'Fornire al bot una serie di esempi'),
              validator: (str) {
               */ /* KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _exampleKey);
                if (str!.isEmpty) {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: false);
                  return "Campo obbligatorio";
                } else {
                  _keyStates[_keyStates.indexOf(state)] =
                      state.copyWith(state: true);
                }*/ /*
                return null;
              },
            ),*/
          if (hideAdvanced == false) const SizedBox(height: 8),
          if (hideAdvanced == false)
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () async {
                    String? result = await displayUpDownInputDialog(context,
                        title: "Tokens",
                        hint:
                            "Imposta la quantità massima di tokens utilizzati",
                        initialValue: currentInput.tokens.toString(),
                        decimals: 0,
                        min: 0,
                        step: 1,
                        max: 4000, onChanged: (value) {
                      setState(() {
                        int tokens = double.parse(value.toString()).round();
                        currentInput = currentInput.copyWith(tokens: tokens);
                      });
                    });
                  },
                  child: _getFap(
                    "Tokens",
                    currentInput.tokens.toDouble(),
                  )),
            ),
          if (hideAdvanced == false) const SizedBox(height: 8),

          if (hideAdvanced == false)
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () async {
                    String? result = await displayUpDownInputDialog(context,
                        title: "Temperature",
                        hint: "Imposta la 'temperatura' della risposta",
                        initialValue: currentInput.temperature.toString(),
                        decimals: 2,
                        min: 0.00,
                        step: 0.01,
                        max: 1.0, onChanged: (value) {
                      setState(() {
                        currentInput =
                            currentInput.copyWith(temperature: value);
                      });
                    });
                  },
                  child: _getFap(
                    "Temperatura",
                    currentInput.temperature,
                  )),
            ),
          //if (assistMode == 1 && hideAdvanced==false)
          const SizedBox(
            height: 16,
          ),

          if (!disabled && assistMode == 0 && hideAdvanced == false)
            TextFormField(
              key: _modelKey,
              focusNode: _modelFocusNode,
              readOnly: disabled,
              maxLines: null,
              //autofocus: isDesktop ? true : false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: modelController,
              maxLength: 500,
              onChanged: (value) =>
                  currentInput = currentInput.copyWith(engine: value),
              decoration: textFieldInputDecoration(
                  labelText: 'Modello ai',
                  hintText:
                      'Inserisci il nome del modello. Ad es: text-davinci-003'),
              validator: (str) {
                KeyValidationState state = _keyStates
                    .firstWhere((element) => element.key == _exampleKey);
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
          if (!disabled && assistMode == 0 && hideAdvanced == false)
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () async {
                    String? result = await displayUpDownInputDialog(context,
                        title: "Modificatore Threshold",
                        hint: "Imposta il modificatore del valore di threshold",
                        initialValue: currentInput.thresholdModifier.toString(),
                        decimals: 3,
                        min: -1.000,
                        step: 0.001,
                        acceleration: 0.1,
                        max: 1.000, onChanged: (value) {
                      setState(() {
                        currentInput =
                            currentInput.copyWith(thresholdModifier: value);
                      });
                    });
                  },
                  child: Text(
                    "Modificatore Threshold: ${currentInput.thresholdModifier}",
                  )),
            ),
          if (disabled) _questionDisabled(state)
        ],
      ),
    );
  }

  Widget _getFap(String text, double currentValue, {double maxValue = 1}) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: FAProgressBar(
            maxValue: maxValue,
            currentValue: currentValue,
            animatedDuration: const Duration(milliseconds: 1000),
            backgroundColor: Theme.of(context).colorScheme.background,
            progressColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 30),
          alignment: Alignment.center,
          child: getStrokedText("$text: ${currentValue.toStringAsFixed(2)}",
              strokeColor: isDarkTheme(context) ? Colors.black : Colors.white,
              strokeWidth: 2),
        )
      ],
    );
  }

  Widget _questionDisabled(ChatInputState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Utente",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Color.alphaBlend(Colors.red.withAlpha(100),
                        Theme.of(context).colorScheme.primary))),
            const SizedBox(height: 8),
            MarkdownBody(
                data: state.question?.last.content ?? "",
                selectable: true,
                onTapLink: (text, url, title) {
                  if (url != null) {
                    launchUrl(Uri.parse(url));
                  }
                }
                /*builders: {
                'p': PElementBuilder(),
              },*/

                /* styleSheet:
              MarkdownStyleSheet(p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Color.alphaBlend(Colors.red.withAlpha(180),
                      Theme.of(context).colorScheme.primary)),
                )*/
                ),
            if (state.result != null && state.finished == true)
              MultiExpansionPanelMiniList(
                animationDuration: const Duration(milliseconds: 500),
                expandedHeaderPadding: EdgeInsets.zero,
                elevation: 0,
                expansionCallback: (panelIndex, isExpanded) {
                  switch (panelIndex) {
                    case 0:
                      _inputModerationExpanded = !_inputModerationExpanded;
                      break;
                  }

                  setState(() {});
                },
                children: [
                  MultiExpansionMiniPanel(
                      backgroundColor: Colors.transparent,
                      isExpanded: _inputModerationExpanded,
                      canTapOnHeader: true,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Container(
                            color: state.result!.inputModerationResult.results
                                    .first.flagged
                                ? Colors.red.withAlpha(100)
                                : Colors.green.withAlpha(100),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${state.result!.inputModerationResult.id} ${state.result!.inputModerationResult.model}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall)),
                            ));
                      },
                      body: Column(
                        children: [
                          Row(
                            children: [
                              if (state.result!.inputModerationResult.results
                                      .first.categories?.hate ??
                                  false)
                                const Text("Hate "),
                              if (state.result!.inputModerationResult.results
                                      .first.categories?.hateThreatening ??
                                  false)
                                const Text("Hate/Threatening "),
                              if (state.result!.inputModerationResult.results
                                      .first.categories?.selfHarm ??
                                  false)
                                const Text("SelfHarm "),
                              if (state.result!.inputModerationResult.results
                                      .first.categories?.sexual ??
                                  false)
                                const Text("Sexual "),
                              if (state.result!.inputModerationResult.results
                                      .first.categories?.sexualMinors ??
                                  false)
                                const Text("Sexual/Minors "),
                              if (state.result!.inputModerationResult.results
                                      .first.categories?.violence ??
                                  false)
                                const Text("Violence "),
                              if (state.result!.inputModerationResult.results
                                      .first.categories?.violenceGraphic ??
                                  false)
                                const Text("Violence/Graphic "),
                            ],
                          ),
                          Column(
                            children: [
                              progress(
                                  "Hate",
                                  state.result!.inputModerationResult.results
                                          .first.category_scores?.hate ??
                                      0),
                              progress(
                                  "Hate/Threatening",
                                  state
                                          .result!
                                          .inputModerationResult
                                          .results
                                          .first
                                          .category_scores
                                          ?.hateThreatening ??
                                      0),
                              progress(
                                  "SelfHarm",
                                  state.result!.inputModerationResult.results
                                          .first.category_scores?.selfHarm ??
                                      0),
                              progress(
                                  "Sexual",
                                  state.result!.inputModerationResult.results
                                          .first.category_scores?.sexual ??
                                      0),
                              progress(
                                  "Sexual/Minors",
                                  state
                                          .result!
                                          .inputModerationResult
                                          .results
                                          .first
                                          .category_scores
                                          ?.sexualMinors ??
                                      0),
                              progress(
                                  "Violence",
                                  state.result!.inputModerationResult.results
                                          .first.category_scores?.violence ??
                                      0),
                              progress(
                                  "Violence/Graphic",
                                  state
                                          .result!
                                          .inputModerationResult
                                          .results
                                          .first
                                          .category_scores
                                          ?.violenceGraphic ??
                                      0),
                            ],
                          ),
                        ],
                      ))
                ],
              )
          ]),
    );
  }

  Widget progress(String name, double value) {
    double percentage = value * 100;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: FAProgressBar(
                animatedDuration: const Duration(milliseconds: 1000),
                maxValue: 1,
                backgroundColor: Theme.of(context).colorScheme.background,
                progressColor: Theme.of(context).colorScheme.primary,
                currentValue: value),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 30),
            alignment: Alignment.center,
            child: getStrokedText(percentage < 100
                ? '$name: ${percentage.toStringAsFixed(2)}%'
                : '$name: 100%'),
          )
        ],
      ),
    );
  }

  Future validateSend() async {
    if (_formKey.currentState!.validate()) {
      makeAChatQuestion();
    } else {
      try {
        KeyValidationState state =
            _keyStates.firstWhere((element) => element.state == false);
        Scrollable.ensureVisible(state.key.currentContext!,
            duration: const Duration(milliseconds: 500));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future resetConversation() async {
    var bloc = BlocProvider.of<ChatGptBloc>(context);

    bloc.add(const ChatGPTEvent(
      status: ChatGPTEvents.resetChat,
      question: '',
    ));
  }
}

String covertStringToUnicode(String content) {
  String regex = "\\u";
  int offset = content.indexOf(regex) + regex.length;
  while (offset > -1 + regex.length) {
    int limit = offset + 4;
    String str = content.substring(offset, limit);
    if (str != null && str.isNotEmpty) {
      String code = String.fromCharCode(int.parse(str, radix: 16));
      content = content.replaceFirst(str, code, offset);
    }
    offset = content.indexOf(regex, limit) + regex.length;
  }
  return content.replaceAll(regex, "");
}
