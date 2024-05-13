part of alghwalbi_core;

class ConfigService {
  /// api url
  static String? apiURL;

  /// stream server url
  static String? wsURL;

  /// is right to left
  static bool isRTL = false;

  // static IConfig config;
  static IThemeConfig? theme;

  /// any keys here will not be cleared when user signout
  static List<String> dontClearKeys = [];

  static SharedPreferences? _prefs;

  ///access token getter
  static String get token => getValueString('token');

  ///access token setter
  static set token(v) {
    if (_prefs == null) {
      init().then((_) => setValueString('token', v));
    } else {
      setValueString('token', v);
    }
  }

  ///refresh token getter
  static String get refreshToken => getValueString('refreshToken');

  ///refresh token setter
  static set refreshToken(v) {
    if (_prefs == null) {
      init().then((_) => setValueString('refreshToken', v));
    } else {
      setValueString('refreshToken', v);
    }
  }

  ///access token expire date getter
  static int get accessTokenExpDate => getValueInt('accessTokenExpDate');

  ///access token expire date setter
  static set accessTokenExpDate(v) {
    if (_prefs == null) {
      init().then((_) => setValueInt('accessTokenExpDate', v));
    } else {
      setValueInt('accessTokenExpDate', v);
    }
  }

  ///refresh token expire date getter
  static int get refreshTokenExpDate => getValueInt('refreshTokenExpDate');

  ///refresh token expire date setter
  static set refreshTokenExpDate(v) {
    if (_prefs == null) {
      init().then((_) => setValueInt('refreshTokenExpDate', v));
    } else {
      setValueInt('refreshTokenExpDate', v);
    }
  }

  /// getter for is user logged in
  static bool get isLogin => getValueBool('is_login');

  /// setter for is user logged in
  static set isLogin(v) {
    if (_prefs == null) {
      init().then((_) => setValueBool('is_login', v));
    } else {
      setValueBool('is_login', v);
    }
  }

  /// initlize the config service
  /// you must call before calling any other function
  static Future init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      if (_prefs != null) return;
      if (CoreApp.isTest) {
        // ignore: invalid_use_of_visible_for_testing_member
        SharedPreferences.setMockInitialValues({'operation_mode': 1});
      }
      debugPrint('----- start prefs');
      _prefs = await SharedPreferences.getInstance();
      debugPrint('----- prefs as added');
    } catch (err, t) {
      if (!kIsWeb && Platform.isWindows) {
        try {
          var file = File.fromUri(Uri.file(
              '${(await path_provider.getApplicationSupportDirectory()).path}\\shared_preferences.json',
              windows: true));
          if (await file.exists()) {
            await file.delete();
            _prefs = await SharedPreferences.getInstance();
            return;
          }
        } catch (err, t) {
          debugPrint('XXXXXXXXXXXXXXXXXXX Config init error $err in $t');
        }
      }
      debugPrint('XXXXXXXXXXXXXXXXXXX Config init error $err in $t');
    }
    debugPrint('------------ Config Done!');
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (err, t) {
      debugPrint('XXXXXXXXXXXXXXXXXXX Config init error $err in $t');
    }
  }

  /// remove all local config values
  static Future<bool> resetConfig() async {
    if (_prefs == null) return false;
    var keys = _prefs!.getKeys();
    var result = true;
    for (var key in keys) {
      if (!dontClearKeys.contains(key)) {
        var r = await _prefs!.remove(key);
        if (!r) result = false;
      }
    }
    return result;
  }

  /// save data localy
  static Future<bool> setValueMap(dynamic key, Map v) async {
    if (_prefs == null) return false;
    await _prefs?.setString(
        key.toString(), json.encode(v, toEncodable: ApiService.customEncode));
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }

  /// save data localy
  static Future<bool> setValueString(dynamic key, String? v) async {
    if (_prefs == null) return false;
    if (v == null) {
      _prefs?.remove(key.toString());
    } else {
      await _prefs?.setString(key.toString(), v);
    }
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }

  /// save data localy
  static Future<bool> setValueBool(dynamic key, bool v) async {
    if (_prefs == null) return false;
    await _prefs?.setBool(key.toString(), v);
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }

  /// save data localy
  static Future<bool> setValueInt(dynamic key, int v) async {
    if (_prefs == null) return false;
    await _prefs?.setInt(key.toString(), v);
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }

  /// get data localy
  static String getValueString(dynamic key) {
    if (_prefs == null) return '';
    return _prefs?.getString(key.toString()) ?? '';
  }

  /// check if data exist
  static bool checkValueExist(dynamic key) {
    if (_prefs == null) return false;
    return _prefs?.get(key.toString()) != null;
  }

  /// get data localy
  static Map<String, dynamic> getValueMap(dynamic key) {
    return json.decode(_prefs?.getString(key.toString()) ?? '{}') ?? {};
  }

  /// get data localy
  static int getValueInt(dynamic key) {
    return _prefs?.getInt(key.toString()) ?? 0;
  }

  /// get data localy
  static bool getValueBool(dynamic key) {
    return _prefs?.getBool(key.toString()) ?? false;
  }
}
