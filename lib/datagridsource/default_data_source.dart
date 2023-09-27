import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:gato/gato.dart' as gato;

class DefaultDataSource<T> extends DataGridSource {
  List<T> list;

  DefaultDataSource({required List<GridColumn> columns, required this.list}) {
    // for (var element in columns) { columnWidths.addAll({element.columnName.toString() : double.nan});}

/*
    columnWidths = columns.map((element) {
      return {element.columnName.toString():double.nan};
    }) as Map<String, double>;
*/

    dataGridRows = toDataGridRows(columns, list);
  }

  static List<DataGridRow> toDataGridRows(List<GridColumn> columns, List list) {
    return list.map<DataGridRowWithItem>((dynamic dataGridRow) {
      List<DataGridCell> cells = <DataGridCell>[];
      for (GridColumn column in columns) {
        Widget Function(dynamic value)? onRenderRowField;
        Color Function(dynamic value)? onQueryRowColor;
        Decoration Function(dynamic value)? onQueryRowDecoration;
        Color? Function(dynamic value)? onQueryTextColor;
        GridColumnWithWidget? columnWithWidget;
        if (column is GridColumnWithWidget) {
          columnWithWidget = column;
          onRenderRowField = column.onRenderRowField;
          onQueryRowDecoration = column.onQueryRowDecoration;
          onQueryRowColor = column.onQueryRowColor;
          onQueryTextColor = column.onQueryTextColor;
        }

        cells.add(DataGridCellWithWidget(
            id: columnWithWidget?.id ?? "emptyId",
            columnName: column.columnName,
            value: gato.get(
                dataGridRow?.json, columnWithWidget?.id ?? column.columnName),
            onRenderRowField: onRenderRowField,
            onQueryRowColor: onQueryRowColor,
            onQueryRowDecoration: onQueryRowDecoration,
            onQueryTextColor: onQueryTextColor));
      }
      return DataGridRowWithItem(item: dataGridRow, cells: cells);
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    DataGridRowWithItem? rowWithItem;
    if (row is DataGridRowWithItem) {
      rowWithItem = row;
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      Widget Function(dynamic value)? onRenderRowField;
      Color Function(dynamic value)? onQueryRowColor;
      Decoration Function(dynamic value)? onQueryRowDecoration;
      Color? Function(dynamic value)? onQueryTextColor;

      if (dataGridCell is DataGridCellWithWidget) {
        onRenderRowField = dataGridCell.onRenderRowField;
        onQueryRowDecoration = dataGridCell.onQueryRowDecoration;
        onQueryRowColor = dataGridCell.onQueryRowColor;
        onQueryTextColor = dataGridCell.onQueryTextColor;
      }

      Widget? childText = onQueryTextColor != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 50,
                style: Theme.of(navigatorKey!.currentContext!)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                        color: onQueryTextColor.call(rowWithItem?.item),
                        letterSpacing: 0,
                        wordSpacing: 0),
              ),
            )
          : getText(
              dataGridCell.value.toString(),
              null,
            );

      Widget child = onRenderRowField?.call(rowWithItem?.item) ?? childText;

      return Container(
          //constraints: conBoxConstraints(minHeight: 20, maxHeight: 20),
          decoration: onQueryRowDecoration?.call(rowWithItem?.item),
          color: onQueryRowColor?.call(rowWithItem?.item),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: child);
    }).toList());
  }

  static Widget getText(String value, Color? color,
      {TextAlign? textAlign, double? fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        maxLines: 150,
        textAlign: textAlign,
        style: Theme.of(navigatorKey!.currentContext!)
            .textTheme
            .bodySmall
            ?.copyWith(
                color: color ??
                    (isDarkTheme(navigatorKey!.currentContext!)
                        ? Colors.white.withAlpha(220)
                        : Colors.black87),
                letterSpacing: 0,
                wordSpacing: 0,
                fontSize: fontSize),
      ),
    );
  }

  static Widget getTextWithoutIntrinsic(String value, Color? color,
      {TextAlign? textAlign, double? fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        maxLines: 150,
        textAlign: textAlign,
        style: Theme.of(navigatorKey!.currentContext!)
            .textTheme
            .bodySmall
            ?.copyWith(
                color: color,
                letterSpacing: 0,
                wordSpacing: 0,
                fontSize: fontSize),
      ),
    );
  }
}

class DataGridRowWithItem<T> extends DataGridRow {
  final T item;

  DataGridRowWithItem({required this.item, required List<DataGridCell> cells})
      : super(cells: cells);
}

class GridColumnWithWidget extends GridColumn {
  final Widget Function(dynamic value)? onRenderRowField;
  final Color Function(dynamic value)? onQueryRowColor;
  final Decoration Function(dynamic value)? onQueryRowDecoration;
  final Color? Function(dynamic value)? onQueryTextColor;
  final String id;

  GridColumnWithWidget(
      {required this.id,
      required String columnName,
      required Widget label,
      ColumnWidthMode columnWidthMode = ColumnWidthMode.none,
      bool visible = true,
      bool allowSorting = true,
      EdgeInsets autoFitPadding = const EdgeInsets.symmetric(horizontal: 4.0),
      double minimumWidth = double.nan,
      double maximumWidth = double.nan,
      double width = double.nan,
      bool allowEditing = true,
      this.onRenderRowField,
      this.onQueryRowColor,
      this.onQueryRowDecoration,
      this.onQueryTextColor})
      : super(
            columnName: columnName,
            label: label,
            visible: visible,
            allowEditing: allowEditing,
            allowSorting: allowSorting,
            autoFitPadding: autoFitPadding,
            minimumWidth: minimumWidth,
            maximumWidth: minimumWidth,
            width: width);
}

class DataGridCellWithWidget<T> extends DataGridCell {
  final Widget Function(dynamic value)? onRenderRowField;
  final Color Function(dynamic value)? onQueryRowColor;
  final Decoration Function(dynamic value)? onQueryRowDecoration;
  final Color? Function(dynamic value)? onQueryTextColor;
  final String id;

  DataGridCellWithWidget(
      {T? value,
      required this.id,
      required String columnName,
      this.onRenderRowField,
      this.onQueryTextColor,
      this.onQueryRowDecoration,
      this.onQueryRowColor})
      : super(value: value, columnName: columnName);
}

enum ColumnSizerRuleType {
  useProvidedTextStyle,
  recalculateCellValue,
}

class ColumnSizerRecalculateResult {
  dynamic result;
  TextStyle? textStyle;

  ColumnSizerRecalculateResult({this.result, this.textStyle});
}

class ColumnSizerRule {
  ColumnSizerRuleType ruleType = ColumnSizerRuleType.useProvidedTextStyle;
  ColumnSizerRecalculateResult Function(dynamic)? recalculateCellValue;
  TextStyle? textStyle;

  ColumnSizerRule(
      {required this.ruleType, this.recalculateCellValue, this.textStyle});
}

class CustomColumnSizer extends ColumnSizer {
  Map<String, ColumnSizerRule?>? columnsStyles;

  TextStyle defaultTextStyle =
      Theme.of(navigatorKey!.currentContext!).textTheme.bodySmall!;

  CustomColumnSizer({this.columnsStyles});

  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    //if (column.columnName == 'Name' || column.columnName == 'Designation') {
    style = Theme.of(navigatorKey!.currentContext!).textTheme.bodySmall!;
    //}
    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellHeight(GridColumn column, DataGridRow row,
      Object? cellValue, TextStyle textStyle) {
    if (column is GridColumnWithWidget) {
      GridColumnWithWidget columnWithWidget = column;
      if (columnsStyles != null &&
          columnsStyles![columnWithWidget.id] != null) {
        switch (columnsStyles![columnWithWidget.id]!.ruleType) {
          case ColumnSizerRuleType.useProvidedTextStyle:
            if (columnsStyles![columnWithWidget.id]!.textStyle != null) {
              textStyle = columnsStyles![columnWithWidget.id]!
                  .textStyle!
                  .copyWith(height: 0.1);
            } else {
              //fallback al textstyle di default
              textStyle = defaultTextStyle.copyWith(height: 0.1);
            }
            break;
          case ColumnSizerRuleType.recalculateCellValue:
            ColumnSizerRecalculateResult? result =
                columnsStyles?[columnWithWidget.id]
                    ?.recalculateCellValue
                    ?.call((row as DataGridRowWithItem).item);
            if (result != null) {
              cellValue = result.result;
              textStyle = result.textStyle?.copyWith(height: 0.1) ??
                  defaultTextStyle.copyWith(height: 0.1);
            }
            break;
        }
      } else {
        textStyle = defaultTextStyle.copyWith(height: 0.1);
      }
    }
    return super.computeCellHeight(column, row, cellValue, textStyle);
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    if (column is GridColumnWithWidget) {
      GridColumnWithWidget columnWithWidget = column;
      if (columnsStyles != null &&
          columnsStyles![columnWithWidget.id] != null) {
        switch (columnsStyles![columnWithWidget.id]!.ruleType) {
          case ColumnSizerRuleType.useProvidedTextStyle:
            if (columnsStyles![columnWithWidget.id]!.textStyle != null) {
              textStyle = columnsStyles![columnWithWidget.id]!.textStyle!;
            } else {
              //fallback al textstyle di default
              textStyle = defaultTextStyle;
            }
            break;
          case ColumnSizerRuleType.recalculateCellValue:
            ColumnSizerRecalculateResult? result =
                columnsStyles?[columnWithWidget.id]
                    ?.recalculateCellValue
                    ?.call((row as DataGridRowWithItem).item);
            if (result != null) {
              cellValue = result.result;
              textStyle = result.textStyle ?? defaultTextStyle;
            }
            break;
        }
      } else {
        textStyle = defaultTextStyle;
      }
    }

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}
