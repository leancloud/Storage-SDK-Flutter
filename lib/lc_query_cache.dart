part of leancloud_storage;

/// Specifies interaction with the cached responses.
enum CachePolicy {
  /// Always queries from the cloud.
  onlyNetwork,

  /// Queries from the cloud first,
  /// if failed, it will queries from the cache instead.
  networkElseCache
}

class LCQueryCache {
  LCQueryCache();
}
