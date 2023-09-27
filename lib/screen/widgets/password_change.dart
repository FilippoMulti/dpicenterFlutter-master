import 'package:dpicenter/blocs/login_bloc.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/screen/useful/loading_screen.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/password_form_field.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

import 'dialog_ok_cancel.dart';
import 'dialog_title.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange(
      {Key? key,
      this.requestCurrentPassword = true,
      this.title = 'Cambia password',
      required this.userName})
      : super(key: key);
  final bool? requestCurrentPassword;
  final String title;
  final String userName;

  @override
  State<StatefulWidget> createState() {
    return PasswordChangeState();
  }
}

class PasswordChangeState extends State<PasswordChange> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_formKey');

  bool _oldPasswordMatch = false;
  bool _oldPasswordValidator = false;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 800),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DialogTitleEx(widget.title),
            Flexible(
                child: Scaffold(
              backgroundColor: getAppBackgroundColor(context),
              body: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

                    ///permette al widget di essere scrollato
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: SettingsScroll(
                            darkTheme: SettingsThemeData(
                              settingsListBackground: isDarkTheme(context)
                                  ? Color.alphaBlend(
                                      Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withAlpha(240),
                                      Theme.of(context).colorScheme.primary)
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            lightTheme: const SettingsThemeData(
                                settingsListBackground: Colors.transparent),
                            //contentPadding: EdgeInsets.zero,
                            platform: DevicePlatform.web,
                            sections: [
                              _configurationSection(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            OkCancel(onCancel: () {
              Navigator.pop(context, null);
            }, onSave: () {
              validateSave();
            }),
          ],
        ),
      ),
    );
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(title: const Text(""), tiles: [
      _passwordSetupSettingTile(),
    ]);
  }

  SettingsTile _passwordSetupSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci nuova password',
        hint: 'Inserisci nuova password',
        description:
            'Compilare i campi come richiesto per cambiare la password',
        child: _passwordSetupBloc());
  }

  _login(String userName, String password) async {
    var event = LoginEvent(
        username: userName,
        password: password,
        status: LoginEvents.authenticate);
    context.read<LoginBloc>().add(event);
  }

  void validateSave() async {
    if (_formKey.currentState!.validate()) {
      if (widget.requestCurrentPassword! && !_oldPasswordMatch) {
        await _login(widget.userName, oldPasswordController.text);
      } else {
        Navigator.pop(context, newPasswordController.text);
      }
      /*if ((element==null || element!.applicationUserId==0) && _passwordSetRequest==false){
        await showSetPasswordErrorMessage();
        return;
      }
      //salvataggio
      if (element == null) {
        element = ApplicationUser(
            applicationUserId: 0,
            userName: usernameController.text,
            applicationProfileId:
            selectedProfile!.applicationProfileId,
            profile:
            selectedProfile!.applicationProfileId == 0
                ? selectedProfile
                : null);
      } else {
        element = element!.copyWith(userName: usernameController.text,
            profile: selectedProfile!.applicationProfileId == 0
                ? selectedProfile
                : null,
            applicationProfileId: selectedProfile!.applicationProfileId
        );
      }
*/
      //Navigator.pop(ctx, textController.text);

    }
  }

  Widget _passwordSetupBloc() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
      if (state is LoginCompleted) {
        _oldPasswordMatch = true;
        _oldPasswordValidator = false;
      } else {
        _oldPasswordMatch = false;
        _oldPasswordValidator = true;
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        validateSave();
      });
    }, child: BlocBuilder<LoginBloc, LoginState>(
            builder: (BuildContext context, LoginState state) {
      if (state is LoginInitState) {
        return Stack(
          children: [
            _passwordSetup(),
            //const LoadingScreen(message: 'Modifica password in corso'),
          ],
        );
      }
      if (state is LoginLoading) {
        return Stack(
          children: [
            _passwordSetup(),
            LoadingScreen(
              message: 'Verifica password in corso',
              color: Theme.of(context).colorScheme.background,
              direction: Axis.vertical,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        );
      }
      if (state is LoginCompleted) {
        return _passwordSetup();
      }
      if (state is LoginError) {
        return _passwordSetup();
      }
      return _passwordSetup();
    }));
  }

  Widget _passwordSetup() {
    return Padding(
        key: const ValueKey("_passwordSetup"),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            if (widget.requestCurrentPassword!)
              PasswordFormField(
                onChanged: (str) {
                  if (_oldPasswordValidator) {
                    setState(() {
                      _oldPasswordValidator = false;
                    });
                  }
                },
                controller: oldPasswordController,
                labelText: 'Password attuale',
                hintText: 'Inserisci la password attuale',
                validator: _oldPasswordValidator
                    ? (str) {
                        if (!_oldPasswordMatch) {
                          return 'Password errata';
                        }
                        return null;
                      }
                    : null,
              ),
            const SizedBox(
              height: 16,
            ),
            PasswordFormField(
              controller: newPasswordController,
              labelText: 'Nuova password',
              hintText: 'Inserisci la nuova password',
              validator: (str) {
                if ((str ?? '').length < 8) {
                  return 'La password deve contenere almeno 8 caratteri';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            PasswordFormField(
              controller: confirmPasswordController,
              labelText: 'Conferma password',
              hintText: 'Inserisci la nuova password per conferma',
              validator: (str) {
                if ((str ?? '').length < 8) {
                  return 'La password deve contenere almeno 8 caratteri';
                }
                if (newPasswordController.text != str) {
                  return 'Le password non corrispondono';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ));
  }
}
