part of alghwalbi_core;

class CoreBeamerPageRoute {
  final String path;
  final BeamPage Function(BuildContext, BeamState, Object?) builder;
  CoreBeamerPageRoute(this.path, this.builder);
}

class BeamerService {
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

      if (_routes!.length == 0) _routes = null;
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
      bool replaceRoute = false}) {
    if (replaceRoute) {
      Beamer.of(context)
          .beamToReplacementNamed(route, data: data, stacked: false);
    } else {
      Beamer.of(context).beamToNamed(
        route,
        data: data,
      );
    }
  }

  static BeamPageType _getPageTransation() {
    if (kIsWeb) {
      return BeamPageType.noTransition;
    }
    return BeamPageType.material;
  }

  static final routerDelegate = BeamerDelegate(
    navigatorObservers: [HeroController(), defaultLifecycleObserver],
    locationBuilder: RoutesLocationBuilder(routes: routes),
  );
}
