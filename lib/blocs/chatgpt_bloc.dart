import 'dart:async';
import 'dart:convert';

import 'package:dpicenter/blocs/models/open_ai/chat_input_state.dart';
import 'package:dpicenter/blocs/models/open_ai/completion_input_state.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/models/server/auth_response.dart';
import 'package:dpicenter/models/server/openai/chat_input.dart';
import 'package:dpicenter/models/server/openai/completion_input.dart';
import 'package:dpicenter/models/server/openai/completion_response_model.dart';
import 'package:dpicenter/models/server/openai/data_frame.dart';
import 'package:dpicenter/models/server/openai/doc_frame.dart';
import 'package:dpicenter/models/server/openai/message.dart';
import 'package:dpicenter/models/server/string_response.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openai_gpt3_api/completion.dart';
import 'package:openai_gpt3_api/openai_gpt3_api.dart';
import 'package:universal_io/io.dart' as http;

class ChatGptBloc extends Bloc<ChatGPTEvent, ChatGPTState> {
  final String key;

  String conversation = "";
  String currentConversation = "";
  CompletionInputState completionInputState =
      const CompletionInputState(completionId: 0, finished: false);
  List<CompletionInputState> completionsInputIds = <CompletionInputState>[];

  List<Message> chatConversation = [];
  List<Message> chatCurrentConversation = [];
  ChatInputState chatInputState =
      const ChatInputState(chatId: 0, finished: false);
  List<ChatInputState> chatInputIds = <ChatInputState>[];

  final codec = const AsciiCodec();

  MultiService<CompletionResponseModel> service =
      MultiService<CompletionResponseModel>(
          CompletionResponseModel.fromJsonModel,
          apiName: 'OpenAi');

  ChatGptBloc({required this.key}) : super(const ChatGPTInitState()) {
    on<ChatGPTEvent>((event, emit) async {
      try {
        switch (event.status) {
          case ChatGPTEvents.completion:
            if (event.question != null && event.question!.isNotEmpty) {
              conversation = "";
              currentConversation = "";

              for (var element in completionsInputIds) {
                conversation += (element.result?.data ?? "");
              }

              conversation +=
                  '${conversation.isNotEmpty ? '\n\n' : ''}${event.question!}';

              emit(ChatGPTCompletionResponseState(
                  event: event,
                  question: event.question!,
                  answer: "",
                  started: true));

              try {
                CompletionInput queryModel = CompletionInput(
                  completionInputId:
                      (completionInputState.completionId ?? 0) + 1,
                  text: event.assistMode == 1 ? conversation : event.question,
                  temperature: event.temperature,
                  instruction: event.instruction,
                  example: event.example,
                  exampleContext: event.exampleContext,
                  engine: event.engine,
                  tokens: event.tokens,
                  generateCompletion: event.completionEnabled,
                  thresholdModifier: event.thresholdModifer,
                  searchType: event.searchType ?? 0,
                );

                completionInputState = CompletionInputState(
                    completionId: (completionInputState.completionId ?? 0) + 1,
                    finished: false,
                    input: queryModel,
                    question: event.question,
                    inProgress: true);
                completionsInputIds.add(completionInputState);

                List<CompletionResponseModel>? responseModel = await service
                    .retrieveCommandWithDio(
                        event.assistMode == 0
                            ? '/api/OpenAi/answer/'
                            : '/api/OpenAi/completion/',
                        queryModel,
                        CompletionResponseModel.fromJsonModel,
                        headers: {
                      "signal_r_connection_id": connectionId ?? ""
                    });

                //conversation = "$conversation\n${responseModel?.first.data}";

                completionInputState = completionInputState.copyWith(
                    finished: true,
                    input: queryModel,
                    result: responseModel?.first,
                    inProgress: false);
                int lastIndex =
                    completionsInputIds.indexOf(completionsInputIds.last);
                completionsInputIds[lastIndex] = completionInputState;

                emit(ChatGPTCompletionResponseState(
                    event: event,
                    question: event.question!,
                    answer: responseModel?.first.data ?? "",
                    started: false));
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
              /*if (!kIsWeb) {
                var api = GPT3(key);
                conversation += event.question!;

                emit(
                    ChatGPTRequestState(
                        event: event, question: event.question!));


                var response = await api.streamCompletion(conversation,
                    stream: true,
                    maxTokens: 750,
                    engine: Engine.davinci3,
                    temperature: 0,
                    presencePenalty: 0.1,
                    frequencyPenalty: 0.1);

                String answer = await readResponse(response, emit, event);
                */ /*       final encoded = codec.encode(answer.choices[0].text);
              final decoded = codec.decode([...encoded]);*/ /*
                conversation += answer;
                print("conversazione: $conversation");
                emit(ChatGPTResponseState(
                    event: event, question: event.question!, answer: answer));
              } else {

              }*/
            }
            break;
          case ChatGPTEvents.chat:
            if (event.questionMessage != null &&
                (event.questionMessage?.isNotEmpty ?? false)) {
              chatConversation.clear();
              chatCurrentConversation.clear();
/*

              for (var element in chatInputIds) {
                conversation += (element.result?.data ?? "");
              }
*/

              /*   conversation +=
              '${conversation.isNotEmpty ? '\n\n' : ''}${event.question!}';*/

              emit(ChatGPTChatResponseState(
                  event: event,
                  question: event.questionMessage!,
                  answer: const <Message>[],
                  started: true));

              try {
                ChatInput queryModel = ChatInput(
                  chatInputId: (chatInputState.chatId ?? 0) + 1,
                  messages: event.assistMode == 1
                      ? chatConversation
                      : event.questionMessage,
                  temperature: event.temperature,
                  instruction: event.instruction,
                  example: event.example,
                  exampleContext: event.exampleContext,
                  engine: event.engine,
                  tokens: event.tokens,
                  generateCompletion: event.completionEnabled,
                  thresholdModifier: event.thresholdModifer,
                  searchType: event.searchType ?? 0,
                );

                chatInputState = ChatInputState(
                    chatId: (chatInputState.chatId ?? 0) + 1,
                    finished: false,
                    input: queryModel,
                    question: event.questionMessage,
                    inProgress: true);
                chatInputIds.add(chatInputState);

                List<CompletionResponseModel>? responseModel = await service
                    .retrieveCommandWithDio('/api/OpenAi/answer_chat/',
                        queryModel, CompletionResponseModel.fromJsonModel,
                        headers: {
                      "signal_r_connection_id": connectionId ?? ""
                    });

                //conversation = "$conversation\n${responseModel?.first.data}";

                chatInputState = chatInputState.copyWith(
                    finished: true,
                    input: queryModel,
                    result: responseModel?.first,
                    inProgress: false);
                int lastIndex = chatInputIds.indexOf(chatInputIds.last);
                chatInputIds[lastIndex] = chatInputState;

                List<Message> answer = [];
                answer.add(Message(
                    role: "assistant",
                    content: responseModel?.first.data ?? ""));
                emit(ChatGPTChatResponseState(
                    event: event,
                    question: event.questionMessage!,
                    answer: answer,
                    started: false));
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            }
            break;
          case ChatGPTEvents.showChat:
            if (event.question != null &&
                event.question!.isNotEmpty &&
                chatInputState.finished == false) {
              //----chatCurrentConversation += event.response ?? "";
              chatInputState = chatInputState.copyWith(
                  finished: false,
                  result: CompletionResponseModel(
                      data: event.response ?? "",
                      completionInputId: chatInputState.chatId ?? 0),
                  inProgress: true);
              int lastIndex = chatInputIds.indexOf(chatInputIds.last);
              chatInputIds[lastIndex] = chatInputState;
//              String toShow = "$conversation\n${event.response}";

              List<Message> answer = [];
              Message? last;
              int lastConversationIndex = -1;
              if (chatCurrentConversation.isEmpty) {
                last = const Message();
              } else {
                last = chatCurrentConversation.last;
                lastConversationIndex = chatCurrentConversation.indexOf(last);
              }

              last = last.copyWith(
                  role: "assistant",
                  content: "${last.content}${event.response}");
              if (lastConversationIndex == -1) {
                chatCurrentConversation.add(last);
              } else {
                chatCurrentConversation[lastConversationIndex] = last;
              }

              emit(ChatGPTChatResponseState(
                  event: event,
                  question: <Message>[
                    Message(role: "assistant", content: event.question!)
                  ],
                  answer: chatCurrentConversation,
                  started: true));
            }
            break;
          case ChatGPTEvents.showCompletion:
            if (event.question != null &&
                event.question!.isNotEmpty &&
                completionInputState.finished == false) {
              currentConversation += event.response ?? "";
              completionInputState = completionInputState =
                  completionInputState.copyWith(
                      finished: false,
                      result: CompletionResponseModel(
                          data: event.response ?? "",
                          completionInputId:
                              completionInputState.completionId ?? 0),
                      inProgress: true);
              int lastIndex =
                  completionsInputIds.indexOf(completionsInputIds.last);
              completionsInputIds[lastIndex] = completionInputState;
//              String toShow = "$conversation\n${event.response}";
              emit(ChatGPTCompletionResponseState(
                  event: event,
                  question: event.question!,
                  answer: currentConversation,
                  started: true));
            }
            break;
          case ChatGPTEvents.reset:
            conversation = "";
            completionsInputIds.clear();
            completionInputState = CompletionInputState(
                completionId: completionInputState.completionId);

            emit(ChatGPTCompletionResponseState(
                event: event, question: "", answer: "", started: false));
            break;
          case ChatGPTEvents.resetChat:
            chatInputIds.clear();
            chatInputState = ChatInputState(chatId: chatInputState.chatId);

            emit(ChatGPTChatResponseState(
                event: event,
                question: const [],
                answer: const [],
                started: false));
            break;
          case ChatGPTEvents.saveDoc:
            emit(ChatGPTSaveDocState(
                event: event, started: true, finished: false));
            MultiService<StringResponse> service = MultiService<StringResponse>(
                StringResponse.fromJsonModel,
                apiName: 'Lab');
            List<StringResponse>? result = await service.retrieveCommand(
                "/api/Lab/generate_doc/",
                DocFrame(
                    id: 0,
                    dataframeId: event.dataframeId,
                    title: event.question,
                    content: event.response,
                    section: event.section,
                    attachments: event.attachments),
                StringResponse.fromJsonModel);
            emit(ChatGPTSaveDocState(
                event: event,
                started: true,
                finished: true,
                url: result?.first.response ?? ""));
            break;
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(ChatGPTError(event: event, error: e));
      }
    });
  }

  Future<String> readResponse(
      http.HttpClientResponse response, Emitter emit, event) async {
    CompletionApiResult? result;
    final contents = StringBuffer();

    try {
      String buffer = '';
      await emit.forEach(response.transform(utf8.decoder), onData: (data) {
        try {
          print("onData: ${data}");
          buffer += data;
          List<String> lines = buffer.split('\n\n');
          if (lines.length > 1) {
            buffer = lines.last;
            lines = lines.sublist(0, lines.length - 1);
            for (var line in lines) {
              if (line.length >= 5) {
                line = line.substring(5).trim();
              }
              if (line.length > 5) {
                if (line != "[DONE]") {
                  Map<String, dynamic> map = json.decode(line.trim());
                  var res = CompletionApiResult.fromJson(map);
                  result = res;
                  contents.write(res.choices.first.text);
                } else {
                  contents.write('\n\n');
                }
              } else {}
            }
          }
        } catch (e) {
          print(e);
        }

        return ChatGPTCompletionResponseState(
            event: event,
            question: event.question!,
            answer: contents.toString(),
            started: true);
      });
      /*await emit.forEach(response.transform(utf8.decoder), onData: (data) {
            try {
              String strData = data;
              if (strData!="data: [DONE]\n\n") {
                Map<String, dynamic> map = json.decode(
                    data.substring(5).trim());
                var res = CompletionApiResult.fromJson(map);
                result = res;
                contents.write(res.choices.first.text);
                return ChatGPTResponseState(
                    event: event,
                    question: event.question!,
                    answer: contents.toString());
              } else {
                contents.write('\n\n');
                return ChatGPTResponseState(
                    event: event,
                    question: event.question!,
                    answer: contents.toString());
              }
            } catch (e) {
              print(e);
              return ChatGPTResponseState(
                  event: event,
                  question: event.question!,
                  answer: contents.toString());
            }
          });*/
    } catch (e) {
      print(e);
    }

    result = CompletionApiResult(
        result!.id,
        result!.object,
        result!.created,
        result!.model,
        List.generate(
            1,
            (index) => Choice(contents.toString(), index,
                result!.choices[index].finishReason)));
    emit(ChatGPTCompletionResponseState(
        event: event,
        question: event.question!,
        answer: contents.toString(),
        started: false));

    /*response.transform(utf8.decoder).listen((data) {

      Map<String, dynamic> map = json.decode(data.substring(5));
      var res = CompletionApiResult.fromJson(map);
      result=res;
      contents.write(res.choices.first.text);
      emit(ChatGPTResponseState(
          event: event,
          question: event.question!,
          answer: contents.toString()));

    }, onDone: () {
      result = CompletionApiResult(result!.id, result!.object, result!.created, result!.model, List.generate(1, (index) => Choice(contents.toString(), index, result!.choices[index].finishReason)));
      emit(ChatGPTResponseState(
          event: event,
          question: event.question!,
          answer: contents.toString()));
    });*/
    //return completer.future;
    /*response.transform(utf8.decoder).listen((data) {
      onRx?.call(data);
      contents.write(data);
    }
    );*/

    /*await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }*/

    return result!.choices.first.text;
  }
}
