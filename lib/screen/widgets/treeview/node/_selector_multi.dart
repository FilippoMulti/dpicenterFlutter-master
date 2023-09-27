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
part of 'tree_node_tile.dart';

class NodeMultiSelector extends StatelessWidget {
  const NodeMultiSelector({Key? key}) : super(key: key);

  /*late String id;
  late AppController appController;*/

  String _getStateDescription(int? state) {
    switch (state) {
      case 1:
        return "Sola lettura";
      case 2:
        return "Abilitato";
      case 3:
        return "Abilitato (Misto)";
      case 0:
      case null:
      default:
        return "Disabilitato";
    }
  }

  String getStatusDescription(TreeNode node, AppController controller) {
    return _getStateDescription(getStatus(node, controller));
  }

  static int? getStatus(TreeNode node, AppController controller) {
    if (node.hasChildren) {
      //debugger(when: int.parse(node.id) == 5);

      if (node.descendants.length > 1) {
        if (node.descendants.every((element) =>
                controller.nodeSelectionState(element.id) == null ||
                controller.nodeSelectionState(element.id) == 0) ||
            node.descendants.every(
                (element) => controller.nodeSelectionState(element.id) == 1) ||
            node.descendants.every(
                (element) => controller.nodeSelectionState(element.id) == 2)) {
          for (var element in node.descendants) {
            print(
                "node: ${node.id} ${node.label} - descendants: parent ${element.parent?.label ?? ''} ${element.id} ${element.label} - status: ${controller.nodeSelectionState(node.id)}");
          }

          return controller.nodeSelectionState(node.id);
        } else {
          for (var element in node.descendants) {
            print(
                "node: ${node.id} ${node.label} - descendants: parent ${element.parent?.label ?? ''} ${element.id} ${element.label} - status: 3");
          }

          return 3;
        }
      } else if (node.descendants.length == 1) {
        for (var element in node.descendants) {
          print(
              "node: ${node.id} ${node.label} - descendants: parent ${element.parent?.label ?? ''} ${element.id} ${element.label} - status: ${controller.nodeSelectionState(node.descendants.first.id)}");
        }

        return controller.nodeSelectionState(node.descendants.first.id);
      }
    }
    for (var element in node.descendants) {
      print(
          "node: ${node.id} ${node.label} - descendants: parent ${element.parent?.label ?? ''} ${element.id} ${element.label} - status: ${controller.nodeSelectionState(node.id)}");
    }

    return controller.nodeSelectionState(node.id);
  }

  @override
  Widget build(BuildContext context) {
    final List<bool> isSelected = <bool>[true, false, false];
    final id = TreeNodeScope.of(context).node.id;
    final appController = AppController.of(context);
    final node = TreeNodeScope.of(context).node;
    if (node.hasChildren) {
      //la descrizione dello stato si basa sullo stato dei figli
      //i figli a loro volta potrebbero avere figli
    }
    return AnimatedBuilder(
        animation: appController,
        builder: (_, __) {
          int? state = getStatus(node, appController);

          if (state != null) {
            for (int buttonIndex = 0;
                buttonIndex < isSelected.length;
                buttonIndex++) {
              if (buttonIndex == state) {
                isSelected[buttonIndex] = true;
              } else {
                isSelected[buttonIndex] = false;
              }
            }
          } else {
            isSelected[0] = true; //disabilitato
            isSelected[1] = false; //sola lettura
            isSelected[2] = false; //abilitato
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(20),
                  onPressed: (int index) {
                    appController.selectNode(
                        TreeNodeScope.of(context).node, index);
                    appController.setSelectionState(id, index);
                    /*setState(() {
                      appController.setSelectionState(id, index);


                      for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                        if (buttonIndex == index) {
                          isSelected[buttonIndex] = true;
                        } else {
                          isSelected[buttonIndex] = false;
                        }
                      }
                    });*/
                  },
                  isSelected: isSelected,
                  children: <Widget>[
                    Tooltip(
                        waitDuration: const Duration(milliseconds: 500),
                        message:
                            'Disabilita l\'operazione selezionata e tutte le operazioni figlie',
                        child: Icon(Icons.disabled_by_default,
                            color: _getColor(0, isSelected),
                            semanticLabel:
                                'Disabilita l\'operazione selezionata e tutte le operazioni figlie')),
                    Tooltip(
                        waitDuration: const Duration(milliseconds: 500),
                        message:
                            'Abilita alla sola lettura l\'operazione selezionata e tutte le operazioni figlie',
                        child: Icon(Icons.visibility,
                            color: _getColor(1, isSelected),
                            semanticLabel:
                                'Abilita alla sola lettura l\'operazione selezionata e tutte le operazioni figlie')),
                    Tooltip(
                        waitDuration: const Duration(milliseconds: 500),
                        message:
                            'Abilita alla lettura e alla scrittura l\'operazione seleziona e tutte le operazioni figlie',
                        child: Icon(
                          Icons.check,
                          color: _getColor(2, isSelected),
                          semanticLabel:
                              'Abilita alla lettura e alla scrittura l\'operazione seleziona e tutte le operazioni figlie',
                        )),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(getStatusDescription(node, appController),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getColor(
                            getStatus(node, appController), isSelected))),
              ],
            ),
          );
        });

    /*,
        return RadioButt(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          activeColor: Colors.green.shade600,
          tristate: true,
          value: appController.isSelected(id),
          onChanged: (_) => appController.toggleSelection(id),
        );*/
  }

  Color _getColor(int? status, isSelected) {
    switch (status) {
      case 1:
        return Color.alphaBlend(
            Theme.of(navigationScreenKey!.currentContext!)
                .colorScheme
                .primary
                .withAlpha(100),
            isSelected[1] ? Colors.blueAccent : Colors.grey);
      case 2:
        return Color.alphaBlend(
            Theme.of(navigationScreenKey!.currentContext!)
                .colorScheme
                .primary
                .withAlpha(100),
            isSelected[2] ? Colors.green : Colors.grey);
      case 3:
        return Color.alphaBlend(
            Theme.of(navigationScreenKey!.currentContext!)
                .colorScheme
                .primary
                .withAlpha(100),
            Colors.green);
      case 0:
      case null:
      default:
        return Color.alphaBlend(
            Theme.of(navigationScreenKey!.currentContext!)
                .colorScheme
                .primary
                .withAlpha(100),
            isSelected[0] ? Colors.red : Colors.grey);
    }
  }
}
