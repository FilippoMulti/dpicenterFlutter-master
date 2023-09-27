import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

/*
LoadingIndicator(
indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
colors: const [Colors.white],       /// Optional, The color collections
strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
backgroundColor: Colors.black,      /// Optional, Background of the widget
pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
)*/

// Define a custom Form widget.
class LoadingScreen extends StatefulWidget {
  final String? message;
  final Color? color;
  final Color? textColor;
  final BorderRadiusGeometry? borderRadius;
  final Axis? direction;

  const LoadingScreen(
      {Key? key,
      required this.message,
      this.color,
      this.borderRadius,
      this.textColor,
      this.direction})
      : super(key: key);

  @override
  LoadingScreenState createState() {
    return LoadingScreenState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    var mediaData = MediaQuery.of(context);

    Color background = isDarkTheme(context)
        ? Color.alphaBlend(Theme.of(context).colorScheme.surface.withAlpha(240),
            Theme.of(context).colorScheme.primary)
        : Color.alphaBlend(
            Theme.of(context).colorScheme.primary.withAlpha(50), Colors.white);

    return LayoutBuilder(
      builder: (context, constraints) => Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: widget.color ?? background,
          ),
          child: Center(
            child: (constraints.maxHeight < tinyHeight &&
                        constraints.maxWidth > tinyWidth) ||
                    (widget.direction != null &&
                        widget.direction == Axis.horizontal)
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: text(
                            fontSize: constraints.maxHeight < tinyHeight &&
                                    constraints.maxWidth < tinyWidth
                                ? 14
                                : null)),
                    pacman(
                        color: Theme.of(context).colorScheme.primary,
                        size: constraints.maxHeight < tinyHeight &&
                                constraints.maxWidth < tinyWidth
                            ? 50
                            : null),
                  ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                          child: text(
                              fontSize: constraints.maxHeight < tinyHeight &&
                                      constraints.maxWidth < tinyWidth
                                  ? 14
                                  : null)),
                      pacman(
                          color: Theme.of(context).colorScheme.primary,
                          size: constraints.maxHeight < tinyHeight &&
                                  constraints.maxWidth < tinyWidth
                              ? 50
                              : null),
                    ],
                  ),
          )),
    );
  }

  Widget text({double? fontSize}) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(100),
          borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Text(
          widget.message!,
          textAlign: TextAlign.center,
          style: TextStyle(
            /*shadows: <Shadow>[
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 8.0,
                color: Color.fromARGB(125, 0, 0, 255),
              ),
            ],*/
            fontSize: fontSize ??
                Theme.of(context).primaryTextTheme.headlineSmall!.fontSize,
            color: widget.textColor ??
                (isDarkTheme(context)
                    ? Theme.of(context).primaryTextTheme.headlineSmall!.color
                    : Colors.black87),
          ),
        ),
      ),
    );
  }


}
