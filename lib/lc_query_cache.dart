part of leancloud_storage;

/// 缓存查询策略
enum CachePolicy {
  /// 只从服务端拉取
  onlyNetwork,

  /// 先从服务端拉取，如果失败则从缓存中查找
  networkElseCache
}

class LCQueryCache {
  LCQueryCache();
}
