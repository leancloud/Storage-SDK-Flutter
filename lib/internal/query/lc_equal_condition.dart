part of leancloud_storage;

class _LCEqualCondition extends _LCQueryCondition {
  String key;
  dynamic value;

  _LCEqualCondition(this.key, this.value);

  @override
  bool equals(_LCQueryCondition other) {
    if (other is _LCEqualCondition) {
      return key == other.key;
    }
    return false;
  }

  @override
  Map<String, dynamic> encode() {
    return {key: _LCEncoder.encode(value)};
  }
}
