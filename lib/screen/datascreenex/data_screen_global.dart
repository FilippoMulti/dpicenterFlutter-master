import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerComboLoading(BuildContext context,
    {double height = 50,
    double? width,
    double borderRadius = 4,
    EdgeInsets padding =
        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
    Widget? child,
    Color? baseColor,
    Color? highlightColor}) {
  var mq = MediaQuery.of(context);
  return Padding(
      padding: padding,
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: baseColor ??
                (isDarkTheme(context)
                    ? Color.alphaBlend(Colors.grey.shade700.withAlpha(240),
                        Theme.of(context).colorScheme.primary)
                    : Color.alphaBlend(Colors.grey.shade300.withAlpha(240),
                        Theme.of(context).colorScheme.primary)),
            highlightColor: highlightColor ??
                (isDarkTheme(context)
                    ? Color.alphaBlend(Colors.grey.shade800.withAlpha(240),
                        Theme.of(context).colorScheme.primary)
                    : Color.alphaBlend(Colors.grey.shade100.withAlpha(240),
                        Theme.of(context).colorScheme.primary)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      /*border: Border.all(
                      color: Colors.grey,
                    ),*/
                      borderRadius: BorderRadius.circular(borderRadius)),
                  height: height,
                  width: width,
                  child: child),
            ),
          ),
        ],
      ));
}

Widget shimmerCondensedComboLoading(BuildContext context,
    {double height = 50,
    double? width,
    EdgeInsets padding =
        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
    Widget? child}) {
  var mq = MediaQuery.of(context);
  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
        padding: padding,
        child: Shimmer.fromColors(
          baseColor: isDarkTheme(context)
              ? Color.alphaBlend(Colors.grey.shade700.withAlpha(240),
                  Theme.of(context).colorScheme.primary)
              : Color.alphaBlend(Colors.grey.shade300.withAlpha(240),
                  Theme.of(context).colorScheme.primary),
          highlightColor: isDarkTheme(context)
              ? Color.alphaBlend(Colors.grey.shade800.withAlpha(240),
                  Theme.of(context).colorScheme.primary)
              : Color.alphaBlend(Colors.grey.shade100.withAlpha(240),
                  Theme.of(context).colorScheme.primary),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    /*border: Border.all(
                    color: Colors.grey,
                  ),*/
                    borderRadius: BorderRadius.circular(4)),
                height: height,
                width: width,
                child: child),
          ),
        )),
  );
}

Widget shimmerListLoading(BuildContext context) {
  var mq = MediaQuery.of(context);
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: isDarkTheme(context)
            ? Color.alphaBlend(Colors.grey.shade700.withAlpha(240),
                Theme.of(context).colorScheme.primary)
            : Color.alphaBlend(Colors.grey.shade300.withAlpha(240),
                Theme.of(context).colorScheme.primary),
        highlightColor: isDarkTheme(context)
            ? Color.alphaBlend(Colors.grey.shade800.withAlpha(240),
                Theme.of(context).colorScheme.primary)
            : Color.alphaBlend(Colors.grey.shade100.withAlpha(240),
                Theme.of(context).colorScheme.primary),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.grey,
              /*border: Border.all(
                color: Colors.grey,
              ),*/
              borderRadius: BorderRadius.circular(4)),
          constraints:
              BoxConstraints(minWidth: mq.size.width - 32, minHeight: 300),
        ),
      ));
}

/*
Widget okCancel(BuildContext context, {VoidCallback? onCancel, VoidCallback? onSave}){
  return _okCancelContainer(context, onCancel, onSave);
}
Widget _okCancelContainer(context, onCancel, onSave) {
  MediaQueryData queryData = MediaQuery.of(context);
  return Material(
    elevation: 8,
    color: Theme.of(context).colorScheme.background,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(20),bottom: Radius.circular(2)),
    clipBehavior: Clip.antiAlias,
    type: MaterialType.card,
    child: AnimatedContainer(duration: const Duration(milliseconds: 250), decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(2)), border: Border.all(
        color: Theme.of(context).dividerColor, width: 0.1),
    ), clipBehavior: Clip.antiAlias, height: queryData.size.height<400 ? 35 : 50, child: _okCancel(onCancel, onSave)),
  );
}
Widget _okCancel(onCancel, onSave) {
  return Center(
    child: Wrap(
      spacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TextButton(
          onPressed: onCancel,
          child: const Text('ANNULLA'),
        ),
        ElevatedButton(
          onPressed: onSave,
          child: const Text(
            'SALVA',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}*/
Future<bool> onWillPop(formKey) async {
  var status = formKey.currentState?.editState ?? false;
  if (status) {
    //on edit
    if (formKey.currentContext != null) {
      String? result = await exitScreen(formKey.currentContext!);
      if (result != null) {
        switch (result) {
          case '0': //si
            formKey.currentState?.validateSave();
            break;
          case '1': //no
            if (formKey.currentContext != null) {
              Navigator.of(formKey.currentContext!).pop();
            }
            break;
          case '2': //annulla
            break;
        }
      }
    }
  }

  ///se editState è true blocco l'uscita
  return !status;
}
