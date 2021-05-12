part of leancloud_storage;

class _LCCompositionalCondition extends _LCQueryCondition {
  static const String And = '\$and';
  static const String Or = '\$or';

  String composition;

  late List<_LCQueryCondition> conditionList;

  late bool includeACL;
  late int skip;
  late int limit;

  List<String>? orderByList;
  Set<String>? includes;
  Set<String>? selectedKeys;

  _LCCompositionalCondition({this.composition = And}) {
    conditionList = <_LCQueryCondition>[];
    includeACL = false;
    skip = 0;
    limit = 30;
  }

  /// Where
  void whereEqualTo(String key, dynamic value) {
    add(new _LCEqualCondition(key, value));
  }

  void whereNotEqualTo(String key, dynamic value) {
    addOperation(key, '\$ne', value);
  }

  void whereContainedIn(String key, Iterable values) {
    addOperation(key, '\$in', values);
  }

  void whereNotContainedIn(String key, Iterable values) {
    addOperation(key, '\$nin', values);
  }

  void whereContainsAll(String key, Iterable values) {
    addOperation(key, '\$all', values);
  }

  void whereExists(String key) {
    addOperation(key, '\$exists', true);
  }

  void whereDoesNotExist(String key) {
    addOperation(key, '\$exists', false);
  }

  void whereSizeEqualTo(String key, int size) {
    addOperation(key, '\$size', size);
  }

  void whereGreaterThan(String key, dynamic value) {
    addOperation(key, '\$gt', value);
  }

  void whereGreaterThanOrEqualTo(String key, dynamic value) {
    addOperation(key, '\$gte', value);
  }

  void whereLessThan(String key, dynamic value) {
    addOperation(key, '\$lt', value);
  }

  void whereLessThanOrEqualTo(String key, dynamic value) {
    addOperation(key, '\$lte', value);
  }

  void whereNear(String key, LCGeoPoint point) {
    addOperation(key, '\$nearSphere', point);
  }

  void whereWithinGeoBox(
      String key, LCGeoPoint southwest, LCGeoPoint northeast) {
    Map<String, dynamic> value = {
      '\$box': [southwest, northeast]
    };
    addOperation(key, '\$within', value);
  }

  void whereWithinRadians(String key, LCGeoPoint point, num distance) {
    Map<String, dynamic> value = {
      '\$nearSphere': point,
      '\$maxDistance': distance
    };
    add(new _LCEqualCondition(key, value));
  }

  void whereRelatedTo(LCObject parent, String key) {
    add(new _LCRelatedCondition(parent, key));
  }

  void whereStartsWith(String key, String prefix) {
    addOperation(key, '\$regex', '^$prefix.*');
  }

  void whereEndsWith(String key, String suffix) {
    addOperation(key, '\$regex', '.*$suffix\$');
  }

  void whereContains(String key, String subString) {
    addOperation(key, '\$regex', '.*$subString.*');
  }

  void whereMatches(String key, String regex, String? modifiers) {
    Map<String, dynamic> value = {'\$regex': regex};
    if (modifiers != null) {
      value['\$options'] = modifiers;
    }
    add(new _LCEqualCondition(key, value));
  }

  void whereMatchesQuery(String key, LCQuery query) {
    Map<String, dynamic> inQuery = {
      'where': query.condition,
      'className': query.className
    };
    addOperation(key, '\$inQuery', inQuery);
  }

  void whereDoesNotMatchQuery(String key, LCQuery query) {
    Map<String, dynamic> inQuery = {
      'where': query.condition,
      'className': query.className
    };
    addOperation(key, '\$notInQuery', inQuery);
  }

  /// Ordering
  void orderByAscending(String key) {
    orderByList = <String>[];
    orderByList!.add(key);
  }

  void orderByDecending(String key) {
    orderByAscending('-$key');
  }

  void addAscendingOrder(String key) {
    if (orderByList == null) {
      orderByList = <String>[];
    }
    orderByList!.add(key);
  }

  void addDescendingOrder(String key) {
    addAscendingOrder('-$key');
  }

  void include(String key) {
    if (includes == null) {
      includes = new Set<String>();
    }
    includes!.add(key);
  }

  void select(String key) {
    if (selectedKeys == null) {
      selectedKeys = new Set<String>();
    }
    selectedKeys!.add(key);
  }

  void addOperation(String key, String op, dynamic value) {
    _LCOperationCondition cond = new _LCOperationCondition(key, op, value);
    add(cond);
  }

  void add(_LCQueryCondition? cond) {
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
  Map<String, dynamic>? encode() {
    if (conditionList.length == 0) {
      return null;
    }
    if (conditionList.length == 1) {
      return conditionList[0].encode();
    }
    return {composition: _LCEncoder.encodeList(conditionList)};
  }

  Map<String, dynamic> _buildParams() {
    Map<String, dynamic> result = {'skip': skip, 'limit': limit};
    if (conditionList.length > 0) {
      result['where'] = jsonEncode(encode());
    }
    String? orders = _buildOrder();
    if (orders != null) {
      result['order'] = orders;
    }
    String? includes = _buildIncludes();
    if (includes != null) {
      result['include'] = includes;
    }
    String? selectedKeys = _buildSelectedKeys();
    if (selectedKeys != null) {
      result['keys'] = selectedKeys;
    }
    if (includeACL) {
      result['returnACL'] = includeACL;
    }
    return result;
  }

  String? _buildWhere() {
    if (conditionList.length > 0) {
      return jsonEncode(encode());
    }
    return null;
  }

  String? _buildOrder() {
    if (orderByList != null && orderByList!.length > 0) {
      return orderByList!.join(',');
    }
    return null;
  }

  String? _buildIncludes() {
    if (includes != null && includes!.length > 0) {
      return includes!.join(',');
    }
    return null;
  }

  String? _buildSelectedKeys() {
    if (selectedKeys != null && selectedKeys!.length > 0) {
      return selectedKeys!.join(',');
    }
    return null;
  }
}
