import 'dart:math';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dpicenter/globals/compress_image.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';
import 'package:mime/mime.dart';
import 'package:universal_io/io.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  CancelableOperation? operation;

  MediaBloc()
      : super(
            const MediaInitState(event: MediaEvent(status: MediaEvents.idle))) {
    on<MediaEvent>(
      (event, emit) async {
        try {
          switch (event.status) {
            case MediaEvents.idle:
              await operation?.cancel();
              emit(MediaInitState(event: event));
              break;
            case MediaEvents.compressList:
              await operation?.cancel();

              List<String> compressedFiles = <String>[];

              List<Media> medias = List.generate(
                  event.fileList![0].files.length,
                  (index) => Media(
                      name: event.fileList![0].files[index].name,
                      compressionId: Random().nextInt(10000000),
                      file: event.fileList![0].files[index]));

              List<Media> miniMedias = List.generate(
                  event.fileList![0].files.length,
                  (index) => Media(
                      name: event.fileList![0].files[index].name,
                      compressionId: Random().nextInt(10000000),
                      file: event.fileList![0].files[index]));

              emit(MediaCompressStarted(
                compressedFilesStatus: compressedFiles,
                medias: medias,
                miniMedias: miniMedias,
                event: event,
                fileList: const <FilePickerResult>[],
              ));

              //await cropList(emit, images, event);
              operation = null;
              if (kIsWeb) {
                await Future.delayed(const Duration(milliseconds: 1000));
              }
              await fromCancelable(processList4(
                  emit, medias, miniMedias, compressedFiles, event, 1024));

              if (event.fileList != null && event.fileList!.isNotEmpty) {
                String newDesc =
                    "Compress completed: ${event.fileList!.length.toString()} files compressed.";
                compressedFiles.add(newDesc);
                emit(MediaCompressCompleted(
                    fileList: event.fileList!,
                    compressedFilesStatus: compressedFiles,
                    medias: medias,
                    miniMedias: miniMedias,
                    event: event));
              } else {
                emit(MediaError(
                    error: Exception('fileList is empty'),
                    compressedFilesStatus: compressedFiles,
                    event: event));
              }

              emit(MediaEndState(
                  event: event, compressedFilesStatus: compressedFiles));
              break;

            case MediaEvents.addFile:
              await operation?.cancel();

              List<Media> medias = List.generate(
                  1,
                  (index) => Media(
                      name: event.name ?? '_noname',
                      compressionId: Random().nextInt(10000000),
                      bytes: event.bytes));

              emit(MediaAddCompleted(
                medias: medias,
                event: event,
              ));

              emit(MediaEndState(event: event));
              break;
            default:
              break;
          }
/*
        switch (event.status) {
          case PictureEvents.idle:
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
          emit(MediaError(event: event, error: e));
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

  Future<void> processList3(Emitter emit, List<Media> medias,
      List<String> compressedFiles, MediaEvent event,
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
        medias[index] =
            medias[index].copyWith(previewBytes: result, bytes: result);

        emit(MediaCompressed(
            medias: medias,
            media: medias[index],
            name: element.files.first.name,
            //miniImages: null,
            file: element,
            bytes: result!,
            compressedFilesStatus: compressedFiles,
            event: event));
      } catch (e) {
        emit(MediaCompressedError(
            file: element,
            error: e,
            compressedFilesStatus: compressedFiles,
            event: event));
      }
      index++;
    }
  }

  Future<void> processList4(Emitter emit, List<Media> medias,
      List<Media> miniMedias, List<String> compressedFiles, MediaEvent event,
      [int compressSize = 0]) async {
    int index = 0;

    for (var file in event.fileList!) {
      for (var element in file.files) {
        if (operation?.isCanceled ?? false) {
          return;
        }
        try {
          Stopwatch sw = Stopwatch();
          sw.start();
          Uint8List? result;

          if (kIsWeb) {
            result = element.bytes!;
            //result = await compressPicture3(element.bytes!, compressSize);
            //   miniResult = await compressPicture3(element.files.first.bytes!, 32);
          } else {
            result = File(element.path!).readAsBytesSync();
            //await compressPicture2(File(element.path!), compressSize);
            //  miniResult = await compressPicture2(File(element.files.first.path!), 32);
          }

          medias[index] =
              medias[index].copyWith(previewBytes: null, bytes: result);
          /*miniImages[index] =
            miniImages[index].copyWith(previewBytes: miniResult, bytes: miniResult);*/

          emit(MediaCompressed(
              medias: medias,
              media: medias[index],
              //miniImages: miniImages,
              name: element.name,
              file: file,
              bytes: result,
              compressedFilesStatus: compressedFiles,
              event: event));
        } catch (e) {
          emit(MediaCompressedError(
              file: file,
              error: e,
              compressedFilesStatus: compressedFiles,
              event: event));
        }
        index++;
      }
    }
  }

  static bool isImage(String path) {
    final mimeType = lookupMimeType(path);

    return mimeType?.startsWith('image/') ?? false;
  }

  static bool isVideo(String path) {
    final mimeType = lookupMimeType(path);

    return mimeType?.startsWith('video/') ?? false;
  }
}
