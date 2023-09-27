import 'package:dpicenter/models/server/auth_response.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo? loginRepo;
  AuthResponse? response;

  LoginBloc({this.loginRepo}) : super(LoginInitState()) {
    on<LoginEvent>((event, emit) async {
      try {
        switch (event.status) {
          case LoginEvents.idle:
            emit(LoginInitState());
            break;
          case LoginEvents.authenticate:
            emit(LoginLoading());

            response =
                await loginRepo!.authenticate(event.username!, event.password!);
            if (response != null) {
              emit(LoginCompleted(response: response));
            } else {
              emit(LoginError(
                error: Exception(
                    'Nome utente o password errata'), //NoInternetException('No Internet'),
              ));
            }

            break;
          default:
            break;
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(LoginError(error: e));
      }
    });
  }

  /*///TODO: Convertire come gli altri bloc utilizzando onEvent
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      switch (event.status) {
        case LoginEvents.idle:
          yield LoginInitState();
          break;
        case LoginEvents.authenticate:
          yield LoginLoading();

          response =
              await loginRepo!.authenticate(event.username!, event.password!);
          if (response != null) {
            yield LoginCompleted(response: response);
          } else {
            yield LoginError(
              error: Exception(
                  'Nome utente o password errata'), //NoInternetException('No Internet'),
            );
          }

          break;
        default:
          break;
      }
    } on BrowserHttpClientException catch (e) {
      yield LoginError(
        error: Exception(
            'Servizio non trovato. Verificare che il server sia avviato e che il firewall sia correttamente configurato\r\n\r\nEccezione completa:\r\n ' +
                e.toString()), //NoServiceFoundException('No Service Found'),
      );
    } on SocketException {
      yield LoginError(
        error: Exception('No Internet'), //NoInternetException('No Internet'),
      );
    } on HttpException catch (e) {
      yield LoginError(
        error: Exception(
            'Servizio non trovato. Verificare che il server sia avviato e che il firewall sia correttamente configurato\r\n\r\nEccezione completa:\r\n ' +
                e.toString()), //NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield LoginError(
        error: Exception(
            'Invalid Response format'), //InvalidFormatException('Invalid Response format'),
      );
    } on LoginException catch (e) {
      yield LoginError(
        error: e, //InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      yield LoginError(
        error: Exception('Unknown Error\r\n' +
            e.toString()), //UnknownException('Unknown Error'),
      );
    }
  }*/
}
