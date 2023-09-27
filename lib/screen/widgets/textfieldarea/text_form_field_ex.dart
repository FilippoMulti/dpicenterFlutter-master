import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/keyboard_close_widget.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_area_widget.dart';
import 'package:flutter/material.dart';

///Dovrebbe occuparsi di visualizzare l'editor di testo in un dialog quando lo spazio a disposizione è ridotto
///attualmente 08/09/2022 crea una TextFormField standard perchè nei browser web mobili era terribilmente lento ad aprire
///la tastiera. Bisogna indagare e correggere. Visto che il problema è secondario preferisco mantenere
///la classe ed eventualmente estenderla successivamente
class MobileField extends StatefulWidget {
  final bool? autofocus;
  final Key? fieldKey;
  final GestureTapCallback? onTap;
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function(String value)? onChanged;
  final InputDecoration? decoration;
  final TextStyle? style;
  final int? maxLines;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final String? labelText;

  const MobileField(
      {Key? key,
      this.fieldKey,
      this.labelText,
      this.autofocus = false,
      this.onTap,
      required this.focusNode,
      required this.controller,
      this.onChanged,
      this.decoration,
      this.style,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text,
      this.textInputAction,
      this.autovalidateMode,
      this.validator,
      this.onFieldSubmitted,
      this.maxLength,
      this.readOnly = false})
      : super(key: key);

  @override
  MobileFieldState createState() => MobileFieldState();
}

class MobileFieldState extends State<MobileField> with WidgetsBindingObserver {
  bool _oldFocusState = false;
  Orientation? _currentOrientation;
  bool _fullScreenOpen = false;

  final GlobalKey _keyboardCloseKey =
      GlobalKey(debugLabel: '_keyboardCloseKey');

  @override
  void initState() {
    super.initState();
    /* WidgetsBinding.instance.addObserver(this);
    _oldFocusState = widget.focusNode.hasFocus;
    _currentOrientation ??=
        WidgetsBinding.instance.window.physicalSize.aspectRatio > 1
            ? Orientation.landscape
            : Orientation.portrait;

    //debugPrint("text_form_field_ex.initState");
    if (isMobile) {
      widget.focusNode.addListener(focusListener);
    }*/
  }

  void focusListener() {
    if (_oldFocusState != widget.focusNode.hasFocus) {
      _oldFocusState = widget.focusNode.hasFocus;
      if (widget.focusNode.hasFocus) {
        print("Has focus: ${widget.focusNode.hasFocus}");
        if (isMobile && isTinyHeight(context)) {
          //focusNode separato da quello principale, viene distrutto alla chiusura del dialog
          openFullScreenKeyboard();

          //widget.focusNode.unfocus();
        } else {
          widget.focusNode.requestFocus();
        }
      }
    }
  }

  void openFullScreenKeyboard() async {
    //debugPrint(
    //    "openFullScreenKeyboard _fullScreenOpen: ${_fullScreenOpen.toString()}");
    if (_fullScreenOpen == false) {
      FocusNode keyboardFocusNode = FocusNode();
      String oldValue = widget.controller.text;
      _fullScreenOpen = true;
      await showFullScreenKeyboard(
          context,
          createTextFormField(
              key: null,
              readOnly: widget.readOnly,
              focusNode: keyboardFocusNode,
              onChanged: (value) {
                if (oldValue != widget.controller.text) {
                  widget.onChanged?.call(value);
                }
              },
              autoFocus: true,
              labelText: widget.labelText),
          keyboardFocusNode);

      _fullScreenOpen = false;
      //debugPrint("_fullScreenOpen: ${_fullScreenOpen.toString()}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    //debugPrint("text_form_field_ex.dispose");
    /* WidgetsBinding.instance.removeObserver(this);
    if (isMobile) {
      widget.focusNode.removeListener(focusListener);
    }*/
  }

  /*@override
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
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          debugPrint("LANDSCAPE");
          debugPrint("_fullScreenOpen: ${_fullScreenOpen.toString()}");
          debugPrint("isTinyHeight(context): ${isTinyHeight(context)}");
          debugPrint("isMobile: ${isMobile.toString()}");
          if (isMobile &&
              isTinyHeight(context) &&
              _fullScreenOpen == false &&
              widget.focusNode.hasFocus) {
            //focusNode separato da quello principale, viene distrutto alla chiusura del dialog
            openFullScreenKeyboard();
          }
        });
      } else {
        debugPrint("PORTRAIT");
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        //focusNode.addListener(() { print("Has focus: ${focusNode.hasFocus}");});

        return createTextFormField(
          key: widget.fieldKey,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onTap: widget.onTap ?? () {},
          readOnly: widget.readOnly,
        );
        /*return GestureDetector(
          onTap: () {

            if (isMobile &&  MediaQuery.of(context).size.height<=tinyHeight) {
              //focusNode separato da quello principale, viene distrutto alla chiusura del dialog
              FocusNode keyboardFocusNode = FocusNode();
              String oldValue = controller.text;
              showFullScreenKeyboard2(context,createTextFormField(null, keyboardFocusNode, (value){
                if (oldValue!=controller.text){
                  onChanged?.call(value);
                }
              }), keyboardFocusNode);

              focusNode.unfocus();
            } else {
              focusNode.requestFocus();
            }
          },
          child: AbsorbPointer(child: createTextFormField(fieldKey, focusNode, onChanged)));*/
      },
    );
  }

  Future showFullScreenKeyboard(
      BuildContext context, Widget child, FocusNode focusNode) async {
    await showDialog(
      context: context,
      builder: (context) {
        return KeyboardClose(
            key: _keyboardCloseKey,
            focusNode: focusNode,
            child: TextArea(focusNode: focusNode, child: child));

        /*  KeyboardClose(focusNode: focusNode,
            child: TextArea(child: child,focusNode: focusNode));*/
        /*Scaffold(
            body: Column(
              children: [
                Expanded(child: Container()),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: child,
                    ),
                    TextButton(onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }, child: const Text('Fatto')),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            )
        ),*/
      },
    ).then((value) => print("then"));
    widget.focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    print("finish");
  }

  Widget createTextFormField(
      {Key? key,
      FocusNode? focusNode,
      ValueChanged<String>? onChanged,
      GestureTapCallback? onTap,
      bool autoFocus = false,
      String? labelText,
      bool readOnly = false}) {
    Widget formField = TextFormField(
      key: key,
      onTap: onTap,
      autofocus: autoFocus,
      readOnly: readOnly,
      autovalidateMode: widget.autovalidateMode,
      enableInteractiveSelection: isMobile ? false : true,
      maxLength: widget.maxLength,
      focusNode: focusNode,
      controller: widget.controller,
      onChanged: onChanged,
      decoration: widget.decoration?.copyWith(
          labelText: labelText,
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
          suffixIconConstraints:
              const BoxConstraints(maxWidth: 20, maxHeight: 16)),
      style: widget.style,
      maxLines: widget.maxLines,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
    );

    if (isMobile) {
      return GestureDetector(
        onTap: () {},
        child: formField,
      );
    }
    return formField;
  }
}
