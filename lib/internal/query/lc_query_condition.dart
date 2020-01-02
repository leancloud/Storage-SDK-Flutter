part of leancloud_storage;

abstract class _QueryCondition {
  bool equals(_QueryCondition other);

  Map<String, dynamic> toMap();
}