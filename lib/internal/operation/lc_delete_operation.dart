part of leancloud_storage;

/// Deletion
class _LCDeleteOperation extends _LCOperation {
  @override
  _LCOperation mergeWithPrevious(_LCOperation previousOp) {
    return this;
  }

  @override
  encode() {
    return {'__op': 'Delete'};
  }

  @override
  apply(dynamic oldValue, String key) {
    return null;
  }

  @override
  List? getNewObjectList() {
    return null;
  }
}
