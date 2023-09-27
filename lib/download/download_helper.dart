import 'package:dio/dio.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

final String _updateUri = "https://${MultiService.baseUrl}/api/CheckVersion/";

void downloadFile(String url) {
  if (isWindowsBrowser || isWindows || isLinux || isLinuxBrowser) {
    url += 'GetDataWin';
  } else if (isAndroidMobile) {
    url += 'GetData';
  }
  html.AnchorElement anchorElement = html.AnchorElement(href: url);
  anchorElement.download = url;
  anchorElement.click();
}

Future<void> downloadUpdate(ProgressCallback? onReceiveProgress) async {
  if (isAndroidMobile) {
    if (kDebugMode) {
      print("Browser Android");
    }
    downloadFile(_updateUri);
  } else if (isWindowsBrowser) {
    if (kDebugMode) {
      print("Browser Windows");
    }
    downloadFile(_updateUri);
  } else if (isIOSMobile) {
    if (kDebugMode) {
      print("Browser iOS");
    }
  } else if (isAndroid) {
    if (kDebugMode) {
      print("Android Platform");
    }
    var dir = await getExternalStorageDirectory();

    var path = "${dir!.path}/downloads/dpicenter.apk";
    if (kDebugMode) {
      print("Dir download: $path");
    }
    Dio dio = Dio();
    /*await dio.download(_UPDATEURI, path, onReceiveProgress: (rec, total){
      try {
        print(((rec/total) * 100).toStringAsFixed(0) + "%");
      } catch (e) {
        print(e);
      }
    } );*/

    await dio.download(_updateUri, path, onReceiveProgress: onReceiveProgress);
  } else if (isWindows || isLinux) {
    if (kDebugMode) {
      print("Windows Browser");
    }
    var dir = await getTemporaryDirectory();

    //var dir = await getExternalStorageDirectory();

    var path = "${dir.path}\\downloads\\dpicenter.msix";
    if (kDebugMode) {
      print("Dir download: $path");
    }
    Dio dio = Dio();
    /*await dio.download(_UPDATEURI, path, onReceiveProgress: (rec, total){
      try {
        print(((rec/total) * 100).toStringAsFixed(0) + "%");
      } catch (e) {
        print(e);
      }
    } );*/
    String url = '${_updateUri}GetDataWin';

    await dio.download(url, path, onReceiveProgress: onReceiveProgress);
  } else if (isWindowsBrowser) {
    if (kDebugMode) {
      print("Windows Browser");
    }
    //tutti gli altri
    downloadFile(_updateUri);
  }
}

Future<DownloadResult> downloadUpdateWithResult(
    ProgressCallback? onReceiveProgress) async {
  if (isAndroidMobile) {
    if (kDebugMode) {
      print("Browser Android");
    }
    downloadFile(_updateUri);
  } else if (isIOSMobile) {
    if (kDebugMode) {
      print("Browser iOS");
    }
  } else if (isAndroid) {
    if (kDebugMode) {
      print("Android Platform");
    }
    var dir = await getExternalStorageDirectory();

    var path = "${dir!.path}/downloads/dpicenter.apk";
    if (kDebugMode) {
      print("Dir download: $path");
    }
    Dio dio = Dio();
    /*await dio.download(_UPDATEURI, path, onReceiveProgress: (rec, total){
      try {
        print(((rec/total) * 100).toStringAsFixed(0) + "%");
      } catch (e) {
        print(e);
      }
    } );*/
    var result = await dio.download(_updateUri, path,
        onReceiveProgress: onReceiveProgress);
    if (result.statusCode == 200) {
      return DownloadResult(ok: true, path: path, response: result);
    } else {
      return DownloadResult(ok: false, path: path, response: result);
    }
  } else if (isWindowsBrowser) {
    if (kDebugMode) {
      print("Windows Browser");
    }
    //tutti gli altri
    downloadFile(_updateUri);
  } else if (isWindows) {
    if (kDebugMode) {
      print("Windows Browser");
    }
    var dir = await getTemporaryDirectory();

    //var dir = await getExternalStorageDirectory();

    var path = "${dir.path}\\downloads\\dpicenter.msix";
    if (kDebugMode) {
      print("Dir download: $path");
    }
    Dio dio = Dio();
    /*await dio.download(_UPDATEURI, path, onReceiveProgress: (rec, total){
      try {
        print(((rec/total) * 100).toStringAsFixed(0) + "%");
      } catch (e) {
        print(e);
      }
    } );*/
    String url = '${_updateUri}GetDataWin';
    var result =
        await dio.download(url, path, onReceiveProgress: onReceiveProgress);

    if (result.statusCode == 200) {
      return DownloadResult(ok: true, path: path, response: result);
    } else {
      return DownloadResult(ok: false, path: path, response: result);
    }
  }
  return DownloadResult(ok: false, path: '', response: null);
}
