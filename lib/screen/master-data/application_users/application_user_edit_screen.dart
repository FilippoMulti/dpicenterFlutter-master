import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/blocs/image_gallery_bloc.dart';
import 'package:dpicenter/blocs/login_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/file_global.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/server/application_profile.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/application_user_detail.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_global.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/button_form_field.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/password_change.dart';
import 'package:dpicenter/screen/widgets/take_picture/take_picture_screen.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:dpicenter/theme_manager/theme_color.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:file_picker/file_picker.dart';

//import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../validation_helpers/key_validation_state.dart';
import 'dart:ui' as ui;
import 'package:open_file/open_file.dart' as open_file;

// Define a custom Form widget.
class ApplicationUserEditForm extends StatefulWidget {
  final ApplicationUser? element;
  final String? title;
  final bool allowProfileChange;

  const ApplicationUserEditForm(
      {Key? key,
      required this.element,
      required this.title,
      this.allowProfileChange = true})
      : super(key: key);

  @override
  ApplicationUserEditFormState createState() {
    return ApplicationUserEditFormState();
  }
}

class ApplicationUserEditFormState extends State<ApplicationUserEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController surnameController;

  late ButtonFormFieldController<String> passwordController;
  List<DropdownMenuItem<ApplicationProfile>>? profiles =
      <DropdownMenuItem<ApplicationProfile>>[];

  ApplicationUser? element;

  ApplicationProfile? selectedProfile;
  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

/*  bool _passwordVisible = false;
  bool _passwordSetRequest = false;*/
  String? newPassword;

  ///chiavi per i campi da compilare
  final GlobalKey _usernameKey = GlobalKey(debugLabel: '_usernameKey');
  final GlobalKey _passwordKey = GlobalKey(debugLabel: '_passwordKey');

  final GlobalKey _surnameKey = GlobalKey(debugLabel: '_surnameKey');
  final GlobalKey _nameKey = GlobalKey(debugLabel: '_nameKey');

  final GlobalKey _profileKey = GlobalKey(debugLabel: '_profileKey');

  //final GlobalKey _avatarKey = GlobalKey(debugLabel: '_avatarKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///attiva o disattiva l'autovalidazione
  bool _autovalidate = false;

  ///Focus passwrodSet
  final FocusNode _passwordSetFocusNode =
      FocusNode(debugLabel: "_passwordSetFocusNode");
  final FocusNode _surnameFocusNode =
      FocusNode(debugLabel: "_surnameFocusNode");

  final FocusNode _saveFocusNode = FocusNode(debugLabel: "_saveFocusNode");

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _usernameKey),
      KeyValidationState(key: _passwordKey),
      KeyValidationState(key: _surnameKey),
      KeyValidationState(key: _nameKey),
      KeyValidationState(key: _profileKey),
    ];
  }

  @override
  void initState() {
    super.initState();

    initKeys();
    element = widget.element;
    _loadProfiles();

    if (element != null) {
      /*   element.userName;
          element.applicationProfileId;
      element.password;
      element.json;
      element.applicationUserId;
      element.profile;
      element.refreshToken;
      element.theme;*/
      usernameController = TextEditingController(text: element!.userName!);
      surnameController = TextEditingController(text: element!.surname!);
      nameController = TextEditingController(text: element!.name!);
      passwordController = ButtonFormFieldController(value: element!.password);
      selectedProfile = element!.profile;

      if (element!.userDetails != null &&
          element!.userDetails!.isNotEmpty &&
          element!.userDetails![0].image != null) {
        _avatarBytes = base64Decode(element!.userDetails![0].image!);
      }
    } else {
      usernameController = TextEditingController();
      passwordController = ButtonFormFieldController();
      surnameController = TextEditingController();
      nameController = TextEditingController();
    }
  }

  /* _compressFiles(List<FilePickerCross> filesPicked) async {
    List<universal_io.File?> _files =
        filesPicked.map((e) => e.path != null ? universal_io.File(e.path!) : null).toList();
    */ /* var _files = <File>[];
    for (var element in filesPicked){
      if ( await element.saveToPath(path: '/my/path/${element.path}')){
        _files.add(File('/my/path/${element.path}'));
      }
    }*/ /*

    _files.removeWhere((element) => element == null);
    var bloc = BlocProvider.of<ImageGalleryBloc>(context);
    bloc.add(ImageGalleryEvent(
        status: ImageGalleryEvents.compressList, fileList: _files, bytesList: <Uint8List>[]));
  }*/
  /* _compressFilesV2(List<FilePickerCross> filesPicked) async {
    List<universal_io.File?> _files =
    filesPicked.map((e) {
      print(e.path);
      try {
        universal_io.File file = universal_io.File(e.path!.substring(1));
      } catch (e) {
        print(e);
      }


    }).toList();

    List<Uint8List> _bytes =
    filesPicked.map((e) => e.toUint8List()).toList();
    */ /* var _files = <File>[];
    for (var element in filesPicked){
      if ( await element.saveToPath(path: '/my/path/${element.path}')){
        _files.add(File('/my/path/${element.path}'));
      }
    }*/ /*

    //_files.removeWhere((element) => element == null);
    var bloc = BlocProvider.of<ImageGalleryBloc>(context);
    bloc.add(ImageGalleryEvent(
        status: ImageGalleryEvents.compressList, bytesList: _bytes, fileList: _files));
  }*/
  _compressFile(FilePickerResult? filesPicked) async {
    if (filesPicked != null) {
      //_files.removeWhere((element) => element == null);
      var bloc = BlocProvider.of<ImageGalleryBloc>(context);
      bloc.add(ImageGalleryEvent(
          status: ImageGalleryEvents.compressList,
          fileList: <FilePickerResult>[filesPicked]));
    }
  }

  _loadProfiles() {
    var bloc = BlocProvider.of<ServerDataBloc>(context);
    bloc.add(const ServerDataEvent<ApplicationProfile>(
        status: ServerDataEvents.fetch));
  }

/*  Widget _title(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Text(
          widget.title!,
          style: const TextStyle(fontSize: 26),
        ));
  }*/
  Widget _avatar(Uint8List? image, bool loading) {
    Widget? child;
    if (loading) {
      child = Container(
        decoration: BoxDecoration(
            color: Colors.black.withAlpha(120), shape: BoxShape.circle),
        clipBehavior: Clip.antiAlias,
        child: Center(
            child: CircularProgressIndicator(
          value: null,
          backgroundColor: Colors.black.withAlpha(150),
        )),
      );
    } else {
      child = image != null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_search, color: Colors.white),
                Text('Aggiungi foto',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white))
              ],
            );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        children: [
          Center(
              child: Stack(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: image != null
                    ? Image.memory(image, filterQuality: FilterQuality.medium)
                        .image
                    : null,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                //image!=null ? null : const Icon(Icons.image_search),
                radius: 48.0,
                child: child,
              ),
              RawMaterialButton(
                hoverColor: Colors.transparent,
                fillColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                onLongPress: () {
                  if (image != null) {
                    showImagePreview(image!);
                  }
                },
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    editState = true;
                  }
                  await _compressFile(result);
                  /* List<FilePickerCross>? myFiles =
                      await FilePickerCross.importMultipleFromStorage(
                              type:
                                  FileTypeCross.custom,
                              // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
                              fileExtension:
                                  'png, jpg, jpeg' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
                              )
                          .then((value) async {
                    await _compressFilesV2(value);
                    */ /*value.forEach((element) async {
                    print("Before: " + element.length.toString());
                    File result = await compressPicture(File(element.path!));
                    print("After: " + result.length.toString());
                  });*/ /*
                    return value;
                  }).onError((error, _) {
                    String _exceptionData = error.toString();
                    if (kDebugMode) {
                      print('----------------------');
                    }
                    if (kDebugMode) {
                      print('REASON: ${_exceptionData}');
                    }
                    if (_exceptionData == 'read_external_storage_denied') {
                      if (kDebugMode) {
                        print('Permission was denied');
                      }
                    } else if (_exceptionData == 'selection_canceled') {
                      if (kDebugMode) {
                        print('User canceled operation');
                      }
                    }
                    if (kDebugMode) {
                      print('----------------------');
                    }
                    return <FilePickerCross>[];
                  });*/
                },
                shape: const CircleBorder(),
                child: const SizedBox(
                  width: 96.0, //CircleAvatar of 2 times the Radius

                  height: 96.0,
                ),
              ),
            ],
          )),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              takePictureButton(),
              IconButton(
                onPressed: () {
                  setState(() {
                    image = null;
                    editState = true;
                    _avatarBytes = null;
                  });
                },
                icon: Icon(
                  icons['close'],
                  color: Theme.of(context).errorColor,
                ),
                tooltip: 'Elimina foto',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget takePictureButton() {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            // Obtain a list of the available cameras on the device.

            //final cameras = await availableCameras();

            // Get a specific camera from the list of available cameras.
            if (cameras != null && cameras!.isNotEmpty) {
              final firstCamera = cameras!.first;

              double oldBackgroundOpacity =
                  ThemeModeHandler.of(context)!.themeColor.backgroundOpacity;
              ThemeColor tc = ThemeModeHandler.of(context)!.themeColor;
              ThemeModeHandler.of(context)!.saveThemeMode(
                  ThemeModeHandler.of(context)!.themeMode,
                  tc.copyWith(backgroundOpacity: 1.0));

              /*               prefs!.getDouble(backgroundOpacitySetting) ?? 1.0;
              prefs!.setDouble(backgroundOpacitySetting, 1.0);
              eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));*/

              showDialog(
                  context: context,
                  builder: (context) {
                    return TakePictureScreen(
                      // Pass the appropriate camera to the TakePictureScreen widget.
                      camera: firstCamera,
                    );
                  }).then((value) async {
                if (value != null) {
                  debugPrint("Value received from camera: ${value.toString()}");
                  List<PlatformFile> files = <PlatformFile>[];
                  Uint8List? bytes = await readBytesFromPath(value.toString());
                  files.add(PlatformFile(
                      path: value.toString(),
                      name: value.toString(),
                      size: bytes?.length ?? 0,
                      bytes: bytes));
                  FilePickerResult? result = FilePickerResult(files);
                  _compressFile(result);
                }
                ThemeColor tc = ThemeModeHandler.of(context)!.themeColor;
                ThemeModeHandler.of(context)!.saveThemeMode(
                    ThemeModeHandler.of(context)!.themeMode,
                    tc.copyWith(backgroundOpacity: oldBackgroundOpacity));
              });
            }
          },
          child: const Text("Scatta foto")),
    );
  }

  Uint8List? _avatarBytes;

  //Uint8List? _miniBytes;
  bool _compressRunning = false;

  Widget _avatarLoad() {
    return BlocListener<ImageGalleryBloc, ImageGalleryState>(
        listener: (BuildContext context, ImageGalleryState state) {
      if (state is ImageGalleryFileCompressed) {
        _avatarBytes = state.images![0].previewBytes;
        //    _miniBytes = state.miniImages![0].previewBytes;
      }
      if (state is ImageGalleryError) {
        _avatarBytes = null;
        //  _miniBytes = null;
      }
      if (state is ImageGalleryCompressStarted) {
        _compressRunning = true;
      }
      if (state is ImageGalleryCompressCompleted) {
        _compressRunning = false;
      }
    }, child: BlocBuilder<ImageGalleryBloc, ImageGalleryState>(
            builder: (BuildContext context, ImageGalleryState state) {
              /*List<Widget> children = <Widget>[];*/
              print(state.toString());
      if (state is ImageGalleryError) {
        for (var element in state.compressedFilesStatus!) {
          return Text(element);
        }
      }
      if (_compressRunning) {
        return _avatar(_avatarBytes, true);
      } else {
        return _avatar(_avatarBytes, false);
      }
      /*if (state is ImageGalleryFileCompressed) {

            //for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }

          }
          switch (state.event!.status) {
            case ImageGalleryEvents.compressList:
              if (state is ImageGalleryInitState) {}

              if (state is ImageGalleryFileCompressedError) {
                for (var element in state.compressedFilesStatus!) {
                  children.add(Text(element));
                }
              }
              if (state is ImageGalleryCompressCompleted) {
                */ /*  for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/ /*
              }
              if (state is ImageGalleryEndState) {
                */ /*for (var element in state.compressedFilesStatus!) { children.add(Text(element)); }
                  children.add(addImagesButton());*/ /*
                children.add(addImagesButton());
              }
              break;
            case ImageGalleryEvents.idle:
              children.add(addImagesButton());
              break;
            default:
              break;
          }
*/
      /* return Column(
        children: children,
      );*/
    }));
  }

  void showImagePreview(Uint8List image) {
    double oldBackgroundOpacity =
        ThemeModeHandler.of(context)!.themeColor.backgroundOpacity;
    ThemeColor tc = ThemeModeHandler.of(context)!.themeColor;
    ThemeModeHandler.of(context)!.saveThemeMode(
        ThemeModeHandler.of(context)!.themeMode,
        tc.copyWith(backgroundOpacity: 1.0));

/*
    double oldBackgroundOpacity =
        prefs!.getDouble(backgroundOpacitySetting) ?? 1.0;
    prefs!.setDouble(backgroundOpacitySetting, 1.0);
    eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));
*/

    showDialog(
        context: context,
        builder: (context) {
          return imagePreview(image);
        }).then((value) {
      /*prefs!.setDouble(backgroundOpacitySetting, oldBackgroundOpacity);
      eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));*/
      ThemeModeHandler.of(context)!.saveThemeMode(
          ThemeModeHandler.of(context)!.themeMode,
          tc.copyWith(backgroundOpacity: oldBackgroundOpacity));
    });
  }

  Widget imagePreview(Uint8List image) {
    return Stack(
      children: [
        InteractiveViewer(
          minScale: 0.25,
          maxScale: 100,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.memory(image,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.medium)
                        .image,
                    fit: BoxFit.cover),
              ),
              child: ClipRRect(
                  // make sure we apply clip it properly
                  child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Scaffold(
                          backgroundColor: Colors.transparent,
                          /*appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),*/
                          body: Center(
                            child: Stack(
                              children: [
                                Center(
                                    child: Image.memory(image,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.medium)),
                              ],
                            ),
                          ))))),
        ),
        Positioned(
            left: 100,
            right: 100,
            bottom: 20,
            child: ElevatedButton(
                onPressed: () async {
                  if (!kIsWeb) {
                    ///solo piattiaforme native -> path_provider non funziona sul web
                    var tempDir = await getTemporaryDirectory();
                    String tempPath = tempDir.path;

                    //if (selectedImages![index].picture!.file == null) {
                    String newPath = "$tempPath\\avatar.png";
                    saveFile(newPath, image);

                    //}

                    try {
                      open_file.OpenFile.open(newPath!);
                    } catch (e) {
                      print("Errore Apri: $e");
                    }
                  }
                  //OpenFile.open("/sdcard/example.txt");
                },
                child: const Text("Apri"))),
        Positioned(
            left: 0,
            top: 0,
            child: Material(
              type: MaterialType.transparency,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(48),
              //shape: const CircleBorder(),
              child: SizedBox(
                height: 64,
                width: 64,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white.withAlpha(200),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                ),
              ),
            )),
      ],
    );
  }

  /*Widget addImagesButton() {
    return ElevatedButton(
        onPressed: () async {
          List<FilePickerCross>? myFiles =
          await FilePickerCross.importMultipleFromStorage(
              type: kIsWeb ? FileTypeCross.any : FileTypeCross.custom,
              // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
              fileExtension:
              'png, jpg, jpeg' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
          )
              .then((value) async {
            await _compressFiles(value);
            */ /*value.forEach((element) async {
                  print("Before: " + element.length.toString());
                  File result = await compressPicture(File(element.path!));
                  print("After: " + result.length.toString());
                });*/ /*
            return value;
          }).onError((error, _) {
            String _exceptionData = error.toString();
            if (kDebugMode) {
              print('----------------------');
            }
            if (kDebugMode) {
              print('REASON: ${_exceptionData}');
            }
            if (_exceptionData == 'read_external_storage_denied') {
              if (kDebugMode) {
                print('Permission was denied');
              }
            } else if (_exceptionData == 'selection_canceled') {
              if (kDebugMode) {
                print('User canceled operation');
              }
            }
            if (kDebugMode) {
              print('----------------------');
            }
            return <FilePickerCross>[];
          });
        },
        child: const Text("Seleziona immagini da associare all'intervento"));
  }*/
  Widget _userName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _usernameKey,
        autovalidateMode: _autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: usernameController,
        maxLength: 500,
        decoration: const InputDecoration(
          //enabledBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
          labelText: 'Nome utente',
          hintText: 'Inserisci il nome utente',
        ),
        validator: (str) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == _usernameKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value){
        //   context.nextEditableTextFocus();
        // },
        onChanged: (value) => editState = true,
      ),
    );
  }

  /* Widget _passwordSet() {
    return Padding(
        key: const ValueKey("_passwordSet"),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: ElevatedButton(
            key: _passwordKey,
            onPressed: () {
              */ /*setState(() {
            _passwordSetRequest=true;
          });*/ /*
              showDialog(
                  context: context,
                  builder: (context) {
                    return multiDialog(
                        content: BlocProvider<LoginBloc>(
                            create: (BuildContext context) =>
                                LoginBloc(loginRepo: LoginServices()),
                            child: PasswordChange(
                              userName: usernameController.text,
                            )));
                  }).then((value) => newPassword = value);
            },
            child: const Text("Imposta password"),
          ),
        ));
  }*/

  Widget _passwordSet() {
    String title = element != null && element!.applicationUserId != 0
        ? 'Cambia password'
        : 'Imposta password';
    return Padding(
        key: const ValueKey("_passwordSet"),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: ButtonFormField<String?>(
            focusNode: _passwordSetFocusNode,
            controller: passwordController,
            key: _passwordKey,
            onPressed: () async {
              /*setState(() {
            _passwordSetRequest=true;
          });*/
              await showDialog(
                  context: context,
                  builder: (context) {
                    return multiDialog(
                        content: BlocProvider<LoginBloc>(
                            create: (BuildContext context) =>
                                LoginBloc(loginRepo: LoginServices()),
                            child: PasswordChange(
                              title: title,
                              requestCurrentPassword: element != null &&
                                  element!.applicationUserId != 0,
                              userName: usernameController.text,
                            )));
                  }).then((value) => newPassword = value);

              FocusScope.of(context).nextFocus();

              return newPassword;
            },
            buttonChild: Text(title),
            onChanged: (value) => editState = true,
            validator: (str) {
              KeyValidationState state = _keyStates
                  .firstWhere((element) => element.key == _passwordKey);
              if (str == null &&
                  //è un nuovo utente, è necessario che sia impostata una password
                  (element == null || element!.applicationUserId == 0)) {
                _keyStates[_keyStates.indexOf(state)] =
                    state.copyWith(state: false);
                return 'Impostare una password';
              } else {
                _keyStates[_keyStates.indexOf(state)] =
                    state.copyWith(state: true);
              }
              return null;
            },
          ),
        ));
  }

  /*Widget _password() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        autofillHints: const [AutofillHints.password],
        textInputAction: TextInputAction.done,
        autovalidateMode: _autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54, width: 1.0)),
            border: const OutlineInputBorder(),
            labelText: 'Password',
            labelStyle: const TextStyle(color: Colors.white54),
            hintText: 'Inserisci password',
            hintStyle: const TextStyle(color: Colors.white54),
            suffixIcon: IconButton(
              icon: Tooltip(
                message:
                !_passwordVisible ? 'Mostra password' : 'Nascondi password',
                child: Icon(
                  // Based on passwordVisible state choose the icon
                  !_passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).textTheme.labelLarge!.color,
                  semanticLabel: !_passwordVisible
                      ? 'Mostra password'
                      : 'Nascondi password',
                ),
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )),
        style: const TextStyle(color: Colors.white),
        validator: (str) {
          if (str!.isEmpty) {
            return "Campo obbligatorio";
          }
        },
      ),
    );
  }*/

  /*Widget _closePasswordSetup() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.red,
          size: 25,
        ),
        onPressed: () async {
          bool close = true; //await showCancelCloseInterventionMessage();
          if (close) {
            setState(() {
              _passwordSetRequest = false;
            });
          }

          //Navigator.pop(context);
        },
      ),
    );
  }*/

  tryAuth(String str) async {
    LoginServices services = LoginServices();
    try {
      await services.authenticate(prefs!.getString(usernameSetting)!, str);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget _surname() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        focusNode: _surnameFocusNode,
        key: _surnameKey,
        autovalidateMode: _autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: surnameController,
        maxLength: 50,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          //enabledBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
          labelText: 'Cognome',
          hintText: 'Inserisci il cognome dell\'utente',
        ),
        validator: (str) {
          KeyValidationState state =
          _keyStates.firstWhere((element) => element.key == _surnameKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        onChanged: (value) => editState = true,
      ),
    );
  }

  Widget _name() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _nameKey,
        textInputAction: TextInputAction.next,
        autovalidateMode: _autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: nameController,
        maxLength: 50,
        decoration: const InputDecoration(
          //enabledBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
          labelText: 'Nome',
          hintText: 'Inserisci il nome dell\'utente',
        ),
        validator: (str) {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.key == _nameKey);
          if (str!.isEmpty) {
            _keyStates[_keyStates.indexOf(state)] =
                state.copyWith(state: false);
            return "Campo obbligatorio";
          } else {
            _keyStates[_keyStates.indexOf(state)] = state.copyWith(state: true);
          }
          return null;
        },
        onFieldSubmitted: (value) {
          _passwordSetFocusNode.requestFocus();
        },
        onChanged: (value) => editState = true,
      ),
    );
  }

  Widget _profile() {
    return BlocBuilder<ServerDataBloc, ServerDataState>(
        builder: (BuildContext context, ServerDataState state) {
          switch (state.event!.status) {
            case ServerDataEvents.fetch:
              if (state is ServerDataInitState || state is ServerDataLoading) {
            return shimmerComboLoading(context,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
          }
          if (state is ServerDataLoadingSendProgress) {
            return shimmerComboLoading(context,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
          }
          if (state is ServerDataLoadingReceiveProgress) {
            return shimmerComboLoading(context,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 16));
          }
          if (state is ServerDataLoaded) {
            profiles!.clear();
            profiles =
                state.items!.map<DropdownMenuItem<ApplicationProfile>>((value) {
              return DropdownMenuItem<ApplicationProfile>(
                value: value,
                child:
                    Text((value as ApplicationProfile).profileName ?? "null"),
              );
            }).toList();

            return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: DropdownButtonFormField<ApplicationProfile>(
                  key: _profileKey,
                  autovalidateMode: _autovalidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  value: (() {
                    if (element != null) {
                      return element!.profile;
                    } else {
                      return null;
                    }
                  }()),
                  onChanged: widget.allowProfileChange
                      ? (ApplicationProfile? newValue) {
                          setState(() {
                            editState = true;
                            selectedProfile = newValue;
                          });

                          //_passwordSetFocusNode.requestFocus();
                          _surnameFocusNode.requestFocus();
                          //context.nextEditableTextFocus();
                        }
                      : null,
                  decoration: const InputDecoration(
                    //enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    labelText: 'Profilo',
                    hintText: 'Seleziona un profilo',
                  ),
                  validator: (item) {
                    KeyValidationState state = _keyStates
                        .firstWhere((element) => element.key == _usernameKey);
                    if (item == null) {
                      _keyStates[_keyStates.indexOf(state)] =
                          state.copyWith(state: false);
                      return "Campo obbligatorio";
                    } else {
                      _keyStates[_keyStates.indexOf(state)] =
                          state.copyWith(state: true);
                    }
                    return null;
                  },
                      items: profiles),
                );
              }
              if (state is ServerDataError) {
                return const Text("Errore Caricamento");
              }

              break;
            default:
              break;
          }
          return const Text("Stato sconosciuto");
        });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 600),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DialogTitleEx(widget.title!),
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
                              _passwordSection(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            OkCancel(
                okFocusNode: _saveFocusNode,
                onCancel: () {
                  Navigator.maybePop(context, null);
                },
                onSave: () {
                  validateSave();
                }),
          ],
        ),
      ),
    );
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(title: const Text("Inserimento dati"), tiles: [
      _avatarSettingTile(),
      _userNameSettingTile(),
      _profileSettingTile(),
      _surnameSettingTile(),
      _nameSettingTile(),
    ]);
  }

  SettingsScrollSection _passwordSection() {
    return SettingsScrollSection(title: const Text("Password"), tiles: [
      _passwordSetSettingTile(),
    ]);
  }

  SettingsTile _avatarSettingTile() {
    return getCustomSettingTile(child: _avatarLoad());
  }

  SettingsTile _userNameSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci nome utente',
        hint: 'Inserire nome utente',
        description:
            'Inserisci il nome da utilizzare per l\'accesso al programma',
        child: _userName());
  }

  SettingsTile _profileSettingTile() {
    return getCustomSettingTile(
        title: 'Seleziona profilo',
        hint: 'Seleziona profilo',
        description: 'Seleziona il profilo di accesso per l\'operatore',
        child: _profile());
  }

  SettingsTile _surnameSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci cognome',
        hint: 'Inserire cognome',
        description: 'Inserire il cognome dell\'operatore',
        child: _surname());
  }

  SettingsTile _nameSettingTile() {
    return getCustomSettingTile(
        title: 'Inserisci nome',
        hint: 'Inserire nome',
        description: 'Inserisci il nome dell\'operatore',
        child: _name());
  }

  SettingsTile _passwordSetSettingTile() {
    return getCustomSettingTile(
        title: 'Password',
        hint: 'Password',
        description: 'Gestione password di accesso',
        child: _passwordSet());
  }

  void validateSave() async {
    if (_formKey.currentState!.validate()) {
      // if ((element == null || element!.applicationUserId == 0) &&
      //     _passwordSetRequest == false) {
      //   await showSetPasswordErrorMessage();
      //   return;
      // }
      //salvataggio
      if (element == null) {
        element = ApplicationUser(
            applicationUserId: 0,
            userName: usernameController.text,
            surname: surnameController.text,
            name: nameController.text,
            applicationProfileId: selectedProfile!.applicationProfileId,
            profile: selectedProfile!.applicationProfileId == 0
                ? selectedProfile
                : null,
            password: passwordController.value,
            userDetails: List.generate(
                1,
                (index) => ApplicationUserDetail(
                    applicationUserDetailId: 0,
                    applicationUserId: 0,
                    image: _avatarBytes != null
                        ? base64Encode(_avatarBytes!)
                        : null)));
      } else {
        List<ApplicationUserDetail>? details;
        if (element!.userDetails == null || element!.userDetails!.isEmpty) {
          details = List.generate(
              1,
              (index) => ApplicationUserDetail(
                  applicationUserDetailId: 0,
                  applicationUserId: element?.applicationUserId,
                  /* thumbImage: _miniBytes!=null
                      ? base64Encode(_miniBytes!)
                      : null,*/
                  image: _avatarBytes != null
                      ? base64Encode(_avatarBytes!)
                      : null));
        } else {
          details = List.generate(
              1,
              (index) => element!.userDetails![0].copyWith(
/*                  thumbImage: _miniBytes!=null
                      ? base64Encode(_miniBytes!)
                      : null,*/
                  image: _avatarBytes != null
                      ? base64Encode(_avatarBytes!)
                      : null));
        }
        element = element!.copyWith(
            userName: usernameController.text,
            surname: surnameController.text,
            name: nameController.text,
            profile: selectedProfile!.applicationProfileId == 0
                ? selectedProfile
                : null,
            applicationProfileId: selectedProfile!.applicationProfileId,
            password: passwordController.value,
            userDetails: details);
      }

      //Navigator.pop(ctx, textController.text);
      Navigator.pop(context, element);
    } else {
      setState(() {
        _autovalidate = true;
      });
      try {
        KeyValidationState state =
            _keyStates.firstWhere((element) => element.state == false);

        Scrollable.ensureVisible(state.key.currentContext!,
            duration: const Duration(milliseconds: 500));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  showSetPasswordErrorMessage() async {
    var result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Impostare password',
            message:
            'Per poter salvare l\'operatore è necessario impostare una password',
            type: MessageDialogType.okOnly,
            okText: 'OK',
            okPressed: () {
              Navigator.pop(context, "0");
            });
      },
    ).then((value) async {
      return value;
      //return value
    });

    if (kDebugMode) {
      print(result);
    }
  }
}
