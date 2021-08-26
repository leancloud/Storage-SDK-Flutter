part of leancloud_storage;

/// LeanCloud object data.
class _LCObjectData {
  String? className;

  String? objectId;

  DateTime? createdAt;

  DateTime? updatedAt;

  late Map<String, dynamic> customPropertyMap;

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
        if (key == 'ACL' && value is Map) {
          result.customPropertyMap[key] = _LCDecoder.decodeACL(value);
        } else {
          // 自定义属性
          result.customPropertyMap[key] = _LCDecoder.decode(value);
        }
      }
    });
    return result;
  }
}
