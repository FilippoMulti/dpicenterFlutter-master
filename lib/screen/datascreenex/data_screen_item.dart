import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/widgets/dialog_header_ex.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:gato/gato.dart' as gato;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataScreenItem extends StatefulWidget {
  const DataScreenItem({this.onPressed,
    this.onDoublePressed,
    this.onLongPress,
    required this.columns,
    required this.item,
      this.isSelected = false,
      this.onCheckedChanged,
      super.key});

  final Function(BuildContext context)? onPressed;
  final Function(BuildContext context)? onDoublePressed;
  final Function(BuildContext context)? onLongPress;
  final List<DataScreenColumnConfiguration> columns;
  final JsonPayload item;
  final bool isSelected;
  final Function(BuildContext context, bool? newValue)? onCheckedChanged;

  @override
  DataScreenItemState createState() => DataScreenItemState();
}

class DataScreenItemState extends State<DataScreenItem> {
  bool _detailsIsExpanded = false;

  /*bool _isSelected=false;

  bool get isSelected => _isSelected;

  set isSelected(bool isSelected) {
    if (_isSelected!=isSelected) {
      setState(() {
        _isSelected = isSelected;
      });
    }

  }
*/
  @override
  void initState() {
    // isSelected=widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DataScreenColumnConfiguration> headItems = widget.columns
        .where((element) => element.labelType != LabelType.miniItemValue)
        .toList(growable: false);
    List<DataScreenColumnConfiguration> miniItems = widget.columns
        .where((element) => element.labelType == LabelType.miniItemValue)
        .toList(growable: false);

    return getCustomSettingTile(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        onDoublePressed: widget.onDoublePressed,
        crossAxisAlignment: CrossAxisAlignment.start,
        color: widget.isSelected ? Colors.green.withAlpha(100) : null,
        icon: Checkbox(
            value: widget.isSelected,
            onChanged: (bool? newValue) {
              //isSelected=newValue ?? false;

              widget.onCheckedChanged?.call(context, newValue);
            }),
        child: SizedBox(
          //duration: const Duration(milliseconds: 500),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...List.generate(headItems.length, (columnIndex) {
              if (headItems[columnIndex].onRenderRowField == null) {
                String? content = gato
                    .get(widget.item.json, headItems[columnIndex].id)
                    .toString();
                String label = headItems[columnIndex].label;

                switch (headItems[columnIndex].labelType) {
                  case LabelType.itemValue:
                    return itemData(
                      content,
                     // contentTextStyle: itemTitleStyle()
                    );
                  case LabelType.subItemValue:
                    return itemData(
                        label: label,
                        content,
                        contentTextStyle: itemSubtitleStyle());
                  case LabelType.miniItemValue:
                    return itemData(
                        label: label,
                        content,
                        contentTextStyle: itemMiniSubtitleStyle());
                  default:
                    break;
                }
              } else {
                return headItems[columnIndex]
                        .onRenderRowField
                        ?.call(widget.item, forList: true) ??
                    const SizedBox();
              }

              return const SizedBox();
            }),
            if (miniItems.isNotEmpty) const SizedBox(height: 8),
            if (miniItems.isNotEmpty)
              Theme(
                data: Theme.of(context).copyWith(cardColor: Colors.transparent),
                child: MultiExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 500),
                  expandedHeaderPadding: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  expansionCallback: (panelIndex, isExpanded) {
                    switch (panelIndex) {
                      case 0: //fisici
                        _detailsIsExpanded = !_detailsIsExpanded;
                        break;
                      /* case 1: //logici
                  _logicPanelIsExpanded = !_logicPanelIsExpanded;
                  break;*/
                    }

                    setState(() {});
                  },
                      children: [
                    MultiExpansionPanel(
                      backgroundColor: Colors.transparent,
                      isExpanded: _detailsIsExpanded,
                      canTapOnHeader: true,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return DialogHeader("Dettagli",
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            style: itemValueTextStyle().copyWith(fontSize: 14));
                      },
                      body: LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme(context)
                                  ? Colors.white.withAlpha(30)
                                  : Colors.black.withAlpha(30),
                              borderRadius: BorderRadius.circular(20)),
                          clipBehavior: Clip.antiAlias,
                          width: constraints.maxWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runAlignment: WrapAlignment.start,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: List.generate(miniItems.length,
                                            (columnIndex) {
                                  if (miniItems[columnIndex].onRenderRowField ==
                                      null) {
                                    String? content = gato
                                        .get(widget.item.json,
                                            miniItems[columnIndex].id)
                                        .toString();
                                    String label = miniItems[columnIndex].label;
                                    if (content != null) {
                                      switch (
                                          miniItems[columnIndex].labelType) {
                                        case LabelType.itemValue:
                                          return itemData(
                                            content,
                                          );
                                        case LabelType.subItemValue:
                                          return itemData(
                                              label: label,
                                              content,
                                              contentTextStyle:
                                              itemSubtitleStyle());
                                        case LabelType.miniItemValue:
                                          return itemData(
                                              label: label,
                                              content,
                                              contentTextStyle:
                                              itemMiniSubtitleStyle());
                                        default:
                                          break;
                                      }
                                    }
                                  } else {
                                    return miniItems[columnIndex]
                                            .onRenderRowField
                                            ?.call(widget.item,
                                                forList: true) ??
                                        const SizedBox();
                                  }
                                  return const SizedBox();
                                })),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
          ]),
        ));
  }
}
