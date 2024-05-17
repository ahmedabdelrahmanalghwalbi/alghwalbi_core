part of alghwalbi_core;

/// A static cache manager to store and retrieve key-value pairs in memory.
/// This manager uses a singleton pattern to provide a globally accessible cache.
class StaticCacheManager {
  // Private constructor to prevent instantiation of this class
  StaticCacheManager._();

  // A static map to hold the cache data
  static final Map<String, dynamic> _cache = {};

  /// Sets a value in the cache with the given [key].
  ///
  /// [key]: The key for the value to be stored.
  /// [value]: The value to be stored in the cache.
  static void setValue(String key, dynamic value) {
    _cache[key] = value;
  }

  /// Retrieves a value from the cache for the given [key].
  ///
  /// [key]: The key for the value to be retrieved.
  ///
  /// Returns the value associated with the [key], or null if the key is not found.
  static T getValue<T>(String key) {
    return _cache[key];
  }

  /// Checks if the cache contains the given [key].
  ///
  /// [key]: The key to check in the cache.
  ///
  /// Returns true if the cache contains the [key], false otherwise.
  static bool containsKey(String key) {
    return _cache.containsKey(key);
  }

  /// Checks if the cache contains valid data for the given [key].
  ///
  /// [key]: The key to check in the cache.
  ///
  /// Returns true if the cache contains the [key] and the value is not null, false otherwise.
  static bool existData(String key) {
    return (getValue(key) != null) && containsKey(key);
  }

  /// Removes the value associated with the given [key] from the cache.
  ///
  /// [key]: The key for the value to be removed.
  static void removeValue(String key) {
    _cache.remove(key);
  }

  /// Clears all data from the cache.
  static void clearCache() {
    _cache.clear();
  }
}
