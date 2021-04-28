part of leancloud_storage;

abstract class _LCQueryCondition {
  bool equals(_LCQueryCondition other);

  Map<String, dynamic>? encode();
}
