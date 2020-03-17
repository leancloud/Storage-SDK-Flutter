part of leancloud_storage;

/// 异常
class LCException implements Exception {
  /// 异常编码
  int code;

  /// 异常信息
  String message;

  LCException(this.code, this.message);
}
