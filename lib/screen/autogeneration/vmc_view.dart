import 'dart:math';

import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_row.dart';
import 'package:dpicenter/screen/autogeneration/row.dart';
import 'package:dpicenter/screen/autogeneration/row_container.dart';
import 'package:dpicenter/screen/autogeneration/row_header.dart';
import 'package:dpicenter/screen/autogeneration/space_item.dart';
import 'package:dpicenter/screen/autogeneration/tick.dart';
import 'package:flutter/material.dart';

class VmcView extends StatefulWidget {
  final Vmc vmc;
  final BoxConstraints constraints;
  final double scaleFactor = 1.0;

  final VmcItem? highlightItem;
  final Space? highlightSpace;
  final bool canCloseItem;
  final Function(VmcItem? item)? onClose;

  final bool? showGridLines;
  final Function(Space space, int rowIndex, int spaceIndex)? onItemTap;

  const VmcView(
      {required this.vmc,
      required this.constraints,
      this.highlightItem,
      this.canCloseItem = false,
      this.onClose,
      this.showGridLines,
      this.onItemTap,
      this.highlightSpace,
      Key? key})
      : super(key: key);

  @override
  VmcViewState createState() => VmcViewState();
}

class VmcViewState extends State<VmcView> {
  ValueNotifier<double> scaleFactor = ValueNotifier(1.0);

  ValueNotifier<bool> showRealDimension = ValueNotifier<bool>(true);

  final ValueNotifier<bool> _showGridLines = ValueNotifier<bool>(false);

  bool get showGridLines => _showGridLines.value;

  Vmc? vmc;
  Stopwatch sw = Stopwatch();

  double _widthSingle = 0;

  List<Vmc> history = <Vmc>[];
  List<Vmc> redoList = <Vmc>[];

  final List<GlobalKey<RowItemState>> rowsKeys = <GlobalKey<RowItemState>>[];

  ///posizione attuale dell'item trascinato
  Offset currentDragOffset = const Offset(0, 0);

  ///posizione del puntatore all'inizio del trascinamento
  final ValueNotifier<Offset> _dragPointerOffset =
      ValueNotifier<Offset>(Offset.zero);

  ///chiave per il calcolo corretto della posizione relativa
  final GlobalKey _baseKey = GlobalKey(debugLabel: 'baseKey');

/*  final GlobalKey<SpaceItemState> _draggableSpaceItemKey =
      GlobalKey<SpaceItemState>(debugLabel: 'draggableSpaceItemKey');*/

  List<Space?>? candidateDragList;

  Vmc? vmcCopy;

  ///elemento candidato all'inserimento nella posizione attuale
  Space? candidate;

  ///riga candidata allo spostamento nella posizione attuale
  VmcRow? candidateRow;

  ///elemento accettato all'inserimento nella posizione attuale
  Space? newSpaceCandidate;

  ///box per calcolare la posizione relativa rispetto alla posizione globale del puntatore
  RenderBox? box;

  ///stato del trascinamento dello space
  bool isOnDrag = false;

  ///posizione attuale della riga trascinata
  //Offset _currentRowDragOffset = const Offset(0, 0);

  ///posizione iniziale del puntatore all'inizio del trascinamento
  //Offset _currentRowPointerOffset = const Offset(0, 0);

  ///stato del trascinamento della riga
  //bool isRowDrag = false;

  @override
  void initState() {
    print("initState->");
    sw.start();
    vmc = widget.vmc;

    vmcCopy = createCopy(vmc!);
    addToHistory(vmcCopy!);

    scaleFactor.value = widget.scaleFactor;
    _showGridLines.value = widget.showGridLines ?? false;

    super.initState();
  }

  addToHistory(Vmc vmcToAdd) {
    history.add(createCopy(vmcToAdd));
    redoList.clear();
  }

  scaleUp() {
    setState(() {
      scaleFactor.value += 0.1;
    });
  }

  resetScale() {
    setState(() {
      scaleFactor.value = 1.0;
    });
  }

  scaleDown() {
    if (scaleFactor.value - 0.1 >= 0.1) {
      setState(() {
        scaleFactor.value -= 0.1;
      });
    }
  }

  /*@override
  Widget build(BuildContext context) {
    double larghezzaBase = (widget.constraints.heightConstraints().maxHeight / vmc.rows!.length) * (670/1260);
    double larghezza = larghezzaBase;

    print(
        'height: ${(widget.constraints.heightConstraints().maxHeight * scaleFactor.value / (vmc.rows?.length ?? 1.0))}');

    List<Widget> stackChildren = <Widget>[];

      for (int rowIndex=0; rowIndex<vmc.rows!.length; rowIndex++){
        double maxLarghezza=0;
        for (int spaceIndex=0; spaceIndex < vmc.rows![rowIndex].spaces.length; spaceIndex++){

          Space space = vmc.rows![rowIndex].spaces[spaceIndex];
          larghezza = larghezzaBase * (space.item!=null ? space.item!.itemConfiguration!.widthSpaces! : space.widthSpaces!);

          stackChildren.add(SpaceItem(
            left: maxLarghezza,
            width: larghezza,
            top: _getRowHeight(rowIndex) * (rowIndex),
            height: _getRowHeight(rowIndex),
            rowIndex: rowIndex,
            spaceIndex: spaceIndex,
            scaleFactor: scaleFactor,
            showRealDimension: showRealDimension,
            constraints: widget.constraints,
            vmc: vmc,
            highlight: vmc.rows![rowIndex]
                .spaces[spaceIndex].item !=
                null &&
                widget.highlightItem != null &&
                widget.highlightItem ==
                    vmc.rows![rowIndex]
                        .spaces[spaceIndex].item,
          )
          );
          maxLarghezza +=larghezza;
        }
      }
    return
      AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          constraints: widget.constraints,
      child: Stack(children: stackChildren)

    );


     */ /* Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: Column(
            children: List.generate(
                vmc.rows?.length ?? 0,
                    (index) => AnimatedContainer(
                    height: _getRowHeight(index),
                    duration: const Duration(milliseconds: 350),
                    decoration: BoxDecoration(
                      color: isDarkTheme(context)
                          ? Colors.black.withAlpha(100)
                          : Colors.white.withAlpha(100),
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {

                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Text(vmc.rows![index].id.toString()),
                          ...List.generate(
                              vmc.rows?[index].spaces.length ?? 0,
                                  (spaceIndex) => SpaceItem(
                                rowIndex: index,
                                spaceIndex: spaceIndex,
                                scaleFactor: scaleFactor,
                                showRealDimension: showRealDimension,
                                constraints: widget.constraints,
                                vmc: vmc,
                                highlight: vmc.rows![index]
                                    .spaces[spaceIndex].item !=
                                    null &&
                                    widget.highlightItem != null &&
                                    widget.highlightItem ==
                                        vmc.rows![index]
                                            .spaces[spaceIndex].item,
                              )),
                        ],
                      );
                    }))),
          ),
        ),
      ),
    );*/ /*
  }*/


  /*@override
  Widget build(BuildContext context) {
    double larghezzaBase = (widget.constraints
        .heightConstraints()
        .maxHeight /
        vmc.rows!.length) *
        (670 / 1260);
    print(
        'height: ${(widget.constraints
            .heightConstraints()
            .maxHeight * scaleFactor.value /
            (vmc.rows?.length ?? 1.0))}');
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: Column(
            key: _baseKey,
            children: List.generate(
                vmc.rows?.length ?? 0,
                    (index) =>
                    AnimatedContainer(
                        height: _getRowHeight(index),
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                          color: isDarkTheme(context)
                              ? Colors.black.withAlpha(100)
                              : Colors.white.withAlpha(100),
                        ),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.transparent)),
                                  child: Stack(
                                    children: [

                                      ///griglia selezioni
                                      if(_showGridLines.value)
                                        ...List.generate(
                                            vmc.maxWidthSpaces!.toInt(),
                                                (spaceIndex) =>
                                                AnimatedPositioned(
                                                  duration: const Duration(milliseconds: 500),
                                                  left: (_getWidthSingle() *
                                                      spaceIndex) +
                                                      40,
                                                  width: _getWidthSingle(),
                                                  height: _getRowHeight(index),
                                                  child: DottedBorder(
                                                      color: Theme
                                                          .of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withAlpha(100),
                                                      strokeWidth: 1,
                                                      child: SizedBox(
                                                        width: _getWidthSingle(),
                                                        height: _getRowHeight(
                                                            index),
                                                      )),
                                                )),

                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .end,
                                        children: [
                                          //Text(vmc.rows![index].id.toString()),

                                          ///row header
                                          AnimatedContainer(
                                              duration:
                                              const Duration(milliseconds: 500),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  color: Theme
                                                      .of(context)
                                                      .backgroundColor
                                                      .withAlpha(100),
                                                  borderRadius: const BorderRadius
                                                      .only(
                                                      topLeft: Radius.circular(
                                                          20),
                                                      bottomLeft: Radius
                                                          .circular(20)),
                                                  border: Border.all(
                                                      color: Theme
                                                          .of(context)
                                                          .colorScheme
                                                          .primary)),
                                              width: 40,
                                              height: _getRowHeight(index),
                                              child: Center(
                                                  child: Text(
                                                    '${vmc.rows!.length -
                                                        index}',
                                                    textAlign: TextAlign.center,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .copyWith(
                                                        fontSize: _getRowHeight(
                                                            -1) /
                                                            (vmc.rows
                                                                ?.length ??
                                                                1)),
                                                  ))),

                                          ///lista selezioni riga (index)
                                          ...generateRowSelections(
                                              index),
                                        ],
                                      ),
                                    ],
                                  ),

                          );
                        }))),
          ),
        ),
      ),
    );
  }*/
  //Vmc? vmcLocale;

  @override
  Widget build(BuildContext context) {
    Vmc vmcToUse;
    if (candidate != null) {
      vmcToUse = vmcCopy!;
    } else {
      vmcToUse = vmc!;
    }
    _widthSingle = getWidthSingle(vmcToUse);

    print("build ${sw.elapsedMilliseconds.toString()}");
    double larghezzaBase = /*_widthSingle * vmcToUse.maxWidthSpaces!;*/
        (widget.constraints.heightConstraints().maxHeight / vmc!.rows!.length) *
            (670 / 1260);

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            width:
                larghezzaBase * (vmc!.vmcConfiguration?.maxWidthSpaces ?? 1) +
                    _getRowHeaderWidth(widget.vmc, 0),
            height: widget.constraints.heightConstraints().maxHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: larghezzaBase *
                        (vmc!.vmcConfiguration?.maxWidthSpaces ?? 1) +
                    _getRowHeaderWidth(widget.vmc, 0),
                height: widget.constraints.heightConstraints().maxHeight <
                        vmcToUse.rows!.fold(
                                0.0,
                                (previousValue, element) =>
                                    (previousValue as double) +
                                    element.maxHeight) *
                            (widget.constraints.heightConstraints().maxHeight *
                                (125 / 1260))
                    ? vmcToUse.rows!.fold(
                            0.0,
                            (previousValue, element) =>
                                (previousValue as double) + element.maxHeight) *
                        (widget.constraints.heightConstraints().maxHeight *
                            (125 / 1260))
                    : widget.constraints.heightConstraints().maxHeight,
                child: Builder(
                  builder: (context) {
                    return Listener(
                        onPointerMove: (details) {
                          //_updateVmcCopy();
                        },
                        child:

                            /*DragTarget<Space>(onWillAccept: (item) {
                debugPrint("onWillAccept");
                candidate = item;
                _updateVmcCopy();
                return true;
          }, onLeave: (item) {
                if (mounted) {
                  setState(() {});
                  */ /*addSpace(vmcLocale!, candidate!);
                      candidate!.row!.updateTicks();
                      candidate=null;
                      setState(() {
                        isOnDrag=false;
                      });*/ /*

                }
          },
*/
                            //onMove: (details)=> setState(()=> currentDragOffset = details.offset),

                            /*builder: (context, candidateList, rejected) {*/

                            Stack(key: _baseKey, children: [
                          ...List.generate(vmcToUse.rows?.length ?? 0,
                              (index) => _getRowContainer(vmcToUse, index)),
                          ...List.generate(
                            vmcToUse.rows?.length ?? 0,
                            (index) => _getRowHeader(vmcToUse, index),
                          ),
                          if (showGridLines)
                            for (int index = (vmcToUse.rows?.length ?? 0) - 1;
                                index >= 0;
                                index--)
                              ..._getRowGridLines(index, vmcToUse),
                          ...getRows(vmcToUse),
                          /* Stack(children: [

                              ..._getRowSpaces(index, vmcToUse),
                            ],)*/

                          /*AnimatedPositioned(
                      child: Text(
                          box?.globalToLocal(currentDragOffset).toString() ?? '?'),
                      duration: const Duration(milliseconds: 500)),*/
                        ]));
                  },
                ),
              ),
            )),
      ),
    );
  }

  List<Widget> getRows(Vmc vmcToUse) {
    List<Widget> result = <Widget>[];
    for (int index = (vmcToUse.rows?.length ?? 0) - 1; index >= 0; index--) {
      result.add(RowItem(
        constraints: widget.constraints,
        rowIndex: index,
        vmcToUse: vmcToUse,
        parentKey: _baseKey,
        scaleFactor: scaleFactor,
        candidate: candidate,
        newSpaceCandidate: newSpaceCandidate,
        curve: isOnDrag ? Curves.linear : Curves.easeInQuart,
        duration: isOnDrag ? null : const Duration(milliseconds: 500),
        onDragEnd: (space, details) {
          setState(() {
            print("dragEnd");
            if (newSpaceCandidate != null && dragItemAdded) {
              debugPrint("newSpaceCandidate copy");
              removeSpace(vmcCopy!, getRowIndex(vmcCopy!, candidate!.rowIndex),
                  candidate!.id);
              vmc = createCopy(vmcCopy!);
              addToHistory(vmcCopy!);
            } else {}

            candidate = null;
            newSpaceCandidate = null;
            isOnDrag = false;
          });
        },
        onDraggableCanceled: (space, velocity, offset) {
          candidate = null;
          debugPrint("onDraggableCanceled");
        },
        onDragUpdate: (space, details) {
          _updateVmcCopy();
          isOnDrag = true;
          currentDragOffset = details.globalPosition;
        },
        onDragStarted: (space, offset) {
          debugPrint("onDragStarted: ${space.rowIndex} ${space.position}");
          candidate = space;
          currentDragOffset = offset;

          _updateVmcCopy();
        },
        onDragDown: (space, offset) {
          debugPrint("onDragDown: ${offset.toString()}");
          _dragPointerOffset.value = offset;
        },
        onItemTap: widget.onItemTap,
        canCloseItems: widget.canCloseItem,
        onClose: (Space space, int rowIndex, int spaceIndex) {
          setState(() {
            if (vmcToUse.rows![rowIndex].spaces[spaceIndex].item != null) {
              vmcToUse.rows![rowIndex].spaces[spaceIndex] = vmcToUse
                  .rows![rowIndex].spaces[spaceIndex]
                  .copyWith(item: null, widthSpaces: 0.25, visible: false);
              vmcToUse.rows![rowIndex].updateTicks();
              addToHistory(createCopy(vmcToUse));

              widget.onClose?.call(space.item);
            }
          });
        },
        showRealDimension: showRealDimension,
        highlightSpace: widget.highlightSpace,
        highlightItem: widget.highlightItem,
        candidateAdded: dragItemAdded,
      ));
    }
    return result;
  }

  bool dragItemAdded = false;

  void _updateVmcCopy() {
    dragItemAdded = false;
    //var sw = Stopwatch();
    //sw.start();
    //debugPrint("_updateVmcLocale inizio: ${sw.elapsedMilliseconds.toString()}");
    //debugPrint("updateVmcCopy copy");
    vmcCopy = createCopy(vmc!);

    if (_baseKey.currentContext != null) {
      box = _baseKey.currentContext?.findRenderObject() as RenderBox;
    }

    if (candidate != null && candidate!.isNotEmpty) {
      /*removeSpace(
          vmcCopy!, getRowIndex(vmcCopy!, candidate!.rowIndex  */ /*candidate!.row!*/ /*), candidate!.id);*/
      Offset offset =
          box?.globalToLocal(currentDragOffset) ?? const Offset(0, 0);
      Offset pointerOffset = _dragPointerOffset.value;

      debugPrint("DragPointerOffset ${pointerOffset.toString()}");
      offset = Offset(offset.dx - pointerOffset.dx, offset.dy);

      ///in che riga mi trovo?
      for (int rowIndex = 0; rowIndex < vmcCopy!.rows!.length; rowIndex++) {
        //print ('OffsetDy: ${offset.dy} OffsetDx: ${offset.dx} _getRowPosition($rowIndex): ${_getRowPosition(vmcCopy!, rowIndex)} _getRowPosition(${rowIndex+1}): ${_getRowPosition(vmcCopy!, rowIndex+1)}');
        if (offset.dy >= _getRowPosition(vmcCopy!, rowIndex) &&
            offset.dy < _getRowPosition(vmcCopy!, rowIndex + 1)) {
          debugPrint("sono nella riga: ${rowIndex.toString()}");
          double candidatePosition = 0;

          ///sono dentro a questo riga
          ///in che posizione mi trovo?

          bool executeAddItem = false;

          ///se la x è negativa (ma maggiore della larghezza massima negativa di candidate) considero la posizione 0
          if (offset.dx < _getRowHeaderWidth(vmcCopy!, 0) &&
              offset.dx >
                  (candidate!.currentWidthSpaces * (_widthSingle * -0.25)) -
                      _getRowHeaderWidth(vmcCopy!, 0)) {
            executeAddItem = true;
            candidatePosition = 0;
          } else {
            for (int tickIndex = 0;
                tickIndex < vmcCopy!.rows![rowIndex].ticks.length;
                tickIndex++) {
              double positionCoordinate =
                  ((vmcCopy!.rows![rowIndex].ticks[tickIndex].position ?? 0) *
                          _widthSingle) +
                      _getRowHeaderWidth(vmcCopy!, rowIndex);

              /*print(
                "OffsetDx: ${offset.dx} Position coordinate $spaceIndex: $positionCoordinate OffsetDx: $positionCoordinate OffsetDx: ${positionCoordinate + (_getWidthSingle() * vmcLocale!.rows![rowIndex].spaces[spaceIndex].currentWidthSpaces)}");*/

              if (offset.dx >= positionCoordinate &&
                  offset.dx < positionCoordinate + (_widthSingle * 0.25)) {
                ///sono dentro a questa posizione
                //double position = ((positionCoordinate - _getRowHeaderWidth(rowIndex)) / ((_getWidthSingle()/vmcLocale!.rows!.length))).round().toDouble();
                debugPrint(
                    "Position: ${vmcCopy!.rows![rowIndex].ticks[tickIndex].position ?? 0} spaceIndex: $tickIndex");
                /* Space? spacePos = vmcLocale!.rows![rowIndex]
                  .getSpaceAtPosition(vmcLocale!.rows![rowIndex].ticks[spaceIndex].position ?? 0);
              if (spacePos != null) {*/

                /*  Space? collisionWith = vmcCopy!.rows![rowIndex].getSpaceCollision(
                  vmcCopy!.rows![rowIndex].spaces.where((element) => element!=candidate).toList(),
                  (vmcCopy!.rows![rowIndex].ticks[tickIndex].position ?? 0),
                  (vmcCopy!.rows![rowIndex].ticks[tickIndex].position ?? 0) +
                      candidate!.currentWidthSpaces);
              if (collisionWith != null && collisionWith!=candidate) {
                candidatePosition = collisionWith.position ?? 0;
              } else {*/
                candidatePosition =
                    vmcCopy!.rows![rowIndex].ticks[tickIndex].position ?? 0;

                ///quando la posizione + la larghezza eccede il massimo considero come posizione l'ultima posizione valida disponibile
                if (candidatePosition +
                        candidate!.item!.itemConfiguration!.widthSpaces >
                    (vmcCopy!.vmcConfiguration?.maxWidthSpaces ?? 1)) {
                  candidatePosition =
                      (vmcCopy!.vmcConfiguration?.maxWidthSpaces ?? 1) -
                          candidate!.item!.itemConfiguration!.widthSpaces;
                }

                /* }*/
                //if (vmcLocale!.rows![rowIndex].canAddItem(candidatePosition, candidate!.item!)){

                executeAddItem = true;
                /*  } else {
                if (collisionWith!=null) {
                  debugPrint("trySwitch: candidate row id: ${candidate!.row!.id!}  collisionWith rowIndex: $rowIndex rowIndex extracted: ${collisionWith.row!.id.toString()}");

                  int rowIndexStart=_getRowIndex(candidate!.row!);
                  int rowIndexEnd=_getRowIndex(collisionWith.row!);
                  int spaceIndexStart=candidate!.id;
                  int spaceIndexEnd=collisionWith.id;

                  print ("rowIndexStart=$rowIndexStart rowIndexEnd $rowIndexEnd spaceIndexStart=$spaceIndexStart spaceIndexEnd=$spaceIndexEnd");

                  newSpaceCandidate =
                      vmcLocale!.trySwitch(rowIndexStart, rowIndexEnd, spaceIndexStart, spaceIndexEnd);
                  if (newSpaceCandidate!=null){
                    setState(() {
                      added = true;
                    });
                  }

                  */
                /*if (candidate!.item!.itemConfiguration!.widthSpaces! == collisionWith.currentWidthSpaces) {
                    vmcLocale!.rows![vmcLocale!.maxRows! - candidate!.row!.id!-1].spaces[candidate!.id] =
                        collisionWith.copyWith(row: candidate!.row);
                    vmcLocale!.rows![vmcLocale!.maxRows! - collisionWith.row!.id!-1].spaces[collisionWith.id] =
                        candidate!.copyWith(row: collisionWith.row);
                    setState(() {
                      added = true;
                    });
                  }*/ /*

                }
              }*/

                ///blocco il ciclo degli spaces
                break;
                /*}*/
              }
            }
          }

          if (executeAddItem) {
            newSpaceCandidate = vmcCopy!.rows![rowIndex].addItem(
                candidatePosition, candidate!.item!,
                excludeSpace: candidate);

            if (newSpaceCandidate != null) {
              setState(() {
                debugPrint("dragItemAdded");
                dragItemAdded = true;
              });
            } else {
              if (dragItemAdded) {
                setState(() {
                  debugPrint(
                      "d@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ragItemAdded=false");
                  dragItemAdded = false;
                });
              }
            }

            ///blocco il ciclo delle righe
            break;
          }
        } else {}
      }
    }

    //debugPrint("_updateVmcLocale fine: ${sw.elapsedMilliseconds.toString()}");
  }

/*  int getRowIndex(Vmc vmc, VmcRow row) {
    for (int index = 0; index < (vmc.rows?.length ?? 0); index++) {
      if (vmc.rows![index].id == row.id) {
        return index;
      }
    }
    return -1;
  }*/
  int getRowIndex(Vmc vmc, int idIndex) {
    for (int index = 0; index < (vmc.rows?.length ?? 0); index++) {
      if (vmc.rows![index].id == idIndex) {
        return index;
      }
    }
    return -1;
  }

  void addSpace(Vmc vmc, Space candidate) {
    VmcRow? candidateRow = vmc.rows?[getRowIndex(vmc, candidate.rowIndex)];
    if (candidateRow != null) {
      for (int spaceIndex = 0;
          spaceIndex < candidateRow.spaces.length;
          spaceIndex++) {
        if (candidateRow.spaces[spaceIndex].id == candidate.id) {
          candidateRow.spaces[spaceIndex] = candidate.copyWith();
        }
      }
    }
  }

  void newVmcStandard() {
    setState(() {
      vmc = Vmc.standard(1, 1, 'test', 'test');
      vmcCopy = createCopy(vmc!);

      addToHistory(vmcCopy!);
    });
  }

  void add(VmcItem item) {
    vmc!.add(item);
    addToHistory(vmc!);
  }

  void reloadWith({required Vmc vmcToUse}) {
    setState(() {
      vmc = vmcToUse;
      vmcCopy = createCopy(vmc!);
      history.clear();
      addToHistory(vmcCopy!);
    });
  }

  void removeSpace(Vmc vmc, int rowIndex, int spaceIndex) {
    for (int index = 0; index < vmc.rows![rowIndex].spaces.length; index++) {
      if (spaceIndex == index) {
        vmc.rows![rowIndex].spaces[spaceIndex] =
            vmc.rows![rowIndex].spaces[spaceIndex].copyWith(
                item: null, widthSpaces: 0.25, visible: false, removed: true);
        vmc.rows![rowIndex].updateTicks();
        break;
      }
    }
  }


  double _getRowHeaderWidth(Vmc vmcToUse, int rowIndex) {
    return 40;
  }

  double _getRowPosition(Vmc vmcToUse, int rowIndex) {
    double position = 0;
    if (vmcToUse.rows != null) {
      //debugPrint("rowIndex: ${rowIndex.toString()} : ${getRowHeight(vmcToUse,  rowIndex)}");
      double rowHeight = 0;
      //debugPrint("calcolo rowHeight per rowIndex: ${rowIndex.toString()}");
      for (int index = 0; index < rowIndex; index++) {
        rowHeight += getRowHeight(vmcToUse, index);
        //debugPrint("index: ${index} - ${getRowHeight(vmcToUse,  index)}");

      }
      //debugPrint("rowHeight calcolato: ${rowHeight.toString()}");
      return rowHeight;
    }
    return position;
  }

  /* Widget _getRowContainer(Vmc vmcToUse, int rowIndex) {

    Offset offset =
        box?.globalToLocal(_currentRowDragOffset) ?? const Offset(0, 0);
    Offset pointerOffset =_currentRowPointerOffset;
    debugPrint("RowDragPointerOffset ${pointerOffset.toString()}");
    offset=Offset(offset.dx - pointerOffset.dx, offset.dy);
    return Builder(builder: (context) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        left: 0,
        top: isRowDrag ? offset.dy : _getRowPosition(vmcToUse, rowIndex),
        height: getRowHeight(vmcToUse, rowIndex),
        width: _widthSingle * vmcToUse.maxWidthSpaces! +
            _getRowHeaderWidth(vmcToUse, rowIndex),
        child: AnimatedContainer(
            height: getRowHeight(vmcToUse, rowIndex),
            width: _widthSingle * vmcToUse.maxWidthSpaces! +
                _getRowHeaderWidth(vmcToUse, rowIndex),
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: isDarkTheme(context)
                  ? Colors.black.withAlpha(100)
                  : Colors.white.withAlpha(100),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: getRowHeight(vmcToUse, rowIndex),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary)),
              );
            })),
      );
    });
  }*/
  Widget _getRowContainer(Vmc vmcToUse, int rowIndex) {
    /* if (_baseKey.currentContext != null) {
      box = _baseKey.currentContext?.findRenderObject() as RenderBox;
    }

    Offset offset =
        box?.globalToLocal(_currentRowDragOffset) ?? const Offset(0, 0);
    Offset pointerOffset = _currentRowPointerOffset;
    debugPrint("RowDragPointerOffset ${pointerOffset.toString()}");
    offset = Offset(offset.dx, offset.dy - pointerOffset.dy);*/
    return Builder(builder: (context) {
      return RowContainer(
        left: 0,
        top: /* candidateRow != null &&
                candidateRow == vmcToUse.rows![rowIndex] &&
                isRowDrag
            ? offset.dy
            :*/
            _getRowPosition(vmcToUse, rowIndex),
        height: getRowHeight(vmcToUse, rowIndex),
        width: _widthSingle * (vmcToUse.vmcConfiguration?.maxWidthSpaces ?? 1) +
            _getRowHeaderWidth(vmcToUse, rowIndex),
        vmc: vmcToUse,
        constraints: widget.constraints,
        rowIndex: rowIndex,
        curve: Curves.linear,
        scaleFactor: ValueNotifier<double>(1.0),
        duration: /*isRowDrag
            ? const Duration(milliseconds: 0)
            : */
            const Duration(milliseconds: 500),
        row: vmcToUse.rows![rowIndex],
        parentKey: _baseKey,
      );
    });

/*    return Builder(builder: (context) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        left: 0,
        top: isRowDrag ? offset.dy : _getRowPosition(vmcToUse, rowIndex),
        height: getRowHeight(vmcToUse, rowIndex),
        width: _widthSingle * vmcToUse.maxWidthSpaces! +
            _getRowHeaderWidth(vmcToUse, rowIndex),
        child: AnimatedContainer(
            height: getRowHeight(vmcToUse, rowIndex),
            width: _widthSingle * vmcToUse.maxWidthSpaces! +
                _getRowHeaderWidth(vmcToUse, rowIndex),
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: isDarkTheme(context)
                  ? Colors.black.withAlpha(100)
                  : Colors.white.withAlpha(100),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: getRowHeight(vmcToUse, rowIndex),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary)),
              );
            })),
      );
    });*/
  }

  Widget _getRowHeader(Vmc vmcToUse, int rowIndex) {
    return RowHeader(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
        row: vmcToUse.rows![rowIndex],
        vmc: vmcToUse,
        constraints: widget.constraints,
        scaleFactor: scaleFactor,
        rowIndex: rowIndex,
        parentKey: _baseKey,
        height: getRowHeight(vmcToUse, rowIndex),
        width: _getRowHeaderWidth(vmcToUse, rowIndex),
        left: 0,
        top: _getRowPosition(vmcToUse, rowIndex),
        label: Text('${vmc!.rows!.length - rowIndex}'),
        /*onDragStarted: (row, details) {
          isRowDrag = true;
          _currentRowDragOffset = details;
          candidateRow = row;
        },
        onDragUpdate: (details) {
          isRowDrag = true;
          _currentRowDragOffset = details.globalPosition;
          setState(() {
            isRowDrag = true;
            _currentRowDragOffset = details.globalPosition;
          });
        },
        onDragEnd: (details) {
          setState(() {
            print("rowDragEnd");
*/ /*
          if (newSpaceCandidate != null && dragItemAdded) {
            debugPrint("newSpaceCandidate copy");
            removeSpace(
                vmcCopy!,
                getRowIndex(vmcCopy!, candidate!.rowIndex),
                candidate!.id);
            vmc = createCopy(vmcCopy!);
            addToHistory(vmcCopy!);

          } else {

          }
*/ /*

            candidateRow = null;
            isRowDrag = false;
          });
        },
        onDraggableCanceled: (velocity, offset) {
          candidateRow = null;
          debugPrint("rowOnDraggableCanceled");
        },
        onDragDown: (details) {
          debugPrint("rowOnDragDown: ${details.toString()}");
          _currentRowPointerOffset = details;
        },*/
        onDown: widget.canCloseItem && rowIndex != vmcToUse.rows!.length - 1
            ? () {
                switchRowIndexWith(vmcToUse, rowIndex, rowIndex + 1);
              }
            : null,
        onUp: widget.canCloseItem && rowIndex != 0
            ? () {
                switchRowIndexWith(vmcToUse, rowIndex, rowIndex - 1);
              }
            : null);
  }

  void switchRowIndexWith(Vmc vmcToUse, int startRowIndex, int endRowIndex) {
    var copyVmc1 = createCopy(vmcToUse);

    for (int index = 0; index < vmcToUse.rows!.length; index++) {
      int indexToUse = index;
      if (index == startRowIndex) {
        indexToUse = endRowIndex;
      }
      if (index == endRowIndex) {
        indexToUse = startRowIndex;
      }

      vmcToUse.rows![indexToUse] = copyVmc1.rows![index].copyWith()
        ..spaces =
            copyVmc1.rows![index].spaces.map((e) => e.copyWith()).toList()
        ..ticks = copyVmc1.rows![index].ticks.map((e) => e.copyWith()).toList();
    }

    addToHistory(vmcToUse);
    setState(() {});
  }

  /*Widget _getRowHeader(Vmc vmcToUse, int rowIndex) {
    debugPrint("spazio occupato: ${vmcToUse.rows!.fold(0.0, (previousValue, element) => (previousValue as double) + element.maxHeight)}");
    debugPrint("RowPosition: ${_getRowPosition(vmcToUse, rowIndex)}");
    return


        ///row header
        Builder(builder: (context) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        height: getRowHeight(vmcToUse, rowIndex),
        width: _getRowHeaderWidth(vmcToUse, rowIndex),
        left: 0,
        top: _getRowPosition(vmcToUse, rowIndex),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: Color.alphaBlend(Theme.of(context).backgroundColor.withAlpha(200), Theme.of(context).colorScheme.secondary),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary)),
            width: _getRowHeaderWidth(vmcToUse, rowIndex),
            height: getRowHeight(vmcToUse, rowIndex),
            child:

            Material(
              type: MaterialType.transparency,
              child: GestureDetector(
                onPanDown: (details){
                  setState(() {
                    debugPrint("rowDrag down");
                    _currentRowPointerOffset=details.globalPosition;
                    candidateRow = vmcToUse.rows![rowIndex];
                  });
                  //isRowDrag=true;
                },
                onPanStart: (details){
                  setState(() {
                    debugPrint("rowDrag start");
                    candidateRow = vmcToUse.rows![rowIndex];
                    _currentRowDragOffset=details.globalPosition;
                    isRowDrag=true;
                  });
                },
                onPanUpdate: (details){

                        setState(() {
                          _currentRowDragOffset=details.globalPosition;
                        });
                },
                onPanCancel: (){
                  setState(() {
                    debugPrint("rowDrag cancel");
                    candidateRow = null;
                    isRowDrag=false;
                  });
                },
                onPanEnd: (details){
                  setState(() {
                    debugPrint("rowDrag end");
                    candidateRow = null;
                    isRowDrag=false;
                  });
                },
                child: InkWell(
                  onTap: (){

                  },
                  child: Center(
                      child: Text(
                    '${vmc!.rows!.length - rowIndex}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 14
                            */ /*getRowHeight(vmcToUse, -1) / (vmc!.rows?.length ?? 1)*/ /*),
                  )),
                ),
              ),
            )),
      );
    });
  }*/

  List<Widget> _getRowSpaces(int rowIndex, Vmc vmcToUse) {
    List<Space>? spaces = vmcToUse.rows?[rowIndex].spaces;
    //Offset offset = box?.globalToLocal(currentDragOffset) ?? const Offset(0, 0);
    //offset=Offset(offset.dx-_dragPointerOffset.value.dx,offset.dy-_dragPointerOffset.value.dy);

    /*print("drag condition: ${candidate?.id ?? -1} (candidate!=null AND candidate!.id == spaces![spaceIndex].id AND isOnDrag) ${ (candidate!=null)}"
        "isOnDrag value $isOnDrag)}");*/
    debugPrint(
        "RowPosition rowIndex(${rowIndex.toString()}): ${_getRowPosition(vmcToUse, rowIndex)}");
    return List.generate(
        spaces?.length ?? 0,
        (spaceIndex) => SpaceItem(
              //key: ValueKey(spaces![spaceIndex]),
              visible: (candidate != null &&
                      candidate!.id == spaces![spaceIndex].id &&
                      candidate!.rowIndex == spaces[spaceIndex].rowIndex &&
                      isOnDrag &&
                      dragItemAdded)
                  ? false
                  : true,
              parentKey: _baseKey,
              curve: isOnDrag ? Curves.linear : Curves.easeInQuart,
              left:
                  /*  (candidate != null &&
                  candidate!.id == spaces[spaceIndex].id &&
                  candidate!.rowIndex == spaces[spaceIndex].rowIndex &&
                  isOnDrag) ? offset.dx* : */
                  vmcToUse.rows![rowIndex].spaces[spaceIndex].visible
                      ? ((spaces![spaceIndex].position ?? 0) * _widthSingle) +
                          _getRowHeaderWidth(vmcToUse, rowIndex)
                      : -500,
              top:
                  /*(candidate != null &&
                  candidate!.id == spaces[spaceIndex].id &&
                  candidate!.rowIndex == spaces[spaceIndex].rowIndex &&
                  isOnDrag) ? offset.dy :*/
                  _getRowPosition(vmcToUse, rowIndex),
              width: _widthSingle * spaces![spaceIndex].currentWidthSpaces,
              height: getRowHeight(vmcToUse, rowIndex),
              duration: isOnDrag
                  ? const Duration(milliseconds: 0)
                  : Duration(milliseconds: 500 + Random().nextInt(1000)),
              onDragEnd: (details) {
                setState(() {
                  print("dragEnd");
                  if (newSpaceCandidate != null && dragItemAdded) {
                    debugPrint("newSpaceCandidate copy");
                    removeSpace(
                        vmcCopy!,
                        getRowIndex(vmcCopy!, candidate!.rowIndex),
                        candidate!.id);
                    vmc = createCopy(vmcCopy!);
                    addToHistory(vmcCopy!);

                    //addSpace(vmcLocale, candidate!);

                    //vmcLocale.rows![_getRowIndex(newSpaceCandidate!.row!)].addItem(newSpaceCandidate!.position ?? 0, newSpaceCandidate!.item!);
                /* vmc=vmcLocale;
                      vmcLocale=vmc!;*/

                //initVmcLocale();

                //initVmcLocale();
                //addSpace(vmcLocale, newSpaceCandidate!);
                //vmc=vmcLocale.copyWith();
              } else {
                //addSpace(vmcToUse, candidate!);
              }

              //candidate!.row!.updateTicks();
              candidate = null;
              newSpaceCandidate = null;
              isOnDrag = false;
            });
          },
          onDraggableCanceled: (velocity, offset) {
            candidate = null;
                debugPrint("onDraggableCanceled");
              },
              onDragUpdate: (details) {
                _updateVmcCopy();
                isOnDrag = true;
                currentDragOffset = details.globalPosition;

                // initVmcLocale();
              },
              onDragStarted: (space, offset) {
                debugPrint(
                    "onDragStarted: ${space?.rowIndex} ${space?.position}");
                candidate = space;
                currentDragOffset = offset;

                _updateVmcCopy();
              },
              onDragDown: (offset) {
                debugPrint("onDragDown: ${offset.toString()}");
                _dragPointerOffset.value = offset;
              },
              onTap: widget.onItemTap,
              canClose: widget.canCloseItem,
          onClose: (VmcItem? item, int rowIndex, int spaceIndex) {
                setState(() {
                  if (vmcToUse.rows![rowIndex].spaces[spaceIndex].item !=
                      null) {
                    vmcToUse.rows![rowIndex].spaces[spaceIndex] =
                        vmcToUse.rows![rowIndex].spaces[spaceIndex].copyWith(
                            item: null, widthSpaces: 0.25, visible: false);
                    vmcToUse.rows![rowIndex].updateTicks();
                    addToHistory(createCopy(vmcToUse));

                    /*double totalMerged=0.25;
                            for (int index=spaceIndex+1; index<vmc.rows![rowIndex].spaces.length; index++){
                              vmc.rows![rowIndex].spaces[index] = vmc.rows![rowIndex].spaces[index].copyWith(visible: true);
                              totalMerged+=vmc.rows![rowIndex].spaces[index].widthSpaces!;
                              if (totalMerged>=item!.itemConfiguration!.widthSpaces!){
                                break;
                              }
                            }*/

                    //vmc.rows![rowIndex].mergeFreeSpaces();
                widget.onClose?.call(item);
              }
                });
              },
              rowIndex: rowIndex,
              spaceIndex: spaceIndex,
              space: /*candidate.isNotEmpty ? candidate[0]! : */ vmcToUse
                  .rows![rowIndex].spaces[spaceIndex],
              scaleFactor: scaleFactor,
              showRealDimension: showRealDimension,
              constraints: widget.constraints,
              vmc: vmcToUse,
              selected: (widget.highlightSpace != null &&
                      widget.highlightSpace == spaces[spaceIndex])
                  ? true
                  : false,
              highlight: (spaces[spaceIndex].item != null &&
                      widget.highlightItem != null &&
                      widget.highlightItem == spaces[spaceIndex].item) ||
                  (newSpaceCandidate != null &&
                      newSpaceCandidate!.position ==
                          spaces[spaceIndex].position &&
                      newSpaceCandidate!.rowIndex ==
                          spaces[spaceIndex].rowIndex),
              highlightColor: newSpaceCandidate != null &&
                      newSpaceCandidate!.position ==
                          spaces[spaceIndex].position &&
              newSpaceCandidate!.rowIndex == spaces[spaceIndex].rowIndex
              ? Colors.green
              : null,
            ));
  }

  List<Widget> _getRowGridLines(int rowIndex, Vmc vmcToUse) {
    //debugPrint("_getRowGridLines");

    List<Space>? spaces = vmcToUse.rows?[rowIndex].ticks;
    if (vmcToUse.rows == null || spaces == null) {
      return [];
    }
    List<Widget> result = <Widget>[];
    for (Space space in spaces) {
      if (space.visible) {
        result.add(
          Builder(builder: (context) {
            return AnimatedPositioned(
                curve: Curves.easeInQuart,
                left: vmcToUse.rows![rowIndex].ticks[space.id].visible &&
                        showGridLines
                    ? ((spaces[space.id].position ?? 0) * _widthSingle) +
                        _getRowHeaderWidth(vmcToUse, rowIndex)
                    : 1500,
                top: showGridLines ? _getRowPosition(vmcToUse, rowIndex) : -500,
                width: _widthSingle * spaces[space.id].currentWidthSpaces,
                height: getRowHeight(vmcToUse, rowIndex),
                duration: isOnDrag
                    ? const Duration(milliseconds: 0)
                    : Duration(milliseconds: 500 + Random().nextInt(1000)),
                child: Tick(
                  key: ValueKey(space),
                  rowIndex: rowIndex,
                  spaceIndex: space.id,
                  space: vmcToUse.rows![rowIndex].ticks[space.id],
                  scaleFactor: scaleFactor,
                  constraints: widget.constraints,
                  vmc: vmcToUse,
                ));
          }),
        );
      }
    }
    return result;
  }

  /* double getRowHeight(Vmc vmcToUse, int index) {
    double rowSpace = (widget.constraints.heightConstraints().maxHeight *
        scaleFactor.value /
        (vmcToUse.rows?.length ?? 1.0));

    if (index == -1) {
      return rowSpace;
    }

    if (showRealDimension.value) {
      VmcRow? row = vmcToUse.rows?[index];
      //debugPrint("spazio libero tra i cassetti ${(((1260/125) - vmcToUse.maxRows!)/vmcToUse.maxRows!)}");

      double totalMaxHeight = vmcToUse.rows!.fold(0.0, (previousValue, element) => previousValue + element.maxHeight);

      double rowHeight = ((widget.constraints.heightConstraints().maxHeight *
          ((125 / 1260) * scaleFactor.value) *
          ((row?.maxHeight ?? 1) + (totalMaxHeight<(1260/125) ? (((1260/125) - totalMaxHeight)/vmcToUse.rows!.length) : 0))
          ));
          //(((1260/125) - vmcToUse.maxRows!)/vmcToUse.maxRows!) /// <<-- spazio libero minimo tra i cassetti

     // debugPrint("rowHeight: ${index} ${rowHeight.toString()}");
     //if (rowHeight > rowSpace) {
        rowSpace = rowHeight;
      //}
    }
    return rowSpace;
  }*/

  double getRowHeight(Vmc vmcToUse, int rowIndex) {
    return vmcToUse.getRowHeight(widget.constraints, rowIndex,
        showRealDimension: showRealDimension.value);
  }

/*  double getRowHeight(Vmc vmcToUse, int index) {
    double rowSpace = (widget.constraints.heightConstraints().maxHeight *
        scaleFactor.value /
        (vmcToUse.rows?.length ?? 1.0));

    if (index == -1) {
      return rowSpace;
    }

    if (showRealDimension.value) {
      VmcRow? row = vmcToUse.rows?[index];

      double rowHeight = ((widget.constraints.heightConstraints().maxHeight *
          ((125 / 1260) * scaleFactor.value) *
          (row?.maxHeight ?? 1)));

      if (rowHeight > rowSpace) {
        rowSpace = rowHeight;
      }
    }
    return rowSpace;
  }*/

  void showHideGridLines(bool state) {
    setState(() {
      _showGridLines.value = state;
    });
  }

  void showRealHeight() {
    setState(() {
      showRealDimension.value = true;
    });
  }

  void showFullHeight() {
    setState(() {
      showRealDimension.value = false;
    });
  }

  final double proportion = (670 / 1260);

  double getWidthSingle(Vmc vmcToUse) {
/*    double larghezzaBase =
        (widget.constraints.heightConstraints().maxHeight / vmc!.rows!.length) *
            (670 / 1260);
    return larghezzaBase;*/
    return ((widget.constraints.heightConstraints().maxHeight *
            widget.scaleFactor *
            (proportion)) /
        (vmcToUse.vmcConfiguration?.maxWidthSpaces ?? 1));
  }

  void undo() {
    if (history.length > 1) {
      setState(() {
        var vmcToRestore = history[history.length - 2];
        redoList.add(history.last);
        history.remove(history.last);

        vmc = vmcToRestore;
        vmcCopy = createCopy(vmc!);
      });
    }
  }

  void redo() {
    if (redoList.isNotEmpty) {
      setState(() {
        var vmcToRestore = redoList.last;
        history.add(redoList.last);
        redoList.remove(redoList.last);
        setState(() {
          vmc = vmcToRestore;
          vmcCopy = createCopy(vmc!);
        });
      });
    }
  }
}

Vmc createCopy(Vmc vmc) {
  return vmc.copyWith(
      rows: vmc.rows
          ?.map((e) => e.copyWith()
            ..spaces = e.spaces.map((e) => e.copyWith()).toList()
            ..ticks = e.ticks.map((e) => e.copyWith()).toList())
          .toList());
}