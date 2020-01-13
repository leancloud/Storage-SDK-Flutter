part of leancloud_storage;

/// 查询类
class LCQuery<T extends LCObject> {
  String className;

  _LCCompositionalCondition condition;

  LCQuery(this.className) {
    condition = new _LCCompositionalCondition();
  }

  /// 等于
  LCQuery<T> whereEqualTo(String key, dynamic value) {
    condition.whereEqualTo(key, value);
    return this;
  }

  /// 不等于
  LCQuery<T> whereNotEqualTo(String key, dynamic value) {
    condition.whereNotEqualTo(key, value);
    return this;
  }

  /// 包含
  LCQuery<T> whereContainedIn(String key, Iterable values) {
    condition.whereContainedIn(key, values);
    return this;
  }

  /// 包含全部
  LCQuery<T> whereContainsAll(String key, Iterable values) {
    condition.whereContainsAll(key, values);
    return this;
  }

  /// 字符串包含
  LCQuery<T> whereContains(String key, String subString) {
    condition.whereContains(key, subString);
    return this;
  }

  /// 存在
  LCQuery<T> whereExists(String key) {
    condition.whereExists(key);
    return this;
  }

  /// 不存在
  LCQuery<T> whereDoesNotExist(String key) {
    condition.whereDoesNotExist(key);
    return this;
  }

  /// 长度等于
  LCQuery<T> whereSizeEqualTo(String key, int size) {
    condition.whereSizeEqualTo(key, size);
    return this;
  }

  /// 大于
  LCQuery<T> whereGreaterThan(String key, dynamic value) {
    condition.whereGreaterThan(key, value);
    return this;
  }

  /// 大于等于
  LCQuery<T> whereGreaterThanOrEqualTo(String key, dynamic value) {
    condition.whereGreaterThanOrEqualTo(key, value);
    return this;
  }

  /// 小于
  LCQuery<T> whereLessThan(String key, dynamic value) {
    condition.whereLessThan(key, value);
    return this;
  }

  /// 小于等于
  LCQuery<T> whereLessThanOrEqualTo(String key, dynamic value) {
    condition.whereLessThanOrEqualTo(key, value);
    return this;
  }

  /// 相邻
  LCQuery<T> whereNear(String key, LCGeoPoint point) {
    condition.whereNear(key, point);
    return this;
  }

  /// 在坐标区域内
  LCQuery<T> whereWithinGeoBox(String key, LCGeoPoint southwest, LCGeoPoint northeast) {
    condition.whereWithinGeoBox(key, southwest, northeast);
    return this;
  }

  /// 相关
  LCQuery<T> whereRelatedTo(LCObject parent, String key) {
    condition.whereRelatedTo(parent, key);
    return this;
  }

  /// 按 key 升序
  LCQuery<T> orderBy(String key) {
    condition.orderBy(key);
    return this;
  }

  /// 按 key 降序
  LCQuery<T> orderByDescending(String key) {
    condition.orderByDecending(key);
    return this;
  }

  /// 拉取 key 的完整对象
  LCQuery<T> include(String key) {
    condition.include(key);
    return this;
  }

  /// 包含 key
  LCQuery<T> select(String key) {
    condition.select(key);
    return this;
  }

  /// 跳过
  LCQuery<T> skip(int value) {
    condition.skip = value;
    return this;
  }

  /// 限制数量
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

  /// 获取
  Future<T> get(String objectId) async {
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

  /// 查找
  Future<List<T>> find() async {
    String path = 'classes/$className';
    Map<String, dynamic> params = _buildParams();
    Map response = await LeanCloud._httpClient.get(path, queryParams: params);
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

  /// 查询第一个
  Future<T> first() async {
    limit(1);
    List<T> results = await find();
    if (results != null) {
      return results.first;
    }
    return null;
  }

  /// and 查询
  static LCQuery<T> and<T extends LCObject>(Iterable<LCQuery<T>> queries) {
    LCQuery<T> compositionQuery = new LCQuery<T>(null);
    String className;
    if (queries != null) {
      queries.forEach((item) {
        if (className != null && className != item.className) {
          throw('All of the queries in an or query must be on the same class.');
        }
        className = item.className;
        compositionQuery.condition.add(item.condition);
      });
    }
    compositionQuery.className = className;
    return compositionQuery;
  }

  /// or 查询
  static LCQuery<T> or<T extends LCObject>(Iterable<LCQuery<T>> queries) {
    LCQuery<T> compositionQuery = new LCQuery<T>(null);
    compositionQuery.condition = new _LCCompositionalCondition(composition: _LCCompositionalCondition.Or);
    String className;
    if (queries != null) {
      queries.forEach((item) {
        if (className != null && className != item.className) {
          throw('All of the queries in an or query must be on the same class.');
        }
        className = item.className;
        compositionQuery.condition.add(item.condition);
      });
    }
    compositionQuery.className = className;
    return compositionQuery;
  }

  Map<String, dynamic> _buildParams() {
    return condition._buildParams(className);
  }

  String _buildWhere() {
    return condition._buildWhere();
  }
}