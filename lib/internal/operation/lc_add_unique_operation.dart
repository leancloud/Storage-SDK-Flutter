part of leancloud_storage;

class LCAddUniqueOperation extends LCOperation {
  Set values;

  LCAddUniqueOperation(Iterable values) {
    this.values = Set.from(values);
  }

  @override
  apply(oldValue, String key) {
    Set result = Set.from(oldValue);
    result = result.union(values);
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
    if (previousOp is LCAddUniqueOperation) {
      values = values.union(previousOp.values);
      return this;
    }
    throw new ArgumentError('Operation is invalid after previous operation.');
  }

  @override
  List getNewObjectList() {
    return values.toList();
  }
  
}