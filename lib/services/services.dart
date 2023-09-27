import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dpicenter/download/download_helper.dart';
import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/application_profile.dart';
import 'package:dpicenter/models/server/application_user.dart';
import 'package:dpicenter/models/server/application_user_detail.dart';
import 'package:dpicenter/models/server/auth_response.dart';
import 'package:dpicenter/models/server/check_version_response.dart';
import 'package:dpicenter/models/server/customer.dart';
import 'package:dpicenter/models/server/data_event_log.dart';
import 'package:dpicenter/models/server/file_model.dart';
import 'package:dpicenter/models/server/hashtag.dart';
import 'package:dpicenter/models/server/intervention_cause.dart';
import 'package:dpicenter/models/server/issue_model.dart';
import 'package:dpicenter/models/server/login_model.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:dpicenter/models/server/print_response.dart';
import 'package:dpicenter/models/server/query_model.dart';
import 'package:dpicenter/models/server/report.dart';
import 'package:dpicenter/models/server/report_detail.dart';
import 'package:dpicenter/models/server/report_detail_image.dart';
import 'package:dpicenter/models/server/server_version.dart';
import 'package:dpicenter/models/server/vmc_configuration.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/services/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
/*import 'package:sembast/sembast.dart';*/
import 'package:universal_io/io.dart';

bool _certificateCheck(X509Certificate cert, String host, int port) => true;

List<T> parse<T>(ParseArgs args) {
  try {
    final items = jsonDecode(args.json!).cast<Map<String, dynamic>>();

    //debugPrint("items: items.lenght: ${items.lenght}");

    List<T> result = <T>[];
    for (var item in items) {
      try {
        result.add(args.fromJson!(item));
      } catch (e) {
        print("Errore parse $e");
      }
    }

    return result;
  } catch (e) {
    print(e);
  }
  return <T>[];
}

List<T> parseWithDio<T>(ParseArgs args) {
  try {
    final items = args.jsonList!;

    //debugPrint("items: items.lenght: ${items.lenght}");

    List<T> result = <T>[];
    for (var item in items) {
      try {
        result.add(args.fromJson!(item));
      } catch (e) {
        print("Errore parse $e");
      }
    }

    return result;
  } catch (e) {
    print(e);
  }
  return <T>[];
}

//#region CrudRepo<T>
abstract class CrudRepo<T> {
  Future<List<T>?> fetch({
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  });

  Future<List<T>?> add(
    T item, {
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  });

  Future<List<T>?> update(
    T item, {
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  });

  Future<bool?> delete(T item);

  Future<List<T>?> get(
    QueryModel item, {
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  });

  Future<bool?> deleteList(List<T>? items);

  Future<List<PrintResponse>?> printQuery({
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  });

  Future<List<PrintResponse>?> printThis(
    List<T>? items, {
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  });
}

//#endregion
//#region GetRepo<T>
abstract class GetRepo<T> {
  Future<List<T>?> fetch();
}

//#endregion
//#region BaseService
class ParseArgs {
  String? json = "";
  Function? fromJson;
  List<Map<String, dynamic>>? jsonList;

  ParseArgs({this.json, this.jsonList, this.fromJson});
}

/*class BaseService {
  static String baseUrl = '192.168.1.223:5031';

  Future<HttpClientResponse> postUrl(String url, dynamic parameter,
      {int connectionTimeout = -1, int closeConnectionTimeout = -1}) async {
    /// Controllo certificato annullato su Android
    final client = HttpClient()..badCertificateCallback = _certificateCheck;
    //client.badCertificateCallback = _certificateCheck;
    client.connectionTimeout = Duration(
        milliseconds: connectionTimeout == -1
            ? startConfig!.connectionTimeout ?? 5000
            : connectionTimeout);

    var request = await client.postUrl(Uri.https(baseUrl, url));

    request.headers.add("Content-Type", "application/json; charset=UTF-8");
    request.headers.add(HttpHeaders.authorizationHeader,
        "Bearer ${prefs!.getString('token') ?? ""}");

    ///header custom che mi serve per identificare la sessione sul server
    ///ogni utente potrebbe essere connesso su pi dispositivi
    request.headers
        .add('SessionId', (prefs!.getString(sessionIdSetting) ?? ""));
    request.headers.add('app_version',
        "${startConfig?.currentVersionString} (${startConfig?.currentVersion})");
    request.headers.add('current_os', currentOs());
    request.headers.add("current_device_info", currentDeviceName);
    */ /*if (request is BrowserHttpClientRequest) {
        request.browserCredentialsMode = true;
      }*/ /*
    //print(request.toString());
    if (parameter != null) {
      if (kDebugMode) {
        print(jsonEncode(parameter));
      }
      request.write(jsonEncode(parameter));
    }

    try {
      return await request.close().timeout(Duration(
          milliseconds: closeConnectionTimeout == -1
              ? startConfig!.requestCloseTimeout ?? 5000
              : closeConnectionTimeout));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<HttpClientResponse> getUrl(
    String url,
    dynamic parameter,
  ) async {
    /// Controllo certificato annullato su Android
    final client = HttpClient()..badCertificateCallback = _certificateCheck;
    //client.badCertificateCallback = _certificateCheck;
    client.connectionTimeout = const Duration(seconds: 5);
    var request = await client.getUrl(Uri.https(baseUrl, url));

    request.headers.add(HttpHeaders.authorizationHeader,
        "Bearer ${prefs!.getString('token') ?? ""}");

    ///header custom che mi serve per identificare la sessione sul server
    ///ogni utente potrebbe essere connesso su pi dispositivi
    request.headers
        .add('SessionId', (prefs!.getString(sessionIdSetting) ?? ""));
    request.headers.add('app_version',
        "${startConfig?.currentVersionString} (${startConfig?.currentVersion})");
    request.headers.add('current_os', currentOs());
    request.headers.add("current_device_info", currentDeviceName);
    */ /*if (request is BrowserHttpClientRequest) {
        request.browserCredentialsMode = true;
      }*/ /*
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

  static String makeResponseErrorText(String title, int statusCode, String body, String reasonPhrase) {
    return title +
        "\r\n" +
        'Response code: ' +
        statusCode.toString() +
        "\r\n" +
        'Response body: ' +
        body +
        "\r\n" +
        'Response reason: ' +
        reasonPhrase +
        "\r\n";
  }

  Future<bool>? executeCommand(String url, dynamic parameter) async {
    final response = await postUrl(url, parameter);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(BaseService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  Future<dynamic>? executeCommandAndGet(String url, dynamic parameter) async {
    final response = await postUrl(url, parameter);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception(BaseService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  Future<T>? executeCommandType<T>(
      String url, dynamic parameter, Function fromJson) async {
    final response = await postUrl(url, parameter);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return fromJson(result);
    } else {
      throw Exception(BaseService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }
  //jsonDecode(response.body) as Map<String, dynamic>

  Future<List<T>>? retrieveCommand<T>(
      String url, dynamic parameter, Function fromJson,
      {int connectionTimeout = -1, int closeConnectionTimeout = -1}) async {
    final response = await postUrl(url, parameter,
        connectionTimeout: connectionTimeout,
        closeConnectionTimeout: closeConnectionTimeout);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return compute(parse, ParseArgs(json: result, fromJson: fromJson));
    } else {
      throw Exception(BaseService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  Future<String>? getResponseCommand<T>(String url, dynamic parameter) async {
    final response = await postUrl(url, parameter);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception(BaseService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

*/ /* Future<dynamic>? retrieveBytes(String url, dynamic parameter) async {
    final response = await getUrl(url, parameter);
    //final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes2(response);
      return bytes;
    } else {
      throw Exception(BaseService.makeResponseErrorText(
          "Comando non riuscito: " + url,
          response.statusCode,
          response.toString(),
          response.reasonPhrase));
    }
  }*/ /*
}*/
//#endregion

//#region Helper
class HelperService extends MultiService {
  static const String _test = '/api/Helper/test/';
  static const String _createIssue = '/api/Helper/createIssue/';
  static const String _getVersion = '/api/Helper/get-version/';

  HelperService() : super(null, apiName: 'Helper');

  Future<bool?> test() async {
    try {
      return await executeCommand(_test, null);
    } catch (e) {
      //print("HelperService.test: " + e.toString());
    }
    return false;
  }

  Future<bool?> createIssue(IssueModel model) async {
    try {
      return await executeCommand(_createIssue, model);
    } catch (e) {
      //print("HelperService.test: " + e.toString());
    }
    return false;
  }

  Future<List<ServerVersion>?> getVersion() async {
    try {
      return await retrieveTypeCommand<ServerVersion>(
          _getVersion, null, ServerVersion.fromJsonModel);
    } catch (e) {
      //print("HelperService.test: " + e.toString());
    }
    return null;
  }
}

//#endregion
/*//#region TestGenerate
class TestGenerateService extends BaseService {
  static const String _test = '/api/Autogeneration/testgenerate/';

  Future<bool?> testgenerate() async {
    try {
      return await executeCommand(_test, null);
    } catch (e) {
      //print("HelperService.test: " + e.toString());
    }
    return false;
  }
}

//#endregion*/
//#region Search
class LocalSearchService extends MultiService {
  //static const String _get = '/api/ApplicationUserSetting/get/';
  LocalSearchService() : super(null, apiName: '');

  Future<List<Menu>?> loadMenus(BuildContext context) async {
    List<Menu>? result = <Menu>[];
    /*  var store = intMapStoreFactory.store(
        "dashboardMenus" + prefs!.getInt(ApplicationUserIdSetting).toString());
    var storeDashState = intMapStoreFactory.store(
        "dashState" + prefs!.getInt(ApplicationUserIdSetting).toString());
*/
    //store.delete(db!);

    ///carico menu standard

    baseMenu = Menu.load();
    result.add(baseMenu!);
    dashBoardMenu = baseMenu!.toDestinationAndCommands();

    /*bool? loadDashboard = prefs!.getBool(LoadDashboardSetting +
        prefs!.getInt(ApplicationUserIdSetting).toString());
    if (loadDashboard ?? false) {
      ///richiedo dashboard al database
      var records = await store.find(db!,
          finder: Finder(sortOrders: [SortOrder("sortOrder")]));
      var userMenuList = <UserMenu>[];
      records.forEach((element) {
        //print("userMenu: ${element.key} - ${element.value}");
        userMenuList.add(UserMenu.fromJson(element.value));
      });

      /// creo una dashboard vuota
      dashBoardMenu = Menu(context,
          text: 'DestinationAndCommands',
          subMenus: <Menu>[],
          id: Menu.DestinationAndCommandsId);
      dashBoardMenu!.subMenus!.clear();

      ///scorro la configurazione salvata selezionando l'id del menu salvato dai menu disponibili
      await Future.forEach<UserMenu>(userMenuList, (element) async {
        var menuFounded = await findMenuById(element.menuId!);
        if (menuFounded.length > 0) {
          */ /*print(
              "MenuId=${element.menuId} - sortOrder=${element.sortOrder} - Menu.Id=${menuFounded[0]!.id} - Menu.Text=${menuFounded[0]!.text}");*/ /*
          dashBoardMenu!.subMenus!.add(menuFounded[0]!);
        }
      });

      result.add(dashBoardMenu!);
    } else {
      //loadDashboard=false
      ///carico la dashboard di default
      dashBoardMenu = baseMenu!.toDestinationAndCommands();

      ///salvo la dashboard di default
      await saveDashboardMenu(dashBoardMenu!);

      ///imposto che la prossiva volta la dashboard venga caricata dal database
      prefs!.setBool(
          LoadDashboardSetting +
              prefs!.getInt(ApplicationUserIdSetting).toString(),
          true);

      result.add(dashBoardMenu!);
    }
*/
    return result;
  }

  Future<Menu?> loadFavorites(BuildContext context) async {
    return null;

    /*try {
      var store = intMapStoreFactory.store("dashboardMenus" +
          prefs!.getInt(ApplicationUserIdSetting).toString());
      var storeDashState = intMapStoreFactory.store(
          "dashState" + prefs!.getInt(ApplicationUserIdSetting).toString());

      //store.delete(db!);
      var state = await storeDashState.find(db!);
      if (state.length != 0 && state[0].value['state'] == 'true') {
        var records = await store.find(db!,
            finder: Finder(sortOrders: [SortOrder("sortOrder")]));
        var userMenuList = <UserMenu>[];
        records.forEach((element) {
          //print("userMenu: ${element.key} - ${element.value}");
          userMenuList.add(UserMenu.fromJson(element.value));
        });

        /// creo una dashboard vuota
        dashBoardMenu = Menu(context,
            text: 'DestinationAndCommands',
            subMenus: <Menu>[],
            id: Menu.destinationAndCommandsId);
        dashBoardMenu!.subMenus!.clear();

        ///scorro la configurazione salvata selezionando l'id del menu salvato dai menu disponibili
        await Future.forEach<UserMenu>(userMenuList, (element) async {
          var menuFounded = await findMenuById(element.menuId!);
          if (menuFounded.length > 0) {
            */ /*print(
                    "MenuId=${element.menuId} - sortOrder=${element.sortOrder} - Menu.Id=${menuFounded[0]!.id} - Menu.Text=${menuFounded[0]!.text}");*/ /*
            dashBoardMenu!.subMenus!.add(menuFounded[0]!);
          }
        });

        return dashBoardMenu;
      } else {
        ///carico la dashboard di default
        dashBoardMenu = Menu.load(context).toDestinationAndCommands();

        ///salvo la dashboard di default
        await saveDashboardMenu(dashBoardMenu!);

        ///imposto che la prossiva volta la dashboard venga caricata dal database
        try {
          storeDashState.record(1).put(db!, {'state': 'true'});
        } catch (e) {
          print(e);
        }

        return dashBoardMenu;
      }
    } catch (e) {
      print(e);
    }*/
  }

  static Future saveDashboardMenu(Menu menu) async {
    /*var store = intMapStoreFactory.store(
        "dashboardMenus" + prefs!.getInt(ApplicationUserIdSetting).toString());
    store.delete(db!);

    int applicationUserId = prefs!.getInt(ApplicationUserIdSetting) ?? -1;
    if (menu.subMenus != null) {
      int i = 0;
      await Future.forEach<Menu>(menu.subMenus!, (element) async {
        //print("sortOrder: $i - ${element.text}");
        UserMenu userMenu = UserMenu(
            applicationUserId: applicationUserId,
            menuId: element.id,
            sortOrder: i);
        i++;
        await store.record(element.id).put(db!, (userMenu).toJson());
      });
    }*/
  }

  Future<List<Menu?>> find(
      Menu thisMenu, String value, List<Menu>? result) async {
    try {
      result ??= <Menu>[];
      thisMenu.subMenus?.forEach((element) async {
        //[a-zA-Z]*[a-zA-Z]*
        RegExp regExp = RegExp(
          r"[a-zA-Z]*" + value + "[a-zA-Z]*",
          caseSensitive: false,
          multiLine: false,
        );
        if (regExp.hasMatch(element.label)) {
          result!.add(element);
        }
        /*if (element.text.toLowerCase().contains(value.toLowerCase())) {
          result!.add(element);
        }*/
        if (element.subMenus != null && element.subMenus!.isNotEmpty) {
          await find(element, value, result);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return result!;
  }

  Future<List<Menu?>> findId(
      Menu thisMenu, int value, List<Menu>? result) async {
    try {
      result ??= <Menu>[];
      thisMenu.subMenus?.forEach((element) async {
        if (element.menuId == value) {
          result!.add(element);
        }

        if (element.subMenus != null && element.subMenus!.isNotEmpty) {
          await findId(element, value, result);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return result!;
  }

  Future<List<Menu?>> findMenu(String value) async {
    try {
      return await find(baseMenu!, value, null);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return <Menu?>[];
  }

  Future<List<Menu?>> findMenuById(int id) async {
    try {
      return await findId(baseMenu!, id, null);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return <Menu?>[];
  }
}
//#endregion

//#region LoginServices
abstract class LoginRepo {
  Future<AuthResponse?> authenticate(String username, String password);
}

class LoginServices extends MultiService implements LoginRepo {
  //

  static const String _authenticate = '/api/ApplicationUser/authenticate/';

  LoginServices() : super(null, apiName: '');

  @override
  Future<AuthResponse?> authenticate(String username, String password) async {
    final client = newUniversalHttpClient()
      ..badCertificateCallback = _certificateCheck;

    //client.badCertificateCallback = _certificateCheck;
    LoginModel loginModel = LoginModel(userName: username, password: password);

    var request =
        await client.postUrl(Uri.https(MultiService.baseUrl, _authenticate));

    request.headers.add("Content-Type", "application/json; charset=UTF-8");

    ///header custom che mi serve per identificare la sessione sul server
    ///ogni utente potrebbe essere connesso su pi dispositivi
    request.headers
        .add('SessionId', (prefs!.getString(sessionIdSetting) ?? ""));
    /* request.headers
          .add(HttpHeaders.authorizationHeader, "Bearer " + authToken);*/

    /*   if (request is BrowserHttpClientRequest) {
        request.browserCredentialsMode = true;
      }*/
    //print(request.toString());
    request.write(jsonEncode(loginModel));

    final response = await request.close();
    final result = await readResponse(response);

    if (response.statusCode == 200) {
      return compute(parseOne, result);
    } else {
      throw LoginException(MultiService.makeResponseErrorText(
          "Failed to authenticate",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  static AuthResponse parseOne(String responseBody) {
    final parsed = jsonDecode(responseBody);
    //final user = parsed['user'];
    //print(user);

    // final parsed = jsonDecode(responseBody).cast<Map<String, String>>();
    return AuthResponse.fromJsonString(parsed);
    //return parsed.map<AuthResponse>((json) => AuthResponse.fromJson(json));
  }
}
//#endregion

//#region CheckVersionServices
abstract class CheckVersionRepo {
  Future<List<CheckVersionResponse>?> checkVersion();

  Future<DownloadResult?> downloadNewVersion(
      ProgressCallback onReceiveProgress);

  Future<bool?> autoLogin();
}

class DownloadResult {
  final String path;
  final dynamic response;
  final bool ok;

  DownloadResult(
      {required this.ok, required this.path, required this.response});
}

class CheckVersionServices extends MultiService implements CheckVersionRepo {
  static const String _get = '/api/CheckVersion/checkversion/';
  static const String _test = '/api/Helper/test/';

  CheckVersionServices()
      : super(CheckVersionResponse.fromJsonModel, apiName: 'CheckVersion');

  @override
  Future<List<CheckVersionResponse>?> checkVersion() async {
    List<CheckVersionResponse>? result;

    result = (await retrieveTypeCommand<CheckVersionResponse>(
        _get, null, CheckVersionResponse.fromJsonModel));

    return result;
  }

  @override
  Future<DownloadResult?> downloadNewVersion(
      ProgressCallback onReceiveProgress) {
    return downloadUpdateWithResult(onReceiveProgress);
  }

  @override
  Future<bool?> autoLogin() async {
    return await executeCommand(_test, null);
  }
}

//#endregion

/*//#region DataEventLogServices
class DataEventLogServices extends BaseService
    implements CrudRepo<DataEventLog> {
  static const String _get = '/api/DataEventLog/get/';
  static const String _add = '/api/DataEventLog/add/';
  static const String _update = '/api/DataEventLog/update/';
  static const String _delete = '/api/DataEventLog/delete-item/';
  static const String _deleteList = '/api/DataEventLog/delete-items/';

  @override
  Future<List<DataEventLog>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");
    return await retrieveCommand(_get, queryModel, DataEventLog.fromJsonModel);

    */
/*List<DataEventLog>? result;
    var store = intMapStoreFactory.store("dataeventlogs");

    try {
      result =
          await retrieveCommand(_get, queryModel, DataEventLog.fromJsonModel);

      if (result != null) {
        //salvo nel db
        result.forEach((element) {
          store.record(element.eventId!).put(db!, (element).toJson());
        });

        //print("saved");
      } else {
        //result = store.record("Manufacturers").get(db!) as List<Manufacturer>;

      }
    } catch (e) {
      print(e);

      var records = await store.find(db!);
      result = <DataEventLog>[];
      records.forEach((element) {
        result!.add(DataEventLog.fromJson(element.value));
      });

      throw FetchDataException([e, result]);
    }
    return result;
    //return await retrieveCommand(_get, queryModel, Manufacturer.fromJsonModel);*/
/*
  }

  @override
  Future<List<DataEventLog>?> add(DataEventLog item) async {
    return await retrieveCommand(_add, item, DataEventLog.fromJsonModel);
  }

  @override
  Future<bool?> delete(DataEventLog item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<DataEventLog>?> update(DataEventLog item) async {
    return await retrieveCommand(_update, item, DataEventLog.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<DataEventLog>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<PrintResponse>?> printQuery() {
    // TODO: implement printQuery
    throw UnimplementedError();
  }

  @override
  Future<List<PrintResponse>?> printThis(List<DataEventLog>? items) {
    // TODO: implement printThis
    throw UnimplementedError();
  }

  @override
  Future<List<DataEventLog>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, DataEventLog.fromJsonModel);
  }
}

//#endregion
//#region VmcConfigurationServices
class VmcConfigurationServices extends BaseService
    implements CrudRepo<VmcConfiguration> {
  static const String _get = '/api/VmcConfiguration/get/';
  static const String _add = '/api/VmcConfiguration/add/';
  static const String _update = '/api/VmcConfiguration/update/';
  static const String _delete = '/api/VmcConfiguration/delete-item/';
  static const String _deleteList = '/api/VmcConfiguration/delete-items/';

  @override
  Future<List<VmcConfiguration>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");
    return await retrieveCommand(
        _get, queryModel, VmcConfiguration.fromJsonModel);
  }

  @override
  Future<List<VmcConfiguration>?> add(VmcConfiguration item) async {
    return await retrieveCommand(_add, item, VmcConfiguration.fromJsonModel);
  }

  @override
  Future<bool?> delete(VmcConfiguration item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<VmcConfiguration>?> update(VmcConfiguration item) async {
    return await retrieveCommand(_update, item, VmcConfiguration.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<VmcConfiguration>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<PrintResponse>?> printQuery() {
    // TODO: implement printQuery
    throw UnimplementedError();
  }

  @override
  Future<List<PrintResponse>?> printThis(List<VmcConfiguration>? items) {
    // TODO: implement printThis
    throw UnimplementedError();
  }

  @override
  Future<List<VmcConfiguration>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, VmcConfiguration.fromJsonModel);
  }
}

//#endregion

//#region ManufacturerServices
class ManufacturerServices extends BaseService
    implements CrudRepo<Manufacturer> {
  static const String _get = '/api/Manufacturer/get/';
  static const String _add = '/api/Manufacturer/add/';
  static const String _update = '/api/Manufacturer/update/';
  static const String _delete = '/api/Manufacturer/delete-item/';
  static const String _deleteList = '/api/Manufacturer/delete-items/';
  static const String _printQuery = '/api/Manufacturer/print-query/';
  static const String _printThis = '/api/Manufacturer/print-this/';

  @override
  Future<List<Manufacturer>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");

    */
/* var store = intMapStoreFactory.store("manufacturers");
    await store.delete(db!);*/
/*
    return await retrieveCommand(_get, queryModel, Manufacturer.fromJsonModel);
    */
/*try {
      result =
          await retrieveCommand(_get, queryModel, Manufacturer.fromJsonModel);

      if (result != null) {
        //salvo nel db
        result.forEach((element) {
          store.record(element.manufacturerId!).put(db!, (element).toJson());
        });

        //print("saved");
      } else {
        //result = store.record("Manufacturers").get(db!) as List<Manufacturer>;

      }
    } catch (e) {
      print(e);

      var records = await store.find(db!);
      result = <Manufacturer>[];
      records.forEach((element) {
        result!.add(Manufacturer.fromJson(element.value));
      });

      throw FetchDataException([e, result]);
    }*/
/*

    //return await retrieveCommand(_get, queryModel, Manufacturer.fromJsonModel);
  }

  */
/*@override
  Future<bool?> add(Manufacturer item) async {
    return await executeCommand(_add, item);
  }*/
/*

  @override
  Future<List<Manufacturer>?> add(Manufacturer item) async {
    return await retrieveCommand(_add, item, Manufacturer.fromJsonModel);
  }

  @override
  Future<bool?> delete(Manufacturer item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<Manufacturer>?> update(Manufacturer item) async {
    return await retrieveCommand(_update, item, Manufacturer.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<Manufacturer>? items) async {
    return await executeCommand(_deleteList, items);
  }

  */
/* Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.pdf');
  }*/
/*

  @override
  Future<List<PrintResponse>?> printQuery() async {
    List<PrintResponse>? result;
    var query = QueryModel("0");

    result = await retrieveCommand(
        _printQuery, query, PrintResponse.fromJsonModel,
        connectionTimeout: 30000, closeConnectionTimeout: 30000);
*/
/*      File file = await _localFile;
      file.writeAsBytes(base64Decode(result![0].resultFile!));
      result[0].path=file.path;*/
/*

    return result;
  }

  @override
  Future<List<PrintResponse>?> printThis(List<Manufacturer>? items) async {
    return await retrieveCommand(_printThis, items, PrintResponse.fromJsonModel,
        connectionTimeout: 30000, closeConnectionTimeout: 30000);
  }

  @override
  Future<List<Manufacturer>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, Manufacturer.fromJsonModel);
  }
}

//#endregion*/

/*//#region CustomerServices

class CustomerServices extends BaseService implements CrudRepo<Customer> {
  //

  static const String _get = '/api/Customer/get/';
  static const String _printQuery = '/api/Customer/print-query/';
  static const String _printThis = '/api/Customer/print-this/';

  @override
  Future<List<Customer>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("");
    //return await retrieveCommand(_get, queryModel, Customer.fromJsonModel);
    return await retrieveCommand(_get, queryModel, Customer.fromJsonModel);
*/
/*    List<Customer>? result;
    var store = stringMapStoreFactory.store("customers");

    try {
      result = await retrieveCommand(_get, queryModel, Customer.fromJsonModel);

      if (result != null) {
        ///cancello i vecchi dati prima di inserirne dei nuovi
        store.delete(db!);

        //salvo nel db
        result.forEach((element) {
          store.record(element.customerId!).put(db!, (element).toJson());
        });

        //print("saved");
      } else {}
    } catch (e) {
      print(e);

      var records = await store.find(db!);
      result = <Customer>[];
      records.forEach((element) {
        result!.add(Customer.fromJson(element.value));
      });

      throw FetchDataException([e, result]);
    }
    return result;*/
/*
  }

  @override
  Future<List<Customer>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, Customer.fromJsonModel);
  }

  @override
  Future<List<Customer>?> add(Customer item) {
    throw UnsupportedError("Azione non supportata");
  }

  @override
  Future<bool?> delete(Customer item) {
    throw UnsupportedError("Azione non supportata");
  }

  @override
  Future<bool?> deleteList(List<Customer>? items) {
    throw UnsupportedError("Azione non supportata");
  }

  @override
  Future<List<Customer>?> update(Customer item) {
    throw UnsupportedError("Azione non supportata");
  }

  @override
  Future<List<PrintResponse>?> printQuery() async {
    var query = QueryModel("0");
    return await retrieveCommand(
        _printQuery, query, PrintResponse.fromJsonModel,
        connectionTimeout: 30000, closeConnectionTimeout: 30000);
  }

  @override
  Future<List<PrintResponse>?> printThis(List<Customer>? items) async {
    return await retrieveCommand(
        _printThis, items, PrintResponse.fromJsonModel,
        connectionTimeout: 30000, closeConnectionTimeout: 30000);
  }
}
//#endregion*/

/*//#region ApplicationUsers


class ApplicationUserServices extends MultiService<ApplicationUser>
    implements CrudRepo<ApplicationUser> {
  //

  static const String _get = '/api/ApplicationUser/get/';
  static const String _getImage = '/api/ApplicationUserDetail/get/';
  static const String _add = '/api/ApplicationUser/add/';
  static const String _update = '/api/ApplicationUser/update/';
  static const String _updateImage = '/api/ApplicationUserDetail/update/';
  static const String _delete = '/api/ApplicationUser/delete-item/';
  static const String _deleteList = '/api/ApplicationUser/delete-items/';

  ApplicationUserServices() : super(ApplicationUser.fromJsonModel, apiName: 'ApplicationUser');

  @override
  Future<List<ApplicationUser>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");
    return await retrieveCommand(
        _get, queryModel, ApplicationUser.fromJsonModel);
  }

  Future<List<ApplicationUserDetail>?> fetchImage(int id) async {
    QueryModel queryModel = QueryModel(id.toString());
    return await retrieveTypeCommand<ApplicationUserDetail>(
        _getImage, queryModel, ApplicationUserDetail.fromJsonModel);
  }

  @override
  Future<List<ApplicationUser>?> add(ApplicationUser item) async {
    //return await executeCommand(_add, item);
    return await retrieveCommand(_add, item, ApplicationUser.fromJsonModel);
  }

  @override
  Future<List<ApplicationUser>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, ApplicationUser.fromJsonModel);
  }

  @override
  Future<bool?> delete(ApplicationUser item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<ApplicationUser>?> update(ApplicationUser item) async {
    return await retrieveCommand(_update, item, ApplicationUser.fromJsonModel);
  }

  Future<bool?> updateImage(ApplicationUser item) async {
    return await executeCommand(_updateImage, item);
  }

  @override
  Future<bool?> deleteList(List<ApplicationUser>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<PrintResponse>?> printQuery() {
    // TODO: implement printQuery
    throw UnimplementedError();
  }

  @override
  Future<List<PrintResponse>?> printThis(List<ApplicationUser>? items) {
    // TODO: implement printThis
    throw UnimplementedError();
  }
}
//#endregion*/

/*//#region ApplicationProfiles

class ApplicationProfileServices extends BaseService
    implements CrudRepo<ApplicationProfile> {
  //

  static const String _get = '/api/ApplicationProfile/get/';
  static const String _add = '/api/ApplicationProfile/add/';
  static const String _update = '/api/ApplicationProfile/update/';
  static const String _delete = '/api/ApplicationProfile/delete-item/';
  static const String _deleteList = '/api/ApplicationProfile/delete-items/';

  @override
  Future<List<ApplicationProfile>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");
    return await retrieveCommand(
        _get, queryModel, ApplicationProfile.fromJsonModel);
  }

  @override
  Future<List<ApplicationProfile>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, ApplicationProfile.fromJsonModel);
  }

  @override
  Future<List<ApplicationProfile>?> add(ApplicationProfile item) async {
    return await retrieveCommand(_add, item, ApplicationProfile.fromJsonModel);
  }

  @override
  Future<bool?> delete(ApplicationProfile item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<ApplicationProfile>?> update(ApplicationProfile item) async {
    return await retrieveCommand(
        _update, item, ApplicationProfile.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<ApplicationProfile>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<PrintResponse>?> printQuery() {
    // TODO: implement printQuery
    throw UnimplementedError();
  }

  @override
  Future<List<PrintResponse>?> printThis(List<ApplicationProfile>? items) {
    // TODO: implement printThis
    throw UnimplementedError();
  }
}
//#endregion*/

/*//#region Machines

class MachineServices extends BaseService implements CrudRepo<Machine> {
  //

  static const String _get = '/api/VMMachine/get/';
  static const String _add = '/api/VMMachine/add/';
  static const String _update = '/api/VMMachine/update/';
  static const String _delete = '/api/VMMachine/delete-item/';
  static const String _deleteList = '/api/VMMachine/delete-items/';

  @override
  Future<List<Machine>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("");
    return await retrieveCommand(_get, queryModel, Machine.fromJsonModel);
  }

  @override
  Future<List<Machine>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, Machine.fromJsonModel);
  }

  @override
  Future<List<Machine>?> add(Machine item) async {
    return await retrieveCommand(_add, item, Machine.fromJsonModel);
  }

  @override
  Future<bool?> delete(Machine item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<Machine>?> update(Machine item) async {
    return await retrieveCommand(_update, item, Machine.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<Machine>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<PrintResponse>?> printQuery() {
    // TODO: implement printQuery
    throw UnimplementedError();
  }

  @override
  Future<List<PrintResponse>?> printThis(List<Machine>? items) {
    // TODO: implement printThis
    throw UnimplementedError();
  }
}
//#endregion

//#region InterventionCauses

class InterventionCauseServices extends BaseService
    implements CrudRepo<InterventionCause> {
  //

  static const String _get = '/api/InterventionCause/get/';
  static const String _add = '/api/InterventionCause/add/';
  static const String _update = '/api/InterventionCause/update/';
  static const String _delete = '/api/InterventionCause/delete-item/';
  static const String _deleteList = '/api/InterventionCause/delete-items/';
  static const String _printQuery = '/api/InterventionCause/print-query/';
  static const String _printThis = '/api/InterventionCause/print-this/';

  @override
  Future<List<InterventionCause>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");
    return await retrieveCommand(
        _get, queryModel, InterventionCause.fromJsonModel);
  }

  @override
  Future<List<InterventionCause>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, InterventionCause.fromJsonModel);
  }

  @override
  Future<List<InterventionCause>?> add(InterventionCause item) async {
    //return await executeCommand(_add, item);
    return await retrieveCommand(_add, item, InterventionCause.fromJsonModel);
  }

  @override
  Future<bool?> delete(InterventionCause item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<InterventionCause>?> update(InterventionCause item) async {
    return await retrieveCommand(
        _update, item, InterventionCause.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<InterventionCause>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<PrintResponse>?> printQuery() async {
    var query = QueryModel("0");
    return await retrieveCommand(
        _printQuery, query, PrintResponse.fromJsonModel,
        connectionTimeout: 30000, closeConnectionTimeout: 30000);
  }

  @override
  Future<List<PrintResponse>?> printThis(List<InterventionCause>? items) async {
    return await retrieveCommand(
        _printThis, items, PrintResponse.fromJsonModel,
        connectionTimeout: 30000, closeConnectionTimeout: 30000);
  }
}
//#endregion
//#region HashTagServices

class HashTagServices extends BaseService implements CrudRepo<HashTag> {
  //

  static const String _get = '/api/HashTag/get/';
  static const String _add = '/api/HashTag/add/';
  static const String _update = '/api/HashTag/update/';
  static const String _delete = '/api/HashTag/delete-item/';
  static const String _deleteList = '/api/HashTag/delete-items/';
  static const String _printQuery = '/api/HashTag/print-query/';
  static const String _printThis = '/api/HashTag/print-this/';

  @override
  Future<List<HashTag>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");
    return await retrieveCommand(_get, queryModel, HashTag.fromJsonModel);
  }

  @override
  Future<List<HashTag>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, HashTag.fromJsonModel);
  }

  @override
  Future<List<HashTag>?> add(HashTag item) async {
    //return await executeCommand(_add, item);
    return await retrieveCommand(_add, item, HashTag.fromJsonModel);
  }

  @override
  Future<bool?> delete(HashTag item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<HashTag>?> update(HashTag item) async {
    return await retrieveCommand(_update, item, HashTag.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<HashTag>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<PrintResponse>?> printQuery() async {
    var query = QueryModel("0");
    return await retrieveCommand(
        _printQuery, query, PrintResponse.fromJsonModel,
        connectionTimeout: 30000, closeConnectionTimeout: 30000);
  }

  @override
  Future<List<PrintResponse>?> printThis(List<HashTag>? items) async {
    return await retrieveCommand(
        _printThis, items, PrintResponse.fromJsonModel,
        connectionTimeout: 30000, closeConnectionTimeout: 30000);
  }
}

//#endregion
//#region ReportServices
class ReportServices extends BaseService implements CrudRepo<Report> {
  static const String _get = '/api/Report/get/';
  static const String _add = '/api/Report/add/';
  static const String _update = '/api/Report/update/';
  static const String _delete = '/api/Report/delete-item/';
  static const String _deleteList = '/api/Report/delete-items/';
  static const String _save = '/api/Report/save/';

  @override
  Future<List<Report>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("");
    return await retrieveCommand(_get, queryModel, Report.fromJsonModel);

    */
/*
    List<Report>? result;
    var store = intMapStoreFactory.store("reports");

    try {
      result = await retrieveComm and(_get, queryModel, Report.fromJsonModel);

      if (result != null) {
        //salvo nel db
        result.forEach((element) {
          store.record(element.reportId!).put(db!, (element).toJson());
        });

        //print("saved");
      } else {
        //result = store.record("Manufacturers").get(db!) as List<Manufacturer>;

      }
    } catch (e) {
      print(e);

      var records = await store.find(db!);
      result = <Report>[];
      records.forEach((element) {
        result!.add(Report.fromJson(element.value));
      });

      throw FetchDataException([e, result]);
    }
    return result;*/
/*
    //return await retrieveCommand(_get, queryModel, Manufacturer.fromJsonModel);
  }

  @override
  Future<List<Report>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, Report.fromJsonModel);
  }

  @override
  Future<List<Report>?> add(Report item) async {
//    return await executeCommand(_add, item);
    return await retrieveCommand(_add, item, Report.fromJsonModel);
  }

  @override
  Future<bool?> delete(Report item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<Report>?> update(Report item) async {
    return await retrieveCommand(_update, item, Report.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<Report>? items) async {
    return await executeCommand(_deleteList, items);
  }

  Future<bool?> save(Report item) async {
    return await executeCommand(_save, item);
  }

  @override
  Future<List<PrintResponse>?> printQuery() {
    // TODO: implement printQuery
    throw UnimplementedError();
  }

  @override
  Future<List<PrintResponse>?> printThis(List<Report>? items) {
    // TODO: implement printThis
    throw UnimplementedError();
  }
}

//#endregion

//#region ReportDetails

class ReportDetailServices extends BaseService
    implements CrudRepo<ReportDetail> {
  //

  static const String _get = '/api/ReportDetail/get/';
  static const String _add = '/api/ReportDetail/add/';
  static const String _update = '/api/ReportDetail/update/';
  static const String _delete = '/api/ReportDetail/delete-item/';
  static const String _deleteList = '/api/ReportDetail/delete-items/';

  @override
  Future<List<ReportDetail>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");
    return await retrieveCommand(_get, queryModel, ReportDetail.fromJsonModel);
  }

  @override
  Future<List<ReportDetail>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, ReportDetail.fromJsonModel);
  }

  @override
  Future<List<ReportDetail>?> add(ReportDetail item) async {
    return await retrieveCommand(_add, item, ReportDetail.fromJsonModel);
  }

  @override
  Future<bool?> delete(ReportDetail item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<List<ReportDetail>?> update(ReportDetail item) async {
    return await retrieveCommand(_update, item, ReportDetail.fromJsonModel);
  }

  @override
  Future<bool?> deleteList(List<ReportDetail>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<PrintResponse>?> printQuery() async {
    throw UnimplementedError();
  }

  @override
  Future<List<PrintResponse>?> printThis(List<ReportDetail>? items) async {
    throw UnimplementedError();
  }
}
//#endregion*/

//#region SyncServices

class SyncServices extends MultiService {
  static const String _syncCustomers = '/api/Sync/sync-customers/';
  static const String _syncMachines = '/api/Sync/sync-machines/';
  static const String _initMachinesHistory = '/api/Sync/init-machines-history/';

  SyncServices() : super(null, apiName: 'Sync');

  Future<dynamic> syncCustomers(FileModel model) async {
    return await executeCommandAndGet(_syncCustomers, model);
  }

  Future<bool?> syncMachines() async {
    return await executeCommand(_syncMachines, null);
  }

  Future<bool?> initMachinesHistory() async {
    return await executeCommand(_initMachinesHistory, null);
  }
}
//#endregion

/*//#region ImageServices
abstract class ImageServiceRepo {
  */
/*Future<List<CheckVersionResponse>?> checkVersion();

  Future<DownloadResult?> downloadNewVersion(
      ProgressCallback onReceiveProgress);

  Future<bool?> autoLogin();*/ /*
}

*/
/*
class DownloadResult {
  final String path;
  final dynamic response;
  final bool ok;

  DownloadResult(
      {required this.ok, required this.path, required this.response});
}
*/
/*

class ReportDetailImageService extends BaseService
    implements CrudRepo<ReportDetailImage> {
  static const String _get = '/api/ReportDetailImage/get/';
  static const String _add = '/api/ReportDetailImage/add/';
  static const String _update = '/api/ReportDetailImage/update/';
  static const String _delete = '/api/ReportDetailImage/delete-item/';
  static const String _deleteList = '/api/ReportDetailImage/delete-items/';

  @override
  Future<List<ReportDetailImage>?> add(ReportDetailImage item) async {
    //return await executeCommand(_add, item);
    return await retrieveCommand(_add, item, ReportDetailImage.fromJsonModel);
  }

  @override
  Future<List<ReportDetailImage>?> get(QueryModel item) async {
    return await retrieveCommand(_get, item, ReportDetailImage.fromJsonModel);
  }

  @override
  Future<bool?> delete(ReportDetailImage item) async {
    return await executeCommand(_delete, item);
  }

  @override
  Future<bool?> deleteList(List<ReportDetailImage>? items) async {
    return await executeCommand(_deleteList, items);
  }

  @override
  Future<List<ReportDetailImage>?> fetch({Function(int sent, int total)? onSendProgress,Function(int sent, int total)? onReceiveProgress,}) async {
    QueryModel queryModel = QueryModel("0");
    return await retrieveCommand(
        _get, queryModel, ReportDetailImage.fromJsonModel);
  }

  Future<List<ReportDetailImage>?> fetchReportDetailId(
      int reportDetailId) async {
    QueryModel queryModel = QueryModel(reportDetailId.toString());
    return await retrieveCommand(
        _get, queryModel, ReportDetailImage.fromJsonModel);
  }

  @override
  Future<List<ReportDetailImage>?> update(ReportDetailImage item) async {
    return await retrieveCommand(
        _update, item, ReportDetailImage.fromJsonModel);
  }

  @override
  Future<List<PrintResponse>?> printQuery() {
    // TODO: implement printQuery
    throw UnimplementedError();
  }

  @override
  Future<List<PrintResponse>?> printThis(List<ReportDetailImage>? items) {
    // TODO: implement printThis
    throw UnimplementedError();
  }
}
//#endregion*/

//#region MultiServiceEx
class MultiService<T extends JsonPayload> implements CrudRepo<T> {
  static const String _get = '/api/@name/get/';
  static const String _add = '/api/@name/add/';
  static const String _update = '/api/@name/update/';
  static const String _delete = '/api/@name/delete-item/';
  static const String _deleteList = '/api/@name/delete-items/';
  static const String _save = '/api/@name/save/';
  static const String _printQuery = '/api/@name/print-query/';
  static const String _printThis = '/api/@name/print-this/';

  static String baseUrl = '192.168.1.223:5031';

  String? apiName;
  dynamic instanceFunction;

  MultiService(dynamic instantiated, {required this.apiName}) {
    instanceFunction = instantiated;
  }

  Future<Response> postUrlWithDio(String url, dynamic parameter,
      {int connectionTimeout = -1,
      int closeConnectionTimeout = -1,
      Function(int sent, int total)? onSendProgress,
      Function(int sent, int total)? onReceiveProgress,
      Map<String, String>? headers}) async {
    Dio dio = Dio();
    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }
    try {
      dio.options.receiveTimeout = Duration(
          milliseconds: connectionTimeout == -1
              ? startConfig!.connectionTimeout ?? 5000
              : connectionTimeout);

      dio.options.connectTimeout = Duration(
          milliseconds: connectionTimeout == -1
              ? startConfig!.connectionTimeout ?? 5000
              : connectionTimeout);
      dio.options.receiveDataWhenStatusError = true;

      dio.options.headers['content-Type'] = "application/json";
      dio.options.headers['authorization'] =
          "Bearer ${prefs!.getString('token') ?? ""}";

      dio.options.headers['app_version'] =
          "${startConfig?.currentVersionString} (${startConfig?.currentVersion})";
      dio.options.headers['current_os'] = currentOs();
      dio.options.headers['current_device_info'] = currentDeviceName;

      if (headers != null) {
        headers.forEach((key, value) {
          dio.options.headers.addAll({key: value});
        });
      }

      dio.options.sendTimeout = const Duration(milliseconds: 360000);
      dio.options.receiveTimeout = const Duration(milliseconds: 360000);

      if (parameter != null && kDebugMode) {
        print(jsonEncode(parameter));
      }
      var response = await dio.post(
        Uri.https(MultiService.baseUrl, url).toString(),
        data: (parameter != null) ? jsonEncode(parameter) : null,
        onReceiveProgress: (int sent, int total) {
          //print("Ricezione: $sent/$total");
          onReceiveProgress?.call(sent, total);
        },
        onSendProgress: onSendProgress,
      );

      dio.close(force: true);
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<HttpClientResponse> postUrl(String url, dynamic parameter,
      {int connectionTimeout = -1,
      int closeConnectionTimeout = -1,
      Map<String, String>? headers}) async {
    /// Controllo certificato annullato su Android
    final client = newUniversalHttpClient()
      ..badCertificateCallback = _certificateCheck;
    //client.badCertificateCallback = _certificateCheck;
    client.connectionTimeout = Duration(
        milliseconds: connectionTimeout == -1
            ? startConfig!.connectionTimeout ?? 5000
            : connectionTimeout);

    var request = await client.postUrl(Uri.https(MultiService.baseUrl, url));

    request.headers.add("Content-Type", "application/json; charset=UTF-8");
    request.headers.add(HttpHeaders.authorizationHeader,
        "Bearer ${prefs!.getString('token') ?? ""}");
    if (headers != null) {
      try {
        headers.forEach((key, value) {
          request.headers.add(key, value);
        });
      } catch (e) {
        debugPrint("Headers Error --> $e");
      }
    }

    ///header custom che mi serve per identificare la sessione sul server
    ///ogni utente potrebbe essere connesso su pi dispositivi
    request.headers
        .add('SessionId', (prefs!.getString(sessionIdSetting) ?? ""));
    request.headers.add('app_version',
        "${startConfig?.currentVersionString} (${startConfig?.currentVersion})");
    request.headers.add('current_os', currentOs());
    request.headers.add("current_device_info", currentDeviceName);
    /*if (request is BrowserHttpClientRequest) {
        request.browserCredentialsMode = true;
      }*/
    //print(request.toString());
    if (parameter != null) {
      if (kDebugMode) {
        print(jsonEncode(parameter));
      }
      request.write(jsonEncode(parameter));
    }

    try {
      return await request.close().timeout(Duration(
          milliseconds: closeConnectionTimeout == -1
              ? startConfig!.requestCloseTimeout ?? 5000
              : closeConnectionTimeout));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<HttpClientResponse> getUrl(String url, dynamic parameter,
      {bool withSessionId = true, bool withBearer = true}) async {
    /// Controllo certificato annullato su Android
    final client = newUniversalHttpClient()
      ..badCertificateCallback = _certificateCheck;
    //client.badCertificateCallback = _certificateCheck;
    client.connectionTimeout = const Duration(seconds: 5);
    var request = await client.getUrl(Uri.https(MultiService.baseUrl, url));

    if (withBearer) {
      request.headers.add(HttpHeaders.authorizationHeader,
          "Bearer ${prefs!.getString('token') ?? ""}");
    }
    request.headers.add('app_version',
        "${startConfig?.currentVersionString} (${startConfig?.currentVersion})");
    request.headers.add('current_os', currentOs());
    request.headers.add("current_device_info", currentDeviceName);

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

  static String makeResponseErrorText(
      String title, int statusCode, String body, String reasonPhrase) {
    return "$title\r\n"
        "Response code: ${statusCode.toString()}\r\n"
        "Response body: $body\r\n"
        "Response reason: $reasonPhrase\r\n";
  }

  Future<bool>? executeCommand(String url, dynamic parameter) async {
    final response = await postUrl(url, parameter);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  Future<bool>? executeCommandWithDio(
      String url, dynamic parameter, onSendProgress, onReceiveProgress,
      {Map<String, String>? headers}) async {
    final response = await postUrlWithDio(url, parameter,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        headers: headers);

    //final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode ?? -1,
          response.data,
          response.statusMessage ?? ''));
    }
  }

  Future<T>? executeCommandType<TParam>(
      String url, dynamic parameter, Function fromJson) async {
    final response = await postUrl(url, parameter);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return fromJson(result);
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  //jsonDecode(response.body) as Map<String, dynamic>

  Future<List<T>>? retrieveCommand<TParam>(
      String url, dynamic parameter, Function fromJson,
      {int connectionTimeout = -1,
      int closeConnectionTimeout = -1,
      Map<String, String>? headers}) async {
    final response = await postUrl(url, parameter,
        connectionTimeout: connectionTimeout,
        closeConnectionTimeout: closeConnectionTimeout,
        headers: headers);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return compute(parse, ParseArgs(json: result, fromJson: fromJson));
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  Future<List<TParam>>? retrieveTypeCommand<TParam>(
      String url, dynamic parameter, Function fromJson,
      {int connectionTimeout = -1, int closeConnectionTimeout = -1}) async {
    final response = await postUrl(url, parameter,
        connectionTimeout: connectionTimeout,
        closeConnectionTimeout: closeConnectionTimeout);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return compute(parse, ParseArgs(json: result, fromJson: fromJson));
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  Future<List<TParam>>? retrieveTypeCommandWithDio<TParam>(
      String url, dynamic parameter, Function fromJson,
      {int connectionTimeout = -1,
      int closeConnectionTimeout = -1,
      Function(int sent, int total)? onSendProgress,
      Function(int sent, int total)? onReceiveProgress,
      Map<String, String>? headers}) async {
    final response = await postUrlWithDio(url, parameter,
        connectionTimeout: connectionTimeout,
        closeConnectionTimeout: closeConnectionTimeout,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        headers: headers);

    final result = (response.data as List).cast<Map<String, dynamic>>();
    //print(result);

    if (response.statusCode == 200) {
      return compute(
          parseWithDio, ParseArgs(jsonList: result, fromJson: fromJson));
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode ?? -1,
          response.data,
          response.statusMessage ?? ''));
    }
  }

  Future<List<T>>? retrieveCommandWithDio<TParam>(
      String url, dynamic parameter, Function fromJson,
      {int connectionTimeout = -1,
      int closeConnectionTimeout = -1,
      onSendProgress,
      onReceiveProgress,
      Map<String, String>? headers}) async {
    final response = await postUrlWithDio(url, parameter,
        connectionTimeout: connectionTimeout,
        closeConnectionTimeout: closeConnectionTimeout,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        headers: headers);
    final result = (response.data as List).cast<Map<String, dynamic>>();
    //print(result);

    if (response.statusCode == 200) {
      return compute(
          parseWithDio, ParseArgs(jsonList: result, fromJson: fromJson));
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode ?? -1,
          response.data,
          response.statusMessage ?? ''));
    }
  }

  Future<String>? getResponseCommand<TParam>(
      String url, dynamic parameter) async {
    final response = await postUrl(url, parameter);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }

  @override
  Future<List<T>?> fetch({
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  }) async {
    QueryModel queryModel = QueryModel(id: "");
    if (onSendProgress != null || onReceiveProgress != null) {
      return await retrieveCommandWithDio(
          _get.replaceFirst("@name", apiName ?? T.toString()),
          queryModel,
          instanceFunction,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
    } else {
      return await retrieveCommand(
          _get.replaceFirst("@name", apiName ?? T.toString()),
          queryModel,
          instanceFunction);
    }
  }

  @override
  Future<List<T>?> get(
    QueryModel item, {
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  }) async {
    if (onSendProgress != null || onReceiveProgress != null) {
      return await retrieveCommandWithDio(
          _get.replaceFirst("@name", apiName ?? T.toString()),
          item,
          instanceFunction,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
    } else {
      return await retrieveCommand(
          _get.replaceFirst("@name", apiName ?? T.toString()),
          item,
          instanceFunction);
    }
  }

  @override
  Future<List<T>?> add(
    T item, {
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  }) async {
//    return await executeCommand(_add, item);

    if (onSendProgress != null || onReceiveProgress != null) {
      return await retrieveCommandWithDio(
          _add.replaceFirst("@name", apiName ?? T.toString()),
          item,
          instanceFunction,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
    } else {
      return await retrieveCommand(
          _add.replaceFirst("@name", apiName ?? T.toString()),
          item,
          instanceFunction);
    }
  }

  @override
  Future<bool?> delete(T item) async {
    return await executeCommand(
        _delete.replaceFirst("@name", apiName ?? T.toString()), item);
  }

  @override
  Future<List<T>?> update(
    T item, {
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  }) async {
    if (onSendProgress != null || onReceiveProgress != null) {
      return await retrieveCommandWithDio(
          _update.replaceFirst("@name", apiName ?? T.toString()),
          item,
          instanceFunction,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
    } else {
      return await retrieveCommand(
          _update.replaceFirst("@name", apiName ?? T.toString()),
          item,
          instanceFunction);
    }
  }

  @override
  Future<bool?> deleteList(List<T>? items) async {
    return await executeCommand(
        _deleteList.replaceFirst("@name", apiName ?? T.toString()), items);
  }

  Future<bool?> save(T item) async {
    return await executeCommand(
        _save.replaceFirst("@name", apiName ?? T.toString()), item);
  }

  @override
  Future<List<PrintResponse>?> printQuery({
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  }) async {
    List<PrintResponse>? result;
    var query = QueryModel(id: "0");
    if (onSendProgress != null || onReceiveProgress != null) {
      return await retrieveTypeCommandWithDio<PrintResponse>(
          _printQuery.replaceFirst("@name", apiName ?? T.toString()),
          query,
          connectionTimeout: 30000,
          closeConnectionTimeout: 30000,
          instanceFunction,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
    } else {
      return await retrieveTypeCommand<PrintResponse>(
          _printQuery.replaceFirst("@name", apiName ?? T.toString()),
          query,
          PrintResponse.fromJsonModel,
          connectionTimeout: 30000,
          closeConnectionTimeout: 30000);
    }
  }

  @override
  Future<List<PrintResponse>?> printThis(
    List<T>? items, {
    Function(int sent, int total)? onSendProgress,
    Function(int sent, int total)? onReceiveProgress,
  }) async {
    if (onSendProgress != null || onReceiveProgress != null) {
      return await retrieveTypeCommandWithDio<PrintResponse>(
          _printThis.replaceFirst("@name", apiName ?? T.toString()),
          items,
          connectionTimeout: 30000,
          closeConnectionTimeout: 30000,
          instanceFunction,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
    } else {
      return await retrieveTypeCommand<PrintResponse>(
          _printThis.replaceFirst("@name", apiName ?? T.toString()),
          items,
          PrintResponse.fromJsonModel,
          connectionTimeout: 30000,
          closeConnectionTimeout: 30000);
    }
  }

  Future<dynamic>? executeCommandAndGet(String url, dynamic parameter) async {
    final response = await postUrl(url, parameter);
    final result = await readResponse(response);
    //print(result);

    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception(MultiService.makeResponseErrorText(
          "Comando non riuscito: $url",
          response.statusCode,
          result,
          response.reasonPhrase));
    }
  }
}
//#endregion