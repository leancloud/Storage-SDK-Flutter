part of leancloud_storage;

/// LeanCloud Object
///
/// Object is also called Record (in traditional relational databases)
/// or Document (in some NoSQL databases).
class LCObject {
  /// The last known data for this object from cloud.
  late _LCObjectData _data;

  /// The best estimate of this's current data.
  late Map<String, dynamic> _estimatedData;

  /// List of sets of changes to the data.
  late Map<String, _LCOperation> _operationMap;

  /// The class name of the object.
  ///
  /// Class is also called Table (in traditional relational databases)
  /// or Collection (in some NoSQL databases).
  String? get className => _data.className;

  /// Gets the object's objectId.
  String? get objectId => _data.objectId;

  /// Gets the object's createdAt attribute.
  DateTime? get createdAt => _data.createdAt;

  /// Gets the object's updatedAt attribute.
  DateTime? get updatedAt => _data.updatedAt ?? _data.createdAt;

  /// Gets the ACL for this object.
  LCACL? get acl => this['ACL'];

  /// Sets the ACL to be used for this object.
  set acl(LCACL? value) => this['ACL'] = value!;

  /// If this object has been modified since its last save/refresh.
  late bool _isDirty;

  /// Creates a new object in [className].
  LCObject(String className) {
    assert(className.length > 0);
    _data = new _LCObjectData();
    _estimatedData = new Map<String, dynamic>();
    _operationMap = new Map<String, _LCOperation>();
    _isDirty = true;
    _data.className = className;
  }

  /// Constructs a object in [className] of [objectId].
  ///
  /// The object corresponding to the [objectId] specified must already exists on the cloud.
  static LCObject createWithoutData(String className, String objectId) {
    if (isNullOrEmpty(className)) {
      throw ArgumentError.notNull(className);
    }
    if (isNullOrEmpty(objectId)) {
      throw ArgumentError.notNull(objectId);
    }
    LCObject object = _createByName(className);
    object._data.objectId = objectId;
    object._isDirty = false;
    return object;
  }

  /// Gets the value of [key].
  operator [](String key) {
    dynamic value = _estimatedData[key];
    if (value is LCRelation) {
      // 反序列化后的 Relation 字段并不完善
      value.key = key;
      value.parent = this;
    }
    return value;
  }

  /// Sets [key] to [value].
  operator []=(String key, dynamic value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull(key);
    }
    if (key.startsWith('_')) {
      throw new ArgumentError('key should not start with \'_\'');
    }
    if (key == 'objectId' ||
        key == 'createdAt' ||
        key == 'updatedAt' ||
        key == 'className') {
      throw new ArgumentError('$key is reserved by LeanCloud');
    }
    _LCSetOperation op = new _LCSetOperation(value);
    _applyOperation(key, op);
  }

  /// Removes the [key].
  ///
  /// This is a noop if the [key] does not exist.
  void unset(String key) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCDeleteOperation op = new _LCDeleteOperation();
    _applyOperation(key, op);
  }

  /// Adds a relation [value] to [key].
  void addRelation(String key, LCObject value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCAddRelationOperation op = new _LCAddRelationOperation(value);
    _applyOperation(key, op);
  }

  /// Removes relation [value] to [key].
  void removeRelation(String key, LCObject value) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCRemoveRelationOperation op = new _LCRemoveRelationOperation(value);
    _applyOperation(key, op);
  }

  /// Atomically increments the value of the given [key] with [amount].
  void increment(String key, num amount) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCIncrementOperation op = new _LCIncrementOperation(amount);
    _applyOperation(key, op);
  }

  /// Atomically decrements the value of the given [key] with [amount].
  void decrement(String key, num amount) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCDecrementOperation op = new _LCDecrementOperation(amount);
    _applyOperation(key, op);
  }

  /// Atomically add [value] to the end of the array [key].
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

  /// Atomically add [values] to the end of the array [key].
  void addAll(String key, Iterable values) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCAddOperation op = new _LCAddOperation(values);
    _applyOperation(key, op);
  }

  /// Atomically add [value] to the array [key], only if not already present.
  ///
  /// The position of the insert is not guaranteed.
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

  /// Atomically add [values] to the array [key], only if not already present.
  ///
  /// The position of the insert is not guaranteed.
  void addAllUnique(String key, Iterable values) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCAddUniqueOperation op = new _LCAddUniqueOperation(values);
    _applyOperation(key, op);
  }

  /// Atomically remove all [value] from the array [key].
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

  /// Atomically remove all [values] from the array [key].
  void removeAll(String key, Iterable values) {
    if (isNullOrEmpty(key)) {
      throw ArgumentError.notNull('key');
    }
    _LCRemoveOperation op = new _LCRemoveOperation(values);
    _applyOperation(key, op);
  }

  /// Refreshes the attributes.
  ///
  /// This populates attributes by starting with the last known data from the
  /// server, and applying all of the local changes that have been made since
  /// then.
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
      _LCOperation? previousOp = _operationMap[key];
      _operationMap[key] = op.mergeWithPrevious(previousOp!);
    } else {
      _operationMap[key] = op;
    }
    _isDirty = true;
  }

  void _merge(_LCObjectData? data) {
    if (data == null) {
      return;
    }
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
    _isDirty = false;
  }

  /// Fetches the object from the cloud.
  ///
  /// Can also specifies which [keys] to fetch,
  /// and if this [includes] pointed objects.
  Future<LCObject> fetch(
      {Iterable<String>? keys, Iterable<String>? includes}) async {
    Map<String, dynamic> queryParams = {};
    if (keys != null) {
      queryParams['keys'] = keys.join(',');
    }
    if (includes != null) {
      queryParams['include'] = includes.join(',');
    }
    String path = 'classes/$className/$objectId';
    Map<String, dynamic> response =
        await LeanCloud._httpClient.get(path, queryParams: queryParams);
    _LCObjectData objectData = _LCObjectData.decode(response);
    _merge(objectData);
    return this;
  }

  /// Fetches all objects in [objectList].
  static Future<List<LCObject>> fetchAll(List<LCObject> objectList) async {
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
      Map<String, dynamic> data = item['success'];
      map[data['objectId']] = _LCObjectData.decode(data);
    });
    objectList.forEach((object) {
      _LCObjectData? objectData = map[object.objectId];
      object._merge(objectData);
    });
    return objectList;
  }

  static Future _saveBatches(Queue<_LCBatch> batches) async {
    while (batches.length > 0) {
      _LCBatch batch = batches.removeLast();

      // 特殊处理 File 依赖
      List<LCObject> dirtyFiles = batch.objects.where((item) {
        return item is LCFile && item._isDirty;
      }).toList();
      for (LCObject file in dirtyFiles) {
        await file.save();
      }

      List<LCObject> dirtyObjects = batch.objects.where((item) {
        return item._isDirty;
      }).toList();

      if (dirtyObjects.length == 0) {
        continue;
      }

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
          String message = item['error'].toString();
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

  /// Saves the object to the cloud.
  ///
  /// Can also specify whether to [fetchWhenSave],
  /// or only saving the object when it matches the [query].
  Future<LCObject> save(
      {bool fetchWhenSave = false, LCQuery<LCObject>? query}) async {
    // 检测循环依赖
    if (_LCBatch.hasCircleReference(this)) {
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
    Map<String, dynamic> response = objectId == null
        ? await LeanCloud._httpClient.post(path,
            data: _LCEncoder.encode(_operationMap), queryParams: queryParams)
        : await LeanCloud._httpClient.put(path,
            data: _LCEncoder.encode(_operationMap), queryParams: queryParams);
    _LCObjectData data = _LCObjectData.decode(response);
    _merge(data);
    return this;
  }

  /// Saves all objects in [objectList].
  static Future<List<LCObject>> saveAll(List<LCObject> objectList) async {
    // 断言没有循环依赖
    objectList.forEach((item) {
      if (_LCBatch.hasCircleReference(item)) {
        throw new ArgumentError('Found a circle dependency when save.');
      }
    });

    Queue<_LCBatch> batches = _LCBatch.batchObjects(objectList, true);
    await _saveBatches(batches);
    return objectList;
  }

  /// Deletes this object.
  Future delete() async {
    if (objectId == null) {
      return;
    }
    String path = 'classes/$className/$objectId';
    await LeanCloud._httpClient.delete(path);
  }

  /// Serializes this [LCObject] to a JSON string.
  String toString() {
    if (_LCBatch.hasCircleReference(this)) {
      throw new ArgumentError('Found a circle dependency when serialize.');
    }
    return jsonEncode(_LCEncoder.encode(this, full: true));
  }

  /// The inverse function of [toString].
  static LCObject parseObject(String str) {
    _LCObjectData objectData = _LCObjectData.decode(jsonDecode(str));
    LCObject object = _createByName(objectData.className!);
    object._merge(objectData);
    return object;
  }

  /// Delete all objects in [objectList].
  static Future deleteAll(List<LCObject> objectList) async {
    if (objectList.length == 0) {
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

  /// Subclass of [LCObject].
  static Map<Type, _LCSubclassInfo> _subclassTypeMap =
      new Map<Type, _LCSubclassInfo>();
  static Map<String, _LCSubclassInfo> _subclassNameMap =
      new Map<String, _LCSubclassInfo>();

  /// Registers a subclass named [className] with [constructor].
  static void registerSubclass<T extends LCObject>(
      String className, Function constructor) {
    _LCSubclassInfo subclassInfo =
        new _LCSubclassInfo(className, T, constructor);
    _subclassTypeMap[T] = subclassInfo;
    _subclassNameMap[className] = subclassInfo;
  }

  static T _create<T>(String className) {
    return _subclassTypeMap.containsKey(T)
        ? _subclassTypeMap[T]!.constructor()
        : new LCObject(className);
  }

  static LCObject _createByName(String className) {
    return _subclassNameMap.containsKey(className)
        ? _subclassNameMap[className]!.constructor()
        : new LCObject(className);
  }
}
