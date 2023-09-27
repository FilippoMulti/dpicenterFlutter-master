import 'dart:convert';
import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/download/download_helper.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/navigation_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/file_model.dart';
import 'package:dpicenter/models/server/importa_anagrafica_clienti_response.dart';
import 'package:dpicenter/models/server/issue_model.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/connected_clients/connected_clients_screen.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/login/login_screen_global.dart';
import 'package:dpicenter/screen/master-data/application_users/application_users_screen_ex.dart';
import 'package:dpicenter/screen/master-data/manufacturers/manufacturers_screen_ex.dart';
import 'package:dpicenter/screen/master-data/reports/report_screen_ex.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/slider_drawer_multi/slider_drawer_multi.dart';
import 'package:dpicenter/screen/widgets/update_server/update_server.dart';
import 'package:dpicenter/theme_manager/theme_select.dart';
import 'package:dpicenter/services/services.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:delta_e/delta_e.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:universal_io/io.dart';

part 'menu.g.dart';

enum MenuType {
  standard,
  searchResult,
  action,
  download,
  dashboard,
}

@CopyWith()
@JsonSerializable()
class Menu extends Equatable implements JsonPayload {
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic json;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Function? command;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int? currentTabIndex;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  static const int searchId = 10000;
  static const int destinationAndCommandsId = 19000;

  final int menuId;

  ///codice identificativo del menu
  final String code;
  final String label;
  final String? icon;
  final String? overlayIcon;

  final int? status;

  final bool? isVisible;

  final bool? isEnabled;

  ///lista di eventuali sub menu
  final List<Menu>? subMenus;

  ///colore del menu
  final String? color;

  ///screen di destinazione
  final String? destination;

  final bool openNewScreen;

  final bool isSelected;
  final double? left;
  final double? top;
  final double? height;
  final double? width;

  //final VoidCallback? onPressed;

  final MenuType type;

  /*final BuildContext? buildContext;*/

  const Menu({
    /*required this.buildContext,*/
    required this.menuId,
    required this.label,
    required this.code,
    this.icon,
    this.overlayIcon,
    this.isVisible,
    this.isEnabled,
    this.subMenus,
    this.color,
    this.destination,
    this.command,
    //this.onPressed,
    this.type = MenuType.standard,
    this.openNewScreen = false,
    this.isSelected = false,
    this.height,
    this.width,
    this.left,
    this.top,
    this.status,
    this.json,
    this.currentTabIndex,
    //this.onPressed,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    var result = _$MenuFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  static Menu fromJsonModel(Map<String, dynamic> json) => Menu.fromJson(json);

  @override
  List<Object?> get props =>
      [
        searchId,
        destinationAndCommandsId,
        menuId,
        label,
        icon,
        overlayIcon,
        isVisible,
        isEnabled,
        color,
        destination
      ];

  factory Menu.load() {
    var menus = Menu.loadWithoutDashboard();

    ///Dashboard

    var newSubMenus = menus.subMenus?.map((e) => e.copyWith()).toList();
    newSubMenus!.insert(
      0,
      menus.toDestinationAndCommands(),
    );

    if (isAndroidMobile) {
      newSubMenus.insert(
        0,
        Menu(
            menuId: 22,
            code: "22",
            label: 'Scarica App Android',
            icon: 'android',
            isVisible: true,
            isEnabled: true,
            type: MenuType.download,
            color: Colors.green.withAlpha(200).value.toString(),
            command: () async {
              var result = await showDialog(
                context: navigatorKey!.currentContext!,
                builder: (BuildContext context) {
                  return MessageDialog(
                      title: 'Applicazione per Android',
                      message:
                          'L\'applicazione per Android è più veloce della versione Web.\r\nScaricare l\'applicazione?',
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
              if (result is String) {
                if (result == "0") {
                  await downloadUpdate((rec, total) {
                    try {
                      if (kDebugMode) {
                        print("${((rec / total) * 100).toStringAsFixed(0)}%");
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  });
                }
              }
            }),
      );
    }
    menus = menus.copyWith(subMenus: newSubMenus);
    return menus;
  }

  List<Menu> toPlainList({List<Menu>? items, List<Menu>? result}) {
    items ??= subMenus;
    result ??= <Menu>[];
    if (items != null) {
      for (Menu menu in items) {
        result!.add(menu);
        if (menu.subMenus != null && menu.subMenus!.isNotEmpty) {
          result = toPlainList(items: menu.subMenus!, result: result);
        }
      }
    }
    return result!;
  }

  factory Menu.loadWithoutDashboard() {
    var menus = Menu(
        menuId: 1,
        code: "1",
        label: 'DpiCenter',
        icon: null,
        isVisible: true,
        isEnabled: true,
        subMenus: [
          Menu(
              menuId: 2,
              code: "2",
              label: 'Anagrafiche',
              icon: 'inventory_2',
              isVisible: true,
              isEnabled: true,
              color: Colors.indigoAccent.withAlpha(200).value.toString(),
              subMenus: [
                Menu(
                    menuId: 3,
                    code: "3",
                    label: 'Clienti',
                    icon: 'factory',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.green.withAlpha(200).value.toString(),
                    destination: "/anagrafiche/clienti"),
                Menu(
                  menuId: 4,
                  code: "4",
                  label: 'Macchine',
                  icon: 'developer_board',
                  //Icons.window,
                  isVisible: true,
                  isEnabled: true,
                  color: Colors.purpleAccent.withAlpha(200).value.toString(),
                  destination: "/anagrafiche/macchine",
                ),
                Menu(
                  menuId: 9001,
                  code: "9001",
                  label: 'Modelli macchina',
                  icon: 'window',
                  isVisible: true,
                  isEnabled: true,
                  color: Colors.orange.withAlpha(200).value.toString(),
                  destination: "/anagrafiche/modellivmc",
                ),
                Menu(
                  menuId: 9002,
                  code: "9002",
                  label: 'Articoli',
                  icon: 'list_alt',
                  isVisible: true,
                  isEnabled: true,
                  color: Colors.pinkAccent.shade700
                      .withAlpha(200)
                      .value
                      .toString(),
                  destination: "/anagrafiche/articoli",
                ),
                Menu(
                  menuId: 9003,
                  code: "9003",
                  label: 'Campionature',
                  icon: 'pan_tool',
                  isVisible: true,
                  isEnabled: true,
                  color: Colors.teal.withAlpha(200).value.toString(),
                  destination: "/anagrafiche/campionature",
                ),
                Menu(
                    menuId: 5,
                    code: "5",
                    label: 'Produttori',
                    icon: 'carpenter',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.pink.withAlpha(200).value.toString(),
                    destination: "/anagrafiche/produttori",
                    subMenus: [
                      Menu(
                          menuId: 6,
                          code: "6",
                          label: "Aggiungi produttore",
                          icon: 'carpenter',
                          overlayIcon: 'add',
                          isVisible: true,
                          isEnabled: true,
                          type: MenuType.action,
                          color: Colors.pink.withAlpha(200).value.toString(),
                          command: () async {
                            await ManufacturersActions.openNew(
                                    navigatorKey!.currentContext)
                                .then((value) async {
                              if (value is Manufacturer) {
                                MultiService<Manufacturer> service =
                                    MultiService<Manufacturer>(
                                        Manufacturer.fromJsonModel,
                                        apiName: 'Manufacturer');
                                await service.add(value);
                              }
                            });
                          })
                    ]),
                Menu(
                    menuId: 8,
                    code: "8",
                    label: 'HashTags',
                    icon: 'tag',
                    isVisible: true,
                    isEnabled: true,
                    color:
                        Colors.lightBlueAccent.withAlpha(200).value.toString(),
                    destination: "/anagrafiche/hashtags"),
                Menu(
                    menuId: 25,
                    code: "25",
                    label: 'Impostazioni base vmc',
                    icon: 'phonelink_setup',
                    isVisible: true,
                    isEnabled: true,
                    color:
                        Colors.lightBlueAccent.withAlpha(200).value.toString(),
                    destination: "/anagrafiche/vmcsettingfields"),
                Menu(
                    menuId: 26,
                    code: "26",
                    label: 'Categorie impostazioni',
                    icon: 'category',
                    isVisible: true,
                    isEnabled: true,
                    color:
                        Colors.lightBlueAccent.withAlpha(200).value.toString(),
                    destination: "/anagrafiche/vmcsettingcategories"),
                Menu(
                    menuId: 27,
                    code: "27",
                    label: 'Operazioni base vmc',
                    icon: 'checklist',
                    isVisible: true,
                    isEnabled: true,
                    color:
                        Colors.lightBlueAccent.withAlpha(200).value.toString(),
                    destination: "/anagrafiche/vmcproductionfields"),
                Menu(
                    menuId: 28,
                    code: "28",
                    label: 'Categorie operazioni',
                    icon: 'category',
                    isVisible: true,
                    isEnabled: true,
                    color:
                        Colors.lightBlueAccent.withAlpha(200).value.toString(),
                    destination: "/anagrafiche/vmcproductioncategories"),
              ]),
          Menu(
              menuId: 9,
              code: "9",
              label: 'Interventi',
              icon: 'build',
              isVisible: true,
              isEnabled: true,
              color: Colors.lightBlue.withAlpha(200).value.toString(),
              subMenus: [
                Menu(
                    menuId: 10,
                    code: "10",
                    label: 'Tickets',
                    icon: 'confirmation_number',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.red.withAlpha(200).value.toString()),
                Menu(
                    menuId: 11,
                    code: "11",
                    label: 'Assistenze',
                    icon: 'engineering',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.amberAccent.withAlpha(200).value.toString(),
                    destination: "/interventi/assistenze",
                    subMenus: [
                      Menu(
                          menuId: 21,
                          code: "21",
                          label: "Nuovo intervento",
                          icon: 'engineering',
                          overlayIcon: 'add',
                          isVisible: true,
                          isEnabled: true,
                          type: MenuType.action,
                          color: Colors.amberAccent
                              .withAlpha(200)
                              .value
                              .toString(),
                          command: () async {
                            await ReportActions.openNew(
                                    navigatorKey!.currentContext)
                                .then((value) async {
                              if (value is Report) {
                                MultiService<Report> service =
                                    MultiService<Report>(Report.fromJsonModel,
                                        apiName: 'Report');
                                await service.add(value);
                              }
                            });
                          }),
                    ])
              ]),
          Menu(
              menuId: 12,
              code: "12",
              label: 'Avanzate',
              icon: 'tune',
              isVisible: true,
              isEnabled: true,
              color: Colors.red.withAlpha(200).value.toString(),
              subMenus: [
                Menu(
                    menuId: 13,
                    code: "13",
                    label: 'Importa clienti',
                    icon: 'sync',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.amber.withAlpha(200).value.toString(),
                    command: () async {
                      await importaClienti(navigatorKey!.currentContext!);
                    }),
                /*Menu(
                  context,
                  id: 14,
                  text: 'Importa distributori',
                  icon: Icons.sync,
                  isVisible: true,
                  isEnabled: true,
                  color: Colors.deepOrange.withAlpha(200),
                  command: () async {
                    await _importaMacchine(context: context);
                  },
                ),*/
                Menu(
                    menuId: 15,
                    code: "15",
                    label: 'Migrate',
                    icon: 'storage',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.blueAccent.withAlpha(200).value.toString()),
                Menu(
                    menuId: 16,
                    code: "16",
                    label: 'Eventi',
                    icon: 'event_note',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.pink.withAlpha(200).value.toString(),
                    destination: "/avanzate/eventi"),
                /*Menu(context,
                    id: 9050,
                    text: 'Inizializza storico macchine',
                    icon: Icons.history,
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.blue.withAlpha(200), command: () async {
                  await _inizializzaStoricoMacchine(context);
                }),*/
                Menu(
                    menuId: 29,
                    code: "29",
                    label: 'Aggiorna server',
                    icon: 'upgrade',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.deepOrange.withAlpha(200).value.toString(),
                    command: () async {
                      await showUpdateServer(navigatorKey!.currentContext!);
                    }),
                Menu(
                    menuId: 30,
                    code: "30",
                    label: 'Client connessi',
                    icon: 'devices',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.purple.withAlpha(200).value.toString(),
                    command: () async {
                      await openConnectedClients(navigatorKey!.currentContext!);
                    }),
                Menu(
                    menuId: 9000,
                    code: "9000",
                    label: 'Configurazioni distributore',
                    icon: 'generating_tokens',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.blue.withAlpha(200).value.toString(),
                    openNewScreen: true,
                    destination: "/avanzate/vmc_configuration"),
                Menu(
                    menuId: 9004,
                    code: "9004",
                    label: 'Dataframes',
                    icon: 'description',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.blue.withAlpha(200).value.toString(),
                    openNewScreen: true,
                    destination: "/avanzate/dataframes"),
                Menu(
                    menuId: 9005,
                    code: "9005",
                    label: 'Docframes',
                    icon: 'dataset',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.blueGrey.withAlpha(200).value.toString(),
                    openNewScreen: true,
                    destination: "/avanzate/docframes"),
              ]),
          Menu(
              menuId: 18,
              code: "18",
              label: 'Accounts',
              icon: 'people',
              isVisible: true,
              isEnabled: true,
              color: Colors.yellowAccent.withAlpha(200).value.toString(),
              subMenus: [
                Menu(
                    menuId: 19,
                    code: "19",
                    label: 'Profili',
                    icon: 'manage_accounts',
                    isVisible: true,
                    isEnabled: true,
                    color:
                        Colors.deepPurpleAccent.withAlpha(200).value.toString(),
                    destination: "/accounts/profili"),
                Menu(
                    menuId: 20,
                    code: "20",
                    label: 'Operatori',
                    icon: 'person',
                    isVisible: true,
                    isEnabled: true,
                    color: Colors.blue.withAlpha(200).value.toString(),
                    destination: "/accounts/operatori",
                    subMenus: [
                      Menu(
                          menuId: 24,
                          code: "24",
                          label: "Aggiungi operatore",
                          icon: 'add_circle_outline',
                          isVisible: true,
                          isEnabled: true,
                          type: MenuType.action,
                          color: Colors.lightGreenAccent
                              .withAlpha(200)
                              .value
                              .toString(),
                          command: () async {
                            await ApplicationUsersActions.openNew(
                                    navigatorKey!.currentContext)
                                .then((value) async {
                              if (value is ApplicationUser) {
                                MultiService<ApplicationUser> service =
                                    MultiService<ApplicationUser>(
                                        ApplicationUser.fromJsonModel,
                                        apiName: 'ApplicationUser');
                                await service.add(value);
                              }
                            });
                          })
                    ]),
              ])
        ]);


    //var newSubMenus = menus.subMenus?.map((e) => e.copyWith()).toList();

    //menus = menus.copyWith(subMenus: newSubMenus);
    return menus;
  }

  factory Menu.loadUserMenu(context) {
    var menus = Menu(
      menuId: 10000,
      code: "10000",
      label: 'UserSettings',
      icon: null,
      isVisible: true,
      isEnabled: true,
      subMenus: [
        /*Menu(context,
            id: 20001,
            text: userName,
            icon: Icons.person,
            isVisible: true,
            isEnabled: true,
            color: Colors.indigoAccent.withAlpha(200), command: () async {
              */ /*if (navigatorKey != null && navigatorKey!.currentContext != null) {
                await disconnectUser(navigatorKey!.currentContext!);
              }*/ /*
            }),*/
        Menu(
            menuId: 10001,
            code: "10001",
            label: 'Disconnetti',
            icon: 'logout',
            isVisible: true,
            isEnabled: true,
            color: Colors.indigoAccent.withAlpha(200).value.toString(),
            command: () async {
              if (navigatorKey != null &&
                  navigatorKey!.currentContext != null) {
                await disconnectUser(navigatorKey!.currentContext!);
              }
            }),
        Menu(
          menuId: 10002,
          code: "10002",
          label: 'Impostazioni',
          icon: 'settings',
          isVisible: true,
          isEnabled: true,
          color: Colors.indigoAccent.withAlpha(200).value.toString(),
          command: () async {
            String url = MultiService.baseUrl;
            List? result = await manageSettings(navigatorKey!.currentContext!);
            if (result != null && result.isNotEmpty) {
              if (result[0] != url) {
                ///l'indirizzo è cambiato, mi disconnetto
                if (navigatorKey != null &&
                    navigatorKey!.currentContext != null) {
                  await disconnectUser(navigatorKey!.currentContext!,
                      confirmRequest: false);
                }
              }
            }
          },
        ),
        Menu(
            menuId: 10003,
            code: "10003",
            label: 'Tema',
            icon: 'brightness_4',
            isVisible: true,
            isEnabled: true,
            color: Colors.indigoAccent.withAlpha(200).value.toString(),
            command: () async {
              return await selectTheme(context);

              /*return await selectThemeMode(
              context,
              Theme.of(context).colorScheme.primary.value,
              const ValueKey('10003'));*/
            }),
        /*Menu(
            menuId: 10004,
            code: "10004",
            label: 'Dashboard',
            icon: 'dashboard_customize',
            isVisible: true,
            isEnabled: true,
            color: Colors.indigoAccent.withAlpha(200).value.toString(),
            command: () async {
              var result = await showDashboardConfigDialog(context);
              return result;
            }),*/
        Menu(
            menuId: 10005,
            code: "10005",
            label: 'Segnala un problema',
            icon: 'bug_report',
            isVisible: true,
            isEnabled: true,
            color: Colors.red.withAlpha(200).value.toString(),
            command: () async {
              if (navigationScreenKey != null &&
                  navigationScreenKey!.currentContext != null) {
                IssueModel? model =
                    await openReportProblem(navigatorKey!.currentContext!);
                if (model != null) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    navigationScreenKey!.currentState?.slideKey.currentState
                        ?.close();
                  });

                  await Future.delayed(const Duration(milliseconds: 500),
                      () async {
                    model = model!.copyWith(
                        message:
                            "${model!.message}\r\n## Versione App\r\n${startConfig!.currentVersionString!}\r\n## Versione Sistema Operativo\r\n${Platform.operatingSystemVersion}");

                    ScaffoldMessenger.of(navigationScreenKey!.currentContext!)
                      ..removeCurrentMaterialBanner()
                      ..showMaterialBanner(_showMaterialBanner(
                          navigatorKey!.currentContext!,
                          "Invio segnalazione in corso..."));
                    // print(model.toString());
                    HelperService service = HelperService();
                    bool? res = await service.createIssue(model!);
                    if (res != null && res) {
                      ScaffoldMessenger.of(navigatorKey!.currentContext!)
                        ..removeCurrentMaterialBanner()
                        ..showMaterialBanner(_showMaterialBanner(
                            navigatorKey!.currentContext!,
                            "Segnalazione inviata!"));
                    } else {
                      ScaffoldMessenger.of(navigatorKey!.currentContext!)
                        ..removeCurrentMaterialBanner()
                        ..showMaterialBanner(_showMaterialBanner(
                            navigatorKey!.currentContext!,
                            "Invio non riuscito!"));
                    }
                  });
                }
              }
            }),
        Menu(
            menuId: 10006,
            code: "10006",
            label: 'Informazioni sulla versione',
            icon: 'history',
            isVisible: true,
            isEnabled: true,
            color: Colors.white.withAlpha(200).value.toString(),
            command: () async {
                  openChangeLog(navigatorKey!.currentContext!);
            }),
      ],
    );

    if (isAndroidMobile) {
      menus.subMenus!.insert(
        0,
        Menu(
            menuId: 22,
            code: "22",
            label: 'Scarica App Android',
            icon: 'android',
            isVisible: true,
            isEnabled: true,
            type: MenuType.download,
            color: Colors.green.withAlpha(200).value.toString(),
            command: () async {
              var result = await showDialog(
                context: navigatorKey!.currentContext ?? context,
                builder: (BuildContext context) {
                  return MessageDialog(
                      title: 'Applicazione per Android',
                      message:
                          'L\'applicazione per Android è più veloce della versione Web.\r\nScaricare l\'applicazione?',
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
              if (result is String) {
                if (result == "0") {
                  await downloadUpdate((rec, total) {
                    try {
                      if (kDebugMode) {
                        print("${((rec / total) * 100).toStringAsFixed(0)}%");
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  });
                }
              }
            }),
      );
    }
    if (isWindowsBrowser) {
      menus.subMenus!.insert(
        0,
        Menu(
            menuId: 23,
            code: "23",
            label: 'Scarica App Windows',
            icon: 'win8',
            isVisible: true,
            isEnabled: true,
            type: MenuType.download,
            color: const Color(0xFF00ACEE).value.toString(),
            command: () async {
              var result = await showDialog(
                context: navigatorKey!.currentContext ?? context,
                builder: (BuildContext context) {
                  return MessageDialog(
                      title: 'Applicazione per Windows',
                      message:
                          'L\'applicazione per Windows è più veloce della versione Web.\r\nScaricare l\'applicazione?',
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
              if (result is String) {
                if (result == "0") {
                  await downloadUpdate((rec, total) {
                    try {
                      if (kDebugMode) {
                        print("${((rec / total) * 100).toStringAsFixed(0)}%");
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  });
                }
              }
            }),
      );
    }

    return menus;
  }

  factory Menu.loadAccountMenu(context, ApplicationUser user) {
    var menus = Menu(
      menuId: 20000,
      code: "20000",
      label: 'HeaderMenu',
      icon: null,
      isVisible: true,
      isEnabled: true,
      subMenus: [
        Menu(
            menuId: 20001,
            code: "20001",
            label: '${user.name} ${user.surname}',
            icon: 'person',
            isVisible: true,
            isEnabled: true,
            color: Colors.indigoAccent.withAlpha(200).value.toString(),
            command: () async {
              ApplicationUser? user = ApplicationUser.getUserFromSetting();
              if (user != null) {
                await ApplicationUsersActions.openDetailAndSave(
                        navigatorKey!.currentContext, user)
                    .then(
                        (value) {} /*async {
                    if (value!=null) {
                      ApplicationUserServices service =
                      ApplicationUserServices();
                      await service.update(value);
                      await service.(value);
                      prefs!.setString(userInfoSetting, jsonEncode(value.toJson()));
                    }
              }*/
                );
              }
              /*if (navigatorKey != null && navigatorKey!.currentContext != null) {
                await disconnectUser(navigatorKey!.currentContext!);
              }*/
            }),
      ],
    );

    return menus;
  }

  List<Menu> toList() {
    return toDestinationAndCommands().subMenus!;
  }

  Menu toDestinationAndCommands() {
    return _toDestinationAndCommands(this);
  }

  Menu _toDestinationAndCommands(Menu menu, {Menu? initMenu}) {
    initMenu ??= const Menu(
        label: 'Home',
        icon: 'home',
        code: "home",
        status: 2,
        //abilitato
        type: MenuType.dashboard,
        subMenus: <Menu>[],
        menuId: Menu.destinationAndCommandsId);

    if (menu.subMenus != null) {
      List<Menu> subMenus = <Menu>[];
      for (var menu in initMenu.subMenus!) {
        subMenus.add(menu);
      }

      for (var element in menu.subMenus!) {
        if (kDebugMode) {
          print(element.label);
        }
        if (element.destination != null || element.command != null) {
          subMenus.add(element);
          initMenu = initMenu?.copyWith(subMenus: subMenus);
        }

        if (element.subMenus != null) {
          initMenu = _toDestinationAndCommands(element, initMenu: initMenu);
        }
      }
    }
    return initMenu!;
  }

  static importaClienti(BuildContext context) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      allowedExtensions: ["xls", "xlsx"],
      type: FileType.custom,
    );
    if (file != null) {
      var result = await showDialog(
        context: navigatorKey!.currentContext ?? context,
        builder: (BuildContext context) {
          return MessageDialog(
              title: 'Importazione clienti',
              message: 'Importare i dati dei clienti dal file excel?',
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
      if (result is String) {
        if (result == "0") {
          Uint8List? bytes;
          if (file.files[0].bytes != null) {
            bytes = file.files[0].bytes!;
          } else {
            File fileToRead = File(file.files[0].path!);
            bytes = fileToRead.readAsBytesSync();
          }

          await _importaClientiCommand(context, bytes);
        }
      }
    }
  }

  /*static _importaMacchine({BuildContext? context}) async {
    var result = await showDialog(
      context: navigatorKey!.currentContext ?? context!,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Importazione macchine',
            message: 'Importare i dati delle macchine dai file excel?',
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
    if (result is String) {
      if (result == "0") {
        await _importaMacchineCommand();
      }
    }
  }
*/
  static Future<String> displayPasswordInputDialog(BuildContext context,
      String title, String hint, String initialValue) async {
    TextEditingController controller = TextEditingController();

    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: controller,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              // Only numbers can be entered*/
              onChanged: (value) {},
              decoration: InputDecoration(hintText: hint),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop("1");
                },
                child: Text(
                  'ANNULLA',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(controller.text);
                  },
                  child: const Text('SALVA')),
            ],
          );
        });

    // _controller.dispose();
  }

/*
  void _inizializzaStoricoMacchine(BuildContext context) async {
    var result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Inizializzazione storico macchine',
            message:
            'Inizializzare lo storico delle macchine ai valori di default. Attenzione verrà cancellato totalmente lo storico attuale e non sarà più possibile recuperarlo!\r\nContinuare?',
            type: MessageDialogType.yesNo,
            yesText: 'SI',
            noText: 'NO',
            okPressed: () async {
              String result = await displayPasswordInputDialog(
                  context, "Inserisci password", "", "");
              if (result == 'multi059') {
                Navigator.pop(context, "0");
              } else {
                Navigator.pop(context, "1");
              }
            },
            noPressed: () {
              Navigator.pop(context, "1");
            });
      },
    ).then((value) async {
      return value;
      //return value
    });
    if (result is String) {
      if (result == "0") {
        await _inizializzaStoricoMacchineCommand(context);
      }
    }
  }
*/

  static Future<void> _importaClientiCommand(BuildContext context, Uint8List fileBytes) async {
    SyncServices services = SyncServices();

    FileModel model =
    FileModel(name: "Anagrafiche.xlsx", content: base64Encode(fileBytes));
    var result = await services.syncCustomers(model);

    if (result != null) {
      ImportaAnagraficaClientiResponse response =
      ImportaAnagraficaClientiResponse.fromJsonModel(jsonDecode(result));
      //ok

      await _actionMessage(context, "Importazione clienti", response.info);
    } else {}
  }

/*
  static Future<void> _inizializzaStoricoMacchineCommand(BuildContext context) async {
    SyncServices services = SyncServices();
    bool? result = await services.initMachinesHistory();

    if (result != null) {
      //ok
      await _actionCompletedMessage(context);
    }
  }
*/

  static _actionCompletedMessage(BuildContext context) async {
    var result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Operazione completata',
            message: 'Operazione completata!',
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
  }

  static _actionMessage(BuildContext context, String title, String message) async {
    var result = await showDialog(
      context: navigatorKey!.currentContext ?? context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: title,
            message: message,
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
  }

  static Future<void> _importaMacchineCommand() async {
    SyncServices services = SyncServices();
    bool? result = await services.syncMachines();

    if (result != null) {
      //ok
    }
  }

  @override
  bool operator ==(Object other) => other is Menu && other.menuId == menuId;

  @override
  int get hashCode => menuId.hashCode;

  TreeNode generateTreeNodes({Menu? menu, TreeNode? root}) {
    menu ??= this;
    root ??= TreeNode(id: 'root', label: menu.label);
    if (menu.subMenus != null) {
      for (Menu subMenu in menu.subMenus!) {
        TreeNode newNode = TreeNode(
            id: subMenu.menuId.toString(), label: subMenu.label, data: subMenu);
        root.addChildren([newNode]);
        if (subMenu.subMenus != null) {
          generateTreeNodes(menu: subMenu, root: newNode);
        }
      }
    }
    return root;
  }

/*
  Menu _toDestinationAndCommands(Menu menu, {Menu? initMenu}) {
    initMenu ??= const Menu(
        label: 'Dashboard',
        icon: 'dashboard',
        type: MenuType.dashboard,
        subMenus: <Menu>[],
        programOperationId: Menu.destinationAndCommandsId);

    if (menu.subMenus != null) {
      List<Menu> _subMenus = <Menu>[];
      for (var menu in initMenu.subMenus!) {
        _subMenus.add(menu);
      }

      for (var element in menu.subMenus!) {
        if (kDebugMode) {
          print(element.label);
        }
        if (element.destination != null || element.command != null) {
          _subMenus.add(element);
          initMenu = initMenu?.copyWith(subMenus: _subMenus);
        }

        if (element.subMenus != null) {
          initMenu = _toDestinationAndCommands(element, initMenu: initMenu);
        }
      }
    }
    return initMenu!;
  }
  * */
}

LabColor getLabColor(Color color) {
  LabColor labColor = LabColor.fromRGB(color.red, color.green, color.blue);
  return labColor;
}

Color? getMenuColor(String? menuDefaultColor) {
  try {
    //print("last: ${menuDefaultColor}");
    if (menuDefaultColor != null) {
      Color primary = Theme.of(navigatorKey!.currentContext!).primaryColor;

      LabColor labColorPrimary = getLabColor(primary);
      LabColor labColorDefault =
          getLabColor(Color(int.parse(menuDefaultColor)));

      //double difference = computeColorDistance(primary, menuDefaultColor);
      double difference = deltaE76(labColorPrimary, labColorDefault);
      //print('difference: ' + difference.toString());
      if (difference < 50) {
        return invert(menuDefaultColor);
      }
      //print("last: ${menuDefaultColor}");
      return Color(int.parse(menuDefaultColor));
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return Colors.white;
}

Color? getReadableColor(String? colorToUse, Color themeColor) {
  try {
    //print("last: ${menuDefaultColor}");
    if (colorToUse != null) {
      Color primary = themeColor;

      LabColor labColorPrimary = getLabColor(primary);
      LabColor labColorDefault = getLabColor(Color(int.parse(colorToUse)));

      //double difference = computeColorDistance(primary, menuDefaultColor);
      double difference = deltaE76(labColorPrimary, labColorDefault);
      //print('difference: ' + difference.toString());
      if (difference < 50) {
        return invert(colorToUse);
      }
      //print("last: ${menuDefaultColor}");
      return Color(int.parse(colorToUse));
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return Colors.white;
}

MaterialBanner _showMaterialBanner(BuildContext context, String message) {
  return MaterialBanner(
    content: Text(message),
    leading: Icon(
      Icons.info,
      color: Theme.of(context).colorScheme.primary,
    ),
    padding: const EdgeInsets.all(16),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    contentTextStyle:
        TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
    actions: [
      TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        },
        child: const Text(
          'OK',
        ),
      ),
    ],
    /*actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Agree',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ]*/
  );
}