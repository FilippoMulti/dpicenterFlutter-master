import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_profile_enabled_menu.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:collection/collection.dart';

enum ExpansionButtonType { folderFile, chevron }

class AppController with ChangeNotifier {
  bool _isInitialized = false;

  List<ApplicationProfileEnabledMenu>? initialValue;

  AppController({this.initialValue});

  bool get isInitialized => _isInitialized;

  static AppController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppControllerScope>()!
        .controller;
  }

  Future<void> init() async {
    if (_isInitialized) return;

    final rootNode = TreeNode(id: kRootId);
    generateSampleTree(rootNode);

    treeController = TreeViewController(
      rootNode: rootNode,
    );

    _isInitialized = true;
  }

  Future<void> initMenus() async {
    if (_isInitialized) return;

/*    if (currentMenu!=null){
      var currentList = currentMenu!.toPlainList();
      var actualMenu = Menu.loadWithoutDashboard().toPlainList();
      for (var menu in actualMenu){
        menu = currentList.firstWhere((element) => element.menuId==menu.menuId);
      }
    }
    currentMenu ??= Menu.loadWithoutDashboard();*/
    var baseMenu = Menu.loadWithoutDashboard();
    if (initialValue != null) {
      updateBaseMenu(baseMenu.subMenus!, initialValue!);
    }

    final rootNode = baseMenu.generateTreeNodes();

    treeController = TreeViewController(
      rootNode: rootNode,
    );

    _isInitialized = true;
  }

  //* == == == == == TreeView == == == == ==

  late final Map<String, bool> _selectedNodes = {};

  bool? isSelected(String id) => _selectedNodes[id];

  void toggleSelection(String id, [bool? shouldSelect]) {
    shouldSelect ??= !(isSelected(id) ?? false);
    shouldSelect ? _select(id) : _deselect(id);

    notifyListeners();
  }

  void _select(String id) => _selectedNodes[id] = true;

  void _deselect(String id) => _selectedNodes.remove(id);

  void selectAll([bool select = true]) {
    if (select) {
      for (var descendant in rootNode.descendants) {
        _selectedNodes[descendant.id] = true;
      }
    } else {
      for (var descendant in rootNode.descendants) {
        _selectedNodes.remove(descendant.id);
      }
    }
    notifyListeners();
  }

  late final Map<String, int> _nodeSelectionState = {};

  int? nodeSelectionState(String id) => _nodeSelectionState[id];

  void updateBaseMenu(
      List<Menu> baseMenuList, List<ApplicationProfileEnabledMenu> valueItems) {
    for (int index = 0; index < baseMenuList.length; index++) {
      Menu menu = baseMenuList[index];

      ApplicationProfileEnabledMenu? menuFounded = valueItems
          .firstWhereOrNull((element) => element.menu?.menuId == menu.menuId);
      if (menuFounded != null) {
        if (menuFounded.status != null) {
          setSelectionState(menu.menuId.toString(), menuFounded.status!);
        }
      }
      if (menu.subMenus != null && menu.subMenus!.isNotEmpty) {
        updateBaseMenu(menu.subMenus!, valueItems);
      }
    }
  }

  void setSelectionState(String id, int state) {
    if (!_nodeSelectionState.containsKey(id)) {
      _nodeSelectionState.addAll({id: state});
    } else {
      _nodeSelectionState[id] = state;
    }

    notifyListeners();
  }

  void selectNode(node, [int select = 0]) {
    //if (select) {
    node.descendants.forEach(
      (descendant) {
        if (_nodeSelectionState.containsKey(descendant.id)) {
          _nodeSelectionState[descendant.id] = select;
        } else {
          _nodeSelectionState.addAll({descendant.id: select});
        }
      },
    );
    //} else {
    //  rootNode.children.forEach(
    //        (descendant) => _selectedNodes.remove(descendant.id),
    //  );

    notifyListeners();
  }

  TreeNode get rootNode => treeController.rootNode;

  late final TreeViewController treeController;

  //* == == == == == Scroll == == == == ==

  final nodeHeight = 40.0;

  late final scrollController = ScrollController();
  late final horizontalScrollController = ScrollController();

  void scrollTo(TreeNode node) {
    final nodeToScroll = node.parent == rootNode ? node : node.parent ?? node;
    final offset = treeController.indexOf(nodeToScroll) * nodeHeight;

    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  //* == == == == == General == == == == ==

  final treeViewTheme =
      ValueNotifier(const TreeViewTheme(roundLineCorners: true));
  final expansionButtonType = ValueNotifier(ExpansionButtonType.folderFile);

  void updateTheme(TreeViewTheme theme) {
    treeViewTheme.value = theme;
  }

  void updateExpansionButton(ExpansionButtonType type) {
    expansionButtonType.value = type;
  }

  @override
  void dispose() {
    treeController.dispose();
    scrollController.dispose();
    horizontalScrollController.dispose();

    treeViewTheme.dispose();
    expansionButtonType.dispose();
    super.dispose();
  }
}

class AppControllerScope extends InheritedWidget {
  const AppControllerScope({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  final AppController controller;

  @override
  bool updateShouldNotify(AppControllerScope oldWidget) => false;
}

void generateSampleTree(TreeNode parent) {
  final childrenIds = kDataSample[parent.id];
  if (childrenIds == null) return;

  parent.addChildren(
    childrenIds.map(
      (String childId) =>
          TreeNode(id: childId, label: 'Sample Node ${childId.toString()}'),
    ),
  );
  parent.children.forEach(generateSampleTree);
}

const String kRootId = 'Root';

const Map<String, List<String>> kDataSample = {
  kRootId: ['A', 'B', 'C', 'D', 'E', 'F'],
  'A': ['A 1', 'A 2'],
  'A 2': ['A 2 1'],
  'B': ['B 1', 'B 2', 'B 3'],
  'B 1': ['B 1 1'],
  'B 1 1': ['B 1 1 1', 'B 1 1 2'],
  'B 2': ['B 2 1'],
  'B 2 1': ['B 2 1 1'],
  'C': ['C 1', 'C 2', 'C 3', 'C 4'],
  'C 1': ['C 1 1'],
  'C 1 1': ['C 1 1 1', 'C 1 1 2'],
  'C 1 1 2': ['C 1 1 2 Z', 'C 1 1 2 W'],
  'D': ['D 1'],
  'D 1': ['D 1 1'],
  'E': ['E 1'],
  'F': ['F 1', 'F 2'],
};
