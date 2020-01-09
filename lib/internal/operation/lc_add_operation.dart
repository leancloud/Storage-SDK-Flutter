part of leancloud_storage;

class LCAddOperation extends LCOperation {
  List valueList;

  LCAddOperation(Iterable values) {
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
      'objects': LCEncoder.encodeList(valueList)
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCAddOperation) {
      valueList.addAll(previousOp.valueList);
      return this;
    }
    if (previousOp is LCAddUniqueOperation) {
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