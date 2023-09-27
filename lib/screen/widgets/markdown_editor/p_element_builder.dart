import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/screen/widgets/markdown_editor/p_style.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class PElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return SizedBox(
        width: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .size
            .width,
        child: RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(navigatorKey!.currentContext!).style,
              children: element.children
                      ?.map((e) => TextSpan(
                            text: e.textContent,
                            style: Theme.of(navigatorKey!.currentContext!)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.red),
                          ))
                      .toList() ??
                  [const TextSpan(text: "")]),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          softWrap: true,
          overflow: TextOverflow.clip,
          textScaleFactor: 1.0,
          maxLines: null,
          strutStyle: StrutStyle.disabled,
        )
        /*HighlightView(
        // The original code to be highlighted
        element.textContent,

        // Specify language
        // It is recommended to give it a value for performance
        language: language,

        // Specify highlight theme
        // All available themes are listed in `themes` folder
        theme: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .platformBrightness ==
                Brightness.light
            ? pTheme
            : pTheme,

        // Specify padding
        padding: const EdgeInsets.all(8),

        // Specify text style
        textStyle: GoogleFonts.robotoMono(),
      ),*/
        );
  }
}
