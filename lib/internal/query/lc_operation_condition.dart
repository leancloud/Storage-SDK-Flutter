part of leancloud_storage;

class _LCOperationCondition extends _LCQueryCondition {
  String key;
  String op;
  dynamic value;

  _LCOperationCondition(this.key, this.op, this.value);

  @override
  bool equals(_LCQueryCondition other) {
    if (other is _LCOperationCondition) {
      return key == other.key && op == other.op;
    }
    return false;
  }

  @override
  Map<String, dynamic> encode() {
    return {
      key: {op: _LCEncoder.encode(value)}
    };
  }
}
