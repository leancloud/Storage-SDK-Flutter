import 'package:flutter_test/flutter_test.dart';

import 'package:leancloud_storage/leancloud.dart';
import 'utils.dart';

void main() {
  // test('object save', () async {
  //   initNorthChina();
  //   LCObject object = new LCObject('Hello');
  //   object['intValue'] = 123;
  //   object['boolValue'] = true;
  //   object['stringValue'] = 'hello, world';
  //   object['time'] = DateTime.now().toUtc();
  //   object['intList'] = [1, 1, 2, 3];
  //   object['stringMap'] = {
  //     'k1': 111,
  //     'k2': true,
  //     'k3': 'haha'
  //   };
  //   LCObject nestedObj = new LCObject('World');
  //   nestedObj['content'] = '7788';
  //   object['objectValue'] = nestedObj;
  //   await object.save();

  //   print(object.className);
  //   print(object.objectId);
  //   print(object.createdAt);
  //   print(object.updatedAt);
  //   print(object['intValue']);
  //   print(object['boolValue']);
  //   print(object['stringValue']);
  //   print(object['objectValue']);
  //   print(object['time']);

  //   assert(nestedObj == object['objectValue']);
  //   print(nestedObj.className);
  //   print(nestedObj.objectId);

  //   assert(object.objectId != null);
  //   assert(object.className != null);
  //   assert(object.createdAt != null);
  //   assert(object.updatedAt != null);
  //   assert(object['intValue'] == 123);
  //   assert(object['boolValue'] == true);
  //   assert(object['stringValue'] == 'hello, world');

    
  //   assert(nestedObj != null);
  //   assert(nestedObj.className != null);
  //   assert(nestedObj.objectId != null);
  //   assert(nestedObj.createdAt != null);
  //   assert(nestedObj.updatedAt != null);
  // });

  // test('save all', () async {
  //   List<LCObject> list = [new LCObject('World'), new LCObject('World'), new LCObject('World'), new LCObject('World')];
  //   await LCObject.saveAll(list);
  //   list.forEach((item) {
  //     assert(item.objectId != null);
  //   });
  // });

  // test('delete', () async {
  //   LCObject world = new LCObject('World');
  //   await world.save();
  //   await world.delete();
  // });

  // test('delete all', () async {
  //   List<LCObject> list = [new LCObject('World'), new LCObject('World'), new LCObject('World'), new LCObject('World')];
  //   await LCObject.saveAll(list);
  //   await LCObject.deleteAll(list);
  // });

  // test('fetch', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
  //   LCObject hello = await query.get('5e14392743c257006fb769d5');
  //   print(hello);
  //   await hello.fetch(includes: ['objectValue']);
  //   LCObject world = hello['objectValue'];
  //   print(world['content']);
  // });

  // test('save with options', () async {
  //   await initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery('Account');
  //   LCObject account = await query.get('5e154a5143c257006fbff63f');
  //   account['balance'] = 300;
  //   LCQuery<LCObject> q = new LCQuery('Account');
  //   q.whereGreaterThan('balance', 100);
  //   try {
  //     await account.save(fetchWhenSave: true, query: q);
  //   } on LCError catch (e) {
  //     print('${e.code} : ${e.message}');
  //     assert(e.code == 305);
  //   }
  // });

  // test('unset', () async {
  //   await initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery('Hello');
  //   LCObject hello = await query.get('5e18226e7796d9006a016004');
  //   hello.unset('aaa');
  //   print(hello['aaa']);
  //   await hello.save();
  // });
}