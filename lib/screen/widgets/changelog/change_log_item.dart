import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/config/change_log.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/widgets/dialog_header_ex.dart';
import 'package:flutter/material.dart';
import 'package:gato/gato.dart' as gato;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:expandable_text/expandable_text.dart';

class ChangeLogItem extends StatefulWidget {
  const ChangeLogItem({this.onPressed,
    this.onDoublePressed,
    this.onLongPress,
    required this.item,
      this.isSelected = false,
      this.onCheckedChanged,
      super.key});

  final Function(BuildContext context)? onPressed;
  final Function(BuildContext context)? onDoublePressed;
  final Function(BuildContext context)? onLongPress;
  final ChangeLog item;
  final bool isSelected;
  final Function(BuildContext context, bool? newValue)? onCheckedChanged;

  @override
  ChangeLogItemState createState() => ChangeLogItemState();
}

class ChangeLogItemState extends State<ChangeLogItem> {
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

    return getCustomSettingTile(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        onDoublePressed: widget.onDoublePressed,
        crossAxisAlignment: CrossAxisAlignment.start,
        color: widget.isSelected ? Colors.green.withAlpha(100) : null,

        child: SizedBox(
          //duration: const Duration(milliseconds: 500),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.item.date ?? '',
              style: _getTextStyle(),
            ),
            Text(
              '${widget.item.version ?? 'test'} (${widget.item.versionNumber ?? 'test'})',
              style: _getTextStyle(),
            ),
            if (widget.item.info != null)
              ExpandableText(
                animation: true,
                animationDuration: const Duration(milliseconds: 300),
                widget.item.info!,
                expandText: 'Mostra tutto',
                collapseText: 'Mostra meno',
                maxLines: 3,
                linkColor: Theme.of(context).colorScheme.primary,
                style: _getTextStyle(),
              )
            /*           Text(
    widget.item.info!.length <= 150 ? widget.item.info! : widget.item.info!.substring(0, 150),
                style: _getTextStyle(),
              ),
                if (widget.item.info != null && widget.item.info!.length > 150)
                  Theme(
                    data: Theme.of(context).copyWith(cardColor: Colors.transparent),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: MultiExpansionPanelList(
                        animationDuration: const Duration(milliseconds: 500),
                        expandedHeaderPadding: EdgeInsets.zero,
                        elevation: 0,
                        expansionCallback: (panelIndex, isExpanded) {
                          switch (panelIndex) {
                            case 0:
                              _detailsIsExpanded = !_detailsIsExpanded;
                              break;
                          }

                          setState(() {});
                        },
                        children: [
                          MultiExpansionPanel(
                            backgroundColor: Colors.transparent,
                            isExpanded: _detailsIsExpanded,
                            canTapOnHeader: true,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Dettagli",
                                    style: itemValueTextStyle()
                                        .copyWith(fontSize: 14, color: _getTextStyle().color,)),
                              );
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
                                    child: Text(
                                      widget.item.info ?? '',
                                      style: _getTextStyle(),
                                    )),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),*/
          ]),
        ));
  }

  TextStyle _getTextStyle() {
    return TextStyle(
        color: isDarkTheme(context)
            ? Colors.white.withAlpha(230)
            : Colors.black87);
  }
}
