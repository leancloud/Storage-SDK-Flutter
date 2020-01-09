part of leancloud_storage;

class LCRemoveOperation extends LCOperation {
  List valueList;

  LCRemoveOperation(Iterable values) {
    valueList = List.from(values);
  }

  @override
  apply(oldValue, String key) {
    List result = List.from(oldValue);
    valueList.forEach((item) {
      result.remove(item);
    });
    return result;
  }

  @override
  encode() {
    return {
      '__op': 'Remove',
      'objects': LCEncoder.encodeList(valueList)
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCRemoveOperation) {
      valueList.addAll(previousOp.valueList);
      return this;
    }
    throw new ArgumentError('Operation is invalid after previous operation.');
  }

  @override
  List getNewObjectList() {
    return null;
  }
}