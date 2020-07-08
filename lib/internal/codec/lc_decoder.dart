part of leancloud_storage;

/// Decoding
class _LCDecoder {
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
        } else if (type == 'Relation') {
          return decodeRelation(data);
        } else if (type == 'GeoPoint') {
          return decodePoint(data);
        } else if (type == 'File') {
          return decodeFile(data);
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
    LCRelation relation = new LCRelation();
    relation.targetClass = data['className'];
    return relation;
  }

  static LCObject decodeNestedObject(dynamic data) {
    String className = data['className'];
    LCObject object = LCObject._createByName(className);
    _LCObjectData objectData = _LCObjectData.decode(data);
    object._merge(objectData);
    return object;
  }

  static LCGeoPoint decodePoint(dynamic data) {
    double latitude = data['latitude'];
    double longitude = data['longitude'];
    return new LCGeoPoint(latitude, longitude);
  }

  static DateTime decodeDate(dynamic data) {
    return DateTime.parse(data).toLocal();
  }

  static LCFile decodeFile(dynamic data) {
    LCFile file = new LCFile();
    _LCObjectData objectData = _LCObjectData.decode(data);
    file._merge(objectData);
    return file;
  }

  static LCACL decodeACL(Map data) {
    LCACL acl = new LCACL();
    data.forEach((key, value) {
      Map access = value;
      if (access.containsKey('read')) {
        acl.readAccess[key] = access['read'];
      }
      if (access.containsKey('write')) {
        acl.writeAccess[key] = access['write'];
      }
    });
    return acl;
  }
}
