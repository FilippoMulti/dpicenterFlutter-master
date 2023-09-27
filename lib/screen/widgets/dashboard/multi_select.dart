/*
part of 'tree_node_tile.dart';

class _NodeMultiSelector extends StatefulWidget {
  const _NodeMultiSelector({Key? key}) : super(key: key);

  @override
  _NodeMultiSelectorState createState() => _NodeMultiSelectorState();


}

class _NodeMultiSelectorState extends State<_NodeMultiSelector> {
  late String id;
  late AppController appController;
  final List<bool> isSelected = <bool>[true, false, false];

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    id = TreeNodeScope.of(context).node.id;
    appController = AppController.of(context);

    int? state = appController.nodeSelectionState(id);
    if (state!=null){
      for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
        if (buttonIndex == state) {
          isSelected[buttonIndex] = true;
        } else {
          isSelected[buttonIndex] = false;
        }
      }

    }
    return AnimatedBuilder(
        animation: appController,
        builder: (_, __) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ToggleButtons(

              borderRadius: BorderRadius.circular(20),
              children: <Widget>[
                Tooltip(
                  waitDuration: const Duration(milliseconds: 500),
                  message: 'Disabilita l\'operazione selezionata e tutte le operazioni figlie',
                    child: Icon(Icons.disabled_by_default, color: Color.alphaBlend(Theme.of(context).colorScheme.primary.withAlpha(100), isSelected[0] ? Colors.red : Colors.grey), semanticLabel: 'Disabilita l\'operazione selezionata e tutte le operazioni figlie')),

                Tooltip(
                    waitDuration: const Duration(milliseconds: 500),
                    message: 'Abilita alla sola lettura l\'operazione selezionata e tutte le operazioni figlie',
                    child: Icon(Icons.visibility, color: Color.alphaBlend(Theme.of(navigationScreenKey!.currentContext!).colorScheme.primary.withAlpha(100), isSelected[1] ? Colors.blueAccent : Colors.grey ), semanticLabel: 'Abilita alla sola lettura l\'operazione selezionata e tutte le operazioni figlie')),
                Tooltip(
                    waitDuration: const Duration(milliseconds: 500),
                    message: 'Abilita alla lettura e alla scrittura l\'operazione seleziona e tutte le operazioni figlie',
                    child: Icon(Icons.check, color: Color.alphaBlend(Theme.of(navigationScreenKey!.currentContext!).colorScheme.primary.withAlpha(100), isSelected[2] ? Colors.green : Colors.grey), semanticLabel: 'Abilita alla lettura e alla scrittura l\'operazione seleziona e tutte le operazioni figlie',)),
              ],
              onPressed: (int index) {
                appController.selectNode(TreeNodeScope.of(context).node, index);
                setState(() {
                  appController.setSelectionState(id, index);


                  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
            ),
          );

        }
    );

    */
/*,
        return RadioButt(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          activeColor: Colors.green.shade600,
          tristate: true,
          value: appController.isSelected(id),
          onChanged: (_) => appController.toggleSelection(id),
        );*/ /*



  }

}
*/

import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class MultiSelectorEx extends StatefulWidget {
  const MultiSelectorEx(
      {required this.selectorData,
      this.status,
      this.showSelectedValueDescription,
      this.padding,
      this.onPressed,
      this.direction = Axis.horizontal,
      Key? key})
      : super(key: key);

  final EdgeInsets? padding;
  final bool? showSelectedValueDescription;
  final List<SelectorData> selectorData;
  final int? status;
  final void Function(int index)? onPressed;
  final Axis direction;

  @override
  MultiSelectorExState createState() => MultiSelectorExState();
}

class MultiSelectorExState extends State<MultiSelectorEx> {
  int? status;
  late List<SelectorData> selectorData;

  @override
  void initState() {
    super.initState();
    status = widget.status;
    selectorData = widget.selectorData;
  }

  @override
  Widget build(BuildContext context) {
    List<bool> isSelected =
        List.generate(selectorData.length, (index) => false);

    return Builder(builder: (_) {
      if (status != null) {
        for (int buttonIndex = 0;
            buttonIndex < isSelected.length;
            buttonIndex++) {
          if (buttonIndex == status) {
            isSelected[buttonIndex] = true;
          } else {
            isSelected[buttonIndex] = false;
          }
        }
      } else {
        isSelected.fillRange(0, isSelected.length, false);
      }

      List<Widget>
          children = //_getSelectorDataChildren( startList: widget.selectorData,);

          List<Widget>.generate(
        selectorData.length,
        (index) => Container(
            color: selectorData[index].selectedColor,
            child: Stack(
              children: [
                if (selectorData[index].percentage != null)
                  SizedBox(
                    height: 50,
                    child: FAProgressBar(
                        borderRadius: BorderRadius.zero,
                        animatedDuration: const Duration(milliseconds: 750),
                        maxValue: 100,
                        changeColorValue: 100,
                        changeProgressColor: Colors.green.withAlpha(200),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withAlpha(100),
                        progressColor: selectorData[index].selectedColor!,
                        currentValue: selectorData[index].percentage ?? 0),
                  ),
                Tooltip(
                  waitDuration: const Duration(milliseconds: 500),
                  message: selectorData[index].periodString,
                  child: selectorData[index].child,
                ),
              ],
            )),
      );

      return Padding(
        padding: widget.padding ?? const EdgeInsets.all(0.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              type: MaterialType.card,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              shadowColor: Theme.of(context).shadowColor,
              child: ToggleButtons(
                selectedBorderColor: Theme.of(context).colorScheme.primary,
                highlightColor: Colors.black,
                selectedColor: Colors.white,
                fillColor: invert(
                    Theme.of(context).colorScheme.primary.value.toString()),
                //invert(Theme.of(context).colorScheme.primary.value.toString()),
                hoverColor: invert(
                    Theme.of(context).colorScheme.primary.value.toString()),
                direction: widget.direction,
                borderRadius: BorderRadius.circular(20),
                onPressed: (index) {
                  setState(() {
                    status = index;
                  });
                  widget.onPressed?.call(index);
                },
                isSelected: isSelected,
                children:
                    children, /*List<Widget>.generate(
                  widget.selectorData.length,
                      (index) => Container(
                    color: widget.selectorData[index].selectedColor,
                    child: Tooltip(
                      waitDuration: const Duration(milliseconds: 500),
                      message: widget.selectorData[index].periodString,
                      child: widget.selectorData[index].child,
                    ),
                  ),
                ),*/
              ),
            ),
            if (widget.showSelectedValueDescription ?? false)
              const SizedBox(
                width: 8,
              ),
            if (widget.showSelectedValueDescription ?? false)
              Text(_getStateDescription(status),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: _getColor(status, isSelected))),
          ],
        ),
      );
    });
  }

  List<Widget> _getSelectorDataChildren(
      {required List<SelectorData> startList, List<Widget>? children}) {
    children ??= <Widget>[];
    for (int index = 0; index < startList.length; index++) {
      SelectorData data = startList[index];
      if (data.dataChildren == null) {
        children.add(Container(
          color: data.selectedColor,
          child: Tooltip(
            waitDuration: const Duration(milliseconds: 500),
            message: data.periodString,
            child: data.child,
          ),
        ));
      } else {
        /*children.add(Container(
          color: data.selectedColor,
          child: Tooltip(
            waitDuration: const Duration(milliseconds: 500),
            message: data.periodString,
            child: MultiExpansionPanelList(
              expansionCallback: (index, expanded){
                switch(index){
                  case 0:
                  default:
                    setState((){
                      startList[index] = SelectorData(periodString: data.periodString, child: data.child, selectedColor: data.selectedColor, dataChildren: data.dataChildren, isExpanded: expanded,);
                    });
                  break;
                }
              },
              children: [
                MultiExpansionPanel(
                    isExpanded: data.isExpanded,

                    headerBuilder: (context, item){
                  return data.child;
                }, body: Column(
                  children:
                    _getSelectorDataChildren(startList: data.dataChildren!).map((e) => Expanded(child: e)).toList(growable: false)
                ))
              ],
            )
          ),
        ));*/
        children.add(Container(
          color: data.selectedColor,
          child: Tooltip(
            waitDuration: const Duration(milliseconds: 500),
            message: data.periodString,
            child: data.child,
          ),
        ));
        children.addAll(_getSelectorDataChildren(startList: data.dataChildren!)
            .map((e) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: e,
                )));
        /*AnimatedContainer(duration: const Duration(milliseconds: 500),
            child: Tooltip(
              waitDuration: const Duration(milliseconds: 500),
              message: data.periodString,
              child:  MultiSelectorEx(
              direction: widget.direction,
              //key: _multiSelectorKey,
              onPressed: (index) async {
                widget.onPressed?.call(index);
              },
              status: widget.status,
              selectorData: data.dataChildren!),
            )
            ) );*/

      }
    }
    return children;
  }

  String _getStateDescription(int? state) {
    if (state != null) {
      if (widget.selectorData.length < state) {
        return widget.selectorData[state].periodString;
      }
    }
    return "Sconosciuto";
  }

  Color _getColor(int? status, isSelected) {
    return Color.alphaBlend(
        Colors.primaries[status ?? 0].withAlpha(100), Colors.grey);
  }
}

class SelectorData extends StatelessWidget {
  final String periodString;
  final Widget child;
  final Color? selectedColor;
  final List<SelectorData>? dataChildren;
  final bool isExpanded;
  final double? percentage;
  final int? elementCount;

  const SelectorData(
      {Key? key,
      required this.periodString,
      required this.child,
      this.selectedColor,
      this.dataChildren,
      this.isExpanded = false,
      this.percentage,
      this.elementCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
