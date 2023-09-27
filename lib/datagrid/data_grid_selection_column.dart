import 'package:dpicenter/datagrid/data_grid_column.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/event_message.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gato/gato.dart' as gato;

class DataGridSelectionColumn<TParent, TChild> extends StatefulWidget {
  final List<TParent>? items;
  final String text;
  final TextStyle? style;
  final List<TChild>? filterValues;
  final DropdownSearchCompareFn<TChild>? compareFn;
  final void Function(List<TChild>? values)? onFilterChange;

  ///to customize selected item
  final DropdownSearchBuilderMultiSelection<dynamic>? dropdownBuilder;
  final DropdownSearchPopupItemBuilder<dynamic>? popupItemBuilder;

  ///customize the fields the be shown
  final DropdownSearchItemAsString<TChild>? itemAsString;

  final String id;
  final DataType dataType;

  const DataGridSelectionColumn({
    Key? key,
    required this.id,
    required this.text,
    required this.items,
    this.style,
    this.onFilterChange,
    this.filterValues,
    this.compareFn,
    this.itemAsString,
    this.popupItemBuilder,
    this.dropdownBuilder,
    this.dataType = DataType.grid,
  }) : super(key: key);

  @override
  DataGridColumnSelectionState<TParent, TChild> createState() =>
      DataGridColumnSelectionState<TParent, TChild>();
}

class DataGridColumnSelectionState<TParent, TChild> extends State<DataGridSelectionColumn> {
  final GlobalKey<DropdownSearchState> filterKey =
  GlobalKey<DropdownSearchState>(debugLabel: 'filterKey');
  late TextEditingController filterController;
  final ScrollController _scrollController =
  ScrollController(debugLabel: '_scrollController');
  List<TChild>? selectedItems;
  final FocusNode _focusNode = FocusNode(debugLabel: 'filterFocusNode');

  @override
  void initState() {
    super.initState();
    selectedItems = widget.filterValues?.cast<TChild>();
    filterController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //filterKey.currentState?.closeDropDownSearch();
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
            child: DataGridColumnState.getTitle(
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
          DataGridColumnState.getTitle(
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
      {String? labelText, String? hintText, bool? dense = true}) {
    return InputDecoration(
      isDense: dense,
      filled: dense,

      fillColor: isDarkTheme(context)
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.background.withAlpha(220),
              Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.surface,

      contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),

      //enabledBorder: OutlineInputBorder(),
      border: const OutlineInputBorder(),
      labelText: labelText,
      hintText: hintText,

      suffixIcon: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          onPressed: () {
            if (mounted) {
              filterController.clear();
              widget.onFilterChange?.call(null);
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ),
    );
  }

  final ScrollController _filterFieldScrollController =
  ScrollController(debugLabel: '_filterFieldScrollController');

  Widget filterField() {
    return DropdownSearch<TChild>.multiSelection(
      key: filterKey,

      //popupBackgroundColor: getAppBackgroundColor(context),
      popupProps: isWindows || isWindowsBrowser
          ? PopupPropsMultiSelection.menu(
        scrollbarProps: const ScrollbarProps(thickness: 0),
        menuProps:
        MenuProps(backgroundColor: getAppBackgroundColor(context)),
        /*focusNode: isWindows || isWindowsBrowser ? null : _focusNode,
        mode: isWindows || isWindowsBrowser ? Mode.MENU : Mode.DIALOG,*/
              //scrollbarProps: ScrollbarProps(controller: _filterFieldScrollController),

              showSelectedItems: true,
              showSearchBox: true,
              emptyBuilder: (context, searchEntry) =>
                  const Center(child: Text('Nessun risultato')),

              searchFieldProps: TextFieldProps(
                  autofocus: isWindows || isWindowsBrowser ? true : false,
                  //controller: filterController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Cerca")),
              itemBuilder: widget.popupItemBuilder ?? getPopupItemBuilder,
            )
          : PopupPropsMultiSelection.dialog(
        scrollbarProps: const ScrollbarProps(thickness: 0),
        dialogProps:
        DialogProps(backgroundColor: getAppBackgroundColor(context)),
        /*focusNode: isWindows || isWindowsBrowser ? null : _focusNode,
        mode: isWindows || isWindowsBrowser ? Mode.MENU : Mode.DIALOG,*/
        //scrollbarProps: ScrollbarProps(controller: _filterFieldScrollController),

        showSelectedItems: true,
        showSearchBox: true,
        emptyBuilder: (context, searchEntry) =>
        const Center(child: Text('Nessun risultato')),

        searchFieldProps: TextFieldProps(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            autofocus: isWindows || isWindowsBrowser ? true : false,
            controller: filterController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Cerca")),
        itemBuilder: widget.popupItemBuilder ?? getPopupItemBuilder,
      ),

      /*clearButtonProps: const ClearButtonProps(
                  isVisible: true
                ),*/
      filterFn: (TChild? item, String? filter) {
        eventBus.fire(LogHubEvent(newEvent: 'filter: ${filter.toString()}'));
        eventBus.fire(LogHubEvent(newEvent: 'widget.id: ${widget.id}'));
        eventBus.fire(LogHubEvent(
            newEvent: 'item is JsonPayload: ${item is JsonPayload}'));
        eventBus.fire(LogHubEvent(
            newEvent: 'item.json: ${item is JsonPayload ? item.json : ''}'));
        eventBus
            .fire(LogHubEvent(newEvent: 'item.toString(): ${item.toString()}'));

        String content = item is JsonPayload
            ? gato.get(item.json, widget.id) ?? item.json.toString()
            : item.toString();
        eventBus.fire(LogHubEvent(newEvent: 'content: $content'));
        String newString = content.removePunctuation();
        eventBus.fire(LogHubEvent(newEvent: 'newString: $newString'));
        print(newString);
        String filterString = filter?.removePunctuation() ?? '';
        eventBus.fire(LogHubEvent(newEvent: 'filterString: $filterString'));

        eventBus.fire(LogHubEvent(
            newEvent:
            'newString.toLowerCase().contains(filterString.toLowerCase()): ${newString.toLowerCase().contains(filterString.toLowerCase())}'));
        return newString.toLowerCase().contains(filterString.toLowerCase());
      },

      compareFn:
      widget.compareFn ?? (item, selectedItem) => item == selectedItem,

      clearButtonProps: getClearButtonProps(context),
      dropdownButtonProps: getDropdownButtonProps(context),


      dropdownBuilder: widget.dropdownBuilder ?? getDropdownBuilder,

      autoValidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (List<TChild>? newValue) {
        setState(() {
          //   editState = true;
          if (newValue != null) {
            selectedItems = newValue;
          }
        });
        widget.onFilterChange?.call(selectedItems!);
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration:
        getFilterFieldDecoration(hintText: 'Seleziona ${widget.text}'),
      ),
      items: widget.items != null ? widget.items! as List<TChild> : <TChild>[],
      selectedItems: selectedItems ?? const [],
    );
  }

  Widget getPopupItemBuilder(BuildContext context, TChild item,
      bool isSelected) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(item.toString()))),
    );
  }

  Widget getDropdownBuilder(context, List<TChild> list) {
    List<Widget> selected = <Widget>[];

    for (var item in list) {
      selected.add(
        IgnorePointer(
          child: getFilterChip(
              text: item is JsonPayload
                  ? gato.get(item.json, widget.id) ?? item.toString()
                  : item.toString(),
              selected: () {
                return false;
              },
              onSelected: (value) {},
              context: context),
        ),
      );
    }

    if (selected.isNotEmpty) {
      return getContainerRow(context, selected);
    } else {
      return getEmptySelectionText(context);
    }
  }

  static Widget getContainerRow(BuildContext context, List<Widget> children,
      {Key? key}) {
    return SizedBox(
        key: key,
        height: 30,
        child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            // controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: children,
              ),
            )));
  }

  static Widget getEmptySelectionText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 1,
          ),

          ///risulta un pixel sopra rispetto l'hint della data per questo c'è questo SizedBox
          Text(
            "Seleziona",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: isDarkTheme(context) ? Colors.white60 : Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget getClearButtonBuilder(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        onPressed: () {
          filterKey.currentState?.clear();
          widget.onFilterChange?.call(null);
        },
        icon: const Icon(Icons.clear),
      ),
    );
  }

  Widget getDropdownButtonBuilder(BuildContext context) {
    return filterKey.currentState?.getSelectedItems.isNotEmpty ?? false
        ? const SizedBox()
        : Material(
      type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              onPressed: () {
                if (mounted) {
                  filterKey.currentState?.openDropDownSearch();
                }
//                  widget.onFilterChange?.call(null);
              },
              icon: const Icon(Icons.arrow_drop_down),
            ),
          );
  }

  ClearButtonProps getClearButtonProps(BuildContext context) {
    return const ClearButtonProps(
      isVisible: false,
      iconSize: 0,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(maxWidth: 0, maxHeight: 0),
      icon: SizedBox(),
    );
  }

  DropdownButtonProps getDropdownButtonProps(BuildContext context) {
    return DropdownButtonProps(
      padding: EdgeInsets.zero,
      icon: filterKey.currentState?.getSelectedItems.isNotEmpty ?? false
          ? Material(
        type: MaterialType.transparency,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  filterKey.currentState?.clear();
                  widget.onFilterChange?.call(null);
                },
                icon: const Icon(
                  Icons.clear,
                  size: 18,
                ),
              ),
            )
          : Material(
        type: MaterialType.transparency,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  filterKey.currentState?.openDropDownSearch();
//                  widget.onFilterChange?.call(null);
                },
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
    );
  }

  static Widget getFilterChip({required BuildContext context,
    required String text,
    required Function() selected,
    Function(bool)? onSelected}) {
    Color backgroundColor = isDarkTheme(context)
        ? Color.alphaBlend(
        Theme.of(context).scaffoldBackgroundColor.withAlpha(100),
        Theme.of(context).colorScheme.primary)
        : Theme
        .of(context)
        .colorScheme
        .primary;
    print(
        'backgroundColor computerLuminance ${backgroundColor.computeLuminance()
            .toString()}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: FilterChip(
          key: ValueKey(text),
          visualDensity: VisualDensity.compact.copyWith(
              horizontal: VisualDensity.maximumDensity,
              vertical: VisualDensity.minimumDensity),
          /*avatar: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.filter_list_alt, color: Colors.white)),*/
          backgroundColor: backgroundColor,
          //selectedColor: Theme.of(context).colorScheme.primary,
          //disabledColor: backgroundColor,
          //labelStyle: TextStyle(letterSpacing: 0, color: Theme.of(context).colorScheme.primary.computeLuminance() > 0.5 ? Colors.black : Colors.white),
          labelPadding: const EdgeInsets.symmetric(horizontal: 2),
          //Color(int.parse(tag.color!)),
          label: Text(
            text,
            overflow: TextOverflow.clip,
            maxLines: 1,
            style: TextStyle(
                letterSpacing: -1,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: backgroundColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white),
          ),
          selected: selected.call(),
          showCheckmark: false,
          //selectedColor: Color(int.parse(tag.color!)).lighten(),
          onSelected: onSelected),
    );
  }

  @override
  void dispose() {
    //print("data_grid_selection_column.dispose");
    filterController.dispose();
    _filterFieldScrollController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
