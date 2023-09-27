import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/navigation_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/useful/data_title_helper.dart';
import 'package:dpicenter/screen/widgets/drawer_multi.dart';
import 'package:dpicenter/screen/widgets/slider_drawer_multi/slider_drawer_multi.dart';
import 'package:dpicenter/screen/widgets/title_widget.dart';
import 'package:flutter/material.dart';

import '../../navigation/multi_scaffold_ex.dart';

class MultiNavigationBar extends StatefulWidget {
  const MultiNavigationBar(
      {required this.tabController,
      required this.scaffoldKeys,
      required this.slideKey,
      this.height,
      this.color,
      Key? key})
      : super(key: key);
  final TabController? tabController;
  final List<GlobalKey<MultiScaffoldState>> scaffoldKeys;
  final GlobalKey<SlideDrawerMultiState> slideKey;
  final double? height;
  final Color? color;

  @override
  State<MultiNavigationBar> createState() => MultiNavigationBarState();
}

class MultiNavigationBarState extends State<MultiNavigationBar>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _sizeActionIconAnimation;
  List<Menu> openScreen = <Menu>[];
  int currentIndex = -1;

  void add(Menu menu) {
    setState(() {
      openScreen.add(menu);
      currentIndex = openScreen.indexOf(menu);
    });
  }

  void onMenuSelected(Menu menu) {
    setState(() {
      int index = 0;
      for (Menu menuOpened in openScreen) {
        if (menuOpened == menu) {
          break;
        }
        index++;
      }
      currentIndex = index;
    });
  }

  void remove(Menu menu) {
    setState(() {
      int index = openScreen.indexOf(menu);
      openScreen.remove(menu);
      if (index > 0) {
        index--;
      }
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _sizeActionIconAnimation = Tween<double>(begin: 16.0, end: 24.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.linear))
      ..addListener(() {
        setState(() {
          //print("value changed!!!!!: " + _sizeAnimation!.value.toString());
        });
      });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: widget.color,
      child: Row(
        children: [
          const SizedBox(width: 4),
          actionButtons(widget.tabController),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  openScreen.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TitleWidget(
                      title: openScreen[index].label,
                      direction: isTinyHeight(context)
                          ? Axis.horizontal
                          : Axis.vertical,
                      offline: false,
                      titleFontSize: 12,
                      iconSize: 16,
                      icon: openScreen[index].icon,
                      foregroundColor:
                          openScreen[currentIndex] == openScreen[index]
                              ? Colors.white
                              : Colors.white60,
                      color: openScreen[currentIndex] == openScreen[index]
                          ? getMenuColor(openScreen[index].color)
                          : getMenuColor(openScreen[index].color)?.darken(0.3),
                      titleClick: () async {
                        setState(() {
                          currentIndex = index;
                        });
                        int currentTabIndex =
                            openScreen[index].currentTabIndex ?? 0;
                        if (navigationScreenKey
                                ?.currentState?.tabController?.index !=
                            currentTabIndex) {
                          navigationScreenKey?.currentState?.tabController
                              ?.animateTo(currentTabIndex);
                        }

                        widget.scaffoldKeys[currentTabIndex].currentState
                            ?.setState(() {
                          widget.scaffoldKeys[currentTabIndex].currentState
                              ?.selectMenu(openScreen[index]);
                        });
                      },
                      subTitleFontSize: 8,
                      buttonHeight: 30,
                      onClosePressed: () {
                        ///close selected screen
                        int currentTabIndex =
                            openScreen[index].currentTabIndex ?? 0;
                        if (navigationScreenKey
                                ?.currentState?.tabController?.index !=
                            currentTabIndex) {
                          navigationScreenKey?.currentState?.tabController
                              ?.animateTo(currentTabIndex);
                        }
                        widget.scaffoldKeys[currentTabIndex].currentState
                            ?.setState(() {
                          widget.scaffoldKeys[currentTabIndex].currentState
                              ?.closeMenu(openScreen[index]);
                        });
                      },
                    ),
                  ),
                ).reversed.toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget actionButtons(TabController? tabController) {
    double actionButtonHeight = getActionButtonsHeight(context);
    //double actionButtonIconSize = getActionButtonsIconSize(context);

    ///Menu button
    return Container(
        height: actionButtonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 350),
          alignment: Alignment.centerLeft,
          child: Material(
            clipBehavior: Clip.antiAlias,
            color: isDarkTheme(context)
                ? Color.alphaBlend(
                    Theme.of(context).colorScheme.background.withAlpha(220),
                    Theme.of(context).colorScheme.primary)
                : Color.alphaBlend(
                    Theme.of(context).colorScheme.background.withAlpha(220),
                    Theme.of(context).colorScheme.primary),
            //Color.alphaBlend(Theme.of(context).colorScheme.background.withAlpha(240), Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(20),
            elevation: 0,
            child: Row(
              children: [
                if (openScreen.isNotEmpty)
                  IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: 'Chiude la finestra aperta',
                      onPressed: () async {
                        ///close current screen

                        int currentTabIndex =
                            openScreen[currentIndex].currentTabIndex ?? 0;
                        if (navigationScreenKey
                                ?.currentState?.tabController?.index !=
                            currentTabIndex) {
                          navigationScreenKey?.currentState?.tabController
                              ?.animateTo(currentTabIndex);
                        }

                        widget.scaffoldKeys[currentTabIndex].currentState
                            ?.setState(() {
                          widget.scaffoldKeys[currentTabIndex].currentState
                              ?.closeMenu(openScreen[currentIndex]);
                        });
                      },
                      icon: Icon(Icons.arrow_back,
                          color: isDarkTheme(context)
                              ? Colors.white70
                              : Colors.black87,
                          size: _sizeActionIconAnimation!.value)),
                IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: 'Visualizza\\Nasconde menu',
                    onPressed: () async {
                      await widget
                          .scaffoldKeys[widget.tabController?.index ?? 0]
                          .currentState
                          ?.toggle();
                    },
                    icon: Icon(Icons.list,
                        color: isDarkTheme(context)
                            ? Colors.white70
                            : Colors.black87,
                        size: _sizeActionIconAnimation!.value)),
                IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Opzioni',
                  onPressed: () {
                    widget.slideKey.currentState?.toggle();
                  },
                  icon: Icon(
                    Icons.manage_accounts,
                    color:
                    isDarkTheme(context) ? Colors.white70 : Colors.black87,
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
                    color: Theme
                        .of(context)
                        .textTheme
                        .labelLarge!
                        .color,
                    size: _sizeActionIconAnimation!.value,
                  ),
                ),
                /*       ...List.generate(_scaffoldKeys?[tabController.index].currentState?.openedMenu.length ?? 0, (index) => Text(
                    _scaffoldKeys![tabController.index].currentState!.openedMenu[index].label
                ))*/
              ],
            ),
          ),
        ));
  }
}
