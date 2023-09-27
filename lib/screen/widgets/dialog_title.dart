import 'package:dpicenter/globals/globals.dart';
import 'package:flutter/material.dart';

class DialogTitle extends StatefulWidget {
  final EdgeInsets padding;
  final Duration animationDuration;
  final double normalFontSize;
  final double tinyFontSize;
  final CrossAxisAlignment titleAlignment;
  final bool withAnimatedContainerDivider;

  final String title;

  const DialogTitle(this.title,
      {Key? key,
      this.padding = const EdgeInsets.all(8),
      this.animationDuration = const Duration(milliseconds: 350),
      this.normalFontSize = 26,
      this.tinyFontSize = 18,
      this.titleAlignment = CrossAxisAlignment.stretch,
      this.withAnimatedContainerDivider = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DialogTitleState();
}

class DialogTitleState extends State<DialogTitle> {
  @override
  Widget build(BuildContext context) {
    bool isTiny = MediaQuery.of(context).size.height <= tinyHeight;
    return Column(
      mainAxisSize: MainAxisSize.min,
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
              child: Text(widget.title),
            ),
          ),
        ),
        if (widget.withAnimatedContainerDivider)
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            height: isTiny ? 15 : 30,
          )
      ],
    );
  }
}
