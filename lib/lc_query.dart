part of leancloud_storage;

/// 查询类
class LCQuery<T extends LCObject> {
  String className;

  _CompositionalCondition condition;

  LCQuery(this.className) {
    condition = new _CompositionalCondition();
  }

  LCQuery<T> whereEqualTo(String key, dynamic value) {
    condition.whereEqualTo(key, value);
    return this;
  }

  LCQuery<T> whereNotEqualTo(String key, dynamic value) {
    condition.whereNotEqualTo(key, value);
    return this;
  }

  LCQuery<T> whereContainedIn(String key, Iterable values) {
    condition.whereContainedIn(key, values);
    return this;
  }

  LCQuery<T> whereContainsAll(String key, Iterable values) {
    condition.whereContainsAll(key, values);
    return this;
  }

  LCQuery<T> whereContains(String key, String subString) {
    condition.whereContains(key, subString);
    return this;
  }

  LCQuery<T> whereExists(String key) {
    condition.whereExists(key);
    return this;
  }

  LCQuery<T> whereDoesNotExist(String key) {
    condition.whereDoesNotExist(key);
    return this;
  }

  LCQuery<T> whereSizeEqualTo(String key, int size) {
    condition.whereSizeEqualTo(key, size);
    return this;
  }

  LCQuery<T> whereGreaterThan(String key, dynamic value) {
    condition.whereGreaterThan(key, value);
    return this;
  }

  LCQuery<T> whereGreaterThanOrEqualTo(String key, dynamic value) {
    condition.whereGreaterThanOrEqualTo(key, value);
    return this;
  }

  LCQuery<T> whereLessThan(String key, dynamic value) {
    condition.whereLessThan(key, value);
    return this;
  }

  LCQuery<T> whereLessThanOrEqualTo(String key, dynamic value) {
    condition.whereLessThanOrEqualTo(key, value);
    return this;
  }

  LCQuery<T> whereNear(String key, LCGeoPoint point) {
    condition.whereNear(key, point);
    return this;
  }

  LCQuery<T> whereWithinGeoBox(String key, LCGeoPoint southwest, LCGeoPoint northeast) {
    condition.whereWithinGeoBox(key, southwest, northeast);
    return this;
  }

  LCQuery<T> whereRelatedTo(LCObject parent, String key) {
    condition.whereRelatedTo(parent, key);
    return this;
  }

  LCQuery<T> orderBy(String key) {
    condition.orderBy(key);
    return this;
  }

  LCQuery<T> orderByDescending(String key) {
    condition.orderByDecending(key);
    return this;
  }

  LCQuery<T> include(String key) {
    condition.include(key);
    return this;
  }

  LCQuery<T> select(String key) {
    condition.select(key);
    return this;
  }

  LCQuery<T> skip(int value) {
    condition.skip = value;
    return this;
  }

  LCQuery<T> limit(int value) {
    condition.limit = value;
    return this;
  }

  Future<int> count() async {
    LCHttpRequest request = _getRequest();
    request.queryParams['limit'] = '0';
    request.queryParams['count'] = '1';
    Map<String, dynamic> result = await LeanCloud._client.send<Map<String, dynamic>>(request);
    return result['count'];
  }

  Future<T> get(String objectId) async {
    whereEqualTo('objectId', objectId);
    limit(1);
    List<T> results = await find();
    if (results != null) {
      return results.first;
    }
    return null;
  }

  Future<List<T>> find() async {
    LCHttpRequest request = _getRequest();
    Map<String, dynamic> response = await LeanCloud._client.send<Map<String, dynamic>>(request);
    List results = response['results'];
    // TODO 判断是否返回正确

    List<T> list = new List();
    results.forEach((item) {
      LCObjectData objectData = LCObjectData.decode(item);
      LCObject object = new LCObject(className);
      object._merge(objectData);
      list.add(object);
    });
    return list;
  }

  Future<T> first() async {
    limit(1);
    List<T> results = await find();
    if (results != null) {
      return results.first;
    }
    return null;
  }

  static LCQuery<T> and<T extends LCObject>(Iterable<LCQuery<T>> queries) {
    LCQuery<T> compositionQuery = new LCQuery<T>(null);
    String className;
    if (queries != null) {
      queries.forEach((item) {
        if (className != null && className != item.className) {
          throw new Error();
        }
        className = item.className;
        compositionQuery.condition.add(item.condition);
      });
    }
    compositionQuery.className = className;
    return compositionQuery;
  }

  static LCQuery<T> or<T extends LCObject>(Iterable<LCQuery<T>> queries) {
    LCQuery<T> compositionQuery = new LCQuery<T>(null);
    compositionQuery.condition = new _CompositionalCondition(composition: _CompositionalCondition.Or);
    String className;
    if (queries != null) {
      queries.forEach((item) {
        if (className != null && className != item.className) {
          throw new Error();
        }
        className = item.className;
        compositionQuery.condition.add(item.condition);
      });
    }
    compositionQuery.className = className;
    return compositionQuery;
  }

  Map<String, dynamic> _buildParams() {
    return condition.buildParams(className);
  }

  LCHttpRequest _getRequest() {
    String path = 'classes/$className';
    String method = LCHttpRequestMethod.get;
    Map<String, dynamic> params = _buildParams();
    Map<String, String> queryParams = new Map<String, String>();
    params.forEach((key, value) {
      queryParams[key] = value.toString();
    });
    return new LCHttpRequest(path, method, queryParams: queryParams);
  }
}