part of leancloud_storage;

const String ClassNameKey = 'className';
const String ObjectIdKey = 'objectId';
const String CreatedAtKey = 'createdAt';
const String UpdatedAtKey = 'updatedAtKey';

const String ACLKey = 'ACL';

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

  /// 访问权限
  LCACL get ACL => this[ACLKey];

  /// TODO 还需要增加「新建对象」的情况
  bool get isDirty => isNew || _estimatedData.length > 0;

  bool isNew;

  LCObject(String className) {
    assert(className != null && className.length > 0);
    _data = new LCObjectData();
    _estimatedData = new Map<String, dynamic>(); 
    _operationMap = new Map<String, LCOperation>();
    
    _data.className = className;
    isNew = true;
  }

  static LCObject createWithoutData(String className, String objectId) {
    LCObject object = new LCObject(className);
    assert(objectId != null && objectId.length > 0);
    object._data.objectId = objectId;
    object.isNew = false;
    return object;
  }

  operator [](String key) => _estimatedData[key];

  operator []=(String key, dynamic value) {
    // TODO 判断是否是保留字段

    LCSetOperation op = new LCSetOperation(value);
    if (_operationMap.containsKey(key)) {
      LCOperation previousOp = _operationMap[key];
      _operationMap[key] = op.mergeWithPrevious(previousOp);
    } else {
      _operationMap[key] = op;
    }
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
    // TODO 针对不同的操作做修改
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
  }

  Map<String, dynamic> decode(Map<String, dynamic> data) {
    Map<String, dynamic> result = new Map<String, dynamic>();
    data.forEach((String key, dynamic value) {
      if (key == 'createdAt' || key == 'updatedAt') {
        result[key] = DateTime.parse(value);
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  /// 拉取
  Future<LCObject> fetch() async {
    return this;
  }

  static Future<void> saveBatches(Queue<Batch> batches) async {
    while (batches.length > 0) {
      Batch batch = batches.removeLast();
      List<LCObject> dirtyObjects = batch.objects.where((item) {
        return item.isDirty;
      }).toList();

      // 生成请求列表
      List<LCHttpRequest> requestList = new List<LCHttpRequest>();
      dirtyObjects.forEach((item) {
        requestList.add(item.getRequest());
      });

      // 发送请求
      Map<String, dynamic> data = {
        'requests': LCEncoder.encodeList(requestList)
      };
      LCHttpRequest request = new LCHttpRequest('/1.1/batch', LCHttpRequestMethod.post, data: data);
      List<dynamic> results = await LeanCloud._client.send<List<dynamic>>(request);
      List<LCObjectData> objectDataList = new List<LCObjectData>();
      results.forEach((item) {
        if (item.containsKey('success')) {
          objectDataList.add(LCObjectData.decode(item['success']));
        } else {
          // TODO 保存错误

        }
      });

      // 刷新数据
      assert(dirtyObjects.length == objectDataList.length);
      for (int i = 0; i < dirtyObjects.length; i++) {
        LCObject object = dirtyObjects[i];
        LCObjectData objectData = objectDataList[i];
        object._merge(objectData);
      }
    }
  }

  LCHttpRequest getRequest() {
    var path = objectId == null ? 'classes/$className' : 'classes/$className/$objectId';
    var method = objectId == null ? LCHttpRequestMethod.post : LCHttpRequestMethod.put;
    return new LCHttpRequest(path, method, data: _estimatedData);
  }

  /// 保存
  Future<LCObject> save() async {
    // 断言没有循环依赖
    assert(!Batch.hasCircleReference(this, new HashSet<LCObject>()));

    // 保存对象依赖
    Queue<Batch> batches = Batch.batchObjects([this], false);
    await saveBatches(batches);

    // 保存对象本身
    LCHttpRequest request = getRequest();
    Map<String, dynamic> response = await LeanCloud._client.send<Map<String, dynamic>>(request);
    LCObjectData data = LCObjectData.decode(response);
    _merge(data);
    return this;
  }

  /// 批量保存
  static Future<List<LCObject>> saveAll(List<LCObject> objectList) async {
    assert(objectList != null);
    // 断言没有循环依赖
    objectList.forEach((item) {
      assert(!Batch.hasCircleReference(item, new HashSet<LCObject>()));
    });

    Queue<Batch> batches = Batch.batchObjects(objectList, true);
    await saveBatches(batches);
    return objectList;
  }

  /// 删除
  Future<void> delete() async {
    if (objectId == null) {
      return;
    }
    String path = 'classes/$className/$objectId';
    String method = LCHttpRequestMethod.delete;
    LCHttpRequest request = new LCHttpRequest(path, method);
    await LeanCloud._client.send(request);
  }

  /// 批量删除
  static Future<void> deleteAll(List<LCObject> objectList) async {
    if (objectList == null || objectList.length == 0) {
      return;
    }
    Set<LCObject> objects = objectList.where((item) {
      return item.objectId != null;
    }).toSet();
    List<LCHttpRequest> requests = objects.map((item) {
      String path = 'classes/${item.className}/${item.objectId}';
      String method = LCHttpRequestMethod.delete;
      return new LCHttpRequest(path, method);
    }).toList();
    
    // 发送请求
    Map<String, dynamic> data = {
      'requests': LCEncoder.encodeList(requests)
    };
    LCHttpRequest request = new LCHttpRequest('batch', LCHttpRequestMethod.post, data: data);
    await LeanCloud._client.send<List<dynamic>>(request);
  }


  /// 子类化
  static Map<Type, SubclassInfo> subclassTypeMap = new Map<Type, SubclassInfo>();
  static Map<String, SubclassInfo> subclassNameMap = new Map<String, SubclassInfo>();

  /// 注册子类
  static void registerSubclass<T extends LCObject>(String className, Function constructor) {
    SubclassInfo subclassInfo = new SubclassInfo(className, T, constructor);
    subclassTypeMap[T] = subclassInfo;
    subclassNameMap[className] = subclassInfo;
  }

  static LCObject create(Type type, { String className }) {
    if (subclassTypeMap.containsKey(type)) {
      SubclassInfo subclassInfo = subclassTypeMap[type];
      return subclassInfo.constructor(subclassInfo.className);
    }
    return new LCObject(className);
  }
}