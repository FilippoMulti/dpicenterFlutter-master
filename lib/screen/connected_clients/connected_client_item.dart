import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/config/change_log.dart';
import 'package:dpicenter/models/server/connected_client_info.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/screen/datascreenex/data_screen.dart';
import 'package:dpicenter/screen/widgets/dialog_header_ex.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/screen/widgets/expansion_panel_custom/multi_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:gato/gato.dart' as gato;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:expandable_text/expandable_text.dart';

class ConnectedClientItem extends StatefulWidget {
  const ConnectedClientItem(
      {this.onPressed,
      this.onDoublePressed,
      this.onLongPress,
      required this.item,
      this.isSelected = false,
      this.onCheckedChanged,
      this.showDetails = true,
      super.key});

  final bool showDetails;
  final Function(BuildContext context)? onPressed;
  final Function(BuildContext context)? onDoublePressed;
  final Function(BuildContext context)? onLongPress;
  final ConnectedClientInfo item;
  final bool isSelected;
  final Function(BuildContext context, bool? newValue)? onCheckedChanged;

  @override
  ConnectedClientItemState createState() => ConnectedClientItemState();
}

class ConnectedClientItemState extends State<ConnectedClientItem> {
  bool detailsIsExpanded = false;

  @override
  void initState() {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              itemData(
                widget.item.user ?? '',
                // contentTextStyle: itemTitleStyle()
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(150),
                    borderRadius: BorderRadius.circular(20)),
                child: itemData(
                  widget.item.currentDeviceName?.split(" ").first ?? '',
                  // contentTextStyle: itemTitleStyle()
                ),
              ),
              if (widget.showDetails) const SizedBox(height: 8),
              if (widget.showDetails)
                Theme(
                  data:
                      Theme.of(context).copyWith(cardColor: Colors.transparent),
                  child: MultiExpansionPanelList(
                    animationDuration: const Duration(milliseconds: 500),
                    expandedHeaderPadding: const EdgeInsets.only(bottom: 8),
                    elevation: 0,
                    expansionCallback: (panelIndex, isExpanded) {
                      switch (panelIndex) {
                        case 0: //fisici
                          detailsIsExpanded = !detailsIsExpanded;
                          break;
                        /* case 1: //logici
                  _logicPanelIsExpanded = !_logicPanelIsExpanded;
                  break;*/
                      }

                      setState(() {});
                    },
                    children: [
                      MultiExpansionPanel(
                        boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.transparent,
                        isExpanded: detailsIsExpanded,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return DialogHeader("Dettagli",
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              style:
                                  itemValueTextStyle().copyWith(fontSize: 14));
                        },
                        body: LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            decoration: BoxDecoration(
                                color: isDarkTheme(context)
                                    ? Colors.white.withAlpha(30)
                                    : Colors.black.withAlpha(30),
                                borderRadius: BorderRadius.circular(20)),
                            width: constraints.maxWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    itemData(
                                        label: "Data connessione",
                                        widget.item.connectionDate
                                                ?.toLocalDateTimeString(
                                                    isUtc: true) ??
                                            '',
                                        contentTextStyle: itemSubtitleStyle()),
                                    itemData(
                                        label: "Info dispositivo",
                                        widget.item.currentDeviceName ?? '',
                                        contentTextStyle: itemSubtitleStyle()),
                                    itemData(
                                        label: "Info Os",
                                        widget.item.currentOs ?? '',
                                        contentTextStyle: itemSubtitleStyle()),
                                    itemData(
                                        label: "User Agent",
                                        widget.item.userAgent ?? '',
                                        contentTextStyle: itemSubtitleStyle()),
                                    itemData(
                                        label: "Indirizzo ip",
                                        widget.item.ipAddress ?? '',
                                        contentTextStyle: itemSubtitleStyle()),
                                    itemData(
                                        label: "Versione App",
                                        widget.item.appVersion ?? '',
                                        contentTextStyle: itemSubtitleStyle()),
                                    itemData(
                                        label: "Id connessione",
                                        widget.item.sessionId ?? '',
                                        contentTextStyle: itemSubtitleStyle()),
                                    ElevatedButton(
                                        onPressed: () {
                                          sendCommandToUser(
                                              messageHub,
                                              "ShowMessage",
                                              widget.item.sessionId ?? "",
                                              "Test messaggio");
                                        },
                                        child: const Text("Test messaggio")),
                                    ElevatedButton(
                                        onPressed: () {
                                          sendCommandToUser(
                                              messageHub,
                                              "ScanRequest",
                                              widget.item.sessionId ?? "",
                                              "connected_client_item");
                                        },
                                        child: const Text("Scan request")),
                                  ]),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ));
  }

  TextStyle _getTextStyle() {
    return TextStyle(
        color: isDarkTheme(context)
            ? Colors.white.withAlpha(230)
            : Colors.black87);
  }
}
