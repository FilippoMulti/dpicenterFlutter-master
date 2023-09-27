import 'package:dpicenter/models/server/hashtag.dart';
import 'package:flutter/material.dart';
import 'package:dpicenter/extensions/color_extension.dart';

class HashTagItem extends StatefulWidget {
  const HashTagItem({
    Key? key,
    required this.hashTag,
    required this.selected,
    required this.onSelected,
    this.fontSize,
    this.letterSpacing,
    this.labelPadding,
    this.padding,
    this.fontWeight,
    this.visualDensity,
  }) : super(key: key);

  final Function() selected;
  final Function(bool) onSelected;
  final double? fontSize;
  final double? letterSpacing;
  final EdgeInsets? labelPadding;
  final EdgeInsets? padding;
  final FontWeight? fontWeight;
  final VisualDensity? visualDensity;
  final HashTag hashTag;

  @override
  _HashTagItemState createState() => _HashTagItemState();
}

class _HashTagItemState extends State<HashTagItem>
    with AutomaticKeepAliveClientMixin<HashTagItem> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return getHashTagItem();
  }

  Widget getHashTagItem() {
    try {
      return FilterChip(
          //padding: EdgeInsets.zero,
          visualDensity: widget.visualDensity,
          labelPadding: widget.labelPadding,
          padding: widget.padding,
          backgroundColor: Color(int.parse(widget.hashTag.color!)),
          label: Text(
              widget.hashTag.name!.isEmpty
                  ? 'ESEMPIO'
                  : widget.hashTag.name!.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: hashTagTextStyle(Color(int.parse(widget.hashTag.color!)),
                  fontSize: widget.fontSize,
                  letterSpacing: widget.letterSpacing,
                  fontWeight: widget.fontWeight)),
          selected: widget.selected.call(),
          selectedColor: Color(int.parse(widget.hashTag.color!)).lighten(),
          onSelected: widget.onSelected);
    } catch (e) {
      return Text(e.toString());
    }
  }

  TextStyle hashTagTextStyle(Color tagColor,
      {double? fontSize, double? letterSpacing, FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        color: tagColor.computeLuminance() > 0.5 ? Colors.black : Colors.white);
  }
}
