part of leancloud_storage;

/// Encoding
class _LCEncoder {
  static dynamic encode(dynamic object, {bool full = false}) {
    if (object is DateTime) {
      return encodeDateTime(object);
    }
    if (object is Uint8List) {
      return encodeBytes(object);
    }
    if (object is List) {
      return encodeList(object, full: full);
    }
    if (object is Map) {
      return encodeMap(object, full: full);
    }
    if (object is LCObject) {
      return encodeLCObject(object, full: full);
    }
    if (object is _LCOperation) {
      return encodeOperation(object);
    }
    if (object is _LCQueryCondition) {
      return object.encode();
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
    DateTime dt = dateTime.toUtc();
    return {'__type': 'Date', 'iso': toLCDateTimeString(dt)};
  }

  static dynamic encodeBytes(Uint8List bytes) {
    return {'__type': 'Bytes', 'base64': base64Encode(bytes)};
  }

  static dynamic encodeList(List list, {bool full: false}) {
    List l = [];
    list.forEach((item) {
      l.add(encode(item, full: full));
    });
    return l;
  }

  static dynamic encodeMap(Map map, {bool full: false}) {
    Map m = new Map();
    map.forEach((key, value) {
      m[key] = encode(value, full: full);
    });
    return m;
  }

  static dynamic encodeLCObject(LCObject object, {bool full: false}) {
    Map<String, dynamic> data = {
      '__type': 'Pointer',
      'className': object.className,
      'objectId': object.objectId
    };
    if (full) {
      if (object.createdAt != null) {
        data['createdAt'] = object.createdAt.toString();
      }
      if (object.updatedAt != null) {
        data['updatedAt'] = object.updatedAt.toString();
      }
      object._estimatedData.forEach((k, v) {
        data[k] = _LCEncoder.encode(v, full: full);
      });
    }
    return data;
  }

  static dynamic encodeOperation(_LCOperation operation) {
    return operation.encode();
  }

  static dynamic encodeACL(LCACL acl) {
    Set<String> keys = new Set<String>();
    if (acl.readAccess.length > 0) {
      keys = keys.union(Set.from(acl.readAccess.keys));
    }
    if (acl.writeAccess.length > 0) {
      keys = keys.union(Set.from(acl.writeAccess.keys));
    }
    Map<String, dynamic> result = new Map<String, dynamic>();
    keys.forEach((key) {
      Map access = {};
      if (acl.readAccess.containsKey(key)) {
        access['read'] = acl.readAccess[key];
      }
      if (acl.writeAccess.containsKey(key)) {
        access['write'] = acl.writeAccess[key];
      }
      result[key] = access;
    });
    return result;
  }

  static dynamic encodeRelation(LCRelation relation) {
    return {'__type': 'Relation', 'className': relation.targetClass};
  }

  static dynamic encodeGeoPoint(LCGeoPoint point) {
    return {
      '__type': 'GeoPoint',
      'latitude': point.latitude,
      'longitude': point.longitude
    };
  }
}
