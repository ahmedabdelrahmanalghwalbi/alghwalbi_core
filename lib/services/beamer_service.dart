part of alghwalbi_core;

class CoreBeamerPageRoute {
  final String path;
  final BeamPage Function(BuildContext, BeamState, Object?) builder;
  CoreBeamerPageRoute(this.path, this.builder);
}

class BeamerService {
  static List<String> stackRouteHistory = [];

  /// to set page title in browser tab default is true
  static bool? setBrowserTabTitle;

  /// pageTitle is null in web
  static Future Function(String route, String? pageTitle)? onNavigate;
  // your not found page default is BeamPage.notFound
  static BeamPage? notFoundPageEx;
  static String? notFoundRedirectNamed;
  static BeamLocation<RouteInformationSerializable<dynamic>>? notFoundRedirect;

  /// default is BeamPageType.cupertino
  static BeamPageType? iosBeamPageType;

  /// default is BeamPageType.noTransition
  static BeamPageType? webBeamPageType;

  /// default is BeamPageType.material
  static BeamPageType? androidBeamPageType;
  static Map<String, dynamic Function(BuildContext, BeamState, Object?)>?
      _routes;

  static Map<String, dynamic Function(BuildContext, BeamState, Object?)>?
      routesEx;

  /// try to give value to routes first
  static Map<String, dynamic Function(BuildContext, BeamState, Object?)>
      get routes {
    if (_routes == null && routesEx != null) {
      Map<String, dynamic Function(BuildContext, BeamState, Object?)> r = {};

      for (var p in pages) {
        var rr = p();
        if (rr == null) continue;
        r[rr.path] = rr.builder;
      }
      _routes = r;
      if (routesEx != null) _routes!.addAll(routesEx!);

      if (_routes!.isEmpty) _routes = null;
    }
    return _routes ?? {};
  }

  static List<CoreBeamerPageRoute? Function()> pages = [];

  static BeamerParser get getBeamerParser => BeamerParser();

  static BeamerBackButtonDispatcher get getBeamerBackButtonDispatcher =>
      BeamerBackButtonDispatcher(
        delegate: routerDelegate,
        alwaysBeamBack: true,
      );

  static void setPathUrlStrategyEx() {
    Beamer.setPathUrlStrategy();
  }

  static BeamPage beamPageEx(
      {required Widget child,
      String? title,
      LocalKey? key,
      String? popToNamedEx,
      bool Function(BuildContext, BeamerDelegate,
              RouteInformationSerializable<dynamic>, BeamPage)?
          onPopPageEx}) {
    return onPopPageEx != null
        ? BeamPage(
            child: child,
            title: title,
            key: key,
            type: _getPageTransation(),
            popToNamed: popToNamedEx,
            onPopPage: onPopPageEx)
        : BeamPage(
            child: child,
            title: title,
            key: key,
            type: _getPageTransation(),
            popToNamed: popToNamedEx,
          );
  }

  static void pop(BuildContext context, {String? popFailedRoute}) {
    if (!kIsWeb) {
      if (Navigator.canPop(context)) {
        if (stackRouteHistory.isNotEmpty) {
          stackRouteHistory.removeLast();
        }
        Navigator.pop(context);
      } else {
        push(
            context: context,
            route: popFailedRoute ?? '/',
            animationType: AnimationTypes.opacity);
      }
      return;
    }
    if (Beamer.of(context).canBeamBack) {
      Beamer.of(context).beamBack();
    } else {
      if (popFailedRoute != null) {
        push(context: context, route: popFailedRoute, replaceRoute: true);
      } else {
        Navigator.pop(context);
      }
    }
  }

  static void push(
      {required BuildContext context,
      required String route,
      Map<String, dynamic>? data,
      bool replaceRoute = false,
      AnimationTypes animationType = AnimationTypes.none}) {
    if (!kIsWeb) {
      if (!route.startsWith('/') && stackRouteHistory.isNotEmpty) {
        route = '${stackRouteHistory.last}/$route';
      }
      stackRouteHistory.add(route);
      var state = BeamState.fromUri(Uri.parse(route));
      var k2 = route.split('/');
      for (var key in BeamerService.routes.keys) {
        var k1 = key.split('/');
        if (k1.length != k2.length) continue;
        var match = true;
        for (var i = 0; i < k1.length; i++) {
          if (!k1[i].contains(':') && k1[i] != k2[i]) {
            match = false;
            continue;
          }
        }
        if (!match) continue;

        for (var i = 0; i < k1.length; i++) {
          if (k1[i].contains(':')) {
            var s = Map<String, String>.from(state.pathParameters);
            // jsonDecode(jsonEncode());
            s[k1[i].substring(1)] = k2[i];
            state = state.copyWith(pathParameters: s);
          }
        }

        BeamPage? widget =
            BeamerService.routes[key]?.call(context, state, data);
        if (widget != null) {
          onNavigate?.call(route, widget.title);
          AppNavigator.navigateTo(context, () => widget.child,
              replaceAll: replaceRoute, animationType: animationType);
          return;
        }
      }
      AppNavigator.showMessage(context, 'Invalid route', MessageType.error,
          message: 'Route $route not found');
      return;
    }

    onNavigate?.call(route, null);
    if (replaceRoute) {
      Beamer.of(context)
          .beamToReplacementNamed(route, data: data, stacked: false);
    } else {
      Beamer.of(context).beamToNamed(route, data: data);
    }
  }

  static BeamPageType _getPageTransation() {
    if (kIsWeb) {
      return webBeamPageType ?? BeamPageType.noTransition;
    } else if (Platform.isIOS) {
      return iosBeamPageType ?? BeamPageType.cupertino;
    } else {
      return androidBeamPageType ?? BeamPageType.material;
    }
  }

  static var routerDelegate = BeamerDelegate(
    setBrowserTabTitle: setBrowserTabTitle ?? true,
    notFoundRedirectNamed: notFoundRedirectNamed,
    notFoundRedirect: notFoundRedirect,
    notFoundPage: notFoundPageEx ?? BeamPage.notFound,
    navigatorObservers: [HeroController(), defaultLifecycleObserver],
    locationBuilder: RoutesLocationBuilder(routes: routes),
  );
}
