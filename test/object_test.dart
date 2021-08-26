import 'package:flutter_test/flutter_test.dart';

import 'package:leancloud_storage/leancloud.dart';
import 'utils.dart';

void main() {
  group('object', () {
    setUp(() => initNorthChina());

    test('create object', () async {
      Hello object = new Hello();
      object['intValue'] = 123;
      object['boolValue'] = true;
      object['stringValue'] = 'hello, world';
      object['time'] = DateTime.now();
      object['intList'] = [1, 1, 2, 3, 5, 8];
      object['stringMap'] = {'k1': 111, 'k2': true, 'k3': 'haha'};
      World nestedObj = new World();
      nestedObj.content = '7788';
      object.world = nestedObj;
      object['pointerList'] = [new LCObject('World'), nestedObj];
      await object.save();

      LCLogger.debug(object.className);
      LCLogger.debug(object.objectId);
      LCLogger.debug(object.createdAt);
      LCLogger.debug(object.updatedAt);
      LCLogger.debug(object['intValue']);
      LCLogger.debug(object['boolValue']);
      LCLogger.debug(object['stringValue']);
      LCLogger.debug(object['objectValue']);
      LCLogger.debug(object['time']);

      assert(nestedObj == object['objectValue']);
      LCLogger.debug(nestedObj.className);
      LCLogger.debug(nestedObj.objectId);

      assert(object.objectId != null);
      assert(object.className != null);
      assert(object.createdAt != null);
      assert(object.updatedAt != null);
      assert(object['intValue'] == 123);
      assert(object['boolValue'] == true);
      assert(object['stringValue'] == 'hello, world');

      assert(nestedObj.className != null);
      assert(nestedObj.objectId != null);
      assert(nestedObj.createdAt != null);
      assert(nestedObj.updatedAt != null);

      object['pointerList'].forEach((item) {
        assert(item.objectId != null);
      });
    });

    test('save all', () async {
      List<LCObject> list = [];
      for (int i = 0; i < 5; i++) {
        World world = new World();
        world.content = 'word_$i';
        list.add(world);
      }
      await LCObject.saveAll(list);
      list.forEach((item) {
        assert(item.objectId != null);
      });
    });

    test('delete', () async {
      World world = new World();
      await world.save();
      await world.delete();
    });

    test('delete all', () async {
      List<LCObject> list = [
        new World(),
        new World(),
        new World(),
        new World(),
      ];
      await LCObject.saveAll(list);
      await LCObject.deleteAll(list);
    });

    test('fetch', () async {
      Hello hello = new Hello();
      World world = new World();
      world.content = "7788";
      hello.world = world;
      await hello.save();

      hello = LCObject.createWithoutData('Hello', hello.objectId!) as Hello;
      LCLogger.debug(hello);
      await hello.fetch(includes: ['objectValue']);
      world = hello.world;
      LCLogger.debug(world.content);
      assert(world.content == '7788');
    });

    test('fetchAll', () async {
      LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
      query.whereExists('intList').limit(10);
      Iterable<String> ids = (await query.find())!.map((e) => e.objectId!);
      Iterable<LCObject> list =
          ids.map((e) => LCObject.createWithoutData('Hello', e));

      Iterable<LCObject> objs = await LCObject.fetchAll(list.toList());
      objs.forEach((item) {
        LCLogger.debug(item.objectId);
        LCLogger.debug(item['intList']);
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
        LCLogger.debug('${e.code} : ${e.message}');
        assert(e.code == 305);
      }
    });

    test('unset', () async {
      LCObject hello = new LCObject('Hello');
      hello['content'] = 'hello, world';
      await hello.save();
      LCLogger.debug(hello['content']);
      assert(hello['content'] == 'hello, world');

      hello.unset('content');
      await hello.save();
      LCLogger.debug(hello['content']);
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
      LCLogger.debug(intList.length);
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

      World world = new World();
      world.content = 'hello, world';
      object['pointerList'] = [world, new LCObject('World')];
      await object.save();

      String json = object.toString();
      LCLogger.debug(json);
      LCObject newObj = LCObject.parseObject(json);
      assert(newObj.objectId != null);
      assert(newObj.className != null);
      assert(newObj.createdAt != null);
      assert(newObj.updatedAt != null);
      assert(newObj['intValue'] == 123);
      assert(newObj['boolValue'] == true);
      assert(newObj['stringValue'] == 'hello, world');
      assert(newObj['objectValue']['content'] == '7788');

      assert(newObj['pointerList'][0] is World);
      World newWorld = newObj['pointerList'][0] as World;
      assert(newWorld.content == 'hello, world');
    });
  });
}
