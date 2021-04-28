part of leancloud_storage;

/// [LCObject] Operation
abstract class _LCOperation {
  // 与前一个操作做合并
  _LCOperation mergeWithPrevious(_LCOperation previousOp);

  dynamic encode();

  // 计算值
  dynamic apply(dynamic oldValue, String key);

  // 得到增加的对象
  List? getNewObjectList();
}
