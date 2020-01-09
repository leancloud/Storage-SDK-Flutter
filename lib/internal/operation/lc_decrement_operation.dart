part of leancloud_storage;

class LCDecrementOperation extends LCOperation {
  num value;

  LCDecrementOperation(this.value);

  @override
  apply(oldValue, String key) {
    return oldValue - value;
  }

  @override
  encode() {
    return {
      '__op': 'Decrement',
      'amount': value
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCDecrementOperation) {
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