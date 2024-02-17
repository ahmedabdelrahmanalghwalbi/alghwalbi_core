part of alghwalbi_core;

abstract class DelegateConfig {
  static double maxExtent = 150;
  static double minExtent = 80;
  static Duration animationDurationValue = const Duration(milliseconds: 150);
  static double elevationValue(double progress, double elevation) =>
      progress > 0 && elevation > 0 ? elevation : 0;
}
