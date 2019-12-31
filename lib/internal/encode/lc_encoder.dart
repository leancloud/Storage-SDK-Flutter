part of leancloud_storage;

/// 编码工具类
class LCEncoder {
  static dynamic encode(dynamic object) {
    if (object is DateTime) {
      return encodeDateTime(object);
    }
    if (object is Uint8List) {
      return encodeBytes(object);
    }
    if (object is List) {
      encodeList(object);
    }
    if (object is Map) {
      encodeMap(object);
    }
    if (object is LCObject) {
      return encodeLCObject(object);
    }
    if (object is LCOperation) {
      return encodeOperation(object);
    }
    if (object is LCHttpRequest) {
      return encodeRequest(object);
    }
    return object;
  }

  static dynamic encodeDateTime(DateTime dateTime) {
    return {
        '__type': 'Date',
        // TODO 测试时间合法性
        'iso': dateTime.toIso8601String()
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

  static dynamic encodeOperation(LCOperation operation) {
    return operation.encode();
  }

  static dynamic encodeRequest(LCHttpRequest request) {
    return {
      'path': request.path,
      'method': request.method,
      'body': encodeMap(request.data)
    };
  }
}