part of leancloud_storage;

class _LCDecrementOperation extends _LCOperation {
  num value;

  _LCDecrementOperation(this.value);

  @override
  apply(oldValue, String key) {
    if (oldValue == null) {
      return -value;
    }
    return oldValue - value;
  }

  @override
  encode() {
    return {'__op': 'Decrement', 'amount': value};
  }

  @override
  _LCOperation mergeWithPrevious(_LCOperation previousOp) {
    if (previousOp is _LCSetOperation || previousOp is _LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is _LCDecrementOperation) {
      value += previousOp.value;
      return this;
    }
    throw new ArgumentError('Operation is invalid after previous operation.');
  }

  @override
  List? getNewObjectList() {
    return null;
  }
}
