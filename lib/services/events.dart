import 'dart:typed_data';

import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/models/server/check_version_response.dart';
import 'package:dpicenter/models/server/openai/message.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/services/wikiquote.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//#region ServerDataEvent
enum ServerDataEvents {
  fetch,
  update,
  add,
  delete,
  save,
  exportExcel,
  exportPdf,
  command,
}




//#endregion
//#region QuoteEvents
enum QuoteEvents {
  idle,
  fetch,
}

class QuoteEvent {
  final List<Quote>? quotes;
  final QuoteEvents? status;

  const QuoteEvent({required this.quotes, required this.status});
}

//#endregion
//#region LoginEvents
enum LoginEvents {
  idle,
  authenticate,
}

class LoginEvent {
  final String? username;
  final String? password;
  final LoginEvents? status;

  const LoginEvent({@required this.username,
    @required this.password,
    @required this.status});
}

//#endregion
//#region MenuSearchEvents
enum NavigatorScreenEvents { loadMenus, search, idle }

class NavigationScreenEvent {
  final NavigatorScreenEvents? status;
  final String? param;
  final BuildContext? context;

  const NavigationScreenEvent({required this.status, required this.param, this.context});
}

//#endregion

//#region CheckVersionEvents
enum CheckVersionEvents {
  ///non fa nulla
  idle,

  ///cerca nuove versioni
  search,

  ///scarica
  download,

  ///in attesa dell'aggiornamento
  waitUpdate,

  ///tentativo di autologin
  autoLogin,
}

class CheckVersionEvent {
  final CheckVersionEvents? status;
  final String? param;
  final CheckVersionResponse? response;
  final String? path;

  const CheckVersionEvent({required this.status, required this.param, this.response, this.path});
}

//#endregion

//#region SyncEvents
enum SyncEvents {
  ///non fa nulla
  idle,

  ///sincronizza i clienti
  syncCustomers,

  ///sincronizza i distributori
  syncMachines,
}

class SyncEvent {
  final SyncEvents? status;
  final bool? result;

  const SyncEvent({required this.status, required this.result});
}

//#endregion

//#region ImageGalleryEvents
enum ImageGalleryEvents {
  ///non fa nulla
  idle,

  ///comprime le immagini
  compressList,
}

class ImageGalleryEvent {
  final ImageGalleryEvents? status;
  final List<FilePickerResult>? fileList;
  final List<Uint8List>? bytesList;

  const ImageGalleryEvent(
      {required this.status, this.fileList, this.bytesList});
}

//#endregion

//#region Picture events
enum PictureEvents {
  ///non fa nulla
  idle,

  ///comprime le immagini
  compressList,

  ///aggiunge il file senza comprimere
  addFile,
}

class PictureEvent {
  final PictureEvents? status;
  final List<FilePickerResult>? fileList;
  final List<Uint8List>? bytesList;
  final String? name;
  final Uint8List? bytes;

  const PictureEvent({
    required this.status,
    this.fileList,
    this.bytesList,
    this.name,
    this.bytes,
  });
}
//#end region

//#region Media events
enum MediaEvents {
  ///non fa nulla
  idle,

  ///comprime i file
  compressList,

  ///aggiunta file senza compressione
  addFile,
}

class MediaEvent {
  final MediaEvents? status;
  final List<FilePickerResult>? fileList;
  final List<Uint8List>? bytesList;
  final String? name;
  final Uint8List? bytes;

  const MediaEvent(
      {required this.status,
      this.fileList,
      this.bytesList,
      this.name,
      this.bytes});
}

//#end region
//#region Picture events
enum ResourceEvents {
  ///non fa nulla
  idle,

  ///ottiene la preview dell'immagine richiesta
  fetchImagePreview,

  ///ottiene l'immagine richiesta
  fetchImage,

  ///ottiene la lista delle immagini
  fetchNameList,

  ///generate image with DALL-E 2
  generateImage,
}

class ResourceEvent {
  final ResourceEvents status;
  final String? name;
  final String? input;

  const ResourceEvent({required this.status, this.name, this.input});
}
//#end region

//#region Chat GPT
enum ChatGPTEvents {
  reset,
  resetChat,
  completion,
  showCompletion,
  showChat,
  saveDoc,
  chat,
}

class ChatGPTEvent extends Equatable {
  final ChatGPTEvents status;
  final String? question;
  final List<Message>? questionMessage;
  final String? response;
  final double temperature;
  final double frequencyPenalty;
  final double presencePenalty;
  final int tokens;
  final String? instruction;
  final String? example;
  final String? exampleContext;
  final String engine;
  final bool completionEnabled;

  final int assistMode;
  final double thresholdModifer;

  ///utilizzato per inviare un DocFrame
  final int? dataframeId;

  ///utilizzato per inviare un DocFrame
  final String? section;

  ///utilizzato per inviare un DocFrame
  final String? attachments;

  ///tipo di ricerca. 0 ricerca nella guida, 1 ricerca su tutto.
  final int? searchType;

  const ChatGPTEvent(
      {required this.status,
      this.question,
      this.response,
      this.temperature = 0.1,
      this.frequencyPenalty = 0.1,
      this.presencePenalty = 0.1,
      this.assistMode = 0,
      this.tokens = 4096,
      this.instruction,
      this.example,
      this.exampleContext,
      this.completionEnabled = true,
      this.thresholdModifer = 0,
      this.engine = 'text-davinci-003',
      this.dataframeId,
      this.section,
      this.searchType,
      this.attachments,
      this.questionMessage});

  @override
  List<Object?> get props =>
      [
        status,
        question,
        response,
        temperature,
        frequencyPenalty,
        presencePenalty,
        assistMode,
        tokens,
        instruction,
        example,
        exampleContext,
        engine,
        completionEnabled,
        thresholdModifer,
        searchType,
      ];
}
//#end region