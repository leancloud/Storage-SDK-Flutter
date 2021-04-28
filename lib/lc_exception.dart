part of leancloud_storage;

/// Thrown when LeanCloud API returns an error.
class LCException implements Exception {
  int code;

  String? message;

  LCException(this.code, this.message);
}
