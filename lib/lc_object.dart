part of leancloud_storage;

const String ClassNameKey = 'className';
const String ObjectIdKey = 'objectId';
const String CreatedAtKey = 'createdAt';
const String UpdatedAtKey = 'updatedAtKey';

/// 对象类
class LCObject {
  /// 最近一次与服务端同步的数据
  Map<String, dynamic> _serverData;
  
  /// 预算数据
  Map<String, dynamic> _estimatedData;

  /// 操作字典
  Map<String, LCOperation> _operationMap;

  /// 类名
  String get className => this[ClassNameKey];

  /// 对象 Id
  String get objectId => this[ObjectIdKey];

  /// 创建时间
  DateTime get createdAt => this[CreatedAtKey];

  /// 更新时间
  DateTime get updatedAt => this[UpdatedAtKey] ?? this[CreatedAtKey];

  LCObject(String className) {
    _serverData = new Map<String, dynamic>();
    _estimatedData = new Map<String, dynamic>(); 
    _operationMap = new Map<String, LCOperation>();
    
    _estimatedData[ClassNameKey] = className;
  }

  LCObject.createWithoutData(String className, String objectId) {

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
    _estimatedData.clear();
    _serverData.forEach((String key, dynamic value) {
      // TODO 对容器类型做一个拷贝
      _estimatedData[key] = value;
    });
    _operationMap.forEach((String key, LCOperation op) {
      _applyOperation(key, op);
    });
  }

  void _applyOperation(String key, LCOperation op) {
    // TODO 针对不同的操作做修改
    _estimatedData[key] = op.apply(_estimatedData[key]);
  }

  void _merge(Map<dynamic, dynamic> data) {
    data.forEach((key, value) {
      _serverData[key] = value;
    });
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

  /// 保存
  Future<LCObject> save() async {
    var path = objectId == null ? '/1.1/classes/$className' : '/1.1/classes/$className/$objectId';
    var method = objectId == null ? LCHttpRequestMethod.post : LCHttpRequestMethod.put;
    var request = new LCHttpRequest(path, method, _estimatedData);
    var response = await LeanCloud._client.send(request);
    var data = LCDecoder.decode(response);
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