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
  encode() {
    return LCEncoder.encode(value);
  }

  @override
  apply(dynamic oldValue, String key) {
    return value;
  }

  @override
  List<LCObject> getNewObjectList() {
    return List.from(value);
  }
}