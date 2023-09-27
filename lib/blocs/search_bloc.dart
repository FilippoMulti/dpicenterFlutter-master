import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationScreenBloc
    extends Bloc<NavigationScreenEvent, NavigationScreenState> {
  final LocalSearchService? repo;

  NavigationScreenBloc({this.repo})
      : super(const NavigationScreenInitState(
            event: NavigationScreenEvent(
                status: NavigatorScreenEvents.search, param: ""))) {
    on<NavigationScreenEvent>((event, emit) async {
      try {
        switch (event.status) {
          case NavigatorScreenEvents.search:
            emit(NavigationScreenLoading(event: event));
            Stopwatch s = Stopwatch();
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
            Stopwatch s = Stopwatch();
            s.start();

            List<Menu>? result = await repo!.loadMenus(event.context!);

            if (result != null && result.isNotEmpty) {
              emit(NavigationScreenMenuLoaded(
                  event: event, menu: result[0], dashboardMenu: result[1]));
            }

            s.stop();

            break;

          default:
            break;
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(NavigationScreenError(
            event: event, error: e, searchQuery: event.param!));
      }
    });
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
}
