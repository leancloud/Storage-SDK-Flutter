part of leancloud_storage;

/// Deletion
class _LCDeleteOperation extends _LCOperation {
  static const String OP = 'Delete';

  @override
  _LCOperation mergeWithPrevious(_LCOperation previousOp) {
    return this;
  }

  @override
  encode() {
    return {'__op': OP};
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
