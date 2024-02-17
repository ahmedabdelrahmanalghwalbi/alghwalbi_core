part of alghwalbi_core;

class ThemeService {
  static final double containerWidth = 1000;
  static final double menuWidth = 300;

  static Color get mainColor => CoreApp.themeConfig?.mainColor ?? Colors.red;
  static Color get mainColor2 => CoreApp.themeConfig?.mainColor2 ?? Colors.red;
  static Color get secondryColor =>
      CoreApp.themeConfig?.secondColor ?? Colors.black54;
  static Color get subColor => CoreApp.themeConfig?.subColor ?? Colors.black38;
  static Color get subColorLight =>
      CoreApp.themeConfig?.subColorLight ?? Colors.black12;

  static Color get inactiveMenuTextColor =>
      CoreApp.themeConfig?.inactiveMenuTextColor ?? Colors.black12;

  static Color get backgroundColor => CoreApp.themeConfig.backgroundColor;
  static Color get backgroundSecondColor =>
      Color.fromRGBO(242, 242, 242, 1); //Gray

  static Color get mainTextColor =>
      CoreApp.themeConfig?.textMainColor ?? Colors.black;
  static Color get textSubColor =>
      CoreApp.themeConfig?.textSubColor ?? Colors.black87;
  static Color get textSelectedColor =>
      CoreApp.themeConfig?.textSelectedColor ?? Colors.black45;
  static Color get textOnSecondColor => Colors.white;
  static Color get textOnMainColor => Colors.white;

  static Color get successColor =>
      CoreApp.themeConfig?.successColor ?? Color.fromRGBO(102, 169, 28, 1);
  static Color get worningColor =>
      CoreApp.themeConfig?.worningColor ?? Colors.yellowAccent;
  static Color get dangerColor =>
      CoreApp.themeConfig?.dangerColor ?? Colors.red; //red
  static Color get mainInvertColor => Colors.orange;
  static Color get validationErrorColors => Colors.red; //red

  static getMainThemeIos() {
    return CupertinoThemeData(
      brightness: Brightness.light,
      barBackgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white, // background
      primaryColor: mainColor,
      //primaryContrastingColor: mainColor
    );
  }

  static ThemeData getMainThemeAndroid() {
    return ThemeData(
      primaryColor: mainColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: backgroundColor,
      dialogBackgroundColor: backgroundColor,
      colorScheme: ColorScheme(
        primary: mainColor,
        onPrimary: mainTextColor,
        secondary: mainColor2,
        onSecondary: mainInvertColor,
        error: dangerColor,
        onError: Colors.white,
        onBackground: mainColor,
        brightness: Brightness.light,
        surface: backgroundColor,
        onSurface: mainColor,
        background: backgroundColor,
      ),
      // brightness: Brightness.light,
      //platform: TargetPlatform.android,
      indicatorColor: secondryColor,
      cardTheme: CardTheme(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
      ),
      secondaryHeaderColor: secondryColor,
      //textSelectionHandleColor: textSubColor,

      highlightColor: mainColor,

      textSelectionTheme: TextSelectionThemeData(
          selectionColor: mainColor,
          cursorColor: mainColor,
          selectionHandleColor: mainColor),
      // buttonColor: mainColor,
      dividerColor: mainColor,

      hintColor: mainColor,

      shadowColor: mainColor,

      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(mainColor))),
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),

      //textSelectionColor: textSelectedColor,
      fontFamily: CoreApp.themeConfig.mainFont,
      //-------------- Active Styles ----------------------

      iconTheme: IconThemeData(color: mainColor, size: 30.0),
      appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: textOnMainColor),
          backgroundColor: mainColor,
          iconTheme: IconThemeData(color: textOnMainColor),
          actionsIconTheme: IconThemeData(color: textOnMainColor),
          toolbarTextStyle: TextStyle(color: textOnMainColor),
          //color: mainColor,
          foregroundColor: textOnMainColor),
      textTheme: TextTheme(
          headline1: TextStyle(fontSize: 20.0),
          subtitle1: TextStyle(
              fontSize: 16.0,
              color: Colors.black45,
              fontWeight: FontWeight.w600),
          bodyText1: TextStyle(
              fontSize: 15.0,
              color: Colors.black45,
              fontWeight: FontWeight.w600)),
    );
  }

  static TextStyle get labelStyle => TextStyle(
      color: ThemeService.textSubColor,
      fontSize: 13,
      fontWeight: FontWeight.normal);
  static TextStyle get titleStyle =>
      TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
  static TextStyle get flatButtonTextStyle =>
      TextStyle(color: mainColor, fontSize: 13, fontWeight: FontWeight.normal);
}
