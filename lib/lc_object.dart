part of leancloud_storage;

/// 对象类
class LCObject {
  /// 最近一次与服务端同步的数据
  LCObjectData _data;
  
  /// 预算数据
  Map<String, dynamic> _estimatedData;

  /// 操作字典
  Map<String, LCOperation> _operationMap;

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

  bool get isDirty => _isNew || _estimatedData.length > 0;

  bool _isNew;

  LCObject(String className) {
    assert(className != null && className.length > 0);
    _data = new LCObjectData();
    _estimatedData = new Map<String, dynamic>(); 
    _operationMap = new Map<String, LCOperation>();
    
    _data.className = className;
    _isNew = true;
  }

  static LCObject createWithoutData(String className, String objectId) {
    LCObject object = new LCObject(className);
    assert(objectId != null && objectId.length > 0);
    object._data.objectId = objectId;
    object._isNew = false;
    return object;
  }

  operator [](String key) {
    dynamic value = _estimatedData[key];
    if (value is LCRelation) {
      // 反序列化后的 Relation 字段并不完善
      value.key = key;
      value.parent = this;
    }
    return value;
  }

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
    LCSetOperation op = new LCSetOperation(value);
    _applyOperation(key, op);
  }

  void addRelation(String key, LCObject value) {
    LCAddRelationOperation op = new LCAddRelationOperation();
    op.valueList.add(value);
    if (_operationMap.containsKey(key)) {
      LCOperation previousOp = _operationMap[key];
      _operationMap[key] = op.mergeWithPrevious(previousOp);
    } else {
      _operationMap[key] = op;
    }
    _applyOperation(key, op);
  }

  void removeRelation(String key, LCObject value) {
    LCRemoveRelationOperation op = new LCRemoveRelationOperation();
    op.valueList.add(value);
    if (_operationMap.containsKey(key)) {
      LCOperation previousOp = _operationMap[key];
      _operationMap[key] = op.mergeWithPrevious(previousOp);
    } else {
      _operationMap[key] = op;
    }
    _applyOperation(key, op);
  }

  /// 增加数字属性值
  void increment(String key, num amount) {
    LCIncrementOperation op = new LCIncrementOperation(amount);
    _applyOperation(key, op);
  }

  /// 减少数字属性值
  void decrement(String key, num amount) {
    LCDecrementOperation op = new LCDecrementOperation(amount);
    _applyOperation(key, op);
  }

  /// 在数组属性中增加一个元素
  void add(String key, dynamic value) {
    LCAddOperation op = new LCAddOperation([value]);
    _applyOperation(key, op);
  }

  /// 在数组属性中增加一组元素
  void addAll(String key, Iterable values) {
    LCAddOperation op = new LCAddOperation(values);
    _applyOperation(key, op);
  }

  /// 在数组属性中增加一个唯一元素
  void addUnique(String key, dynamic value) {
    LCAddUniqueOperation op = new LCAddUniqueOperation([value]);
    _applyOperation(key, op);
  }

  /// 在数组属性中增加一组唯一元素
  void addAllUnique(String key, Iterable values) {
    LCAddUniqueOperation op = new LCAddUniqueOperation(values);
    _applyOperation(key, op);
  }

  /// 移除某个元素
  void remove(String key, dynamic value) {
    LCRemoveOperation op = new LCRemoveOperation([value]);
    _applyOperation(key, op);
  }

  /// 移除一组元素
  void removeAll(String key, Iterable values) {
    LCRemoveOperation op = new LCRemoveOperation(values);
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

  void _applyOperation(String key, LCOperation op) {
    if (_operationMap.containsKey(key)) {
      LCOperation previousOp = _operationMap[key];
      _operationMap[key] = op.mergeWithPrevious(previousOp);
    } else {
      _operationMap[key] = op;
    }
    if (op is LCDeleteOperation) {
      _estimatedData.remove(key);
    } else {
      _estimatedData[key] = op.apply(_estimatedData[key], key);
    }
  }

  void _merge(LCObjectData data) {
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

  /// 拉取
  Future<LCObject> fetch({ Iterable<String> keys, Iterable<String> includes }) async {
    Map<String, dynamic> queryParams = {};
    if (keys != null) {
      queryParams['keys'] = keys.join(',');
    }
    if (includes != null) {
      queryParams['include'] = includes.join(',');
    }
    String path = 'classes/$className/$objectId';
    Map response = await LeanCloud._httpClient.get(path, queryParams: queryParams);
    LCObjectData objectData = LCObjectData.decode(response);
    _merge(objectData);
    return this;
  }

  static Future _saveBatches(Queue<LCBatch> batches) async {
    while (batches.length > 0) {
      LCBatch batch = batches.removeLast();
      List<LCObject> dirtyObjects = batch.objects.where((item) {
        return item.isDirty;
      }).toList();

      // 生成请求列表
      List requestList = dirtyObjects.map((item) {
        String path = item.objectId == null ? 
          '/1.1/classes/${item.className}' : '/1.1/classes/${item.className}/${item.objectId}';
        String method = item.objectId == null ?
          'POST' : 'PUT';
        Map body = LCEncoder.encode(item._operationMap);
        return {
          'path': path,
          'method': method,
          'body': body
        };
      }).toList();

      // 发送请求
      Map<String, dynamic> data = {
        'requests': LCEncoder.encodeList(requestList)
      };
      List results = await LeanCloud._httpClient.post('batch', data: data);
      // 反序列化为 Object 数据
      List<LCObjectData> resultList = results.map((item) {
        if (item.containsKey('error')) {
          throw new Error();
        }
        return LCObjectData.decode(item['success']);
      }).toList();
      for (int i = 0; i < dirtyObjects.length; i++) {
        LCObject object = dirtyObjects[i];
        LCObjectData objectData = resultList[i];
        object._merge(objectData);
      }
    }
  }

  /// 保存
  Future<LCObject> save() async {
    // 检测循环依赖
    if (LCBatch.hasCircleReference(this, new HashSet<LCObject>())) {
      throw new ArgumentError('Found a circle dependency when save.');
    }

    // 保存对象依赖
    Queue<LCBatch> batches = LCBatch.batchObjects([this], false);
    if (batches.length > 0) {
      await _saveBatches(batches);
    }

    // 保存对象本身
    String path = objectId == null ? 'classes/$className' : 'classes/$className/$objectId';
    Map response = objectId == null ? 
      await LeanCloud._httpClient.post(path, data: LCEncoder.encode(_operationMap)) :
      await LeanCloud._httpClient.put(path, data: LCEncoder.encode(_operationMap));
    LCObjectData data = LCObjectData.decode(response);
    _merge(data);
    return this;
  }

  /// 批量保存
  static Future<List<LCObject>> saveAll(List<LCObject> objectList) async {
    assert(objectList != null);
    // 断言没有循环依赖
    objectList.forEach((item) {
      assert(!LCBatch.hasCircleReference(item, new HashSet<LCObject>()));
    });

    Queue<LCBatch> batches = LCBatch.batchObjects(objectList, true);
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

  /// 批量删除
  static Future deleteAll(List<LCObject> objectList) async {
    if (objectList == null || objectList.length == 0) {
      return;
    }
    Set<LCObject> objects = objectList.where((item) {
      return item.objectId != null;
    }).toSet();
    List requestList = objects.map((item) {
      String path = 'classes/${item.className}/${item.objectId}';
      return {
        'path': path,
        'method': 'DELETE'
      };
    }).toList();
    
    // 发送请求
    Map<String, dynamic> data = {
      'requests': LCEncoder.encodeList(requestList)
    };
    await LeanCloud._httpClient.post('batch', data: data);
  }


  /// 子类化
  static Map<Type, LCSubclassInfo> subclassTypeMap = new Map<Type, LCSubclassInfo>();
  static Map<String, LCSubclassInfo> subclassNameMap = new Map<String, LCSubclassInfo>();

  /// 注册子类
  static void registerSubclass<T extends LCObject>(String className, Function constructor) {
    LCSubclassInfo subclassInfo = new LCSubclassInfo(className, T, constructor);
    subclassTypeMap[T] = subclassInfo;
    subclassNameMap[className] = subclassInfo;
  }

  static LCObject _create(Type type, { String className }) {
    if (subclassTypeMap.containsKey(type)) {
      LCSubclassInfo subclassInfo = subclassTypeMap[type];
      return subclassInfo.constructor();
    }
    return new LCObject(className);
  }

  static LCObject _createByName(String className) {
    if (subclassNameMap.containsKey(className)) {
      LCSubclassInfo subclassInfo = subclassNameMap[className];
      return subclassInfo.constructor();
    }
    return new LCObject(className);
  }
}