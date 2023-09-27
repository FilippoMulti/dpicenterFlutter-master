import 'dart:ui';

import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/navigation_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select.dart';
import 'package:dpicenter/screen/widgets/dashboard/reports_stat.dart';
import 'package:dpicenter/screen/widgets/multi_text_animation/text_clock_animation.dart';
import 'package:dpicenter/screen/widgets/resizable_widget/resizable_container.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/wikiquote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ascii_art_generator.dart';

class DashboardContainer extends StatefulWidget {
  final List<Menu> favoritesMenu;
  final Function(Menu menu)? onFavoriteMenuTap;
  final bool showMenu;

  const DashboardContainer(
      {Key? key,
      required this.favoritesMenu,
      this.onFavoriteMenuTap,
      this.showMenu = false})
      : super(key: key);

  @override
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer>
    with AutomaticKeepAliveClientMixin<DashboardContainer> {
  final ScrollController _scrollController =
      ScrollController(debugLabel: '_dashboardMenuList');
  final ScrollController _mainScrollController =
      ScrollController(debugLabel: '_mainScrollController');
  final GlobalKey _key = GlobalKey(debugLabel: '_dashboardKey');
  final GlobalKey _reportStatBlocKey =
      GlobalKey(debugLabel: '_reportStatBlocKey');
  final GlobalKey<ReportStatState> _reportStatKey =
      GlobalKey<ReportStatState>(debugLabel: '_reportStatKey');
  final GlobalKey _welcomeKey = GlobalKey(debugLabel: '_welcomeKey');
  final GlobalKey _mainScrollKey = GlobalKey(debugLabel: '_mainScrollKey');
  final GlobalKey<MultiSelectorExState> _multiSelectorKey =
      GlobalKey<MultiSelectorExState>(debugLabel: '_multiSelectorKey');
  final GlobalKey _multiSelectorPositionedKey =
      GlobalKey(debugLabel: '_multiSelectorPositionedKey');

  final GlobalKey _asciiArtKey = GlobalKey(debugLabel: 'key: _asciiArtKey');
  final GlobalKey _fullScreenArtKey =
      GlobalKey(debugLabel: 'key: _fullScreenArtKey');

  List<Quote>? quotes;
  int statNavStatus = 0;

  bool reportStatLoaded = false;

  bool _visualizerFullScreen = false;
  final double _mobileMultiSelectorTop = 50;

  ApplicationUser? user;

  @override
  void initState() {
    super.initState();
    _mainScrollController.addListener(scrollListener);
    user = ApplicationUser.getUserFromSetting();
  }

  final Map<GlobalKey, RenderBox> _boxes = <GlobalKey, RenderBox>{};

  ///se esiste, aggiungo alle chiavi da navigare la chiave e il box relativo
  void addToBoxes(GlobalKey key) {
    if (!_boxes.containsKey(key)) {
      var box = key.currentContext?.findRenderObject();
      if (box != null && box is RenderBox) {
        _boxes.addAll({key: box});
      }
    }
  }

  void scrollListener() {
    ///se esistono, aggiungo alle chiavi da navigare i relativi boxes
    if (_reportStatKey.currentState != null) {
      addToBoxes(_reportStatKey.currentState!.reportsListKey);
      addToBoxes(_reportStatKey.currentState!.hashtagsListKey);
      addToBoxes(_reportStatKey.currentState!.chartListKey);
    }

    int index = 0;
    int nCycle = 0;

    double dy =
        0; //(_reportStatBlocKey.currentContext!.findRenderObject()! as RenderBox).localToGlobal(Offset.zero).dy + (_isTinyWidth() ? 66 : 0);

    RenderBox? currentBox = context.findRenderObject() as RenderBox?;
    Offset mainBoxOffset =
        currentBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    //print("Dy: $dy");
    //print("mainBoxOffset.dy: ${mainBoxOffset.dy+4}");
    dy = (mainBoxOffset.dy +
        4 +
        (_isTinyWidth()
            ? 66
            : 0)); //4 è il padding top, se è in visualizzazione mobile aggiunge l'offset relativo al menu sopra

    print("dy: $dy");
    double statisticheStartTop =
        (_reportStatBlocKey.currentContext!.findRenderObject()! as RenderBox)
            .localToGlobal(Offset.zero)
            .dy;
    print("statisticheStartTop: $statisticheStartTop");

/*    setState((){});
    _multiSelectorPositionedKey.currentState?.setState((){
      if (statisticheStartTop>=200) {
      _mobileMultiSelectorTop = (statisticheStartTop - dy + 50);
    } else {
      _mobileMultiSelectorTop = 50;
    }});*/

    _boxes.forEach((key, value) {
      //print("[key: $key]\rvalue.localToGlobal(Offset.zero).dy: ${value.localToGlobal(Offset.zero).dy}\rdy: $dy\r(value.localToGlobal(Offset.zero).dy - dy)\r${(value.localToGlobal(Offset.zero).dy - dy)}\r\r");

      if ((value.localToGlobal(Offset.zero).dy - dy) < 10) {
        index = nCycle;
      }

      nCycle++;
      //Offset = _mainScrollController.offset _mainScrollController.offset

      /*print(
          "currentOffset: ${_mainScrollController.offset} topLeft-dy: ${value.localToGlobal(Offset.zero).dy} bottomLeft-dy: ${value.size.bottomLeft(Offset.zero).dy}");*/
      /*  if (_mainScrollController.offset >= value.size.topLeft(Offset.zero).dy &&
          _mainScrollController.offset <  value.size.bottomLeft(Offset.zero).dy){
        print("Sono all'interno di key ${key.toString()}");

      }*/
    });

    if (statNavStatus != index) {
      statNavStatus = index;
      _multiSelectorKey.currentState?.setState(() {
        _multiSelectorKey.currentState?.status = index;
      });
    }
    // print("DashboardContainer scrollPosition ${_mainScrollController.position.toString()}");
  }

  final Wikiquote wikiquote = Wikiquote();
  int? randomCit;

  @override
  Widget build(BuildContext context) {
    super.build(context);
/*    return FutureBuilder(
        future: getQuotes(),
        builder: (context, AsyncSnapshot<List<Quote>> snapshot) {*/
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          key: _key,
          child: _isTinyWidth()
              ? mobileWidget(constraints: constraints)
              : desktopWidget(constraints: constraints));
    });
    /*}
        )*/
  }

  bool _isTinyWidth() {
    return MediaQuery.of(context).size.width <= 600;
  }

  /*Future<List<Quote>> getQuotes() async {
    */ /*quotes =<Quote>[Quote(author: 'a', quote: 'b'),Quote(author: 'c', quote: 'd')];
    return quotes!;*/ /*

    if (quotes!=null){return quotes!;}
    List<String> authors = <String>[
      'Caparezza',
      'Simpsons',
      'Matrix',
      'Matrix_Reloaded',
      'Steve_Jobs',
      'Bill_Gates'
    ];

    int authorValue = Random().nextInt(authors.length);
    List<Quote> result = <Quote>[];
for(String author in authors) {
  result.addAll(await wikiquote.quotes(author, 'it', 100));
}

    quotes=result;

    return result;
  }

  void _newRandomCit() {
    if (quotes!=null) {
      randomCit = Random().nextInt(quotes!.length);
    }
  }*/

  double _getNavPosition() {
    double navPosition = 40;
    var box = _key.currentContext?.findRenderObject();
    if (box != null && box is RenderBox) {
      navPosition = box.size.topLeft(Offset.zero).dy + 8;
    }
    return navPosition;
  }

  Widget desktopWidget({BoxConstraints? constraints}) {
    double iconSize = 24;
    double fontSize = 18; //getFontSize(context);
    /*   if (snapshot.hasData) {
      randomCit ??= Random().nextInt(snapshot.requireData.length);
    }

*/

    List<Widget> widgets = dashboardWidgets(constraints: constraints);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showMenu)
          Container(
              color: getAppBackgroundColor(context),
              height: constraints?.maxHeight,
              //   duration: const Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width - 800,
              constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: List.generate(
                        widget.favoritesMenu.length,
                        (index) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: getListItem(widget.favoritesMenu[index],
                                  fontSize, iconSize),
                            )),
                  ),
                ),
              )),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  right: 58,
                  bottom: 0,
                  top: 0,
                  child: ListView.builder(
                    key: _mainScrollKey,
                    shrinkWrap: true,
                    controller: _mainScrollController,
                    addAutomaticKeepAlives: false,
                    itemBuilder: (context, index) {
                      return widgets[index];
                    },
                    itemCount: widgets.length,
                  )),

              /*SingleChildScrollView(
                    key: _mainScrollKey,
                    restorationId: '_mainScrollRestorationId',
                    controller: _mainScrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: dashboardWidgets(constraints: constraints),
                    )),
              ),*/
              if (reportStatLoaded)
                Positioned(
                  top: _getNavPosition(),
                  right: 0,
                  width: 58,
                  child: MultiSelectorEx(
                    key: _multiSelectorKey,
                    padding: const EdgeInsets.only(
                      left: 6,
                      right: 2,
                    ),
                    direction: Axis.vertical,
                    onPressed: (index) async {
                      statNavStatus = index;
                      /*setState(() {
                        statNavStatus = index;
                      });*/

                      _scrollToCurrentStatus();
                      //widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
                    },
                    status: statNavStatus,
                    selectorData: _getSelectorData(),
                  ),
                )
            ],
          ),
        ))
      ],
    );
  }

  void _scrollToCurrentStatus() async {
    RenderObject? renderObj;

    switch (statNavStatus) {
      case 0:
        renderObj = _reportStatKey.currentState?.reportsListKey.currentContext
            ?.findRenderObject();
        break;
      case 1:
        renderObj = _reportStatKey.currentState?.hashtagsListKey.currentContext
            ?.findRenderObject();
        break;

      case 2:
      default:
        renderObj = _reportStatKey.currentState?.chartListKey.currentContext
            ?.findRenderObject();
        break;
    }

    if (renderObj != null) {
      //_mainScrollController.jumpTo(_mainScrollController.offset);
      await scrollTo(renderObj);
    }
  }

  Future scrollTo(RenderObject renderObj) async {
    // _mainScrollController.removeListener(scrollListener);
    await _mainScrollController.position.ensureVisible(
        _reportStatKey.currentContext!.findRenderObject()!,
        alignment: 0.0,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOut,
        targetRenderObject: renderObj,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
    // _mainScrollController.addListener(scrollListener);
  }

  List<SelectorData> _getSelectorData() {
    return const [
      SelectorData(periodString: "Interventi", child: Icon(Icons.engineering)),
      SelectorData(periodString: "HashTags", child: Icon(Icons.tag)),
      SelectorData(periodString: "Grafici", child: Icon(Icons.bar_chart)),
    ];
  }

  Widget getUserWelcome(/*AsyncSnapshot<List<Quote>> snapshot*/) {
/*    print("getUserWelcome");
    Quote? quote;
    if (snapshot.hasData){
      print("snapshot.hasData");
      var data = snapshot.requireData;

        print("data lenght: ${data.length}");
      print("randomCit: $randomCit}");
      quote=data[randomCit!];
    }
    print("getUserFromSetting");*/

    /*print("return Container");*/
    return Container(
      key: _welcomeKey,
      child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
              text: 'Ciao ',
              style: Theme.of(context).textTheme.titleLarge,
              children: [
                TextSpan(
                    text: '${user?.name}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary)),

                /*TextSpan(
                    text: ' lo sai cosa diceva ',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge!,
                  ),
                  TextSpan(
                      text: '${quote.author}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary)),*/
                /*TextSpan(
                  text: '\r\n',
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                TextSpan(
                  text: '${quote?.quote}',
                        style: Theme.of(context).textTheme.titleSmall!),*/
              ])),
    );
  }

  Widget mobileWidget({constraints} /*AsyncSnapshot<List<Quote>> quote*/) {
    double iconSize = 24;
    double fontSize = 18; //getFontSize(context);

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showMenu)
            LayoutBuilder(builder: (context, constraints) {
              return Container(
                  //duration: const Duration(milliseconds: 300),
                  height: 50,
                  //width: MediaQuery.of(context).size.width - 800,
                  constraints:
                      const BoxConstraints(minHeight: 50, maxHeight: 50),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                          widget.favoritesMenu.length,
                              (index) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: 200,
                                child: getListItem(widget.favoritesMenu[index],
                                    fontSize, iconSize),
                              ))),
                    ),
                  ));
            }),
          const SizedBox(
            height: 16,
          ),
          Expanded(
              child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification) {
                    } else if (scrollNotification is ScrollUpdateNotification) {
                    } else if (scrollNotification is ScrollEndNotification) {}
                    return true;
                  },
                  child: SingleChildScrollView(
                      key: _mainScrollKey,
                      restorationId: '_mainScrollRestorationId',
                      controller: _mainScrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: dashboardWidgets(constraints: constraints),
                      ))),
              if (reportStatLoaded)
                Positioned(
                  /*key: _multiSelectorPositionedKey,*/
                  top: _mobileMultiSelectorTop, //default 50
                  right: 16,
                  child: MultiSelectorEx(
                    key: _multiSelectorKey,
                    onPressed: (index) async {
                      statNavStatus = index;
                      /*setState(() {
                      statNavStatus = index;
                    });*/
                      _scrollToCurrentStatus();
                      //widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
                    },
                    status: statNavStatus,
                    selectorData: _getSelectorData(),
                  ),
                )
            ],
          ))
        ],
      ),
    );
  }

  List<Widget> dashboardWidgets({constraints}) {
    //menuId:11 = Assistenze
    int reportStatus = user?.profile?.enabledMenus
            ?.firstWhere((element) => element.menuId == 11)
            .status ??
        0;

    return [
      getUserWelcome(),
      const SizedBox(
        height: 8,
      ),
      /*Container(
        clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: isDarkTheme(context)
                  ? Colors.black.withAlpha(50)
                  : Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(20)),
          height: 500,
          child:  BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 25,
              sigmaY: 25,
            ),
            child:  const TextAnimationEx(
              text: "Dpi Center",
              cycleLetters: false,
            ),
          )),*/
      //if (!_visualizerFullScreen || reportStatus>=2)

      if (reportStatus == 0 && !_visualizerFullScreen)
        asciiArt(_asciiArtKey,
            maxHeight: constraints != null ? constraints.maxHeight : 1200),

      if (reportStatus == 0 && !_visualizerFullScreen)
        const SizedBox(
          height: 8,
        ),

      if (reportStatus != 0) getReportStat(tinyWidth: 600),
    ];
  }

  Widget asciiArt(Key key, {double? maxHeight}) {
    return InkWell(
      key: key,
      onTap: () {
        setState(() {
          if (!_visualizerFullScreen) {
            showPreview(asciiArt(_fullScreenArtKey));
          } else {
            Navigator.maybePop(context);
          }
          _visualizerFullScreen = !_visualizerFullScreen;
        });
      },
      child: SizedBox(
        height: maxHeight,
        child: Stack(
          children: [
            asciiArtSingleFilter(
              const TextClockAnimation(
                //text: "Dpi Center <> Dpi Center",
                maxBlur: 7.0,
                opacity: 0.50,

                showInfo: false,
                fastTimeoutDuration: Duration(milliseconds: 10000),
                timeoutDuration: Duration(milliseconds: 25000),
                scaleDuration: Duration(milliseconds: 15000),
                scaleTimeoutDuration: Duration(milliseconds: 15000),
                blurDuration: Duration(milliseconds: 5000),
                colorTimeoutDuration: Duration(milliseconds: 5000),
                textStyleDuration: Duration(milliseconds: 5000),
                maxScale: 2,
                rotate: true,
                rotateCanvas: false,
                scale: true,
              ),
            ),
          ],
        ),
        /*asciiArtFilter(const TextAnimationEx(
            text: "Multi-Tech",
            cycleLetters: false,
            rotate: true,
            fastTimeoutDuration: Duration(milliseconds: 2500),
            textStyleDuration: Duration(milliseconds: 2500),
            timeoutDuration: Duration(milliseconds: 10000),
            fontSize: 26,
          ),
            const TextClockAnimation(
              //text: "Dpi Center <> Dpi Center",
              fastTimeoutDuration: Duration(milliseconds: 200),
              timeoutDuration: Duration(milliseconds: 30000),
              scaleDuration: Duration(milliseconds: 15000),
              maxScale: 2,
              rotate: true,
              scale: true,
            ),),*/
      ),
    );
  }

  void showPreview(Widget child) {
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(body: child);
        }).then((value) {
      setState(() {
        _visualizerFullScreen = false;
      });
    });
  }

  Widget asciiArtSingleFilter(Widget child) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget asciiArtFilter(Widget backgroundChild, Widget foregroundChild) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Stack(alignment: Alignment.center, children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Container(
              decoration: BoxDecoration(
                color: isDarkTheme(context)
                    ? Colors.black.withAlpha(50)
                    : Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                  // make sure we apply clip it properly
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: backgroundChild))),
        ),
        Container(
          color: null,
          /*isDarkTheme(context) ?
          Color.alphaBlend(Colors.black.withAlpha(200), Theme.of(context).colorScheme.primary).withAlpha(100) :
          Color.alphaBlend(Colors.white.withAlpha(200), Theme.of(context).colorScheme.primary).withAlpha(100)*/
        ),
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: foregroundChild),
      ]),
    );
  }

  Widget getAsciiArt(String text) {
    return FutureBuilder<String>(
        future: renderText('drpepper.flf', text),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data ?? '?',
              style: const TextStyle(
                  fontFamily: 'Roboto Mono',
                  fontFeatures: [FontFeature.tabularFigures()]),
            );
          }
          return const Text("...");
        });
  }

  Widget getReportStat({double? tinyWidth}) {
    return MultiBlocProvider(
        key: _reportStatBlocKey,
        providers: [
          BlocProvider<ServerDataBloc<Report>>(
            lazy: false,
            create: (context) => ServerDataBloc<Report>(
                repo: MultiService<Report>(Report.fromJsonModel,
                    apiName: 'Report')),
          ),
        ],
        child: ReportStat(
            key: _reportStatKey,
            tinyWidth: tinyWidth,
            onLoaded: () {
              setState(() {
                reportStatLoaded = true;
              });
            }) /*LayoutBuilder(builder: (context, constraints) {
          return getResizableContainer(ReportStat(), "reportStat",
              maxWidth ?? constraints.maxWidth, maxHeight ?? constraints.maxHeight);
        })*/
        );
  }

  ///Restituisce l'item da visualizzare e definisce il callback della selezione in base al tipo di menu
  Widget getListItem(Menu menu, double fontSize, double iconSize) {
    return Builder(builder: (context) {
      return Material(
          type: MaterialType.transparency,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: getMenuColor(menu.color),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              widget.onFavoriteMenuTap?.call(menu);
              /*if (menu.destination != null) {
                setState(() {
                  selectedMenu = menu;
                });
              } else {
                menu.command?.call();
              }*/
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
                    color: getMenuColor(menu.color),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      menu.label,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: fontSize,
                            letterSpacing: 0,
                            wordSpacing: 0,
                            overflow: TextOverflow.clip,

                            ///per ora sempre white
                            /*color: isLightTheme(context)
                            ? Colors.white
                            : Colors.white,*/
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ]),
          ));
    });
  }

  Widget getResizableContainer(
      Widget child, String tag, double areaWidth, double areaHeight) {
    return ResizableContainer(
        tag: tag,
        usePoints: false,
        key: ValueKey(tag),
        areaWidth: areaWidth,
        areaHeight: areaHeight,
        offset: const Offset(0, 0),
        width: areaWidth,
        height: areaHeight,
        child: Container(
          width: areaWidth,
          height: areaHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          foregroundDecoration: BoxDecoration(
              border: Border.all(
                  color: /*lmenu.menuId != (selectedItem?.menuId ?? -1)
                    ? Theme.of(context).colorScheme.primary
                    :*/
                      Color.alphaBlend(Colors.yellow.withAlpha(150),
                          Theme.of(context).colorScheme.primary),
                  width:
                      1 /*lmenu.menuId != (selectedItem?.menuId ?? -1) ? 1 : 2*/),
              borderRadius: BorderRadius.circular(20),
              color: /*lmenu.menuId == (hoverItem?.menuId ?? -1)
                ? Colors.yellow.withAlpha(100)
                : */
                  null),
          child: Stack(
            children: [
              IgnorePointer(ignoring: false, child: child),
              /*Positioned(
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
                          : MaterialType.labelLarge,
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
                            color: Theme.of(context).errorColor,
                            icon: const Icon(Icons.close))),
                  ],
                ))*/
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.removeListener(scrollListener);
    _mainScrollController.dispose();
    _boxes.clear();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
