import 'package:dpicenter/globals/theme_global.dart';
import 'package:flutter/material.dart';

class DataGridColumn extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final String? filterText;
  final DataType dataType;
  final void Function(String value)? onFilterChange;

  const DataGridColumn(
      {Key? key,
      required this.text,
      this.style,
      this.onFilterChange,
      this.filterText,
      this.dataType = DataType.grid})
      : super(key: key);

  @override
  DataGridColumnState createState() => DataGridColumnState();
}

class DataGridColumnState extends State<DataGridColumn> {
  final GlobalKey filterKey = GlobalKey(debugLabel: 'filterKey');
  late TextEditingController filterController;

  @override
  void initState() {
    super.initState();

    filterController = TextEditingController(text: widget.filterText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...getTypeData(widget.dataType),
          ],
        ));
  }

  static Widget getTitle(String text, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }

  Widget _getValue() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: filterField(),
    );
  }

  List<Widget> getTypeData(DataType titleType) {
    switch (titleType) {
      case DataType.grid:
        return <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 30,
            child: getTitle(
              widget.text,
              style: widget.style ?? Theme.of(context).textTheme.labelLarge,
            ),
          ),
          SizedBox(
            height: 8,
            child: Divider(
              color: Color.alphaBlend(
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                  Theme.of(context).colorScheme.primary.withAlpha(90)),
            ),
          ),
          Container(height: 30, child: _getValue()),
        ];
      case DataType.list:
        return <Widget>[
          getTitle(
            widget.text,
            style: widget.style ?? Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          _getValue(),
          Divider(
            color: Color.alphaBlend(
                Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                Theme.of(context).colorScheme.primary.withAlpha(90)),
          ),
        ];
      case DataType.none:
      default:
        return <Widget>[];
    }
  }

  InputDecoration getFilterFieldDecoration(
      {String? labelText, bool? dense = true, bool showClearButton = true}) {
    return InputDecoration(
      isDense: dense,
      filled: dense,

      fillColor: isDarkTheme(context)
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.background.withAlpha(220),
              Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.surface,

      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      //enabledBorder: OutlineInputBorder(),
      border: const OutlineInputBorder(),
      labelText: labelText,
      hintText: 'Contiene',
      suffixIcon: showClearButton
          ? Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                alignment: Alignment.center,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                onPressed: () {
                  filterController.clear();
                  widget.onFilterChange?.call('');
                },
                icon: const Icon(Icons.clear, size: 16),
              ),
            )
          : const SizedBox(height: 20),
    );
  }

  final FocusNode _focusNode = FocusNode(debugLabel: 'filterFocusNode');

  Widget filterField() {
    var mediaData = MediaQuery.of(context);

    return TextFormField(
        focusNode: _focusNode,
        maxLines: 1,
//      autofocus: isDesktop ? true : false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          widget.onFilterChange?.call(value);
        },
        controller: filterController,
        //onChanged: (value) => editState = true,
        decoration: getFilterFieldDecoration(
                showClearButton: filterController.text.isNotEmpty)
            .copyWith(
          labelText: widget.text,
        ),
        style: Theme.of(context).textTheme.bodyLarge);
  }

  @override
  void dispose() {
    filterController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

enum DataType {
  none,
  grid,
  list,
}