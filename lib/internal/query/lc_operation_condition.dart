part of leancloud_storage;

class _OperationCondition extends _QueryCondition {
  String key;
  String op;
  dynamic value;

  _OperationCondition(this.key, this.op, this.value);

  @override
  bool equals(_QueryCondition other) {
    if (other is _OperationCondition) {
      return key == other.key && op == other.op;
    }
    return false;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      key: {
        op: value
      }
    };
  }
}