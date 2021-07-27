import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

void main() {
  test('LeanCloud Exception', () {
    try {
      throw new LCException(123, 'hello, world');
    } on LCException catch (e) {
      LCLogger.debug('${e.code} : ${e.message}');
      assert(e.code == 123);
    }
  });
}
