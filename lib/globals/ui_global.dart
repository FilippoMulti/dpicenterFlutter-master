import 'dart:async';
import 'dart:typed_data';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scan2/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:dpicenter/blocs/server_data_bloc.dart';
import 'package:dpicenter/extensions/color_extension.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/screen/connected_clients/connected_clients_screen.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dashboard/pusher.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/keyboard_close_widget.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_area_widget.dart';
import 'package:dpicenter/services/events.dart';
import 'package:dpicenter/services/server_data_event.dart';
import 'package:dpicenter/services/services.dart';
import 'package:dpicenter/services/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:ui' as ui;

import 'package:loading_indicator/loading_indicator.dart';

const String defaultBackgroundImage = 'graphics/default.jpg';
const String angryImage = 'graphics/angry_trasp.png';

//int? currentBackground;
//double currentBackgroundOpacity = 0.93;
const Color kGreenMultiTech = Color(0xFF95C11F);
Uint8List? defaultBackgroundBytes;

final List<String> assetsImages = <String>[
  'graphics/default.webp',
];

bool isTinyHeight(BuildContext context) {
  if (MediaQuery.of(context).size.height <= tinyHeight) {
    return true;
  }
  return false;
}

bool isTinyWidth(BuildContext context) {
  if (MediaQuery.of(context).size.width <= tinyWidth) {
    return true;
  }
  return false;
}

Color getAppBackgroundColor(BuildContext context) {
  if (isDarkTheme(context)) {
    return Color.alphaBlend(
        Theme.of(context).colorScheme.surface.withAlpha(240),
        Theme.of(context).colorScheme.primary);
  } else {
    return Theme.of(context).colorScheme.surface;
  }
}

void showFullScreenKeyboard(BuildContext context,
    TextEditingController txtCtrl, {
      void Function(String value)? onChanged,
      InputDecoration? decoration,
      TextStyle? style,
      int? maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.next,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return KeyboardClose(
        focusNode: FocusNode(),
        child: Scaffold(
            body: Column(
              children: [
                Expanded(child: Container()),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        onChanged: onChanged,
                        decoration: decoration ??
                            const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                        maxLines: maxLines,
                        autofocus: true,
                        textInputAction: textInputAction,
                        keyboardType: keyboardType,
                        controller: txtCtrl,
                        style: style,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: const Text('Fatto')),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            )),
      );
    },
  );
}

void showFullScreenKeyboard2(BuildContext context, Widget child, FocusNode focusNode) async {
  await showDialog(
    context: context,
    builder: (context) {
      return KeyboardClose(
          focusNode: focusNode,
          child: TextArea(focusNode: focusNode, child: child)
        /*Scaffold(
            body: Column(
              children: [
                Expanded(child: Container()),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: child,
                    ),
                    TextButton(onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }, child: const Text('Fatto')),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            )
        ),*/
      );
    },
  ).then((value) => print("then"));
  print("finish");
}

InputDecoration textFieldInputDecoration({String? labelText, String? hintText}) {
  return InputDecoration(
    //enabledBorder: OutlineInputBorder(),
    border: const OutlineInputBorder(),
    labelText: labelText,
    hintText: hintText,
  );
}

InputDecoration getInputDecoration(context, String labelText, String hintText) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: getCurrentCalcThemeMode(context) == ThemeMode.light
                ? Theme.of(context).textTheme.bodySmall!.color!
                : Colors.grey,
            width: 1.0)),
    border: const OutlineInputBorder(),
    labelText: labelText,
    //  labelStyle: TextStyle(color: Colors.white54),
    hintText: hintText,
    //    hintStyle: TextStyle(color: Colors.white54)
  );
}

double getKeyboardHeight(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}

BoxDecoration getBoxDecoration(context) {
  return BoxDecoration(borderRadius: BorderRadius.circular(20));
}

ShapeBorder getBorderShape([double borderRadius = 20]) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius));
}

///per ora testato soltanto con FloatingActionButton
Future tapTargetWithEffect(GlobalKey target,
    {Duration duration = const Duration(milliseconds: 1000)}) async {
  if (target.currentContext != null) {
    return tapTargetContextWithEffect(target.currentContext!,
        duration: duration);
  }
}

///per ora testato soltanto con FloatingActionButton
Future tapTargetContextWithEffect(BuildContext target,
    {Duration duration = const Duration(milliseconds: 1000)}) async {
  final RenderBox renderBox = target.findRenderObject() as RenderBox;

  final child = renderBox as RenderProxyBox;
  //if (child. ?? false) {
  final size = renderBox.size;
  final center = renderBox.localToGlobal(size.center(Offset.zero));
  final hitResult = BoxHitTestResult();
  child.hitTest(hitResult, position: size.center(Offset.zero));
  final pointerDown = PointerDownEvent(
    position: center,
  );
  final tappableL = hitResult.path
      .where((element) => element.target is RenderSemanticsGestureHandler)
      .map((element) => element.target as RenderSemanticsGestureHandler)
      .toList();
  final clickableL = hitResult.path
      .where((element) => element.target is RenderPointerListener)
      .map((e) => e.target as RenderPointerListener)
      .toList();

  if (tappableL.isEmpty) {
    debugPrint('No RenderSemanticsGestureHandler available');
    //return;
  } else {
    final tappable = tappableL.first;
    tappable.onTap?.call();
  }

  if (clickableL.isEmpty) {
    debugPrint('No RenderPointerListener available');
    //return;
  } else {
    final clickable = clickableL.first;
    clickable.onPointerDown?.call(pointerDown);
  }

  // cancel the pointer down event
  await Future.delayed(duration).then((value) {
    debugPrint('Cancelling the pointer down event');
    final result = BoxHitTestResult();
    WidgetsBinding.instance.hitTest(result, Offset.zero);
    WidgetsBinding.instance.dispatchEvent(const PointerMoveEvent(), result);
  });
  //}
}
Future<String?> exitScreen(BuildContext context) async {
  String? result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return MessageDialog(
          title: 'Modifiche non salvate',
          message: 'Salvare le modifiche prima di uscire?',
          type: MessageDialogType.yesNoCancel,
          yesText: 'SALVA',
          noText: 'NON SALVARE',
          cancelText: 'ANNULLA',
          okPressed: () {
            Navigator.pop(context, "0");
          },
          noPressed: () {
            Navigator.pop(context, "1");
          },
          cancelPressed: () {
            Navigator.pop(context, "2");
          });
    },
  ).then((value) async {
    return value;
//return value
  });
  return result;
}

Stack getStrokedText(String text,
    {Color? textColor,
    Color? strokeColor,
    TextAlign? textAlign,
    double? fontSize,
    double? letterSpacing,
    FontWeight? fontWeight,
    int? maxLines,
    bool? softWrap,
    TextOverflow? overflow,
    Alignment alignment = Alignment.topLeft,
    double strokeWidth = 1}) {
  return Stack(alignment: alignment, children: [
    Text(
      text,
      overflow: overflow ?? TextOverflow.ellipsis,
      softWrap: softWrap,
      textAlign: textAlign,
      maxLines: maxLines ?? 3,
      style: _textStyleStandardStroke(
        strokeColor ??
            Theme.of(navigationScreenKey!.currentState!.context)
                .colorScheme
                .primary
                .withAlpha(200),
        strokeWidth: strokeWidth,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
      ),
    ),
    Text(text,
        textAlign: textAlign,
        overflow: overflow ?? TextOverflow.ellipsis,
        maxLines: maxLines ?? 3,
        softWrap: softWrap,
        style: _textStyleStandard(
            textColor ??
                (isDarkTheme(navigatorKey!.currentContext!)
                    ? Colors.white
                    : Colors.black),
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight)),
  ]);
}

TextStyle _textStyleStandard(Color? textColor,
    {double? fontSize, double? letterSpacing, FontWeight? fontWeight}) {
  return TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      color: textColor ??
          (isDarkTheme(navigatorKey!.currentContext!)
              ? Colors.white
              : Colors.black)
    //color: tagColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
  );
}

TextStyle _textStyleStandardStroke(Color textColor,
    {double? fontSize,
      double? letterSpacing,
      FontWeight? fontWeight,
      double strokeWidth = 1}) {
  return TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = textColor);
}

void scrollAndTapEffect({ScrollController? scrollController,
  required GlobalKey target,
  int durationMilliseconds = 250,
  Curve curve = Curves.easeOut,
  bool tap = true}) async {
  ///esegue lo scroll solo se gli viene passato un controller e currentContext del target non è null
  if (target.currentContext != null) {
    await scrollController?.position.ensureVisible(
      target.currentContext!.findRenderObject()!,
      duration: Duration(milliseconds: durationMilliseconds),
      curve: curve,
    );
  }
  if (tap) {
    await tapTargetWithEffect(target);
  }
}

Color? standardOkButtonBackgroundColor(BuildContext context) {
  return isDarkTheme(context)
      ? Theme.of(context).primaryColorDark
      : Colors.white;
}

Color? standardOkButtonTextColor(BuildContext context) {
  return isDarkTheme(context)
      ? Theme.of(context).primaryTextTheme.bodyLarge?.color
      : getMenuColor(Theme.of(context).primaryColor.value.toString());
}

Color? standardNoButtonBackgroundColor(BuildContext context) {
  return isDarkTheme(context) ? Colors.red.darken(0.3) : Colors.white;
}

Color? standardNoButtonTextColor(BuildContext context) {
  return isDarkTheme(context) ? Colors.white : Colors.red;
}

Color? standardYesButtonBackgroundColor(BuildContext context) {
  return isDarkTheme(context) ? Colors.green.darken(0.2) : Colors.white;
}

Color? standardYesButtonTextColor(BuildContext context) {
  return isDarkTheme(context) ? Colors.white : Colors.green;
}

Color? standardCustomButtonBackgroundColor(BuildContext context) {
  return isDarkTheme(context)
      ? Theme.of(context).primaryColorDark
      : Colors.white;
}

Color? standardCustomButtonTextColor(BuildContext context) {
  return isDarkTheme(context)
      ? Theme.of(context).primaryTextTheme.bodyLarge?.color
      : getMenuColor(Theme.of(context).primaryColor.value.toString());
}

Future<ui.Image> getUiImage(
    String imageAssetPath, int height, int width) async {
  final completer = Completer<ui.Image>();
  final byteData = await rootBundle.load(imageAssetPath);
  ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
  return completer.future;
}

Widget pacman({Color? color, double? size}) {
  return Center(
    child: SizedBox(
      height: size ?? 100,
      width: size ?? 100,
      child: LoadingIndicator(
        indicatorType: Indicator.pacman,

        /// Required, The loading type of the widget
        colors: [
          color ?? Colors.yellow,
          Colors.red,
          Colors.blue,
        ],

        /// Optional, The color collections
        strokeWidth: 2,

        /// Optional, The stroke of the line, only applicable to widget which contains line
      ),
    ),
  );
}

Future showPusher(BuildContext context, Widget pusher) async {
  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return multiDialog(content: pusher);
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}

Widget getHeroTitle(String title, String tag, TextStyle? textStyle) {
  return Hero(
      tag: tag,
      child: Material(
          type: MaterialType.transparency,
          child: Text(title, style: textStyle)));
}

Future<Color?> selectColorPicker(
    {required BuildContext context,
    int currentColor = 0,
    void Function(Color value)? onChanged}) async {
  // raise the [showDialog] widget
  int? result = await showDialog(
    context: context,
    builder: (context) {
      return multiDialog(
        title: const Text('Seleziona un colore'),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: Color(currentColor),
            portraitOnly: true,
            enableLabel: false,
            onPrimaryChanged: (color) {
              currentColor = color.value;
              onChanged?.call(color);
            },
            onColorChanged: (color) {
              currentColor = color.value;
              onChanged?.call(color);
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Seleziona'),
            onPressed: () {
              Navigator.of(context).pop(currentColor);
            },
          ),
        ],
      );
    },
  );
  return result != null ? Color(result) : null;
}

Color getScaffoldBackgroundColor(BuildContext context) {
  return isDarkTheme(context)
      ? Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(230),
          Theme.of(context).colorScheme.primary)
      : Color.alphaBlend(
          Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
          Theme.of(context).colorScheme.primary);
}

Future<List<Machine>?> downloadMachine(
    BuildContext context, String matricola) async {
  var result = await showPusher(
      context,
      MultiBlocProvider(
          providers: [
            BlocProvider<ServerDataBloc<Machine>>(
              lazy: false,
              create: (context) => ServerDataBloc<Machine>(
                  repo: MultiService(Machine.fromJsonModel,
                      apiName: 'VMMachine')),
            ),
          ],
          child: Pusher(
              command: (BuildContext context) {
                var bloc = BlocProvider.of<ServerDataBloc<Machine>>(context);
                bloc.add(ServerDataEvent<Machine>(
                    status: ServerDataEvents.fetch,
                    queryModel:
                        QueryModel(id: matricola, downloadContent: true)));
              },
              child: _machineDownloader())));
  return result;
}

Widget _machineDownloader() {
  return BlocListener<ServerDataBloc<Machine>, ServerDataState>(
      listener: (BuildContext context, ServerDataState state) {
    if (state.event is ServerDataLoaded) {
      Navigator.pop(context, state.event?.items);
    }
  }, child: BlocBuilder<ServerDataBloc<Machine>, ServerDataState>(
          builder: (BuildContext context, ServerDataState state) {
    if (state is ServerDataLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pop(context, state.items);
      });
      // return const Text("OK!");
    }
    return Container(
      constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            pacman(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 16,
            ),
            if (state is ServerDataLoading)
              const Text("Download macchina in corso..."),
            if (state is ServerDataLoadingSendProgress)
              Text(
                  "Richiesta ${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)}..."),
            if (state is ServerDataLoadingReceiveProgress)
              Text(
                  "Ricezione ${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)}..."),
            const SizedBox(
              height: 16,
            ),
            /* OkCancel(onCancel: (){
                if (mounted) {
                  Navigator.of(context).maybePop(null);
                }

              },)*/
          ],
        ),
      ),
    );
  }));
}

Future<List<Report>?> downloadReport(BuildContext context, int reportId) async {
  var result = await showPusher(
      context,
      MultiBlocProvider(
          providers: [
            BlocProvider<ServerDataBloc<Report>>(
              lazy: false,
              create: (context) => ServerDataBloc<Report>(
                  repo: MultiService(Report.fromJsonModel, apiName: 'Report')),
            ),
          ],
          child: Pusher(
              command: (BuildContext context) {
                var bloc = BlocProvider.of<ServerDataBloc<Report>>(context);
                bloc.add(ServerDataEvent<Report>(
                    status: ServerDataEvents.fetch,
                    queryModel: QueryModel(
                        id: reportId.toString(), downloadContent: true)));
              },
              child: _reportDownloader())));
  return result;
}

Widget _reportDownloader() {
  return BlocListener<ServerDataBloc<Report>, ServerDataState>(
      listener: (BuildContext context, ServerDataState state) {
    if (state.event is ServerDataLoaded) {
      Navigator.pop(context, state.event?.items);
    }
  }, child: BlocBuilder<ServerDataBloc<Report>, ServerDataState>(
          builder: (BuildContext context, ServerDataState state) {
    if (state is ServerDataLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pop(context, state.items);
      });
      // return const Text("OK!");
    }
    return Container(
      constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            pacman(
              color: Theme.of(context).colorScheme.primary,
            ),
                const SizedBox(
                  height: 16,
                ),
                if (state is ServerDataLoading)
                  const Text("Download macchina in corso..."),
                if (state is ServerDataLoadingSendProgress)
                  Text(
                      "Richiesta ${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)}..."),
                if (state is ServerDataLoadingReceiveProgress)
                  Text(
                      "Ricezione ${formatBytes(state.sent, 2)}/${formatBytes(state.total, 2)}..."),
                const SizedBox(
                  height: 16,
                ),
                /* OkCancel(onCancel: (){
                if (mounted) {
                  Navigator.of(context).maybePop(null);
                }

              },)*/
              ],
            ),
          ),
        );
      }));
}

Future<ScanResult> scanCodeWithCameraMobile() async {
  var result = await BarcodeScanner.scan();
  if (result.type != ResultType.Cancelled) {
    //player?.play(AssetSource("audio/beep_08b.mp3"));
    /*setState(() {
      barcodeController.value =
          barcodeController.value.copyWith(text: result.rawContent);
    });*/
    debugPrint(
        result.type.toString()); // The result type (barcode, cancelled, failed)
    debugPrint(result.rawContent); // The barcode content
    debugPrint(result.format.toString()); // The barcode format (as enum)
    debugPrint(result.formatNote); //
  } else {
    //player?.play(AssetSource("audio/se_non_bestemmio.mp3"));
    debugPrint("scan cancelled");
  }
  return result;
}
