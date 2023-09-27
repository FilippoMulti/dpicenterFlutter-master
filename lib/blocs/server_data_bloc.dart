import 'dart:convert';
import 'dart:typed_data';
import 'package:dpicenter/datagrid/filter.dart';
import 'package:dpicenter/exceptions/exceptions.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/print_response.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:gato/gato.dart' as gato;

class ServerDataBloc<T> extends Bloc<ServerDataEvent<T>, ServerDataState<T>> {
  final CrudRepo<T>? repo;
  List<T>? items;
  List<T>? filteredItems;

  List<T>? get totalItems => items;

  List<T>? get totalFilteredItems => filteredItems;

  ServerDataBloc({this.repo})
      : super(const ServerDataInitState(
            event: ServerDataEvent(
                items: null, item: null, status: ServerDataEvents.fetch))) {
    on<ServerDataEvent<T>>(
      (event, emit) async {
        try {
          if (kDebugMode) {
            print(event.status.toString());
          }

          switch (event.status) {
            case ServerDataEvents.fetch:
              if (kDebugMode) {
                print("fetch");
              }
              if (event.onEvent != null) {
                await event.onEvent!.call(this, event, emit);
              } else {
                if (kDebugMode) {
                  print("fetch emit ServerDataLoading");
                }
                //if (event.refresh) {
                emit(ServerDataLoading(event: event));
                //}
                if (kDebugMode) {
                  print("await repo!.fetch()");
                }

                await fetch(event, emit);

                /*items = await repo!.fetch();*/

                if (items != null && filteredItems != null) {
                  if (kDebugMode) {
                    print("items != null");
                  }
                  if (kDebugMode) {
                    print("fetch emit ServerDataLoaded");
                  }
                  emit(ServerDataLoaded(items: filteredItems, event: event));
                  event.onDataLoaded?.call(filteredItems);

                  if (event.withComplete) {
                    if (kDebugMode) {
                      print(
                          "event.withComplete -> fetch emit ServerDataLoadedCompleted");
                    }
                    emit(ServerDataLoadedCompleted(
                        items: filteredItems, event: event));
                    event.onDataLoaded?.call(filteredItems);
                  }
                } else {
                  if (kDebugMode) {
                    print("fetch emit ServerDataEror");
                  }
                  emit(
                    ServerDataError(
                        event: event,
                        error: Exception(
                            'ServerData Is Null!')), //NoInternetException('No Internet'),
                  );
                }
              }

              break;
            case ServerDataEvents.add:
              if (kDebugMode) {
                print("add");
              }
              List<T>? result;
              if (event.onEvent != null) {
                result = await event.onEvent!.call(this, event, emit);
              } else {
                if (kDebugMode) {
                  print("add emit ServerDataLoading");
                }
                emit(ServerDataLoading(event: event));

                result = await repo!.add(event.item as T,
                    onSendProgress: (sent, total) {
                  emit(ServerDataLoadingSendProgress<T>(
                      event: event, sent: sent, total: total));
                }, onReceiveProgress: (sent, total) {
                  emit(ServerDataLoadingReceiveProgress<T>(
                      event: event, sent: sent, total: total));
                });
                if (result != null && result.isNotEmpty) {
                  if (kDebugMode) {
                    print("add result!");
                  }
                  if (kDebugMode) {
                    print("add emit ServerDataAdded");
                  }
                } else {
                  if (kDebugMode) {
                    print("add emit ServerDataError");
                  }
                  emit(ServerDataError(
                      event: event,
                      error: Exception('Inserimento non riuscito!')));
                  return;
                }
              }

              if (result != null && result.isNotEmpty) {
                items?.addAll(result);
                emit(ServerDataAdded(
                    event: event, item: result[0], items: items));
              }

              emit(ServerDataLoading(event: event));

              //await fetch(event, emit);
              await fetch(event.copyWith(refresh: items == null), emit);
              emit(ServerDataLoaded(items: filteredItems, event: event));
              event.onDataLoaded?.call(filteredItems);

              if (event.withComplete) {
                if (kDebugMode) {
                  print(
                      "event.withComplete -> fetch emit ServerDataLoadedCompleted");
                }
                emit(ServerDataLoadedCompleted(
                    items: filteredItems, event: event));
              }

              break;
            case ServerDataEvents.update:
              if (kDebugMode) {
                print("update");
              }
              List<T>? result;
              if (event.onEvent != null) {
                result = await event.onEvent!.call(this, event, emit);
              } else {
                if (kDebugMode) {
                  print("update emit ServerDataLoading");
                }
                emit(ServerDataLoading(event: event));
                if (kDebugMode) {
                  print("try save");
                }
                /*  int currentIndex = -1;
                for (int index=0; index < (items?.length ?? 0); index++){
                  if (items![index] == event.item){
                    currentIndex=index;
                    break;
                  }
                }*/

                result = await repo!.update(event.item as T,
                    onSendProgress: (sent, total) {
                  emit(ServerDataLoadingSendProgress<T>(
                      event: event, sent: sent, total: total));
                }, onReceiveProgress: (sent, total) {
                  emit(ServerDataLoadingReceiveProgress<T>(
                      event: event, sent: sent, total: total));
                });
                if (result != null && result.isNotEmpty) {
                  if (kDebugMode) {
                    print("update result!");
                  }
                  if (kDebugMode) {
                    print("add emit ServerDataUpdated");
                  }
/*
                  if (currentIndex!=-1) {
                    items![currentIndex] = result[0];
                  }*/
                } else {
                  if (kDebugMode) {
                    print("add emit ServerDataError");
                  }
                  emit(ServerDataError(
                      event: event,
                      error: Exception('Salvataggio non riuscito!')));
                }
              }

              if (result != null && result.isNotEmpty) {
                int currentIndex = -1;
                for (int index = 0; index < (items?.length ?? 0); index++) {
                  var item = items![index];
                  if (item is JsonPayload) {
                    if (gato.get(item.json, event.keyName ?? '') ==
                        gato.get((result[0] as JsonPayload).json,
                            event.keyName ?? '')) {
                      currentIndex = index;
                      break;
                    }
                  }
                }
                if (currentIndex != -1) {
                  items![currentIndex] = result[0];
                }
                emit(ServerDataUpdated(
                    event: event, item: result[0], items: items));
              }

              await fetch(event.copyWith(refresh: items == null), emit);

              emit(ServerDataLoaded(items: filteredItems, event: event));
              event.onDataLoaded?.call(filteredItems);
              if (event.withComplete) {
                if (kDebugMode) {
                  print(
                      "event.withComplete -> fetch emit ServerDataLoadedCompleted");
                }
                emit(ServerDataLoadedCompleted(
                    items: filteredItems, event: event));
              }

              break;
            case ServerDataEvents.delete:
              if (kDebugMode) {
                print("delete");
              }
              if (event.onEvent != null) {
                await event.onEvent!.call(this, event, emit);
              } else {
                emit(ServerDataLoading(event: event));

                bool? result = await repo!.deleteList(event.items);
                if (result!) {
                  emit(ServerDataDeleted(event: event, items: event.items));
                } else {
                  emit(ServerDataError(
                      event: event,
                      error: Exception('Cancellazione non riuscita!')));
                }
              }
              emit(ServerDataLoading(event: event));

              await fetch(event, emit);
              /*items = await repo!.fetch();
                debugPrint('numero elementi prima del filtro: ${items!.length.toString()}');
                ///esecuzione filtro
                if (event.columnFilters!=null) {
                  items = await filterItems(event.columnFilters!);
                }
                debugPrint('numero elementi dopo il filtro: ${items!.length.toString()}');*/

              emit(ServerDataLoaded(items: filteredItems, event: event));
              event.onDataLoaded?.call(filteredItems);

              if (event.withComplete) {
                if (kDebugMode) {
                  print(
                      "event.withComplete -> fetch emit ServerDataLoadedCompleted");
                }
                emit(ServerDataLoadedCompleted(
                    items: filteredItems, event: event));
              }

              break;
            case ServerDataEvents.exportPdf:
              emit(ServerDataLoading(event: event));

              List<PrintResponse>? result = await repo!.printThis(event.items,
                  onSendProgress: (sent, total) {
                emit(ServerDataLoadingSendProgress<T>(
                    event: event, sent: sent, total: total));
              }, onReceiveProgress: (sent, total) {
                emit(ServerDataLoadingReceiveProgress<T>(
                    event: event, sent: sent, total: total));
              });
              if (result != null && result.isNotEmpty) {
                Uint8List? file;
                if (result[0].resultFile != null) {
                  file = base64Decode(result[0].resultFile!);
                }
                emit(ServerDataExported(
                    event: event, response: result[0], file: file));
              } else {
                emit(ServerDataError(
                    event: event, error: Exception('Stampa non riuscita!')));
              }

              break;
            case ServerDataEvents.command:
              if (kDebugMode) {
                print("command");
              }

              emit(ServerDataLoading(event: event));
              List<T>? result;
              if (event.command != null) {
                result = await event.command!.call(this);
                emit(ServerDataCommandCompleted(event: event, items: result));
              } else {
                if (kDebugMode) {
                  print("emit ServerDataError: event.command is null!");
                }

                emit(ServerDataError(
                    event: event, error: 'event.command is null!'));
              }

              if (event.withComplete) {
                if (kDebugMode) {
                  print(
                      "event.withComplete -> fetch emit ServerDataLoadedCompleted");
                }
                emit(ServerDataLoadedCompleted(items: result, event: event));
              }
              break;
            default:
              if (kDebugMode) {
                print("state default");
              }
              break;
          }
        } on BrowserHttpClientException catch (e) {
          if (kDebugMode) {
            print("BrowserHttpClientException");
          }
          emit(ServerDataError(
            event: event,
            error: Exception(
                'Servizio non trovato. Verificare che il server sia avviato e che il firewall sia correttamente configurato\r\n\r\nEccezione completa:\r\n $e'), //NoServiceFoundException('No Service Found'),
          ));
        } on SocketException catch (e) {
          if (kDebugMode) {
            print("SocketException");
          }
          emit(ServerDataError(
            event: event,
            error: Exception(
                'Server non trovato\r\n${e.toString()}'), //NoInternetException('No Internet'),
          ));
        } on HttpException catch (e) {
          if (kDebugMode) {
            print("HttpExcetpion");
          }
          emit(ServerDataError(
            event: event,
            error: Exception(
                'Servizio non trovato\r\n${e.toString()}'), //NoServiceFoundException('No Service Found'),
          ));
        } on FormatException catch (e) {
          if (kDebugMode) {
            print("FormatException");
          }
          emit(ServerDataError(
            event: event,
            error: Exception(
                'Formato risposta non valido\r\n${e.toString()}'), //InvalidFormatException('Invalid Response format'),
          ));
        } on FetchDataException catch (e) {
          if (kDebugMode) {
            print("FetchDataException");
            print(e.message[0]);
          }
          emit(ServerDataError(
            event: event,
            error: Exception(
                '${e.message[0]}'), //InvalidFormatException('Invalid Response format'),
          ));

          /*  var result = e.message[1];
          if (result != null) {
            emit(ServerDataLoaded(items: result, event: event, local: true));
          }*/
        } catch (e) {
          if (kDebugMode) {
            print("Errore server_data_bloc");
          }
          try {
            if (kDebugMode) {
              print(e.hashCode.toString());
              print(e.toString());
            }
            emit(ServerDataError(
              event: event,
              error:
                  Exception('Error\r\n$e'), //UnknownException('Unknown Error'),
            ));
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
      },

      /// Specify a custom event transformer from `package:bloc_concurrency`
      transformer: restartable(),
    );
  }

  Future<void> fetch(ServerDataEvent event, emit) async {
    if (event.refresh) {
      if (event.queryModel != null) {
        items = await repo!.get(event.queryModel!,
            onSendProgress: (int sent, int total) {
          emit(ServerDataLoadingSendProgress<T>(
              sent: sent, total: total, event: event));
        }, onReceiveProgress: (int sent, int total) {
          emit(ServerDataLoadingReceiveProgress<T>(
              sent: sent, total: total, event: event));
        });
      } else {
        items = await repo!.fetch(onSendProgress: (int sent, int total) {
          emit(ServerDataLoadingSendProgress<T>(
              sent: sent, total: total, event: event));
        }, onReceiveProgress: (int sent, int total) {
          emit(ServerDataLoadingReceiveProgress<T>(
              sent: sent, total: total, event: event));
        });
      }
    }

    debugPrint('numero elementi prima del filtro: ${items!.length.toString()}');

    ///esecuzione filtro
    if (event.columnFilters != null && event.customFilters != null) {
      filteredItems =
          await filterItems(event.columnFilters!, event.customFilters!);
    } else {
      filteredItems = items;
    }
    debugPrint(
        'numero elementi dopo il filtro: ${filteredItems!.length.toString()}');
  }

  Future<List<T>> filterItems(
      Map<String, Filter> columnFilters,
      Map<String, bool Function(dynamic searchValue, dynamic item)?>?
          customFilters) async {
    ///seleziono solo gli elementi che con contengono il valore value di columnFilters
    ///la ricerca del campo avviene grazie alla proprietà json di T
    return items!.where((dynamic element) {
      List<bool> results = <bool>[];

      for (int index = 0; index < columnFilters.length; index++) {
        String key = columnFilters.keys.elementAt(index);
        Filter filter = columnFilters.values.elementAt(index);

        bool Function(dynamic searchValue, dynamic item)? customFilter =
            customFilters!.values.elementAt(index);

        var valueReaded = gato.get(element.json, key);
        if (customFilter != null) {
          results.add(customFilter.call(filter.value, element));
        } else {
          switch (filter.filterType) {
            case MultiFilterType.containsText:
              if (filter.value.toString().isNotEmpty) {
                results.add(valueReaded
                    .toString()
                    .toLowerCase()
                    .contains(filter.value.toString().toLowerCase()));
              } else {
                results.add(true);
              }
              break;

            case MultiFilterType.betweenDate:
              try {
                List<String> values = filter.value as List<String>;
                DateTime toCheck = DateTime.parse(valueReaded);
                if (values[0].isNotEmpty && values[1].isNotEmpty) {
                  DateTime startValue = DateTime.parse(values[0]);
                  DateTime endValue = DateTime.parse(values[1]);
                  if (endValue.isBefore(startValue)) {
                    results.add(false);
                    break;
                  }

                  if ((toCheck.isAtSameMomentAs(startValue) ||
                          toCheck.isAfter(startValue)) &&
                      ((toCheck.isAtSameMomentAs(endValue) ||
                          toCheck.isBefore(
                              endValue.add(const Duration(days: 1)))))) {
                    //se toCheck è compreso tra startValue ed endValue
                    results.add(true);
                  } else {
                    results.add(false);
                  }
                } else if (values[0].isNotEmpty && values[1].isEmpty) {
                  //solo data inizio
                  DateTime startValue = DateTime.parse(values[0]);
                  if ((toCheck.isAtSameMomentAs(startValue) ||
                      toCheck.isAfter(startValue))) {
                    //se toCheck è compreso tra startValue ed endValue
                    results.add(true);
                  } else {
                    results.add(false);
                  }
                } else if (values[0].isEmpty && values[1].isNotEmpty) {
                  //solo data fine
                  DateTime endValue = DateTime.parse(values[1]);
                  if ((toCheck.isAtSameMomentAs(endValue) ||
                      toCheck
                          .isBefore(endValue.add(const Duration(days: 1))))) {
                    //se toCheck è compreso tra startValue ed endValue
                    results.add(true);
                  } else {
                    results.add(false);
                  }
                }
              } catch (e) {
                print(e);
              }
              break;

            case MultiFilterType.selection:
              if (filter.value != null &&
                  filter.value! is List &&
                  (filter.value as List).isNotEmpty) {
                List<String> values =
                    (filter.value as List).map((e) => e.toString()).toList();
                if (values.contains(valueReaded)) {
                  results.add(true);
                } else {
                  results.add(false);
                }
              } else {
                results.add(true);
              }
              break;
            default:
              break;
          }
        }
      }
      /*columnFilters.forEach((key, value) {
        ///trovo il valore attuale della colonna key
        if (value.isNotEmpty) {

          var valueReaded = gato.get(element.json, key);
          results.add(valueReaded.toString()
              .toLowerCase()
              .contains(value.toLowerCase()));
        } else {
          results.add(true);
        }
      });*/

      ///se uno dei risultati è false, l'elemento va escluso
      return !results.contains(false);
    }).toList(growable: false);
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

  void setFilteredItem(int index, T value) {
    if (index < (filteredItems?.length ?? 0)) {
      filteredItems?[index] = value;
    }
  }
}
