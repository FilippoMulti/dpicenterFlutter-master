import 'package:dpicenter/globals/globals.dart';
import 'package:flutter/material.dart';

class DialogTitleEx extends StatefulWidget {
  final EdgeInsets padding;
  final Duration animationDuration;
  final double normalFontSize;
  final double tinyFontSize;
  final CrossAxisAlignment titleAlignment;
  final bool withAnimatedContainerDivider;
  final Widget? trailingChild;
  final String? title;
  final Widget? subTitleWidget;

  const DialogTitleEx(this.title,
      {Key? key,
      this.padding = const EdgeInsets.all(8),
      this.subTitleWidget,
      this.animationDuration = const Duration(milliseconds: 350),
      this.normalFontSize = 26,
      this.tinyFontSize = 18,
      this.titleAlignment = CrossAxisAlignment.stretch,
      this.trailingChild,
      this.withAnimatedContainerDivider = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DialogTitleExState();
}

class DialogTitleExState extends State<DialogTitleEx> {
  String title = "";

  @override
  void initState() {
    super.initState();
    title = widget.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    bool isTiny = MediaQuery.of(context).size.height <= tinyHeight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors
            .transparent, /*Theme.of(context).primaryColor.withAlpha(150)*/
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: widget.titleAlignment,
        children: [
          Flexible(
            child: Padding(
              padding: widget.padding,
              child: AnimatedDefaultTextStyle(
                duration: widget.animationDuration,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize:
                        isTiny ? widget.tinyFontSize : widget.normalFontSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title),
                            if (widget.subTitleWidget != null)
                              widget.subTitleWidget!,
                          ]),
                    ),
                    if (widget.trailingChild != null) widget.trailingChild!
                  ],
                ),
              ),
            ),
          ),
          /*if (widget.withAnimatedContainerDivider)
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              height: isTiny ? 15 : 30,
            )*/
        ],
      ),
    );
  }
}
