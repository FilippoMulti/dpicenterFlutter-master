import 'package:dpicenter/extensions/type_extension.dart';
import 'package:dpicenter/globals/navigation_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/screen/useful/size_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DashboardMenuConfig extends StatefulWidget {
  final Menu dashboardMenu;

  const DashboardMenuConfig({Key? key, required this.dashboardMenu})
      : super(key: key);

  @override
  _DashboardMenuConfigState createState() => _DashboardMenuConfigState();
}

class _DashboardMenuConfigState extends State<DashboardMenuConfig> {
  List<Menu> listA = <Menu>[];
  List<Menu> listB = <Menu>[];

  double oldlistASize = 0;
  double listASize = 0;
  double oldlistBSize = 0;
  double listBSize = 0;

  bool _showDragPointListA = false;
  bool _showDragPointListB = false;

  @override
  void initState() {
    super.initState();
    listA = widget.dashboardMenu.subMenus!;
    Menu menu = Menu.load().toDestinationAndCommands();

    listB = menu.subMenus!.whereNotIn(listA).toList();

    if (kDebugMode) {
      print("A: ${listA.length}");
      print("B: ${listB.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var result = getDashboardIconAndFontSize(context);
    double dashboardHeight = getDashboardHeight(context);
    double iconSize = result[0];
    double fontSize = result[1];

    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
              child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                    child: Text("Menu selezionati",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize)))),
//            list view separated will build a widget between 2 list items to act as a separator
            SizedBox(
                height: dashboardHeight,
                child: AnimationLimiter(
                    key: const ValueKey("keyA"),
                    child: OrientationBuilder(builder:
                        (BuildContext context, Orientation orientation) {
                      return SizeProviderWidget(
                          onChildSize: (size) {
                            if (oldlistASize != size.longestSide) {
                              oldlistASize = size.longestSide;
                              setState(() {
                                if (kDebugMode) {
                                  print("onChildSizeA");
                                }
                                listASize = size.longestSide;
                              });
                            }
                          },
                          child:

/*
                    AnimatedList(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index, animation) => _buildListItemsWithSeparators(context, index, fontSize, iconSize, listA,listA,listB),
                      initialItemCount: (listA.length*2) + 2,
                    )
*/
                              ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => _buildListItems(
                                context, index, fontSize, iconSize, listA, 0),
                            separatorBuilder: (context, index) =>
                                _buildDragTargets(context, index, fontSize,
                                    iconSize, listA, listB, listASize, 0),
                            itemCount: listA.length + 2,
                          ));
                    }))),

            Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                    child: Text("Menu disponibili",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize)))),
            SizedBox(
                height: dashboardHeight,
                child: AnimationLimiter(
                    key: const ValueKey("keyB"),
                    child: OrientationBuilder(builder:
                        (BuildContext context, Orientation orientation) {
                      return SizeProviderWidget(
                          onChildSize: (size) {
                            if (oldlistBSize != size.longestSide) {
                              oldlistBSize = size.longestSide;
                              setState(() {
                                if (kDebugMode) {
                                  print("onChildSizeB");
                                }

                                listBSize = size.longestSide;
                              });
                            }
                          },
                          child:

/*
                    AnimatedList(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index, animation) => _buildListItemsWithSeparators(context, index, fontSize, iconSize, listA,listA,listB),
                      initialItemCount: (listA.length*2) + 2,
                    )
*/
                              ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => _buildListItems(
                                context, index, fontSize, iconSize, listB, 1),
                            separatorBuilder: (context, index) =>
                                _buildDragTargets(context, index, fontSize,
                                    iconSize, listB, listA, listBSize, 1),
                            itemCount: listB.length + 2,
                          ));
                    }))),
          ],
        ),
      )))),
    );
  }

  /*Widget getDashboardItem(Menu menu, double fontSize, double iconSize) {
   return Material(
            type: MaterialType.transparency,
            child: Container(
                child: Column(children: [
                  Padding(padding:EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child:
                      Container(

                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Padding(padding:EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Text(menu.text))
                      )
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: menu.color,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(iconSize + 5)),
                    onPressed: () {
                      //_menuClick(menu);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //Center Column contents vertically,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          menu.icon,
                          size: 32,
                        ),
                        Icon(
                          menu.overlayIcon,
                          size: 32,
                        )
                      ],
                    ),
*/ /*
                        Expanded(
                          child: Text(
                            menu.text,
                            style: TextStyle(
                              fontSize: fontSize,
                              overflow: TextOverflow.clip,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
*/ /*
                  ),


                ])));
  }*/
//  builds the widgets for List B items
  /*Widget _buildListBItems(BuildContext context, int index) {
    if (index == 0 || index == listB.length + 1) return const SizedBox.shrink();
    return Draggable<String>(
//      the value of this draggable is set using data
      data: listB[index-1],
//      the widget to show under the users finger being dragged
      feedback: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listB[index-1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
//      what to display in the child's position when being dragged
      childWhenDragging: Card(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listB[index-1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
//      widget in idle state
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listB[index-1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
*/
  Widget _buildListItems(BuildContext context, int index, double fontSize,
      double iconSize, List list, int listAorB) {
    if (index == 0 || index == list.length + 1) return const SizedBox.shrink();
    Menu menu = list[index - 1];
    return AnimationConfiguration.staggeredList(
      key: ValueKey(index),
      position: index,
      duration: const Duration(milliseconds: 375),
      child: ScaleAnimation(
        child: FadeInAnimation(
            child: LongPressDraggable<Menu>(
//      the value of this draggable is set using data
                data: menu,
                onDragStarted: () => setState(() => listAorB == 0
                    ? _showDragPointListB = true
                    : _showDragPointListA = true),
                onDragEnd: (details) => setState(() => listAorB == 0
                    ? _showDragPointListB = false
                    : _showDragPointListA = false),
                onDraggableCanceled: (velocity, offset) => setState(() =>
                    listAorB == 0
                        ? _showDragPointListB = false
                        : _showDragPointListA = false),
                onDragCompleted: () => setState(() => listAorB == 0
                    ? _showDragPointListB = false
                    : _showDragPointListA = false),

//      the widget to show under the users finger being dragged
                feedback: AnimationConfiguration.synchronized(
                  child: ScaleAnimation(
                    scale: 1.2,
                    child: getDashboardItem(menu, fontSize, iconSize, null),
                  ),
                ),
                dragAnchorStrategy: childDragAnchorStrategy,
//      what to display in the child's position when being dragged
                childWhenDragging: Stack(
                  children: [
                    //getDashboardItem(menu, fontSize, iconSize, null),
                    Container(color: Colors.red.withAlpha(30)),
                  ],
                ),
//      widget in idle state
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: getDashboardItem(menu, fontSize, iconSize, null),
                ))),
      ),
    );
  }

/*
  Widget _buildListItemsWithSeparatorsA(BuildContext context, int index,
      double fontSize, double iconSize, List<Menu> list) {
    if (index == 0 || index == list.length + 1) return SizedBox.shrink();
    print("_buildListItemsWithSeparatorsA");
    if ((index % 2) == 0) {
      return _buildDragTargets(
          context, index, fontSize, iconSize, listA, listB, listASize, 0);
    }

    double i = index - ((index + 1) / 2);

    return _buildListItems(context, i as int, fontSize, iconSize, list, 0);
  }

  Widget _buildListItemsWithSeparators(
      BuildContext context,
      int index,
      double fontSize,
      double iconSize,
      List<Menu> list,
      List<Menu> listAdd,
      List<Menu> listRemove) {
    if (index == 0 || index == list.length + 1) {
      if (list.length == 0) {
        Stack(
          children: [
            Container(
              color: Colors.white.withAlpha(50),
              width: listASize,
              height: MediaQuery.of(context).size.height,
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    }

    print("_buildListItemsWithSeparatorsB");
    if ((index % 2) == 0) {
      return _buildDragTargets(context, index, fontSize, iconSize, listAdd,
          listRemove, listBSize, 1);
    }

    double i = index - ((index + 1) / 2);

    return _buildListItems(context, i as int, fontSize, iconSize, list, 1);
  }
*/

//  builds the widgets for List A items
  /*Widget _buildListAItems(BuildContext context, int index) {
    if (index == 0 || index == listA.length + 1) return const SizedBox.shrink();

    return Draggable<String>(
      data: listA[index-1],
      feedback: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listA[index-1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      childWhenDragging: Container(
        color: Colors.grey,
        width: 40,
        height: 40,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listA[index-1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }*/

//  will return a widget used as an indicator for the drop position
  Widget _buildDropPreview(
      BuildContext context, Menu menu, double fontSize, double iconSize) {
    return getDashboardItem(menu, fontSize, iconSize, null);
  }

  Widget _dragContainer(double width, String text, [bool withColor = true]) {
    return Container(
        decoration: BoxDecoration(
            color: withColor ? Colors.white.withAlpha(50) : Colors.transparent,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(10)),
        width: width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: Text(text)));
  }

//  builds DragTargets used as separators between list items/widgets for list A
  Widget _buildDragTargets(
      BuildContext context,
      int index,
      double fontSize,
      double iconSize,
      List<Menu> listAdd,
      List<Menu> listRemove,
      double listSize,
      int listAorB) {
    return DragTarget<Menu>(
//      builder responsible to build a widget based on whether there is an item being dropped or not
      builder: (context, candidates, rejects) {
        if (candidates.isNotEmpty) {
          if (listAdd.isEmpty) {
            return Stack(
              children: [
                _dragContainer(listSize, ""),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildDropPreview(
                        context, candidates[0]!, fontSize, iconSize))
              ],
            );
          } else {
            return Padding(
                padding: const EdgeInsets.all(8),
                child: _buildDropPreview(
                    context, candidates[0]!, fontSize, iconSize));
          }
        }

        //print("listAdd.lenght: " + listA.length.toString());
        if (listAdd.isEmpty) {
          return _dragContainer(listSize, "Trascina qui");
        }
        if (index == listAdd.length) {
          return _dragContainer(50, "+");
        }

        switch (listAorB) {
          case 0:
            return _showDragPointListA
                ? _dragContainer(10, "+", true)
                : _dragContainer(10, "", false);

          case 1:
          default:
            return _showDragPointListB
                ? _dragContainer(10, "+", true)
                : _dragContainer(10, "", false);
        }

        /*return Container(
          width: 10,
          height: 10,
        );*/
      },
//      condition on to accept the item or not
      onWillAccept: (value) => !listAdd.contains(value),
//      what to do when an item is accepted
      onAccept: (value) {
        setState(() {
          listAdd.insert(index, value);
          listRemove.remove(value);
        });
      },
    );
  }
/*Widget scaleIt(BuildContext context, int index, animation) {
    int item = _items[index];
    TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: SizedBox( // Actual widget to display
        height: 128.0,
        child: Card(
          color: Colors.primaries[item % Colors.primaries.length],
          child: Center(
            child: Text('Item $item', style: textStyle),
          ),
        ),
      ),
    );
  }*/
/*//  builds drag targets for list B
  Widget _buildDragTargetsB(BuildContext context, int index) {

    return DragTarget<String>(
      builder: (context, candidates, rejects) {
        return candidates.length > 0 ? _buildDropPreview(context, candidates[0]!):
        Container(
          width: 10,
          height: 10,
        );
      },
      onWillAccept: (value)=>!listB.contains(value),
      onAccept: (value) {
        setState(() {
          listB.insert(index, value);
          listA.remove(value);
        });
      },
    );
  }*/
}
