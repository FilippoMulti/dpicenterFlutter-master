/*
import 'package:dpicenter/datagridsource/default_data_source.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/screen/datascreenex/data_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:settings_ui/settings_ui.dart';

class DataList extends StatefulWidget {
  const DataList({required this.source, super.key});

  final DefaultDataSource source;


  @override
  DataListState createState()=>DataListState();
}

class DataListState extends State<DataList>{
  final AutoScrollController _autoScrollTagController =
  AutoScrollController(debugLabel: '_autoScrollTagController');
  List<DataGridRow>? selectedGridRows;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

  }
  Widget cardItems() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      color: isDarkTheme(context)
          ? Color.alphaBlend(
          Theme.of(context).colorScheme.surface.withAlpha(240),
          Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.surface,
      child: SeparatedSettingsList(
          controller: _autoScrollTagController,
          shrinkWrap: true,
          contentPadding: EdgeInsets.zero,
          //contentPadding: EdgeInsets.zero,
          platform: DevicePlatform.web,
          automaticKeepAlive: true,
          sections: List.generate(widget.source.effectiveRows.length, (index) {
            DataGridRowWithItem row =
            widget.source.effectiveRows[index] as DataGridRowWithItem;
            */
/*if (!listRowKeyMap.containsKey(row.item)){
                  print("create key: ${row.item} - $index");
                  listRowKeyMap.addAll({row.item : GlobalKey(debugLabel: row.item.toString())});
                } else {
                  print("Key ${row.item} already created!");
                }
            print("Total keys: ${listRowKeyMap.length}");*/ /*

            */
/* String content2 =
                gato.get(row.item.json, widget.configuration.columns[1].id).toString();*/ /*

            return AutoScrollTag(
              key: ValueKey(index),*/
/*listRowKeyMap[row.item]!*/ /*

              controller: _autoScrollTagController,
              index: index,
              child: DataScreenItem(
                key: ValueKey(row.item),
                onCheckedChanged: (BuildContext context, bool? newValue) {
                  if (newValue ?? false) {
                    if (!(selectedGridRows?.contains(row) ?? false)) {
                      print("add");
                      selectedGridRows?.add(row);
                      */
/*        listRowKeyMap[row.item]?.currentState?.setState(() {
                        listRowKeyMap[row.item]?.currentState?.isSelected=true;
                      });*/ /*


                    } else {
                      print("row already added");
                    }
                  } else {
                    if (selectedGridRows?.contains(row) ?? false) {
                      print("remove!!");
                      selectedGridRows?.remove(row);
                      */
/*              listRowKeyMap[row.item]?.currentState?.setState(() {
                        listRowKeyMap[row.item]?.currentState?.isSelected=false;
                      });*/ /*


                    } else {
                      print("row not found!!!!!!!!!!!!!!!");
                    }

                  }
                  if (selectedGridRows != null) {
                    print("update fab");
                    updateFAB(selectedGridRows!);
                  } else {
                    print("selectedGridRows==null");
                  }
                },
                onPressed: (context) {
                  selectedGridRows?.clear();
                  selectedGridRows?.add(row);
                  if (selectedGridRows != null) {
                    updateFAB(selectedGridRows!);
                  }
                },
                onDoublePressed: (context) {
                  openDetail(row.item);
                },
                columns: widget.configuration.columns,
                item: row.item,
                isSelected: selectedGridRows?.contains(row) ?? false,
              ),
            );
          })),
    );
  }

@override
  void dispose() {
    _autoScrollTagController.dispose();
    super.dispose();
  }
}*/
