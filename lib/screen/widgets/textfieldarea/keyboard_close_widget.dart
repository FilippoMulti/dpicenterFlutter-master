
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class KeyboardClose extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;

  const KeyboardClose({Key? key, required this.child, required this.focusNode})
      : super(key: key);

  @override
  KeyboardCloseState createState() => KeyboardCloseState();
}

class KeyboardCloseState extends State<KeyboardClose>
    with WidgetsBindingObserver {
  //late StreamSubscription<bool> keyboardSubscription;
  //late Stream<ChangeNotifier>  keyboardSubscription;

  final ValueNotifier<bool> keyboardVisible = ValueNotifier(false);
  bool? keyboardStartState;

  var keyboardVisibilityController = KeyboardVisibilityController();

  //final ScreenHeight _screenHeightController = ScreenHeight();

  //bool _oldFocusState = false;
  bool? _closed;

  Orientation? _currentOrientation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentOrientation ??=
        WidgetsBinding.instance.window.physicalSize.aspectRatio > 1
            ? Orientation.landscape
            : Orientation.portrait;

    //  widget.focusNode.addListener(focusListener);
    /*   keyboardVisible = _screenHeightController.isOpen;
    _screenHeightController.addListener(() {
      debugPrint("event");
    });*/

    /*// Query
      keyboardVisible = keyboardVisibilityController.isVisible;
      if (kDebugMode) {
        print('Keyboard visibility direct query: ${keyboardVisibilityController
            .isVisible}');
      }

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
          if (isAndroid && isIOS) {
            if (keyboardVisible == false && !visible) {
              if (mounted) {
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  if (mounted) {
                    Navigator.of(context).pop();
                    widget.focusNode?.unfocus();
                  }
                });
              }
            } else {
              keyboardVisible = false;
            }
          }
          if (kDebugMode) {
            print('Keyboard visibility update. Is visible: $visible');
          }
        });
*/
  }

/*void focusListener(){
    if (mounted) {
      if (_oldFocusState != widget.focusNode.hasFocus) {
        _oldFocusState = widget.focusNode.hasFocus;
        if (widget.focusNode.hasFocus == false) {
          print("Has focus: ${widget.focusNode.hasFocus}");
          Navigator.of(context).pop();
          //if (isMobile &&  MediaQuery.of(context).size.height<=tinyHeight) {
          //focusNode separato da quello principale, viene distrutto alla chiusura del dialog

          //} else {
          //  focusNode.requestFocus();
          //}
        }
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    //if (isAndroidMobile || isIOSMobile) {
    //return widget.child;

    return KeyboardSizeProvider(
      child: Consumer<ScreenHeight>(builder: (context, res, child) {
        print("res.isOpen1: ${res.isOpen}");
        if (keyboardStartState == null && res.isOpen == true) {
          //situazione in cui è già aperta la tastiera all'apertura del widget
          keyboardStartState = false;
        } else {
          keyboardStartState ??= res.isOpen;
        }

        print("keyboardStartState: $keyboardStartState");

        if (mounted) {
          // print("res.isOpen2: " + _res.isOpen.toString());
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            //keyboardVisible.value = _res.isOpen;
            //print("keyboardVisible 2: " + keyboardVisible.value.toString());
            if (keyboardStartState! && !res.isOpen) {
              //   print("res.isOpen3: " + _res.isOpen.toString());
              //if (keyboardVisible.value == true) {
              if (_closed != null) {
                print(
                    "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>>>>>>>>>>>>>>>>> already closed");
              }

              if (mounted && _closed == null) {
                _closed = true;
                print("pop ");
                pop();
              }
              /*} else {
                                print("set keyboardVisible to false ");

                              }*/
            } else {
              keyboardStartState = res.isOpen;
            }
          });
        }
        return widget.child;
      }),
    );
    /*} else {
      return widget.child;
    }*/
  }

  void pop() {
    widget.focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //keyboardSubscription.cancel();
    //widget.focusNode.removeListener(focusListener);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    //debugPrint("didChangeMetrics");
    Orientation orientation =
    WidgetsBinding.instance.window.physicalSize.aspectRatio > 1
            ? Orientation.landscape
            : Orientation.portrait;

    if (_currentOrientation != orientation) {
      //debugPrint("orientation change");
      _currentOrientation = orientation;
      if (_currentOrientation == Orientation.landscape) {
      } else {
        //debugPrint("PORTRAIT");
        if (isMobile && isTinyHeight(context)) {
          //focusNode separato da quello principale, viene distrutto alla chiusura del dialog
          if (_closed == null) {
            _closed = true;
            //widget.focusNode.unfocus();
            Navigator.of(context).pop();
          }
        }
      }
    }
  }
}
