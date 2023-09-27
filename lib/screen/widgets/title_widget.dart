import 'package:dpicenter/icons/material.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatefulWidget {
  const TitleWidget(
      {required this.title,
      this.direction = Axis.vertical,
      this.subTitle,
      this.offline,
      required this.titleFontSize,
      required this.subTitleFontSize,
      required this.iconSize,
      required this.buttonHeight,
      this.icon,
      this.color,
      this.titleClick,
      this.foregroundColor = Colors.white,
      this.onClosePressed,
      Key? key})
      : super(key: key);

  final String title;
  final Axis direction;
  final String? subTitle;
  final bool? offline;
  final double titleFontSize;
  final double subTitleFontSize;
  final double iconSize;
  final double buttonHeight;
  final String? icon;
  final Color? color;
  final VoidCallback? titleClick;
  final Function()? onClosePressed;

  final Color foregroundColor;

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.antiAlias,
      duration: const Duration(milliseconds: 350),
      child: Hero(
        tag: '${widget.title}Hero',
        transitionOnUserGestures: true,
        child: MouseRegion(
          onEnter: (value) {
            setState(() {
              hover = true;
            });
          },
          onExit: (value) {
            setState(() {
              hover = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              type: MaterialType.transparency,
              child: IntrinsicWidth(
                  child: MaterialButton(
                color: widget.color,
                textColor: widget.foregroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                /*style: TextButton.styleFrom(
                          foregroundColor: widget.foregroundColor,
                          backgroundColor: widget.color,
                          minimumSize: Size(1, widget.buttonHeight),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),*/
                onPressed: widget.titleClick,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icons[widget.icon],
                          size: widget.iconSize,
                          color: widget.foregroundColor,
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 2, 4),
                          child: widget.direction == Axis.horizontal
                              ? horizontalLayout(widget.title, widget.subTitle,
                                  widget.titleFontSize, widget.subTitleFontSize)
                              : verticalLayout(
                                  widget.title,
                                  widget.subTitle,
                                  widget.titleFontSize,
                                  widget.subTitleFontSize)),
                    ),
                    if (widget.onClosePressed != null && hover)
                      const SizedBox(
                        width: 16,
                      ),
                    if (widget.onClosePressed != null && hover)
                      Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                            tooltip: 'Chiude la finestra',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                maxHeight: 20, minWidth: 20),
                            onPressed: widget.onClosePressed,
                            icon: Icon(
                              Icons.clear,
                              size: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .error, //Color.alphaBlend(Colors.red.withAlpha(150), Colors.white)
                            )),
                      )
                    /*Column(
                              children: <Widget>[
                                Text(
                                  offline != null && offline ? "OFFLINE" : "",
                                  style: TextStyle(color: Colors.red),
                                )
                              ],
                            )*/
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget verticalLayout(String title, String? subTitle, double titleFontSize,
      double subTitleFontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        itemText(title, titleFontSize),
        if (subTitle != null) itemText(subTitle ?? '', subTitleFontSize)
      ],
    );
  }

  Widget horizontalLayout(String title, String? subTitle, double titleFontSize,
      double subTitleFontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        itemText(title, titleFontSize),
        if (subTitle != null)
          const SizedBox(
            width: 16,
          ),
        if (subTitle != null) itemText(subTitle ?? '', subTitleFontSize)
      ],
    );
  }

  itemText(String? text, double fontSize) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text ?? '',
          style: TextStyle(fontSize: fontSize), textAlign: TextAlign.start),
    );
  }
}
