import 'dart:typed_data';

import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/auth_response.dart';
import 'package:dpicenter/models/server/check_version_response.dart';
import 'package:dpicenter/models/server/dalle/response_model.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/openai/message.dart';
import 'package:dpicenter/models/server/print_response.dart';
import 'package:dpicenter/models/server/report_detail_image.dart';
import 'package:dpicenter/models/server/resource_response.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/wikiquote.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import 'events.dart';

//#region Base
abstract class DpiCenterState extends Equatable {
  @override
  List<Object> get props => [];

  const DpiCenterState();
}

//#endregion
//#region Base
abstract class ServerDataState<T> extends Equatable {
  final ServerDataEvent? event;

  const ServerDataState({required this.event});

  @override
  List<Object?> get props => [event];
}
//#endregion


//#region ServerDataStates

class ServerDataInitState<T> extends ServerDataState<T> {
  const ServerDataInitState({required ServerDataEvent? event})
      : super(event: event);

  @override
  List<Object?> get props => [event];
}

class ServerDataLoading<T> extends ServerDataState<T> {
  const ServerDataLoading({required ServerDataEvent? event})
      : super(event: event);

  @override
  List<Object?> get props => [event];
}

class ServerDataLoadingSendProgress<T> extends ServerDataState<T> {
  final int sent;
  final int total;

  const ServerDataLoadingSendProgress(
      {required ServerDataEvent? event, this.sent = 0, this.total = 0})
      : super(event: event);

  @override
  List<Object?> get props => [event, sent, total];
}

class ServerDataLoadingReceiveProgress<T> extends ServerDataState<T> {
  final int sent;
  final int total;

  const ServerDataLoadingReceiveProgress(
      {required ServerDataEvent? event, this.sent = 0, this.total = 0})
      : super(event: event);

  @override
  List<Object?> get props => [event, sent, total];
}

class ServerDataExported<T> extends ServerDataState<T> {
  final PrintResponse? response;
  final Uint8List? file;

  const ServerDataExported(
      {required ServerDataEvent? event, this.response, this.file})
      : super(event: event);

  @override
  List<Object?> get props => [event, file];
}

class ServerDataLoaded<T> extends ServerDataState<T> {
  final List<T>? items;
  final List? untypedItems; //items di tipo diverso rispetto a T

  ///true quando il risultato è stato caricato localmente
  final bool? local;

  const ServerDataLoaded(
      {this.items,
      this.untypedItems,
      required ServerDataEvent? event,
      this.local})
      : super(event: event);

  @override
  List<Object?> get props => [event, items, local];
}

class ServerDataCommandCompleted<T> extends ServerDataState<T> {
  final List<T>? items;

  ///true quando il risultato è stato caricato localmente
  final bool? local;

  const ServerDataCommandCompleted(
      {this.items, required ServerDataEvent? event, this.local})
      : super(event: event);

  @override
  List<Object?> get props => [event, items, local];
}

class ServerDataLoadedCompleted<T> extends ServerDataState<T> {
  final List<T>? items;

  ///true quando il risultato è stato caricato localmente
  final bool? local;

  const ServerDataLoadedCompleted(
      {this.items, required ServerDataEvent? event, this.local})
      : super(event: event);

  @override
  List<Object?> get props => [event, items, local];
}

class ServerDataError<T> extends ServerDataState<T> {
  final dynamic error;

  const ServerDataError({this.error, required ServerDataEvent? event})
      : super(event: event);

  @override
  List<Object?> get props => [event, error];
}

class ServerDataAdded<T> extends ServerDataState<T> {
  final T? item;
  final List<T>? items;

  const ServerDataAdded(
      {this.item, this.items, required ServerDataEvent? event})
      : super(event: event);

  @override
  List<Object?> get props => [event, item, items];
}

class ServerDataUpdated<T> extends ServerDataState<T> {
  final T? item;
  final List<T>? items;

  const ServerDataUpdated(
      {this.item, this.items, required ServerDataEvent? event})
      : super(event: event);

  @override
  List<Object?> get props => [event, item, items];
}

class ServerDataDeleted<T> extends ServerDataState<T> {
  final T? item;
  final List<T>? items;

  const ServerDataDeleted(
      {this.item, this.items, required ServerDataEvent? event})
      : super(event: event);
}

//#endregion
//#region LoginState
abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitState extends LoginState {}

class LoginLoading extends LoginState {}

class LoginCompleted extends LoginState {
  final AuthResponse? response;

  LoginCompleted({this.response});
}

class LoginError extends LoginState {
  final dynamic error;

  LoginError({this.error});
}

//#endregion
//#region QuoteState
abstract class QuoteState extends Equatable {
  @override
  List<Object> get props => [];
}

class QuoteInitState extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteCompleted extends QuoteState {
  final List<Quote>? items;

  QuoteCompleted({this.items});
}

class QuoteError extends QuoteState {
  final dynamic error;

  QuoteError({this.error});
}

//#endregion

//#region NavigationScreenState
abstract class NavigationScreenState extends Equatable {
  @override
  List<Object> get props => [];

  final NavigationScreenEvent? event;

  const NavigationScreenState({required this.event});
}

class NavigationScreenInitState extends NavigationScreenState {
  const NavigationScreenInitState({required NavigationScreenEvent? event})
      : super(event: event);

  @override
  List<Object> get props => [event!];
}

class NavigationScreenLoading extends NavigationScreenState {
  const NavigationScreenLoading({required NavigationScreenEvent? event})
      : super(event: event);

  @override
  List<Object> get props => [event!];
}

class NavigationScreenSearchCompleted extends NavigationScreenState {
  final List? response;

  final int? elapsedMillisecond;
  final String? searchQuery;

  const NavigationScreenSearchCompleted(
      {required NavigationScreenEvent? event,
      this.response,
      this.elapsedMillisecond,
      this.searchQuery})
      : super(event: event);

  @override
  List<Object> get props =>
      [event!, response!, elapsedMillisecond!, searchQuery!];
}

class NavigationScreenSearchCleared extends NavigationScreenState {
  const NavigationScreenSearchCleared({required NavigationScreenEvent? event})
      : super(event: event);

  @override
  List<Object> get props => [event!];
}

class NavigationScreenMenuLoading extends NavigationScreenState {
  const NavigationScreenMenuLoading({required NavigationScreenEvent? event})
      : super(event: event);

  @override
  List<Object> get props => [event!];
}

class NavigationScreenMenuLoaded extends NavigationScreenState {
  final Menu? menu;
  final Menu? dashboardMenu;

  const NavigationScreenMenuLoaded(
      {this.menu, this.dashboardMenu, required NavigationScreenEvent? event})
      : super(event: event);

  @override
  List<Object> get props => [event!, event!, dashboardMenu!];
}

class NavigationScreenError extends NavigationScreenState {
  final dynamic error;

  final String? searchQuery;

  const NavigationScreenError(
      {required NavigationScreenEvent? event, this.error, this.searchQuery})
      : super(event: event);

  @override
  List<Object> get props => [error!, event!, searchQuery!];
}
//#endregion

//#region CheckVersionStates
abstract class CheckVersionState extends Equatable {
  @override
  List<Object?> get props => [event];

  final CheckVersionEvent? event;

  const CheckVersionState({required this.event});
}

class CheckVersionInitState extends CheckVersionState {
  const CheckVersionInitState({required CheckVersionEvent? event})
      : super(event: event);

  @override
  List<Object?> get props => [event];
}

class CheckVersionWaitState extends CheckVersionState {
  final String path;

  const CheckVersionWaitState(
      {required CheckVersionEvent? event, required this.path})
      : super(event: event);

  @override
  List<Object?> get props => [event, path];
}

class CheckVersionLoading extends CheckVersionState {
  const CheckVersionLoading({required CheckVersionEvent? event})
      : super(event: event);

  @override
  List<Object?> get props => [event];
}

class CheckVersionAutoLoginResult extends CheckVersionState {
  final bool? result;

  const CheckVersionAutoLoginResult(
      {required CheckVersionEvent? event, this.result})
      : super(event: event);

  @override
  List<Object?> get props => [event, result];
}

class CheckVersionDownloading extends CheckVersionState {
  final double progressValue;
  final int sended;
  final int total;

  const CheckVersionDownloading(
      {required CheckVersionEvent? event,
      required this.progressValue,
      required this.sended,
      required this.total})
      : super(event: event);

  @override
  List<Object?> get props => [event, progressValue];
}

class CheckVersionDownloadCompleted extends CheckVersionState {
  final CheckVersionResponse? version;
  final int? elapsedMillisecond;
  final String path;
  final int totalSended;

  const CheckVersionDownloadCompleted(
      {required CheckVersionEvent? event,
      this.version,
      this.elapsedMillisecond,
      required this.totalSended,
      required this.path})
      : super(event: event);

  @override
  List<Object?> get props => [event, version, elapsedMillisecond, path];
}

class CheckVersionCompleted extends CheckVersionState {
  final CheckVersionResponse? response;

  final int? elapsedMillisecond;
  final String? query;

  const CheckVersionCompleted(
      {required CheckVersionEvent? event,
      this.response,
      this.elapsedMillisecond,
      this.query})
      : super(event: event);

  @override
  List<Object?> get props => [event, response, elapsedMillisecond, query];
}

class CheckVersionCleared extends CheckVersionState {
  const CheckVersionCleared({required CheckVersionEvent? event})
      : super(event: event);

  @override
  List<Object?> get props => [event];
}

class CheckVersionError extends CheckVersionState {
  final dynamic error;
  final String? query;

  const CheckVersionError(
      {required CheckVersionEvent? event, this.error, this.query})
      : super(event: event);

  @override
  List<Object?> get props => [event, error, query];
}
//#endregion

//#region SyncStates
abstract class SyncState extends Equatable {
  final SyncEvent? event;

  const SyncState({this.event});

  @override
  List<Object> get props => [];
}

class SyncInitState extends SyncState {
  const SyncInitState({required SyncEvent? event}) : super(event: event);
}

class SyncLoading extends SyncState {

  const SyncLoading({required SyncEvent? event}) : super(event: event);
}

class SyncCompleted extends SyncState {
  final bool? result;

  const SyncCompleted({required SyncEvent? event, this.result})
      : super(event: event);
}

class SyncError extends SyncState {
  final dynamic error;

  const SyncError({required SyncEvent? event, this.error})
      : super(event: event);
}

//#endregion

//#region ImageGalleryStates
abstract class ImageGalleryState extends Equatable {
  @override
  List<Object?> get props => [];

  final ImageGalleryEvent? event;

  const ImageGalleryState({required this.event});
}

class ImageGalleryInitState extends ImageGalleryState {
  const ImageGalleryInitState({ImageGalleryEvent? event}) : super(event: event);
}

class ImageGalleryEndState extends ImageGalleryState {
  final List<String>? compressedFilesStatus;

  const ImageGalleryEndState(
      {ImageGalleryEvent? event, this.compressedFilesStatus})
      : super(event: event);
}

class ImageGalleryError extends ImageGalleryState {
  final dynamic error;
  final List<String>? compressedFilesStatus;

  const ImageGalleryError(
      {this.error, ImageGalleryEvent? event, this.compressedFilesStatus})
      : super(event: event);

  @override
  List<Object?> get props => [event, error];
}

class ImageGalleryFileCompressed extends ImageGalleryState {
  final FilePickerResult? file;
  final Uint8List bytes;
  final List<String>? compressedFilesStatus;
  final List<ReportDetailImage>? images;

  //final List<ReportDetailImage>? miniImages;

  const ImageGalleryFileCompressed({
    required this.file,
    required this.bytes,
    ImageGalleryEvent? event,
    this.compressedFilesStatus,
    required this.images,
    //required this.miniImages
  }) : super(event: event);

  @override
  List<Object?> get props => [event, file];
}

class ImageGalleryFileCompressedError extends ImageGalleryState {
  final FilePickerResult? file;
  final dynamic error;
  final List<String>? compressedFilesStatus;

  const ImageGalleryFileCompressedError(
      {required this.file,
      required this.error,
      ImageGalleryEvent? event,
      this.compressedFilesStatus})
      : super(event: event);

  @override
  List<Object?> get props => [event, file, error];
}

class ImageGalleryCompressCompleted extends ImageGalleryState {
  final List<FilePickerResult?> fileList;
  final List<String>? compressedFilesStatus;
  final List<ReportDetailImage> images;
  final List<ReportDetailImage> miniImages;

  const ImageGalleryCompressCompleted(
      {required this.fileList,
      ImageGalleryEvent? event,
      this.compressedFilesStatus,
      required this.images,
      required this.miniImages})
      : super(event: event);

  @override
  List<Object?> get props => [event, fileList];
}

class ImageGalleryCompressStarted extends ImageGalleryState {
  final List<FilePickerResult?> fileList;
  final List<String>? compressedFilesStatus;
  final List<ReportDetailImage> images;
  final List<ReportDetailImage> miniImages;

  const ImageGalleryCompressStarted({required this.fileList,
    ImageGalleryEvent? event,
    this.compressedFilesStatus,
    required this.images,
    required this.miniImages})
      : super(event: event);

  @override
  List<Object?> get props => [event, fileList, images];
}
//#endregion

//#region PictureStates
abstract class PictureState extends Equatable {
  @override
  List<Object?> get props => [];

  final PictureEvent? event;

  const PictureState({required this.event});
}

class PictureInitState extends PictureState {
  const PictureInitState({PictureEvent? event}) : super(event: event);
}

class PictureEndState extends PictureState {
  final List<String>? compressedFilesStatus;

  const PictureEndState({PictureEvent? event, this.compressedFilesStatus})
      : super(event: event);
}

class PictureError extends PictureState {
  final dynamic error;
  final List<String>? compressedFilesStatus;

  const PictureError(
      {this.error, PictureEvent? event, this.compressedFilesStatus})
      : super(event: event);

  @override
  List<Object?> get props => [event, error];
}

class PictureCompressed extends PictureState {
  final FilePickerResult? file;
  final Uint8List bytes;
  final List<String>? compressedFilesStatus;
  final List<Media>? images;
  final Media? image;
  final String name;

  //final List<ReportDetailImage>? miniImages;

  const PictureCompressed({
    required this.name,
    required this.file,
    required this.bytes,
    PictureEvent? event,
    this.compressedFilesStatus,
    required this.images,
    this.image,
    //required this.miniImages
  }) : super(event: event);

  @override
  List<Object?> get props => [event, file, images, image, bytes];
}

class PictureCompressedError extends PictureState {
  final FilePickerResult? file;
  final dynamic error;
  final List<String>? compressedFilesStatus;

  const PictureCompressedError({required this.file,
    required this.error,
    PictureEvent? event,
    this.compressedFilesStatus})
      : super(event: event);

  @override
  List<Object?> get props => [event, file, error];
}

class PictureCompressCompleted extends PictureState {
  final List<FilePickerResult?> fileList;
  final List<String>? compressedFilesStatus;
  final List<Media> images;
  final List<Media> miniImages;

  const PictureCompressCompleted({required this.fileList,
    PictureEvent? event,
    this.compressedFilesStatus,
    required this.images,
    required this.miniImages})
      : super(event: event);

  @override
  List<Object?> get props => [event, fileList];
}

class PictureAddCompleted extends PictureState {
  final List<Media> images;


  const PictureAddCompleted({
    PictureEvent? event,
    required this.images,
  })
      : super(event: event);

  @override
  List<Object?> get props => [event, images,];
}
class PictureCompressStarted extends PictureState {
  final List<FilePickerResult?> fileList;
  final List<String>? compressedFilesStatus;
  final List<Media> images;
  final List<Media> miniImages;

  const PictureCompressStarted(
      {required this.fileList,
      PictureEvent? event,
      this.compressedFilesStatus,
      required this.images,
      required this.miniImages})
      : super(event: event);

  @override
  List<Object?> get props => [event, fileList, images];
}
//#endregion

//#region MediaStates
abstract class MediaState extends Equatable {
  @override
  List<Object?> get props => [];

  final MediaEvent? event;

  const MediaState({required this.event});
}

class MediaInitState extends MediaState {
  const MediaInitState({MediaEvent? event}) : super(event: event);
}

class MediaEndState extends MediaState {
  final List<String>? compressedFilesStatus;

  const MediaEndState({MediaEvent? event, this.compressedFilesStatus})
      : super(event: event);
}

class MediaError extends MediaState {
  final dynamic error;
  final List<String>? compressedFilesStatus;

  const MediaError({this.error, MediaEvent? event, this.compressedFilesStatus})
      : super(event: event);

  @override
  List<Object?> get props => [event, error];
}

class MediaCompressed extends MediaState {
  final FilePickerResult? file;
  final Uint8List bytes;
  final List<String>? compressedFilesStatus;
  final List<Media>? medias;
  final Media? media;
  final String name;

  //final List<ReportDetailImage>? miniImages;

  const MediaCompressed({
    required this.name,
    required this.file,
    required this.bytes,
    MediaEvent? event,
    this.compressedFilesStatus,
    required this.medias,
    this.media,
    //required this.miniImages
  }) : super(event: event);

  @override
  List<Object?> get props => [event, file, medias, media, bytes];
}

class MediaCompressedError extends MediaState {
  final FilePickerResult? file;
  final dynamic error;
  final List<String>? compressedFilesStatus;

  const MediaCompressedError(
      {required this.file,
      required this.error,
      MediaEvent? event,
      this.compressedFilesStatus})
      : super(event: event);

  @override
  List<Object?> get props => [event, file, error];
}

class MediaCompressCompleted extends MediaState {
  final List<FilePickerResult?> fileList;
  final List<String>? compressedFilesStatus;
  final List<Media> medias;
  final List<Media> miniMedias;

  const MediaCompressCompleted(
      {required this.fileList,
      MediaEvent? event,
      this.compressedFilesStatus,
      required this.medias,
      required this.miniMedias})
      : super(event: event);

  @override
  List<Object?> get props => [event, fileList];
}

class MediaCompressStarted extends MediaState {
  final List<FilePickerResult?> fileList;
  final List<String>? compressedFilesStatus;
  final List<Media> medias;
  final List<Media> miniMedias;

  const MediaCompressStarted(
      {required this.fileList,
      MediaEvent? event,
      this.compressedFilesStatus,
      required this.medias,
      required this.miniMedias})
      : super(event: event);

  @override
  List<Object?> get props => [
        event,
        fileList,
        medias,
      ];
}

class MediaAddCompleted extends MediaState {
  final List<Media> medias;

  const MediaAddCompleted({
    MediaEvent? event,
    required this.medias,
  }) : super(event: event);

  @override
  List<Object?> get props => [
        event,
        medias,
      ];
}
//#endregion

//#region ResourceStates
abstract class ResourceState extends Equatable {
  @override
  List<Object?> get props => [];

  final ResourceEvent event;

  const ResourceState({required this.event});
}

class ResourceInitState extends ResourceState {
  const ResourceInitState({required ResourceEvent event}) : super(event: event);
}

class ResourceFetchCompletedState extends ResourceState {
  final List<ResourceResponse> items;
  final List<ResourceResponse>? nameList;

  const ResourceFetchCompletedState(
      {required ResourceEvent event, required this.items, this.nameList})
      : super(event: event);
}

class ResourceError extends ResourceState {
  final dynamic error;

  const ResourceError({this.error, required ResourceEvent event})
      : super(event: event);

  @override
  List<Object?> get props => [event, error];
}

//#endregion
//#region ChatGPT States
abstract class ChatGPTState extends Equatable {
  final ChatGPTEvent? event;

  const ChatGPTState({this.event});

  @override
  List<Object?> get props => [event];
}

class ChatGPTInitState extends ChatGPTState {
  const ChatGPTInitState({super.event});

  @override
  List<Object?> get props => [event];
}

class ChatGPTRequestState extends ChatGPTState {
  final String question;

  const ChatGPTRequestState({super.event, required this.question});

  @override
  List<Object?> get props => [event, question];
}

class ChatGPTCompletionResponseState extends ChatGPTState {
  final String question;
  final String answer;
  final bool started;

  const ChatGPTCompletionResponseState(
      {super.event,
      required this.question,
      required this.answer,
      required this.started});

  @override
  List<Object?> get props => [event, question, answer, started];
}

class ChatGPTChatResponseState extends ChatGPTState {
  final List<Message> question;
  final List<Message> answer;
  final bool started;

  const ChatGPTChatResponseState(
      {super.event,
      required this.question,
      required this.answer,
      required this.started});

  @override
  List<Object?> get props => [event, question, answer, started];
}

class ChatGPTSaveDocState extends ChatGPTState {
  final bool started;
  final bool finished;
  final String? url;

  const ChatGPTSaveDocState(
      {super.event, required this.finished, this.url, required this.started});

  @override
  List<Object?> get props => [event, finished, url, started];
}

class ChatGPTError extends ChatGPTState {
  final dynamic error;

  const ChatGPTError({this.error, ChatGPTEvent? event}) : super(event: event);

  @override
  List<Object?> get props => [event, error];
}
//#endregion