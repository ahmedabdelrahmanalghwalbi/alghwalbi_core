part of alghwalbi_core;

extension StringExtension on String {
  /// convert HexString to Color
  Color? toColorEx([Color? defaultColor]) {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return defaultColor;
  }
}

extension ColorExtension on Color {
  /// convert color to HexString
  String toHexString() {
    return value.toRadixString(16);
  }
}
