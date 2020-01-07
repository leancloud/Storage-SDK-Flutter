part of leancloud_storage;

class LCAddUniqueOperation extends LCOperation {
  Set values;

  LCAddUniqueOperation(Iterable values) {
    this.values = Set.from(values);
  }

  @override
  apply(oldValue, String key) {
    List result = List.from(oldValue);
    result.addAll(values);
    return result;
  }

  @override
  encode() {
    return {
      '__op': 'AddUnique',
      'objects': LCEncoder.encodeList(values.toList())
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCAddOperation) {
      previousOp.valueList.addAll(values);
      return previousOp;
    }
    if (previousOp is LCAddUniqueOperation) {
      values.addAll(previousOp.values);
      return this;
    }
    // TODO 不支持的类型

    return null;
  }

  @override
  List<LCObject> getNewObjectList() {
    return values.toList();
  }
  
}