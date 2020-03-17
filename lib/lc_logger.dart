part of leancloud_storage;

/// 日志
class LCLogger {
  /// 关闭日志
  static const int OffLevel = 0;

  /// 错误级
  static const int ErrorLevel = 1;

  /// 警告级
  static const int WarningLevel = 2;

  /// 调试级
  static const int DebugLevel = 3;

  static int level = OffLevel;

  /// 设置日志输出级别 [logLevel]
  static void setLevel(int logLevel) {
    level = logLevel;
    if (level >= DebugLevel) {
      LeanCloud._httpClient.enableLog();
    }
  }

  /// 输出错误日志 [message]
  static void error(String message) {
    if (level < ErrorLevel) {
      return;
    }
    print('[ERROR]: $message');
  }

  /// 输出警告日志 [message]
  static void warning(String message) {
    if (level < WarningLevel) {
      return;
    }
    print('[WARN]: $message');
  }

  /// 输出调试日志 [message]
  static void debug(String message) {
    if (level < DebugLevel) {
      return;
    }
    print('[DEBUG]: $message');
  }
}
