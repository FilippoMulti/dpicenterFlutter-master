import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_profile.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/treeview/node/tree_node_tile.dart';
import 'package:dpicenter/screen/widgets/treeview/treeview_app_controller.dart';
import 'package:dpicenter/services/services.dart';

//import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:settings_ui/settings_ui.dart';

import '../validation_helpers/key_validation_state.dart';
import 'package:get/get.dart';

// Define a custom Form widget.
class ApplicationProfileEditForm extends StatefulWidget {
  final ApplicationProfile? element;
  final String? title;

  const ApplicationProfileEditForm(
      {Key? key, required this.element, required this.title})
      : super(key: key);

  @override
  ApplicationProfileEditFormState createState() {
    return ApplicationProfileEditFormState();
  }
}

class ApplicationProfileEditFormState
    extends State<ApplicationProfileEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController profileNameController;

  late final AppController appController;

  ApplicationProfile? element;

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  ///chiavi per i campi da compilare
  final GlobalKey _profileNameKey = GlobalKey(debugLabel: '_profileNameKey');

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  ///attiva o disattiva l'autovalidazione
  bool _autovalidate = false;

  ///Focus
  final FocusNode _profileNameFocusNode =
      FocusNode(debugLabel: "_profileNameFocusNode");

  final FocusNode _saveFocusNode = FocusNode(debugLabel: "_saveFocusNode");

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _profileNameKey),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    appController.dispose();
  }

  @override
  void initState() {
    super.initState();

    initKeys();
    element = widget.element;
    //appController = AppController.of(context);

    if (element != null) {
      profileNameController = TextEditingController(text: element!.profileName);
      appController = AppController(initialValue: element!.enabledMenus);
    } else {
      profileNameController = TextEditingController();
      appController = AppController();
    }
  }

  Widget _profileName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: TextFormField(
        key: _profileNameKey,
        autovalidateMode: _autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: profileNameController,
        maxLength: 500,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nome profilo',
          hintText: 'Inserisci il nome del profilo',
        ),
        validator: (str) {
          KeyValidationState state = _keyStates
              .firstWhere((element) => element.key == _profileNameKey);
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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 800, maxHeight: 800),
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

/*    return FocusScope(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: Get.width < 800 ? Get.width : Get.width - 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DialogTitle(widget.title!),
                        _profileName(),
                        ElevatedButton(
                          onPressed: () async {
                            debugPrint("start save");
                            var service = BaseServiceEx<Menu>(
                                Menu.fromJsonModel,
                                apiName: 'Menu');

                            Menu.loadWithoutDashboard()
                              ..toPlainList().forEach((element) async {
                                await service.add(element);
                              });
                            debugPrint("save end!");
                          },
                          child: const Text('Crea menu'),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _configTreeView(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )),
          ),
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
    );*/
  }

  SettingsScrollSection _configurationSection() {
    return SettingsScrollSection(title: const Text("Inserimento dati"), tiles: [
      _profileNameSettingTile(),
      _createMenuSettingTile(),
      _configTreeViewSettingTile(),
    ]);
  }

  SettingsTile _profileNameSettingTile() {
    return getCustomSettingTile(
        title: 'Nome del profilo',
        hint: 'Inserire nome del profilo',
        description: 'Inserisci un nome da associare a questo profilo',
        child: _profileName());
  }

  SettingsTile _configTreeViewSettingTile() {
    return getCustomSettingTile(
        title: 'Abilitazioni profilo',
        hint: 'Abilitazioni profilo',
        description: 'Imposta cosa può e cosa non può fare questo profilo',
        child: _configTreeView());
  }

  SettingsTile _createMenuSettingTile() {
    return getCustomSettingTile(
        title: 'Creazione menu (debug)',
        hint: 'Creazione menu (debug)',
        description: 'Ricrea i menu, utilizzare solo per debug',
        child: _createMenuButton());
  }

  Widget _createMenuButton() {
    return ElevatedButton(
      onPressed: () async {
        debugPrint("start save");
        var service = MultiService<Menu>(Menu.fromJsonModel, apiName: 'Menu');

        Menu loadedMenu = Menu.loadWithoutDashboard();
        loadedMenu.toPlainList().forEach((element) async {
          await service.add(element);
        });
        debugPrint("save end!");
      },
      child: const Text('Crea menu'),
    );
  }

  Widget _configTreeView() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: isDarkTheme(context) ? Colors.white60 : Colors.black54)),
      child: AppControllerScope(
        controller: appController,
        child: FutureBuilder<void>(
          future: appController.initMenus(),
          builder: (_, __) {
            if (appController.isInitialized) {
              //return const _Unfocus(child: HomePage());
              return _treeView();
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _treeView() {
    return ValueListenableBuilder<TreeViewTheme>(
      valueListenable: appController.treeViewTheme,
      builder: (_, treeViewTheme, __) {
        return LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            child: TreeView(
              shrinkWrap: true,
              width: 1200,
              physics: const NeverScrollableScrollPhysics(),
              controller: appController.treeController,
              theme: treeViewTheme,
              scrollController: appController.scrollController,
              nodeHeight: appController.nodeHeight,
              nodeBuilder: (_, node) => TreeNodeTile(menu: node.data as Menu),
            ),
          );
        });
      },
    );
  }

  void validateSave() async {
    if (_formKey.currentState!.validate()) {
      // if ((element == null || element!.applicationUserId == 0) &&
      //     _passwordSetRequest == false) {
      //   await showSetPasswordErrorMessage();
      //   return;
      // }

/*
      for (TreeNode myNode in appController.rootNode.descendants){
        print("myNode Id: ${myNode.id} - ${NodeMultiSelector.getStatus(myNode, appController)}" );
      }*/
/*      appController.rootNode.descendants
          .map((e) => ApplicationProfileEnabledMenu(
              applicationProfileEnabledMenuId: element!.enabledMenus
                      ?.firstWhereOrNull((element) =>
                          element.menuId == (e.data as Menu).menuId)
                      ?.applicationProfileEnabledMenuId ??
                  0,
              applicationProfileId: element!.applicationProfileId,
              menuId: (e.data as Menu).menuId,
              status: NodeMultiSelector.getStatus(e, appController)))
          .toList();*/
      //salvataggio
      if (element == null) {
        element = ApplicationProfile(
            applicationProfileId: 0,
            profileName: profileNameController.text,
            specialType: 0,
            enabledMenus: appController.rootNode.descendants
                .map((e) => ApplicationProfileEnabledMenu(
                    applicationProfileId: 0,
                    applicationProfileEnabledMenuId: 0,
                    menuId: (e.data as Menu).menuId,
                    status: NodeMultiSelector.getStatus(e, appController)))
                .toList());
      } else {
        element = element!.copyWith(
            applicationProfileId: element!.applicationProfileId,
            profileName: profileNameController.text,
            specialType: element!.specialType,
            enabledMenus: appController.rootNode.descendants
                .map((e) => ApplicationProfileEnabledMenu(
                    applicationProfileEnabledMenuId: element!.enabledMenus
                            ?.firstWhereOrNull((element) =>
                                element.menuId == (e.data as Menu).menuId)
                            ?.applicationProfileEnabledMenuId ??
                        0,
                    applicationProfileId: element!.applicationProfileId,
                    menuId: (e.data as Menu).menuId,
                    status: NodeMultiSelector.getStatus(e, appController)))
                .toList());
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

        _scrollController.position.ensureVisible(
          state.key.currentContext!.findRenderObject()!,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
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
