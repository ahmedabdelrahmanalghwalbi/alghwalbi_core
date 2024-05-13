part of alghwalbi_core;

class ThemeService {
  static const double containerWidth = 1000;
  static const double menuWidth = 300;

  static Color get mainColor => CoreApp.themeConfig.mainColor;
  static Color get mainColor2 => CoreApp.themeConfig.mainColor2;
  static Color get secondryColor => CoreApp.themeConfig.secondColor;
  static Color get subColor => CoreApp.themeConfig.subColor;
  static Color get subColorLight => CoreApp.themeConfig.subColorLight;
  static Color get inactiveMenuTextColor =>
      CoreApp.themeConfig.inactiveMenuTextColor;
  static Color get backgroundColor => CoreApp.themeConfig.backgroundColor;
  static Color get backgroundSecondColor =>
      const Color.fromRGBO(242, 242, 242, 1);
  static Color get mainTextColor => CoreApp.themeConfig.textMainColor;
  static Color get textSubColor => CoreApp.themeConfig.textSubColor;
  static Color get textSelectedColor => CoreApp.themeConfig.textSelectedColor;
  static Color get textOnSecondColor => Colors.white;
  static Color get textOnMainColor => Colors.white;

  static Color get successColor => CoreApp.themeConfig.successColor;
  static Color get worningColor => CoreApp.themeConfig.worningColor;
  static Color get dangerColor => CoreApp.themeConfig.dangerColor; //red
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
      cardTheme: const CardTheme(
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
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),

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
      textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 20.0),
          titleMedium: TextStyle(
              fontSize: 16.0,
              color: Colors.black45,
              fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(
              fontSize: 15.0,
              color: Colors.black45,
              fontWeight: FontWeight.w600)),
    );
  }

  static TextStyle get labelStyle => TextStyle(
      color: ThemeService.textSubColor,
      fontSize: 13,
      fontWeight: FontWeight.normal);
  static TextStyle get titleStyle => const TextStyle(
      color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
  static TextStyle get flatButtonTextStyle =>
      TextStyle(color: mainColor, fontSize: 13, fontWeight: FontWeight.normal);
}
