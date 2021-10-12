import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group('cloud', () {
    setUp(() => initNorthChina());

    test("ping", () async {
      String? response = await LCCloud.call<String>('ping');
      LCLogger.debug(response);
      assert(response == "pong");
    });

    test('hello', () async {
      Map response = await LCCloud.run('hello', params: {'name': 'world'});
      LCLogger.debug(response['result']);
      assert(response['result'] == 'hello, world');
    });

    test('getObject', () async {
      LCObject hello = new LCObject("Hello");
      await hello.save();
      Map result = await LCCloud.rpc('getObject',
          params: {"className": "Hello", "id": hello.objectId});
      LCObject obj = result['result'];
      assert(obj.objectId == hello.objectId);
    });

    test('getObjects', () async {
      Map response = await LCCloud.rpc('getObjects');
      List<LCObject> monopolies = List<LCObject>.from(response['result']);
      LCLogger.debug(monopolies.length);
      assert(monopolies.length > 0);
      monopolies.forEach((m) {
        assert(m['balance'] > 100);
      });
    });

    test('getObjectMap', () async {
      Map response = await LCCloud.rpc('getObjectMap');
      Map<String, LCObject> map =
          Map<String, LCObject>.from(response['result']);
      LCLogger.debug(map.length);
      map.forEach((key, value) {
        assert(key == value.objectId);
      });
    });

    test('lcexception', () async {
      try {
        await LCCloud.run('lcexception');
      } on LCException catch (e) {
        print('${e.code} - ${e.message}');
      }
    });

    test('exception', () async {
      try {
        await LCCloud.run('exception');
      } on LCException catch (e) {
        print('${e.code} - ${e.message}');
      }
    });
  });
}
