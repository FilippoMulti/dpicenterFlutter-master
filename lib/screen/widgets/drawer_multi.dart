import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/screen/widgets/app_bar.dart';
import 'package:dpicenter/screen/widgets/menu_bar.dart';
import 'package:dpicenter/screen/widgets/slide_direction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'drawer_multi_utils.dart';

/// SliderMenuContainer which have two [sliderMain] and [sliderMenu] parameter
///
///For Example :
///
/// SliderMenuContainer(
///           appBarColor: Colors.white,
///             sliderMenuOpenSize: 200,
///             title: Text(
///               title,
///               style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
///             ),
///             sliderMenu: MenuWidget(
///               onItemClick: (title) {
///                 _key.currentState.closeDrawer();
///                 setState(() {
///                   this.title = title;
///                });
///               },
///             ),
///             sliderMain: MainWidget())
///
///
///
class SliderMenuContainerEx extends StatefulWidget {
  /// [Widget] which display when user open drawer
  ///
  final Widget sliderMenu;

  /// [Widget] main screen widget
  ///
  final Widget sliderMain;

  /// [int] you can changes sliderDrawer open/close animation times with this [animationDuration]
  /// parameter
  ///
  final int animationDuration;

  /// [double] you can change open drawer size by this parameter [sliderMenuOpenSize]
  ///
  final double sliderMenuOpenSize;

  ///[double] you can change close drawer size by this parameter [sliderMenuCloseSize]
  /// by Default it is 0. if you set 30 then drawer will not close full it will display 30 size of width always
  ///
  final double sliderMenuCloseSize;

  ///[bool] if you set [false] then swipe to open feature disable.
  ///By Default it's true
  ///
  final bool isDraggable;

  ///[bool] if you set [false] then it will not display app bar
  ///
  final bool hasAppBar;

  ///[Color] you can change drawer icon by this parameter [drawerIconColor]
  ///
  final Color drawerIconColor;

  ///[Widget] you can change drawer icon by this parameter [drawerIcon]
  ///
  final Widget? drawerIcon;

  ///[double] you can change drawer icon size by this parameter [drawerIconSize]
  ///
  final double drawerIconSize;

  /// The primary color of the button when the drawer button is in the down (pressed) state.
  /// The splash is represented as a circular overlay that appears above the
  /// [highlightColor] overlay. The splash overlay has a center point that matches
  /// the hit point of the user touch event. The splash overlay will expand to
  /// fill the button area if the touch is held for long enough time. If the splash
  /// color has transparency then the highlight and drawer button color will show through.
  ///
  /// Defaults to the Theme's splash color, [ThemeData.splashColor].
  ///
  final Color splashColor;

  /// [double] you can change appBar height by this parameter [appBarHeight]
  ///
  final double appBarHeight;

  /// [Widget] you can set appbar title by this parameter [title]
  ///
  final Widget title;

  ///[bool] you can set title in center by this parameter
  /// By default it's [true]
  ///
  final bool isTitleCenter;

  ///[bool] you can enable shadow of [sliderMain] Widget by this parameter
  ///By default it's [false]
  ///
  final bool isShadow;

  ///[Color] you can change shadow color by this parameter [shadowColor]
  ///
  final Color shadowColor;

  ///[double] you can change blurRadius of shadow by this parameter [shadowBlurRadius]
  ///
  final double shadowBlurRadius;

  ///[double] you can change spreadRadius of shadow by this parameter [shadowSpreadRadius]
  ///
  final double shadowSpreadRadius;

  ///[Widget] you can set trailing of appbar by this parameter [trailing]
  ///
  final Widget? trailing;

  ///[Color] you can change appbar color by this parameter [appBarColor]
  ///
  final Color appBarColor;

  ///[EdgeInsets] you can change appBarPadding by this parameter [appBarPadding]
  ///
  final EdgeInsets? appBarPadding;

  ///[slideDirection] you can change slide direction by this parameter [slideDirection]
  ///There are three type of [SlideDirection]
  ///[SlideDirection.rightToLeft]
  ///[SlideDirection.leftToRight]
  ///[SlideDirection.topToBottom]
  ///
  /// By default it's [SlideDirection.leftToRight]
  ///
  final SlideDirection slideDirection;

  ///menu initial state
  final MenuState menuInitialState;

  const SliderMenuContainerEx({
    Key? key,
    required this.sliderMenu,
    required this.sliderMain,
    this.isDraggable = true,
    this.animationDuration = 200,
    this.sliderMenuOpenSize = 265,
    this.drawerIconColor = Colors.black,
    this.drawerIcon,
    this.splashColor = Colors.transparent,
    this.isTitleCenter = true,
    this.trailing,
    this.appBarColor = Colors.white,
    this.appBarPadding = const EdgeInsets.only(top: 24),
    this.title = const Text('AppBar'),
    this.drawerIconSize = 27,
    this.appBarHeight = 70,
    this.sliderMenuCloseSize = 0,
    this.slideDirection = SlideDirection.leftToRight,
    this.isShadow = false,
    this.shadowColor = Colors.grey,
    this.shadowBlurRadius = 25.0,
    this.shadowSpreadRadius = 5.0,
    this.hasAppBar = true,
    this.menuInitialState = MenuState.closed,
  }) : super(key: key);

  @override
  SliderMenuContainerExState createState() => SliderMenuContainerExState();
}

class SliderMenuContainerExState extends State<SliderMenuContainerEx>
    with TickerProviderStateMixin {
  GlobalKey containerBaseKey = GlobalKey();
  GlobalKey containerKey = GlobalKey();
  static const double widthGesture = 50.0;
  static const double heightGesture = 30.0;
  static const double blurShadow = 20.0;

  double slideAmount = 0.0;
  double _percent = 0.0;
  final GlobalKey _drawerKey = GlobalKey(debugLabel: '_drawerMultiKey');

  //double? _currentMainWidth;
  AnimationController? _animationDrawerController;
  late Animation animation;

  bool dragging = false;

  Widget? drawerIcon;

  double _sliderMenuOpenSize = 235;

  double get sliderMenuOpenSize => _sliderMenuOpenSize;

  set sliderMenuOpenSize(double value) {
    double position;
    if (value > _sliderMenuOpenSize) {
      position = _sliderMenuOpenSize / value;
    } else {
      position = value / sliderMenuOpenSize;
    }

    double oldValue = _sliderMenuOpenSize;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _animationDrawerController?.reset();
      _sliderMenuOpenSize = value;
      animation = Tween<double>(begin: oldValue, end: _sliderMenuOpenSize)
          .animate(CurvedAnimation(
              parent: _animationDrawerController!,
              curve: Curves.easeIn,
              reverseCurve: Curves.easeOut));
      await _animationDrawerController?.forward();
    });
  }

  /// check whether drawer is open
  bool get isDrawerOpen =>
      _animationDrawerController!.isCompleted ||
      _animationDrawerController!.status == AnimationStatus.forward;

  /// it's provide [animationController] for handle and lister drawer animation
  AnimationController? get animationController => _animationDrawerController;

  /// Toggle drawer
  void toggle() async {
    if (_animationDrawerController!.isCompleted) {
      animation = Tween<double>(
              begin: widget.sliderMenuCloseSize, end: sliderMenuOpenSize)
          .animate(CurvedAnimation(
              parent: _animationDrawerController!,
              curve: Curves.easeIn,
              reverseCurve: Curves.easeOut));
      await _animationDrawerController!.reverse();
    } else {
      animation = Tween<double>(
              begin: widget.sliderMenuCloseSize, end: sliderMenuOpenSize)
          .animate(CurvedAnimation(
              parent: _animationDrawerController!,
              curve: Curves.easeIn,
              reverseCurve: Curves.easeOut));
      await _animationDrawerController!.forward();
    }

    /*_animationDrawerController!.isCompleted ?
    _animationDrawerController!.isCompleted
        ? await _animationDrawerController!.reverse()
        : await _animationDrawerController!.forward();*/
  }

  /// Open drawer
  void openDrawer() async {
    //_currentMainWidth=MediaQuery.of(context).size.width - widget.sliderMenuOpenSize;
    await _animationDrawerController!.forward();
  }

  /// Close drawer
  void closeDrawer() async {
    //_currentMainWidth=MediaQuery.of(context).size.width;
    await _animationDrawerController!.reverse();
  }

  @override
  void initState() {
    super.initState();

    _sliderMenuOpenSize = widget.sliderMenuOpenSize;
    _animationDrawerController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animationDuration));

    animation = Tween<double>(
            begin: widget.sliderMenuCloseSize, end: widget.sliderMenuOpenSize)
        .animate(CurvedAnimation(
            parent: _animationDrawerController!,
            curve: Curves.easeIn,
            reverseCurve: Curves.easeOut));

    switch (widget.menuInitialState) {
      case MenuState.opened:
        openDrawer();
        break;
      case MenuState.closed:
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <= 500) {
      return standardWidget();
    } else {
      return customWidget();
    }
  }

  Color getSurfaceBackgroundColor() {
    return isLightTheme(context)
        ? Theme.of(context).colorScheme.primary
        : Color.alphaBlend(Theme.of(context).colorScheme.surface.withAlpha(240),
            Theme.of(context).colorScheme.primary);
  }

  Widget customWidget() {
    double width = MediaQuery.of(context).size.width;
    //double y = 0;
    return LayoutBuilder(builder: (context, constrain) {
      /*print("H: " + constrain.heightConstraints().toString());
      print("H_A: " + MediaQuery.of(context).size.height.toString());

      print("W: " + constrain.widthConstraints().toString());
      print("W_A: " + MediaQuery.of(context).size.width.toString());*/
      return Container(
          decoration: BoxDecoration(
            color: getSurfaceBackgroundColor(),
            //  border: Border.all(color: Theme.of(context).colorScheme.onPrimary)
          ),
          /*constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height),*/
          key: containerBaseKey,
          child: Stack(children: <Widget>[
            /// Display Menu
            //IntrinsicHeight(
            //    child:
            SlideMenuBar(
              slideDirection: widget.slideDirection,
              sliderMenu: widget.sliderMenu,
              sliderMenuOpenSize: widget.sliderMenuOpenSize,
            ), //),

            /*  /// Displaying the  shadow
            if (widget.isShadow) ...[
              AnimatedBuilder(
                animation: _animationDrawerController!,
                builder: (_, child) {
                  return Transform.translate(
                    offset: Utils.getOffsetValueForShadow(widget.slideDirection,
                        animation.value, widget.sliderMenuOpenSize),
                    child: child,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
                    BoxShadow(
                      color: widget.shadowColor,
                      blurRadius: widget.shadowBlurRadius,
                      // soften the shadow
                      spreadRadius: widget.shadowSpreadRadius,
                      //extend the shadow
                      offset: Offset(
                        15.0, // Move to right 15  horizontally
                        15.0, // Move to bottom 15 Vertically
                      ),
                    )
                  ]),
                ),
              ),
            ],*/

            //Display Main Screen
            AnimatedBuilder(
              key: containerKey,
              animation: _animationDrawerController!,
              builder: (_, child) {
                //double width = MediaQuery.of(_).size.width;

                /*    if (containerKey.currentContext != null &&
                    containerKey.currentContext!.findRenderObject()
                        is RenderBox) {
                  RenderBox box = containerKey.currentContext!
                      .findRenderObject() as RenderBox;
                  Offset position =
                      box.localToGlobal(Offset.zero); //this is global position
                //  y = position.dy;
                } else {
                  if (kDebugMode) {
                    print('non render box o key null');
                  }
                }*/
                /*if (y.isNaN) {
                  y = 0.0;
                }*/
                if (kDebugMode) {
                  //print("MediaQuery: " + MediaQuery.of(_).size.toString());
                }

                return Positioned(
                    left: animation.value,
                    top: 0,
                    right: 0,
                    //width: width - animation.value,
                    height: constrain.minHeight,
                    /*   duration: const Duration(milliseconds: 200),
                    curve: Curves.linearToEaseOut,*/
                    child: child!);
              },

              /*return Transform.translate(
                  offset: Utils.getOffsetValues(widget.slideDirection, animation.value),
                  child: child,
                );*/

              child: GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                //onHorizontalDragStart: _onHorizontalDragStart,
                //onHorizontalDragEnd: _onHorizontalDragEnd,
                //onHorizontalDragUpdate: (detail) =>
                //    _onHorizontalDragUpdate(detail, constrain),
                child: Column(
                  children: <Widget>[
                    if (widget.hasAppBar)
                      SliderAppBar(
                        slideDirection: widget.slideDirection,
                        onTap: () => toggle(),
                        appBarHeight: widget.appBarHeight,
                        animationController: _animationDrawerController!,
                        appBarColor: widget.appBarColor,
                        appBarPadding: widget.appBarPadding!,
                        drawerIcon: widget.drawerIcon,
                        drawerIconColor: widget.drawerIconColor,
                        drawerIconSize: widget.drawerIconSize,
                        isTitleCenter: widget.isTitleCenter,
                        splashColor: widget.splashColor,
                        title: widget.title,
                        trailing: widget.trailing,
                      ),
                    Expanded(key: _drawerKey, child: widget.sliderMain),
                  ],
                ),
              ),
            ),
          ]));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationDrawerController!.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails detail) {
    if (!widget.isDraggable) return;

    //Check use start dragging from left edge / right edge then enable dragging
    if ((widget.slideDirection == SlideDirection.leftToRight &&
        detail.localPosition.dx <= widthGesture) ||
        (widget.slideDirection == SlideDirection.rightToLeft &&
            detail.localPosition.dx >=
                widthGesture) /*&&
        detail.localPosition.dy <= widget.appBarHeight*/
    ) {
      setState(() {
        dragging = true;
      });
    }
    //Check use start dragging from top edge / bottom edge then enable dragging
    if (widget.slideDirection == SlideDirection.topToBottom &&
        detail.localPosition.dy >= heightGesture) {
      setState(() {
        dragging = true;
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails detail) {
    if (!widget.isDraggable) return;
    if (dragging) {
      openOrClose();
      setState(() {
        dragging = false;
      });
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails detail,
      BoxConstraints constraints,) {
    if (!widget.isDraggable) return;
    // open drawer for left/right type drawer
    if (dragging && widget.slideDirection == SlideDirection.leftToRight ||
        widget.slideDirection == SlideDirection.rightToLeft) {
      var globalPosition = detail.globalPosition.dx;
      globalPosition = globalPosition < 0 ? 0 : globalPosition;
      double position = globalPosition / constraints.maxWidth;
      var realPosition = widget.slideDirection == SlideDirection.leftToRight
          ? position
          : (1 - position);
      move(realPosition);
    }
    // open drawer for top/bottom type drawer
    /*if (dragging && widget.slideDirection == SlideDirection.TOP_TO_BOTTOM) {
      var globalPosition = detail.globalPosition.dx;
      globalPosition = globalPosition < 0 ? 0 : globalPosition;
      double position = globalPosition / constraints.maxHeight;
      var realPosition = widget.slideDirection == SlideDirection.TOP_TO_BOTTOM
          ? position
          : (1 - position);
      move(realPosition);
    }*/

    // close drawer for left/right type drawer
    if (isDrawerOpen &&
        (widget.slideDirection == SlideDirection.leftToRight ||
            widget.slideDirection == SlideDirection.rightToLeft) &&
        detail.delta.dx < 15) {
      closeDrawer();
    }
  }

  move(double percent) {
    _percent = percent;
    _animationDrawerController!.value = percent;
    //_animationDrawerController!.notifyListeners();
  }

  openOrClose() {
    if (_percent > 0.3) {
      openDrawer();
    } else {
      closeDrawer();
    }
  }

  Widget standardWidget() {
    return LayoutBuilder(builder: (context, constrain) {
      return Container(
        key: containerBaseKey,
        child: Stack(children: <Widget>[
          /// Display Menu
          SlideMenuBar(
            slideDirection: widget.slideDirection,
            sliderMenu: widget.sliderMenu,
            sliderMenuOpenSize: widget.sliderMenuOpenSize,
          ),

          /// Displaying the  shadow
          if (widget.isShadow) ...[
            AnimatedBuilder(
              animation: _animationDrawerController!,
              builder: (_, child) {
                return Transform.translate(
                  offset: Utils.getOffsetValueForShadow(widget.slideDirection,
                      animation.value, widget.sliderMenuOpenSize),
                  child: child,
                );
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
                  BoxShadow(
                    color: widget.shadowColor,
                    blurRadius: widget.shadowBlurRadius,
                    // soften the shadow
                    spreadRadius: widget.shadowSpreadRadius,
                    //extend the shadow
                    offset: const Offset(
                      15.0, // Move to right 15  horizontally
                      15.0, // Move to bottom 15 Vertically
                    ),
                  )
                ]),
              ),
            ),
          ],

          //Display Main Screen
          AnimatedBuilder(
            animation: _animationDrawerController!,
            builder: (_, child) {
              return Transform.translate(
                offset: Utils.getOffsetValues(
                    widget.slideDirection, animation.value),
                child: child,
              );
            },
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
    /*          onHorizontalDragStart: _onHorizontalDragStart,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              onHorizontalDragUpdate: (detail) =>
                  _onHorizontalDragUpdate(detail, constrain),*/
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color:
                    isDarkTheme(context) ? getSurfaceBackgroundColor() : null,
                child: Column(
                  children: <Widget>[
                    if (widget.hasAppBar)
                      SliderAppBar(
                        slideDirection: widget.slideDirection,
                        onTap: () => toggle(),
                        appBarHeight: widget.appBarHeight,
                        animationController: _animationDrawerController!,
                        appBarColor: widget.appBarColor,
                        appBarPadding: widget.appBarPadding!,
                        drawerIcon: widget.drawerIcon,
                        drawerIconColor: widget.drawerIconColor,
                        drawerIconSize: widget.drawerIconSize,
                        isTitleCenter: widget.isTitleCenter,
                        splashColor: widget.splashColor,
                        title: widget.title,
                        trailing: widget.trailing,
                      ),
                    Expanded(key: _drawerKey, child: widget.sliderMain),
                  ],
                ),
              ),
            ),
          ),
        ]),
      );
    });
  }
}
enum MenuState {
  closed,
  opened,
}