part of alghwalbi_core;

abstract class IApiService {
  static Function(dynamic response)? unauthrizedCallback;

  Future<OperationResult<Map>> httpGet(String url,
      {Map<String, String>? header});

  Future<OperationResult<dynamic>> httpPost(String url, dynamic data,
      [Map<String, String>? header, bool asString = false]);

  Future<OperationResult<dynamic>> httpPut(String url, Map data,
      {Map<String, String>? header});

  Future<OperationResult<dynamic>> httpPostEx(String url, dynamic data,
      [Map<String, String>? header, bool addToken = true]);

  Future<OperationResult<dynamic>> httpPutEx(String url, dynamic data,
      {Map<String, String>? header});

  Future<OperationResult<dynamic>> httpGetDynamic(String url,
      {Map<String, String>? header});

  Future<OperationResult<dynamic>> httpDeleteDynamic(String url,
      {Map<String, String>? header});

  Future<OperationResult<dynamic>> httpDeleteDynamicEx(String url,
      {Map<String, String>? header});

  Future<OperationResult<String>> httpGetString(String url,
      {Map<String, String>? header});

  Future<OperationResult<String>> httpPostFile(
      String url, Uint8List fileData, String name,
      [Map<String, String>? requestFields,
      Map<String, String>? header,
      bool isImage = true]);
}

class ApiService implements IApiService {
  /// backend token
  static String get token => ConfigService.token;

  static Map<String, String>? _baseHeader;
  Map<String, String> get baseHeader {
    if (_baseHeader == null) {
      _baseHeader = {
        'AppVersion': CoreApp.appVersion,
        'DeviceType': kIsWeb
            ? 'WebBrowser'
            : Platform.isAndroid
                ? 'Android'
                : Platform.isIOS
                    ? 'iOS'
                    : Platform.isWindows
                        ? 'Windows'
                        : Platform.isMacOS
                            ? 'MacOS'
                            : Platform.isLinux
                                ? 'Linux'
                                : Platform.isFuchsia
                                    ? 'Fuchsia'
                                    : 'Unknown',
      };
      if (!kIsWeb) {
        _baseHeader!['Accept-Encoding'] = 'gzip';
      }
    }
    return _baseHeader!;
  }

  /// call backend and return OperationResult with Map
  Future<OperationResult<Map>> httpGet(String url,
      {Map<String, String>? header}) async {
    try {
      var result = await httpGetString(url, header: header);
      if (!result.success) {
        return OperationResult(
            success: false,
            message: result.message,
            innerError: result.innerError);
      }

      var map = json.decode(result.data ?? '');
      if (kDebugMode) print('$url: ${result.data?.length} length');

      return OperationResult(success: true, data: map);
    } catch (err, t) {
      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  /// custom Encodeer for DateTime issue
  static dynamic customEncode(dynamic item) {
    if (item is DateTime) {
      return intl.DateFormat("yyyy-MM-ddTHH:mm:ss").format(item);
    }
    return item;
  }

  /// call backend and return OperationResult with Map
  Future<OperationResult<dynamic>> httpPost(String url, dynamic data,
      [Map<String, String>? header, bool asString = false]) async {
    try {
      var httpClient = http.Client();
      if (kDebugMode) print('POST: ${await _getFullUrl(url)}');

      if (asString) {
        data =
            json.encode(data, toEncodable: customEncode).replaceAll('\"', '\'');
      }
      var body = json.encode(data, toEncodable: customEncode);

      var headers = {'content-type': 'application/json'};
      for (var h in baseHeader.keys) {
        headers[h] = baseHeader[h]!;
      }

      if (token.isNotEmpty) headers['Authorization'] = 'Bearer $token';

      http.Response response = await httpClient.post(
        await _getFullUrl(url),
        headers: {...headers, ...?header},
        body: utf8.encode(body),
      );
      if (response.statusCode != 200) //&& response.statusCode !=307
      {
        debugPrint('statusCode: ${response.statusCode}');
        return OperationResult(
            success: false, message: 'Result code = ${response.statusCode}');
      }
      var r = jsonDecode(response.body);
      httpClient.close();
      return parseResponse(r);
      // } else
      //   return OperationResult(success: false, message: 'Result code = ${result.statusCode}');
    } catch (err, t) {
      debugPrint('xxxxxxxxxxxx ERROR: POST   error ==>$err ==>$t');
      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  /// call backend and return OperationResult with Map
  Future<OperationResult<dynamic>> httpPut(String url, Map data,
      {Map<String, String>? header}) async {
    try {
      var httpClient = http.Client();

      if (kDebugMode) print('PUT: ${await _getFullUrl(url)}');

      var headers = {'content-type': 'application/json'};
      for (var h in baseHeader.keys) {
        headers[h] = baseHeader[h]!;
      }
      if (token.isNotEmpty) headers['Authorization'] = 'Bearer $token';

      http.Response response = await httpClient.put(
        await _getFullUrl(url),
        headers: {...headers, ...?header},
        body: json.encode(data, toEncodable: customEncode),
      );

      if (response.statusCode != 200) //&& response.statusCode !=307
      {
        debugPrint(response.statusCode.toString());
        return OperationResult(
            success: false, message: 'Result code = ${response.statusCode}');
      }

      String reply = response.body;

      httpClient.close();

      var r = jsonDecode(reply);
      return parseResponse(r);
      // } else
      //   return OperationResult(success: false, message: 'Result code = ${result.statusCode}');
    } catch (err, t) {
      debugPrint('xxxxxxxxxxxx ERROR: POST  error ==> $err ==> $t');
      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  /// call backend and return OperationResult with Map
  Future<OperationResult<dynamic>> httpPostEx(String url, dynamic data,
      [Map<String, String>? header, bool addToken = true]) async {
    try {
      if (kDebugMode) print('POST: ${await _getFullUrl(url)}');
      var httpClient = http.Client();
      var result = await httpClient.post(await _getFullUrl(url),
          body: json.encode(data, toEncodable: customEncode),
          headers: addToken
              ? {
                  'content-type': 'application/json',
                  ...baseHeader,
                  ...?header,
                  'Authorization': 'Bearer $token'
                }
              : {
                  'content-type': 'application/json',
                  ...baseHeader,
                });
      httpClient.close();
      if (result.statusCode != 200) {
        debugPrint('XXXXXXX  Response status code ${result.statusCode}');
        return OperationResult(
            success: false, message: 'Result code = ${result.statusCode}');
      }

      String reply = result.body;
      var r = jsonDecode(reply);

      return parseResponse(r);
    } catch (err, t) {
      debugPrint('xxxxxxxxxxxx ERROR: POST  error ==> $err $t');
      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  /// call backend and return OperationResult with Map
  Future<OperationResult<dynamic>> httpPutEx(String url, dynamic data,
      {Map<String, String>? header}) async {
    try {
      if (kDebugMode) print('PUT: ${await _getFullUrl(url)}');
      var httpClient = http.Client();
      var result = await httpClient.put(await _getFullUrl(url),
          body: json.encode(data, toEncodable: customEncode),
          headers: {
            'content-type': 'application/json',
            ...baseHeader,
            ...?header,
            'Authorization': 'Bearer $token'
          });
      httpClient.close();
      if (result.statusCode != 200) //&& response.statusCode !=307
      {
        debugPrint(result.statusCode.toString());
        return OperationResult(
            success: false, message: 'Result code = ${result.statusCode}');
      }

      String reply = result.body;

      var r = jsonDecode(reply);
      return parseResponse(r);
      // } else
      //   return OperationResult(success: false, message: 'Result code = ${result.statusCode}');
    } catch (err, t) {
      debugPrint('xxxxxxxxxxxx ERROR: POST ==> $err ==>$t');
      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  /// call backend and return OperationResult with Map
  Future<OperationResult<dynamic>> httpGetDynamic(String url,
      {Map<String, String>? header}) async {
    try {
      if (kDebugMode) {
        print('GET --------------------- ${await _getFullUrl(url)}');
      }
      var httpClient = http.Client();
      var response = await httpClient.get(
        await _getFullUrl(url),
        headers: {
          'content-type': 'application/json',
          ...baseHeader,
          ...?header,
          'Authorization': 'Bearer $token'
        },
      );
      httpClient.close();
      if (response.statusCode != 200) {
        debugPrint('XXXXXXXXXXX GET status is ${response.statusCode} $url');
        if (response.statusCode == 401 &&
            IApiService.unauthrizedCallback != null) {
          IApiService.unauthrizedCallback?.call(response.statusCode);
        }
        return OperationResult(
            success: false, message: 'Result code = ${response.statusCode}');
      } else if (kDebugMode) {
        print('GET response $url');
      }
      String reply = response.body;

      if (reply.length == 0) {
        return OperationResult(success: false, message: 'Result is empty');
      }

      var r = jsonDecode(reply);

      if (r['success'] != true) {
        debugPrint(r.toString());
        if (r['errorCodeString'] == 'InvalidAuthentication' &&
            IApiService.unauthrizedCallback != null) {
          IApiService.unauthrizedCallback?.call(r);
        }
      }
      return parseResponse(r);
    } catch (err, t) {
      debugPrint(
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ERROR: GET: $url  error ==> $err ==>$t');

      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  /// call backend and return OperationResult with Map
  Future<OperationResult<dynamic>> httpDeleteDynamic(String url,
      {Map<String, String>? header}) async {
    try {
      if (kDebugMode) {
        print('DELETE --------------------- ${await _getFullUrl(url)}');
      }
      var httpClient = http.Client();
      var response = await httpClient.delete(await _getFullUrl(url), headers: {
        'content-type': 'application/json',
        ...baseHeader,
        ...?header,
        'Authorization': 'Bearer $token'
      });
      httpClient.close();
      if (response.statusCode != 200) {
        return OperationResult(
            success: false, message: 'Result code = ${response.statusCode}');
      }

      String reply = response.body;

      if (reply.length == 0) {
        return OperationResult(success: false, message: 'Result is empty');
      }

      var r = jsonDecode(reply);

      if (r['success'] != true) print(r);
      return parseResponse(r);
    } catch (err, t) {
      debugPrint(
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   ERROR: DELETE: $url  error ==> $err ==>$t');

      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  /// call backend and return OperationResult with Map
  Future<OperationResult<dynamic>> httpDeleteDynamicEx(String url,
      {Map<String, String>? header}) async {
    try {
      if (kDebugMode) {
        print('DELETE --------------------- ${await _getFullUrl(url)}');
      }
      var httpClient = http.Client();
      var headers = {'content-type': 'application/json'};
      for (var h in baseHeader.keys) {
        headers[h] = baseHeader[h]!;
      }

      if (token.isNotEmpty) headers['Authorization'] = 'Bearer $token';

      http.Response response = await httpClient
          .delete(await _getFullUrl(url), headers: {...headers, ...?header});

      if (response.statusCode != 200) {
        return OperationResult(
            success: false, message: 'Result code = ${response.statusCode}');
      }

      String reply = response.body;
      httpClient.close();

      if (reply.length == 0) {
        return OperationResult(success: false, message: 'Result is empty');
      }

      var r = jsonDecode(reply);

      if (r['success'] != true) print(r);
      return parseResponse(r);
    } catch (err, t) {
      debugPrint(
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   ERROR: DELETE: $url  xxx error ==> $err  ==> t');

      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  Future<OperationResult<String>> httpGetString(String url,
      {Map<String, String>? header}) async {
    try {
      var httpClient = http.Client();
      var result = await httpClient.get(await _getFullUrl(url), headers: {
        ...baseHeader,
        ...?header,
        'Authorization': 'Bearer '
            '$token'
      });
      httpClient.close();
      if (result.statusCode == 200) {
        return OperationResult(success: true, data: result.body);
      } else
        return OperationResult(
            success: false, message: 'Result code = ${result.statusCode}');
    } catch (err, t) {
      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  static String? get apiURL => ConfigService.apiURL;
  static Future<Uri> _getFullUrl(String url) async {
    if (url.startsWith('http')) return Uri.parse(url);
    while (apiURL == null || (apiURL?.isEmpty ?? true)) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return Uri.parse("$apiURL$url");
  }

  /// call backend and post file like images
  Future<OperationResult<String>> httpPostFile(
      String url, Uint8List fileData, String name,
      [Map<String, String>? requestFields,
      Map<String, String>? header,
      bool isImage = true]) async {
    String dataString;
    try {
      //print('POST:---- ${_getFullUrl(url)}   $name');
      //var httpClient = http.Client();
      var request = http.MultipartRequest("POST", await _getFullUrl(url));

      request.headers['Authorization'] = 'Bearer $token';
      // request.fields['user'] = 'someone@somewhere.com';
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileData,
        filename: name,
        contentType: isImage
            ? MediaType("image", path.extension(name))
            : MediaType('application', 'x-tar'),
      ));
      request.fields['name'] = name;
      request.fields['path'] = 'img';

      request.headers["Authorization"] = "Bearer $token";
      // request.headers["Accept"] = vimeoUploadHeader;
      request.headers["Content-Type"] = "image/jpg";
      if (requestFields != null) {
        request.fields.addAll(requestFields);
      }
      if (header != null) {
        request.headers.addAll(header);
      }
      //request.headers["Content-Length"] = fileData.length.toString();
      var response = await request.send();
      if (response.statusCode == 200) {
        var data = (await response.stream.toBytes());
        if (kDebugMode) print(data.length);
        dataString = utf8.decode(data);
        var r = json.decode(dataString);
        return OperationResult(
          data: r['data'] is Map ? r['data']['url'] : r['data'],
          success: r['success'] is bool
              ? r['success']
              : r['success']?.toString() == "true",
          innerError: r['innerError']?.toString(),
          minVersion: r['minVersion']?.toString(),
          lastVersion: r['lastVersion']?.toString(),
          message: r['message'] is Map || r['message'] == null
              ? (r['messageAr'] ??
                  r['errorString'] ??
                  r['fullMessagesString'] ??
                  r['errorCodeString'] ??
                  'No Server Error!')
              : r['message'],
          multiMessage: r['message'] is Map ? r['message'] : null,
          errorCodeString: r['errorCodeString']?.toString(),
        );
      }
      return OperationResult(
          success: false, message: 'Error HttpPosFile: ${response.statusCode}');
    } catch (err, t) {
      debugPrint('XXXXXXXXXXXXXXXX post file error: $err $t');

      return OperationResult(
          success: false, message: err.toString(), innerError: t.toString());
    }
  }

  OperationResult parseResponse(Map r) {
    return OperationResult(
      success: r['success'] is bool
          ? r['success']
          : r['success']?.toString() == "true",
      innerError: r['innerError']?.toString(),
      minVersion: r['minVersion']?.toString(),
      lastVersion: r['lastVersion']?.toString(),
      message: r['message'] is Map || r['message'] == null
          ? (r['messageAr'] ??
              r['errorString'] ??
              r['fullMessagesString'] ??
              r['errorCodeString'] ??
              'No Server Error!')
          : r['message'],
      data: r['data'],
      features: r['features'] != null
          ? (r['features'] as List<dynamic>).cast<String>().toList()
          : null,
      multiMessage: r['message'] is Map ? r['message'] : null,
      errorCodeString: r['errorCodeString']?.toString(),
    );
  }
}
