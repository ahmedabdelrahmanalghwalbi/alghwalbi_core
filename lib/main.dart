part of alghwalbi_core;

class CoreApp {
  /// theme config class
  static late IThemeConfig themeConfig;

  /// the file name for rive anumationFile
  static String? animactionNameLoading;

  /// the file name for rive anumationFile
  static String? animactionNameError;

  /// the file name for rive anumationFile
  static String? animactionNameInfo;

  /// the file name for rive anumationFile
  static String? animactionNameSuccess;

  /// the file name for rive anumationFile
  static String? animactionNameWarning;

  /// the file name for rive anumationFile
  static String? animactionNameConfirm;

  /// app Global key used for navigate
  static GlobalKey<NavigatorState> appGlobalkey = GlobalKey<NavigatorState>();

  /// is for testing
  static bool isTest = false;

  /// api url to for checking on (refresh token && access token) expiration date.
  static String? refreshTokenApiURL;

  /// enable or disable checking for (refresh token && access token) before any request to backend server.
  static bool? checkOnTokenExpiration;
  //required passing navigator global key in intialization of application
  static GlobalKey<NavigatorState>? navigatorGlobalKey;

  /// api service class
  static IApiService apiService = ApiServiceMock();

  ///path of the app logo image with white Text to use in notification icon
  static String? logoWithWihteText;

  /// the file name for rive anumationFile
  static String? gifAssetLoading;
  static Color? backgroundColorLoading;

  /// app version
  static String appVersion = '';
  static num appVersionInt = 0;
  static bool isNewer(String? version) {
    if (version == null) return false;
    if (appVersionInt == 0) {
      var t = CoreApp.appVersion.split('.').map((e) => num.parse(e)).toList();
      appVersionInt += t[0] * 10000000;
      appVersionInt += t[1] * 10000;
      appVersionInt += t[2];
    }
    if (version == appVersion) return false;
    num v = 0;
    var tv = version.split('.').map((e) => num.parse(e)).toList();
    v += tv[0] * 10000000;
    v += tv[1] * 10000;
    v += tv[2];
    return v > appVersionInt;
  }
}

class ThemeConfigMock extends IThemeConfig {}

class ApiServiceMock extends IApiService {
  ApiServiceMock();

  @override
  Future<OperationResult> httpDeleteDynamic(String url,
      {Map<String, String>? header}) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> httpDeleteDynamicEx(String url,
      {Map<String, String>? header}) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult<Map>> httpGet(String url,
      {Map<String, String>? header}) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> httpGetDynamic(String url,
      {Map<String, String>? header}) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult<String>> httpGetString(String url,
      {Map<String, String>? header}) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> httpPost(String url, data,
      [Map<String, String>? header, bool asString = false]) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> httpPostEx(String url, data,
      [Map<String, String>? header, bool addToken = true]) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult<String>> httpPostFile(
      String url, Uint8List fileData, String name,
      [Map<String, String>? requestFields,
      Map<String, String>? header,
      bool isImage = true]) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> httpPut(String url, Map data,
      {Map<String, String>? header}) {
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> httpPutEx(String url, data,
      {Map<String, String>? header}) {
    throw UnimplementedError();
  }
}

class CoreMaterialApp extends MaterialApp {
  CoreMaterialApp(
      {super.key,
      super.scaffoldMessengerKey,
      super.routeInformationProvider,
      super.routerConfig,
      super.builder,
      super.title,
      super.onGenerateTitle,
      super.color,
      ThemeData? theme,
      super.darkTheme,
      super.highContrastTheme,
      super.highContrastDarkTheme,
      super.themeMode,
      super.themeAnimationDuration,
      super.themeAnimationCurve,
      super.locale,
      super.localizationsDelegates,
      super.localeListResolutionCallback,
      super.localeResolutionCallback,
      super.supportedLocales,
      super.debugShowMaterialGrid,
      super.showPerformanceOverlay,
      super.checkerboardRasterCacheImages,
      super.checkerboardOffscreenLayers,
      super.showSemanticsDebugger,
      super.debugShowCheckedModeBanner,
      super.shortcuts,
      super.actions,
      super.restorationScopeId,
      super.useInheritedMediaQuery})
      : super.router(
          routerDelegate: BeamerService.routerDelegate,
          routeInformationParser: BeamerService.getBeamerParser,
          backButtonDispatcher: BeamerService.getBeamerBackButtonDispatcher,
          scrollBehavior: AppScrollBehavior(),
          theme: ThemeService.getMainThemeAndroid(),
        );
}

class AppScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
