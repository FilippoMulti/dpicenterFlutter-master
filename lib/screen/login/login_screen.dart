import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_installer/app_installer.dart';
import 'package:dpicenter/blocs/check_version_bloc.dart';
import 'package:dpicenter/blocs/login_bloc.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/check_version_response.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/useful/download_screen.dart';
import 'package:dpicenter/screen/useful/info_screen.dart';
import 'package:dpicenter/screen/useful/loading_screen.dart';
import 'package:dpicenter/screen/useful/waiting_screen.dart';
import 'package:dpicenter/screen/widgets/app_bar.dart';
import 'package:dpicenter/screen/widgets/password_form_field.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/exceptions.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:dpicenter/theme_manager/theme_picker_dialog.dart'
    as theme_picker;
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/shell.dart';

import 'login_screen_global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController userNameController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  final GlobalKey _autoFillGroupKey =
      GlobalKey(debugLabel: '_autoFillGroupKey');

  @override
  void initState() {
/*    var queryData = MediaQuery.of(context);
    eventBus.fire(MessageHubEvent(message: queryData.toString()));*/

    if (isAndroid || isWindows) {
      _checkVersion();
    } else {
      if (foundation.kDebugMode) {
        //_checkVersion();
      }
      if (prefs!.getString("token") != null &&
          prefs!.getString("token")!.isNotEmpty) {
        _checkVersionAutoLoginAsync();
      }
    }

    userNameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  _checkVersion() async {
    await _checkVersionAsync();
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: isDarkTheme(context)
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withAlpha(240),
              Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.primary,
      /*flexibleSpace: Container(

        decoration: ShapeDecoration(
          shape:
            CustomAppBarShape(),

            */ /*gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  getCurrentCalcThemeMode(context) == ThemeMode.light ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                  getCurrentCalcThemeMode(context) == ThemeMode.light ? Theme.of(context).colorScheme.primary.withAlpha(0) : Theme.of(context).colorScheme.surface.withAlpha(0),

                ])*/ /*
        ),
      ),*/

      shape: const CustomAppBarShape(),
      title: Text(
        "Login",
        style: TextStyle(color: getBottomNavigatorBarForegroundColor(context)),
      ),
      actions: [
        theme_picker.getThemeChangeIconButton(context),
        IconButton(
          padding: const EdgeInsets.all(16),
          icon: Icon(Icons.settings,
              color: getBottomNavigatorBarForegroundColor(context)),
          tooltip: 'Impostazioni',
          onPressed: () async {
            var result = await manageSettings(context);
            if (result != null && result is List) {
              setState(() {});
            }
          },
        ),
        const SizedBox(
          width: 16,
        )
      ],
    );
  }

  Widget bodyWithBlocBuilder() {
    return BlocListener<CheckVersionBloc, CheckVersionState>(
        listener: (BuildContext context, CheckVersionState state) {
      switch (state.event!.status) {
        case CheckVersionEvents.autoLogin:
          if (prefs!.getString(tokenSetting) == null ||
              prefs!.getString(tokenSetting) == '') {
            ///non ho token da caricare vado direttamente alla richiesta del login
            _checkVersionIdleAsync();
          } else {
            if (state is CheckVersionAutoLoginResult) {
              if (state.result ?? false) {
                _goHome();
              }
            } else if (state is CheckVersionError) {
              Future.delayed(const Duration(seconds: 0), () {
                ///cancello il token
                prefs!.setString(tokenSetting, "");

                ///vado alla richiesta del login
                _checkVersionIdleAsync();
              });
            }
            if (kDebugMode) {
              print(state.toString());
            }
          }
        default:
          break;
      }
    }, child: BlocBuilder<CheckVersionBloc, CheckVersionState>(
            builder: (BuildContext context, CheckVersionState state) {
      switch (state.event!.status) {
        case CheckVersionEvents.idle:
          return loginWithBlockBuilder();
        case CheckVersionEvents.search:
          return checkVersionWithBlocBuilder();
        case CheckVersionEvents.download:
          return downloadNewVersionWithBlocBuilder();
        case CheckVersionEvents.waitUpdate:
          return waitingScreen(state);
        case CheckVersionEvents.autoLogin:
          if (prefs!.getString(tokenSetting) == null ||
              prefs!.getString(tokenSetting) == '') {
            ///non ho token da caricare vado direttamente alla richiesta del login
            //_checkVersionIdleAsync();
            return loginWithBlockBuilder();
          } else {
            ///tento la procedura di autologin
            return autoLoginScreen(state);
          }

        default:
          break;
      }
      return const Text("Non ancora implementato");
    }));
  }

  Widget scaffoldIdle() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56), child: getAppBar()),
        body: bodyWithBlocBuilder());
  }

  Widget scaffoldSearch() {
    return Scaffold(
        backgroundColor: Colors.transparent, body: bodyWithBlocBuilder());
  }

  Widget scaffoldDownload() {
    return Scaffold(
        backgroundColor: Colors.transparent, body: bodyWithBlocBuilder());
  }

  Widget scaffoldWaitUpdate() {
    return Scaffold(
        backgroundColor: Colors.transparent, body: bodyWithBlocBuilder());
  }

  Widget scaffoldAutoLogin() {
    return Scaffold(
        backgroundColor: Colors.transparent, body: bodyWithBlocBuilder());
  }

  Widget _baseBlockBuilder() {
    return BlocBuilder<CheckVersionBloc, CheckVersionState>(
        builder: (BuildContext context, CheckVersionState state) {
      switch (state.event!.status) {
        case CheckVersionEvents.idle:
          return scaffoldIdle();
        case CheckVersionEvents.search:
          return scaffoldSearch();
        case CheckVersionEvents.download:
          return scaffoldDownload();
        case CheckVersionEvents.waitUpdate:
          return scaffoldWaitUpdate();
        default:
          break;
      }
      return scaffoldIdle();
    });
  }

  Widget _baseBlockBuilderWithImage() {
    return DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("graphics/multi2.jpg"), fit: BoxFit.cover),
        ),
        child: ClipRRect(
            // make sure we apply clip it properly
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: _baseBlockBuilder())));
  }

  Widget _baseBlockBuilderWithoutImage() {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: _baseBlockBuilder());
  }

  late bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    isDarkMode = isDarkTheme(context);
 /*   if (prefs!.getBool(showBackgroundImageSetting) ?? false) {
      return _baseBlockBuilderWithImage();
    } else {*/
    return _baseBlockBuilderWithoutImage();
    // }
  }

  _login() async {
    var event = LoginEvent(
        username: userNameController.text,
        password: passwordController.text,
        status: LoginEvents.authenticate);
    context.read<LoginBloc>().add(event);
  }

  ///stato per nome utente o password errata
  _clearLogin() async {
    var event =
        const LoginEvent(status: LoginEvents.idle, username: '', password: '');
    context.read<LoginBloc>().add(event);
  }

  _saveUserData(int? applicationUserId, String? name, String? token,
      String? sessionId) async {
    //TODO: creare una classe settings
    prefs!.setString(tokenSetting, token ?? "");
    prefs!.setInt(applicationUserIdSetting, applicationUserId ?? -1);
    prefs!.setString(usernameSetting, name ?? "");
    prefs!.setString(sessionIdSetting, sessionId ?? "");
  }

  _saveUserDataJson(String json) async {
    //TODO: creare una classe settings
    prefs!.setString(userInfoSetting, json);
  }

  Widget waitingScreen(CheckVersionState state) {
    if (state is CheckVersionWaitState) {
      return WaitingScreen(
        title: "Completamento aggiornamento",
        message: isWindows
            ? "Se non si è avviata automaticamente l'installazione, cliccare sul pulsante 'Installa'"
            : "Installare l'aggiornamento tramite 'Installazione Pacchetti'",
        onPressed: () {
          isWindows
              ? onClickInstallMsix(state.path)
              : onClickInstallApk(state.path);
        },
        buttonText: isWindows ? 'Installa' : 'Riprova',
      );
    } else {
      return const Text("Error");
    }
  }

  ///tento l'autologin
  ///in caso positivo accedo direttamente
  ///altrimento vado alla richiesta del login
  Widget autoLoginScreen(CheckVersionState state) {
    if (state is CheckVersionAutoLoginResult) {
      if (state.result ?? false) {
        //_goHome();
        return const LoadingScreen(
          message: "Accesso in corso",
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        );
      }
    } else if (state is CheckVersionError) {
      /*Future.delayed(const Duration(seconds: 0), () {
        ///cancello il token
        prefs!.setString(tokenSetting, "");

        ///vado alla richiesta del login
        _checkVersionIdleAsync();
      });*/
      return InfoScreen(
        message: "Accesso non riuscito",
        icon: const Icon(
          Icons.sentiment_dissatisfied,
          size: 128,
          color: Colors.white,
        ),
        onPressed: () {},
      );
    }
    /*if (kDebugMode) {
      print(state.toString());
    }*/
    return LoadingScreen(
        message: "Accesso in corso: $state",
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)));
  }

  Widget loginFormScreen() {
    int flexLR = 0;
    int flexC = 10;

    var queryData = MediaQuery.of(context);
//    print(queryData!.size.width);
    if (queryData.size.width >= 400) {
      flexC = 8;
      flexLR = 1;
    }
    if (queryData.size.width >= 600) {
      flexC = 6;
      flexLR = 2;
    }
    if (queryData.size.width >= 800) {
      flexC = 4;
      flexLR = 3;
    }

    if (queryData.size.width >= 1200) {
      flexC = 3;
      flexLR = 4;
    }
/*    const colorizeColors = [
      Colors.green,
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];*/

    /* const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
    );*/

    Color backColor = getBackgroundColor(context);

    return Form(
        key: _formKey,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: backColor,
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Row(
            children: [
              Expanded(flex: flexLR, child: Container()),
              Expanded(
                flex: flexC,
                child: Column(
                  children: <Widget>[
                    Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Dpi Center',
                            curve: Curves.linear,
                            textStyle: TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            speed: const Duration(milliseconds: 500),
                          ),
                                ],
                                repeatForever: true,
                                pause: const Duration(milliseconds: 500),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                          child: Text(startConfig!.currentVersionString!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                    ),

                    if (kServerVersionString != null && kServerVersion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                            child: Text(
                                "Server: $kServerVersionString ($kServerVersion)",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary))),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 30.0),
                      child: Center(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.alphaBlend(
                                        Colors.white.withAlpha(150),
                                        Theme.of(context).colorScheme.primary)
                                    .withAlpha(100)),
                            clipBehavior: Clip.antiAlias,
                            width: 200,
                            height: 150,
                            /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/

                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'graphics/multi.png',
                                ))),
                      ),
                    ),

                    ///username e password

                    isMacBrowser
                        ? userNamePasswordColumn()
                        : AutofillGroup(
                            key: _autoFillGroupKey,
                            child: userNamePasswordColumn()),
                    Container(
                      height: 80,
                      width: 250,
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: ElevatedButton(
                        style: isDarkTheme(context)
                            ? ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary)
                            : null,
                        onPressed: () {
                          //
                          _onSubmit();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 25,
                              color: isDarkTheme(context)
                                  ? Theme.of(context).primaryColor
                                  : null),
                        ),
                      ),
                    ),
                        const SizedBox(
                      height: 130,
                    ),
                  ],
                ),
              ),
              Expanded(flex: flexLR, child: Container()),
            ],
          )),
        ));
  }

  Widget userNamePasswordColumn() {
    Color backColor = getBackgroundColor(context);
    print(
        'userNamePasswordColumn backColor computeLuminace: ${backColor.computeLuminance()}');

    return Column(
      children: [
        Padding(
          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            autofillHints: isMacBrowser
                ? null
                : const [
                    AutofillHints.username,
              AutofillHints.newUsername,
            ],
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: userNameController,
            decoration: InputDecoration(
                filled: true,
                border: const OutlineInputBorder(),
                labelText: 'Nome utente',
                labelStyle: TextStyle(
                    color: backColor.computeLuminance() > 0.5
                        ? Colors.black54
                        : Colors.white54),
                //errorStyle: TextStyle(color: Colors.redAccent),
                hintText: 'Inserisci nome utente',
                hintStyle: TextStyle(
                    color: backColor.computeLuminance() > 0.5
                        ? Colors.black54
                        : Colors.white54)),
            validator: (str) {
              if (str!.isEmpty) {
                return "Campo obbligatorio";
              }
              return null;
            },
            style: TextStyle(
                color: backColor.computeLuminance() > 0.5
                    ? Colors.black54
                    : Colors.white54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15, bottom: 0),
          //padding: EdgeInsets.symmetric(horizontal: 15),
          child: PasswordFormField(
            //autofillHints: const [AutofillHints.password],
            //textInputAction: TextInputAction.done,
            //autovalidateMode:
            //    AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              filled: true,
              border: const OutlineInputBorder(),
              labelText: 'Password',
              labelStyle: TextStyle(
                  color: backColor.computeLuminance() > 0.5
                      ? Colors.black54
                      : Colors.white54),
              //errorStyle: TextStyle(color: Colors.redAccent),
              hintText: 'Inserisci password',
              hintStyle: TextStyle(
                  color: backColor.computeLuminance() > 0.5
                      ? Colors.black54
                      : Colors.white54),
            ),

            //borderSide: BorderSide(color: isDarkTheme(context) ? Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color, width: 1.0),
            controller: passwordController,
            maxLenght: null,
            style: TextStyle(
                color: backColor.computeLuminance() > 0.5
                    ? Colors.black54
                    : Colors.white54),
            iconColor: backColor.computeLuminance() > 0.5
                ? Colors.black54
                : Colors.white54,
            validator: (str) {
              if (str!.isEmpty) {
                return "Campo obbligatorio";
              }
              return null;
            },
            onFieldSubmitted: (_) => _onSubmit(),
          ),
        ),
      ],
    );
  }

  _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Widget loginWithBlockBuilder() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
      if (state is LoginCompleted) {
        /*print(sessionId);*/
        _saveUserData(state.response!.user!.applicationUserId!,
            state.response!.user!.userName!, state.response!.token, sessionId);
        _saveUserDataJson(jsonEncode(state.response!.user!.toJson()));

        ///riavvio il messageHub
        eventBus.fire(RestartHubEvent(newUrl: MultiService.baseUrl));
        _goHome();
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
            builder: (BuildContext context, LoginState state) {
      if (state is LoginLoading) {
        return Stack(
          alignment: const Alignment(0.6, 0.6),
          children: const [
            //loginFormScreen(),
            LoadingScreen(
              message: "Autenticazione...",
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ],
        );
      }
      if (state is LoginError) {
        final error = state.error;

        if (error is LoginException) {
          /*Future.delayed(const Duration(seconds: 2), () {
            _clearLogin();
          });*/
          return InfoScreen(
            message: "Nome utente o password errata",
            /*icon: const Icon(
                Icons.sentiment_dissatisfied,
                size: 128,
                color: Colors.white,
              )*/
            emoticonText: !kIsWeb ? '¯\\_( ツ )_/¯' : '😒',
            onPressed: () {
              _clearLogin();
            },
          );
        } else {
          String message = error.toString();
          return InfoScreen(
            message: "Errore durante l'operazione di autenticazione",
            errorMessage: message,
            /*icon: const Icon(
                Icons.sentiment_dissatisfied,
                size: 128,
                color: Colors.white,
              )*/
            //emoticonText: !kIsWeb ? '(╯°□°）╯︵ ┻━┻' : '💔',
            image: Image.asset(angryImage).image,
            buttonText: "RIPROVA",
            onPressed: () {
              _login();
            },
          );

          /*ErrorScreen(
              onPressed: () {
                _login();
              },
              message: message);*/
        }
      }
      if (state is LoginCompleted) {
        return const LoadingScreen(
            message: "OK!",
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)));
        //List<VMProductor> productors = state.productors!;
        //return _grid(productors);
      }
      //return loginFormScreen();
      return loginFormScreen();
    }));
  }

  _goHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

/*  _showLoginErrorMessage() async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Accesso non riuscito',
            message: 'Nome utente o password errata',
            type: MessageDialogType.okOnly,
            okText: 'OK',
            okPressed: () {
              Navigator.pop(context, "0");
            });
      },
    ).then((value) {
      return value;
      //return value
    });
    return result;
  }*/

  Widget checkVersionWithBlocBuilder() {
    return BlocListener<CheckVersionBloc, CheckVersionState>(
        listener: (BuildContext context, CheckVersionState state) {
      if (state is CheckVersionCompleted) {
        if (state.response != null) {
          ///ho ricevuto la risposta, controllo se è necessario effettuare l'aggiornamento

          if (kServerVersion != state.response!.serverVersion ||
              kServerVersionString != state.response!.serverVersionString) {
            kServerVersion = state.response!.serverVersion;
            kServerVersionString = state.response!.serverVersionString;
            ThemeModeHandler.of(context)?.update();
          }
        }
      }
    }, child: BlocBuilder<CheckVersionBloc, CheckVersionState>(
            builder: (BuildContext context, CheckVersionState state) {
      if (state is CheckVersionLoading) {
        return const LoadingScreen(message: "Controllo aggiornamenti...");
        /* return Stack(
          //alignment: const Alignment(0.6, 0.6),
          children: const [
            //loginFormScreen(),
            LoadingScreen(message: "Controllo aggiornamenti..."),
          ],
        );*/
      }
      if (state is CheckVersionError) {
        final error = state.error;

        ///l'idea era quella di estrarre la proprietà "message"
        ///da exception ma a quanto pare la classe abstract Exception
        ///non ha nessuna proprietà "message"
        ///per ora mantengo per tutti e due i casi di errore "error.toString()"
        String message = "";
        if (error is Error) {
          message = error.toString();
        } else if (error is Exception) {
          message = error.toString();
        }

        //if (error is TimeoutException || error is BrowserHttpClientException || error is ClientException){
        ///la richiesta al server non è riuscita
        ///in questo caso non mostro un messaggio di errore ma la richiesta
        ///del login. L'applicazione potrà funzionare offline se verranno trovati
        ///dati nel database locale

        /*Future.delayed(const Duration(seconds: 5), () {
          _checkVersionIdleAsync();
        });*/

        if (kDebugMode) {
          print(message);
        }
        return InfoScreen(
          message: "Non è stato possibile contattare il server",
          errorMessage: state.error.toString(),
          //emoticonText: !kIsWeb ? '(╯°□°）╯︵ ┻━┻' : '💔',
          image: Image.asset(angryImage).image,
          onPressed: () async {
            await _checkVersionIdleAsync();
          },
        );
        //}

      }
      if (state is CheckVersionCompleted) {
        if (state.response != null) {
          ///ho ricevuto la risposta, controllo se è necessario effettuare l'aggiornamento

          if (startConfig!.currentVersion! < state.response!.version) {
            ///disabilito il messaggio di chiusura applicazione (verrà chiusa dall'installazione dell'aggiornamento)
            gShowCloseMessage = false;
            return WaitingScreen(
              onPressed: () {
                _downloadNewVersionAsync(state.response!);
              },
              message: state.response!.message,
              title: state.response!.force
                  ? 'Aggiornamento necessario'
                  : 'Aggiornamento disponibile',
              buttonText: 'Aggiorna',
            );
          } else {
            ///Aggiornamento non disponibile
            ///devo controllare se ho già un token da testare
            String? token = prefs!.getString("token");
            if (token != null && token.isNotEmpty) {
              _checkVersionAutoLoginAsync();
            } else {
              _checkVersionIdleAsync();
            }
          }

          return const LoadingScreen(
            message: "Caricamento",
          );
        } else {
          return InfoScreen(
              message: "La risposta ricevuta dal server non è valida",
              errorMessage: "Response is null",
              emoticonText: '(´Д｀)ヾ',
              onPressed: () => _checkVersion());
        }
      }
      return const Text("Stato non gestito");
      //return loginFormScreen();
    }));
  }

  /*dynamic updateDialog(CheckVersionResponse response) async {
    var result =  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: response.force ? 'Aggiornamento necessario' : 'Aggiornamento disponibile',
            message: response.message,
            type: MessageDialogType.yesNo,
            yesText: 'SI',
            noText: 'NO',
            okPressed: () {
              Navigator.pop(context, "0");
            },
            noPressed: () {
              Navigator.pop(context, "1");
            });
      },
    ).then((value) async {

      return value;
      //return value
    });
    return result;
  }*/
  Widget downloadNewVersionWithBlocBuilder() {
    return BlocBuilder<CheckVersionBloc, CheckVersionState>(
        builder: (BuildContext context, CheckVersionState state) {
      if (state is CheckVersionDownloading) {
        return Stack(
          alignment: const Alignment(0.6, 0.6),
          children: [
            //loginFormScreen(),
            downloadScreen(state.event!.response!, state.progressValue,
                state.sended, state.total),
          ],
        );
      }
      if (state is CheckVersionError) {
        final error = state.error;
        String message =
            'Errore mentre controllavo se erano presenti aggiornamenti';
        return InfoScreen(
            message: message,
            errorMessage: error.message,
            emoticonText: '( ✜︵✜ )',
            onPressed: () {});
      }
      if (state is CheckVersionDownloadCompleted) {
        if (isAndroid) {
          onClickInstallApk(state.path);
        } else if (isWindows) {
          onClickInstallMsix(state.path);
        }
        _checkVersionWaitAsync(state.path);

        return downloadScreen(
            state.event!.response!, 1.0, state.totalSended, state.totalSended);
      } else {
        return InfoScreen(
            message: "La risposta ricevuta dal server non è valida",
            errorMessage: "Response is null",
            emoticonText: '(´Д｀)ヾ',
            onPressed: () => _checkVersion());
      }
    });
  }

  void onClickInstallMsix(String path) async {
    var shell = Shell();

    await shell.run('''

    $path

''');
  }

  void onClickInstallApk(String path) async {
    if (path.isEmpty) {
      if (kDebugMode) {
        print('Assicurati che l\'argomento path sia compilato');
      }
      return;
    }
    await AppInstaller.installApk(path);
  }

  Widget downloadScreen(
      CheckVersionResponse cv, double progressValue, int sended, int total) {
    return DownloadScreen(
        message: "Scaricamento versione '${cv.versionString}'",
        progressValue: progressValue,
        sended: sended,
        total: total);
  }

  _checkVersionAsync() async {
    //print(T);
    //print(context);
    //BlocProvider.of<ServerDataBloc<T>>(context).add(ServerDataEvent(status: ServerDataEvents.fetch));
    var bloc = BlocProvider.of<CheckVersionBloc>(context);
    bloc.add(
        const CheckVersionEvent(status: CheckVersionEvents.search, param: ""));
    //var bloc1=context.read<ServerDataBloc>();
    /*context.read<ServerDataBloc>().add(
        ServerDataEvent(status: ServerDataEvents.fetch));*/
  }

  _downloadNewVersionAsync(CheckVersionResponse currentVersion) async {
    //print(T);
    //print(context);
    //BlocProvider.of<ServerDataBloc<T>>(context).add(ServerDataEvent(status: ServerDataEvents.fetch));
    var bloc = BlocProvider.of<CheckVersionBloc>(context);
    bloc.add(CheckVersionEvent(
        status: CheckVersionEvents.download,
        param: "",
        response: currentVersion));
    //var bloc1=context.read<ServerDataBloc>();
    /*context.read<ServerDataBloc>().add(
        ServerDataEvent(status: ServerDataEvents.fetch));*/
  }

  _checkVersionIdleAsync() async {
    //print(T);
    //print(context);
    //BlocProvider.of<ServerDataBloc<T>>(context).add(ServerDataEvent(status: ServerDataEvents.fetch));
    var bloc = BlocProvider.of<CheckVersionBloc>(context);
    bloc.add(const CheckVersionEvent(
        status: CheckVersionEvents.idle, param: "", response: null));
    //var bloc1=context.read<ServerDataBloc>();
    /*context.read<ServerDataBloc>().add(
        ServerDataEvent(status: ServerDataEvents.fetch));*/
  }

  _checkVersionAutoLoginAsync() async {
    //print(T);
    //print(context);
    //BlocProvider.of<ServerDataBloc<T>>(context).add(ServerDataEvent(status: ServerDataEvents.fetch));
    var bloc = BlocProvider.of<CheckVersionBloc>(context);
    bloc.add(const CheckVersionEvent(
        status: CheckVersionEvents.autoLogin, param: "", response: null));
    //var bloc1=context.read<ServerDataBloc>();
    /*context.read<ServerDataBloc>().add(
        ServerDataEvent(status: ServerDataEvents.fetch));*/
  }

  _checkVersionWaitAsync(String path) async {
    //print(T);
    //print(context);
    //BlocProvider.of<ServerDataBloc<T>>(context).add(ServerDataEvent(status: ServerDataEvents.fetch));
    var bloc = BlocProvider.of<CheckVersionBloc>(context);
    bloc.add(CheckVersionEvent(
        status: CheckVersionEvents.waitUpdate,
        param: "",
        response: null,
        path: path));

    //var bloc1=context.read<ServerDataBloc>();
    /*context.read<ServerDataBloc>().add(
        ServerDataEvent(status: ServerDataEvents.fetch));*/
  }
}
