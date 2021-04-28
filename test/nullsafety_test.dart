import 'package:flutter_test/flutter_test.dart';

class Hello {
}

void main() {
  void length(String? str) {
    print(str?.length);
  }

  test('null safety', () {
    length('hello');
    length(null);

    Map<String, String> map = {
      "a": "aaa",
      "b": "bbb"
    };
    print(map["a"] ?? "hello");
    print(map["c"] ?? "world");

    Type type = Hello;
    print(type.runtimeType.toString());
  });
}