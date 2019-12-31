part of leancloud_storage;

/// LCObject 操作基类
abstract class LCOperation {
  /// 与前一个操作做合并
  LCOperation mergeWithPrevious(LCOperation previousOp);

  dynamic encode();

  // 计算值
  dynamic apply(dynamic oldValue, String key);
}