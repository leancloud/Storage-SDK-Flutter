import 'package:flutter_test/flutter_test.dart';

import 'package:leancloud_storage/leancloud.dart';
import 'utils.dart';

void main() {
  test('base query', () async {
    initNorthChina();
    int limit = 2;
    LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
    query.limit(limit);
    List<LCObject> list = await query.find();
    print(list.length);
    assert(list.length > 0);
    assert(list.length <= limit);

    list.forEach((object) {
      assert(object.className != null);
      assert(object.objectId != null);
      assert(object.createdAt != null);
      assert(object.updatedAt != null);

      print('-------------------------------------------------');
      print(object.className);
      print(object.objectId);
      print(object.createdAt);
      print(object.updatedAt);
      print(object['intValue']);
      print(object['boolValue']);
      print(object['stringValue']);
    });
  });

  // test('greater query', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
  //   query.whereGreaterThan('balance', 200);
  //   List<LCObject> list = await query.find();
  //   print(list.length);
  // });

  // test('query after login', () async {
  //   initNorthChina();
  //   await LCUser.login('hello', 'world');
  //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
  //   query.whereGreaterThan('balance', 200);
  //   List<LCObject> list = await query.find();
  //   print(list.length);
  // });

  // test('count', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
  //   query.whereGreaterThan('balance', 200);
  //   int count = await query.count();
  //   print(count);
  //   assert(count > 0);
  // });

  // test('get', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
  //   LCObject account = await query.get('5e0d9f7fd4b56c008e5d048a');
  //   assert(account['balance'] == 400);
  // });

  // test('first', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
  //   LCObject account = await query.first();
  //   assert(account.objectId != null);
  // });

  // test('order by', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
  //   query.orderBy('balance');
  //   List<LCObject> results = await query.find();
  //   assert(results[0]['balance'] < results[1]['balance']);

  //   query = new LCQuery<LCObject>('Account');
  //   query.orderByDescending('balance');
  //   results = await query.find();
  //   assert(results[0]['balance'] > results[1]['balance']);
  // });

  // test('include', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
  //   query.include('objectValue');
  //   LCObject hello = await query.get('5e0d55aedd3c13006a53cd87');
  //   print(hello['objectValue']['content']);
  //   assert(hello['objectValue']['content'] == '7788');
  // });

  // test('and', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> q1 = new LCQuery<LCObject>('Account');
  //   q1.whereGreaterThan('balance', 100);
  //   LCQuery<LCObject> q2 = new LCQuery<LCObject>('Account');
  //   q2.whereLessThan('balance', 500);
  //   LCQuery<LCObject> query = LCQuery.and([q1, q2]);
  //   List<LCObject> results = await query.find();
  //   print(results.length);
  //   assert(results.length == 3);
  // });

  // test('or', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> q1 = new LCQuery<LCObject>('Account');
  //   q1.whereLessThanOrEqualTo('balance', 100);
  //   LCQuery<LCObject> q2 = new LCQuery<LCObject>('Account');
  //   q2.whereGreaterThanOrEqualTo('balance', 500);
  //   LCQuery<LCObject> query = LCQuery.or([q1, q2]);
  //   List<LCObject> results = await query.find();
  //   print(results.length);
  //   assert(results.length == 2);
  // });

  // test('where object equals', () async {
  //   initNorthChina();
  //   LCQuery<LCObject> worldQuery = new LCQuery('World');
  //   LCObject world = await worldQuery.get('5e0d55ae21460d006a1ec931');
  //   LCQuery<LCObject> helloQuery = new LCQuery('Hello');
  //   helloQuery.whereEqualTo('objectValue', world);
  //   LCObject hello = await helloQuery.first();
  //   print(hello.objectId);
  //   assert(hello.objectId == '5e0d55aedd3c13006a53cd87');
  // });
}