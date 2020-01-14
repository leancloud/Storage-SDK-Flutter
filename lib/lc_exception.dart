part of leancloud_storage;

/// 错误类
class LCException implements Exception {
  int code;

  String message;

  LCException(this.code, this.message);
}