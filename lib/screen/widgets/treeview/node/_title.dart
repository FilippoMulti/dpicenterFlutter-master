part of 'tree_node_tile.dart';

class _NodeTitle extends StatelessWidget {
  const _NodeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appController = AppController.of(context);
    final nodeScope = TreeNodeScope.of(context);

    return AnimatedBuilder(
      animation: appController,
      builder: (_, __) {
        final textStyle = appController.isSelected(nodeScope.node.id) ?? false
            ? Theme.of(context)
                .textTheme //
                .titleMedium
                ?.copyWith(
                  color: Colors.green.shade500,
                  fontWeight: FontWeight.w500,
                )
            : Theme.of(context).textTheme.titleMedium;
        return Text(
          nodeScope.node.label,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
