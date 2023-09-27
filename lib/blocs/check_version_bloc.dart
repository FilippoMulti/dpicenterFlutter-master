import 'package:dpicenter/models/server/check_version_response.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckVersionBloc extends Bloc<CheckVersionEvent, CheckVersionState> {
  final CheckVersionRepo? repo;

  CheckVersionBloc({this.repo})
      : super(const CheckVersionInitState(
            event: CheckVersionEvent(
                status: CheckVersionEvents.idle, param: ""))) {
    on<CheckVersionEvent>((event, emit) async {
      try {
        switch (event.status) {
          case CheckVersionEvents.search:
            emit(CheckVersionLoading(event: event));
            Stopwatch s = Stopwatch();
            s.start();

            if (kIsWeb) {
              await Future.delayed(const Duration(milliseconds: 300));
            }
            List<CheckVersionResponse>? result = await repo!.checkVersion();

            emit(CheckVersionCompleted(
                event: event,
                response: result![0],
                elapsedMillisecond: s.elapsedMilliseconds,
                query: event.param!));
            s.stop();

            break;
          case CheckVersionEvents.download:
            emit(CheckVersionDownloading(
                event: event, progressValue: 0, sended: 0, total: 0));
            Stopwatch s = Stopwatch();
            s.start();

            int totalBytes = 0;

            DownloadResult? result =
                await repo!.downloadNewVersion((count, total) {
              double value = (count / total);
              totalBytes = total;
              if (kDebugMode) {
                print(value);
              }
              emit(CheckVersionDownloading(
                  event: event,
                  progressValue: value,
                  sended: count,
                  total: total));
            });

            if (result!.ok) {
              emit(CheckVersionDownloadCompleted(
                  event: event,
                  version: event.response,
                  elapsedMillisecond: s.elapsedMilliseconds,
                  path: result.path,
                  totalSended: totalBytes));
              s.stop();
            } else {
              emit(CheckVersionError(
                  event: event,
                  error: Exception(
                      "Non è stato possibile scaricare l'aggiornamento")));
            }
            break;
          case CheckVersionEvents.waitUpdate:
            emit(CheckVersionWaitState(event: event, path: event.path!));
            break;
          case CheckVersionEvents.autoLogin:
            emit(CheckVersionLoading(event: event));
            Stopwatch s = Stopwatch();
            s.start();

            bool? result = await repo!.autoLogin();

            emit(CheckVersionAutoLoginResult(event: event, result: result));
            s.stop();

            break;
          default:
            emit(CheckVersionInitState(
              event: event,
            ));
            break;
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(CheckVersionError(event: event, error: e, query: event.param!));
      } on Error catch (e) {
        emit(CheckVersionError(event: event, error: e, query: event.param!));
      }
    });
  }
}
