
import 'package:dpicenter/datagrid/data_grid_column.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/widgets/date_time_picker_multi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataGridDateColumn extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final String? startFilterText;
  final String? endFilterText;
  final DataType dataType;

  final void Function(String startValue, String endValue)? onFilterChange;

  const DataGridDateColumn(
      {Key? key,
      required this.text,
      this.style,
      this.onFilterChange,
      this.startFilterText,
      this.endFilterText,
      this.dataType = DataType.grid})
      : super(key: key);

  @override
  DataGridDateColumnState createState() => DataGridDateColumnState();
}

class DataGridDateColumnState extends State<DataGridDateColumn> {
  final GlobalKey filterKey = GlobalKey(debugLabel: 'filterKey');
  late TextEditingController endFilterController;
  late TextEditingController startFilterController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    startFilterController = TextEditingController(text: widget.startFilterText);
    endFilterController = TextEditingController(text: widget.endFilterText);
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
      child: Row(
        children: [
          Expanded(
              child: filterField(
            calendarTitle: 'SELEZIONA INIZIO',
            decoration: getFilterFieldDecoration(
                controller: startFilterController,
                labelText: 'Inizio',
                showClearButton: startFilterController.text.isNotEmpty),
            controller: startFilterController,
            onChanged: (String value) {
              setState(() {
                startFilterController.text = value;
                widget.onFilterChange?.call(
                    startFilterController.text, endFilterController.text);
              });
            },
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: filterField(
                calendarTitle: 'SELEZIONA FINE',
            decoration: getFilterFieldDecoration(
                controller: endFilterController,
                labelText: 'Fine',
                showClearButton: endFilterController.text.isNotEmpty),
            controller: endFilterController,
            onChanged: (String value) {
              setState(() {
                endFilterController.text = value;
                widget.onFilterChange?.call(
                    startFilterController.text, endFilterController.text);
              });
            },
          )
              /*    filterField(
                          controller: endFilterController, labelText: 'Fine')*/
              ),
        ],
      ),
    );
  }

  List<Widget> getTypeData(DataType titleType) {
    switch (titleType) {
      case DataType.grid:
        return <Widget>[
          Container(
            height: 30,
            alignment: Alignment.centerLeft,
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

  InputDecoration getFilterFieldDecoration({
    required TextEditingController controller,
    String? labelText,
    String hintText = 'Seleziona data',
    bool? dense = true,
    bool showClearButton = true,
  }) {
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
      hintText: hintText,

      suffixIcon: showClearButton
          ? Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    //DateTime parsed = DateTime.parse(controller.text);
                    setState(() {
                      controller.text = '';
                    });
                    //parsed.subtract(const Duration(days: 3650)).toString();
                    //controller.clear();
                  }
                  widget.onFilterChange?.call(
                      startFilterController.text, endFilterController.text);
                },
                icon: const Icon(Icons.clear),
              ),
            )
          : const SizedBox(height: 16),
    );
  }

  final FocusNode _focusNode = FocusNode(debugLabel: 'filterFocusNode');

  Widget filterField(
      {required TextEditingController controller,
      String calendarTitle = 'SELEZIONA',
      String? dateLabelText = 'Data',
      required InputDecoration decoration,
      required Function(String value) onChanged}) {
    return DateTimePicker(
      initialEntryMode:
          isWindows ? DatePickerEntryMode.input : DatePickerEntryMode.calendar,
      decoration: decoration,
      type: DateTimePickerType.date,
      dateMask: 'd MMM, yyyy',
      controller: controller,
      //initialValue: startDateFormatted,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      icon: const Icon(Icons.event),
      calendarTitle: calendarTitle,
      dateLabelText: dateLabelText,
      onChanged: onChanged,
      validator: (val) {
        if (kDebugMode) {
          print(val);
        }
        /*setState(() => _valueToValidate1 = val ?? '');*/
        return null;
      },
      /*
        onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),*/
    );
  }

  @override
  void dispose() {
    startFilterController.dispose();
    endFilterController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
