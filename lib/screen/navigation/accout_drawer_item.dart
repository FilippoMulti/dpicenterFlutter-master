import 'dart:convert';

import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:flutter/material.dart';

class AccountDrawerMenu extends StatefulWidget {
  const AccountDrawerMenu({
    Key? key,
    required this.menu,
    required this.onTap,
    required this.user,
  }) : super(key: key);

  final Menu menu;
  final Future Function()? onTap;
  final ApplicationUser user;

  @override
  AccountDrawerMenuState createState() => AccountDrawerMenuState();
}

class AccountDrawerMenuState extends State<AccountDrawerMenu>
    with AutomaticKeepAliveClientMixin<AccountDrawerMenu> {
  ImageProvider? imageProvider;

  @override
  void initState() {
    super.initState();

    createImageProvider(widget.user);
  }

  void createImageProvider(ApplicationUser user) {
    imageProvider = user.userDetails != null &&
            user.userDetails!.isNotEmpty &&
            user.userDetails![0].image != null
        ? Image.memory(
            base64Decode(user.userDetails![0].image!),
            filterQuality: FilterQuality.medium,
          ).image
        : (user.userDetails != null &&
                user.userDetails!.isNotEmpty &&
                user.userDetails![0].image != null &&
                user.userDetails![0].imageProvider != null)
            ? user.userDetails![0].imageProvider
            : null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(80)),
        child: InkWell(
          splashColor:
              Theme.of(navigatorKey!.currentContext!).colorScheme.primary,
          onTap: () async {
            var result = await widget.onTap?.call();
            if (result != null) {
              updateUser(result);
            }
          },
          child: ListTile(
              leading: widget.user.userDetails != null &&
                      widget.user.userDetails!.isNotEmpty &&
                      widget.user.userDetails![0].image != null
                  ? CircleAvatar(
                      backgroundImage: imageProvider,
                      backgroundColor: Theme.of(navigatorKey!.currentContext!)
                          .colorScheme
                          .primary,
                      radius: 20.0,
                    )
                  : const Icon(Icons.person),
              title: Text(
                widget.menu.label,
                style: const TextStyle(color: Colors.white),
              )),
        ));
  }

  void updateUser(ApplicationUser user) {
    setState(() {
      createImageProvider(user);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
