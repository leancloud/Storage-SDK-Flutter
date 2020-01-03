part of leancloud_storage;

/// 解码工具类
class LCDecoder {
  static dynamic decode(dynamic data) {
    if (data is Map) {
      if (data.containsKey('__type')) {
        // 支持的内置类型
        var type = data['__type'];
        assert(type is String);
        if (type == 'Date') {
          return decodeDate(data['iso']);
        } else if (type == 'Bytes') {
          // Base64 解码
          return base64Decode(data['base64']);
        } else if (type == 'Object') {
          return decodeNestedObject(data);
        } else if (type == 'Pointer') {
          // 引用对象
          return decodeNestedObject(data);
        } else if (type == 'relation') {
          return decodeRelation(data);
        } else if (type == 'GeoPoint') {
          return decodePoint(data);
        }
      }
      // 普通的 Map 类型
      return data.map((key, value) {
        return new MapEntry(key, decode(value));
      });
    } else if (data is List) {
      return data.map((item) => decode(item)).toList();
    }
    return data;
  }

  static LCRelation decodeRelation(dynamic data) {
    // TODO 

    return new LCRelation();
  }

  /// 解码对象
  static LCObject decodeNestedObject(dynamic data) {
    String className = data['className'];
    LCObject object = LCObject.createByName(className);
    LCObjectData objectData = LCObjectData.decode(data);
    object._merge(objectData);
    return object;
  }

  /// 解码坐标
  static LCGeoPoint decodePoint(dynamic data) {
    double latitude = double.parse(data['latitude']);
    double longitude = double.parse(data['longitude']);
    return new LCGeoPoint(latitude, longitude);
  }

  /// 解码时间
  static DateTime decodeDate(dynamic data) {
    return DateTime.parse(data);
  }
}