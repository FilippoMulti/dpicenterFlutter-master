import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/theme_manager/theme_mode_handler.dart';
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
class WaitingScreen extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const WaitingScreen(
      {Key? key,
      required this.title,
      required this.message,
      required this.onPressed,
      required this.buttonText})
      : super(key: key);

  dynamic getDarkColors(context) {
    return [
      Theme.of(context).primaryColor,
      Colors.blue,
      Colors.blueAccent,
      Colors.blue.shade700,
      Colors.blue.shade900,
    ];
  }

  dynamic getLightColors(context) {
    return [
      Theme.of(context).primaryColor,
      Colors.blue,
      Colors.blueAccent,
      Colors.blue.shade700,
      Colors.blue.shade900,
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    var color =
        isDarkTheme(context) ? getDarkColors(context) : getLightColors(context);
    /*var color = [Colors.black];
    switch (ThemeModeHandler.of(context)!.themeMode) {
      case ThemeMode.dark:
        color = getDarkColors(context);
        break;
      case ThemeMode.light:
        color = getLightColors(context);
        break;
      case ThemeMode.system:
        if (isSystemDarkMode(context)) {
          color = getDarkColors(context);
        } else {
          color = getLightColors(context);
        }

        break;
    }*/
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.001, 0.4, 0.55, 0.75, 0.95],
          colors: color,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              type: MaterialType.button,
                              elevation: 8,
                              borderRadius: BorderRadius.circular(20),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.blue.withAlpha(150),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.blue.withAlpha(150),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize),
                                ),
                              ),
                            ))))
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
                                    child: Material(
                                      type: MaterialType.button,
                                      elevation: 8,
                                      borderRadius: BorderRadius.circular(20),
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.blue.withAlpha(150),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.withAlpha(150),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          message,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              overflow: TextOverflow.clip,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .fontSize),
                                        ),
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
                          fixedSize: const Size(200, 50),
                          backgroundColor: Colors.blue,
                          elevation: 8),
                      onPressed: onPressed,
                      child: Text(
                        buttonText,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                            color: Colors.white),
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
