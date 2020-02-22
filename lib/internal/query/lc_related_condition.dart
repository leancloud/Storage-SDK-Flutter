part of leancloud_storage;

class _LCRelatedCondition extends _LCQueryCondition {
  LCObject parent;
  String key;

  _LCRelatedCondition(this.parent, this.key);

  @override
  bool equals(_LCQueryCondition other) {
    if (other is _LCRelatedCondition) {
      return key == other.key;
    }
    return false;
  }

  @override
  Map<String, dynamic> encode() {
    return {
      '\$relatedTo': {"object": _LCEncoder.encodeLCObject(parent), 'key': key}
    };
  }
}
