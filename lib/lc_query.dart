part of leancloud_storage;

/// 查询
class LCQuery<T extends LCObject> {
  String className;

  _LCCompositionalCondition condition;

  /// 创建 [className] 类型的查询对象
  LCQuery(this.className) {
    condition = new _LCCompositionalCondition();
  }

  /// [key] 等于 [value]
  LCQuery<T> whereEqualTo(String key, dynamic value) {
    condition.whereEqualTo(key, value);
    return this;
  }

  /// [key] 不等于 [value]
  LCQuery<T> whereNotEqualTo(String key, dynamic value) {
    condition.whereNotEqualTo(key, value);
    return this;
  }

  /// [key] 中包含 [values]
  LCQuery<T> whereContainedIn(String key, Iterable values) {
    condition.whereContainedIn(key, values);
    return this;
  }

  /// [key] 中不包括 [values]
  LCQuery<T> whereNotContainedIn(String key, Iterable values) {
    condition.whereNotContainedIn(key, values);
    return this;
  }

  /// [key] 中包含全部 [values]
  LCQuery<T> whereContainsAll(String key, Iterable values) {
    condition.whereContainsAll(key, values);
    return this;
  }

  /// 存在 [key] 字段
  LCQuery<T> whereExists(String key) {
    condition.whereExists(key);
    return this;
  }

  /// 不存在 [key] 字段
  LCQuery<T> whereDoesNotExist(String key) {
    condition.whereDoesNotExist(key);
    return this;
  }

  /// [key] 字段长度等于 [size]
  LCQuery<T> whereSizeEqualTo(String key, int size) {
    condition.whereSizeEqualTo(key, size);
    return this;
  }

  /// [key] 字段大于 [value]
  LCQuery<T> whereGreaterThan(String key, dynamic value) {
    condition.whereGreaterThan(key, value);
    return this;
  }

  /// [key] 字段大于等于 [value]
  LCQuery<T> whereGreaterThanOrEqualTo(String key, dynamic value) {
    condition.whereGreaterThanOrEqualTo(key, value);
    return this;
  }

  /// [key] 字段小于 [value]
  LCQuery<T> whereLessThan(String key, dynamic value) {
    condition.whereLessThan(key, value);
    return this;
  }

  /// [key] 字段小于等于 [value]
  LCQuery<T> whereLessThanOrEqualTo(String key, dynamic value) {
    condition.whereLessThanOrEqualTo(key, value);
    return this;
  }

  /// [key] 字段相邻 [point] 位置
  LCQuery<T> whereNear(String key, LCGeoPoint point) {
    condition.whereNear(key, point);
    return this;
  }

  /// [key] 字段在 [southwest] 到 [northeast] 坐标区域内
  LCQuery<T> whereWithinGeoBox(
      String key, LCGeoPoint southwest, LCGeoPoint northeast) {
    condition.whereWithinGeoBox(key, southwest, northeast);
    return this;
  }

  /// [key] 字段与 [parent] 相关
  LCQuery<T> whereRelatedTo(LCObject parent, String key) {
    condition.whereRelatedTo(parent, key);
    return this;
  }

  /// [key] 字段以 [prefix] 为前缀
  LCQuery<T> whereStartsWith(String key, String prefix) {
    condition.whereStartsWith(key, prefix);
    return this;
  }

  /// [key] 字段以 [suffix] 为后缀
  LCQuery<T> whereEndsWith(String key, String suffix) {
    condition.whereEndsWith(key, suffix);
    return this;
  }

  /// [key] 字段中包含 [subString]
  LCQuery<T> whereContains(String key, String subString) {
    condition.whereContains(key, subString);
    return this;
  }

  /// [key] 字段满足正则匹配 [regex]
  LCQuery<T> whereMatches(String key, String regex, {String modifiers}) {
    condition.whereMatches(key, regex, modifiers);
    return this;
  }

  /// [key] 字段满足 [query] 查询
  LCQuery<T> whereMatchesQuery(String key, LCQuery query) {
    condition.whereMatchesQuery(key, query);
    return this;
  }

  /// [key] 字段不满足 [query] 查询
  LCQuery<T> whereDoesNotMatchQuery(String key, LCQuery query) {
    condition.whereDoesNotMatchQuery(key, query);
    return this;
  }

  /// 按 [key] 升序
  LCQuery<T> orderByAscending(String key) {
    condition.orderByAscending(key);
    return this;
  }

  /// 按 [key] 降序
  LCQuery<T> orderByDescending(String key) {
    condition.orderByDecending(key);
    return this;
  }

  /// 增加按 [key] 升序
  LCQuery<T> addAscendingOrder(String key) {
    condition.addAscendingOrder(key);
    return this;
  }

  /// 增加按 [key] 降序
  LCQuery<T> addDescendingOrder(String key) {
    condition.addDescendingOrder(key);
    return this;
  }

  /// 拉取 [key] 的完整对象
  LCQuery<T> include(String key) {
    condition.include(key);
    return this;
  }

  /// 包含 [key]
  LCQuery<T> select(String key) {
    condition.select(key);
    return this;
  }

  /// 跳过 [value]
  LCQuery<T> skip(int value) {
    condition.skip = value;
    return this;
  }

  /// 限制 [value] 数量
  LCQuery<T> limit(int value) {
    condition.limit = value;
    return this;
  }

  /// 数量
  Future<int> count() async {
    String path = 'classes/$className';
    Map<String, dynamic> params = _buildParams();
    params['limit'] = 0;
    params['count'] = 1;
    Map result = await LeanCloud._httpClient.get(path, queryParams: params);
    return result['count'];
  }

  /// 获取 [objectId] 对应的对象
  Future<T> get(String objectId) async {
    if (isNullOrEmpty(objectId)) {
      throw new ArgumentError.notNull('objectId');
    }
    whereEqualTo('objectId', objectId);
    limit(1);
    List<T> results = await find();
    if (results != null) {
      if (results.length == 0) {
        return null;
      }
      return results[0];
    }
    return null;
  }

  /// 根据 [cachePolicy] 查找
  Future<List<T>> find(
      {CachePolicy cachePolicy = CachePolicy.onlyNetwork}) async {
    if (cachePolicy == CachePolicy.onlyNetwork) {
      return _fetch(CachePolicy.onlyNetwork);
    } else {
      try {
        List<T> results = await _fetch(CachePolicy.onlyNetwork);
        return results;
      } on DioError catch (e) {
        LCLogger.error(e.message);
        return _fetch(CachePolicy.networkElseCache);
      }
    }
  }

  Future<List<T>> _fetch(CachePolicy cachePolicy) async {
    String path = 'classes/$className';
    Map<String, dynamic> params = _buildParams();
    Map response = await LeanCloud._httpClient
        .get(path, queryParams: params, cachePolicy: cachePolicy);
    List results = response['results'];
    List<T> list = new List();
    results.forEach((item) {
      _LCObjectData objectData = _LCObjectData.decode(item);
      LCObject object = LCObject._create(T, className: className);
      object._merge(objectData);
      list.add(object);
    });
    return list;
  }

  /// 返回符合条件的第一个对象
  Future<T> first() async {
    limit(1);
    List<T> results = await find();
    if (results != null && results.length > 0) {
      return results.first;
    }
    return null;
  }

  /// [queries] 的 and 查询
  static LCQuery<T> and<T extends LCObject>(Iterable<LCQuery<T>> queries) {
    if (queries == null || queries.length < 1) {
      throw new ArgumentError.notNull('queries');
    }
    LCQuery<T> compositionQuery = new LCQuery<T>(null);
    String className;
    queries.forEach((item) {
      if (className != null && className != item.className) {
        throw ('All of the queries in an or query must be on the same class.');
      }
      className = item.className;
      compositionQuery.condition.add(item.condition);
    });
    compositionQuery.className = className;
    return compositionQuery;
  }

  /// [queries] 的 or 查询
  static LCQuery<T> or<T extends LCObject>(Iterable<LCQuery<T>> queries) {
    if (queries == null || queries.length < 1) {
      throw new ArgumentError.notNull('queries');
    }
    LCQuery<T> compositionQuery = new LCQuery<T>(null);
    compositionQuery.condition = new _LCCompositionalCondition(
        composition: _LCCompositionalCondition.Or);
    String className;
    queries.forEach((item) {
      if (className != null && className != item.className) {
        throw ('All of the queries in an or query must be on the same class.');
      }
      className = item.className;
      compositionQuery.condition.add(item.condition);
    });
    compositionQuery.className = className;
    return compositionQuery;
  }

  Map<String, dynamic> _buildParams() {
    return condition._buildParams();
  }

  String _buildWhere() {
    return condition._buildWhere();
  }
}
