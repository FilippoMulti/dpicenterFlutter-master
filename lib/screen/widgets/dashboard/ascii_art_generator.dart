import 'package:enough_ascii_art/enough_ascii_art.dart' as art;

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String fontName) async {
  return await rootBundle.loadString('assets/fonts/$fontName');
}

Future<String> renderText(String fontName, String text) async {
  /*final bytes = await File('./example/enough.jpg').readAsBytes();
  final image = img.decodeImage(bytes)!;
  var asciiImage = art.convertImage(image, maxWidth: 40, invert: true);
  print('');
  print(asciiImage);
*/

  /*var helloWithUtf8Smileys = 'hello world 😛';
  var helloWithTextSmileys =
  art.convertEmoticons(helloWithUtf8Smileys, art.EmoticonStyle.western);
  print('');
  print(helloWithTextSmileys);
  print('');
*/
  /*print('cosmic:');*/
  var fontText = await loadAsset(fontName);
  var figure = art.renderFiglet(text, art.Font.text(fontText));
  //print(figure);
  //print('---');

  return figure;
  /*var unicode = art.renderUnicode('hello world', art.UnicodeFont.doublestruck);
  print('double struck:');
  print(unicode);*/
}

String renderTextWithFont(String font, String text) {
  /*final bytes = await File('./example/enough.jpg').readAsBytes();
  final image = img.decodeImage(bytes)!;
  var asciiImage = art.convertImage(image, maxWidth: 40, invert: true);
  print('');
  print(asciiImage);
*/

  /*var helloWithUtf8Smileys = 'hello world 😛';
  var helloWithTextSmileys =
  art.convertEmoticons(helloWithUtf8Smileys, art.EmoticonStyle.western);
  print('');
  print(helloWithTextSmileys);
  print('');
*/
  /*print('cosmic:');*/
  var figure = art.renderFiglet(text, art.Font.text(font));
  //print(figure);
  //print('---');
  return figure;
  /*var unicode = art.renderUnicode('hello world', art.UnicodeFont.doublestruck);
  print('double struck:');
  print(unicode);*/
}
