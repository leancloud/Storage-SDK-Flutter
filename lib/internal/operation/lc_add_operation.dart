part of leancloud_storage;

class _LCAddOperation extends _LCOperation {
  List valueList;

  _LCAddOperation(Iterable values) {
    valueList = List.from(values);
  }

  @override
  apply(oldValue, String key) {
    List result = List.from(oldValue);
    result.addAll(valueList);
    return result;
  }

  @override
  encode() {
    return {
      '__op': 'Add',
      'objects': _LCEncoder.encodeList(valueList)
    };
  }

  @override
  _LCOperation mergeWithPrevious(_LCOperation previousOp) {
    if (previousOp is _LCSetOperation || previousOp is _LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is _LCAddOperation) {
      valueList.addAll(previousOp.valueList);
      return this;
    }
    if (previousOp is _LCAddUniqueOperation) {
      valueList.addAll(previousOp.values);
      return this;
    }
    throw new ArgumentError('Operation is invalid after previous operation.');
  }

  @override
  List getNewObjectList() {
    return valueList;
  }
  
}