import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatefulWidget {
  const DrawerItem(
      {required this.menu,
      this.onPressed,
      this.onClosePressed,
      this.isOpen = false,
      Key? key})
      : super(key: key);

  final bool isOpen;
  final Menu menu;
  final Function(Menu menu)? onPressed;
  final Function(Menu menu)? onClosePressed;

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  bool get isWebMobileA =>
      isWebMobile || MediaQuery.of(context).size.width < 400;

  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
      child: Center(
          child: SizedBox(
              height: 120,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  child: MaterialButton(
                      hoverElevation: 0,
                      elevation: 0,
                      hoverColor: isLightTheme(context)
                          ? Color.alphaBlend(
                              Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withAlpha(180),
                              Theme.of(context).colorScheme.primary)
                          : Color.alphaBlend(
                                  Theme.of(context).canvasColor.withAlpha(100),
                                  Theme.of(context).colorScheme.primary)
                              .withAlpha(100),
                      color: isDarkTheme(context)
                          ? Color.alphaBlend(
                              Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withAlpha(240),
                              Theme.of(context).colorScheme.primary)
                          : Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      //side: BorderSide(color: Color.fromARGB(255, 197, 197, 246), width: 0.1)

                      onPressed: () {
                        widget.onPressed?.call(widget.menu);
                        /*if (isWebMobileA) {
                          Navigator.pushNamed(context, widget.menu.destination!,
                              arguments: widget.menu);
                        } else {
                          setState(() {
                            selectMenu(widget.menu);
                            //selectedMenu = menu;
                          });
                        }*/
                        /*   setState(() {
                          //selectedMenu = menu;
                          selectMenu(menu);
                        });*/
                      },
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                  child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 350),
                                      padding: widget.isOpen
                                          ? const EdgeInsets.all(5)
                                          : const EdgeInsets.all(0),
                                      //margin: isOpen ? const EdgeInsets.all(5) : null,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          //border: isOpen ? Border.all(color: Colors.greenAccent, width: 5) : null,
                                          //color: getMenuColor(menu.color)
                                          gradient: LinearGradient(
                                            colors: [
                                              getMenuColor(widget.menu.color)!,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                            ],
                                            tileMode: TileMode.decal,
                                          )),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            //border: isOpen ? Border.all(color: Colors.greenAccent, width: 5) : null,
                                            color: getMenuColor(
                                                widget.menu.color)),
                                        child: Icon(
                                          icons[widget.menu.icon],
                                          color:
                                              (getMenuColor(widget.menu.color)
                                                              as Color)
                                                          .computeLuminance() >
                                                      0.5
                                                  ? Colors.black
                                                  : Colors.white,
                                        ),
                                      ))),
                              const SizedBox(
                                height: 8,
                              ),
                              Center(
                                child: Text(
                                  widget.menu.label,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),
                          if (hover && widget.isOpen)
                            Positioned(
                              width: 32,
                              height: 32,
                              right: 8,
                              top: 8,
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                      tooltip: 'Chiude la finestra',
                                      padding: EdgeInsets.zero,
                                      onPressed: widget.onClosePressed != null
                                          ? () {
                                              widget.onClosePressed
                                                  ?.call(widget.menu);
                                            }
                                          : null,
                                      icon: Icon(Icons.clear,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error))),
                            )
                        ],
                      ))))),
    );
  }
}
