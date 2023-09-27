import 'dart:convert';

import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:flutter/material.dart';

class ApplicationUserItem extends StatefulWidget {
  const ApplicationUserItem({
    Key? key,
    required this.user,
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
  final ApplicationUser user;

  @override
  _ApplicationUserItemState createState() => _ApplicationUserItemState();
}

class _ApplicationUserItemState extends State<ApplicationUserItem>
    with AutomaticKeepAliveClientMixin<ApplicationUserItem> {
  @override
  bool get wantKeepAlive => true;

  late ImageProvider? imageProvider;

  final GlobalKey _filterChipKey = GlobalKey(debugLabel: '_filterChipKey');
  final GlobalKey _circleAvatarKey = GlobalKey(debugLabel: '_circleAvatarKey');

  @override
  void initState() {
    super.initState();
/*    imageProvider = (widget.user.userDetails != null &&
        widget.user.userDetails!.isNotEmpty &&
        widget.user.userDetails![0].thumbImage != null &&
        widget.user.userDetails![0].imageProvider == null)
        ? Image.memory(base64Decode(widget.user.userDetails![0].thumbImage!)).image
        : null;*/

    imageProvider = (widget.user.userDetails != null &&
            widget.user.userDetails!.isNotEmpty &&
            widget.user.userDetails![0].image != null &&
            widget.user.userDetails![0].imageProvider == null)
        ? Image.memory(
            base64Decode(widget.user.userDetails![0].image!),
            filterQuality: FilterQuality.medium,
            isAntiAlias: true,
          ).image
        : (widget.user.userDetails != null &&
                widget.user.userDetails!.isNotEmpty &&
                widget.user.userDetails![0].image != null &&
                widget.user.userDetails![0].imageProvider != null)
            ? widget.user.userDetails![0].imageProvider
            : null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return getOperatorItem();
  }

  Widget getOperatorItem() {
    print(
        "image.lenght: ${widget.user.userDetails?[0].image?.length.toString()}");
    try {
      return FilterChip(
          key: _filterChipKey,
          visualDensity: widget.visualDensity,
          labelPadding: widget.labelPadding,
          padding: widget.padding,
          avatar: CircleAvatar(
              key: _circleAvatarKey,
              backgroundColor: Colors.transparent,
              backgroundImage: imageProvider,
              child: widget.user.userDetails != null &&
                      widget.user.userDetails!.isNotEmpty &&
                      widget.user.userDetails![0].image != null
                  ? null
                  : Icon(
                      Icons.person,
                      color: isDarkTheme(context) ? Colors.white : Colors.black,
                      size: 20,
                    )),
          backgroundColor: Theme.of(context).chipTheme.backgroundColor,
          selectedColor: Theme.of(context).colorScheme.primary,
          //Color(int.parse(tag.color!)),
          label: SizedBox(
            height: 20,
            child: Center(
              child: Text(
                widget.user.userName == null || widget.user.userName!.isEmpty
                    ? 'ESEMPIO'
                    : '${widget.user.name!.toUpperCase()} ${widget.user.surname!.toUpperCase()}',
                overflow: TextOverflow.ellipsis,
                style: operatorTextStyle(
                    fontSize: widget.fontSize,
                    letterSpacing: widget.letterSpacing,
                    fontWeight: widget.fontWeight),
              ),
            ),
          ),
          selected: widget.selected.call(),
          showCheckmark: false,
          //selectedColor: Color(int.parse(tag.color!)).lighten(),
          onSelected: widget.onSelected);
    } catch (e) {
      return Text(e.toString());
    }
  }

  TextStyle operatorTextStyle(
      {double? fontSize, double? letterSpacing, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight:
          fontWeight, /* color: tagColor.computeLuminance() > 0.5 ? Colors.black : Colors.white*/
    );
  }
}
