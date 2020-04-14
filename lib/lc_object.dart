part of leancloud_storage;

/// 对象
class LCObject {
  /// 最近一次与服务端同步的数据
  _LCObjectData _data;

  /// 预算数据
  Map<String, dynamic> _estimatedData;

  /// 操作字典
  Map<String, _LCOperation> _operationMap;

  /// 类名
  String get className => _data.className;

  /// 对象 Id
  String get objectId => _data.objectId;

  /// 创建时间
  DateTime get createdAt => _data.createdAt;

  /// 更新时间
  DateTime get updatedAt => _data.updatedAt ?? _data.createdAt;

  /// 获得访问权限
  LCACL get acl => this['ACL'];

  /// 设置访问权限
  set acl(LCACL value) => this['ACL'] = value;

  /// 是否需要保存
  bool get _isDirty => _isNew || _estimatedData.length > 0;

  /// 是否为新建
  bool _isNew;

  /// 创建 [className] 类型的对象
  LCObject(String className) {
    assert(className != null && className.length > 0);
    _data = new _LCObjectData();
    _estimatedData = new Map<String, dynamic>();
    _operationMap = new Map<String, _LCOperation>();

    _data.className = className;
    _isNew = true;
  }

  /// 创建 [className] 类型的 [objectId] 对象
  static LCObject createWithoutData(String className, String objectId) {
    LCObject object = new LCObject(className);
    assert(objectId != null && objectId.length > 0);
    object._data.objectId = objectId;
    object._isNew = false;
    return object;
  }

  /// 获取 [key] 对应的值
  operator [](String key) {
    dynamic value = _estimatedData[key];
    if (value is LCRelation) {
      // 反序列化后的 Relation 字段并不完善
      value.key = key;
      value.parent = this;
    }
    return value;
  }

  /// 设置 [key] 对应的值 [value]
  operator []=(String key, dynamic value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull(key);
    }
    if (key.startsWith('_')) {
      throw new ArgumentError('key should not start with \'_\'');
    }
    if (key == 'objectId' || key == 'createdAt' || key == 'updatedAt') {
      throw new ArgumentError('$key is reserved by LeanCloud');
    }
    _LCSetOperation op = new _LCSetOperation(value);
    _applyOperation(key, op);
  }

  /// 删除 [key] 字段
  void unset(String key) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCDeleteOperation op = new _LCDeleteOperation();
    _applyOperation(key, op);
  }

  /// 增加 [key] 对应的关联 [value]
  void addRelation(String key, LCObject value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    _LCAddRelationOperation op = new _LCAddRelationOperation(value);
    _applyOperation(key, op);
  }

  /// 删除 [key] 对应的关联 [value]
  void removeRelation(String key, LCObject value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    _LCRemoveRelationOperation op = new _LCRemoveRelationOperation(value);
    _applyOperation(key, op);
  }

  /// 增加 [key] 数字属性值 [amount]
  void increment(String key, num amount) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCIncrementOperation op = new _LCIncrementOperation(amount);
    _applyOperation(key, op);
  }

  /// 减少 [key] 数字属性值 [amount]
  void decrement(String key, num amount) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCDecrementOperation op = new _LCDecrementOperation(amount);
    _applyOperation(key, op);
  }

  /// 在 [key] 数组属性中增加一个元素 [value]
  void add(String key, dynamic value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    _LCAddOperation op = new _LCAddOperation([value]);
    _applyOperation(key, op);
  }

  /// 在 [key] 数组属性中增加一组元素 [values]
  void addAll(String key, Iterable values) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    if (values == null) {
      throw ArgumentError.notNull('values');
    }
    _LCAddOperation op = new _LCAddOperation(values);
    _applyOperation(key, op);
  }

  /// 在 [key] 数组属性中增加一个唯一元素 [value]
  void addUnique(String key, dynamic value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    _LCAddUniqueOperation op = new _LCAddUniqueOperation([value]);
    _applyOperation(key, op);
  }

  /// 在 [key] 数组属性中增加一组唯一元素 [values]
  void addAllUnique(String key, Iterable values) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    if (values == null) {
      throw ArgumentError.notNull('values');
    }
    _LCAddUniqueOperation op = new _LCAddUniqueOperation(values);
    _applyOperation(key, op);
  }

  /// 移除 [key] 数组中的元素 [value]
  void remove(String key, dynamic value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    _LCRemoveOperation op = new _LCRemoveOperation([value]);
    _applyOperation(key, op);
  }

  /// 移除 [key] 数组中的一组元素 [values]
  void removeAll(String key, Iterable values) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    if (values == null) {
      throw ArgumentError.notNull('values');
    }
    _LCRemoveOperation op = new _LCRemoveOperation(values);
    _applyOperation(key, op);
  }

  void _rebuildEstimatedData() {
    _estimatedData = new Map<String, dynamic>();
    _data.customPropertyMap.forEach((String key, dynamic value) {
      // 对容器类型做一个拷贝
      if (value is List) {
        _estimatedData[key] = List.from(value);
      } else if (value is Map) {
        _estimatedData[key] = Map.from(value);
      } else {
        _estimatedData[key] = value;
      }
    });
  }

  void _applyOperation(String key, _LCOperation op) {
    // 先累加计算
    if (op is _LCDeleteOperation) {
      _estimatedData.remove(key);
    } else {
      _estimatedData[key] = op.apply(_estimatedData[key], key);
    }
    // 再合并为新的操作参数
    if (_operationMap.containsKey(key)) {
      _LCOperation previousOp = _operationMap[key];
      _operationMap[key] = op.mergeWithPrevious(previousOp);
    } else {
      _operationMap[key] = op;
    }
  }

  void _merge(_LCObjectData data) {
    _data.className = data.className ?? _data.className;
    _data.objectId = data.objectId ?? _data.objectId;
    _data.createdAt = data.createdAt ?? _data.createdAt;
    _data.updatedAt = data.updatedAt ?? _data.updatedAt;
    // 先将本地的预估数据直接替换
    _data.customPropertyMap = _estimatedData;
    // 再将服务端的数据覆盖
    data.customPropertyMap.forEach((String key, dynamic value) {
      _data.customPropertyMap[key] = value;
    });
    // 最后重新生成预估数据，用于后续访问和操作
    _rebuildEstimatedData();
    // 清空操作
    _operationMap.clear();
    _isNew = false;
  }

  /// 拉取 [keys] 字段值，以及包含 [includes] 字段对象
  Future<LCObject> fetch(
      {Iterable<String> keys, Iterable<String> includes}) async {
    Map<String, dynamic> queryParams = {};
    if (keys != null) {
      queryParams['keys'] = keys.join(',');
    }
    if (includes != null) {
      queryParams['include'] = includes.join(',');
    }
    String path = 'classes/$className/$objectId';
    Map response =
        await LeanCloud._httpClient.get(path, queryParams: queryParams);
    _LCObjectData objectData = _LCObjectData.decode(response);
    _merge(objectData);
    return this;
  }

  static Future<List<LCObject>> fetchAll(List<LCObject> objectList) async {
    if (objectList == null) {
      throw new ArgumentError.notNull('objectList');
    }
    Set<LCObject> objects = objectList.where((item) {
      return item.objectId != null;
    }).toSet();
    List requestList = objects.map((item) {
      String path = '/$APIVersion/classes/${item.className}/${item.objectId}';
      return {'path': path, 'method': 'GET'};
    }).toList();

    // 发送请求
    Map<String, dynamic> data = {
      'requests': _LCEncoder.encodeList(requestList)
    };
    List results = await LeanCloud._httpClient.post('batch', data: data);
    // 反序列化为 Object 数据
    Map<String, _LCObjectData> map = new Map<String, _LCObjectData>();
    results.forEach((item) {
      if (item.containsKey('error')) {
        int code = item['code'];
        String message = item['error'];
        throw ('$code : $message');
      }
      Map data = item['success'];
      map[data['objectId']] = _LCObjectData.decode(data);
    });
    objectList.forEach((object) {
      _LCObjectData objectData = map[object.objectId];
      object._merge(objectData);
    });
    return objectList;
  }

  static Future _saveBatches(Queue<_LCBatch> batches) async {
    while (batches.length > 0) {
      _LCBatch batch = batches.removeLast();
      List<LCObject> dirtyObjects = batch.objects.where((item) {
        return item._isDirty;
      }).toList();

      // 生成请求列表
      List requestList = dirtyObjects.map((item) {
        String path = item.objectId == null
            ? '/1.1/classes/${item.className}'
            : '/1.1/classes/${item.className}/${item.objectId}';
        String method = item.objectId == null ? 'POST' : 'PUT';
        Map body = _LCEncoder.encode(item._operationMap);
        return {'path': path, 'method': method, 'body': body};
      }).toList();

      // 发送请求
      Map<String, dynamic> data = {
        'requests': _LCEncoder.encodeList(requestList)
      };
      List results = await LeanCloud._httpClient.post('batch', data: data);
      // 反序列化为 Object 数据
      List<_LCObjectData> resultList = results.map((item) {
        if (item.containsKey('error')) {
          int code = item['code'];
          String message = item['error'];
          throw ('$code : $message');
        }
        return _LCObjectData.decode(item['success']);
      }).toList();
      for (int i = 0; i < dirtyObjects.length; i++) {
        LCObject object = dirtyObjects[i];
        _LCObjectData objectData = resultList[i];
        object._merge(objectData);
      }
    }
  }

  /// 保存，[fetchWhenSave] 是否在保存后拉取，是否根据 [query] 条件更新对象
  Future<LCObject> save(
      {bool fetchWhenSave = false, LCQuery<LCObject> query}) async {
    // 检测循环依赖
    if (_LCBatch.hasCircleReference(this, new HashSet<LCObject>())) {
      throw new ArgumentError('Found a circle dependency when save.');
    }

    // 保存对象依赖
    Queue<_LCBatch> batches = _LCBatch.batchObjects([this], false);
    if (batches.length > 0) {
      await _saveBatches(batches);
    }

    // 保存对象本身
    String path = objectId == null
        ? 'classes/$className'
        : 'classes/$className/$objectId';
    Map<String, dynamic> queryParams = {};
    if (fetchWhenSave) {
      queryParams['fetchWhenSave'] = true;
    }
    if (query != null) {
      queryParams['where'] = query._buildWhere();
    }
    Map response = objectId == null
        ? await LeanCloud._httpClient.post(path,
            data: _LCEncoder.encode(_operationMap), queryParams: queryParams)
        : await LeanCloud._httpClient.put(path,
            data: _LCEncoder.encode(_operationMap), queryParams: queryParams);
    _LCObjectData data = _LCObjectData.decode(response);
    _merge(data);
    return this;
  }

  /// 批量保存 [objectList]
  static Future<List<LCObject>> saveAll(List<LCObject> objectList) async {
    if (objectList == null) {
      throw new ArgumentError.notNull('objectList');
    }
    // 断言没有循环依赖
    objectList.forEach((item) {
      if (_LCBatch.hasCircleReference(item, new HashSet<LCObject>())) {
        throw new ArgumentError('Found a circle dependency when save.');
      }
    });

    Queue<_LCBatch> batches = _LCBatch.batchObjects(objectList, true);
    await _saveBatches(batches);
    return objectList;
  }

  /// 删除
  Future delete() async {
    if (objectId == null) {
      return;
    }
    String path = 'classes/$className/$objectId';
    await LeanCloud._httpClient.delete(path);
  }

  /// 批量删除 [objectList]
  static Future deleteAll(List<LCObject> objectList) async {
    if (objectList == null || objectList.length == 0) {
      return;
    }
    Set<LCObject> objects = objectList.where((item) {
      return item.objectId != null;
    }).toSet();
    List requestList = objects.map((item) {
      String path = '/$APIVersion/classes/${item.className}/${item.objectId}';
      return {'path': path, 'method': 'DELETE'};
    }).toList();

    // 发送请求
    Map<String, dynamic> data = {
      'requests': _LCEncoder.encodeList(requestList)
    };
    await LeanCloud._httpClient.post('batch', data: data);
  }

  /// 子类化
  static Map<Type, _LCSubclassInfo> _subclassTypeMap =
      new Map<Type, _LCSubclassInfo>();
  static Map<String, _LCSubclassInfo> _subclassNameMap =
      new Map<String, _LCSubclassInfo>();

  /// 注册类名为 [className] 子类，其构造方法为 [constructor]
  static void registerSubclass<T extends LCObject>(
      String className, Function constructor) {
    _LCSubclassInfo subclassInfo =
        new _LCSubclassInfo(className, T, constructor);
    _subclassTypeMap[T] = subclassInfo;
    _subclassNameMap[className] = subclassInfo;
  }

  static LCObject _create(Type type, {String className}) {
    if (_subclassTypeMap.containsKey(type)) {
      _LCSubclassInfo subclassInfo = _subclassTypeMap[type];
      return subclassInfo.constructor();
    }
    return new LCObject(className);
  }

  static LCObject _createByName(String className) {
    if (_subclassNameMap.containsKey(className)) {
      _LCSubclassInfo subclassInfo = _subclassNameMap[className];
      return subclassInfo.constructor();
    }
    return new LCObject(className);
  }
}
