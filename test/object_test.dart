import 'package:flutter_test/flutter_test.dart';

import 'package:leancloud_storage/leancloud.dart';
import 'utils.dart';

void main() {
  group('object', () {
    setUp(() => initNorthChina());

    test('create object', () async {
      LCObject object = new LCObject('Hello');
      object['intValue'] = 123;
      object['boolValue'] = true;
      object['stringValue'] = 'hello, world';
      object['time'] = DateTime.now();
      object['intList'] = [1, 1, 2, 3, 5, 8];
      object['stringMap'] = {'k1': 111, 'k2': true, 'k3': 'haha'};
      LCObject nestedObj = new LCObject('World');
      nestedObj['content'] = '7788';
      object['objectValue'] = nestedObj;
      object['pointerList'] = [new LCObject('World'), nestedObj];
      await object.save();

      print(object.className);
      print(object.objectId);
      print(object.createdAt);
      print(object.updatedAt);
      print(object['intValue']);
      print(object['boolValue']);
      print(object['stringValue']);
      print(object['objectValue']);
      print(object['time']);

      assert(nestedObj == object['objectValue']);
      print(nestedObj.className);
      print(nestedObj.objectId);

      assert(object.objectId != null);
      assert(object.className != null);
      assert(object.createdAt != null);
      assert(object.updatedAt != null);
      assert(object['intValue'] == 123);
      assert(object['boolValue'] == true);
      assert(object['stringValue'] == 'hello, world');

      assert(nestedObj != null);
      assert(nestedObj.className != null);
      assert(nestedObj.objectId != null);
      assert(nestedObj.createdAt != null);
      assert(nestedObj.updatedAt != null);

      object['pointerList'].forEach((item) {
        assert(item.objectId != null);
      });
    });

    test('save all', () async {
      List<LCObject> list = new List<LCObject>();
      for (int i = 0; i < 5; i++) {
        LCObject world = new LCObject('World');
        world['content'] = 'word_$i';
        list.add(world);
      }
      await LCObject.saveAll(list);
      list.forEach((item) {
        assert(item.objectId != null);
      });
    });

    test('delete', () async {
      LCObject world = new LCObject('World');
      await world.save();
      await world.delete();
    });

    test('delete all', () async {
      List<LCObject> list = [
        new LCObject('World'),
        new LCObject('World'),
        new LCObject('World'),
        new LCObject('World')
      ];
      await LCObject.saveAll(list);
      await LCObject.deleteAll(list);
    });

    test('fetch', () async {
      LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
      LCObject hello = await query.get('5e14392743c257006fb769d5');
      print(hello);
      await hello.fetch(includes: ['objectValue']);
      LCObject world = hello['objectValue'];
      print(world['content']);
    });

    test('fetchAll', () async {
      List<LCObject> list = [
        LCObject.createWithoutData('Hello', '5e8fe86938ed12000870ae82'),
        LCObject.createWithoutData('Hello', '5e8fe867158a7a0006be0feb'),
        LCObject.createWithoutData('Hello', '5e8fe84e5c385800081a1d64')
      ];
      await LCObject.fetchAll(list);
      list.forEach((item) {
        assert(item['intList'] != null);
      });
    });

    test('save with options', () async {
      LCObject account = new LCObject('Account');
      account['balance'] = 10;
      await account.save();

      account['balance'] = 1000;
      LCQuery<LCObject> q = new LCQuery('Account');
      q.whereGreaterThan('balance', 100);
      try {
        await account.save(fetchWhenSave: true, query: q);
      } on LCException catch (e) {
        print('${e.code} : ${e.message}');
        assert(e.code == 305);
      }
    });

    test('unset', () async {
      LCObject hello = new LCObject('Hello');
      hello['content'] = 'hello, world';
      await hello.save();
      print(hello['content']);
      assert(hello['content'] == 'hello, world');

      hello.unset('content');
      await hello.save();
      print(hello['content']);
      assert(hello['content'] == null);
    });

    test('operate null property', () async {
      LCObject object = new LCObject('Hello');
      object.increment('intValue', 123);
      object.increment('intValue', 321);
      object.add('intList', 1);
      object.add('intList', 2);
      object.add('intList', 3);
      await object.save();

      assert(object['intValue'] == 444);
      List intList = object['intList'];
      print(intList.length);
      assert(intList.length == 3);
      assert(intList[0] == 1);
      assert(intList[1] == 2);
      assert(intList[2] == 3);
    });

    test('serialization', () async {
      LCObject object = new LCObject('Hello');
      object['intValue'] = 123;
      object['boolValue'] = true;
      object['stringValue'] = 'hello, world';
      object['time'] = DateTime.now();
      object['intList'] = [1, 1, 2, 3, 5, 8];
      object['stringMap'] = {'k1': 111, 'k2': true, 'k3': 'haha'};
      LCObject nestedObj = new LCObject('World');
      nestedObj['content'] = '7788';
      object['objectValue'] = nestedObj;
      object['pointerList'] = [new LCObject('World'), nestedObj];
      await object.save();

      String json = object.toString();
      print(json);
      LCObject newObj = LCObject.parseObject(json);
      assert(newObj.objectId != null);
      assert(newObj.className != null);
      assert(newObj.createdAt != null);
      assert(newObj.updatedAt != null);
      assert(newObj['intValue'] == 123);
      assert(newObj['boolValue'] == true);
      assert(newObj['stringValue'] == 'hello, world');
    });
  });
}
