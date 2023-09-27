import 'dart:math';

import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/models/server/autogeneration/item_conf%C3%ACguration.dart';
import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/usage_configuration.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultVmcGenerator {
  List<VmcItem>? items;
  Vmc lvmc = Vmc.standardEmpty(1, 1, 'test', 'test');

  Vmc get vmc => lvmc;

  set vmc(Vmc vmc) {
    lvmc = vmc;
  }

  void setItem(int itemIndex, VmcItem item) {
    items?[itemIndex] = item;
  }

  DefaultVmcGenerator({this.items});

/*
  void generate() {
    items?.clear();
    items = List.generate(
        6,
        (index) => Item(
            code: index.toString(),
            description: 'Articolo $index',
            itemConfiguration: ItemConfiguration(
              depthSpaces: index % 3 == 0
                  ? 9
                  : index % 2 == 0
                      ? 6
                      : 18,
              heightSpaces: index % 3 == 0
                  ? 1
                  : index % 2 == 0
                      ? 1.5
                      : 1.3,
              widthSpaces: index % 3 == 0
                  ? 2
                  : index % 2 == 0
                      ? 2.5
                      : 1,
              photocell: index % 3 == 0
                  ? true
                  : index % 2 == 0
                      ? true
                      : false,
              engineType: index % 3 == 0
                  ? EngineType.double
                  : index % 2 == 0
                      ? EngineType.double
                      : EngineType.single,
            ),
            usageConfiguration: UsageConfiguration(
                value: index % 3 == 0
                    ? 50
                    : index % 2 == 0
                        ? 30
                        : 40)));

    items?.sort((x, y) =>
        y.usageConfiguration?.value
            ?.compareTo(x.usageConfiguration?.value ?? 0) ??
        -1);

    for (Item item in items!) {
      for (double value = item.usageConfiguration?.value ?? 0;
          value > 0;
          value -= item.itemConfiguration?.depthSpaces ?? 0) {
        Space? space = lvmc.add(item);
        if (space != null) {
          print('item added');
        } else {
          print('item not added');
        }
      }
    }
    lvmc.fillRemainingSpace();
  }
*/

  void generateTestItems() {
    items = <VmcItem>[];
    List<int> colors = <int>[];
    for (int i = 0; i < 50; i++) {
      colors.add(Color((Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0)
          .value);
    }
    items!.add(VmcItem(
        itemId: 1,
        item: const Item(itemId: 1, code: '1', description: 'Guanti pelle'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 2,
            heightSpaces: 1,
            depthSpaces: 9,
            photoCell: true,
            engineType: EngineType.double,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[0],
        usageConfiguration: const UsageConfiguration(value: 84)));
    items!.add(VmcItem(
        itemId: 2,
        item:
            const Item(itemId: 2, code: '2', description: 'Guanti antitaglio'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 2,
            heightSpaces: 1,
            depthSpaces: 9,
            photoCell: true,
            engineType: EngineType.double,
            vmc: vmc,
            vmcId: vmc.vmcId),
        color: colors[1],
        usageConfiguration: const UsageConfiguration(value: 54)));
    items!.add(VmcItem(
        itemId: 3,
        item:
            const Item(itemId: 3, code: '3', description: 'Guanti anticalore'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 2.5,
            heightSpaces: 1,
            depthSpaces: 6,
            photoCell: true,
            engineType: EngineType.double,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[2],
        usageConfiguration: const UsageConfiguration(value: 12)));
    items!.add(VmcItem(
        itemId: 4,
        item: const Item(itemId: 4, code: '4', description: 'Mascherina FFP2'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 1,
            heightSpaces: 1,
            depthSpaces: 9,
            photoCell: true,
            engineType: EngineType.single,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[3],
        usageConfiguration: const UsageConfiguration(value: 24)));
    items!.add(VmcItem(
        itemId: 5,
        item: const Item(
            itemId: 5, code: '5', description: 'Mascherine Chirurgiche'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 1,
            heightSpaces: 1,
            depthSpaces: 9,
            photoCell: true,
            engineType: EngineType.single,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[4],
        usageConfiguration: const UsageConfiguration(value: 30)));
    items!.add(VmcItem(
        itemId: 6,
        item: const Item(itemId: 6, code: '6', description: 'Mascherine FFP3'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 1,
            heightSpaces: 1,
            depthSpaces: 9,
            photoCell: true,
            engineType: EngineType.single,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[5],
        usageConfiguration: const UsageConfiguration(value: 42)));
    items!.add(VmcItem(
        itemId: 7,
        item: const Item(itemId: 7, code: '7', description: 'Occhiali'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 2,
            heightSpaces: 1,
            depthSpaces: 9,
            photoCell: true,
            engineType: EngineType.single,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[6],
        usageConfiguration: const UsageConfiguration(value: 18)));
    items!.add(VmcItem(
        itemId: 8,
        item:
            const Item(itemId: 8, code: '8', description: 'Cuffie antirumore'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 2.5,
            heightSpaces: 1,
            depthSpaces: 4,
            photoCell: true,
            engineType: EngineType.double,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[7],
        usageConfiguration: const UsageConfiguration(value: 4)));
    items!.add(VmcItem(
        itemId: 9,
        item: const Item(
            itemId: 9,
            code: '9',
            description: 'Otoprotettori (tappi acustici)'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 1,
            heightSpaces: 1,
            depthSpaces: 18,
            photoCell: true,
            engineType: EngineType.single,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[8],
        usageConfiguration: const UsageConfiguration(value: 18)));
    items!.add(VmcItem(
        itemId: 10,
        item: const Item(itemId: 99, code: '99', description: 'Cutter'),
        itemConfiguration: SampleItemConfiguration(
            widthSpaces: 1,
            heightSpaces: 1.3,
            depthSpaces: 14,
            photoCell: true,
            engineType: EngineType.single,
            vmcId: vmc.vmcId,
            vmc: vmc),
        color: colors[9],
        usageConfiguration: const UsageConfiguration(value: 18)));
  }

  /*Map<double, List<Item>> generate2() {
    lvmc = Vmc.standardEmpty();

*/ /*
    come accennato ad Alberto siamo pronti con quanto da voi richiesto dal punto di vista HW e SW.
    Di seguito invio modifica delle quantità di DPI da rendere disponibili nel distributore:
    1.	Guanti pelle  - pezzi totali 84
    2.	Guanti antitaglio – pezzi totali 54
    3.	Guanti anticalore ok 12
    4.	Mascherina FFP2-  pezzi totali 24
    5.	Mascherine chirurgiche - pezzi totali 30
    6.	Mascherina ffp3 con valvola – pezzi totali 42
    7.	Occhiali - almeno 18 pezzi
    8.	Cuffie antirumore ok 4
    9.	Otoprotettori (tappi acustici) almeno 18-20
*/ /*

    ///per ogni articolo
    ///creo un dizionario con chiave la dimensione widthSpaces e valore un array di articoli
    Map<double, List<Item>> map = <double, List<Item>>{};
    items?.forEach((element) {
      for (double value = element.usageConfiguration?.value ?? 0;
          value > 0;
          value -= element.itemConfiguration?.depthSpaces ?? 0) {
        if (map.containsKey(element.itemConfiguration!.widthSpaces!)) {
          ///contiene la dimensione richiesta
        } else {
          map.addAll({element.itemConfiguration!.widthSpaces!: <Item>[]});
        }

        ///aggiungo un nuovo elemento alla lista degli Item
        map[element.itemConfiguration!.widthSpaces!]!.add(element);
      }
    });

    ///ordino le chiavi
    var sortedKeys = map.keys.toList()..sort((x, y) => y.compareTo(x));

    ///per ogni chiave ordino gli elementi in base alla priorità (DESC)
    for (var element in sortedKeys) {
      map[element]?.sort((x, y) => y.usageConfiguration!.priority
          .compareTo(x.usageConfiguration!.priority));
    }

*/ /*    ///verifico che possa inserire un nuovo cassetto
    ///devo verificare a che altezza sono
    if (lvmc.currentMaxRowHeight<lvmc.maxHeightSpaces){

    }
    */ /*
    int rowIndex = 0;
    while (rowIndex < (vmc.maxRows ?? 0)) {
      ///verifico se c'è lo spazio per creare un cassetto
      double? maxHeight = vmc.rows?.fold(0, (previousValue, element) {
        return (previousValue is VmcRow
                ? (previousValue as VmcRow).maxHeight
                : (previousValue as double)) +
            (element.maxHeight + 0.25);
      });

      ///altezza / altezza cassetto = numero spazi per cassetto (in teoria il numero di cassetti massimo)
      ///(1260/125)
      ///se l'altezza raggiunta fin'ora ${maxHeight} + altezza minima cassetto < altezza massima possibile, inserisco il cassetto
      ///10(approsimazione
      int count = 0;
      for (var element in sortedKeys) {
        count += map[element]!.isEmpty ? 1 : 0;
      }
      bool isEmpty = count == sortedKeys.length; ///ho finito gli articoli

      if ((maxHeight ?? 0) + 1 < 10 && !isEmpty) {
        VmcRow row = VmcRow(maxWidthSpaces: vmc.maxWidthSpaces!, id: rowIndex);
        lvmc.rows!.insert(0, row);

        ///fino a che non ho riempito tutti gli spazi (e che ci siano chiavi da scorrere)
        int index = 0;
        while (index < sortedKeys.length &&
            row.maxPosition.toInt() != row.maxWidthSpaces) {
          ///se ci sono ancora dimensioni da cui pescare articoli
          //if (index<sortedKeys.length) {
          double widthSpaces = sortedKeys[index];
          List<Item> toRemove = <Item>[];

          ///se ci sono ancora articoli in questa dimensione
          if (map[widthSpaces]!.isNotEmpty) {
            map[widthSpaces]!.sort((x, y) {
              int cmp = y.usageConfiguration!.priority
                  .compareTo(x.usageConfiguration!.priority);
              if (cmp != 0) {
                return cmp;
              }
              return y.itemConfiguration!.heightSpaces!
                  .compareTo(x.itemConfiguration!.heightSpaces!);
            });

            ///scorro tutti gli item della dimensione e provo ad inserire l'item nello spazio
            for (int itemIndex = 0;
                itemIndex < map[widthSpaces]!.length;
                itemIndex++) {
              Item item = map[widthSpaces]![itemIndex];

              if (

                  ///se lo spazio disponibile è >= allo spazio richiesto
                  row.maxWidthSpaces! - row.maxPosition >=
                      (item.itemConfiguration?.widthSpaces ?? 0)) {
                ///inserisco l'item nella riga
                Space space =
                    Space(position: row.maxPosition, item: item, row: row);
                row.spaces.add(space);

                ///rimuovo l'item dalla lista della dimensione corrente
                toRemove.add(item);
              } else {
                ///non c'è spazio, provo a la dimensione successiva
                break;
              }
            }
            if (toRemove.isNotEmpty) {
              for (var element in toRemove) {
                map[widthSpaces]!.remove(element);
              }
            }
          }

          ///passo alla dimensione successiva
          index++;
        }

        ///non sono riuscito a riempiro tutta la riga, creo uno spazio dimensione mancante
        ///row.maxWidthSpaces! - row.maxPosition
        if (row.maxPosition.toInt() != row.maxWidthSpaces) {
          Space space = Space(
              position: row.maxPosition,
              item: null,
              row: row,
              widthSpaces: row.maxWidthSpaces! - row.maxPosition);
          row.spaces.add(space);
        }
      }

      rowIndex++;
    }

    */ /*//*//l'inserimento deve partire dal basso
    for (int rowIndex = lvmc.rows!.length-1; rowIndex>=0; rowIndex--){
      VmcRow row = lvmc.rows![rowIndex];

      ///fino a che non ho riempito tutti gli spazi (e che ci siano chiavi da scorrere)
      int index=0;
      while(index<sortedKeys.length && row.maxPosition.toInt()!=row.maxWidthSpaces){
        ///se ci sono ancora dimensioni da cui pescare articoli
        //if (index<sortedKeys.length) {
          double widthSpaces = sortedKeys[index];
          List<Item> toRemove =<Item>[];
          ///se ci sono ancora articoli in questa dimensione
          if (map[widthSpaces]!.isNotEmpty){

            ///scorro tutti gli item della dimensione e provo ad inserire l'item nello spazio
            for (int itemIndex=0; itemIndex< map[widthSpaces]!.length; itemIndex++ ){

              Item item = map[widthSpaces]![itemIndex];

              if (
              ///se lo spazio disponibile è >= allo spazio richiesto
              row.maxWidthSpaces! - row.maxPosition >=
                  (item.itemConfiguration?.widthSpaces ?? 0)) {
                ///inserisco l'item nella riga
                Space space = Space(position: row.maxPosition, item: item, row: row);
                row.spaces.add(space);
                ///rimuovo l'item dalla lista della dimensione corrente
                toRemove.add(item);
              } else {
                ///non c'è spazio, provo a la dimensione successiva
                break;
              }
            }
           if (toRemove.isNotEmpty){
             for (var element in toRemove) {map[widthSpaces]!.remove(element);}
           }
        }
          ///passo alla dimensione successiva
          index++;
      }

      ///non sono riuscito a riempiro tutta la riga, creo uno spazio dimensione mancante
      ///row.maxWidthSpaces! - row.maxPosition
      if(row.maxPosition.toInt()!=row.maxWidthSpaces) {
        Space space = Space(position: row.maxPosition,
            item: null,
            row: row,
            widthSpaces: row.maxWidthSpaces! - row.maxPosition);
        row.spaces.add(space);
      }
    }*//*

    return map;
    //_vmc.fillRemainingSpace();
  }

  List<Item> generate3(Vmc lVmc) {
    //lvmc ??= Vmc.standardEmpty();
    vmc = lVmc;
    vmc.rows?.clear();

    List<Item> trueItems = <Item>[];


    items?.forEach((element) {
      for (double value = element.usageConfiguration?.value ?? 0;
      value > 0;
      value -= element.itemConfiguration?.depthSpaces ?? 0) {
        trueItems.add(element);
      }
    });

    ///ordino tutti gli articoli
    trueItems.sort((x,y){
      int cmp = y.usageConfiguration!.priority.compareTo(x.usageConfiguration!.priority);
      if (cmp!=0){return cmp;}
      cmp = y.itemConfiguration!.heightSpaces!.compareTo(x.itemConfiguration!.heightSpaces!);
      if (cmp!=0){return cmp;}
      cmp = y.itemConfiguration!.widthSpaces!.compareTo(x.itemConfiguration!.widthSpaces!);
      return cmp;
    });
    int rowIndex = 0;
    while (rowIndex < (vmc.maxRows ?? 0)) {
      ///verifico se c'è lo spazio per creare un cassetto
      double? maxHeight = vmc.rows?.fold(0, (previousValue, element) {
        return (previousValue is VmcRow
            ? (previousValue as VmcRow).maxHeight
            : (previousValue as double)) +
            (element.maxHeight + 0.25);
      });

      ///altezza / altezza cassetto = numero spazi per cassetto (in teoria il numero di cassetti massimo)
      ///(1260/125)
      ///se l'altezza raggiunta fin'ora ${maxHeight} + altezza minima cassetto < altezza massima possibile, inserisco il cassetto
      ///10(approsimazione
      List<Item> toRemove = <Item>[];

      if ((maxHeight ?? 0) + 1 < 10 && trueItems.isNotEmpty) {
        VmcRow row = VmcRow(maxWidthSpaces: vmc.maxWidthSpaces!, id: rowIndex);
        lvmc.rows!.insert(0, row);

        ///fino a che non ho riempito tutti gli spazi (e che ci siano chiavi da scorrere)
        int index = 0;
        while (index < trueItems.length &&
            row.maxPosition.toInt() != row.maxWidthSpaces) {
          if (

          ///se lo spazio disponibile è >= allo spazio richiesto
          row.maxWidthSpaces! - row.maxPosition >=
              (trueItems[index].itemConfiguration?.widthSpaces ?? 0)) {
            ///inserisco l'item nella riga
            Space space =
            Space(position: row.maxPosition, item: trueItems[index], row: row);
            row.spaces.add(space);

            ///rimuovo l'item dalla lista della dimensione corrente
            toRemove.add(trueItems[index]);
          } else {
            ///non c'è spazio, provo a la dimensione successiva
            //break;
          }

          ///passo all'articolo successivo
          index++;
        }

        if (toRemove.isNotEmpty) {
          for (var element in toRemove) {
            trueItems.remove(element);
          }
        }

        ///non sono riuscito a riempiro tutta la riga, creo uno spazio dimensione mancante
        ///row.maxWidthSpaces! - row.maxPosition
        if (row.maxPosition.toInt() != row.maxWidthSpaces) {
          Space space = Space(
              position: row.maxPosition,
              item: null,
              row: row,
              widthSpaces: row.maxWidthSpaces! - row.maxPosition);
          row.spaces.add(space);
        }
        }




      rowIndex++;
    }


    return trueItems;
    //_vmc.fillRemainingSpace();
  }*/*/
  void updateVmcItem(int index, VmcItem item) {
    items?[index] = item;
    lvmc.rows?.forEach((row) {
      for (var space in row.spaces) {
        if (space.item?.item.code == item.item.code) {
          space.item = item;
        }
      }
    });
  }

  List<VmcItem> generate4(Vmc lVmc) {
    //lvmc ??= Vmc.standardEmpty();
    vmc = lVmc;
    vmc.rows?.clear();

    List<VmcItem> trueItems = <VmcItem>[];

    items?.forEach((element) {
      for (double value = element.usageConfiguration?.value ?? 0;
          value > 0;
          value -= element.itemConfiguration?.depthSpaces ?? 0) {
        trueItems.add(element);
      }
    });

    ///ordino tutti gli articoli
    trueItems.sort((x, y) {
      int cmp = y.usageConfiguration!.priority
          .compareTo(x.usageConfiguration!.priority);
      if (cmp != 0) {
        return cmp;
      }
      cmp = y.itemConfiguration!.heightSpaces
          .compareTo(x.itemConfiguration!.heightSpaces);
      if (cmp != 0) {
        return cmp;
      }
      cmp = y.itemConfiguration!.widthSpaces
          .compareTo(x.itemConfiguration!.widthSpaces);
      return cmp;
    });
    int rowIndex = 0;
    while (rowIndex < (vmc.vmcConfiguration?.maxRows ?? 0)) {
      ///verifico se c'è lo spazio per creare un cassetto
      double? maxHeight = vmc.rows?.fold(0, (previousValue, element) {
        return (previousValue ?? 0) + (element.maxHeight);
      });

      ///altezza / altezza cassetto = numero spazi per cassetto (in teoria il numero di cassetti massimo)
      ///(1260/125)
      ///se l'altezza raggiunta fin'ora ${maxHeight} + altezza minima cassetto < altezza massima possibile, inserisco il cassetto
      ///10(approsimazione
      List<VmcItem> toRemove = <VmcItem>[];

      if ((maxHeight ?? 0) + 1 < 10 && trueItems.isNotEmpty) {
        debugPrint("maxHeight: ${maxHeight ?? 0}");
        VmcRow row = VmcRow(
            maxWidthSpaces: vmc.vmcConfiguration?.maxWidthSpaces ?? 1,
            id: rowIndex,
            rowIndex: rowIndex);
        row.initSpacesAndTicks();
        lvmc.rows!.insert(0, row);

        ///fino a che non ho riempito tutti gli spazi (e che ci siano chiavi da scorrere)
        int index = 0;
        while (index < trueItems.length &&
            row.maxItemPosition.toInt() != row.maxWidthSpaces) {
          if (

          ///se lo spazio disponibile è >= allo spazio richiesto
          row.maxWidthSpaces - row.maxItemPosition >=
                  (trueItems[index].itemConfiguration?.widthSpaces ?? 0)) {
            ///inserisco l'item nella riga

            int? emptyIndex = row.getNextEmptyIndex();
            if (emptyIndex != null) {
              Space emptySpace = row.spaces[emptyIndex];
              row.spaces[emptyIndex] = emptySpace.copyWith(
                  position: row.maxItemPosition,
                  item: trueItems[index],
                  rowIndex: rowIndex,
                  //row: row,
                  widthSpaces: null,
                  visible: true);
            }

            /* int? emptyIndex = row.getSpaceIndexAtPosition(row.maxItemPosition);

            if (emptyIndex!=null){

            } else {
              emptyIndex=0;
            }
            Space? emptySpace = row.spaces[emptyIndex];

            row.spaces[emptyIndex] = emptySpace.copyWith(
                position: row.maxItemPosition,
                item: trueItems[index], row: row, widthSpaces: null, visible: true);*/

            ///rimuovo l'item dalla lista della dimensione corrente
            toRemove.add(trueItems[index]);
          } else {
            ///non c'è spazio, provo a la dimensione successiva
            //break;
          }

          ///passo all'articolo successivo
          index++;
        }

        if (toRemove.isNotEmpty) {
          for (var element in toRemove) {
            trueItems.remove(element);
          }
        }

        /*///non sono riuscito a riempiro tutta la riga, creo uno spazio dimensione mancante
        ///row.maxWidthSpaces! - row.maxPosition
        if (row.maxPosition.toInt() != row.maxWidthSpaces) {
          Space space = Space(
              position: row.maxPosition,
              item: null,
              row: row,
              widthSpaces: row.maxWidthSpaces! - row.maxPosition);
          row.spaces.add(space);
        }*/
        row.updateTicks();
      }

      rowIndex++;
    }

    return trueItems;
    //_vmc.fillRemainingSpace();
  }
}
