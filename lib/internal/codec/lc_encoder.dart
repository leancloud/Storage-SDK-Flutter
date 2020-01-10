part of leancloud_storage;

/// 编码工具类
class _LCEncoder {
  static dynamic encode(dynamic object) {
    if (object is DateTime) {
      return encodeDateTime(object);
    }
    if (object is Uint8List) {
      return encodeBytes(object);
    }
    if (object is List) {
      return encodeList(object);
    }
    if (object is Map) {
      return encodeMap(object);
    }
    if (object is LCObject) {
      return encodeLCObject(object);
    }
    if (object is _LCOperation) {
      return encodeOperation(object);
    }
    if (object is _LCQueryCondition) {
      return object.toMap();
    }
    if (object is LCACL) {
      return encodeACL(object);
    }
    if (object is LCRelation) {
      return encodeRelation(object);
    }
    if (object is LCGeoPoint) {
      return encodeGeoPoint(object);
    }
    return object;
  }

  static dynamic encodeDateTime(DateTime dateTime) {
    return {
        '__type': 'Date',
        'iso': '${dateTime.year}-${dateTime.month}-${dateTime.day}T${dateTime.hour}:${dateTime.minute}:${dateTime.second}.${dateTime.millisecond}Z'
      };
  }

  static dynamic encodeBytes(Uint8List bytes) {
    return {
        '__type': 'Bytes',
        'base64': base64Encode(bytes)
      };
  }

  static dynamic encodeList(List list) {
    List l = new List();
    list.forEach((item) {
      l.add(encode(item));
    });
    return l;
  }

  static dynamic encodeMap(Map map) {
    Map m = new Map();
    map.forEach((key, value) {
      m[key] = encode(value);
    });
    return m;
  }

  static dynamic encodeLCObject(LCObject object) {
    return {
      '__type': 'Pointer',
      'className': object.className,
      'objectId': object.objectId
    };
  }

  static dynamic encodeOperation(_LCOperation operation) {
    return operation.encode();
  }

  static dynamic encodeACL(LCACL acl) {
    Set<String> readers = acl.readers;
    Set<String> writers = acl.writers;
    Set<String> union = readers.union(writers);
    Map<String, dynamic> result = new Map<String, dynamic>();
    union.forEach((item) {
      result[item] = {
        'read': readers.contains(item),
        'write': writers.contains(item)
      };
    });
    return result;
  }

  static dynamic encodeRelation(LCRelation relation) {
    return {
      '__type': 'Relation',
      'className': relation.targetClass
    };
  }

  static dynamic encodeGeoPoint(LCGeoPoint point) {
    return {
      '__type': 'GeoPoint',
      'latitude': point.latitude,
      'longitude': point.longitude
    };
  }
}