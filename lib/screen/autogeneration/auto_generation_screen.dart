
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/autogeneration/default_vmc_generator.dart';
import 'package:dpicenter/models/server/autogeneration/space.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/autogeneration/vmc_item.dart';
import 'package:dpicenter/screen/autogeneration/edit_item_old.dart';
import 'package:dpicenter/screen/autogeneration/edit_vmc.dart';
import 'package:dpicenter/screen/autogeneration/space_item.dart';
import 'package:dpicenter/screen/autogeneration/vmc_view.dart';
import 'package:flutter/material.dart';

import 'edit_item_old.dart';

//String authToken =
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIiLCJuYmYiOjE2MzM3MDQxMDEsImV4cCI6MTYzNDMwODkwMSwiaWF0IjoxNjMzNzA0MTAxfQ.zBdH7eo-nNFgiB0Sy4pCsBN6zjJRPydCW9ZygOhiuWY';

//bool _certificateCheck(X509Certificate cert, String host, int port) => true;

class AutoGenerationScreen extends StatefulWidget {
  const AutoGenerationScreen(
      {Key? key, required this.title, this.menu, this.customBackClick})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Menu? menu;
  final VoidCallback? customBackClick;

  @override
  AutoGenerationScreenState createState() => AutoGenerationScreenState();
}

class AutoGenerationScreenState extends State<AutoGenerationScreen> {
  ValueNotifier<bool> isLoaded = ValueNotifier<bool>(false);
  Vmc? vmc;
  DefaultVmcGenerator vmcGenerator = DefaultVmcGenerator();
  VmcItem? _currentItem;
  Space? _currentSpace;
  int _currentItemIndex = -1;
  bool _canCloseItem = false;

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'scaffoldKey');

  final GlobalKey<VmcViewState> _vmcStateKey =
      GlobalKey<VmcViewState>(debugLabel: 'vmcState');

  final int _generationId = 0;
  Map<double, List<VmcItem>>? _resultMap;
  List<VmcItem>? _resultList;
  final List<VmcItem> _cancelled = <VmcItem>[];

  @override
  void initState() {
    if (vmcGenerator.items == null) {
      vmcGenerator.generateTestItems();
    }
    vmcGenerator.vmc = Vmc.standard(1, 1, 'test', 'test');
    isLoaded.value = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<VmcItem> remaining = <VmcItem>[];
    if (_resultMap != null) {
      _resultMap!.forEach((key, value) {
        for (var element in value) {
          remaining.add(element);
        }
      });
    }

    _resultList?.forEach((element) => remaining.add(element));
    for (var element in _cancelled) {
      remaining.insert(0, element);
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          key: _scaffoldKey,

          /* appBar: TitleHelper.getAppBar(
            title: widget.title,
            icon: Icons.generating_tokens,
            titleClick: () {},
            printClick: () {},
            customBackClick: widget.customBackClick,
            context: context),*/
          body: isLoaded.value
              ? LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...List.generate(
                                        vmcGenerator.items?.length ?? 0,
                                        (index) {
                                          Space data = Space(
                                            id: -1,
                                            position: 0,
                                            item: vmcGenerator.items![index],
                                            rowIndex: 0,
                                          );
                                          Widget feedBack = Material(
                                              type: MaterialType.transparency,
                                              child: _vmcStateKey
                                                          .currentState !=
                                                      null
                                                  ? SizedBox(
                                                      width: _vmcStateKey
                                                              .currentState!
                                                              .getWidthSingle(
                                                                  vmcGenerator
                                                                      .vmc) *
                                                          vmcGenerator
                                                              .items![index]
                                                              .itemConfiguration!
                                                              .widthSpaces,
                                                      height: _vmcStateKey
                                                          .currentState!
                                                          .getRowHeight(
                                                              _vmcStateKey
                                                                  .currentState!
                                                                  .vmc!,
                                                              0),
                                                      child: Stack(children: [
                                                        SpaceItem(
                                                          onDragStarted:
                                                              (item, offset) {
                                                            _vmcStateKey
                                                                .currentState!
                                                                .candidate = item;
                                                          },
                                                          onDragEnd: (details) {
                                                            _vmcStateKey
                                                                .currentState!
                                                                .candidate = null;
                                                          },
                                                          constraints:
                                                              _vmcStateKey
                                                                  .currentState!
                                                                  .widget
                                                                  .constraints,
                                                          scaleFactor:
                                                              ValueNotifier<
                                                                  double>(1),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      0),
                                                          space: data,
                                                          parentKey:
                                                              _vmcStateKey,
                                                          width: _vmcStateKey
                                                                  .currentState!
                                                                  .getWidthSingle(
                                                                      vmcGenerator
                                                                          .vmc) *
                                                              vmcGenerator
                                                                  .items![index]
                                                                  .itemConfiguration!
                                                                  .widthSpaces,
                                                          height: _vmcStateKey
                                                              .currentState!
                                                              .getRowHeight(
                                                                  _vmcStateKey
                                                                      .currentState!
                                                                      .vmc!,
                                                                  0),
                                                          vmc: _vmcStateKey
                                                              .currentState!
                                                              .vmc!,
                                                          spaceIndex: 0,
                                                          rowIndex: 0,
                                                          curve: Curves.linear,
                                                        ),
                                                      ]),
                                                    )
                                                  : const SizedBox());

                                          return SizedBox(
                                            width: constraints.maxWidth / 3.5,
                                            child: Draggable<Space>(
                                              feedback: feedBack,
                                              data: data,
                                              child: ListTile(
                                                onTap: () async {
                                                  setState(() {
                                                    _currentItem = vmcGenerator
                                                        .items?[index];
                                                    _currentItemIndex = index;
                                                    if (MediaQuery.of(context)
                                                            .size
                                                            .width <
                                                        600) {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return itemPropertyWidget(
                                                                onClose: () {
                                                                  _currentSpace =
                                                                  null;
                                                              _currentItem =
                                                                  null;
                                                              _currentItemIndex =
                                                                  -1;
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          });
                                                    }
                                                  });

                                                  /*EditItem editItem = EditItem(item: vmcGenerator.items?[index]);
                                            final result = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                              return editItem;
                                            }));


                                            vmcGenerator.items![index]=result as Item;
                                            generate();*/
                                                },
                                                leading: Container(
                                                    height: 24,
                                                    width: 24,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: vmcGenerator
                                                                  .items![index]
                                                                  .color !=
                                                              null
                                                          ? Color(vmcGenerator
                                                              .items![index]
                                                              .color!)
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                    ),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          vmcGenerator
                                                                  .items?[index]
                                                                  .item
                                                                  .code ??
                                                              '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: vmcGenerator
                                                                          .items![
                                                                              index]
                                                                          .color !=
                                                                      null
                                                                  ? Color(vmcGenerator.items![index].color!)
                                                                              .computeLuminance() >
                                                                          0.5
                                                                      ? Colors
                                                                          .black
                                                                          .withAlpha(
                                                                              200)
                                                                      : Colors
                                                                          .white
                                                                          .withAlpha(
                                                                              200)
                                                                  : Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary),
                                                        ))),
                                                title: Text(vmcGenerator
                                                        .items?[index]
                                                        .item
                                                        .description ??
                                                    ''),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const Divider(),
                                      ...List.generate(
                                        remaining.length,
                                        (index) => InkWell(
                                          onTap: () async {
/*                                              EditItem editItem = EditItem(item: vmcGenerator.items?[index]);
                                            final result = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                              return editItem;
                                            }));


                                            vmcGenerator.items![index]=result as Item;
                                            generate();*/
                                          },
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: <InlineSpan>[
                                                      WidgetSpan(
                                                        alignment:
                                                            PlaceholderAlignment
                                                                .middle,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Container(
                                                              height: 24,
                                                              width: 24,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .error),
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    remaining[index]
                                                                            .item
                                                                            .code ??
                                                                        '',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .onError),
                                                                  ))),
                                                        ),
                                                      ),
                                                      WidgetSpan(
                                                        alignment:
                                                            PlaceholderAlignment
                                                                .middle,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  8, 2, 8, 2),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              children: [
                                                                Text(remaining[
                                                                            index]
                                                                        .item
                                                                        .description ??
                                                                    ''),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                const Text(
                                                                    'Qta'),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(remaining[
                                                                            index]
                                                                        .itemConfiguration
                                                                        ?.depthSpaces
                                                                        .toString() ??
                                                                    ''),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      //Text(_resultMap![index].toString()))
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return InteractiveViewer(
                                  /*boundaryMargin: const EdgeInsets.all(1000),
                                  minScale: 0.01,*/
                                  maxScale: 50,
                                  child: SingleChildScrollView(
                                    child: VmcView(
                                      onItemTap: (space, rowIndex, spaceIndex) {
                                        setState(() {
                                          _currentSpace = space;

                                          /// cerco tra gli articoli di basde l'indice dell'articolo cliccato
                                          int localItemIndex = -1;
                                          if (space.item != null) {
                                            for (int itemIndex = 0;
                                                itemIndex <
                                                    (vmcGenerator
                                                            .items?.length ??
                                                        0);
                                                itemIndex++) {
                                              VmcItem element = vmcGenerator
                                                  .items![itemIndex];
                                              if (element == space.item) {
                                                localItemIndex = itemIndex;
                                                break;
                                              }
                                            }
                                          }
                                          if (localItemIndex != -1 &&
                                              space.item != null) {
                                            _currentItem = space.item!;
                                            _currentItemIndex = localItemIndex;
                                          }

                                          if (MediaQuery.of(context)
                                              .size
                                              .width <
                                              600) {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return itemPropertyWidget(
                                                      onClose: () {
                                                        _currentSpace = null;
                                                    _currentItem = null;

                                                    _currentItemIndex = -1;
                                                    Navigator.pop(context);
                                                  });
                                                });
                                          }
                                        });
                                      },
                                      onClose: (item) {
                                        if (item != null) {
                                          setState(() {
                                            _cancelled.add(item);
                                          });
                                        }
                                      },
                                      key: _vmcStateKey,
                                      vmc: vmcGenerator.vmc,
                                      constraints: BoxConstraints(
                                        maxHeight: constraints.maxHeight,
                                      ),
                                      highlightSpace: _currentSpace,
                                      highlightItem: _currentItem,
                                      canCloseItem: _canCloseItem,
                                    ),
                                  ),
                                );
                                /*return List.generate(1, (int i) {
                            return AnimationConfiguration.synchronized(
                              key: ValueKey(_generationId),
                              duration: const Duration(milliseconds: 800),
                              child: ScaleAnimation(
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FadeInAnimation(
                                      child: InteractiveViewer(
                                        maxScale: 10,
                                        child: SingleChildScrollView(
                                          child: VmcView(
                                            onItemTap: (space, rowIndex, spaceIndex){
                                              setState(() {

                                                /// cerco tra gli articoli di basde l'indice dell'articolo cliccato
                                                int localItemIndex=-1;
                                                if (space.item!=null) {
                                                  for (int itemIndex=0; itemIndex<(vmcGenerator.items?.length ?? 0); itemIndex++){
                                                    Item element = vmcGenerator.items![itemIndex];
                                                    if (element == space.item){
                                                      localItemIndex=itemIndex;
                                                      break;
                                                    }
                                                  }
                                                }
                                                if (localItemIndex!=-1 && space.item!=null){
                                                _currentItem=space.item!;
                                                _currentItemIndex = localItemIndex;
                                                }

                                                if (MediaQuery.of(context).size.width<600) {
                                                  showModalBottomSheet(
                                                      context: context, builder: (context){
                                                    return itemPropertyWidget(onClose: (){
                                                      _currentItem = null;
                                                      _currentItemIndex = -1;
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                }
                                              });
                                            },
                                            onClose:(item){
                                              if (item!=null) {
                                                setState(() {
                                                  _cancelled.add(item);
                                                });
                                              }
                                            },
                                            key: _vmcStateKey,
                                            vmc: vmcGenerator.vmc,
                                            constraints: BoxConstraints(
                                              maxHeight:
                                                  constraints.maxHeight,
                                            ),
                                            highlightItem: _currentItem,
                                            canCloseItem: _canCloseItem,
                                          ),
                                        ),
                                      ),
                                      curve: Curves.linear)),
                            );
                          }).first;*/
                              }),
                            )),
                        if ((_currentItem != null) &&
                            MediaQuery.of(context).size.width >= 600)
                          itemPropertyWidget()
                      ],
                    ),
                  );
                })
              : const Center(
                  child: Text('Carica i dati'),
                ),
          //bottomSheet:  ((_currentItem != null) && MediaQuery.of(context).size.width<600) ? Center(child: itemPropertyWidget()) : null,
          bottomNavigationBar: SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _vmcStateKey.currentState?.undo();
                      });
                    },
                    icon: const Icon(Icons.undo)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _vmcStateKey.currentState?.redo();
                      });
                    },
                    icon: const Icon(Icons.redo)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _vmcStateKey.currentState?.showHideGridLines(
                            !(_vmcStateKey.currentState?.showGridLines ??
                                true));
                      });
                    },
                    icon: const Icon(Icons.grid_on)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _vmcStateKey.currentState?.newVmcStandard();
                        vmcGenerator.vmc = Vmc.standard(1, 1, 'test', 'test');
                      });
                    },
                    icon: const Icon(Icons.add)),
                IconButton(
                    onPressed: () {
                      //if (MediaQuery.of(context).size.width<600) {
                      setState(() {
                        _canCloseItem = !_canCloseItem;
                      });
                      //}
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      //if (MediaQuery.of(context).size.width<600) {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return EditVmc(
                              vmc: vmcGenerator.vmc,
                              onClose: (item) {
                                Navigator.pop(context);
                              },
                              onSave: (item) {
                                generate(vmcGenerator.vmc);
                              },
                            );
                          });
                      //}
                    },
                    icon: const Icon(Icons.settings)),
                IconButton(
                    onPressed: () {
                      _vmcStateKey.currentState?.showRealHeight();
                    },
                    icon: const Icon(Icons.line_weight)),
                IconButton(
                    onPressed: () {
                      _vmcStateKey.currentState?.showFullHeight();
                    },
                    icon: const Icon(Icons.height)),
                IconButton(
                    onPressed: () {
                      generate(vmcGenerator.vmc);
                      setState(() {
                        _vmcStateKey.currentState
                            ?.reloadWith(vmcToUse: vmcGenerator.vmc);

                        /*_vmcStateKey.currentState?.vmc=vmcGenerator.vmc;
                    _vmcStateKey.currentState?.vmcCopy=vmcGenerator.vmc;*/
                      });
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
          )),
    );
  }

  Widget itemPropertyWidget({VoidCallback? onClose}) {
    return SizedBox(
        key: ValueKey(_currentItem),
        width: 350,
        child: EditItemOld(
            item: _currentItem,
            onAdd: (VmcItem item) {
              setState(() {
                _vmcStateKey.currentState?.add(item);
              });
            },
            onSave: (VmcItem item) {
              setState(() {
                vmcGenerator.updateVmcItem(_currentItemIndex, item);
                _vmcStateKey.currentState
                    ?.reloadWith(vmcToUse: vmcGenerator.vmc);
                /*vmcGenerator.items![_currentItemIndex] = item;
                _vmcStateKey.currentState
                    ?.reloadWith(vmcToUse: vmcGenerator.vmc);*/
              });
            },
            onClose: onClose != null
                ? (item) => onClose.call()
                : (VmcItem item) {
                    setState(() {
                      _currentItem = null;
                      _currentSpace = null;
                      _currentItemIndex = -1;
                    });
                  }));
  }

  void generate(vmc) {
    //_resultMap = vmcGenerator.generate2();
    _resultList = vmcGenerator.generate4(vmc);

    setState(() {
      //_generationId = Random().nextInt(0xFFFFFFFF);
      isLoaded.value = true;
    });
  }
}
