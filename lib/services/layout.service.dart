part of alghwalbi_core;

class LayoutService {
  /// check if the device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 900 &&
        MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// check if the device is tabled
  static bool isTablet(BuildContext context) {
    return (MediaQuery.of(context).size.width >= 900 &&
            MediaQuery.of(context).size.width < 1200) ||
        (MediaQuery.of(context).orientation == Orientation.landscape &&
            MediaQuery.of(context).size.width < 1200);
  }

  /// check if the device is desctop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  /// return device screen width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// return device screen height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// check if device has disabled the animation
  static bool disableAnimation(BuildContext context) {
    return kIsWeb || (MediaQuery.of(context).disableAnimations);
  }

  /// bind the widget depond on screen size
  static Widget bindWidget(BuildContext context,
      {Widget Function()? mobileWidget,
      Widget Function()? tabletWidget,
      Widget Function()? descktopWidget}) //: assert(context != null)
  {
    //return descktopWidget;
    if (MediaQuery.of(context).size.width > 1200) {
      var c = descktopWidget ??
          tabletWidget ??
          mobileWidget ??
          () => const SizedBox();
      return c();
    }
    if (MediaQuery.of(context).size.width > 650 ||
        MediaQuery.of(context).orientation == Orientation.landscape) {
      var c = tabletWidget ??
          descktopWidget ??
          mobileWidget ??
          () => const SizedBox();
      return c();
    }

    var c = mobileWidget ??
        tabletWidget ??
        descktopWidget ??
        () => const SizedBox();
    return c();
  }

  ///Get Text Size
  static Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
