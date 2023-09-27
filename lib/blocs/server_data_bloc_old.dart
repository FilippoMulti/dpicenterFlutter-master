/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dpicenter/exceptions/exceptions.dart';
import 'package:dpicenter/models/server/print_response.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class ServerDataBloc<T> extends Bloc<ServerDataEvent<T>, ServerDataState<T>> {
  final CrudRepo<T>? repo;
  List<T>? items;

  ServerDataBloc({this.repo})
      : super(ServerDataInitState(
            event: ServerDataEvent(
                items: null, item: null, status: ServerDataEvents.fetch))) {
    on<ServerDataEvent<T>>((event, emit) async {
      try {
        print (event.status.toString());
        switch (event.status) {
          case ServerDataEvents.fetch:
            print ("fetch emit ServerDataLoading");
            emit(ServerDataLoading(event: event));
            print ("await repo!.fetch()");
            items = await repo!.fetch();

            if (items != null) {
              print ("items != null");
              print ("fetch emit ServerDataLoaded");
              emit(ServerDataLoaded(items: items, event: event));
              if (event.withComplete) {
                print ("event.withComplete -> fetch emit ServerDataLoadedCompleted");
                emit(ServerDataLoadedCompleted(items: items, event: event));
              }
            } else {
              print ("fetch emit ServerDataEror");
              emit(

                ServerDataError(
                    event: event,
                    error: Exception(
                        'ServerData Is Null!')), //NoInternetException('No Internet'),
              );
            }
            break;
          case ServerDataEvents.add:
            print ("add emit ServerDataLoading");
            emit(ServerDataLoading(event: event));

            bool? result = await repo!.add(event.item!);
            if (result!) {
              print ("add result!");
              print ("add emit ServerDataAdded");
              emit(ServerDataAdded(event: event, item: event.item));
            } else {
              print ("add emit ServerDataError");
              emit(ServerDataError(
                  event: event, error: Exception('Inserimento non riuscito!')));
            }

            break;
          case ServerDataEvents.update:
            print ("update emit ServerDataLoading");
            emit(ServerDataLoading(event: event));
            print ("try save");
            bool? result = await repo!.update(event.item!);
            if (result!) {
              print ("update emit ServerDataUpdated");
              emit(ServerDataUpdated(event: event, item: event.item));
            } else {
              print ("update emit ServerDataLoading");
              emit(ServerDataError(
                  event: event, error: Exception('Salvataggio non riuscito!')));
            }

            break;
          case ServerDataEvents.delete:
            emit(ServerDataLoading(event: event));

            bool? result = await repo!.deleteList(event.items);
            if (result!) {
              emit(ServerDataDeleted(event: event, items: event.items));
            } else {
              emit(ServerDataError(
                  event: event,
                  error: Exception('Cancellazione non riuscita!')));
            }

            break;
          case ServerDataEvents.exportPdf:
            emit(ServerDataLoading(event: event));

            List<PrintResponse>? result = await repo!.printThis(event.items);
            if (result != null && result.isNotEmpty) {
              Uint8List? file;
              if (result[0].resultFile!=null){
                file = base64Decode(result[0].resultFile!);
              }
              emit(ServerDataExported(event: event, response: result[0], file: file));
            } else {
              emit(ServerDataError(
                  event: event, error: Exception('Stampa non riuscita!')));
            }

            break;
          default:
            print ("state default");
            break;
        }
      } on BrowserHttpClientException catch (e) {
        print("BrowserHttpClientException");
        emit(ServerDataError(
          event: event,
          error: Exception(
              'Servizio non trovato. Verificare che il server sia avviato e che il firewall sia correttamente configurato\r\n\r\nEccezione completa:\r\n ' +
                  e.toString()), //NoServiceFoundException('No Service Found'),
        ));
      } on SocketException {
        print("SocketException");
        emit(ServerDataError(
          event: event,
          error: Exception('No Internet'), //NoInternetException('No Internet'),
        ));
      } on HttpException {
        print("HttpExcetpion");
        emit(ServerDataError(
          event: event,
          error: Exception(
              'No Service Found'), //NoServiceFoundException('No Service Found'),
        ));
      } on FormatException {
        print("FormatException");
        emit(ServerDataError(
          event: event,
          error: Exception(
              'Invalid Response format'), //InvalidFormatException('Invalid Response format'),
        ));
      } on FetchDataException catch (e) {
        print("FetchDataException");
        print(e.message[0]);

        var result = e.message[1];
        if (result != null) {
          emit(ServerDataLoaded(items: result, event: event, local: true));
        }
      } catch (e) {
        print("Errore server_data_bloc");
        try {

          print(e.hashCode.toString());
          print(e.toString());
          emit(ServerDataError(
                    event: event,
                    error: Exception('Unknown Errorfff\r\n' +
                        e.toString()), //UnknownException('Unknown Error'),
                  ));
        } catch (e) {
          print(e);
        }
      }
    });
  }

@override
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
  }

}
*/
