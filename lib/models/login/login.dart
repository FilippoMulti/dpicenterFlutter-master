import 'package:dpicenter/models/server/application_user.dart';

class Auth {
  final ApplicationUser? user;

  bool? get isLogged {
    //devo controllare tra le preference se vi è salvato uno username e un token
    //in caso affermativo testo la connessione con quei dati
    return false;
  }

  Auth({this.user});
}
