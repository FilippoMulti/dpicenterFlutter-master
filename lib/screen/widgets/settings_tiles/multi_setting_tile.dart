import 'package:animated_check/animated_check.dart';
import 'package:dpicenter/blocs/media_bloc.dart';
import 'package:dpicenter/blocs/picture_bloc.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/models/server/item_picture.dart';
import 'package:dpicenter/models/server/media.dart';
import 'package:dpicenter/models/server/media_item.dart';
import 'package:dpicenter/screen/widgets/file_loader/file_loader.dart';
import 'package:dpicenter/screen/widgets/image_loader/image_loader.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

class MultiSettingTile extends StatefulWidget {
  MultiSettingTile(
      {required this.title,
      this.initialValue,
      this.onToggle,
      this.defaultTextColor,
      this.enabled = true,
      this.readOnly = false,
      required this.textWhenFalse,
      this.description,
      this.icon,
      this.duration = const Duration(seconds: 1),
      this.user,
      required this.textWhenTrue,
      this.type = MultiSettingTileType.selection,
      this.hint,
      this.currentValueIcon,
      this.selectionChildren,
      this.showCheck = true,
      this.onResult,
      Key? key,
      this.falseValue,
      this.onImagesChanged,
      this.onImagesLoaded,
      this.quarterTurns = 0})
      : super(key: key);

  final String title;
  final dynamic initialValue;
  final Widget? icon;
  late final Widget? currentValueIcon;
  final String? description;
  late final String textWhenTrue;
  late final String textWhenFalse;
  late Color? defaultTextColor;
  late final Function(bool value)? onToggle;
  final bool enabled;
  final bool readOnly;
  final Duration duration;
  final String? user;
  late final Function(String? value)? onResult;

  late final MultiSettingTileType type;
  late final List<Widget>? selectionChildren;
  late final String? hint;

  final bool showCheck;

  ///valore da considerare come stato falso
  late final String? falseValue;
  late final Function(List<ItemPicture> values)? onImagesChanged;
  late final Function(List<ItemPicture> values)? onImagesLoaded;

  late final Function(List<MediaItem> values)? onMediasChanged;
  late final Function(List<MediaItem> values)? onMediasLoaded;

  final int quarterTurns;
  late double min;
  late double max;
  late double step;
  late int decimals;

  @override
  MultiSettingTileState createState() => MultiSettingTileState();

  MultiSettingTile.checkBoxTile({
    required this.title,
    this.onToggle,
    this.initialValue,
    this.defaultTextColor,
    this.enabled = true,
    this.readOnly = false,
    required this.textWhenFalse,
    this.description,
    this.icon,
    this.duration = const Duration(seconds: 1),
    this.user,
    required this.textWhenTrue,
    this.showCheck = true,
    this.quarterTurns = 0,
    Key? key,
  }) : super(key: key) {
    type = MultiSettingTileType.checkbox;
    currentValueIcon = null;
    hint = "";
    selectionChildren = null;
    falseValue = "";
  }

  MultiSettingTile.textInputTile({
    required this.title,
    this.initialValue,
    this.defaultTextColor,
    this.enabled = true,
    this.readOnly = false,
    this.description,
    this.icon,
    this.duration = const Duration(seconds: 1),
    this.user,
    this.showCheck = true,
    this.onResult,
    this.quarterTurns = 0,
    Key? key,
  }) : super(key: key) {
    type = MultiSettingTileType.textInput;
    currentValueIcon = null;
    hint = "";
    selectionChildren = null;
    falseValue = "";
  }

  MultiSettingTile.selection({
    required this.title,
    this.initialValue,
    this.onToggle,
    this.defaultTextColor,
    this.enabled = true,
    this.readOnly = false,
    this.description,
    this.icon,
    this.duration = const Duration(seconds: 1),
    this.user,
    this.selectionChildren,
    this.currentValueIcon,
    this.hint,
    required this.falseValue,
    this.showCheck = true,
    this.quarterTurns = 0,
    Key? key,
  }) : super(key: key) {
    type = MultiSettingTileType.selection;
    textWhenTrue = '';
    textWhenFalse = '';
  }

  MultiSettingTile.image({
    required this.title,
    this.initialValue,
    this.onImagesChanged,
    this.onImagesLoaded,
    this.defaultTextColor,
    this.enabled = true,
    this.readOnly = false,
    this.description,
    this.icon,
    this.duration = const Duration(seconds: 1),
    this.user,
    this.hint,
    required this.falseValue,
    this.showCheck = true,
    this.quarterTurns = 0,
    Key? key,
  }) : super(key: key) {
    type = MultiSettingTileType.image;
    textWhenTrue = '';
    textWhenFalse = '';
  }

  MultiSettingTile.file({
    required this.title,
    this.initialValue,
    this.onMediasChanged,
    this.onMediasLoaded,
    this.defaultTextColor,
    this.enabled = true,
    this.readOnly = false,
    this.description,
    this.icon,
    this.duration = const Duration(seconds: 1),
    this.user,
    this.hint,
    required this.falseValue,
    this.showCheck = true,
    this.quarterTurns = 0,
    Key? key,
  }) : super(key: key) {
    type = MultiSettingTileType.fileLoader;
    textWhenTrue = '';
    textWhenFalse = '';
  }

  MultiSettingTile.upDown({
    required this.title,
    this.quarterTurns = 0,
    this.min = 1,
    this.max = 100,
    this.step = 1,
    this.initialValue,
    this.defaultTextColor,
    this.enabled = true,
    this.readOnly = false,
    this.description,
    this.icon,
    this.duration = const Duration(seconds: 1),
    this.user,
    this.hint,
    this.showCheck = true,
    this.decimals = 0,
    this.onResult,
    Key? key,
  }) : super(key: key) {
    type = MultiSettingTileType.upDown;
    textWhenTrue = '';
    textWhenFalse = '';
    falseValue = "";
  }

  MultiSettingTile.note({
    required this.title,
    this.quarterTurns = 0,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.duration = const Duration(seconds: 1),
    this.description,
    this.icon,
    this.user,
    this.hint,
    this.showCheck = true,
    this.onResult,
    Key? key,
  }) : super(key: key) {
    type = MultiSettingTileType.upDown;
    textWhenTrue = '';
    textWhenFalse = '';
    falseValue = "";
    defaultTextColor = Colors.black;
  }
}

class MultiSettingTileState extends State<MultiSettingTile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool currentState = false;
  String? currentValue;
  String? currentUser;
  List<ItemPicture>? currentImages;
  List<MediaItem>? currentFiles;
  TextEditingController? textController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
        reverseDuration: widget.duration);

    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));
    switch (widget.type) {
      case MultiSettingTileType.checkbox:
        if (widget.initialValue != null) {
          currentState = widget.initialValue as bool;
        } else {
          currentState = false;
        }
        textController = TextEditingController();
        break;
      case MultiSettingTileType.selection:
        currentValue = widget.initialValue;
        textController = TextEditingController(text: widget.initialValue ?? '');

        break;
      case MultiSettingTileType.textInput:
        currentValue = widget.initialValue;
        textController = TextEditingController(text: widget.initialValue ?? '');

        break;
      case MultiSettingTileType.upDown:
        currentValue = widget.initialValue;
        textController = TextEditingController(text: widget.initialValue ?? '');

        break;
      case MultiSettingTileType.image:
        if (widget.initialValue != null &&
            widget.initialValue is List<ItemPicture>) {
          currentImages = widget.initialValue;
        }
        break;
      case MultiSettingTileType.fileLoader:
        if (widget.initialValue != null &&
            widget.initialValue is List<MediaItem>) {
          currentFiles = widget.initialValue;
        }
      default:
        break;
    //textController=TextEditingController(text: widget.initialValue ?? '');
    }

    currentUser = widget.user;

    WidgetsBinding.instance.addPostFrameCallback((_) => _controlStatus());
  }

  void _controlStatus() {
    switch (widget.type) {
      case MultiSettingTileType.selection:
        if (currentValue != null && currentValue!.isNotEmpty) {
          showCheck();
        } else {
          resetCheck();
        }

        break;
      case MultiSettingTileType.checkbox:
        if (currentState) {
          showCheck();
        } else {
          resetCheck();
        }
        break;
      case MultiSettingTileType.image:
        if (currentImages != null &&
            currentImages!
                .where((element) => element.mediaId != -1)
                .isNotEmpty) {
          showCheck();
        } else {
          resetCheck();
        }
        break;
      case MultiSettingTileType.textInput:
        if (currentValue != null && currentValue!.isNotEmpty) {
          showCheck();
        } else {
          resetCheck();
        }
        break;
      case MultiSettingTileType.upDown:
        if (currentValue != null && currentValue!.isNotEmpty) {
          showCheck();
        } else {
          resetCheck();
        }
        break;
      case MultiSettingTileType.fileLoader:
        if (currentFiles != null &&
            currentFiles!
                .where((element) => element.mediaId != -1)
                .isNotEmpty) {
          showCheck();
        } else {
          resetCheck();
        }
        break;
      default:
        break;
    }
  }

  void showCheck() {
    _controller.forward();
  }

  void resetCheck() {
    _controller.reverse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  double confirmIconSize = 64;
  double iconSpacer = 32;

  bool isTinyWidth() => MediaQuery.of(context).size.width <= 800;

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case MultiSettingTileType.checkbox:
        return _checkboxTile();
      case MultiSettingTileType.upDown:
        return _upDownTile();
      case MultiSettingTileType.image:
        return _imageTile();
      case MultiSettingTileType.fileLoader:
        return _fileTile();
      case MultiSettingTileType.selection:
        return _selectionTile();

      case MultiSettingTileType.textInput:
      default:
        return _textInputTile();
    }
  }

  Widget _upDownTile() {
    print("currentValue: ${currentValue}");
    return SettingsTile.navigation(
      enabled: widget.enabled,
      onPressed: (context) async {
        if (!widget.readOnly) {
          String? result = await displayUpDownInputDialog(context,
              title: widget.title,
              hint: widget.hint,
              initialValue: widget.initialValue,
              decimals: widget.decimals,
              min: widget.min,
              step: widget.step,
              max: widget.max);
          widget.onResult?.call(result);
          _controlStatus();
        }
      },
      leading: RotatedBox(
        quarterTurns: widget.quarterTurns,
        child: widget.icon,
      ),
      title: Text(
        widget.title ?? '',
        style: itemTitleStyle(),
      ),
      value: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.description != null)
                  DefaultTextStyle(
                    style: itemSubtitleStyle()!,
                    child: Text(widget.description!),
                  ),
                if (widget.description != null)
                  const SizedBox(
                    height: 8,
                  ),
                AnimatedSwitcher(
                  /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                  duration: const Duration(milliseconds: 350),
                  child: LayoutBuilder(
                      key: ValueKey<String?>(currentValue),
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: Text(
                            currentValue != null && currentValue!.isNotEmpty
                                ? currentValue!
                                : (widget.falseValue ?? ''),
                            textAlign: TextAlign.start,
                            style: itemValueTextStyle(),
                          ),
                        );
                      }),
                ),
                if (isTinyWidth())
                  const SizedBox(
                    height: 8,
                  ),
                if (isTinyWidth() && widget.showCheck)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: confirmIconSize,
                      height: confirmIconSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              currentValue != null && currentValue!.isNotEmpty
                                  ? Colors.white.withAlpha(100)
                                  : Colors.transparent),
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedCheck(
                        progress: _animation,
                        size: confirmIconSize,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                if (currentUser != null)
                  const SizedBox(
                    height: 8,
                  ),
                if (currentUser != null)
                  AnimatedSwitcher(
                    /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                    duration: const Duration(milliseconds: 350),
                    child: LayoutBuilder(
                        key: ValueKey<String?>(currentUser),
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Text(
                              textAlign: TextAlign.start,
                              currentUser != null ? currentUser! : '?',
                              style: itemMiniSubtitle2Style(),
                            ),
                          );
                        }),
                  ),
              ],
            ),
          ),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 32,
              ),
            ),
          if (isTinyWidth() == false && widget.showCheck)
            AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                width: confirmIconSize,
                height: confirmIconSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentValue != null && currentValue!.isNotEmpty
                        ? Colors.white.withAlpha(100)
                        : Colors.transparent),
                clipBehavior: Clip.antiAlias,
                child: AnimatedCheck(
                  progress: _animation,
                  size: confirmIconSize,
                  color: Theme.of(context).colorScheme.primary,
                )),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 82,
              ),
            ),
        ],
      ),
    );
  }

  Widget _imageTile() {
    print("currentValue: ${currentValue}");

    return SettingsTile.navigation(
      onPressed: (context) async {
        /*if (!widget.readOnly) {
          await displaySelectionDialog(context, widget.title, widget.hint ?? '',
              widget.initialValue, widget.selectionChildren ?? [], textController);
          _controlStatus();
        }*/
      },
      leading: widget.icon,
      title: Text(
        widget.hint ?? '',
        style: itemTitleStyle(),
      ),
      enabled: widget.enabled,
      color: currentImages != null &&
              currentImages!
                  .where((element) => element.mediaId != -1)
                  .isNotEmpty
          ? widget.showCheck
              ? Colors.green.withAlpha(180)
              : Colors.transparent
          : Colors.transparent,
      value: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.description != null)
                  DefaultTextStyle(
                    style: itemSubtitleStyle()!,
                    child: Text(widget.description!),
                  ),
                if (widget.description != null)
                  const SizedBox(
                    height: 8,
                  ),
                MultiBlocProvider(
                  providers: [
                    BlocProvider<ServerDataBloc<Media>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<Media>(
                          repo: MultiService<Media>(Media.fromJsonModel,
                              apiName: "Media")),
                    ),
                    BlocProvider<PictureBloc>(
                      lazy: false,
                      create: (context) => PictureBloc(),
                    ),
                  ],
                  child: ImageLoader(
                    showButtons: true,
                    itemPictures: currentImages ?? [],
                    onChanged: (items) {
                        if (mounted) {
                          setState(() {
                            currentImages = items
                                .where((element) => element.mediaId != -1)
                                .toList(growable: false);
                          });

                          _controlStatus();
                          widget.onImagesChanged?.call(currentImages ?? []);
                        }
                      },
                    onLoaded: (items) {
                        if (mounted) {
                          setState(() {
                            currentImages = items
                                .where((element) => element.mediaId != -1)
                                .toList(growable: false);
                          });
                          _controlStatus();
                          widget.onImagesLoaded?.call(items);
                        }
                      }),
                ),
                /*AnimatedSwitcher(
                  */ /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/ /*
                  duration: const Duration(milliseconds: 350),child: LayoutBuilder(
                    key: ValueKey<String?>(currentValue),
                    builder: (context, constraints) {

                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Text(
                          currentValue!=null && currentValue!.isNotEmpty ? currentValue! : (widget.falseValue ?? ''),
                          textAlign: TextAlign.start,
                          style: itemValueTextStyle(),
                        ),
                      );
                    }
                ),
                ),*/
                if (isTinyWidth())
                  const SizedBox(
                    height: 8,
                  ),
                if (isTinyWidth() && widget.showCheck)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: confirmIconSize,
                      height: confirmIconSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentImages != null &&
                                  currentImages!
                                      .where((element) => element.mediaId != -1)
                                      .isNotEmpty
                              ? Colors.white.withAlpha(100)
                              : Colors.transparent),
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedCheck(
                        progress: _animation,
                        size: confirmIconSize,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                if (currentUser != null)
                  const SizedBox(
                    height: 8,
                  ),
                if (currentUser != null)
                  AnimatedSwitcher(
                    /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                    duration: const Duration(milliseconds: 350),
                    child: LayoutBuilder(
                        key: ValueKey<String?>(currentUser),
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Text(
                              textAlign: TextAlign.start,
                              currentUser != null ? currentUser! : '?',
                              style: itemMiniSubtitle2Style(),
                            ),
                          );
                        }),
                  ),
              ],
            ),
          ),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 32,
              ),
            ),
          if (isTinyWidth() == false && widget.showCheck)
            AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                width: confirmIconSize,
                height: confirmIconSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentImages != null &&
                            currentImages!
                                .where((element) => element.mediaId != -1)
                                .isNotEmpty
                        ? Colors.white.withAlpha(100)
                        : Colors.transparent),
                clipBehavior: Clip.antiAlias,
                child: AnimatedCheck(
                  progress: _animation,
                  size: confirmIconSize,
                  color: Theme.of(context).colorScheme.primary,
                )),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 82,
              ),
            ),
        ],
      ),
    );
  }

  Widget _fileTile() {
    //print("currentValue: ${currentValue}");

    return SettingsTile.navigation(
      onPressed: (context) async {},
      leading: widget.icon,
      title: Text(
        widget.hint ?? '',
        style: itemTitleStyle(),
      ),
      enabled: widget.enabled,
      color: currentFiles != null &&
              currentFiles!.where((element) => element.mediaId != -1).isNotEmpty
          ? widget.showCheck
              ? Colors.green.withAlpha(180)
              : Colors.transparent
          : Colors.transparent,
      value: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.description != null)
                  DefaultTextStyle(
                    style: itemSubtitleStyle()!,
                    child: Text(widget.description!),
                  ),
                if (widget.description != null)
                  const SizedBox(
                    height: 8,
                  ),
                MultiBlocProvider(
                  providers: [
                    BlocProvider<ServerDataBloc<Media>>(
                      lazy: false,
                      create: (context) => ServerDataBloc<Media>(
                          repo: MultiService<Media>(Media.fromJsonModel,
                              apiName: "Media")),
                    ),
                    BlocProvider<MediaBloc>(
                      lazy: false,
                      create: (context) => MediaBloc(),
                    ),
                  ],
                  child: FileLoader(
                      showButtons: true,
                      itemFiles: currentFiles ?? [],
                      onChanged: (items) {
                        if (mounted) {
                          setState(() {
                            currentFiles = items
                                .where((element) => element.mediaId != -1)
                                .toList(growable: false);
                          });

                          _controlStatus();
                          widget.onMediasChanged?.call(currentFiles ?? []);
                        }
                      },
                      onLoaded: (items) {
                        if (mounted) {
                          setState(() {
                            currentFiles = items
                                .where((element) => element.mediaId != -1)
                                .toList(growable: false);
                          });
                          _controlStatus();
                          widget.onMediasLoaded?.call(items);
                        }
                      }),
                ),
                /*AnimatedSwitcher(
                  */ /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/ /*
                  duration: const Duration(milliseconds: 350),child: LayoutBuilder(
                    key: ValueKey<String?>(currentValue),
                    builder: (context, constraints) {

                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Text(
                          currentValue!=null && currentValue!.isNotEmpty ? currentValue! : (widget.falseValue ?? ''),
                          textAlign: TextAlign.start,
                          style: itemValueTextStyle(),
                        ),
                      );
                    }
                ),
                ),*/
                if (isTinyWidth())
                  const SizedBox(
                    height: 8,
                  ),
                if (isTinyWidth() && widget.showCheck)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: confirmIconSize,
                      height: confirmIconSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentImages != null &&
                                  currentImages!
                                      .where((element) => element.mediaId != -1)
                                      .isNotEmpty
                              ? Colors.white.withAlpha(100)
                              : Colors.transparent),
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedCheck(
                        progress: _animation,
                        size: confirmIconSize,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                if (currentUser != null)
                  const SizedBox(
                    height: 8,
                  ),
                if (currentUser != null)
                  AnimatedSwitcher(
                    /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                    duration: const Duration(milliseconds: 350),
                    child: LayoutBuilder(
                        key: ValueKey<String?>(currentUser),
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Text(
                              textAlign: TextAlign.start,
                              currentUser != null ? currentUser! : '?',
                              style: itemMiniSubtitle2Style(),
                            ),
                          );
                        }),
                  ),
              ],
            ),
          ),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 32,
              ),
            ),
          if (isTinyWidth() == false && widget.showCheck)
            AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                width: confirmIconSize,
                height: confirmIconSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentImages != null &&
                            currentImages!
                                .where((element) => element.mediaId != -1)
                                .isNotEmpty
                        ? Colors.white.withAlpha(100)
                        : Colors.transparent),
                clipBehavior: Clip.antiAlias,
                child: AnimatedCheck(
                  progress: _animation,
                  size: confirmIconSize,
                  color: Theme.of(context).colorScheme.primary,
                )),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 82,
              ),
            ),
        ],
      ),
    );
  }

  Widget _selectionTile() {
    print("currentValue: ${currentValue}");
    return SettingsTile.navigation(
      onPressed: (context) async {
        if (!widget.readOnly) {
          await displaySelectionDialog(
              context,
              widget.title,
              widget.hint ?? '',
              widget.initialValue,
              widget.selectionChildren ?? [],
              textController);
          _controlStatus();
        }
      },
      leading: widget.icon,
      title: Text(widget.hint ?? '', style: itemTitleStyle()),
      enabled: widget.enabled,
      color: currentValue != null && currentValue!.isNotEmpty
          ? widget.showCheck
              ? Colors.green.withAlpha(180)
              : Colors.transparent
          : Colors.transparent,
      value: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.description != null)
                  DefaultTextStyle(
                    style: itemSubtitleStyle()!,
                    child: Text(widget.description!),
                  ),
                if (widget.description != null)
                  const SizedBox(
                    height: 8,
                  ),
                AnimatedSwitcher(
                  /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                  duration: const Duration(milliseconds: 350),
                  child: LayoutBuilder(
                      key: ValueKey<String?>(currentValue),
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: Text(
                            currentValue != null && currentValue!.isNotEmpty
                                ? currentValue!
                                : (widget.falseValue ?? ''),
                            textAlign: TextAlign.start,
                            style: itemValueTextStyle(),
                          ),
                        );
                      }),
                ),
                if (isTinyWidth())
                  const SizedBox(
                    height: 8,
                  ),
                if (isTinyWidth() && widget.showCheck)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: confirmIconSize,
                      height: confirmIconSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              currentValue != null && currentValue!.isNotEmpty
                                  ? Colors.white.withAlpha(100)
                                  : Colors.transparent),
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedCheck(
                        progress: _animation,
                        size: confirmIconSize,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                if (currentUser != null)
                  const SizedBox(
                    height: 8,
                  ),
                if (currentUser != null)
                  AnimatedSwitcher(
                    /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                    duration: const Duration(milliseconds: 350),
                    child: LayoutBuilder(
                        key: ValueKey<String?>(currentUser),
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Text(
                              textAlign: TextAlign.start,
                              currentUser != null ? currentUser! : '?',
                              style: itemMiniSubtitle2Style(),
                            ),
                          );
                        }),
                  ),
              ],
            ),
          ),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 32,
              ),
            ),
          if (isTinyWidth() == false && widget.showCheck)
            AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                width: confirmIconSize,
                height: confirmIconSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentValue != null && currentValue!.isNotEmpty
                        ? Colors.white.withAlpha(100)
                        : Colors.transparent),
                clipBehavior: Clip.antiAlias,
                child: AnimatedCheck(
                  progress: _animation,
                  size: confirmIconSize,
                  color: Theme.of(context).colorScheme.primary,
                )),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 82,
              ),
            ),
        ],
      ),
    );
  }

  Widget _checkboxTile() {
    return SettingsTile.switchTile(
      onToggle: (value) {
        if (!widget.readOnly) {
          setState(() {
            currentState = !currentState;
            _controlStatus();

            widget.onToggle?.call(value);
          });
        }
      },
      initialValue: currentState,
      leading: widget.icon,
      enabled: widget.enabled,
      color: currentState
          ? widget.showCheck
              ? Colors.green.withAlpha(180)
              : Colors.transparent
          : Colors.transparent,
      activeSwitchColor: Theme.of(context).colorScheme.primary,
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: itemTitleStyle()),
                if (widget.description != null)
                  DefaultTextStyle(
                    style: itemSubtitleStyle()!,
                    child: Text(widget.description!),
                  ),
                if (widget.description != null)
                  const SizedBox(
                    height: 8,
                  ),
                AnimatedSwitcher(
                  /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                  duration: const Duration(milliseconds: 350),
                  child: LayoutBuilder(
                      key: ValueKey<bool>(currentState),
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: Text(
                            textAlign: TextAlign.start,
                            currentState
                                ? widget.textWhenTrue
                                : widget.textWhenFalse,
                            style: itemValueTextStyle(),
                          ),
                        );
                      }),
                ),
                if (isTinyWidth())
                  const SizedBox(
                    height: 8,
                  ),
                if (isTinyWidth() && widget.showCheck)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: confirmIconSize,
                      height: confirmIconSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentState
                              ? Colors.white.withAlpha(100)
                              : Colors.transparent),
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedCheck(
                        progress: _animation,
                        size: confirmIconSize,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                if (currentUser != null)
                  const SizedBox(
                    height: 8,
                  ),
                if (currentUser != null)
                  AnimatedSwitcher(
                    /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                    duration: const Duration(milliseconds: 350),
                    child: LayoutBuilder(
                        key: ValueKey<String?>(currentUser),
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Text(
                              textAlign: TextAlign.start,
                              currentUser != null ? currentUser! : '?',
                              style: itemMiniSubtitle2Style(),
                            ),
                          );
                        }),
                  ),
              ],
            ),
          ),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 32,
              ),
            ),
          if (isTinyWidth() == false && widget.showCheck)
            AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                width: confirmIconSize,
                height: confirmIconSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentState
                        ? Colors.white.withAlpha(100)
                        : Colors.transparent),
                clipBehavior: Clip.antiAlias,
                child: AnimatedCheck(
                  progress: _animation,
                  size: confirmIconSize,
                  color: Theme.of(context).colorScheme.primary,
                )),
        ],
      ),
    );
  }

  Widget _textInputTile() {
    return SettingsTile.navigation(
      enabled: widget.enabled,
      onPressed: (context) async {
        if (!widget.readOnly) {
          String? result = await displayTextInputDialog(
              context: context,
              title: widget.title,
              hint: widget.hint,
              initialValue: widget.initialValue);
          /* setState((){
          currentValue=result;
        });*/

          widget.onResult?.call(result);
          _controlStatus();
        }
      },
      leading: widget.icon,
      title: Text(widget.title, style: itemTitleStyle()),
      color: currentState
          ? widget.showCheck
              ? Colors.green.withAlpha(180)
              : Colors.transparent
          : Colors.transparent,
      value: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.description != null)
                  DefaultTextStyle(
                    style: itemSubtitleStyle()!,
                    child: Text(widget.description!),
                  ),
                if (widget.description != null)
                  const SizedBox(
                    height: 8,
                  ),
                AnimatedSwitcher(
                  /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                  duration: const Duration(milliseconds: 350),
                  child: LayoutBuilder(
                      key: ValueKey<String?>(currentValue),
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: Text(
                            currentValue != null && currentValue!.isNotEmpty
                                ? currentValue!
                                : (widget.falseValue ?? ''),
                            textAlign: TextAlign.start,
                            style: itemValueTextStyle(),
                          ),
                        );
                      }),
                ),
                if (isTinyWidth())
                  const SizedBox(
                    height: 8,
                  ),
                if (isTinyWidth() && widget.showCheck)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: confirmIconSize,
                      height: confirmIconSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              currentValue != null && currentValue!.isNotEmpty
                                  ? Colors.white.withAlpha(100)
                                  : Colors.transparent),
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedCheck(
                        progress: _animation,
                        size: confirmIconSize,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                if (currentUser != null)
                  const SizedBox(
                    height: 8,
                  ),
                if (currentUser != null)
                  AnimatedSwitcher(
                    /* transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                  },*/
                    duration: const Duration(milliseconds: 350),
                    child: LayoutBuilder(
                        key: ValueKey<String?>(currentUser),
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            child: Text(
                              textAlign: TextAlign.start,
                              currentUser != null ? currentUser! : '?',
                              style: itemMiniSubtitle2Style(),
                            ),
                          );
                        }),
                  ),
              ],
            ),
          ),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 32,
              ),
            ),
          if (isTinyWidth() == false && widget.showCheck)
            AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                width: confirmIconSize,
                height: confirmIconSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentValue != null && currentValue!.isNotEmpty
                        ? Colors.white.withAlpha(100)
                        : Colors.transparent),
                clipBehavior: Clip.antiAlias,
                child: AnimatedCheck(
                  progress: _animation,
                  size: confirmIconSize,
                  color: Theme.of(context).colorScheme.primary,
                )),
          if (isTinyWidth() == false)
            UnconstrainedBox(
              child: Container(
                width: 82,
              ),
            ),
        ],
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    textController?.dispose();
    super.dispose();
  }
}

enum MultiSettingTileType {
  selection,
  checkbox,
  image,
  textInput,
  upDown,
  fileLoader,
  note,
}
