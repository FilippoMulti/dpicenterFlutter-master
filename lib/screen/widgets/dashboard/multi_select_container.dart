import 'package:dpicenter/screen/widgets/dashboard/multi_select.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class MultiSelectorItem implements Equatable {
  final Icon? icon;
  final String text;
  final int? elementCount;

  const MultiSelectorItem({required this.text, this.icon, this.elementCount});

  @override
  // TODO: implement props
  List<Object?> get props => [text, icon, elementCount];

  @override
  bool? get stringify => false;
}

class MultiSelectorContainer extends StatefulWidget {
  final String? title;
  final Map<MultiSelectorItem, GlobalKey> headerSectionsMap;
  final ScrollController scrollController;
  final Widget child;
  final Widget? bottom;
  final bool useScrollable;

  const MultiSelectorContainer(
      {this.title,
      required this.scrollController,
      required this.headerSectionsMap,
      required this.child,
      this.useScrollable = true,
      this.bottom,
      Key? key})
      : super(key: key);

  @override
  State<MultiSelectorContainer> createState() => _MultiSelectorContainerState();
}

class _MultiSelectorContainerState extends State<MultiSelectorContainer> {
  final Map<GlobalKey, RenderBox> _boxes = <GlobalKey, RenderBox>{};
  final GlobalKey<MultiSelectorExState> _multiSelectorKey =
      GlobalKey<MultiSelectorExState>(debugLabel: '_multiSelectorKey');

  ///stato della barra di navigazione
  int statNavStatus = -1;

  ///scorre alla posizione di toNavStatus e poi viene impostato statNavStatus
  int toNavStatus = -1;
  final GlobalKey<DialogTitleExState> _dialogTitleKey =
      GlobalKey<DialogTitleExState>(debugLabel: '_dialogTitleKey');
  final GlobalKey _dialogNavigationKey =
      GlobalKey(debugLabel: '_dialogNavigationKey');

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_formKey');
  String? title;

  final ScrollController _multiSelectorScrollController =
      ScrollController(debugLabel: '_multiSelectorScrollController');

  List<SelectorData>? _selectorData;

  @override
  void initState() {
    widget.scrollController.addListener(scrollListener);
    title = widget.title;
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(scrollListener);
    _boxes.clear();
    //widget.scrollController.dispose();
    _multiSelectorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DialogTitleEx(
              key: _dialogTitleKey,
              widget.title ?? '',
              titleAlignment: CrossAxisAlignment.start,
              trailingChild: isLittleWidth() ? _popupCategoryButton() : null),
          Expanded(
            child: Form(
                key: _formKey,
                child: Container(
                    //padding: const EdgeInsets.all(5),
                    /*constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height > 700
                            ? MediaQuery.of(context).size.height -
                                (MediaQuery.of(context).size.height / 3)
                            : MediaQuery.of(context).size.height),*/
                    child: _mainLayout())),
          ),
          if (widget.bottom != null) widget.bottom!,
        ],
      ),
    );
  }

  bool isLittleWidth({BuildContext? passedContext}) =>
      MediaQuery.of(passedContext ?? context).size.width <= 1000;

  Widget _mainLayout() {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: widget.child,
                  ),
                  //const SizedBox(height: 20),
                ]),
          ),
          if (!isLittleWidth()) _categorySelector(),
        ]);
  }

  ///se esiste, aggiungo alle chiavi da navigare la chiave e il box relativo
  void addToBoxes(GlobalKey key) {
    if (!_boxes.containsKey(key)) {
      var box = key.currentContext?.findRenderObject();
      if (box != null && box is RenderBox) {
        _boxes.addAll({key: box});
      }
    }
  }

  Widget _categorySelector() {
    return SizedBox(
      width: 330,
      child: SingleChildScrollView(
          controller: _multiSelectorScrollController,
          key: _dialogNavigationKey,
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                /*  _fieldsDropDown(),
                const SizedBox(
                  height: 16,
                ),*/
                Padding(
                  padding: getPadding(),
                  child: _multiSelector(),
                ),
              ],
            ),
          )),
    );
  }

  EdgeInsets getPadding() {
    return const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
  }

  Widget _multiSelector() {
    _selectorData = _getSelectorData(direction: Axis.vertical);
    _multiSelectorKey.currentState?.selectorData = _selectorData!;
    return MultiSelectorEx(
      direction: Axis.vertical,
      key: _multiSelectorKey,
      onPressed: (index) async {
        if (isLittleWidth()) {
          if (!mounted) return;
          Navigator.of(context).pop();
        }

        toNavStatus = index;
        //statNavStatus = index;
        /*setState(() {
                        statNavStatus = index;
                    });*/
        await _scrollToCurrentNavStatus(); //_scrollToCurrentStatus();
        statNavStatus = index;
        _multiSelectorKey.currentState?.setState(() {
          _multiSelectorKey.currentState?.status = statNavStatus;
        });

        //widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
      },
      status: statNavStatus,
      selectorData: _selectorData!,
    );
  }

  List<SelectorData> _getSelectorData({Axis direction = Axis.horizontal}) {
    /* Map mapSettings = selectedSettings.groupBy((p0) => p0.categoryName);
    Map mapProductions = selectedProductions.groupBy((p0) => p0.categoryName);
*/
    List<SelectorData> result = <SelectorData>[];

    widget.headerSectionsMap.forEach((key, value) {
      if (_checkCategoryKey(key)) {
        result.add(getSelectorDataItem(
            text: key.text,
            icon: key.icon,
            elementCount: key.elementCount,
            direction: direction,
            color: Theme.of(context).colorScheme.primary.withAlpha(150)));
      }
    });

    return result;
  }

  SelectorData getSelectorDataItem({
    required String text,
    Axis direction = Axis.horizontal,
    required Color color,
    Icon? icon,
    int? elementCount,
  }) {
    Color foreColor = Colors.white;

    if (Theme.of(context)
            .colorScheme
            .primary
            .withAlpha(150)
            .computeLuminance() >
        0.5) {
      foreColor = Colors.black87;
    } else {
      foreColor = Colors.white.withAlpha(240);
    }
    return SelectorData(
        key: ValueKey(text),
        periodString: text,
        selectedColor: color,
        elementCount: elementCount,
        child: Container(
          constraints: direction == Axis.horizontal
              ? null
              : const BoxConstraints(maxHeight: 50, minWidth: 290),
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (icon != null) const SizedBox(width: 8),
            if (icon != null) Icon(icon.icon, color: foreColor),
            const SizedBox(width: 8),
            Align(
                alignment: Alignment.centerLeft,
                child: badges.Badge(
                  key: GlobalKey(),
                  badgeColor: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withAlpha(200),
                  animationType: badges.BadgeAnimationType.scale,
                  padding: const EdgeInsets.all(5),
                  animationDuration: const Duration(milliseconds: 500),
                  position: badges.BadgePosition.topEnd(top: -10, end: -26),
                  showBadge: elementCount != null,
                  borderRadius: BorderRadius.circular(100),
                  badgeContent: elementCount != null
                      ? SizedBox(
                          width: 32,
                          child: Text(elementCount.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withAlpha(200)
                                              .computeLuminance() >
                                          0.5
                                      ? Colors.black87
                                      : Colors.white.withAlpha(230))))
                      : null,
                  child: Text(text,
                      style: direction == Axis.horizontal
                          ? Theme.of(context).textTheme.bodySmall?.copyWith(
                              letterSpacing: 0,
                              wordSpacing: 0,
                              color: foreColor)
                          : Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: foreColor)),
                )),
            const SizedBox(width: 8),
          ]),
        ));
  }

  bool _checkCategoryKey(MultiSelectorItem key) {
/*    switch (key) {
      case 'Assegnazione':
        return currentStato >= 1;
      case 'Impostazioni':
        return currentStato >= 2;
      case 'Produzione':
        return currentStato >= 2;
      case 'Operazioni':
        return currentStato >= 2 && element != null;

      default:
        return true;
    }*/
    return true;
  }

  Future _scrollToCurrentNavStatus() async {
    GlobalKey? key;

    Map<MultiSelectorItem, GlobalKey> mapIndexKey = _getMapIndexKey();

    if (toNavStatus >= 0 && toNavStatus < mapIndexKey.entries.length) {
      key = mapIndexKey.entries.elementAt(toNavStatus).value;
      print("key founded: $key");
      if (key.currentContext != null) {
        if (!widget.useScrollable) {
          await widget.scrollController.position
              .ensureVisible(key.currentContext!.findRenderObject()!,
                  alignment: 0.0,
                  duration: const Duration(milliseconds: 500),
                  //curve: Curves.easeOut,
                  //targetRenderObject: renderObj,
                  alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
        } else {
          await Scrollable.ensureVisible(key.currentContext!,
              alignment: 0.0,
              duration: const Duration(milliseconds: 500),
              //curve: Curves.easeOut,
              //targetRenderObject: renderObj,
              alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
        }
        /*await Scrollable.ensureVisible(key.currentContext!,  alignment: 0.0,
            duration: const Duration(milliseconds: 500));*/
      }
    }
  }

  Map<MultiSelectorItem, GlobalKey> _getMapIndexKey() {
    Map<MultiSelectorItem, GlobalKey> mapIndexKey = {};

    widget.headerSectionsMap.forEach((key, value) {
      if (_checkCategoryKey(key)) {
        mapIndexKey.addAll({key: value});
      }
    });

    return mapIndexKey;
  }

  Widget _popupCategoryButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: const CircleBorder(),
        type: MaterialType.transparency,
        child: PopupMenuButton(
          position: PopupMenuPosition.under,
          tooltip: 'Categorie',
          constraints: const BoxConstraints(maxWidth: 1500),
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          itemBuilder: (BuildContext context) => List.generate(
            1,
            (index) => PopupMenuItem(
              value: index,
              child: _categorySelector(),

              /*Note.fromSampleItemNote(widget.itemConfiguration.notes[index], context),*/
            ),
          ),
        ),
      ),
    );
  }

  void scrollListener() {
    bool isNavigationOnTop = MediaQuery.of(context).size.width <= 800;

    Map<MultiSelectorItem, GlobalKey> mapIndexKey = _getMapIndexKey();

    ///se esistono, aggiungo alle chiavi da navigare i relativi boxes
    _boxes.clear();
    for (var item in mapIndexKey.keys) {
      addToBoxes(mapIndexKey[item]!);
    }

    int index = -1;
    int nCycle = 0;

    double dy =
        0; //(_reportStatBlocKey.currentContext!.findRenderObject()! as RenderBox).localToGlobal(Offset.zero).dy + (_isTinyWidth() ? 66 : 0);

    RenderBox? currentBox = context.findRenderObject() as RenderBox?;
    Offset mainBoxOffset =
        currentBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    RenderBox? currentDialogTitleBox =
        _dialogTitleKey.currentContext?.findRenderObject() as RenderBox?;
    Offset currentDialogTitleBoxOffset =
        currentDialogTitleBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    RenderBox? currentDialogNavigationBox =
        _dialogNavigationKey.currentContext?.findRenderObject() as RenderBox?;

    Offset currentDialogNavigationBoxOffset =
        currentDialogNavigationBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    //print("Dy: $dy");
    //print("mainBoxOffset.dy: ${mainBoxOffset.dy+4}");
    dy = (mainBoxOffset.dy +
        currentDialogTitleBoxOffset.dy +
        (currentDialogTitleBox?.size.height ?? 0) +
        (isNavigationOnTop
            ? (currentDialogNavigationBox?.size.height ?? 0)
            : 0));

    for (MapEntry entry in _boxes.entries) {
      if ((entry.value.localToGlobal(Offset.zero).dy - dy) < 10) {
        index = nCycle;
      } else {
        if (nCycle == 0) {
          if ((entry.value.localToGlobal(Offset.zero).dy - dy) > 100) {
            index = -1;
          }
        }
      }
      nCycle++;
    }

    if (widget.scrollController.position.pixels <=
        widget.scrollController.position.minScrollExtent) {
      title = "${widget.title ?? ''} - ${mapIndexKey.keys.elementAt(0).text}";
      _setTitle(title);
    } else if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent) {
      title = "${widget.title ?? ''} - ${mapIndexKey.keys.last.text}";
      _setTitle(title);
    } else {
      if (index == -1) {
        if (title != (widget.title ?? '')) {
          title = widget.title ?? '';
          _setTitle(title);
        }
      } else {
        if (index < mapIndexKey.length) {
          if (index < mapIndexKey.keys.length) {
            int localIndex = index - widget.headerSectionsMap.length;
            String desiredTitle = "";
            //if (localIndex < 0 || localIndex >= categoriesMap!.length) {
            desiredTitle =
                "${widget.title ?? ''} - ${mapIndexKey.keys.elementAt(index).text}";
            /*} else {
              desiredTitle =
                  "${widget.title ?? ''} - ${categoriesMap!.keys.elementAt(localIndex)}";
            }*/
            if (title != desiredTitle) {
              title = desiredTitle;
              _setTitle(title);
            }
          }
        }
      }
    }

    if (statNavStatus != index) {
      statNavStatus = index;

      if (index != -1) {
        if (_multiSelectorKey.currentState?.mounted ?? false) {
          _multiSelectorKey.currentState?.setState(() {
            _multiSelectorKey.currentState?.status = index;
          });
        }
      }
    }
  }

  void _setTitle(String? title) {
    if (title != null) {
      if (_dialogTitleKey.currentState?.mounted ?? false) {
        _dialogTitleKey.currentState?.setState(() {
          _dialogTitleKey.currentState?.title = title;
        });
      }
    }
  }
}
