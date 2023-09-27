import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

/*
LoadingIndicator(
indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
colors: const [Colors.white],       /// Optional, The color collections
strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
backgroundColor: Colors.black,      /// Optional, Background of the widget
pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
)*/

// Define a custom Form widget.
class DownloadScreen extends StatelessWidget {
  final String message;
  final double progressValue;
  final int sended;
  final int total;

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

  const DownloadScreen(
      {Key? key,
      required this.message,
      required this.progressValue,
      required this.sended,
      required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color =
        isDarkTheme(context) ? getDarkColors(context) : getLightColors(context);

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.001, 0.4, 0.55, 0.75, 0.95],
            colors: color,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
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
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .primaryTextTheme
                              .headlineSmall!
                              .fontSize,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .displayLarge!
                              .color,
                        ),
                      ),
                    ),
                  )),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: FAProgressBar(
                      borderRadius: BorderRadius.circular(20),
                      animatedDuration: const Duration(milliseconds: 0),
                      maxValue: 100,
                      changeColorValue: 100,
                      changeProgressColor: Colors.green.withAlpha(200),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .background
                          .withAlpha(100),
                      progressColor: Theme.of(context).colorScheme.primary,
                      currentValue: progressValue * 100),

                  /*    LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                      value: progressValue,
                    )*/
                ),
              ),
              const SizedBox(height: 8),
              Text("$sended/$total",
                  style: itemValueTextStyle(context: context).copyWith(
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displayLarge!
                          .color))
            ],
          ),
        ));
  }
}
