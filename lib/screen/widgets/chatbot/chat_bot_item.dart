import 'package:dpicenter/blocs/models/open_ai/completion_input_state.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/openai/data_frame_result.dart';
import 'package:dpicenter/screen/master-data/dataframes/data_frame_screen.dart';
import 'package:dpicenter/screen/widgets/chatbot/horizontal_docs_list.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list_mini.dart';
import 'package:dpicenter/screen/widgets/markdown_editor/code_element_builder.dart';
import 'package:dpicenter/screen/widgets/markdown_editor/p_element_builder.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

// Define a custom Form widget.
class ChatBotItem extends StatefulWidget {
  const ChatBotItem(
      {required this.state,
      this.onQuestionChanged,
      this.onSend,
      this.onCreateDoc,
      this.onListen,
      Key? key})
      : super(key: key);
  final void Function(String value)? onQuestionChanged;
  final void Function(String value)? onSend;
  final void Function(String question, String answer, String attachments)?
      onCreateDoc;
  final void Function(String text)? onListen;

  final CompletionInputState state;

  @override
  ChatBotItemState createState() {
    return ChatBotItemState();
  }
}

class ChatBotItemState extends State<ChatBotItem> {
  ///gestisce lo stato del pannello moderazione input
  bool _inputModerationExpanded = false;

  ///gestisce lo stato del pannello moderazione ouput
  bool _outputModerationExpanded = false;

  ///gestisce lo stato della ricerca semantica
  bool _semanticSearchExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _section(widget.state);
  }

  Widget _section(CompletionInputState item) {
    List<Widget> tiles = <Widget>[];
    if (!item.inProgress && item.finished == false) {
      //la domanda è ancora da porre
      tiles.add(_questionSettingTile(item));
    } else {
      tiles.add(_questionSettingTile(item));
      tiles.add(_messageSettingTile(item));
    }

    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: tiles);
  }

  bool maxScroll = false;

  Widget _questionSettingTile(CompletionInputState state) {
    return _question(state);
  }

  Widget _question(CompletionInputState state) {
    return _questionDisabled(state);
  }

  Widget _questionDisabled(CompletionInputState state) {
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
                data: state.question ?? "",
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
              const SizedBox(height: 8),
            if (state.result != null &&
                state.finished == true &&
                state.result!.inputModerationResult.results.isNotEmpty)
              _inputModeration(state),
          ]),
    );
  }

  Widget _inputModeration(CompletionInputState state) {
    return MultiExpansionPanelMiniList(
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
                  color:
                      state.result!.inputModerationResult.results.first.flagged
                          ? Colors.red.withAlpha(100)
                          : Colors.green.withAlpha(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                            "${state.result!.inputModerationResult.id} ${state.result!.inputModerationResult.model}",
                            style: Theme.of(context).textTheme.bodySmall)),
                  ));
            },
            body: Column(
              children: [
                Row(
                  children: [
                    if (state.result!.inputModerationResult.results.first
                            .categories?.hate ??
                        false)
                      const Text("Hate "),
                    if (state.result!.inputModerationResult.results.first
                            .categories?.hateThreatening ??
                        false)
                      const Text("Hate/Threatening "),
                    if (state.result!.inputModerationResult.results.first
                            .categories?.selfHarm ??
                        false)
                      const Text("SelfHarm "),
                    if (state.result!.inputModerationResult.results.first
                            .categories?.sexual ??
                        false)
                      const Text("Sexual "),
                    if (state.result!.inputModerationResult.results.first
                            .categories?.sexualMinors ??
                        false)
                      const Text("Sexual/Minors "),
                    if (state.result!.inputModerationResult.results.first
                            .categories?.violence ??
                        false)
                      const Text("Violence "),
                    if (state.result!.inputModerationResult.results.first
                            .categories?.violenceGraphic ??
                        false)
                      const Text("Violence/Graphic "),
                  ],
                ),
                Column(
                  children: [
                    progress(
                        "Hate",
                        state.result!.inputModerationResult.results.first
                                .category_scores?.hate ??
                            0),
                    progress(
                        "Hate/Threatening",
                        state.result!.inputModerationResult.results.first
                                .category_scores?.hateThreatening ??
                            0),
                    progress(
                        "SelfHarm",
                        state.result!.inputModerationResult.results.first
                                .category_scores?.selfHarm ??
                            0),
                    progress(
                        "Sexual",
                        state.result!.inputModerationResult.results.first
                                .category_scores?.sexual ??
                            0),
                    progress(
                        "Sexual/Minors",
                        state.result!.inputModerationResult.results.first
                                .category_scores?.sexualMinors ??
                            0),
                    progress(
                        "Violence",
                        state.result!.inputModerationResult.results.first
                                .category_scores?.violence ??
                            0),
                    progress(
                        "Violence/Graphic",
                        state.result!.inputModerationResult.results.first
                                .category_scores?.violenceGraphic ??
                            0),
                  ],
                ),
              ],
            ))
      ],
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

  Widget _messageSettingTile(CompletionInputState state) {
    bool showAttachments = isStateContainsValidAttachments(state);
    List<String> docs = getAttachmentsDocs(state, onlyUrl: false);
    String attachments = docs.join("\r\n");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Assistente",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Color.alphaBlend(Colors.green.withAlpha(100),
                      Theme.of(context).colorScheme.primary))),
          const SizedBox(height: 8),
          _messageWidget(state),
          if (state.result != null &&
              state.finished &&
              state.result!.semanticSearchResult != null &&
              showAttachments)
            const SizedBox(height: 8),
          if (state.result != null &&
              state.finished &&
              state.result!.semanticSearchResult != null &&
              showAttachments)
            _attachmentsResults(state),
          const SizedBox(height: 8),
          if (state.result != null &&
              state.finished == true &&
              state.result!.outputModerationResult.results.isNotEmpty)
            _outputModeration(state),
          if (state.result != null &&
              state.finished &&
              state.result!.semanticSearchResult != null)
            const SizedBox(height: 8),
          if (state.result != null && state.finished)
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () =>
                            widget.onListen?.call(state.result?.data ?? ""),
                        child: const Text("Ascolta risposta")),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () => widget.onCreateDoc?.call(
                            state.question ?? "",
                            state.result?.data ?? "",
                            attachments),
                        child: const Text("Crea doc html")),
                  ],
                )),
          if (state.result != null &&
              state.finished &&
              state.result!.semanticSearchResult != null)
            const SizedBox(height: 8),
          if (state.result != null &&
              state.finished &&
              state.result!.semanticSearchResult != null)
            _semanticSearchResults(state),
        ],
      ),
    ); /*getCustomSettingTile(
        title: '', hint: '', description: '', child: _messageBloc(state));*/
  }

  Widget _outputModeration(CompletionInputState state) {
    return MultiExpansionPanelMiniList(
      animationDuration: const Duration(milliseconds: 500),
      expandedHeaderPadding: EdgeInsets.zero,
      elevation: 0,
      expansionCallback: (panelIndex, isExpanded) {
        switch (panelIndex) {
          case 0:
            _outputModerationExpanded = !_outputModerationExpanded;
            break;
        }

        setState(() {});
      },
      children: [
        MultiExpansionMiniPanel(
            backgroundColor: Colors.transparent,
            isExpanded: _outputModerationExpanded,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                  color:
                      state.result!.outputModerationResult.results.first.flagged
                          ? Colors.red.withAlpha(100)
                          : Colors.green.withAlpha(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                            "${state.result!.outputModerationResult.id} ${state.result!.outputModerationResult.model}",
                            style: Theme.of(context).textTheme.bodySmall)),
                  ));
            },
            body: Column(
              children: [
                Row(
                  children: [
                    if (state.result!.outputModerationResult.results.first
                            .categories?.hate ??
                        false)
                      const Text("Hate "),
                    if (state.result!.outputModerationResult.results.first
                            .categories?.hateThreatening ??
                        false)
                      const Text("Hate/Threatening "),
                    if (state.result!.outputModerationResult.results.first
                            .categories?.selfHarm ??
                        false)
                      const Text("SelfHarm "),
                    if (state.result!.outputModerationResult.results.first
                            .categories?.sexual ??
                        false)
                      const Text("Sexual "),
                    if (state.result!.outputModerationResult.results.first
                            .categories?.sexualMinors ??
                        false)
                      const Text("Sexual/Minors "),
                    if (state.result!.outputModerationResult.results.first
                            .categories?.violence ??
                        false)
                      const Text("Violence "),
                    if (state.result!.outputModerationResult.results.first
                            .categories?.violenceGraphic ??
                        false)
                      const Text("Violence/Graphic "),
                  ],
                ),
                Column(
                  children: [
                    progress(
                        "Hate",
                        state.result!.outputModerationResult.results.first
                                .category_scores?.hate ??
                            0),
                    progress(
                        "Hate/Threatening",
                        state.result!.outputModerationResult.results.first
                                .category_scores?.hateThreatening ??
                            0),
                    progress(
                        "SelfHarm",
                        state.result!.outputModerationResult.results.first
                                .category_scores?.selfHarm ??
                            0),
                    progress(
                        "Sexual",
                        state.result!.outputModerationResult.results.first
                                .category_scores?.sexual ??
                            0),
                    progress(
                        "Sexual/Minors",
                        state.result!.outputModerationResult.results.first
                                .category_scores?.sexualMinors ??
                            0),
                    progress(
                        "Violence",
                        state.result!.outputModerationResult.results.first
                                .category_scores?.violence ??
                            0),
                    progress(
                        "Violence/Graphic",
                        state.result!.outputModerationResult.results.first
                                .category_scores?.violenceGraphic ??
                            0),
                  ],
                ),
              ],
            ))
      ],
    );
  }

  bool isStateContainsValidAttachments(state) {
    if (state.result != null &&
        state.finished &&
        state.result!.semanticSearchResult != null) {
      List<DataFrameResult> accepted = state.result!.semanticSearchResult!
          .where((element) => element.result == "Accepted")
          .toList();
      if (accepted.isNotEmpty &&
          accepted.any((element) =>
              element.attachments != null && element.attachments!.isNotEmpty)) {
        return true;
      }
    }
    return false;
  }

  List<DataFrameResult> getAccepted(CompletionInputState state) {
    List<DataFrameResult> accepted = <DataFrameResult>[];
    if (state.result != null &&
        state.finished &&
        state.result!.semanticSearchResult != null) {
      accepted = state.result!.semanticSearchResult!
          .where((element) => element.result == "Accepted")
          .toList();
    }
    return accepted;
  }

  List<String> getAttachmentsDocs(CompletionInputState state,
      {bool onlyUrl = true}) {
    List<DataFrameResult> accepted = getAccepted(state);
    List<String> docs = <String>[];
    for (var item in accepted) {
      List<String>? lines = item.attachments?.split("\r\n");
      if (lines != null) {
        for (String line in lines) {
          if (line.trim().isNotEmpty) {
            line =
                "https://${MultiService.baseUrl}/api/OpenAi/getImage?imageName=${line.trim()}";
          }
          List<String> values = line.split("|");
          if (onlyUrl) {
            if (!docs.contains(values[0])) {
              docs.add(values[0]);
            }
          } else {
            if (!docs.contains(line)) {
              docs.add(line);
            }
          }
        }
      }
    }
    return docs;
  }

  Widget _attachmentsResults(CompletionInputState state) {
    List<String> docs = getAttachmentsDocs(state, onlyUrl: false);
    return HorizontalDocsList(
      docs: docs,
    );
  }

  Widget _semanticSearchResults(CompletionInputState state) {
    List<DataFrameResult> accepted = <DataFrameResult>[];
    List<DataFrameResult> refused = <DataFrameResult>[];
    if (state.result != null &&
        state.finished &&
        state.result!.semanticSearchResult != null) {
      accepted = state.result!.semanticSearchResult!
          .where((element) => element.result == "Accepted")
          .toList();
      refused = state.result!.semanticSearchResult!
          .where((element) => element.result == "Refused")
          .toList();
    }
    return MultiExpansionPanelMiniList(
      animationDuration: const Duration(milliseconds: 500),
      expandedHeaderPadding: EdgeInsets.zero,
      elevation: 0,
      expansionCallback: (panelIndex, isExpanded) {
        switch (panelIndex) {
          case 0:
            _semanticSearchExpanded = !_semanticSearchExpanded;
            break;
        }

        setState(() {});
      },
      children: [
        MultiExpansionMiniPanel(
            backgroundColor: Colors.transparent,
            isExpanded: _semanticSearchExpanded,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      "Risultati ricerca: ${accepted.length} accettati - ${refused.length} rifiutati"),
                ),
              );
            },
            body: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await DataFramesActions.openNewAndSave(context);
                    },
                    child: const Text("Aggiungi")),
                const SizedBox(height: 8),
                Text(
                    "Thresold: ${state.result?.semanticSearchResult?[0].threshold ?? 0}"),
                const SizedBox(height: 8),
                ...List.generate(
                    accepted.length, (index) => _getListTile(accepted[index])),
                ...List.generate(refused.length < 5 ? refused.length : 5,
                    (index) => _getListTile(refused[index]))
              ],
            ))
      ],
    );
  }

  Widget _getListTile(DataFrameResult result) {
    return ListTile(
      title: Text(result.question ?? ""),
      subtitle: Text(result.answer ?? ""),
      trailing: Text(result.similarity.toStringAsFixed(5)),
      tileColor: result.result == "Accepted"
          ? Colors.green.withAlpha(50)
          : Colors.red.withAlpha(50),
      onTap: () {
        DataFramesActions.openDetailAndSave(context, result.toDataFrame());
      },
    );
  }

  final regex = RegExp(r"#link#:(\/[a-zA-Z_]+)+\.[a-zA-Z]{3}");

  String convert(String data) {
    String result = "";
    result = data.replaceAll("#nomeserver#", MultiService.baseUrl);
    result = result.replaceAll("#apiUrl#", "api/OpenAi");
    result = result.replaceAll("#apiParam#", "getImage?imageName");
/*    while(regex.firstMatch(data)!=null){
      var res = regex.firstMatch(result);
      if (res!=null) {
        String link = result.substring(res.start, res.end);
        link = link.replaceAll("#link#:", "");
        link = "![$link](${Uri.https(
            MultiService.baseUrl)}/api/OpenAi/getImage?imageName=$link)"
            .replaceAll("\n", "");
        //result = result.replaceRange(res.start, res.end, link);
        result =
            result.substring(0, res.start) + link + data.substring(res.end);
      }
    }

    for (var res in regex.allMatches(result)){
      String link = result.substring(res.start, res.end);
      link = link.replaceAll("#link#:", "");
      link = "![$link](${Uri.https(MultiService.baseUrl)}/api/OpenAi/getImage?imageName=$link)".replaceAll("\n","");
      //result = result.replaceRange(res.start, res.end, link);
      result = result.substring(0, res.start) + link + data.substring(res.end);
    }
    result = result.replaceAll('\n', '\r\n');

    //result = regex.replaceAll(data,
    //result = result.replaceAll(("#link#:"), "![Immagine](${Uri.https(MultiService.baseUrl)}/api/OpenAi/getImage?imageName=");
    //result = "![Immagine](https://example.com/example.jpg)*/

    return result;
  }

  Widget _messageWidget(CompletionInputState state) {
    String data = state.result?.data ?? "";
    data = convert(data);
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: MarkdownBody(
          selectable: true,
          shrinkWrap: false,
          fitContent: false,
          builders: {
            'code': CodeElementBuilder(),
          },
          onTapLink: (text, url, title) {
            if (url != null) {
              launchUrl(Uri.parse(url));
            }
          },
          data: data,
        ));
  }
}
