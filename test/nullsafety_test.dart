import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

class Hello {
}

void main() {
  void length(String? str) {
    LCLogger.debug(str?.length);
  }

  test('null safety', () {
    length('hello');
    length(null);

    Map<String, String> map = {
      "a": "aaa",
      "b": "bbb"
    };
    LCLogger.debug(map["a"] ?? "hello");
    LCLogger.debug(map["c"] ?? "world");

    Type type = Hello;
    LCLogger.debug(type.runtimeType.toString());
  });
}