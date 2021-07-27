part of leancloud_storage;

/// Configures the logger.
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

  /// Prints an error message.
  static void error(dynamic message) {
    if (level < ErrorLevel) {
      return;
    }
    print('[ERROR]: $message');
  }

  /// Prints a warning message.
  static void warning(dynamic message) {
    if (level < WarningLevel) {
      return;
    }
    print('[WARN]: $message');
  }

  /// Prints a debug message.
  static void debug(dynamic message) {
    if (level < DebugLevel) {
      return;
    }
    print('[DEBUG]: $message');
  }
}
