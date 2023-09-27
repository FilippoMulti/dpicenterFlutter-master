
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/icons/material.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/screen/widgets/treeview/common/snackbar.dart';
import 'package:dpicenter/screen/widgets/treeview/treeview_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';


part '_selector.dart';

part '_title.dart';

part '_selector_multi.dart';

const Color _kDarkBlue = Color(0xFF1565C0);

const RoundedRectangleBorder kRoundedRectangleBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

class TreeNodeTile extends StatefulWidget {
  const TreeNodeTile({required this.menu, Key? key}) : super(key: key);

  final Menu menu;

  @override
  _TreeNodeTileState createState() => _TreeNodeTileState();
}

class _TreeNodeTileState extends State<TreeNodeTile> {
  @override
  Widget build(BuildContext context) {
    final appController = AppController.of(context);
    final nodeScope = TreeNodeScope.of(context);
    // print ('menuId: ${widget.menu.menuId}');
    return InkWell(
      onTap: () => appController.treeController.toggleExpanded(nodeScope.node),
      onLongPress: () => appController.setSelectionState(nodeScope.node.id, 2),
      child: ValueListenableBuilder<ExpansionButtonType>(
        valueListenable: appController.expansionButtonType,
        builder: (context, ExpansionButtonType buttonType, __) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: buttonType == ExpansionButtonType.folderFile
                  ? [
                      const LinesWidget(),
                      NodeWidgetLeadingIcon(
                        useFoldersOnly: false,
                        leafIcon: Icon(Icons.tune,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 16),
                        expandIcon: Icon(icons[widget.menu.icon],
                            key: ValueKey(widget.menu.menuId)),
                        collapseIcon: Icon(icons[widget.menu.icon],
                            key: ValueKey('O${widget.menu.menuId}'), size: 16),
                        onPressed: () {},
                      ),
                      //const _NodeActionsChip(),
                      const _NodeTitle(),
                      const SizedBox(width: 8),
                      const NodeMultiSelector(),
                      const SizedBox(width: 8),
                      //const Expanded(child: _NodeTitle()),
                    ]
                  : const [
                      LinesWidget(),
                      SizedBox(width: 4),
                      //_NodeActionsChip(),
                      _NodeSelector(),
                      SizedBox(width: 8),
                      Expanded(child: _NodeTitle()),
                      ExpandNodeIcon(expandedColor: _kDarkBlue),
                    ],
            ),
          );
        },
      ),
    );
  }

  void _describeAncestors(TreeNode node) {
    final ancestors = node.ancestors.map((ancestor) => ancestor.id).join('/');

    showSnackBar(
      context,
      'Path of "${node.label}": /$ancestors/${node.id}',
      duration: const Duration(seconds: 3),
    );
  }
}
