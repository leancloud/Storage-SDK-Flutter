part of leancloud_storage;

/// 设置操作
class LCDeleteOperation extends LCOperation {
  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    return this;
  }

  @override
  apply(String oldValue) {
    return null;
  }
}