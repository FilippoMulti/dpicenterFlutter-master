import 'package:animations/animations.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/navigation_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/main.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_reminder.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/widgets/animated_indexed_stack/animated_indexed_stack.dart';
import 'package:dpicenter/screen/widgets/dashboard/reportstat_container.dart';
import 'package:dpicenter/screen/widgets/dashboard/dashboard_navigator.dart';
import 'package:dpicenter/screen/widgets/drawer_item/drawer_item.dart';
import 'package:dpicenter/screen/widgets/drawer_multi.dart';
import 'package:dpicenter/screen/widgets/fade_indexed_stack/fade_indexed_stack.dart';
import 'package:dpicenter/screen/widgets/navigation_bar/navigation_bar.dart';
import 'package:dpicenter/screen/widgets/postioned_container.dart';
import 'package:dpicenter/screen/widgets/resizable_widget/resizable_container.dart';
import 'package:dpicenter/screen/widgets/resizable_widget/resizable_widget_controller.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class MultiScaffold extends StatefulWidget {
  const MultiScaffold(
      {Key? key,
      required this.menu,
      required this.isDashboard,

      ///quando cambia il menu visualizzato
      this.onMenuChanged,
      this.onMenuOpen,
      this.onMenuClose,
      this.onMenuRemove,
      this.navigationBar})
      : super(key: key);

  final bool isDashboard;
  final Menu menu;
  final Function(Menu menu)? onMenuClose;
  final Function(Menu menu)? onMenuChanged;
  final Function(Menu menu)? onMenuRemove;
  final Function(Menu menu)? onMenuOpen;
  final Widget? navigationBar;

  @override
  MultiScaffoldState createState() => MultiScaffoldState();
}

class MultiScaffoldState extends State<MultiScaffold>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController =
      ScrollController(debugLabel: 'scrollControllerDashboard');
  List<Menu> destinationsMenu = <Menu>[];
  final List<Menu> openedMenu = <Menu>[];

  ValueNotifier<bool> get isDrawerOpen =>
      ValueNotifier(_sliderKey.currentState?.isDrawerOpen ?? false);

  double menuOpenSize = 160;
  Menu? selectedItem;
  Menu? _lastMenuClosed;
  Menu? hoverItem;
  int _currentIndex = 0;

  String searchMenuValue = "";

  final TextEditingController _searchController = TextEditingController();

  //GlobalKey containerKey = GlobalKey();
  Menu? selectedMenu;
  final Map<Menu, GlobalKey> _containerKey = <Menu, GlobalKey>{};

  final ScrollController scrollController =
      ScrollController(debugLabel: 'multiScaffoldScrollController');
  final ScrollController gridViewScrollController =
      ScrollController(debugLabel: 'multiScaffoldGridViewScrollController');
  final GlobalKey<SliderMenuContainerExState> _sliderKey =
      GlobalKey<SliderMenuContainerExState>();

  static MultiScaffoldState of(BuildContext context) {
    final MultiScaffoldState? result =
        context.findAncestorStateOfType<MultiScaffoldState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'DataScreenState.of() called with a context that does not contain a Scaffold.',
      ),
      ErrorDescription(
        'No DataScreenState ancestor could be found starting from the context that was passed to DataScreenState.of(). '
            'This usually happens when the context provided is from the same StatefulWidget as that '
            'whose build function actually creates the Scaffold widget being sought.',
      ),
      ErrorHint(
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
            'context that is "under" the DataScreenState. For an example of this, please see the '
            'documentation for Scaffold.of():\n'
            '  https://api.flutter.dev/flutter/material/Scaffold/of.html',
      ),
      ErrorHint(
        'A more efficient solution is to split your build function into several widgets. This '
            'introduces a new context from which you can obtain the DataScreenState. In this solution, '
            'you would have an outer widget that creates the DataScreenState populated by instances of '
            'your new inner widgets, and then in these inner widgets you would use DataScreenState.of().\n'
            'A less elegant but more expedient solution is assign a GlobalKey to the DataScreenState, '
            'then use the key.currentState property to obtain the ScaffoldState rather than '
            'using the DataScreenState.of() function.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  toggle() {
    setState(() {
      _sliderKey.currentState?.toggle();
    });
  }

  @override
  void initState() {
    super.initState();
    for (var itemMenu in widget.menu.subMenus!) {
      if (itemMenu.destination != null) {
        destinationsMenu.add(itemMenu);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return contentPage();
  }

  ///da utilizzare per generare il menu dai submenus
  Widget getMenu(Menu menu, ScrollController scrollController) {
    //rimuovo i menu disabilitati
    menu = menu.copyWith(
        subMenus: menu.subMenus
            ?.where((element) =>
        element.command == null &&
                element.status != null &&
            element.status != 0 &&
            (searchMenuValue.isEmpty
                ? true
                : element.label.toLowerCase().contains(searchMenuValue)))
            .toList(growable: false));
    return Container(
        //padding: const EdgeInsets.symmetric(vertical: 0),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
            color: isDarkTheme(context)
                ? Color.alphaBlend(
                    Theme.of(context).colorScheme.surface.withAlpha(240),
                    Theme.of(context).colorScheme.primary)
                : Theme.of(context).colorScheme.surface),
        child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Column(children: [
                if (widget.isDashboard)
                  Container(
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                          controller: _searchController,
                          onChanged: (newValue) {
                            setState(() {
                              _searchTextChanged(newValue);
                            });
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.black.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Cerca...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.zero,
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          _searchTextChanged("");
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        size: 16,
                                      ),
                                    )
                                  : null))),
                ...List.generate(
                    menu.subMenus!.length,
                    (index) => DrawerItem(
                          isOpen: openedMenu.contains(menu.subMenus![index]),
                          menu: menu.subMenus![index],
                          onPressed: (menu) {
                            if (isWebMobileA) {
                              Navigator.pushNamed(context, menu.destination!,
                                  arguments: menu);
                            } else {
                              setState(() {
                                selectMenu(menu);
                                //selectedMenu = menu;
                              });
                            }
                          },
                          onClosePressed: (menu) {
                            setState(() {
                              closeMenu(menu);
                            });
                          },
                        )
                    /*contentPageDrawerItem(menu.subMenus![index],
                        isOpen: openedMenu.contains(menu.subMenus![index]))*/
                    )
              ]),
            )));
  }

  void _searchTextChanged(String newValue) {
    searchMenuValue = newValue;
    if (newValue.isNotEmpty) {
      _sliderKey.currentState?.sliderMenuOpenSize = 320;
      menuOpenSize = 320;
    } else {
      _sliderKey.currentState?.sliderMenuOpenSize = 160;
      menuOpenSize = 160;
    }
  }

  ///item del menu
/*  Widget contentPageDrawerItem(Menu menu, {bool isOpen = false}) {
    return Center(
        child: SizedBox(
            height: 120,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: MaterialButton(
                    hoverElevation: 0,
                    elevation: 0,
                    hoverColor: isLightTheme(context)
                        ? Color.alphaBlend(
                            Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withAlpha(180),
                        Theme.of(context).colorScheme.primary)
                        : Color.alphaBlend(
                        Theme.of(context).canvasColor.withAlpha(100),
                        Theme.of(context).colorScheme.primary)
                        .withAlpha(100),
                    color: isDarkTheme(context)
                        ? Color.alphaBlend(
                        Theme.of(context)
                            .colorScheme
                            .surface
                            .withAlpha(240),
                        Theme.of(context).colorScheme.primary)
                        : Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    //side: BorderSide(color: Color.fromARGB(255, 197, 197, 246), width: 0.1)

                    onPressed: () {
                      if (isWebMobileA) {
                        Navigator.pushNamed(context, menu.destination!,
                            arguments: menu);
                      } else {
                        setState(() {
                          selectMenu(menu);
                          //selectedMenu = menu;
                        });
                      }
                      */ /*   setState(() {
                        //selectedMenu = menu;
                        selectMenu(menu);
                      });*/ /*
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                padding: isOpen
                                    ? const EdgeInsets.all(5)
                                    : const EdgeInsets.all(0),
                                //margin: isOpen ? const EdgeInsets.all(5) : null,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    //border: isOpen ? Border.all(color: Colors.greenAccent, width: 5) : null,
                                    //color: getMenuColor(menu.color)
                                    gradient: LinearGradient(
                                      colors: [
                                        getMenuColor(menu.color)!,
                                        Theme.of(context).colorScheme.primary
                                      ],
                                      tileMode: TileMode.decal,
                                    )),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //border: isOpen ? Border.all(color: Colors.greenAccent, width: 5) : null,
                                      color: getMenuColor(menu.color)),
                                  child: Icon(
                                    icons[menu.icon],
                                    color: (getMenuColor(menu.color) as Color)
                                                .computeLuminance() >
                                            0.5
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ))),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text(
                            menu.label,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ],
                    )))));
  }*/

  final GlobalKey _pageTransitionKey =
      GlobalKey(debugLabel: '_pageTransitionKey');

  Widget contentPage() {
    List<Widget> children = <Widget>[];
    Menu menu = widget.menu.copyWith(
        subMenus: widget.menu.subMenus
            ?.where((element) => element.status != null && element.status != 0)
            .toList(growable: false));

    ///creo le chiavi se non esistono
    for (Menu menu in menu.subMenus!) {
      if (!_containerKey.containsKey(menu)) {
        _containerKey
            .addAll({menu: GlobalKey(debugLabel: menu.menuId.toString())});
      }
    }

    ///creo i widgets
    children = List.generate(
        _containerKey.length,
        (index) => !openedMenu.contains(_containerKey.keys.elementAt(index)) &&
                _lastMenuClosed != _containerKey.keys.elementAt(index)
            ? Container(
                key: _containerKey.values.elementAt(index),
                clipBehavior: isDarkTheme(context) ? Clip.antiAlias : Clip.none,
                decoration: isDarkTheme(context)
                    ? BoxDecoration(
                        borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            color: getScaffoldBackgroundColor(),
          )
              : null,
          // key: ValueKey(widget.menu.menuId),
          child: Center(
              child: SizedBox(child: Text("Index: ${index.toString()}"))),
        )
            :

        Container(
            key: _containerKey.values.elementAt(index),
            clipBehavior: isDarkTheme(context) ? Clip.antiAlias : Clip.none,
            decoration: isDarkTheme(context)
                ? BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              color: getScaffoldBackgroundColor(),
            )
                : null,
                // key: ValueKey(widget.menu.menuId),
                child: _buildGridTileContent(
                    _containerKey.keys.elementAt(index))));
    children.insert(
      0,
      Container(
          clipBehavior: isDarkTheme(context) ? Clip.antiAlias : Clip.none,
          decoration: isDarkTheme(context)
              ? BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: getScaffoldBackgroundColor(),
                )
              : BoxDecoration(color: getScaffoldBackgroundColor()),
          key: ValueKey(widget.menu.menuId),
          child: widget.isDashboard
              ? MultiBlocProvider(
                  //key: _reportStatBlocKey,
                  providers: [
                    BlocProvider<ServerDataBloc<Machine>>(
                        //lazy: false,
                        create: (context) => ServerDataBloc<Machine>(
                            repo: MultiService<Machine>(Machine.fromJsonModel,
                                apiName: 'VMMachine')),
                      ),
                    ],
                  child:
                      const DashboardNavigator() /*LayoutBuilder(builder: (context, constraints) {
          return getResizableContainer(ReportStat(), "reportStat",
              maxWidth ?? constraints.maxWidth, maxHeight ?? constraints.maxHeight);
        })*/
                  )

              /*DashboardContainer(
                  //    key: ValueKey(widget.menu.menuId),
                  favoritesMenu: widget.menu.subMenus!,
                  onFavoriteMenuTap: (menu) {
                    if (menu.destination != null) {
                      if (isWebMobileA) {
                        Navigator.pushNamed(context, menu.destination!,
                            arguments: menu);
                      } else {
                        setState(() {
                          selectMenu(menu);
                          //selectedMenu = menu;
                        });
                      }
                      */ /*  setState(() {
                        selectMenu(menu);

                        //selectedMenu = menu;
                      });*/ /*
                    } else {
                      menu.command?.call();
                    }
                  },
                )*/
              //_buildGrid(widget.menu)
              : _buildGrid(widget.menu)),
    );

    return SliderMenuContainerEx(
      sliderMenuOpenSize: menuOpenSize,
      //animationDuration: 500,
      appBarHeight: 0,
      hasAppBar: false,
      appBarColor: Colors.white,
      key: _sliderKey,
      menuInitialState: widget.isDashboard && !isTinyWidth(context)
          ? MenuState.opened
          : MenuState.closed,
      //menuInitialState: isTinyWidth(context) ? MenuState.closed : MenuState.opened,
      sliderMenu: AnimatedOpacity(
          opacity: isDrawerOpen.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 350),
          child: getMenu(widget.menu, scrollController)),
      sliderMain: Column(
        children: [
          if (widget.navigationBar != null) widget.navigationBar!,
          Expanded(
            child: AnimatedIndexedStack(
              key: ValueKey(widget.menu.menuId.toString() ?? 'no'),
              duration: const Duration(milliseconds: 200),
              index: _currentIndex,
              /*transitionBuilder: (Widget child, Animation<double> primaryAnimation, Animation<double> secondaryAnimation) {

                    return SharedAxisTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.scaled,
                      child: child,
                    );
                  },*/

              children: children,
              /*   [
                    Container(
                        clipBehavior: isDarkTheme(context) ? Clip.antiAlias : Clip.none,
                        decoration: isDarkTheme(context)
                            ? BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: getScaffoldBackgroundColor(),
                        )
                            : BoxDecoration(color: getScaffoldBackgroundColor()),
                        key: ValueKey(widget.menu.menuId),
                        child: widget.isDashboard
                            ? DashboardContainer(
                          //    key: ValueKey(widget.menu.menuId),
                          favoritesMenu: widget.menu.subMenus!,
                          onFavoriteMenuTap: (menu) {
                            if (menu.destination != null) {
                              setState(() {
                                selectMenu(menu);
                                //selectedMenu = menu;
                              });
                            } else {
                              menu.command?.call();
                            }
                          },
                        )
                        //_buildGrid(widget.menu)
                            : _buildGrid(widget.menu)),


                    if (openedMenu.isNotEmpty)
                      ...List.generate(
                          openedMenu.length,
                              (index) => Container(
                                  key: _containerKey[openedMenu[index]],
                              clipBehavior:
                              isDarkTheme(context) ? Clip.antiAlias : Clip.none,
                              decoration: isDarkTheme(context)
                                  ? BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: getScaffoldBackgroundColor(),
                              )
                                  : null,
                              // key: ValueKey(widget.menu.menuId),
                              child: _buildGridTileContent(openedMenu[index])))
                    */ /*if (selectedMenu != null)
                    Container(
                        clipBehavior:
                            isDarkTheme(context) ? Clip.antiAlias : Clip.none,
                        decoration: isDarkTheme(context)
                            ? BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: getScaffoldBackgroundColor(),
                              )
                            : null,
                        // key: ValueKey(widget.menu.menuId),
                        child: _buildGridTileContent(selectedMenu!))*/ /*
                  ],
*/
            ),
          ),
        ],
      ),

      /*selectedMenu != null
            ? Container(
            clipBehavior: isDarkTheme(context) ? Clip.antiAlias : Clip.none,
                decoration: isDarkTheme(context)
                    ? BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: getScaffoldBackgroundColor(),
                      )
                    : null,
                key: ValueKey(widget.menu.menuId),
                child: _buildGridTileContent(selectedMenu!))
            : Container(
            clipBehavior: isDarkTheme(context) ? Clip.antiAlias : Clip.none,
                decoration: isDarkTheme(context)
                    ? BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: getScaffoldBackgroundColor(),
                      )
                    : BoxDecoration(color: getScaffoldBackgroundColor()),
                key: ValueKey(widget.menu.menuId),
                child: widget.isDashboard
                    ?
                    DashboardContainer(
                      key: ValueKey(widget.menu.menuId),
                      favoritesMenu: widget.menu.subMenus!,
                    onFavoriteMenuTap: (menu){
                      if (menu.destination != null) {
                        setState(() {
                          selectedMenu = menu;
                        });
                      } else {
                        menu.command?.call();
                      }
                    },)
                    //_buildGrid(widget.menu)

                    : _buildGrid(widget.menu))*/
    );
    /*selectedMenu != null
      ? Builder(
        builder: (BuildContext context) {
      //_sliderKey.currentState!.openDrawer();
      return _buildGridTileContent(_selectedMenu![index]!,
          index); //getMenuContent(menu);// getMenuContent(selectedMenu!);
    },
    )
        : Container(
    color: getScaffoldBackgroundColor(),
    child:///TODO: trovare un modo migliore per definire la chiave,
    ///in questa maniera se la lista cambia ma mantiene lo stesso numero di elementi l'animazione non viene eseguita
    _buildGrid(currentMenu!.subMenus![index],
    currentMenu!.subMenus!.length.toString(), index)); //getMenuContent(menu);// getMenuContent(selectedMenu!);
    },
    );*/
  }

  Color getScaffoldBackgroundColor() {
    return isDarkTheme(context)
        ? Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(230),
        Theme.of(context).colorScheme.primary)
        : Color.alphaBlend(
        Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
        Theme.of(context).colorScheme.primary);
  }

  Widget _buildGridTileContent(Menu menu) {
    /*return Container(
        key: _containerKey[menu],
        color: getScaffoldBackgroundColor(),
        child: List.generate(1, (int i) {
          return AnimationConfiguration.synchronized(
            key: ValueKey(menu.menuId),
            duration: const Duration(milliseconds: 800),
            child: ScaleAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                    curve: Curves.linear, child: getMenuContent(menu))),
          );
        }).first);*/

    return Container(
        color: getScaffoldBackgroundColor(), child: getMenuContent(menu));
  }

  Widget _buildGridTileContent2(Menu menu) {
    return Container(
      //key: _containerKey,
        color: getScaffoldBackgroundColor(),
        child: getMenuContent(menu));
  }

  Widget getMenuContent(Menu menu, {bool withBackButton = true}) {
    ///è una destinazione
    if (menu.destination != null) {
      /*  Widget? screen;
      if (openedMenu.containsKey(menu)){
        screen = openedMenu[menu];
        openedMenu.remove(menu);
        openedMenu.addAll({menu:screen!});
      } else {
        screen =
            DpiCenterApp.of(context)!.getScreen(menu.destination!, menu, () {
              setState(() {
                ///rivisualizzo il menu
                selectedMenu = null;
              });
            }, context, withBackButton);
        openedMenu.addAll({menu : screen});
      }*/
      Widget screen =
          DpiCenterApp.of(context)!.getScreen(menu.destination!, menu, () {
        setState(() {
          ///rivisualizzo il menu
          closeMenu(menu);
          //selectedMenu = null;
        });
      }, context, withBackButton);
      //Display Main Screen
      return Container(
        clipBehavior: isDarkTheme(context) ? Clip.antiAlias : Clip.none,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: screen,
      );
    }

    return Container(
        color: Colors.red,
        child: Center(
            child: Text(
              "Comando non ancora implementato\r\n:(",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        )));
  }

  void selectMenu(Menu menu) {
    ///fireEvent: solo se il menu non era ancora inserito
    bool fireOpenEvent = false;
    if (!openedMenu.contains(menu)) {
      fireOpenEvent = true;
    }
    closeMenu(menu, fireEvent: false);
    selectedMenu = menu;
    Menu elabMenu = widget.menu.copyWith(
        subMenus: widget.menu.subMenus
            ?.where((element) => element.status != null && element.status != 0)
            .toList(growable: false));

    for (int index = 0; index < elabMenu.subMenus!.length; index++) {
      if (elabMenu.subMenus![index].menuId == menu.menuId) {
        _currentIndex = index + 1;
        break;
      }
    }

    /*GlobalKey? globalKey;

    if (!_containerKey.containsKey(menu)) {
      globalKey = GlobalKey(debugLabel: "${menu.menuId}");
      _containerKey.addAll({menu : globalKey});
    } else {
      ///per mantenere l'ordine giusto
      GlobalKey tempKey = _containerKey[menu]!;
      _containerKey.removeWhere((key, value) => key == menu);
      _containerKey.addAll({menu : tempKey});
    }*/
    if (isWebMobileA) {
      openedMenu.clear();
    }
    menu = menu.copyWith(
        currentTabIndex:
            navigationScreenKey?.currentState?.tabController?.index ?? 0);
    openedMenu.add(menu);
    if (fireOpenEvent) {
      widget.onMenuOpen?.call(menu);
    }
    widget.onMenuChanged?.call(menu);
  }

  void closeMenu(Menu menu, {bool fireEvent = true}) {
    if (openedMenu.contains(menu)) {
      selectedMenu = null;
      _lastMenuClosed = menu;
      openedMenu.remove(menu);
      if (fireEvent) {
        widget.onMenuClose?.call(menu);
      }
    }

    Menu allMenu = cleanMenu(widget.menu);

    if (openedMenu.isNotEmpty) {
      _currentIndex = allMenu.subMenus!.indexOf(allMenu.subMenus!
              .firstWhere((element) => openedMenu.last == element)) +
          1;
    } else {
      _currentIndex = 0;
    }
    if (fireEvent) {
      if (_currentIndex - 1 > 0) {
        widget.onMenuChanged?.call(allMenu.subMenus![_currentIndex - 1]);
      }
    }
  }

  Menu cleanMenu(Menu menu) {
    return menu.copyWith(
        subMenus: menu.subMenus
            ?.where((element) => element.status != null && element.status != 0)
            .toList(growable: false));
  }

  ///main screen
  Widget _buildGrid(Menu menu) {
    int crossAxisCount = getCrossAxisCount(context);
    menu = cleanMenu(menu);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: AnimationLimiter(
          key: ValueKey(menu.subMenus!.length.toString()),
          child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: crossAxisCount,
              // Generate 100 widgets that display their index in the List.
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              childAspectRatio: (1 / .28),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              controller: gridViewScrollController,
              children: _buildGridTileList(menu, crossAxisCount))),
    );
  }

  List<Widget> _buildGridTileList(Menu menu, int crossAxisCount) {
    //var result = getIconAndFontSize(context);
    double iconSize = 24; //result[0];
    double fontSize = getFontSize(context);

    return List.generate(menu.subMenus!.length, (int i) {
      return AnimationConfiguration.staggeredGrid(
        position: i,
        columnCount: crossAxisCount,
        duration: const Duration(milliseconds: 375),
        child: ScaleAnimation(
          child: FadeInAnimation(
              child: getListItem(menu.subMenus![i], fontSize, iconSize)),
        ),
      );
    });
  }

  Color getBorderMenuColor(Menu menu) {
    return isDarkTheme(context)
        ? getMenuColor(menu.color)!.lighten(0.2)
        : getMenuColor(menu.color)!.darken(0.2);
  }

  ///Restituisce l'item da visualizzare e definisce il callback della selezione in base al tipo di menu
  Widget getListItem(Menu menu, double fontSize, double iconSize) {
    return Builder(builder: (context) {
      return Hero(
        tag: '${menu.label}Hero',
        child: Material(
            type: MaterialType.transparency,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: getMenuColor(menu.color),
                  side: BorderSide(color: getBorderMenuColor(menu), width: 1)
                  /*shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))*/
                  ),
              onPressed: () {
                if (menu.destination != null) {
                  if (isWebMobileA) {
                    Navigator.pushNamed(context, menu.destination!,
                        arguments: menu);
                  } else {
                    setState(() {
                      selectMenu(menu);
                      //selectedMenu = menu;
                    });
                  }
                } else {
                  menu.command?.call();
                }
                //openContainer.call();
                //_menuClick(menu);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icons[menu.icon],
                      size: iconSize,

                      ///per ora sempre white
                      color: getCurrentCalcThemeMode(context) == ThemeMode.light
                          ? Colors.white
                          : Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: Text(
                      menu.label,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white.withAlpha(240)),
                    )
                        /*getStrokedText(
                        menu.label,
                        */ /*style: Theme.of(context).textTheme.headline6!.copyWith(*/ /*
                        fontSize: fontSize,
                        letterSpacing: 1.5,
                        strokeWidth: 2,
                        */ /*  wordSpacing: 0,*/ /*
                        overflow: TextOverflow.clip,

                        ///per ora sempre white
                        textColor:
                            getCurrentCalcThemeMode(context) == ThemeMode.light
                                ? Colors.white
                                : Colors.white,
                        strokeColor: getBorderMenuColor(menu).darken(0.3),

                        alignment: Alignment.center,
                        */ /*),*/ /*
                        textAlign: TextAlign.center,
                      ),*/
                        ),
                  ]),
            )),
      );
    });
  }

  Widget _buildDashboardGrid2(Menu menu) {
    int crossAxisCount = getCrossAxisCount(context);

    /*List<Menu> destinationsMenu = <Menu>[];
    for (var itemMenu in menu.subMenus!){
      if (itemMenu.destination!=null){
        destinationsMenu.add(itemMenu);
      }
    }*/

    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: destinationsMenu.length * 100,
        child: Stack(
          key: ValueKey(menu.menuId),
          fit: StackFit.expand,
          children: [
            ...List.generate(
                destinationsMenu.length, (index) => getDashboardItem3(index)),
            //if (selectedItem!=null) getDashboardItem2(selectedItem!, 0, 0, 300, 300),
          ],
        ),
      ),
    );

    /*AnimationLimiter(

        child: GridView.count(
            key: ValueKey(menu.id),
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 3,
            // Generate 100 widgets that display their index in the List.
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            //childAspectRatio: 1.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            controller: gridViewScrollController,
            children: _buildDashboardGridTileList(menu, crossAxisCount)));*/
  }

  Widget _buildDashboardGrid(Menu menu) {
    int crossAxisCount = getCrossAxisCount(context);

    return AnimationLimiter(
        child: GridView.count(
            key: ValueKey(menu.menuId),
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 3,
            // Generate 100 widgets that display their index in the List.
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            //childAspectRatio: 1.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            controller: gridViewScrollController,
            children: _buildDashboardGridTileList(menu, crossAxisCount)));
  }

  List<Widget> _buildDashboardGridTileList(Menu menu, int crossAxisCount) {
    //var result = getIconAndFontSize(context);
    double iconSize = 24; //result[0];
    double fontSize = 18; //result[1];

    List<Menu> destinationsMenu = <Menu>[];
    for (var itemMenu in menu.subMenus!) {
      if (itemMenu.destination != null) {
        destinationsMenu.add(itemMenu);
      }
    }
    return List.generate(destinationsMenu.length, (int i) {
      return AnimationConfiguration.staggeredGrid(
        key: ValueKey(destinationsMenu[i].menuId),
        position: i,
        columnCount: 2,
        duration: const Duration(milliseconds: 375),
        child: ScaleAnimation(
          child: FadeInAnimation(
              child: getDashboardItem(destinationsMenu[i], fontSize, iconSize)),
        ),
      );
    });
  }

  ///Restituisce l'item da visualizzare e definisce il callback della selezione in base al tipo di menu
  Widget getDashboardItem(Menu menu, double fontSize, double iconSize) {
    return Container(
        key: ValueKey(menu.menuId),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            getMenuContent(menu, withBackButton: false),
            Positioned(
                right: 8,
                top: 8,
                child: Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(4),
                      clipBehavior: Clip.antiAlias,
                      color: isDarkTheme(context)
                          ? null
                          : Color.alphaBlend(Colors.green.withAlpha(100),
                          Theme.of(context).colorScheme.primary),
                      type: isDarkTheme(context)
                          ? MaterialType.transparency
                          : MaterialType.button,
                      child: OutlinedButton(
                          onPressed: () {
                            /*setState(() {
                              selectMenu(menu);
                              //selectedMenu = menu;
                            });*/
                            if (isWebMobileA) {
                              Navigator.pushNamed(context, menu.destination!,
                                  arguments: menu);
                            } else {
                              setState(() {
                                selectMenu(menu);
                                //selectedMenu = menu;
                              });
                            }
                          },
                          child: Text("Apri",
                              style: TextStyle(
                                  color: Color.alphaBlend(
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withAlpha(50),
                                      Colors.white)))),
                    ),
                    Material(
                        type: MaterialType.transparency,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.menu.subMenus?.remove(menu);
                              });
                            },
                            color: Theme.of(context).errorColor,
                            icon: const Icon(Icons.close))),
                  ],
                ))
          ],
        ));
/*    return Builder(builder: (context) {
      return Material(
          type: MaterialType.transparency,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: getMenuColor(menu.color),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              if (menu.destination != null) {
                setState(() {
                  selectedMenu = menu;
                });
              } else {
                menu.command?.call();
              }
              //openContainer.call();
              //_menuClick(menu);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    menu.icon,
                    size: iconSize,

                    ///per ora sempre white
                    color: getCurrentCalcThemeMode(context) == ThemeMode.light
                        ? Colors.white
                        : Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      "Dashboard " +
                      menu.text,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        overflow: TextOverflow.clip,

                        ///per ora sempre white
                        color: getCurrentCalcThemeMode(context) ==
                            ThemeMode.light
                            ? Colors.white
                            : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
          ));
    });*/
  }

  List<ResizableWidgetController> controllers = <ResizableWidgetController>[];

  Widget getDashboardItem3(int index) {
    Menu lmenu = destinationsMenu[index];

    return ResizableContainer(
        tag: lmenu.menuId.toString(),
        usePoints: false,
        key: ValueKey(lmenu.menuId),
        areaWidth: Get.width,
        areaHeight: Get.height,
        offset: Offset(index * 10, index * 10),
        width: lmenu.width ?? 300,
        height: lmenu.height ?? 300,
        child: Container(
          width: lmenu.width ?? 300,
          height: lmenu.height ?? 300,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          foregroundDecoration: BoxDecoration(
              border: Border.all(
                  color: lmenu.menuId != (selectedItem?.menuId ?? -1)
                      ? Theme.of(context).colorScheme.primary
                      : Color.alphaBlend(Colors.yellow.withAlpha(150),
                      Theme.of(context).colorScheme.primary),
                  width: lmenu.menuId != (selectedItem?.menuId ?? -1) ? 1 : 2),
              borderRadius: BorderRadius.circular(20),
              color: lmenu.menuId == (hoverItem?.menuId ?? -1)
                  ? Colors.yellow.withAlpha(100)
                  : null),
          child: Stack(
            children: [
              IgnorePointer(
                  ignoring: true,
                  child: getMenuContent(lmenu, withBackButton: false)),
              Positioned(
                  right: 8,
                  top: 8,
                  child: Row(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(4),
                        clipBehavior: Clip.antiAlias,
                        color: isDarkTheme(context)
                            ? null
                            : Color.alphaBlend(Colors.green.withAlpha(100),
                            Theme.of(context).colorScheme.primary),
                        type: isDarkTheme(context)
                            ? MaterialType.transparency
                            : MaterialType.button,
                        child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                destinationsMenu[index] =
                                    lmenu.copyWith(width: 500);
                                //selectedMenu = lmenu;
                              });
                            },
                            child: Text("Apri",
                                style: TextStyle(
                                    color: Color.alphaBlend(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withAlpha(50),
                                        Colors.white)))),
                      ),
                      Material(
                          type: MaterialType.transparency,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: IconButton(
                              onPressed: () {
                                destinationsMenu.remove(lmenu);
                                widget.onMenuRemove?.call(lmenu);
                              },
                              color: Theme.of(context).colorScheme.error,
                              icon: const Icon(Icons.close))),
                    ],
                  ))
            ],
          ),
        ));
  }

  Widget getDashboardItem2(int index) {
    Menu menu = destinationsMenu[index];

    return PositionedContainer(
      key: ValueKey(menu.menuId),
      onPanEnd: (details) {
        debugPrint("onPanEnd");
        destinationsMenu[index] =
            destinationsMenu[index].copyWith(left: details.dx, top: details.dy);
      },
      onSelected: () {
        setState(() {
          selectedItem = menu;
          if (selectedItem != null) {
            destinationsMenu.removeWhere(
                    (element) => element.menuId == selectedItem!.menuId);
            destinationsMenu.add(selectedItem!);
          }
        });
      },
      onHoverStart: () {
        if (hoverItem == null) {
          setState(() {
            hoverItem = menu;
          });
        }
      },
      onHoverEnd: () {
        debugPrint("hoverItem end hoverItem is null? ${hoverItem == null}");

        if (hoverItem != null) {
          setState(() {
            hoverItem = null;
          });
        }
      },
      offset: Offset(
          destinationsMenu[index].left ?? 0, destinationsMenu[index].top ?? 0),
      child: Container(
        width: destinationsMenu[index].width ?? 300,
        height: destinationsMenu[index].height ?? 300,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        foregroundDecoration: BoxDecoration(
            border: Border.all(
                color: destinationsMenu[index].menuId !=
                    (selectedItem?.menuId ?? -1)
                    ? Theme.of(context).colorScheme.primary
                    : Color.alphaBlend(Colors.yellow.withAlpha(150),
                    Theme.of(context).colorScheme.primary),
                width: destinationsMenu[index].menuId !=
                    (selectedItem?.menuId ?? -1)
                    ? 1
                    : 2),
            borderRadius: BorderRadius.circular(20),
            color: destinationsMenu[index].menuId == (hoverItem?.menuId ?? -1)
                ? Colors.yellow.withAlpha(100)
                : null),
        child: Stack(
          children: [
            IgnorePointer(
                ignoring: false,
                child: getMenuContent(menu, withBackButton: false)),
            Positioned(
                right: 8,
                top: 8,
                child: Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(4),
                      clipBehavior: Clip.antiAlias,
                      color: isDarkTheme(context)
                          ? null
                          : Color.alphaBlend(Colors.green.withAlpha(100),
                          Theme.of(context).colorScheme.primary),
                      type: isDarkTheme(context)
                          ? MaterialType.transparency
                          : MaterialType.button,
                      child: OutlinedButton(
                          onPressed: () {
                            if (isWebMobileA) {
                              Navigator.pushNamed(context, menu.destination!,
                                  arguments: menu);
                            } else {
                              setState(() {
                                selectMenu(menu);
                                //selectedMenu = menu;
                              });
                            }
                            /*                         setState(() {
                              selectMenu(menu);
                              //selectedMenu = menu;
                            });*/
                          },
                          child: Text("Apri",
                              style: TextStyle(
                                  color: Color.alphaBlend(
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withAlpha(50),
                                      Colors.white)))),
                    ),
                    Material(
                        type: MaterialType.transparency,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                            onPressed: () {
                              destinationsMenu.remove(menu);
                              widget.onMenuRemove?.call(menu);
                            },
                            color: Theme.of(context).colorScheme.error,
                            icon: const Icon(Icons.close))),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  bool get isWebMobileA =>
      isWebMobile ||
      MediaQuery.of(context).size.width < 400; // per test: isWindows;

  /* Widget getListItem2(Menu menu, double fontSize, double iconSize){
    return OpenContainer(
      transitionDuration: Duration(seconds: 2),
      useRootNavigator: true,
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        if (selectedMenu!=null) {
          return _buildGridTileContent2(selectedMenu!);
        } else {
          return const SizedBox();
        }
      },
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      closedColor: Theme.of(context).colorScheme.secondary,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return getListItem(menu, fontSize, iconSize, openContainer);

        */ /*return SizedBox(
          height: _fabDimension,
          width: _fabDimension,
          child: Center(
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        );*/ /*
      },
    );
  }
*/

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
