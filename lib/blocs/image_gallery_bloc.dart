import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dpicenter/globals/compress_image.dart';
import 'package:dpicenter/models/server/report_detail_image.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';
import 'package:mime/mime.dart';
import 'package:universal_io/io.dart';

class ImageGalleryBloc extends Bloc<ImageGalleryEvent, ImageGalleryState> {
  ///attualmente non usato
  final MultiService<ReportDetailImage>? repo;
  CancelableOperation? operation;
  final List<String> excludeFromCompression;

  ImageGalleryBloc({this.repo, this.excludeFromCompression = const ['.gif']})
      : super(const ImageGalleryInitState(
            event: ImageGalleryEvent(status: ImageGalleryEvents.idle))) {
    on<ImageGalleryEvent>(
      (event, emit) async {
        try {
          switch (event.status) {
            case ImageGalleryEvents.idle:
              await operation?.cancel();
              emit(ImageGalleryInitState(event: event));
              break;
            case ImageGalleryEvents.compressList:
              await operation?.cancel();

              List<String> compressedFiles = <String>[];

              List<ReportDetailImage> images = List.generate(
                  event.fileList!.length,
                  (index) => ReportDetailImage(file: event.fileList![0]));

              List<ReportDetailImage> miniImages = List.generate(
                  event.fileList!.length,
                  (index) => ReportDetailImage(file: event.fileList![0]));

              emit(ImageGalleryCompressStarted(
                compressedFilesStatus: compressedFiles,
                images: images,
                miniImages: miniImages,
                event: event,
                fileList: const <FilePickerResult>[],
              ));

              //await cropList(emit, images, event);
              operation = null;
              if (kIsWeb) {
                await Future.delayed(const Duration(milliseconds: 1000));
              }

              await fromCancelable(processList4(
                  emit, images, miniImages, compressedFiles, event, 256));

              if (event.fileList != null && event.fileList!.isNotEmpty) {
                String newDesc =
                    "Compress completed: ${event.fileList!.length.toString()} files compressed.";
                compressedFiles.add(newDesc);
                emit(ImageGalleryCompressCompleted(
                    fileList: event.fileList!,
                    compressedFilesStatus: compressedFiles,
                    images: images,
                    miniImages: miniImages,
                    event: event));
              } else {
                emit(ImageGalleryError(
                    error: Exception('fileList is empty'),
                    compressedFilesStatus: compressedFiles,
                    event: event));
              }

              emit(ImageGalleryEndState(
                  event: event, compressedFilesStatus: compressedFiles));
              break;
            default:
              break;
          }
/*
        switch (event.status) {
          case ImageGalleryEvents.idle:
            emit(NavigationScreenLoading(event: event));
            Stopwatch s = new Stopwatch();
            s.start();

            List<Menu?>? result = await repo!.findMenu(event.param!);

            emit(NavigationScreenSearchCompleted(
                event: event,
                response: result,
                elapsedMillisecond: s.elapsedMilliseconds,
                searchQuery: event.param!));
            s.stop();

            break;

          case NavigatorScreenEvents.idle:
            emit(NavigationScreenLoading(event: event));
            emit(NavigationScreenSearchCleared(event: event));
            break;

          case NavigatorScreenEvents.loadMenus:
            emit(NavigationScreenLoading(event: event));
            Stopwatch s = new Stopwatch();
            s.start();

            List<Menu>? result = await repo!.loadMenus(event.context!);

            if (result != null && result.length > 0) {
              emit(NavigationScreenMenuLoaded(
                  event: event, menu: result[0], dashboardMenu: result[1]));
            }

            s.stop();

            break;

          default:
            break;
        }
*/
        } on Exception catch (e) {
          if (kDebugMode) {
            print(e);
          }
          emit(ImageGalleryError(event: event, error: e));
        }
      },

      /// Specify a custom event transformer from `package:bloc_concurrency`
      transformer: restartable(),
    );
  }

  Future<dynamic> fromCancelable(Future<dynamic> future) async {
    await operation?.cancel();
    operation = CancelableOperation.fromFuture(future, onCancel: () {
      if (kDebugMode) {
        print('Operation Cancelled');
      }
    });
    return operation?.value;
  }

  /*Future<void> processList(Emitter emit, List<ReportDetailImage> images,
      List<String> compressedFiles, ImageGalleryEvent event,
      [int compressSize = 0]) async {
    int index = 0;

    for (var element in event.fileList!) {
      if (element != null) {
        try {
          Stopwatch sw = Stopwatch();
          sw.start();

          var result = compressSize > 0
              ? await compressPictureUint8List(element, compressSize)
              : await element.readAsBytes();
          String newDesc =
              "${element.path} compressed. Size: ${result.length.toString()} - Time: ${sw.elapsed.toString()}";
          images[index] = compressSize > 0
              ? images[index].copyWith(previewBytes: result)
              : images[index].copyWith(previewBytes: result);
          compressedFiles.add(newDesc);

          emit(ImageGalleryFileCompressed(
              images: images,
              file: element,
              bytes: result,
              compressedFilesStatus: compressedFiles,
              event: event));
        } catch (e) {
          String newDesc =
              "Error compress file '${element.path}'. Error: ${e.toString()}";
          compressedFiles.add(newDesc);
          emit(ImageGalleryFileCompressedError(
              file: element,
              error: e,
              compressedFilesStatus: compressedFiles,
              event: event));
        }
      }
      index++;
    }
  }

  Future<void> processList2(Emitter emit, List<ReportDetailImage> images,
      List<String> compressedFiles, ImageGalleryEvent event,
      [int compressSize = 0]) async {
    int index = 0;

    for (var element in event.fileList!) {
      if (operation?.isCanceled ?? false) {
        return;
      }
      if (element != null) {
        try {
          Stopwatch sw = Stopwatch();
          sw.start();
          Uint8List? result;
          if (isImage(element.path)) {
            result = await compressPicture2(element, compressSize);
            String newDesc =
                "${element.path} compressed. Size: ${result.length.toString()} - Time: ${sw.elapsed.toString()}";
            images[index] =
                images[index].copyWith(previewBytes: result, bytes: result);
            compressedFiles.add(newDesc);
          } else if (isVideo(element.path)) {
            result = await element.readAsBytes();
            images[index] = images[index].copyWith(bytes: result);
          }
          emit(ImageGalleryFileCompressed(
              images: images,
              file: element,
              bytes: result ?? Uint8List(0),
              compressedFilesStatus: compressedFiles,
              event: event));
        } catch (e) {
          String newDesc =
              "Error compress file '${element.path}'. Error: ${e.toString()}";
          compressedFiles.add(newDesc);
          emit(ImageGalleryFileCompressedError(
              file: element,
              error: e,
              compressedFilesStatus: compressedFiles,
              event: event));
        }
      }
      index++;
    }
  }*/
  Future<void> processList3(Emitter emit, List<ReportDetailImage> images,
      List<String> compressedFiles, ImageGalleryEvent event,
      [int compressSize = 0]) async {
    int index = 0;

    for (var element in event.fileList!) {
      if (operation?.isCanceled ?? false) {
        return;
      }
      try {
        Stopwatch sw = Stopwatch();
        sw.start();
        Uint8List? result;
        if (kIsWeb) {
          result =
              await compressPicture3(element.files.first.bytes!, compressSize);
        } else {
          result = await compressPicture2(
              File(element.files.first.path!), compressSize);
        }
        images[index] =
            images[index].copyWith(previewBytes: result, bytes: result);

        emit(ImageGalleryFileCompressed(
            images: images,
            //miniImages: null,
            file: element,
            bytes: result!,
            compressedFilesStatus: compressedFiles,
            event: event));
      } catch (e) {
        emit(ImageGalleryFileCompressedError(
            file: element,
            error: e,
            compressedFilesStatus: compressedFiles,
            event: event));
      }
      index++;
    }
  }

  Future<void> processList4(
      Emitter emit,
      List<ReportDetailImage> images,
      List<ReportDetailImage> miniImages,
      List<String> compressedFiles,
      ImageGalleryEvent event,
      [int compressSize = 0]) async {
    int index = 0;

    for (var element in event.fileList!) {
      if (operation?.isCanceled ?? false) {
        return;
      }
      try {
        Stopwatch sw = Stopwatch();
        sw.start();
        Uint8List? result;
        Uint8List? miniResult;

        if (kIsWeb) {
          if (_isToCompress(element.files.first.name)) {
            result = await compressPicture3(
                element.files.first.bytes!, compressSize);
          } else {
            result = element.files.first.bytes!;
          }
          //   miniResult = await compressPicture3(element.files.first.bytes!, 32);
        } else {
          if (_isToCompress(element.files.first.path!)) {
            result = await compressPicture2(
                File(element.files.first.path!), compressSize);
          } else {
            var imageBytes =
                await File(element.files.first.path!).readAsBytesSync();
            result = imageBytes;
          }
          //  miniResult = await compressPicture2(File(element.files.first.path!), 32);
        }

        images[index] =
            images[index].copyWith(previewBytes: result, bytes: result);
        /*miniImages[index] =
            miniImages[index].copyWith(previewBytes: miniResult, bytes: miniResult);*/

        emit(ImageGalleryFileCompressed(
            images: images,
            //miniImages: miniImages,
            file: element,
            bytes: result!,
            compressedFilesStatus: compressedFiles,
            event: event));
      } catch (e) {
        emit(ImageGalleryFileCompressedError(
            file: element,
            error: e,
            compressedFilesStatus: compressedFiles,
            event: event));
      }
      index++;
    }
  }

  bool _isToCompress(String pathOrName) {
    return excludeFromCompression
        .where((element) => pathOrName.endsWith(element))
        .isEmpty;
  }

  Future<Uint8List> cropImage(FilePickerResult imageFile) async {
    final Uint8List image = imageFile.files[0].bytes!;
    final decodedImage = decodeImage(image);

    const rectangle = Rect.fromLTRB(0, 0, 128, 128);

    final crop = copyCrop(
      decodedImage!,
      x: rectangle.topLeft.dx.toInt(),
      y: rectangle.topLeft.dy.toInt(),
      width: rectangle.width.toInt(),
      height: rectangle.height.toInt(),
    );

    return Uint8List.fromList(encodePng(crop));
  }

  Future<void> cropList(Emitter emit, List<ReportDetailImage> images,
      ImageGalleryEvent event) async {
    int index = 0;

    for (var element in event.fileList!) {
      try {
        Stopwatch sw = Stopwatch();
        sw.start();

        var result = await cropImage(element);
        images[index] = images[index].copyWith(previewBytes: result);

        emit(ImageGalleryFileCompressed(
          images: images, file: element, bytes: result, event: event,
          //miniImages: null
        ));
      } catch (e) {
        emit(ImageGalleryFileCompressedError(
            file: element, error: e, event: event));
      }
      index++;
    }
  }

/*@override
  Stream<ServerDataState<T>> mapEventToState(ServerDataEvent<T> event) async* {
    try {
      switch (event.status) {
        case ServerDataEvents.fetch:
          yield ServerDataLoading(event: event);

          items = await repo!.fetch();
          if (items != null) {
            yield ServerDataLoaded(items: items, event: event);
          } else {
            yield ServerDataError(
              event: event,
              error: Exception(
                  'Manufacturers Is Null!'), //NoInternetException('No Internet'),
            );
          }
          break;
        case ServerDataEvents.add:
          yield ServerDataLoading(event: event);

          bool? result = await repo!.add(event.item!);
          if (result!) {
            yield ServerDataAdded(event: event, item: event.item);
          } else {
            yield ServerDataError(
                event: event, error: Exception('Inserimento non riuscito!'));
          }

          break;
        case ServerDataEvents.update:
          yield ServerDataLoading(event: event);

          bool? result = await repo!.update(event.item!);
          if (result!) {
            yield ServerDataUpdated(event: event, item: event.item);
          } else {
            yield ServerDataError(
                event: event, error: Exception('Salvataggio non riuscito!'));
          }

          break;
        case ServerDataEvents.delete:
          yield ServerDataLoading(event: event);

          bool? result = await repo!.deleteList(event.items!);
          if (result!) {
            yield ServerDataDeleted(event: event, items: event.items);
          } else {
            yield ServerDataError(
                event: event, error: Exception('Cancellazione non riuscita!'));
          }

          break;

        default:
          break;
      }
    } on BrowserHttpClientException catch (e) {
      yield ServerDataError(
        event: event,
        error: Exception(
            'Servizio non trovato. Verificare che il server sia avviato e che il firewall sia correttamente configurato\r\n\r\nEccezione completa:\r\n ' +
                e.toString()), //NoServiceFoundException('No Service Found'),
      );
    } on SocketException {
      yield ServerDataError(
        event: event,
        error: Exception('No Internet'), //NoInternetException('No Internet'),
      );
    } on HttpException {
      yield ServerDataError(
        event: event,
        error: Exception(
            'No Service Found'), //NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield ServerDataError(
        event: event,
        error: Exception(
            'Invalid Response format'), //InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield ServerDataError(
        event: event,
        error: Exception('Unknown Error\r\n' +
            e.toString()), //UnknownException('Unknown Error'),
      );
    }
  }*/

  static bool isImage(String path) {
    final mimeType = lookupMimeType(path);

    return mimeType?.startsWith('image/') ?? false;
  }

  static bool isVideo(String path) {
    final mimeType = lookupMimeType(path);

    return mimeType?.startsWith('video/') ?? false;
  }
}
