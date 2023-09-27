import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vmc_row.g.dart';

@JsonSerializable()
@CopyWith(copyWithNull: true)
class VmcRow extends Equatable implements JsonPayload {
  VmcRow(
      {required this.id,
      required this.rowIndex,
      required this.maxWidthSpaces,
      this.json});

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  final int maxWidthSpaces;
  final int id;
  final int rowIndex;

  final List<Space> _spaces = <Space>[];
  final List<Space> _ticks = <Space>[];

  List<Space> get spaces => _spaces;

  List<Space> get ticks => _ticks;

  set ticks(List<Space> newTicks) {
    _ticks.clear();
    for (var tick in newTicks) {
      _ticks.add(tick);
    }
  }

  set spaces(List<Space> newSpaces) {
    _spaces.clear();
    for (var space in newSpaces) {
      _spaces.add(space);
    }
  }

  ///dimensione occupata dagli space
  double get maxPosition {
    double result = 0;

    for (Space space in spaces) {
      result += space.currentWidthSpaces;
    }

    return result;
  }

  ///dimensione occupata dagli item
  double get maxItemPosition {
    double result = 0;

    for (Space space in spaces) {
      if (space.isNotEmpty) {
        if ((space.position ?? 0) + space.currentWidthSpaces > result) {
          result = (space.position ?? 0) + space.currentWidthSpaces;
        }
      }
    }

    return result;
  }

  ///totale spazi occupati dagli item
  double get totalOccupiedSpaceOld {
    double result = 0;

    for (Space space in spaces) {
      result += space.currentOccupiedWidthSpaces;
    }

    return result;
  }

  ///spazio libero disponibile nella riga indipendentemente dalla posizione degli item
  double get totalFreeSpaceOld {
    return maxWidthSpaces.toDouble() - totalOccupiedSpaceOld;
  }

  double get totalFreeSpace {
    double freeSpace = 0;
    for (double position = 0;
        position < maxWidthSpaces.toDouble();
        position += 0.25) {
      if (hasItemInPosition(spaces, position)) {} else {
        freeSpace += 0.25;
      }
    }

    return freeSpace;
  }

  double get totalOccupiedSpace {
    double occupiedSpace = 0;
    for (double position = 0;
        position < maxWidthSpaces.toDouble();
        position += 0.25) {
      if (hasItemInPosition(spaces, position)) {
        occupiedSpace += 0.25;
      } else {}
    }
    return occupiedSpace;
  }

  ///spazio libero più grande
  double get maxFreeSpace {
    double result = 0;

    for (Space space in spaces) {
      double value = space.item == null ? space.widthSpaces! : 0;
      if (value > result) {
        result = value;
      }
    }

    return result;
  }

  ///spazio libero più grande
  Space? get maxSpace {
    double result = 0;
    Space? spaceResult;

    for (Space space in spaces) {
      double value = space.item == null ? space.widthSpaces! : 0;
      if (value > result) {
        result = value;
        spaceResult = space;
      }
    }

    return spaceResult;
  }

/*

  Space? addItemInSpace(Space space, Item item){

    double totalMerged=0.25;
    for (int index =0; index < spaces.length; index++){
      if (space.position == spaces[index].position){
        spaces[index] = spaces[index].copyWith(item: item, widthSpaces: null);
        if (index + 1 < spaces.length) {
          for (int nextIndex = index + 1; nextIndex <
              spaces.length; nextIndex++) {
            spaces[nextIndex] = spaces[nextIndex].copyWith(visible: false);
            totalMerged+=spaces[nextIndex].widthSpaces!;
            if (totalMerged>=item.itemConfiguration!.widthSpaces!){
              return spaces[index];
            }
          }
        }
        return null;
      }

    }
    return null;
  }
*/

  Space? getSpaceAtPosition(double position, {Space? excludeSpace}) {
    for (Space space in spaces) {
      if (excludeSpace == null || excludeSpace != space) {
        if (space.position == position) {
          return space;
        }
      }
    }
    return null;
  }

  int? getSpaceIndexAtPosition(double position) {
    for (int index = 0; index < spaces.length; index++) {
      Space space = spaces[index];
      if (space.position == position) {
        return index;
      }
    }
    return null;
  }

  Space? getNextEmptySpace() {
    for (Space space in spaces) {
      if (space.isEmpty) {
        return space;
      }
    }
    return null;
  }

  int? getNextEmptyIndex() {
    for (int index = 0; index < spaces.length; index++) {
      if (spaces[index].isEmpty) {
        return index;
      }
    }
    return null;
  }

  void setSpaceAtPosition(double position, Space spaceToSet) {
    for (int index = 0; index < spaces.length; index++) {
      Space space = spaces[index];
      if (space.position == position) {
        spaces[index] = spaceToSet;
        return;
      }
    }
  }

  /*Space? addItem(double spacePosition, Item item){
    Space? newSpace = getSpaceAtPosition(spacePosition);


      if (freeSpacesAtLeftOf(spacePosition) >=
          item.itemConfiguration!.widthSpaces! ||
          freeSpacesAtRightOf(spacePosition) >=
              item.itemConfiguration!.widthSpaces!
      ) {
        ///lo spazio per contenere l'item c'è
        ///ora verifico in che space vuole essere inserito
        ///sposto tutti gli item a destra
        List<Space> newSpaceConfig = <Space>[];
        Space? newSpace = getSpaceAtPosition(spacePosition);
        newSpaceConfig.add(
            newSpace!.copyWith(item: item, widthSpaces: null, visible: true, position: spacePosition));

        //int spaceIndex = ((newSpace.position ?? 0) * 4).toInt();
        double widthCount = item.itemConfiguration!.widthSpaces!;
        //Space toCalculateWidth = newSpace;

        for (double position =spacePosition; position < maxWidthSpaces!.toDouble(); position+=0.25){
          var spaceInThisPos = getSpaceAtPosition(position);

          if (spaceInThisPos!=null && spaceInThisPos.isNotEmpty){

            if (widthCount > 0) {
              newSpaceConfig.add(spaceInThisPos.copyWith(
                  item: spaceInThisPos.item,
                  position: (spaceInThisPos.position ?? 0) + widthCount,
                  visible: true));
              //toCalculateWidth = spaceInThisPos;
              */ /*if (widthCount <= 0) {
            ///non ho più necessità di spostare gli item

          } else {
            ///se si sovrappone con un altro item
            ///if ((spaces[index].position ?? 0)<item.itemConfiguration!.widthSpaces! + (space.position ?? 0)){
            //             widthCount = spaces[index].position;
            //           }
            //newSpaceConfig.add(value)
          }*/ /*
            } else {
              newSpaceConfig.add(spaceInThisPos.copyWith(visible: true));
            }
          } else {
            if (! _hasItemInPosition(spaces, position)){
              widthCount = widthCount - 0.25;
            }

          }

        }
        ///inserisco anche quelli a sinistra
        for (double position =spacePosition-0.25; position >=0; position-=0.25){
          Space? spaceAtPosition=getSpaceAtPosition(position);
          if (spaceAtPosition!=null && spaceAtPosition.isNotEmpty){
            newSpaceConfig.insert(0,spaceAtPosition.copyWith(visible: true));
          }
        }


        ///riordinamento in base a position
        newSpaceConfig.sort((x,y) => (x.position ?? 0).compareTo(y.position ?? 0));

        ///ho la nuova configurazione degli item, ricreo gli space in modo da rispettare la nuova configurazione
        for (int index = 0; index < spaces.length; index++) {
          if (index < newSpaceConfig.length) {
            spaces[index] = newSpaceConfig[index];
          } else {
            spaces[index] = spaces[index].copyWith(

                item: null, widthSpaces: 0.25, visible: false);
          }
        }

        ///ora devo nascondere gli space vuoti che occupano la posizione dell'item
      updateTicks();
        return newSpace;
      } else {
        return null;
      }



    */ /*double totalMerged=0.25;
    for (int index =0; index < spaces.length; index++){
      if (space.position == spaces[index].position){
        spaces[index] = spaces[index].copyWith(item: item, widthSpaces: null);
        if (index + 1 < spaces.length) {
          for (int nextIndex = index + 1; nextIndex <
              spaces.length; nextIndex++) {
            spaces[nextIndex] = spaces[nextIndex].copyWith(visible: false);
            totalMerged+=spaces[nextIndex].widthSpaces!;
            if (totalMerged>=item.itemConfiguration!.widthSpaces!){
              return spaces[index];
            }
          }
        }
        return null;
      }

    }*/ /*
    return null;
  }
*/

  bool canAddItem(double spacePosition, VmcItem item) {
    if ((spacePosition + item.itemConfiguration!.widthSpaces) <=
        maxWidthSpaces) {
      if (freeSpacesAtLeftOf(spacePosition) >=
          item.itemConfiguration!.widthSpaces) {
        //sinistra
        return true;
        // debugPrint("direction : 0");
      } else if (freeSpacesAtRightOf(spacePosition) >=
          item.itemConfiguration!.widthSpaces) {
        //destra
        return true;
        //debugPrint("direction : 1");
      }
    } else {
      //debugPrint("$spacePosition + ${item.itemConfiguration!.widthSpaces!} >= ${maxWidthSpaces!}");
    }
    return false;
  }

  Space? addItem(double spacePosition, VmcItem item, {Space? excludeSpace}) {
    int? direction;
    List<Space> collisions = getSpaceCollisions(
        spaces
            .where((element) => excludeSpace == null || element != excludeSpace)
            .toList(growable: false),
        spacePosition,
        spacePosition + item.itemConfiguration!.widthSpaces);
    double collisionWidth = collisions.fold(0,
        (previousValue, element) => previousValue + element.currentWidthSpaces);

    if ((spacePosition + item.itemConfiguration!.widthSpaces) <=
            maxWidthSpaces &&
        spacePosition >= 0) {
      /*if (collisions.isEmpty && (freeSpacesAtRightOfPosition(spacePosition, excludeSpace) >=
          item.itemConfiguration!.widthSpaces!)){
        ///c'è abbastanza spazio sulla destra per contenere l'item
        //destra
        direction = 1;
      } else {

      }*/

      ///cè abbastanza spazio sulla destra per contenere l'item?
      if (collisions
          .isEmpty /*? true : collisions[0].position==spacePosition*/) {
        //destra
        direction = 1;
      } else {
        ///collisioni rilevate

        ///[ []] -> s1 < s2 && e1>s2  ->collido sulla destra
        ///[[] ] -> s1 > s2 && e2>s1  ->collido sulla sinistra
        debugPrint("collisions lenght: ${collisions.length}");
        if (collisions.length == 1) {
          ///per ora gestisco come valide solo le collisioni con un solo spazio
          double start1 = spacePosition;
          double end1 = spacePosition + item.itemConfiguration!.widthSpaces;
          double start2 = collisions[0].position ?? 0;
          double end2 =
              (collisions[0].position ?? 0) + collisions[0].currentWidthSpaces;

          if (start1 == start2) {
            debugPrint("start1==start2");
            if (freeSpacesAtRightOfPosition(spacePosition, excludeSpace) >=
                item.itemConfiguration!.widthSpaces) {
              direction = 1;
            }
          } else if (start1 < start2 && end1 > start2) {
            debugPrint("collido sulla destra");

            ///collido sullo destra
            ///c'è abbastanza spazio libero sulla destra?
            if (freeSpacesAtRightOfPosition(spacePosition, excludeSpace) >=
                item.itemConfiguration!.widthSpaces) {
              direction = 1;
            }
          } else if (start1 > start2 && end2 > start1) {
            ///collido sullo sinistra
            ///c'è abbastanza spazio a sinistra per contenere gli oggetti con cui collido
            debugPrint("collido sulla sinistra");
            if (freeSpacesAtLeftOfPosition(spacePosition, excludeSpace) >=
                collisionWidth -
                    (spacePosition - (collisions[0].position ?? 0))) {
              //sinistra
              direction = 0;
            } else {
              print(
                  "freeSpacesAtLeftOf(spacePosition($spacePosition)): ${freeSpacesAtLeftOf(spacePosition)}");
              print(
                  "freeSpacesAtLeftOf(spacePosition($spacePosition)): ${freeSpacesAtLeftOf(spacePosition)}");
            }
          } else {
            debugPrint("non ho rilevato collisioni");
          }
        } else {
          debugPrint("collisioni superiori a uno");
        }
      }
    } else {
      debugPrint(
          "$spacePosition + ${item.itemConfiguration!.widthSpaces} >= $maxWidthSpaces");
    }

    if (direction != null) {
      List<Space> newSpaceConfig = <Space>[];
      Space? newSpace = getNextEmptySpace();
      newSpace = newSpace?.copyWith(
          item: item,
          widthSpaces: null,
          visible: true,
          position: spacePosition /*, row: this*/);

      newSpaceConfig.add(newSpace!);

      if (direction == 0) {
        ///quanto collido sulla sinistra
        double widthCount =
            ((collisions[0].position ?? 0) + collisions[0].currentWidthSpaces) -
                spacePosition;
        for (double position = spacePosition; position >= 0; position -= 0.25) {
          var spaceInThisPos =
              getSpaceAtPosition(position, excludeSpace: excludeSpace);

          if (spaceInThisPos != null && spaceInThisPos.isNotEmpty) {
            //debugPrint("position: $position - spaceInThisPos.position: ${(spaceInThisPos!.position ?? 0)} position-widthCount : ${(spaceInThisPos?.position ?? 0) - widthCount}");

            if (widthCount > 0) {
              newSpaceConfig.add(spaceInThisPos.copyWith(
                  item: spaceInThisPos.item,
                  position: (spaceInThisPos.position ?? 0) - widthCount,
                  visible: true,
                  rowIndex: rowIndex));
            } else {
              newSpaceConfig.add(
                  spaceInThisPos.copyWith(visible: true, rowIndex: rowIndex));
            }
          } else {
            if (!hasItemInPosition(
                spaces
                    .where((element) =>
                        excludeSpace == null || element != excludeSpace)
                    .toList(),
                position)) {
              widthCount = widthCount - 0.25;
            }
          }
        }

        ///inserisco anche quelli a destra
        for (double position = spacePosition + 0.25;
            position < maxWidthSpaces.toDouble();
            position += 0.25) {
          Space? spaceAtPosition =
              getSpaceAtPosition(position, excludeSpace: excludeSpace);
          if (spaceAtPosition != null && spaceAtPosition.isNotEmpty) {
            newSpaceConfig.insert(
                0, spaceAtPosition.copyWith(visible: true, rowIndex: rowIndex));
          }
        }
      } else if (direction == 1) {
        ///quanto collido sulla destra (e1 - start2)
        double end1 = spacePosition + item.itemConfiguration!.widthSpaces;
        double start2 = collisions.isEmpty ? 0 : collisions[0].position ?? 0;

        double widthCount = item.itemConfiguration!
            .widthSpaces; //collisions.isEmpty ? 0 : end1-start2;//item.itemConfiguration!.widthSpaces!;
        debugPrint("###################WIDTH COUNT---------> $widthCount");

        for (double position = spacePosition;
            position < maxWidthSpaces.toDouble();
            position += 0.25) {
          var spaceInThisPos =
              getSpaceAtPosition(position, excludeSpace: excludeSpace);

          if (spaceInThisPos != null && spaceInThisPos.isNotEmpty) {
            if (widthCount > 0) {
              newSpaceConfig.add(spaceInThisPos.copyWith(
                  item: spaceInThisPos.item,
                  position: (spaceInThisPos.position ?? 0) + widthCount,
                  visible: true,
                  rowIndex: rowIndex));
            } else {
              newSpaceConfig.add(
                  spaceInThisPos.copyWith(visible: true, rowIndex: rowIndex));
            }
          } else {
            if (!hasItemInPosition(
                spaces
                    .where((element) =>
                        excludeSpace == null || element != excludeSpace)
                    .toList(),
                position)) {
              widthCount = widthCount - 0.25;
            }
          }
        }

        ///inserisco anche quelli a sinistra
        for (double position = spacePosition - 0.25;
        position >= 0;
        position -= 0.25) {
          Space? spaceAtPosition =
              getSpaceAtPosition(position, excludeSpace: excludeSpace);
          if (spaceAtPosition != null && spaceAtPosition.isNotEmpty) {
            newSpaceConfig.insert(
                0, spaceAtPosition.copyWith(visible: true, rowIndex: rowIndex));
          }
        }
      }

      ///riordinamento in base a position
      newSpaceConfig
          .sort((x, y) => (x.position ?? 0).compareTo(y.position ?? 0));

      ///ho la nuova configurazione degli item, ricreo gli space in modo da rispettare la nuova configurazione

      for (int index = 0; index < spaces.length; index++) {
        Space? spaceFounded;
        for (Space spaceConfig in newSpaceConfig) {
          if (spaceConfig.id == spaces[index].id) {
            spaceFounded = spaceConfig;
            break;
          }
        }
        if (spaceFounded != null) {
          spaces[index] = spaceFounded;
        } else {
          spaces[index] = spaces[index].copyWith(
              position: null,
              item: null,
              widthSpaces: 0.25,
              visible: false,
              rowIndex: rowIndex);
        }
      }

      ///ora devo nascondere gli space vuoti che occupano la posizione dell'item
      updateTicks();
      return newSpace;
    } else {
      debugPrint("direction is null!!!!!!!!!!!");
    }
    return null;

    /*if (freeSpacesAtLeftOf(spacePosition) >=
        item.itemConfiguration!.widthSpaces! ||
        freeSpacesAtRightOf(spacePosition) >=
            item.itemConfiguration!.widthSpaces!
    ) {
      ///lo spazio per contenere l'item c'è
      ///ora verifico in che space vuole essere inserito
      ///sposto tutti gli item a destra
      List<Space> newSpaceConfig = <Space>[];
      Space? newSpace = getNextEmptySpace();
      newSpaceConfig.add(
          newSpace!.copyWith(item: item, widthSpaces: null, visible: true, position: spacePosition));

      //int spaceIndex = ((newSpace.position ?? 0) * 4).toInt();
      double widthCount = item.itemConfiguration!.widthSpaces!;
      //Space toCalculateWidth = newSpace;

      for (double position =spacePosition; position < maxWidthSpaces!.toDouble(); position+=0.25){
        var spaceInThisPos = getSpaceAtPosition(position);

        if (spaceInThisPos!=null && spaceInThisPos.isNotEmpty){
          if (widthCount > 0) {
            newSpaceConfig.add(spaceInThisPos.copyWith(
                item: spaceInThisPos.item,
                position: (spaceInThisPos.position ?? 0) + widthCount,
                visible: true));
          } else {
            newSpaceConfig.add(spaceInThisPos.copyWith(visible: true));
          }
        } else {
          if (! _hasItemInPosition(spaces, position)){
            widthCount = widthCount - 0.25;
          }

        }

      }
      ///inserisco anche quelli a sinistra
      for (double position =spacePosition-0.25; position >=0; position-=0.25){
        Space? spaceAtPosition=getSpaceAtPosition(position);
        if (spaceAtPosition!=null && spaceAtPosition.isNotEmpty){
          newSpaceConfig.insert(0,spaceAtPosition.copyWith(visible: true));
        }
      }


      ///riordinamento in base a position
      newSpaceConfig.sort((x,y) => (x.position ?? 0).compareTo(y.position ?? 0));

      ///ho la nuova configurazione degli item, ricreo gli space in modo da rispettare la nuova configurazione

      for (int index = 0; index < spaces.length; index++) {


          Space? spaceFounded;
          for (Space spaceConfig in newSpaceConfig){
            if (spaceConfig.id == spaces[index].id){
              spaceFounded = spaceConfig;
              break;
            }
          }
          if (spaceFounded!=null){
            spaces[index]=spaceFounded;
          } else {
            spaces[index] = spaces[index].copyWith(
                position: null,
                item: null, widthSpaces: 0.25, visible: false);
          }



      }

      ///ora devo nascondere gli space vuoti che occupano la posizione dell'item
      updateTicks();
      return newSpace;
    } else {
      return null;
    }*/

    /*double totalMerged=0.25;
    for (int index =0; index < spaces.length; index++){
      if (space.position == spaces[index].position){
        spaces[index] = spaces[index].copyWith(item: item, widthSpaces: null);
        if (index + 1 < spaces.length) {
          for (int nextIndex = index + 1; nextIndex <
              spaces.length; nextIndex++) {
            spaces[nextIndex] = spaces[nextIndex].copyWith(visible: false);
            totalMerged+=spaces[nextIndex].widthSpaces!;
            if (totalMerged>=item.itemConfiguration!.widthSpaces!){
              return spaces[index];
            }
          }
        }
        return null;
      }

    }*/
  }

  void updateTicks() {
    ///ora devo nascondere gli space vuoti che occupano la posizione dell'item
    for (double position = 0;
        position < maxWidthSpaces.toDouble();
        position += 0.25) {
      int index = (position * 4).toInt();
      if (hasItemInPosition(spaces, position, excludeStarOfItem: false)) {
        ticks[index] = ticks[index].copyWith(visible: false);
      } else {
        ticks[index] = ticks[index].copyWith(visible: true);
      }
    }
  }

  /*Space? addItemOld(Space space, Item item){
    if (freeSpaceAtLeftOf(space.position ?? 0)>=item.itemConfiguration!.widthSpaces! ||
        freeSpaceAtRightOf(space.position ?? 0)>=item.itemConfiguration!.widthSpaces!
    ){
      ///lo spazio per contenere l'item c'è
      ///ora verifico in che space vuole essere inserito
      ///sposto tutti gli item a destra
      List<Space> newSpaceConfig = <Space>[];
      newSpaceConfig.add(space.copyWith(item: item, widthSpaces: null, visible: true));

      int spaceIndex = ((space.position ?? 0) * 4).toInt();
      double widthCount = item.itemConfiguration!.widthSpaces!;
      Space toCalculateWidth = space;
      for (int index = spaceIndex; index<spaces.length; index++){


        if (spaces[index].isNotEmpty) {
          widthCount = widthCount - ((spaces[index].position ?? 0)-(toCalculateWidth.position ?? 0));
          if (widthCount>0){
          newSpaceConfig.add(spaces[index].copyWith(item: spaces[index].item, position: (spaces[index].position ?? 0) + widthCount, visible: true));
          toCalculateWidth = spaces[index];
          */ /*if (widthCount <= 0) {
            ///non ho più necessità di spostare gli item

          } else {
            ///se si sovrappone con un altro item
            ///if ((spaces[index].position ?? 0)<item.itemConfiguration!.widthSpaces! + (space.position ?? 0)){
            //             widthCount = spaces[index].position;
            //           }
            //newSpaceConfig.add(value)
          }*/ /*
        } else {
            newSpaceConfig.add(spaces[index].copyWith());
          }


        }
      }
      for (int index = spaceIndex-1; index>=0; index--){
        if (spaces[index].isNotEmpty) {
          newSpaceConfig.add(spaces[index].copyWith());
        }
      }

      ///ho la nuova configurazione degli item, ricreo gli space in modo da rispettare la nuova configurazione
      for (int index = 0; index<spaces.length; index++){
        ///esiste un item in newSpaceConfig nella posizione in cui mi trovo
        Space? foundedItem;
        for (var spaceConfig in newSpaceConfig) {
          if (spaces[index].position == spaceConfig.position){
            foundedItem=spaceConfig;
            break;
          }
        }
        if (foundedItem!=null){
          spaces[index]=spaces[index].copyWith(item: foundedItem.item, widthSpaces: null, visible: true);
        } else {
          spaces[index]=spaces[index].copyWith(item: null, widthSpaces: 0.25, visible: true);
        }
      }

      ///ora devo nascondere gli space vuoti che occupano la posizione dell'item
      for (int index = 0; index<spaces.length; index++){
        if (_hasItemInPosition(newSpaceConfig, (spaces[index].position ?? 0))){
          spaces[index] = spaces[index].copyWith(visible: false);
        } else {
          spaces[index] = spaces[index].copyWith(visible: true);
        }
      }
    }



    */ /*double totalMerged=0.25;
    for (int index =0; index < spaces.length; index++){
      if (space.position == spaces[index].position){
        spaces[index] = spaces[index].copyWith(item: item, widthSpaces: null);
        if (index + 1 < spaces.length) {
          for (int nextIndex = index + 1; nextIndex <
              spaces.length; nextIndex++) {
            spaces[nextIndex] = spaces[nextIndex].copyWith(visible: false);
            totalMerged+=spaces[nextIndex].widthSpaces!;
            if (totalMerged>=item.itemConfiguration!.widthSpaces!){
              return spaces[index];
            }
          }
        }
        return null;
      }

    }*/ /*
    return null;
  }*/

  bool hasItemInPosition(List<Space> newSpaceConfig, double position,
      {bool excludeStarOfItem = false}) {
    for (Space space in newSpaceConfig) {
      //if (space.row!  == this) {
      if (space.isNotEmpty) {
        if (excludeStarOfItem) {
          if (position > (space.position ?? 0) &&
              position < (space.position ?? 0) + space.currentWidthSpaces) {
            return true;
          }
        } else {
          if (position >= (space.position ?? 0) &&
              position < (space.position ?? 0) + space.currentWidthSpaces) {
            return true;
          }
        }
      }
      //}
    }
    return false;
  }

  Space? getSpaceCollision(List<Space> newSpaceConfig, double startPosition, double endPosition,
      {bool excludeStarOfItem = false}) {
    for (Space space in newSpaceConfig) {
      ///siamo nella stessa riga
      if (space.isNotEmpty) {
        if (excludeStarOfItem) {
          if (startPosition > (space.position ?? 0) &&
              startPosition <
                  (space.position ?? 0) + space.currentWidthSpaces ||
              endPosition > (space.position ?? 0) &&
                  endPosition <
                      (space.position ?? 0) + space.currentWidthSpaces) {
            return space;
          }
        } else {
          /*if (RectA.Left < RectB.Right && RectA.Right > RectB.Left &&
                RectA.Top > RectB.Bottom && RectA.Bottom < RectB.Top )*/
          if (startPosition <
              (space.position ?? 0) + space.currentWidthSpaces &&
              endPosition > (space.position ?? 0)) {
            return space;
          }
        }
      }
    }
    return null;
  }

  List<Space> getSpaceCollisions(List<Space> newSpaceConfig, double startPosition, double endPosition) {
    List<Space> collisions = <Space>[];

    for (Space space in newSpaceConfig) {
      ///siamo nella stessa riga
      if (space.isNotEmpty) {
        /*if (RectA.Left < RectB.Right && RectA.Right > RectB.Left &&
                RectA.Top > RectB.Bottom && RectA.Bottom < RectB.Top )*/
        if (startPosition < (space.position ?? 0) + space.currentWidthSpaces &&
            endPosition > (space.position ?? 0)) {
          collisions.add(space);
        }
      }
    }
    return collisions;
  }

  ///spazio libero totale alla destra di space.position (position compreso)
  ///versione con grid lines
  double freeSpacesAtRightOf(double position) {
    double totalPositions = maxWidthSpaces.toDouble();
    double totalFreeSpace = 0;
    for (double pos = position; pos < totalPositions; pos += 0.25) {
      if (!hasItemInPosition(spaces, pos, excludeStarOfItem: false)) {
        totalFreeSpace += 0.25;
      }
    }
    return totalFreeSpace;
  }

  ///spazio libero totale alla destra di space.position (position compreso)
  ///versione con grid lines
  double freeSpacesAtRightOfPosition(double position, Space? excludeSpace) {
    if (excludeSpace == null) {
      return freeSpacesAtRightOf(position);
    }

    double totalPositions = maxWidthSpaces.toDouble();
    double totalFreeSpace = 0;
    for (double pos = position; pos < totalPositions; pos += 0.25) {
      if (!hasItemInPosition(
          spaces
              .where((element) => element != excludeSpace)
              .toList(growable: false),
          pos,
          excludeStarOfItem: false)) {
        totalFreeSpace += 0.25;
      }
    }
    return totalFreeSpace;
  }

  ///quanto overlappa l'item rispetto un eventuale altro item nell'attuale posizione
  double overlappingWidth(double position) {
    double totalPositions = maxWidthSpaces.toDouble();
    double totalOverlappingWidth = 0;
    for (double pos = position; pos < totalPositions; pos += 0.25) {
      if (hasItemInPosition(spaces, pos, excludeStarOfItem: false)) {
        totalOverlappingWidth += 0.25;
      }
    }
    return totalOverlappingWidth;
  }

  ///spazio libero totale alla destra di space.position (position compreso)
  ///versione con grid lines
  double freeSpacesAtLeftOf(double position) {
    double totalFreeSpace = 0;
    for (double pos = position; pos >= 0; pos -= 0.25) {
      if (!hasItemInPosition(spaces, pos, excludeStarOfItem: false)) {
        totalFreeSpace += 0.25;
      }
    }
    return totalFreeSpace;
  }

  ///spazio libero totale alla destra di space.position (position compreso)
  ///versione con grid lines
  double freeSpacesAtLeftOfPosition(double position, Space? excludeSpace) {
    if (excludeSpace == null) {
      return freeSpacesAtLeftOf(position);
    }

    double totalFreeSpace = 0;
    for (double pos = position; pos >= 0; pos -= 0.25) {
      if (!hasItemInPosition(
          spaces
              .where((element) => element != excludeSpace)
              .toList(growable: false),
          pos,
          excludeStarOfItem: false)) {
        totalFreeSpace += 0.25;
      }
    }
    return totalFreeSpace;
  }

  ///spazio libero totale alla destra di space.position (position compreso)
  double freeSpaceAtRightOf(double position) {
    double totalFreeSpace = 0;
    int startIndex = (position * 4).toInt();
    for (int index = startIndex; index < spaces.length; index++) {
      if (spaces[index].isEmpty) {
        totalFreeSpace += spaces[index].currentWidthSpaces;
      }
    }
    return totalFreeSpace;
  }

  ///spazio libero totale alla destra di space.position (position compreso)
  double freeSpaceAtLeftOf(double position) {
    double totalFreeSpace = 0;
    int startIndex = (position * 4).toInt();
    for (int index = spaces.length - 1; index >= startIndex; index--) {
      if (spaces[index].isEmpty) {
        totalFreeSpace += spaces[index].currentWidthSpaces;
      }
    }
    return totalFreeSpace;
  }

  ///il primo spazio libero di grandezza = o superiore a widthSpace
  Space? firstFreeSpaceWith(double widthSpace) {
    for (double position = 0;
        position < maxWidthSpaces.toDouble();
        position += 0.25) {
      if (!hasItemInPosition(spaces, position)) {
        return getSpaceAtPosition(position);
      }
    }

    return null;
  }

  ///il primo spazio libero di grandezza = o superiore a widthSpace
  Space? getFirstFreeSpace() {
    for (double position = 0;
        position < maxWidthSpaces.toDouble();
        position += 0.25) {
      if (!hasItemInPosition(spaces, position)) {
        int index = (position * 4).toInt();
        return spaces[index];
      }
    }

    return null;
  }

  double? getFirstFreeSpacePosition() {
    for (double position = 0;
        position < maxWidthSpaces.toDouble();
        position += 0.25) {
      if (!hasItemInPosition(spaces, position)) {
        return position;
      }
    }

    return null;
  }

  ///fonde gli spazi liberi vicini
  void mergeFreeSpaces() {
    if (spaces.length > 1) {
      for (int i = 1; i < spaces.length; i++) {
        Space aSpace = spaces[i - 1];
        Space bSpace = spaces[i];
        if (aSpace.widthSpaces != null && bSpace.widthSpaces != null) {
          //sono spazi liberi consecutivi
          spaces[i - 1] = aSpace.copyWith(
              widthSpaces: aSpace.widthSpaces! + bSpace.widthSpaces!);
          spaces.removeAt(i);
          mergeFreeSpaces();
          return;
        }
      }
    }
  }

  ///posizione dove ha inizio lo spazio libero più grande
  double get startMaxFreeSpacePosition {
    double maxValueIndex = 0;
    double result = 0;
    for (Space space in spaces) {
      double value = space.item == null ? space.widthSpaces! : 0;
      if (value > result) {
        result = value;
        maxValueIndex = space.position ?? 0;
      }
    }
    return maxValueIndex;
  }

  ///altezza massima dei prodotti inseriti negli spazi
  double get maxHeight {
    double max = 0;

    for (Space space in spaces) {
      double value = space.item == null
          ? 1
          : space.item!.itemConfiguration?.heightSpaces ?? 1;
      if (value > max) {
        max = value;
      }
    }

    return max;
  }

  void initSpacesAndTicks() {
    int index = 0;
    for (int spaceIndex = 0; spaceIndex < maxWidthSpaces; spaceIndex++) {
      for (int tickIndex = 0; tickIndex < 4; tickIndex++) {
        /*spaces.add(Space(row: this, widthSpaces: 0.25, position: (spaceIndex) + (0.25 * tickIndex), visible: false));*/
        spaces.add(Space(
            id: index,
            rowIndex: rowIndex,
            widthSpaces: 0.25,
            position: null,
            visible: false));
        ticks.add(Space(
            id: index,
            rowIndex: rowIndex,
            widthSpaces: 0.25,
            position: (spaceIndex) + (0.25 * tickIndex)));
        index++;
      }
    }
  }

  factory VmcRow.fromJson(Map<String, dynamic> json) {
    var result = _$VmcRowFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$VmcRowToJson(this);

  static VmcRow fromJsonModel(Map<String, dynamic> json) =>
      VmcRow.fromJson(json);

  @override
  VmcRow fromJsonModelL(Map<String, dynamic> json) => VmcRow.fromJson(json);

  /*@override
  bool operator ==(Object other) => other is ReportUser && other._name == _name;

  @override
  int get hashCode => _name.hashCode;*/

  @override
  List<Object?> get props => [maxWidthSpaces, id, spaces];

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;
}
