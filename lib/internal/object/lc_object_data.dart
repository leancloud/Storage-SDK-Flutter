part of leancloud_storage;

/// 对象数据类
class LCObjectData {
  String className;

  String objectId;

  DateTime createdAt;

  DateTime updatedAt;

  Map<String, dynamic> customPropertyMap;

  static LCObjectData decode(Map<String, dynamic> data) {
    LCObjectData result = new LCObjectData();
    data.forEach((String key, dynamic value) {
      if (key == 'className') {
        result.className = value;
      } else if (key == 'objectId') {
        result.objectId = value;
      } else if (key == 'createdAt') {
        result.createdAt = DateTime.parse(value);
      } else if (key == 'updatedAt') {
        result.updatedAt = DateTime.parse(value);
      } else {
        // 自定义属性
        result.customPropertyMap[key] = value;
      }
    });
    return result;
  }
}