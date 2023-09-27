import 'dart:convert';

import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser show parse;
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

class Wikiquote {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  String _baseUrl(String lang) => 'http://$lang.wikiquote.org/w/api.php';

  String _searchUrl(String lang, String search) =>
      '${_baseUrl(lang)}?format=json&action=query&list=search&continue=&srsearch=$search';

  String _pageUrl(String lang, String p) =>
      '${_baseUrl(lang)}?format=json&action=parse&prop=text|categories&disableeditsection&page=$p';

  String _mainPageUrl(String lang, String main) =>
      '${_baseUrl(lang)}?format=json&action=parse&prop=text&page=$main';

  String _randomUrl(String lang, int limit) =>
      '${_baseUrl(lang)}?format=json&action=query&list=random&rnnamespace=0&rnlimit=$limit';

  List<String> supportedLanguages() {
    return ['en', 'it'];
  }

  Future<Quote> quoteOfTheDay(String lang, String page) async {
    var url = _mainPageUrl(lang, page);
    var future = await http.get(Uri.parse(url));
    var body = json.decode(future.body);
    var parsed = (body['parse'] ?? const {});
    var text = (parsed['text'] ?? const {});
    var star = (text['*'] ?? '');
    String tag = 'main-page-qotd';

    if (lang == 'en') {
      tag = 'mf-qotd';
    }
    var element = parser.parse(star).getElementById(tag);

    if (element != null) {
      var html = [
        for (var e in element.querySelectorAll('table table table tr td'))
          e.text.replaceAll('~', '').replaceAll('\n', '')
      ];
      return Quote()
        ..quote = html[0]
        ..author = html[1];
    }
    return Quote()
      ..quote =
          'Tu non sei il tuo lavoro, non sei la quantità di soldi che hai in banca, non sei la macchina che guidi, né il contenuto del tuo portafogli, non sei i tuoi vestiti di marca. Sei la canticchiante e danzante merda del mondo!'
      ..author = 'Tyler Durden (Fight Club)';
  }

  Future<List<String>> search(String article, String lang) async {
    var url = _searchUrl(lang, article);
    var response = await http.get(Uri.parse(url));
    var body = (json.decode(response.body) ?? const {});
    var query = (body['query'] ?? const {});
    var search = (query['search'] ?? []);
    var content = [for (var e in search) e['title']?.toString() ?? ''];
    return content;
  }

  Future<List<Quote>> quotes(String title, String lang, int maxQuotes) async {
    var res = <Quote>[];
    try {
      String url = _pageUrl(lang, title);
      var response =
          await getUrl(url, null, withBearer: false, withSessionId: false);
      final result = await readResponse(response);
      //print(result);

      if (response.statusCode == 200) {
        return compute(parse, ParseQuoteArgs(text: result, author: title));
        //return fromJson(result);
      } else {
        throw Exception(MultiService.makeResponseErrorText(
            "Comando non riuscito: $url",
            response.statusCode,
            result,
            response.reasonPhrase));
      }
    } catch (e) {
      print(e);
    }
    /*var future = await http.get(Uri.parse(url));
      var body = json.decode(future.body);
      var parsed = (body['parse'] ?? const {});
      var text = (parsed['text'] ?? const {});
      var star = (text['*'] ?? '');

      int countColl=0;
      for (var element in parser.parse(star).querySelectorAll('ul li')){

            try {
              var author = result;

              if (!element.text.startsWith(" ") && element.classes.isEmpty) {

                      //print(element.text);
                      res.add(Quote(author: author, quote: element.text));

                    }
            } catch (e) {
              print(e);
            }
          }

*/
    return res;
  }

  List<Quote> parse(ParseQuoteArgs args) {
    List<Quote> result = <Quote>[];
    try {
      var body = json.decode(args.text);
      var parsed = (body['parse'] ?? const {});
      var text = (parsed['text'] ?? const {});
      var star = (text['*'] ?? '');

      for (var element in parser.parse(star).querySelectorAll('ul li')) {
        try {
          var author = args.author;
          if (!element.text.startsWith(" ") && element.classes.isEmpty) {
            //print(element.text);
            result.add(Quote(author: author, quote: element.text));
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List<String>> randomTitles(String lang, int maxTitles) async {
    var url = _randomUrl(lang, maxTitles);
    var response = await http.get(Uri.parse(url));
    var body = (json.decode(response.body) ?? const {});
    var query = (body['query'] ?? const {});
    var search = (query['random'] ?? []);
    var content = [for (var e in search) e['title']?.toString() ?? ''];
    return content;
  }

  Future<HttpClientResponse> getUrl(String url, dynamic parameter,
      {bool withSessionId = true, bool withBearer = true}) async {
    /// Controllo certificato annullato su Android
    final client = newUniversalHttpClient()
      ..badCertificateCallback = _certificateCheck;
    //client.badCertificateCallback = _certificateCheck;
    client.connectionTimeout = const Duration(seconds: 35);
    var request = await client.getUrl(Uri.parse(url));

    if (withBearer) {
      request.headers.add(HttpHeaders.authorizationHeader,
          "Bearer ${prefs!.getString('token') ?? ""}");
    }

    ///header custom che mi serve per identificare la sessione sul server
    ///ogni utente potrebbe essere connesso su pi dispositivi
    if (withSessionId) {
      request.headers
          .add('SessionId', (prefs!.getString(sessionIdSetting) ?? ""));
    }
    /*if (request is BrowserHttpClientRequest) {
        request.browserCredentialsMode = true;
      }*/
    //print(request.toString());

    return await request.close().timeout(const Duration(seconds: 30));
  }

  //leggo il body
  Future<String> readResponse(HttpClientResponse response) async {
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    return contents.toString();
  }
}

class Quote {
  String? author;
  String? quote;

  Quote({this.author, this.quote});
}

class ParseQuoteArgs {
  String text;
  String author;

  ParseQuoteArgs({this.text = "", this.author = ""});
}
