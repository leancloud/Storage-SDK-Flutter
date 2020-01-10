part of leancloud_storage;

class _LCCompositionalCondition extends _LCQueryCondition {
  static const String And = '\$and';
  static const String Or = '\$or';

  String composition;

  List<_LCQueryCondition> conditionList;

  List<String> orderByList;
  Set<String> includes;
  Set<String> selectedKeys;
  int skip;
  int limit;

  _LCCompositionalCondition({ this.composition }) {
    if (composition == null) {
      composition = And;
    }
    conditionList = new List<_LCQueryCondition>();
    skip = 0;
    limit = 30;
  }

  /// Where
  void whereEqualTo(String key, dynamic value) {
    add(new _LCEqualCondition(key, value));
  }

  void whereNotEqualTo(String key, dynamic value) {
    addCondition(key, '\$ne', value);
  }

  void whereContainedIn(String key, Iterable values) {
    addCondition(key, '\$in', values);
  }

  void whereNotContainedIn(String key, Iterable values) {
    addCondition(key, '\$nin', values);
  }

  void whereContainsAll(String key, Iterable values) {
    addCondition(key, '\$all', values);
  }

  void whereContains(String key, String subString) {
    addCondition(key, '\$regex', subString);
  }

  void whereExists(String key) {
    addCondition(key, '\$exists', true);
  }

  void whereDoesNotExist(String key) {
    addCondition(key, '\$exists', false);
  }

  void whereSizeEqualTo(String key, int size) {
    addCondition(key, '\$size', size);
  }

  void whereGreaterThan(String key, dynamic value) {
    addCondition(key, '\$gt', value);
  }

  void whereGreaterThanOrEqualTo(String key, dynamic value) {
    addCondition(key, '\$gte', value);
  }

  void whereLessThan(String key, dynamic value) {
    addCondition(key, '\$lt', value);
  }

  void whereLessThanOrEqualTo(String key, dynamic value) {
    addCondition(key, '\$lte', value);
  }

  void whereNear(String key, LCGeoPoint point) {
    addCondition(key, '\$nearSphere', point);
  }

  void whereWithinGeoBox(String key, LCGeoPoint southwest, LCGeoPoint northeast) {
    Map<String, dynamic> value = {
      '\$box': [ southwest, northeast ]
    };
    addCondition(key, '\$within', value);
  }

  void whereRelatedTo(LCObject parent, String key) {
    add(new _LCRelatedCondition(parent, key));
  }

  void whereStartsWith(String key, String prefix) {
    addCondition(key, '\$regex', '^$prefix');
  }

  void whereEndsWith(String key, String suffix) {
    addCondition(key, '\$regex', '$suffix\$');
  }

  /// 筛选条件
  void orderBy(String key) {
    if (orderByList == null) {
      orderByList = new List<String>();
    }
    orderByList.add(key);
  }

  void orderByDecending(String key) {
    orderBy('-$key');
  }
  
  void include(String key) {
    if (includes == null) {
      includes = new Set<String>();
    }
    includes.add(key);
  }

  void select(String key) {
    if (selectedKeys == null) {
      selectedKeys = new Set<String>();
    }
    selectedKeys.add(key);
  }

  void addCondition(String key, String op, dynamic value) {
    _LCOperationCondition cond = new _LCOperationCondition(key, op, value);
    add(cond);
  }

  void add(_LCQueryCondition cond) {
    if (cond == null) {
      return;
    }
    conditionList.removeWhere((item) => item.equals(cond));
    conditionList.add(cond);
  }

  @override
  bool equals(_LCQueryCondition other) {
    return false;
  }

  @override
  Map<String, dynamic> toMap() {
    if (conditionList == null || conditionList.length == 0) {
      return null;
    }
    if (conditionList.length == 1) {
      return conditionList[0].toMap();
    }
    return {
      composition: _LCEncoder.encodeList(conditionList)
    };
  }

  Map<String, dynamic> _buildParams(String className) {
    Map<String, dynamic> result = {
      'className': className
    };
    if (conditionList != null && conditionList.length > 0) {
      result['where'] = jsonEncode(toMap());
    }
    if (orderByList != null && orderByList.length > 0) {
      result['order'] = orderByList.join(',');
    }
    if (includes != null && includes.length > 0) {
      result['include'] = includes.join(',');
    }
    if (selectedKeys != null && selectedKeys.length > 0) {
      result['keys'] = selectedKeys.join(',');
    }
    result['skip'] = skip;
    result['limit'] = limit;
    return result;
  }

  String _buildWhere() {
    if (conditionList != null && conditionList.length > 0) {
      return jsonEncode(toMap());
    }
    return null;
  }
}