part of leancloud_storage;

/// 错误类
class LCError {
  int code;

  String message;

  LCError(this.code, this.message);
}