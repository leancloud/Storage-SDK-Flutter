part of leancloud_storage;

/// Set Operation
class _LCSetOperation extends _LCOperation {
  dynamic value;

  _LCSetOperation(this.value);

  @override
  _LCOperation mergeWithPrevious(_LCOperation previousOp) {
    return this;
  }

  @override
  encode() {
    return _LCEncoder.encode(value);
  }

  @override
  apply(dynamic oldValue, String key) {
    return value;
  }

  @override
  List? getNewObjectList() {
    if (value is List) {
      return List.from(value);
    }
    return [value];
  }
}
