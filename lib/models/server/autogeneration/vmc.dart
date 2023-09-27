import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:dpicenter/models/server/autogeneration/vmc_accessory.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_engine.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_physics_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_row.dart';
import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_selection.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_separator.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/vmc_file.dart';
import 'package:dpicenter/models/server/vmc_production.dart';
import 'package:dpicenter/models/server/vmc_setting.dart';
import 'package:dpicenter/models/server/vmc_type_enum.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:json_annotation/json_annotation.dart';

part 'vmc.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class Vmc extends Equatable implements JsonPayload {
  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int vmcId;
  final String code;
  final String description;
  final int? vmcPhysicsConfigurationId;
  final VmcPhysicsConfiguration? vmcPhysicsConfiguration;
  final int? vmcConfigurationId;
  final VmcConfiguration? vmcConfiguration;

  final List<VmcSeparator>? vmcSeparators;
  final List<VmcEngine>? vmcEngines;
  final List<VmcAccessory>? vmcAccessory;
  final List<VmcSelection>? vmcSelections;
  final List<VmcSetting>? vmcSettings;
  final List<VmcFile>? vmcFiles;
  final List<VmcProduction>? vmcProductions;

  /// <summary>
  /// lista delle righe attuali
  /// </summary>
  final List<VmcRow>? rows;
  final VmcTypeEnum? vmcType;

  const Vmc(
      {required this.vmcId,
      required this.code,
      required this.description,
      this.vmcPhysicsConfigurationId,
      this.vmcPhysicsConfiguration,
      this.vmcConfigurationId,
      this.vmcConfiguration,
      this.rows,
      this.vmcSelections,
      this.vmcEngines,
      this.vmcAccessory,
      this.vmcSeparators,
      this.vmcSettings,
      this.vmcProductions,
      this.vmcFiles,
      this.vmcType,
      this.json});

  factory Vmc.fromJson(Map<String, dynamic> json) {
    var result = _$VmcFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  factory Vmc.standard(
      int id, int configurationId, String code, String description,
      {int maxRows = 8, int maxWidthSpaces = 9, int tickInSingleSpace = 4}) {
    List<VmcRow> rows = <VmcRow>[];

    for (int rowIndex = 0; rowIndex < maxRows; rowIndex++) {
      VmcRow row = VmcRow(
          rowIndex: rowIndex, id: rowIndex, maxWidthSpaces: maxWidthSpaces);
      int index = 0;
      for (int spaceIndex = 0; spaceIndex < maxWidthSpaces; spaceIndex++) {
        for (int tickIndex = 0; tickIndex < 4; tickIndex++) {
          /*row.spaces.add(Space(row: row, widthSpaces: 0.25, position: (spaceIndex) + (0.25 * tickIndex), visible: false));*/
          row.spaces.add(Space(
              id: index,
              rowIndex: rowIndex,
              tickInSingleSpace: tickInSingleSpace,
              //row: row,
              widthSpaces: 0.25,
              position: null,
              visible: false));
          row.ticks.add(Space(
              id: index,
              rowIndex: rowIndex,
              tickInSingleSpace: tickInSingleSpace,
              //row: row,
              widthSpaces: 0.25,
              position: (spaceIndex) + (0.25 * tickIndex)));
          index++;
        }
      }

      rows.add(row);
    }
    return Vmc(
      vmcId: id,
      code: code,
      description: description,
      rows: rows,
      vmcConfiguration: VmcConfiguration(
          maxWidthSpaces: maxWidthSpaces,
          maxRows: maxRows,
          tickInSingleSpace: tickInSingleSpace,
          vmcConfigurationId: configurationId),
    );
  }

  factory Vmc.standardBase(
      int id, int configurationId, String code, String description,
      {int tickInSingleSpace = 4, int maxRows = 8, int maxWidthSpaces = 9}) {
    List<VmcRow> rows = <VmcRow>[];

    for (int rowIndex = 0; rowIndex < maxRows; rowIndex++) {
      VmcRow row = VmcRow(
          rowIndex: rowIndex, id: rowIndex, maxWidthSpaces: maxWidthSpaces);
      rows.add(row);
    }

    return Vmc(
        vmcId: id,
        code: code,
        description: description,
        rows: rows,
        vmcConfiguration: VmcConfiguration(
            maxWidthSpaces: maxWidthSpaces,
            maxRows: maxRows,
            tickInSingleSpace: tickInSingleSpace,
            vmcConfigurationId: configurationId));
  }

  factory Vmc.standardEmpty(
      int id, int configurationId, String code, String description,
      {int tickInSingleSpace = 4, int maxRows = 8, int maxWidthSpaces = 9}) {
    List<VmcRow> rows = <VmcRow>[];

    return Vmc(
        vmcId: id,
        code: code,
        description: description,
        rows: rows,
        vmcConfiguration: VmcConfiguration(
            maxWidthSpaces: maxWidthSpaces,
            maxRows: maxRows,
            tickInSingleSpace: tickInSingleSpace,
            vmcConfigurationId: configurationId));
  }

  Map<String, dynamic> toJson() => _$VmcToJson(this);

  static Vmc fromJsonModel(Map<String, dynamic> json) => Vmc.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props =>
      [code, description, vmcPhysicsConfigurationId, vmcConfigurationId];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  /*Space? add(Item item) {
    if (rows != null) {
      for (VmcRow row in rows!.reversed) {
        Space? freeSpace = row.firstFreeSpaceWith(0.25);//row.firstFreeSpaceWith(item.itemConfiguration!.widthSpaces!);
        if (freeSpace!=null){
        var space = row.addItem(freeSpace, item);
        return space;
        }

      }
    }
    return null;
  }*/
  Space? add(VmcItem item) {
    if (rows != null) {
      for (VmcRow row in rows!.reversed) {
        double? freeSpacePosition =
            row.getFirstFreeSpacePosition(); //row.firstFreeSpaceWith(0.25);
        if (freeSpacePosition != null &&
            item.itemConfiguration!.widthSpaces <=
                row.freeSpacesAtRightOf(freeSpacePosition)) {
          //c'è lo spazio sulla destra per contenere l'item

          var space = row.addItem(freeSpacePosition, item);
          if (space != null) {
            return space;
          }
        }
      }
    }
    return null;
  }

  Space? trySwitch(int rowIndexStart, int rowIndexEnd, int spaceIndexStart,
      int spaceIndexEnd) {
    /*  var start = rows![rowIndexStart].spaces[spaceIndexStart].copyWith();
    var end = rows![rowIndexEnd].spaces[spaceIndexEnd].copyWith();
    if (start.currentWidthSpaces==end.currentWidthSpaces){
      rows![rowIndexStart].spaces[spaceIndexStart]=start.copyWith(item: end.item);
      rows![rowIndexEnd].spaces[spaceIndexEnd]=end.copyWith(item: start.item);

      return end;
    }
*/
    return null;
  }
/*Space? addOld(Item item) {
    if (rows != null) {
      for (VmcRow row in rows!.reversed) {
        for (Space space in row.spaces){
          if (space.item == null && space.widthSpaces!>=(item.itemConfiguration?.widthSpaces ?? 1)){
            row.spaces.remove(space);
            Space spaceNew = Space(position: space.position ?? 0, item: item, row: row);
            row.spaces.add(spaceNew);
            double remainingWidth = space.widthSpaces! - (spaceNew.item?.itemConfiguration?.widthSpaces ?? 1);
            if (remainingWidth>0) {
              row.spaces.add(Space(position: (spaceNew.position ?? 0) +
                  (space.item?.itemConfiguration?.widthSpaces ?? 1),
                  item: null, row: row, widthSpaces: remainingWidth)
              );
            }
            return spaceNew;
          }
        }
        */ /*Space? maxSpace = row.maxSpace;
        if (maxSpace!=null){
          if (maxSpace.widthSpaces!>=(item.itemConfiguration?.widthSpaces ?? 1)){
            row.spaces.remove(maxSpace);
            Space space = Space(position: maxSpace.position ?? 0, item: item, row: row);
            row.spaces.add(space);
            double remainingWidth = maxSpace.widthSpaces! - (space.item?.itemConfiguration?.widthSpaces ?? 1);
            row.spaces.add(Space(position: space.position! + (space.item?.itemConfiguration?.widthSpaces ?? 1),
                item: null, row: row, widthSpaces: remainingWidth)
            );

            return space;
          }
        }*/ /*

      }
    }
    return null;
  }*/
/* Space? addItem(VmcRow row, Item item) {
    if (

        ///se lo spazio disponibile è >= allo spazio richiesto
        row.maxWidthSpaces! - row.maxPosition >=
            (item.itemConfiguration?.widthSpaces ?? 0)) {
      Space space = Space(position: row.maxPosition, item: item, row: row);
      row.spaces.add(space);
      return space;
    }
    return null;
  }*/

/*void fillRemainingSpace() {
    if (rows != null) {
      for (VmcRow row in rows!) {
        if (row.maxWidthSpaces! - row.maxPosition > 0) {
          //se c'è ancora spazio disponibile inserisco uno space senza articolo

          Space space = Space(
              position: row.maxWidthSpaces! - row.maxPosition,
              item: null,
              row: row,
              widthSpaces: row.maxWidthSpaces! - row.maxPosition);
          row.spaces.add(space);
        }
      }
    }
  }*/

  double getRowHeight(BoxConstraints constraints, int index,
      {bool showRealDimension = false}) {
    double rowSpace =
    (constraints.heightConstraints().maxHeight / (rows?.length ?? 1.0));
    if (index == -1) {
      return rowSpace;
    }

    if (showRealDimension) {
      VmcRow? row = rows?[index];
      //debugPrint("spazio libero tra i cassetti ${(((1260/125) - vmcToUse.maxRows!)/vmcToUse.maxRows!)}");

      double totalMaxHeight = rows!.fold(
          0.0, (previousValue, element) => previousValue + element.maxHeight);

      double rowHeight = ((constraints.heightConstraints().maxHeight *
          ((125 / 1260)) *
          ((row?.maxHeight ?? 1) +
              (totalMaxHeight < (1260 / 125)
                  ? (((1260 / 125) - totalMaxHeight) / rows!.length)
                  : 0))));
      //(((1260/125) - vmcToUse.maxRows!)/vmcToUse.maxRows!) /// <<-- spazio libero minimo tra i cassetti

      // debugPrint("rowHeight: ${index} ${rowHeight.toString()}");
      //if (rowHeight > rowSpace) {
      rowSpace = rowHeight;
      //}
    }
    return rowSpace;
  }
}
