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

  LCObject(String className) {
    assert(className != null && className.length > 0);
    _data = new LCObjectData();
    _estimatedData = new Map<String, dynamic>(); 
    _operationMap = new Map<String, LCOperation>();
    
    _data.className = className;
  }

  static LCObject createWithoutData(String className, String objectId) {
    LCObject object = new LCObject(className);
    assert(objectId != null && objectId.length > 0);
    object._data.objectId = objectId;
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
      _estimatedData[key] = op.apply(_estimatedData[key]);
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

  /// 保存
  Future<LCObject> save() async {
    var path = objectId == null ? '/1.1/classes/$className' : '/1.1/classes/$className/$objectId';
    var method = objectId == null ? LCHttpRequestMethod.post : LCHttpRequestMethod.put;
    var request = new LCHttpRequest(path, method, data: _estimatedData);
    var response = await LeanCloud._client.send(request);
    var data = LCObjectData.decode(response);
    _merge(data);
    return this;
  }

  /// 批量保存
  static Future<List<LCObject>> saveAll(List<LCObject> objectList) {

  }

  /// 删除
  Future<void> delete() {

  }
}