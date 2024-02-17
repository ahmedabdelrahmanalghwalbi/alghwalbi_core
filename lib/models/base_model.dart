part of alghwalbi_core;

abstract class BaseModel {
  /// return the id valie
  String get idValue;

  /// return display name
  String get displayName;

  /// return bool from dynamic
  bool getBool(dynamic val) => BaseModel.getBoolEx(val);

  /// return bool from dynamic
  static bool getBoolEx(dynamic val) {
    if (val == null) return false;
    if (val is bool) return val;
    if (val is String) return val == 'true' || val == '1';
    if (val is num) return val == 1;
    return false;
  }

  /// return DateTime from dynamic
  DateTime? getDate(dynamic val, [bool isUTC = true]) =>
      BaseModel.getDateEx(val, isUTC);

  /// return DateTime from dynamic
  static DateTime? getDateEx(dynamic val,
      [bool isUTC = true, bool isMicrosecondsSinceEpoch = false]) {
    if (val == null) return null;
    if (val is int) {
      return isMicrosecondsSinceEpoch
          ? DateTime.fromMicrosecondsSinceEpoch(val, isUtc: isUTC)
          : DateTime.fromMillisecondsSinceEpoch(val, isUtc: isUTC);
    }
    if (val is DateTime) return val;
    if (val is String) return isUTC ? parseUTC(val) : parse(val);
    return null;
  }

  /// return double from dynamic
  double? getDouble(dynamic val, [bool defaultIsZero = true]) =>
      BaseModel.getDoubleEx(val, defaultIsZero);

  /// return int from dynamic
  int? getInt(dynamic val, [bool defaultIsZero = true]) =>
      BaseModel.getIntEx(val, defaultIsZero);

  /// return double from dynamic
  static double? getDoubleEx(dynamic val, [bool defaultIsZero = true]) {
    if (val == null) return defaultIsZero ? 0 : null;
    if (val is num) return val.toDouble();
    if (val is String) {
      return num.tryParse(val)?.toDouble() ?? (defaultIsZero ? 0 : null);
    }
    return (defaultIsZero ? 0 : null);
  }

  /// return int from dynamic
  static int? getIntEx(dynamic val, [bool defaultIsZero = true]) {
    if (val == null || (val is num && val.isNaN)) {
      return defaultIsZero ? 0 : null;
    }
    if (val is num) return val.toInt();
    if (val is String) {
      return num.tryParse(val)?.toInt() ?? (defaultIsZero ? 0 : null);
    }
    return (defaultIsZero ? 0 : null);
  }

  /// return true if the Id is default
  static bool isDefault(String? id) => id != null && id.length < 30;

  /// convert service time to DateTime UTC
  static DateTime? parseUTC(String? serverValue,
      {String format = "yyyy-MM-ddTHH:mm:ss", DateTime? defaultValue}) {
    if (serverValue == null) return defaultValue;
    try {
      return intl.DateFormat(format).parseUTC(serverValue);
    } catch (err) {
      return defaultValue;
    }
  }

  static DateTime? parse(String? serverValue,
      {String format = "yyyy-MM-ddTHH:mm:ss", DateTime? defaultValue}) {
    if (serverValue == null) return defaultValue;
    try {
      return intl.DateFormat(format).parse(serverValue);
    } catch (err) {
      return defaultValue;
    }
  }
}
