part of leancloud_storage;

class _RelatedCondition extends _QueryCondition {
  LCObject parent;
  String key;

  _RelatedCondition(this.parent, this.key);

  @override
  bool equals(_QueryCondition other) {
    if (other is _RelatedCondition) {
      return key == other.key;
    }
    return false;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      '\$relatedTo': {
        "object": LCEncoder.encodeLCObject(parent),
        'key': key
      }
    };
  }
}