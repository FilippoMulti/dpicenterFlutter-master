import 'package:dpicenter/screen/widgets/slide_direction.dart';
import 'package:flutter/material.dart';

///
/// Build and Align the Menu widget based on the slide open type
///
class SlideMenuBar extends StatelessWidget {
  final SlideDirection slideDirection;
  final double sliderMenuOpenSize;
  final Widget sliderMenu;

  const SlideMenuBar(
      {Key? key,
      required this.slideDirection,
      required this.sliderMenuOpenSize,
      required this.sliderMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var container = SizedBox(
      width: sliderMenuOpenSize,
      height: MediaQuery.of(context).size.height,
      child: sliderMenu,
    );
    switch (slideDirection) {
      case SlideDirection.leftToRight:
        return container;
      case SlideDirection.rightToLeft:
        return Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: sliderMenuOpenSize,
            height: MediaQuery.of(context).size.height,
            child: container);
      case SlideDirection.topToBottom:
        return Positioned(
            right: 0,
            left: 0,
            top: 0,
            width: sliderMenuOpenSize,
            height: MediaQuery.of(context).size.height,
            child: container);
    }
  }
}
