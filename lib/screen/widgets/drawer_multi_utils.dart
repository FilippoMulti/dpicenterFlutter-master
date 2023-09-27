import 'dart:ui';

import 'package:dpicenter/screen/widgets/slide_direction.dart';

class Utils {
  ///
  /// This method get Offset base on [sliderOpen] type
  ///

  static Offset getOffsetValues(SlideDirection direction, double value) {
    switch (direction) {
      case SlideDirection.leftToRight:
        return Offset(value, 0);
      case SlideDirection.rightToLeft:
        return Offset(-value, 0);
      case SlideDirection.topToBottom:
        return Offset(0, value);
      default:
        return Offset(value, 0);
    }
  }

  static Offset getOffsetValueForShadow(
      SlideDirection direction, double value, double slideOpenWidth) {
    switch (direction) {
      case SlideDirection.leftToRight:
        return Offset(value - (slideOpenWidth > 50 ? 20 : 10), 0);
      case SlideDirection.rightToLeft:
        return Offset(-value - 5, 0);
      case SlideDirection.topToBottom:
        return Offset(0, value - (slideOpenWidth > 50 ? 15 : 5));
      default:
        return Offset(value - 30.0, 0);
    }
  }
}
