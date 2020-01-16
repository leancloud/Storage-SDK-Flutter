part of leancloud_storage;

/// 对象数据类
class _LCObjectData {
  String className;

  String objectId;

  DateTime createdAt;

  DateTime updatedAt;

  Map<String, dynamic> customPropertyMap;

  _LCObjectData() {
    customPropertyMap = new Map<String, dynamic>();
  }

  static _LCObjectData decode(Map<String, dynamic> data) {
    _LCObjectData result = new _LCObjectData();
    data.forEach((String key, dynamic value) {
      if (key == 'className') {
        result.className = value;
      } else if (key == 'objectId') {
        result.objectId = value;
      } else if (key == 'createdAt') {
        result.createdAt = DateTime.parse(value).toLocal();
      } else if (key == 'updatedAt') {
        result.updatedAt = DateTime.parse(value).toLocal();
      } else {
        // 自定义属性
        result.customPropertyMap[key] = _LCDecoder.decode(value);
      }
    });
    return result;
  }
}