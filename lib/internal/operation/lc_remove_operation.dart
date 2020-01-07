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
    // TODO 不支持的类型

    return null;
  }

  @override
  List getNewObjectList() {
    return null;
  }
  
}