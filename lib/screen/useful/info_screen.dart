import 'package:dpicenter/globals/theme_global.dart';
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
class InfoScreen extends StatefulWidget {
  final String message;
  final String? errorMessage;
  final Icon? icon;
  final String? emoticonText;
  final VoidCallback onPressed;
  final String buttonText;
  final ImageProvider? image;

  const InfoScreen(
      {Key? key,
      required this.message,
      required this.onPressed,
      this.icon,
      this.emoticonText,
      this.errorMessage,
      this.image,
      this.buttonText = 'OK'})
      : super(key: key);

  @override
  _InfoScreenState createState() {
    return _InfoScreenState();
  }
}

double getEmoticonSize(BuildContext context) {
  if (MediaQuery.of(context).size.width < 400) {
    return 24;
  }
  if (MediaQuery.of(context).size.width < 500) {
    return 30;
  }
  if (MediaQuery.of(context).size.width < 600) {
    return 36;
  }
  if (MediaQuery.of(context).size.width < 800) {
    return 48;
  }

  if (MediaQuery.of(context).size.width < 1200) {
    return 64;
  }

  return 96;
}

// Define a corresponding State class.
// This class holds data related to the form.
class _InfoScreenState extends State<InfoScreen> {
  final ScrollController _scrollController =
      ScrollController(debugLabel: '_scrollController');

  //'(╯°□°）╯︵ ┻━┻',//'¯\\_( ツ )_/¯',
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    double emoticonSize = getEmoticonSize(context);
    return Container(
        color: isDarkTheme(context)
            ? Color.alphaBlend(
                Theme.of(context).colorScheme.surface.withAlpha(240),
                Theme.of(context).colorScheme.primary)
            : Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(100),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(50),
                            child: Text(
                              widget.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .primaryTextTheme
                                    .headlineSmall!
                                    .fontSize,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headlineSmall!
                                    .color,
                                /* shadows: <Shadow>[
                                Shadow(
                                offset: Offset(10.0, 10.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                  Shadow(
                    offset: Offset(10.0, 10.0),
                    blurRadius: 8.0,
                    color: Color.fromARGB(125, 0, 0, 255),
                  ),
                  ],*/
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.icon != null)
                        Flexible(
                            child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(50),
                              child: SizedBox(
                                  height: 100, width: 100, child: widget.icon)),
                        )),
                      if (widget.image != null)
                        const SizedBox(
                          height: 16,
                        ),
                      if (widget.image != null)
                        Container(
                            padding: EdgeInsets.all(20),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(100),
                                borderRadius: BorderRadius.circular(20)),
                            child: Image(
                                image: widget.image!,
                                width: emoticonSize * 2,
                                height: emoticonSize * 2,
                                color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withAlpha(100)
                                            .computeLuminance() <
                                        0.5
                                    ? Colors.white70
                                    : Colors.black87)),
                      if (widget.emoticonText != null)
                        const SizedBox(
                          height: 16,
                        ),
                      if (widget.emoticonText != null)
                        Flexible(
                            child: Center(
                                child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                              child: Text(
                            widget.emoticonText!,
                            style: TextStyle(
                                fontSize: emoticonSize,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headlineSmall!
                                    .color),
                          )),
                        ))),
                      if (widget.errorMessage != null)
                        const SizedBox(
                          height: 48,
                        ),
                      if (widget.errorMessage != null)
                        Flexible(
                            child: Center(
                                child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withAlpha(100),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Theme.of(context).errorColor)),
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(widget.errorMessage!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .primaryTextTheme
                                            .headlineSmall!
                                            .color)),
                              )),
                        ))),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 40)),
                    onPressed: widget.onPressed,
                    child: Text(
                      widget.buttonText,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                )),
            const SizedBox(
              height: 16,
            )
          ],
        ));
  }
}
