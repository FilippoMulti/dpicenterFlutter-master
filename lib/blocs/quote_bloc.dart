import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dpicenter/services/wikiquote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  List<Quote>? items;

  QuoteBloc() : super(QuoteInitState()) {
    on<QuoteEvent>((event, emit) async {
      try {
        switch (event.status) {
          case QuoteEvents.idle:
            emit(QuoteInitState());
            break;
          case QuoteEvents.fetch:
            emit(QuoteLoading());

            /*  response =
                await loginRepo!.authenticate(event.username!, event.password!);*/
            /*  if (response != null) {
              emit(QuoteCompleted(response: response));
            } else {
              emit(QuoteError(
                error: Exception(
                    'Non è stato possibile ottenere le citazioni'), //NoInternetException('No Internet'),
              ));
            }*/

            break;
          default:
            break;
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(QuoteError(error: e));
      }
    });
  }
}
