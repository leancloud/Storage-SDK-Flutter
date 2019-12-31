part of leancloud_storage;

/// 设置操作
class LCDeleteOperation extends LCOperation {
  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    return this;
  }

  @override
  encode() {
    return { '__op': 'Delete' };
  }

  @override
  apply(dynamic oldValue, String key) {
    return null;
  }
}