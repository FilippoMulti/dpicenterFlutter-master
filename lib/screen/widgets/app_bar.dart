import 'package:dpicenter/screen/widgets/slide_direction.dart';
import 'package:flutter/material.dart';

class SliderAppBar extends StatelessWidget {
  final EdgeInsets appBarPadding;
  final Color appBarColor;
  final Widget? drawerIcon;
  final Color splashColor;
  final Color drawerIconColor;
  final double drawerIconSize;
  final double appBarHeight;
  final AnimationController animationController;
  final VoidCallback onTap;
  final Widget title;
  final bool isTitleCenter;
  final Widget? trailing;
  final SlideDirection slideDirection;

  const SliderAppBar(
      {Key? key,
      this.appBarPadding = const EdgeInsets.only(top: 24),
      this.appBarColor = Colors.blue,
      this.drawerIcon,
      this.splashColor = Colors.black,
      this.drawerIconColor = Colors.black87,
      this.drawerIconSize = 27,
      required this.animationController,
      required this.onTap,
      required this.title,
      required this.isTitleCenter,
      this.trailing,
      required this.slideDirection,
      required this.appBarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appBarHeight,
      padding: appBarPadding,
      color: appBarColor,
      child: Row(
        children: appBar(),
      ),
    );
  }

  List<Widget> appBar() {
    List<Widget> list = [
      drawerIcon ??
          IconButton(
              splashColor: splashColor,
              icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  color: drawerIconColor,
                  size: drawerIconSize,
                  progress: animationController),
              onPressed: () => onTap()),
      Expanded(
        child: isTitleCenter
            ? Center(
                child: title,
              )
            : title,
      ),
      trailing ??
          const SizedBox(
            width: 35,
          )
    ];

    if (slideDirection == SlideDirection.rightToLeft) {
      return list.reversed.toList();
    }
    return list;
  }
}

class CustomAppBarShape extends ContinuousRectangleBorder {
  const CustomAppBarShape() : super();

  const CustomAppBarShape.withSide({required BorderSide side})
      : super(side: side);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double height = rect.height;
    double width = rect.width;
    var path = Path();

    path.lineTo(0, height + 20);
    path.arcToPoint(
      Offset(20, height),
      radius: const Radius.circular(20),
    );
    path.lineTo(width - 20, height);
    path.arcToPoint(
      Offset(width, height + 20),
      radius: const Radius.circular(20),
    );
    path.lineTo(width, 0);
    path.close();
    /*path.lineTo(0, height + width * 0.1);
    path.arcToPoint(Offset(width * 0.1, height),
      radius: Radius.circular(width * 0.1),
    );
    path.lineTo(width * 0.9,  height);
    path.arcToPoint(Offset(width, height + width * 0.1),
      radius: Radius.circular(width * 0.1),
    );
    path.lineTo(width,  0);
    path.close();*/

    return path;
  }
}