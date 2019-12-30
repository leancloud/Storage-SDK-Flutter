part of leancloud_storage;

enum LogLevel {
  Debug,
  Warn,
  Error,
}

class Logger {
  static Function(LogLevel, String) _delegate;

  static void setLog(Function(LogLevel, String) func) {
    _delegate = func;
  }

  static void debug(String message) {
    if (_delegate != null) {
      _delegate(LogLevel.Debug, message);
    }
  }

  static void warn(String message) {
    if (_delegate != null) {
      _delegate(LogLevel.Warn, message);
    }
  }

  static void error(String message) {
    if (_delegate != null) {
      _delegate(LogLevel.Error, message);
    }
  }
}