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

  static Map<String, dynamic> encode(_LCObjectData objectData) {
    if (objectData == null) {
      return null;
    }
    Map<String, dynamic> data = {'className': objectData.className};
    if (objectData.objectId != null) {
      data['objectId'] = objectData.objectId;
    }
    if (objectData.createdAt != null) {
      data['createdAt'] = objectData.createdAt.toString();
    }
    if (objectData.updatedAt != null) {
      data['updatedAt'] = objectData.updatedAt.toString();
    }
    if (objectData.customPropertyMap != null) {
      objectData.customPropertyMap.forEach((k, v) {
        data[k] = _LCEncoder.encode(v);
      });
    }
    return data;
  }
}
