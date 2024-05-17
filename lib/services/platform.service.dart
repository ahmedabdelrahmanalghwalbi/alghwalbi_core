part of alghwalbi_core;

class PlatformService {
  /// return true if the current device and version
  /// supporting local db in sqlite
  static bool get isSupportLocalDBSupported =>
      !kIsWeb &&
      (Platform.isAndroid ||
          Platform.isIOS ||
          Platform.isMacOS ||
          Platform.isWindows ||
          Platform.isLinux);

  /// return true if the current device and version support sound
  static bool get isSoundSupport => kIsWeb || !Platform.isWindows;

  /// return true if the current device and version support barcode scanner
  static bool get isBarcodeSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  /// return true if the current device and version support bluetoth
  static bool get isBluetoothSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
}
