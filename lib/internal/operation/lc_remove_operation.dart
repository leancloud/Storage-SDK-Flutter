part of leancloud_storage;

class _LCRemoveOperation extends _LCOperation {
  late List valueList;

  _LCRemoveOperation(Iterable values) {
    valueList = List.from(values);
  }

  @override
  apply(oldValue, String key) {
    List result = oldValue != null ? List.from(oldValue) : [];
    valueList.forEach((item) {
      result.remove(item);
    });
    return result;
  }

  @override
  encode() {
    return {'__op': 'Remove', 'objects': _LCEncoder.encodeList(valueList)};
  }

  @override
  _LCOperation mergeWithPrevious(_LCOperation previousOp) {
    if (previousOp is _LCSetOperation || previousOp is _LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is _LCRemoveOperation) {
      List list = List.from(previousOp.valueList);
      list.addAll(valueList);
      valueList = list;
      return this;
    }
    throw new ArgumentError('Operation is invalid after previous operation.');
  }

  @override
  List? getNewObjectList() {
    return null;
  }
}
