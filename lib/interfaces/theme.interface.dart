part of alghwalbi_core;

abstract class IThemeConfig {
  String? get mainFont => null;
  Color get mainColor => Colors.black;
  Color get mainColor2 => Colors.black;
  Color get secondColor => Colors.blue;
  Color get backgroundColor => Colors.white;
  Color get backgroundSecondColor => Colors.black12;
  Color get subColor => Colors.orangeAccent;
  Color get subColorLight => Colors.orangeAccent;
  Color get textMainColor => mainColor;
  Color get textSubColor => Colors.black45;
  Color get textSelectedColor => secondColor;
  Color get inactiveMenuTextColor => secondColor;
  Color get worningColor => Colors.yellowAccent;
  Color get successColor => Colors.green;
  Color get dangerColor => Colors.redAccent;
}
