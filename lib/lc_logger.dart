part of leancloud_storage;

/// 日志
class LCLogger {
  static const int OffLevel = 0;
  static const int ErrorLevel = 1;
  static const int WarningLevel = 2;
  static const int DebugLevel = 3;

  static int level = OffLevel;

  static void setLevel(int logLevel) {
    level = logLevel;
    if (level >= DebugLevel) {
      LeanCloud._httpClient.enableLog();
    }
  }

  static void error(String message) {
    if (level < ErrorLevel) {
      return;
    }
    print('[ERROR]: $message');
  }

  static void warning(String message) {
    if (level < WarningLevel) {
      return;
    }
    print('[WARN]: $message');
  }

  static void debug(String message) {
    if (level < DebugLevel) {
      return;
    }
    print('[DEBUG]: $message');
  }
}