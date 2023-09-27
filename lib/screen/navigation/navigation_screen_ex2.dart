import 'dart:math';

import 'package:dpicenter/action_intents/action_intent.dart';
import 'package:dpicenter/blocs/search_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/navigation_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/navigation/accout_drawer_item.dart';
import 'package:dpicenter/screen/navigation/multi_scaffold_ex.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/app_bar.dart';
import 'package:dpicenter/screen/widgets/changelog/change_log_screen.dart';
import 'package:dpicenter/screen/widgets/navigation_bar/navigation_bar.dart';
import 'package:dpicenter/screen/widgets/slider_drawer_multi/alignment.dart';
import 'package:dpicenter/screen/widgets/slider_drawer_multi/slider_drawer_multi.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_keyboard_size/screen_height.dart';

import 'custom_tab_bar.dart' as multi_tabbar;
import 'package:collection/collection.dart';

class NavigationScreenPageEx extends StatefulWidget {
  const NavigationScreenPageEx({Key? key, required this.title, this.menu})
      : super(key: key);

  /// Access to the closest [NavigationScreenPageEx] instance to the given context.
  static NavigationScreenPageExState? of(BuildContext context) {
    return context.findAncestorStateOfType<NavigationScreenPageExState>();
  }

  final String title;
  final Menu? menu;

  @override
  NavigationScreenPageExState createState() => NavigationScreenPageExState();

  static Widget withSearchBlocProvider({Key? key, String? title, Menu? menu}) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  NavigationScreenBloc(repo: LocalSearchService())),
          BlocProvider(
              create: (context) => ServerDataBloc<ApplicationUser>(
                  repo: MultiService<ApplicationUser>(
                      ApplicationUser.fromJsonModel,
                      apiName: 'ApplicationUser'))),
          BlocProvider(
              create: (context) => ServerDataBloc<Menu>(
                  repo:
                      MultiService<Menu>(Menu.fromJsonModel, apiName: "Menu"))),
        ],
        child: NavigationScreenPageEx(
            key: key, title: title ?? 'Dpi Center', menu: menu));
  }
}

class NavigationScreenPageExState extends State<NavigationScreenPageEx>
    with TickerProviderStateMixin {
  bool get isWebMobileA =>
      isWebMobile || MediaQuery.of(context).size.width < 400;

  TabController? tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffoldKey");
  List<GlobalKey<MultiScaffoldState>>? _scaffoldKeys;

/*  List<ScrollController>? _scrollControllers;
  List<ScrollController>? _gridViewScrollControllers;*/

  final GlobalKey<SlideDrawerMultiState> slideKey =
      GlobalKey<SlideDrawerMultiState>(debugLabel: "sliderDrawerMultiKey");
  final ValueKey _tabControllerKey = const ValueKey("tabController");
  GlobalKey? _tabViewKey;

/*  List<GlobalKey>? _containerKeys;*/

  final GlobalKey<MultiNavigationBarState> _navigationBarKey =
      GlobalKey<MultiNavigationBarState>(debugLabel: '_navigationBarKey');

  ///menu con le impostazioni dell'operatore
  Menu? userSettings;

  ///menu dell'account dell'operatore
  Menu? accountMenu;

  ///menu corrente
  Menu? currentMenu;

  ///menu preferiti
  Menu? favoritesMenu;

  ///menu selezionato
  List<Menu?>? _selectedMenu;

  ///ricarica i menu al successivo setState
  bool reloadMenu = false;

  //late TabController _tabBarController;
  // List<GlobalKey<MultiScaffoldState>>? _scaffoldKeys;

  List<Widget>? _scaffolds;

  Animation? _sizeActionIconAnimation;
  Animation? _sizeTabIconAnimation;
  Animation? _sizeTabTextAnimation;

  AnimationController? _animationController;

  ApplicationUser? user;

  @override
  void reassemble() {
/*    debugPrint("NavigationScreen goes down");
    eventBus.fire(RestartHubEvent(newUrl: BaseServiceEx.baseUrl));*/
    super.reassemble();
  }

  /*///aggiorna navigation screen dall'esterno
  void updateUser(ApplicationUser? userNew) {
    if (userNew!=null) {
      setState(() {
        user = userNew;
      });
    }
  }*/

  final GlobalKey<AccountDrawerMenuState> accountDrawerKey =
  GlobalKey<AccountDrawerMenuState>(debugLabel: '_accountDrawerKey');

  @override
  void initState() {
    super.initState();
    //_loadMenuAsync(true);

    user = ApplicationUser.getUserFromSetting();
    initMenu();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _sizeActionIconAnimation = Tween<double>(begin: 16.0, end: 24.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.linear))
      ..addListener(() {
        setState(() {
          //print("value changed!!!!!: " + _sizeAnimation!.value.toString());
        });
      });
    _sizeTabIconAnimation = Tween<double>(begin: 16.0, end: 32.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.linear))
      ..addListener(() {
        setState(() {
          //print("value changed!!!!!: " + _sizeAnimation!.value.toString());
        });
      });
    _sizeTabTextAnimation = Tween<double>(begin: 12.0, end: 24.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.linear))
      ..addListener(() {
        setState(() {
          //print("value changed!!!!!: " + _sizeAnimation!.value.toString());
        });
      });

    _tabViewKey ??= GlobalKey(debugLabel: "_tabViewKey");

    userSettings = Menu.loadUserMenu(context);
    accountMenu =
        Menu.loadAccountMenu(context, ApplicationUser.getUserFromSetting()!);

    //  initMenu();

    /*favoritesMenu = currentMenu?.subMenus?.firstWhere((element) => element.type==MenuType.dashboard);
    if (favoritesMenu!=null){
      LocalSearchService menuLoader = LocalSearchService();
      menuLoader.loadFavorites(context).then((value){
        setState(() {
          favoritesMenu?.subMenus?.clear();
        });
        value?.subMenus?.forEach((element) {
          setState(() {
            favoritesMenu?.subMenus?.add(element);
          });
        });
      });
    }*/
  }

/*  _loadMenus(BuildContext context) {
    var bloc = BlocProvider.of<NavigationScreenBloc>(context);
    bloc.add(NavigationScreenEvent(
        status: NavigatorScreenEvents.loadMenus,
        param: null,
        context: context));
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  void _loadMenuAsync(bool refresh) {
    var bloc = BlocProvider.of<ServerDataBloc>(context);

    bloc.add(ServerDataEvent<Menu>(
      status: ServerDataEvents.fetch,
      refresh: refresh,
    ));
  }

  void initMenu() {
    if (widget.menu == null) {
      //_loadMenus(context);
      currentMenu = Menu.load();

      // currentMenu = menu;
      // print("qui");
    } else {
      currentMenu = widget.menu;
      /*if (dashBoardMenu!=null && dashBoardMenu!.subMenus!=null) {
        dashBoardMenu!.subMenus!.forEach((element) {
          element.buildContext = context;
        });
      }*/

    }
    currentMenu?.subMenus
        ?.retainWhere((element) => element.type != MenuType.download);

    //currentMenu?.subMenus?.retainWhere((element) => element.type!=MenuType.dashboard);

    try {
      favoritesMenu = currentMenu?.subMenus
          ?.firstWhere((element) => element.type == MenuType.dashboard);
      dashBoardMenu = favoritesMenu;
    } catch (e) {
      if (kDebugMode) {
        print('errore favorites menu $e');
      }
    }

    try {
      updateBaseMenu(currentMenu!.subMenus!, user!.profile!.enabledMenus!);
      for (var element in currentMenu!.subMenus!) {
        print('${element.label} status: ${element.status}');
      }

      ///rimuovo gli elementi disabilitati
      currentMenu = currentMenu?.copyWith(
          subMenus: currentMenu?.subMenus
              ?.where(
                  (element) => element.status != null && element.status != 0)
              .toList(growable: false));
      try {
        ///rimuovo gli elementi disabilitati dalla dashboard
        currentMenu!.subMenus![0] = currentMenu!.subMenus![0].copyWith(
            subMenus: currentMenu!.subMenus![0].subMenus
                ?.where(
                    (element) => element.status != null && element.status != 0)
                .toList(growable: false));
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  void updateBaseMenu(List<Menu> baseMenuList, List<ApplicationProfileEnabledMenu> valueItems) {
    for (int index = 0; index < baseMenuList.length; index++) {
      Menu menu = baseMenuList[index];

      ApplicationProfileEnabledMenu? menuFounded = valueItems
          .firstWhereOrNull((element) => element.menuId == menu.menuId);
      if (menuFounded != null) {
        baseMenuList[index] = menu.copyWith(status: menuFounded.status);
      } else {
        //se il menu non è stato trovato
        // ma ha uno status definito da programma (ad esempio la Dashboard)
        //mantengo lo status corrente
        //baseMenuList[index] = menu.copyWith(status: null);
        //baseMenuList[index] = menu.copyWith(status: menu.status);
      }

      if (menu.subMenus != null && menu.subMenus!.isNotEmpty) {
        updateBaseMenu(menu.subMenus!, valueItems);
      }
    }
  }

  void reload() {
    setState(() {
      reloadMenu = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaData = MediaQuery.of(context);
    //_tabBarController = TabController(length: currentMenu?.subMenus?.length ?? 0, vsync: this);
    if (reloadMenu) {
      reloadMenu = false;
      user = ApplicationUser.getUserFromSetting();
      initMenu();
    }

/*    _scrollControllers ??= List.generate(
        currentMenu?.subMenus?.length ?? 0,
        (index) => ScrollController(
            debugLabel:
                "scrollController_${currentMenu?.subMenus?[index].text}"));
    _gridViewScrollControllers ??= List.generate(
        currentMenu?.subMenus?.length ?? 0,
        (index) => ScrollController(
            debugLabel:
                "gridViewScrollController_${currentMenu?.subMenus?[index].text}"));*/

    if (_scaffoldKeys == null || reloadMenu) {
      _scaffoldKeys = List.generate(
          currentMenu?.subMenus?.length ?? 0,
              (index) => GlobalKey<MultiScaffoldState>(
              debugLabel: "_scaffoldKeys[${index.toString()}]"));
/*    _containerKeys ??= List.generate(
        currentMenu?.subMenus?.length ?? 0,
        (index) =>
            GlobalKey(debugLabel: "_containerKeys[${index.toString()}]"));*/
    }
    if (_selectedMenu == null || reloadMenu) {
      _selectedMenu =
          List.generate(currentMenu?.subMenus?.length ?? 0, (index) => null);
    }
    //if (_scaffolds == null) {---> mettendo questo non rileva ovviamente le modifiche con setState
    _scaffolds = List.generate(
        currentMenu?.subMenus?.length ?? 0,
            (index) => MultiScaffold(
            onMenuClose: (menu) {
              _navigationBarKey.currentState?.remove(menu);
            },
            onMenuOpen: (menu) {
              _navigationBarKey.currentState?.add(menu);
            },
            onMenuChanged: (menu) {
              _navigationBarKey.currentState?.onMenuSelected(menu);
            },
            isDashboard: index == 0,
            onMenuRemove: index == 0
                ? (Menu menu) {
                    setState(() {
                      List<Menu> subMenus = <Menu>[];

                      var res = currentMenu!.subMenus![index];

                      for (var menu in res.subMenus!) {
                        if (menu.menuId != menu.menuId) {
                    subMenus.add(menu);
                  }
                }
                currentMenu!.subMenus![index] = currentMenu!
                    .subMenus![index]
                    .copyWith(subMenus: subMenus);
              });
            }
                : null,
            key: _scaffoldKeys![index],
            menu: currentMenu!.subMenus![index]));

    //}
/*    if (_pageKeys==null){
      _pageKeys = List.generate(currentMenu?.subMenus?.length ?? 0, (index) =>
          ValueKey(index));
    }*/

    ///ho utilizzato SafeArea perchè su Android l'area occupata dalla tabbar finiva
    ///per coprire la StatusBar di Android
    return Container(
      color: isLightTheme(context)
          ? Theme.of(context).colorScheme.primary
          : Color.alphaBlend(
          Theme.of(context).colorScheme.surface.withAlpha(240),
          Theme.of(context).colorScheme.primary),
      child: SafeArea(
          child: DefaultTabController(
              key: _tabControllerKey,

              //animationDuration: Duration(milliseconds: 600),

              length: currentMenu?.subMenus?.length ?? 0,
              child: SlideDrawerMulti(
                  backgroundColor: isLightTheme(context)
                      ? Color.alphaBlend(
                      Theme.of(context).colorScheme.primary.withAlpha(240),
                      Theme.of(context).colorScheme.surface)
                      : Color.alphaBlend(Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.primary.withAlpha(240)),
                  alignment: SlideDrawerAlignment.start,
                  key: slideKey,
                  offsetFromRight: MediaQuery.of(context).size.width - 300,
                  isRotate: false,
                  headDrawer: Builder(builder: (context) {
                    return headDrawer();
                  }),
                  contentDrawer: mainDrawer(),
                  child: WillPopScope(
                    onWillPop: isDesktop
                        ? null
                        : () async {
                      bool close = (await showCloseMessage() ?? false);
                      return close;
                    },
                    child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        key: _scaffoldKey,
                        appBar: customAppBar(),
                        body: multiTabBarView()),
                  )))),
    );
  }

  double getTextAreaHeight(ScreenHeight res) {
    MediaQueryData mediaData = MediaQuery.of(context);
    double keyboardHeight = res.keyboardHeight;
    double result =
        mediaData.size.height - mediaData.padding.top - keyboardHeight;

    return result;
  }

  double oldActionButtonIconSize = 0;

  @override
  void didChangeDependencies() {
    MediaQuery.of(context).size.height < tinyHeight
        ? _animationController?.reverse()
        : _animationController?.forward();

    /*double actionButtonIconSize = getActionButtonsIconSize(context);
    try {
      if (oldActionButtonIconSize==0.0){
            oldActionButtonIconSize=actionButtonIconSize;

          } else if (oldActionButtonIconSize<actionButtonIconSize){
            animationController?.isAnimating==false ? animationController?.forward() : null;

          } else if (oldActionButtonIconSize>actionButtonIconSize) {

            animationController?.isAnimating==false ? animationController?.reverse() : null;
          }
    } catch (e) {
      print(e);
    }
    oldActionButtonIconSize=actionButtonIconSize;*/
    super.didChangeDependencies();
  }

  /*late Menu headerMenu;
  Widget headDrawer() {
    headerMenu = Menu.loadHeaderMenu(context, prefs!.getString(usernameSetting) ?? '');

    return Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
            children: List.generate(headerMenu.subMenus!.length, (index) {
              Menu menu = headerMenu.subMenus![index];
              return getDrawerMenu(menu, () { });
              //ListTile(leading: Icon(menu.icon),title: Text(menu.text), onTap: menu.command,);
            })));
  }*/

  Widget getDrawerMenu(Menu menu, VoidCallback? onTap) {
    return Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(80)),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.primary,
          onTap: onTap,
          child: ListTile(
              leading: Icon(icons[menu.icon], color: Colors.white),
              title: Text(menu.label,
                  style: const TextStyle(color: Colors.white))),
        ));
  }

  /*Widget getAccountDrawerMenu(Menu menu, VoidCallback? onTap) {
    return Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(80)),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.primary,
          onTap: onTap,
          child: ListTile(
              leading: user != null &&
                      user!.userDetails != null &&
                      user!.userDetails!.isNotEmpty &&
                      user?.userDetails![0].image != null
                  ? CircleAvatar(
                      backgroundImage: Image.memory(
                              base64Decode(user!.userDetails![0].image!))
                          .image,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryVariant,
                      radius: 20.0,
                    )
                  : const Icon(Icons.person),
              title: Text(menu.label)),
        ));
  }*/

  Widget headDrawer() {
    return Column(
      children: [
        if (!isDesktop) const SizedBox(height: 16),
        if (!isDesktop)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Text(
                    "Multi-Tech\r\nDpi Center ${startConfig!.currentVersionString!}v${startConfig!.currentVersion!}@${MultiService.baseUrl} (${kServerVersionString ?? '?'} - ${kServerVersion ?? '?'})",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall),
                onPressed: () {},
              ),
            ),
          ),
        if (!isDesktop) const SizedBox(height: 8),
        Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(80)),
                color: Colors.black38.withAlpha(50)),
            alignment: Alignment.centerLeft,
            height: 80,
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(accountMenu!.subMenus!.length, (index) {
                  Menu menu = accountMenu!.subMenus![index];
                  return Builder(builder: (context) {
                    return AccountDrawerMenu(
                        key: accountDrawerKey,
                        menu: menu,
                        onTap: () async {
                          //switch (menu.id) {
                          dynamic result = await menu.command!.call();
                          reloadUser();
                          return ApplicationUser.getUserFromSetting();
                        },
                        user: user!);
                  });
                }))),
      ],
    );
  }

  Widget mainDrawer() {
    /*final RenderBox renderBox = _slideKey.currentContext!.findRenderObject() as RenderBox;
          final Size size = renderBox.size;

          print("paintBounds: " + _slideKey.currentContext!.findRenderObject()!
              .paintBounds
              .height.toString());

          print("paintBounds: " + size
              .height.toString());*/

    return Center(
        child: SingleChildScrollView(
          child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  List.generate(userSettings!.subMenus!.length, (index) {
                    Menu menu = userSettings!.subMenus![index];
                    return getDrawerMenu(
                      menu,
                          () async {
                        switch (menu.menuId) {
                          case 10003: //tema
                            dynamic result = await menu.command!.call();
                            if (result != null) {
                              /*setState(() {
                                  ///esco dalle schermate (PlutoGrid non rileva il cambio di tema in automatico
                                  ///per ora, quando viene cambiato il tema chiudo le schermate aperte)
                                  for (int i = 0; i <
                                      _scaffoldKeys!.length; i++) {
                                    setState(() {
                                      _selectedMenu?[i] = null;
                                    });
                                  }
                                });*/
                            }
                            break;
                          case 10004: //dashboard
                            dynamic result = await menu.command!.call();
                            if (result != null) {
                              setState(() {
                                favoritesMenu = result;
                              });
                            }
                            break;
                          default:
                            await menu.command!.call();
                            //dynamic result = await menu.command!.call();
                            break;
                        }
                      },
                    );
                    /*return Material(
              type: MaterialType.transparency,
              child: InkWell(
                splashColor: Theme.of(context).colorScheme.primary,
                onTap: () async {
                  switch (menu.id) {
                    case 10003: //tema
                      dynamic result = await menu.command!.call();
                      if (result != null) {
                        setState(() {
                          ///esco dalle schermate (PlutoGrid non rileva il cambio di tema in automatico
                          ///per ora, quando viene cambiato il tema chiudo le schermate aperte)
                          for (int i = 0; i < _scaffoldKeys!.length; i++) {
                            setState(() {
                              _selectedMenu?[i] = null;
                            });
                          }
                        });
                      }
                      break;
                    case 10004: //dashboard
                      dynamic result = await menu.command!.call();
                      if (result != null) {
                        setState(() {
                          favoritesMenu = result;
                        });
                      }
                      break;
                    default:
                      await menu.command!.call();
                      //dynamic result = await menu.command!.call();
                      break;
                  }
                },
                child: ListTile(
                    leading: Icon(menu.icon), title: Text(menu.text)), // ListTile
              ), // InkWell
          ); // Ma
          //ListTile(leading: Icon(menu.icon),title: Text(menu.text), onTap: menu.command,);*/
                  }))),
        ));
  }

  double oldHeight = 0;

  PreferredSize customAppBar() {
    var themeModeHandler = ThemeModeHandler.of(context);
    double height = 0;
    if (isWebMobileA) {
      height = getAppBarHeightForWeb(context);
    } else {
      height = getAppBarHeight(context);
    }

    if (oldHeight == 0) {
      oldHeight = height;
    } else if (oldHeight < height) {
      //si sta ingrandendo
      oldHeight = height;
    }

    if (kDebugMode) {
      print(height);
    }
    return PreferredSize(
        preferredSize: Size.fromHeight(oldHeight),
        child: Builder(builder: (BuildContext context) {
          tabController = DefaultTabController.of(context);
          tabController?.addListener(() {
            if (!(tabController?.indexIsChanging ?? false)) {
              // Your code goes here.
              // To get index of current tab use tabController.index
            }
          });

          return Column(
            children: [
              Expanded(
                child: AnimatedContainer(
                    onEnd: () => setState(() {
                      oldHeight = height;
                    }),
                    height: height,
                    duration: const Duration(milliseconds: 250),
                    /*decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).highlightColor, width: 0.5),
                      */ /*borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20)),*/ /*
                    ),*/
                    /*constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: double.infinity),*/
                    child: Material(
                        clipBehavior: Clip.antiAlias,
                        shape: const CustomAppBarShape(),
                        /*borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20)),*/
                        color: isDarkTheme(context)
                            ? Color.alphaBlend(
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withAlpha(240),
                            Theme.of(context).colorScheme.primary)
                            : Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  if (isWebMobileA) const SizedBox(width: 16),
                                  if (isWebMobileA)
                                    actionButtons(tabController!),
                                  const SizedBox(width: 16),
                                  if (themeModeHandler?.themeColor.menuType ==
                                      0)
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: multiTabBar()),
                                    ),

                                  /*const SizedBox(width: 16),
                                  IconButton(
                                      onPressed: () async {
                                        */ /*LocalSearchService menuLoader = LocalSearchService();
                                                      var value = await menuLoader.loadFavorites(context);
                                                    favoritesMenu?.subMenus?.clear();
                                                    value?.subMenus?.forEach((element) {
                                                      favoritesMenu?.subMenus?.add(element);
                                                      return;
                                                    });
                                                    Menu oldMenu = currentMenu!;

                                                    oldMenu.subMenus![0]=favoritesMenu!;

                                                    _tabViewKey!.currentState!.setState(() {

                                                      currentMenu=null;
                                                      currentMenu=oldMenu;
                                                    });
                                                          setState(() {


                                                            //      currentMenu?.subMenus?.insert(0, value!);
                                                          });*/ /*
                                      },
                                      icon: Icon(Icons.manage_accounts,
                                          color:
                                              Theme.of(context).textTheme.labelLarge!.color)),*/
                                ],
                              ),
                            ),
                            if (!isWebMobileA)
                              MultiNavigationBar(
                                key: _navigationBarKey,
                                scaffoldKeys: _scaffoldKeys!,
                                tabController: tabController,
                                slideKey: slideKey,
                              ),
                            /*Container(height: 32,
                              color: Colors.black54,
                              child: Row(
                                children: [
                                 const SizedBox(width: 20),
                                  actionButtons(tabController),
                                  const SizedBox(width: 16),


                                ],
                              ),
                            ),*/
                            const SizedBox(height: 8),
                          ],
                        ))),
              ),
            ],
          );
        }));
  }

  Widget actionButtons(TabController tabController) {
    double actionButtonHeight = getActionButtonsHeight(context);
    //double actionButtonIconSize = getActionButtonsIconSize(context);

    ///Menu button
    return AnimatedContainer(
        height: actionButtonHeight,
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          clipBehavior: Clip.antiAlias,
          color: Color.alphaBlend(
              Theme.of(context).colorScheme.background.withAlpha(220),
              Theme.of(context).colorScheme.primary),
          //Color.alphaBlend(Theme.of(context).colorScheme.background.withAlpha(240), Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(20),
          elevation: 0,
          child: Row(
            children: [
              IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Visualizza\\Nasconde menu',
                  onPressed: () async {
                    await _scaffoldKeys?[tabController.index]
                        .currentState
                        ?.toggle();
                  },
                  icon: Icon(Icons.list,
                      color: Theme.of(context).textTheme.labelLarge!.color,
                      size: _sizeActionIconAnimation!.value)),
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Opzioni',
                onPressed: () {
                  slideKey.currentState?.toggle();
                },
                icon: Icon(
                  Icons.manage_accounts,
                  color: Theme.of(context).textTheme.labelLarge!.color,
                  size: _sizeActionIconAnimation!.value,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Chatbot',
                onPressed: () async {
                  await openChatGPTBot(context);
                },
                icon: Icon(
                  Icons.chat_bubble,
                  color: Theme.of(context).textTheme.labelLarge!.color,
                  size: _sizeActionIconAnimation!.value,
                ),
              ),

              /*       ...List.generate(_scaffoldKeys?[tabController.index].currentState?.openedMenu.length ?? 0, (index) => Text(
                  _scaffoldKeys![tabController.index].currentState!.openedMenu[index].label
              ))*/
            ],
          ),
        ));
  }

  double _getOpacity(context) {
    final TabController tabController = DefaultTabController.of(context)!;
    if (tabController.previousIndex < tabController.index) {
      return (tabController.index - 1 - tabController.animation!.value).abs();
    } else {
      return (tabController.index + 1 - tabController.animation!.value).abs();
    }
  }

  Widget multiTabBarView() {
    return multi_tabbar.TabBarView(
        key: _tabViewKey,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            currentMenu?.subMenus?.length ?? 0,
                (index) =>
            _scaffolds?[index] ??
                Container(
                    color: Colors.red,
                    child:
                    const Center(child: Text("MultiScaffold is null")))));
  }

  Widget multiTabBarViewWithAnimation() {
    return Builder(builder: (context) {
      final TabController tabController = DefaultTabController.of(context)!;

      print('animationValue: ${tabController.animation!.value}');
      print('animationValue/2: ${tabController.animation!.value / 2}');
      double startValue = tabController.animation!.value;
      return AnimatedBuilder(
        animation: tabController.animation!,
        builder: (BuildContext context, snapshot) {
          return Transform.rotate(
              angle: tabController.animation!.value * pi * 2, //?? 0 * pi,
              child: Opacity(
                opacity: _getOpacity(context) > 0 ? 1 : _getOpacity(context),
                child: multi_tabbar.TabBarView(
                    key: _tabViewKey,
                    children: List.generate(
                        currentMenu?.subMenus?.length ?? 0,
                            (index) =>
                        _scaffolds?[index] ??
                            Container(
                                color: Colors.red,
                                child: const Center(
                                    child: Text("MultiScaffold is null"))))),
              ));
        },
      );
    });
  }

  Widget multiTabBar() {
    return multi_tabbar.TabBar(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        labelColor: isDarkTheme(context)
            ? Theme.of(context).textTheme.bodySmall!.color
            : Colors.white,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        isScrollable: MediaQuery.of(context).size.width < 400
            ? true
            : MediaQuery.of(context).size.width < 800
            ? false
            : true,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
        indicatorSize: multi_tabbar.TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkTheme(context)
              ? Theme.of(context).colorScheme.primary.withAlpha(50)
              : Theme.of(context).colorScheme.surface.withAlpha(50),
        ),
        tabs: List.generate(
            currentMenu?.subMenus?.length ?? 0,
                (index) => MediaQuery.of(context).size.width < 800
                ? standardTab(currentMenu!.subMenus![index])
                : multiTab(currentMenu!.subMenus![index])));
  }

  Widget standardTab(Menu menu) {
    double iconSize = MediaQuery.of(context).size.height < tinyHeight ? 16 : 24;

    return MediaQuery.of(context).size.width < midWidth ||
        MediaQuery.of(context).size.height < tinyHeight
        ? Tooltip(
        message: menu.label,
        child: multi_tabbar.Tab(
            icon: Icon(
              icons[menu.icon],
              color: getMenuColor(menu.color),
              size: iconSize,
            )))
        : multi_tabbar.Tab(
        iconMargin: const EdgeInsets.all(0),
        icon: Icon(
          icons[menu.icon],
          color: getMenuColor(menu.color),
          size: 16,
        ),
        text: menu.label);
    //Tooltip(message: 'message', child: MultiTabBar.Tab(icon: Icon(menu.icon, color: menu.color), text: MediaQuery.of(context).size.width < 650 ? null : menu.text));
  }

  Widget multiTab(Menu menu) {
    //var mediaData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minHeight: 80, maxHeight: 80),
      height: 80,
      child: multi_tabbar.Tab(
          child: Semantics(
              child: IntrinsicWidth(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Icon(icons[menu.icon],
                            size: _sizeTabIconAnimation!.value,
                            color: getMenuColor(menu.color)),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                          child: Center(
                              child: Text(
                                menu.label,
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: getCurrentCalcThemeMode(context) == ThemeMode.dark
                                        ? Theme.of(context).textTheme.bodySmall!.color
                                        : Colors.white,
                                    fontSize: _sizeTabTextAnimation!.value),
                                overflow: TextOverflow.ellipsis,
                              )))
                    ],
                  )))),
    );
  }

  Color invertColor(Color color) {
    final r = 255 - color.red;
    final g = 255 - color.green;
    final b = 255 - color.blue;

    return Color.fromARGB((color.opacity * 255).round(), r, g, b);
  }

  void reloadUser() {
    setState(() {
      user = ApplicationUser.getUserFromSetting();
    });
  }
}
