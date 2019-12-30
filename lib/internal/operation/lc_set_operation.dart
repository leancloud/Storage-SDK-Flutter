part of leancloud_storage;

/// 设置操作
class LCSetOperation extends LCOperation {
  dynamic value;

  LCSetOperation(this.value);

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    return this;
  }

  @override
  apply(String oldValue) {
    return value;
  }
}