part of leancloud_storage;

class _EqualCondition extends _QueryCondition {
  String key;
  dynamic value;

  _EqualCondition(this.key, this.value);
  
  @override
  bool equals(_QueryCondition other) {
    if (other is _EqualCondition) {
      return key == other.key;
    }
    return false;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      key: LCEncoder.encode(value)
    };
  }
}