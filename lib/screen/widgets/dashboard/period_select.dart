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


import 'package:flutter/material.dart';

class MultiSelector extends StatelessWidget {
  const MultiSelector(
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

  /*late String id;
  late AppController appController;*/

  String _getStateDescription(int? state) {
    if (state != null) {
      if (selectorData.length < state) {
        return selectorData[state].periodString;
      }
    }
    return "Sconosciuto";
  }

  @override
  Widget build(BuildContext context) {
    final List<bool> isSelected =
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

      return Padding(
        padding: padding ?? const EdgeInsets.all(0.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleButtons(
              direction: direction,
              borderRadius: BorderRadius.circular(20),
              onPressed: onPressed,
              isSelected: isSelected,
              children: List<Widget>.generate(
                selectorData.length,
                (index) => Tooltip(
                  waitDuration: const Duration(milliseconds: 500),
                  message: selectorData[index].periodString,
                  child: selectorData[index].icon,

                  /*Icon(Icons.disabled_by_default,
                          color: _getColor(index, isSelected),
                          semanticLabel:
                          periodData[index].periodString,)*/
                ),
              ),
            ),
            if (showSelectedValueDescription ?? false)
              const SizedBox(
                width: 8,
              ),
            if (showSelectedValueDescription ?? false)
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

  Color _getColor(int? status, isSelected) {
    return Color.alphaBlend(
        Colors.primaries[status ?? 0].withAlpha(100), Colors.grey);
  }
}

class SelectorData {
  final String periodString;
  final Icon icon;

  const SelectorData({required this.periodString, required this.icon});
}
