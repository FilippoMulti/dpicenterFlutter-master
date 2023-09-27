import 'package:dpicenter/globals/globals.dart';
import 'package:flutter/material.dart';

class DialogHeader extends StatefulWidget {
  final Duration animationDuration;
  final double normalFontSize;
  final double tinyFontSize;
  final AlignmentGeometry titleAlignment;
  final EdgeInsetsGeometry? padding;
  final String title;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const DialogHeader(this.title,
      {Key? key,
      this.style,
      this.animationDuration = const Duration(milliseconds: 350),
      this.normalFontSize = 20,
      this.tinyFontSize = 14,
      this.titleAlignment = Alignment.centerLeft,
      this.padding,
      this.maxLines,
      this.overflow})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DialogHeaderState();
}

class DialogHeaderState extends State<DialogHeader> {
  @override
  Widget build(BuildContext context) {
    bool isTiny = MediaQuery.of(context).size.height <= tinyHeight;
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: 40,
        child: Align(
          alignment: widget.titleAlignment,
          child: AnimatedDefaultTextStyle(
            duration: widget.animationDuration,
            style: widget.style ??
                Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize:
                        isTiny ? widget.tinyFontSize : widget.normalFontSize),
            child: Text(
              widget.title,
              softWrap: true,
              maxLines: widget.maxLines,
              overflow: widget.overflow ?? TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
