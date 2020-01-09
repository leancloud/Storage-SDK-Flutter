part of leancloud_storage;

class LCIncrementOperation extends LCOperation {
  num value;

  LCIncrementOperation(this.value);

  @override
  apply(oldValue, String key) {
    return oldValue + value;
  }

  @override
  encode() {
    return {
      '__op': 'Increment',
      'amount': value
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCIncrementOperation) {
      value += previousOp.value;
      return this;
    }
    throw new ArgumentError('Operation is invalid after previous operation.');
  }

  @override
  List getNewObjectList() {
    return null;
  }

}