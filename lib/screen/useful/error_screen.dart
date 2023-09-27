import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:flutter/material.dart';

/*
LoadingIndicator(
indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
colors: const [Colors.white],       /// Optional, The color collections
strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
backgroundColor: Colors.black,      /// Optional, Background of the widget
pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
)*/

// Define a custom Form widget.
class ErrorScreen extends StatelessWidget {
  final String? message;
  final VoidCallback? onPressed;

  const ErrorScreen({Key? key, required this.message, required this.onPressed})
      : super(key: key);

  dynamic getDarkColors(context) {
    return [
      getAppBackgroundColor(context),
      Colors.deepOrange,
      Colors.red,
      Colors.red.shade700,
      Colors.red.shade900,
    ];
  }

  dynamic getLightColors(context) {
    return [
      getAppBackgroundColor(context),
      Colors.deepOrange,
      Colors.red,
      Colors.red.shade700,
      Colors.red.shade900,
    ];
  }

  Color getBackground(BuildContext context) {
    if (isDarkTheme(context)) {
      return Color.alphaBlend(
          Theme.of(context).colorScheme.surface.withAlpha(240),
          Theme.of(context).colorScheme.primary);
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.001, 0.2, 0.55, 0.75, 0.95],
          colors: [
            getBackground(context),
            Colors.red,
            Colors.red,
            Colors.red.shade700,
            Colors.red.shade900,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                        child: Text(
                          "Oooops!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        )),
                  ])),
          Expanded(
              flex: 7,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: Center(
                            child: SingleChildScrollView(
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SelectableText(
                                      message!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        overflow: TextOverflow.clip,
                                      ),
                                    )))))
                  ])),
          Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: ButtonTheme(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 50)),
                          onPressed: onPressed,
                          child: const Text(
                            "Riprova",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ))
                ],
              ))
        ],
      ),
    );

    /*return SingleChildScrollView(
        child: Container(
      color: Colors.deepOrange.withAlpha(230),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 25),
              child: Text(
                "Oooops!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                ),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: SelectableText(
                message!,
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          Center(
            child: Padding(
                padding: EdgeInsets.all(50),
                child: Container(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    child: Text("Riprova"),
                  ),
                )),
          )
        ],
      ),
    ));*/
  }
}
