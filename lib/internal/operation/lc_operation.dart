part of leancloud_storage;

/// [LCObject] Operation
abstract class _LCOperation {
  // 与前一个操作做合并
  _LCOperation mergeWithPrevious(_LCOperation previousOp);

  dynamic encode();

  // 计算值
  dynamic apply(dynamic oldValue, String key);

  // 得到增加的对象
  List? getNewObjectList();

  static _LCOperation decode(dynamic data) {
    if (!(data is Map) || !data.containsKey('__op')) {
      // set
      return new _LCSetOperation(_LCDecoder.decode(data));
    }
    String op = data['__op'];
    switch (op) {
      case _LCAddOperation.OP:
        return new _LCAddOperation(_LCDecoder.decode(data['objects']));
      case _LCAddRelationOperation.OP:
        return new _LCAddRelationOperation(_LCDecoder.decode(data['objects']));
      case _LCAddUniqueOperation.OP:
        return new _LCAddUniqueOperation(_LCDecoder.decode(data['objects']));
      case _LCDecrementOperation.OP:
        return new _LCDecrementOperation(data['amount']);
      case _LCDeleteOperation.OP:
        return new _LCDeleteOperation();
      case _LCIncrementOperation.OP:
        return new _LCIncrementOperation(data['amount']);
      case _LCRemoveOperation.OP:
        return new _LCRemoveOperation(_LCDecoder.decode(data['objects']));
      case _LCRemoveRelationOperation.OP:
        return new _LCRemoveRelationOperation(data['objects']);
      default:
        throw ('Error operation: ${jsonEncode(data)}');
    }
  }
}
