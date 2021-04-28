import 'package:flutter_test/flutter_test.dart';

import 'package:leancloud_storage/leancloud.dart';
import 'utils.dart';

void main() {
  group('query', () {
    setUp(() => initNorthChina());

    // test('base query', () async {
    //   int limit = 2;
    //   LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
    //   query.limit(limit);
    //   List<LCObject>? list = await query.find();
    //   print(list?.length);
    //   assert(list!.length > 0);
    //   assert(list!.length == limit);

    //   list!.forEach((object) {
    //     assert(object.className != null);
    //     assert(object.objectId != null);
    //     assert(object.createdAt != null);
    //     assert(object.updatedAt != null);

    //     print(object.className);
    //     print(object.objectId);
    //     print(object.createdAt);
    //     print(object.updatedAt);
    //     print(object['intValue']);
    //     print(object['boolValue']);
    //     print(object['stringValue']);
    //   });
    // });

    // test('count', () async {
    //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
    //   query.whereGreaterThan('balance', 200);
    //   int count = await query.count();
    //   print(count);
    //   assert(count > 0);
    // });

    // test('order by', () async {
    //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
    //   query.orderByAscending('balance');
    //   List<LCObject> results = (await query.find())!;
    //   assert(results[0]['balance'] <= results[1]['balance']);

    //   query = new LCQuery<LCObject>('Account');
    //   query.orderByDescending('balance');
    //   results = (await query.find())!;
    //   assert(results[0]['balance'] >= results[1]['balance']);
    // });

    // test('add order', () async {
    //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
    //   query.addAscendingOrder('balance');
    //   query.addDescendingOrder('createdAt');
    //   List<LCObject> results = (await query.find())!;
    //   for (int i = 0; i + 1 < results.length; i++) {
    //     LCObject a1 = results[i];
    //     LCObject a2 = results[i + 1];
    //     assert(a1['balance'] < a2['balance'] ||
    //         a1.createdAt!.compareTo(a2.createdAt!) >= 0);
    //   }
    // });

    // test('include', () async {
    //   LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
    //   query.include('objectValue');
    //   LCObject hello = (await query.get('5e0d55aedd3c13006a53cd87'))!;
    //   print(hello['objectValue']['content']);
    //   assert(hello['objectValue']['content'] == '7788');
    // });

    // test('get', () async {
    //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
    //   LCObject account = (await query.get('5e0d9f7fd4b56c008e5d048a'))!;
    //   assert(account['balance'] == 400);
    // });

    // test('first', () async {
    //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
    //   LCObject account = (await query.first())!;
    //   assert(account.objectId != null);
    // });

    // test('greater query', () async {
    //   LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
    //   query.whereGreaterThan('balance', 200);
    //   List<LCObject> list = (await query.find())!;
    //   print(list.length);
    // });

    // test('and', () async {
    //   LCQuery<LCObject> q1 = new LCQuery<LCObject>('Account');
    //   q1.whereGreaterThan('balance', 100);
    //   LCQuery<LCObject> q2 = new LCQuery<LCObject>('Account');
    //   q2.whereLessThan('balance', 500);
    //   LCQuery<LCObject> query = LCQuery.and([q1, q2]);
    //   List<LCObject> results = (await query.find())!;
    //   print(results.length);
    //   results.forEach((item) {
    //     int balance = item['balance'];
    //     assert(balance >= 100 || balance <= 500);
    //   });
    // });

    // test('or', () async {
    //   LCQuery<LCObject> q1 = new LCQuery<LCObject>('Account');
    //   q1.whereLessThanOrEqualTo('balance', 100);
    //   LCQuery<LCObject> q2 = new LCQuery<LCObject>('Account');
    //   q2.whereGreaterThanOrEqualTo('balance', 500);
    //   LCQuery<LCObject> query = LCQuery.or([q1, q2]);
    //   List<LCObject> results = (await query.find())!;
    //   print(results.length);
    //   results.forEach((item) {
    //     int balance = item['balance'];
    //     assert(balance <= 100 || balance >= 500);
    //   });
    // });

    // test('where object equals', () async {
    //   LCQuery<LCObject> worldQuery = new LCQuery('World');
    //   LCObject world = (await worldQuery.get('5e0d55ae21460d006a1ec931'))!;
    //   LCQuery<LCObject> helloQuery = new LCQuery('Hello');
    //   helloQuery.whereEqualTo('objectValue', world);
    //   LCObject hello = (await helloQuery.first())!;
    //   print(hello.objectId);
    //   assert(hello.objectId == '5e0d55aedd3c13006a53cd87');
    // });

    // test('exist', () async {
    //   LCQuery<LCObject> query = new LCQuery('Account');
    //   query.whereExists('user');
    //   List<LCObject> results = (await query.find())!;
    //   results.forEach((item) {
    //     assert(item['user'] != null);
    //   });

    //   query = new LCQuery('Account');
    //   query.whereDoesNotExist('user');
    //   results = (await query.find())!;
    //   results.forEach((item) {
    //     assert(item['user'] == null);
    //   });
    // });

    // test('select', () async {
    //   LCQuery<LCObject> query = new LCQuery('Account');
    //   query.select('balance');
    //   List<LCObject> results = (await query.find())!;
    //   results.forEach((item) {
    //     assert(item['balance'] != null);
    //     assert(item['user'] == null);
    //   });
    // });

    // test('string', () async {
    //   // Start
    //   LCQuery<LCObject> query = new LCQuery('Hello');
    //   query.whereStartsWith('stringValue', 'hello');
    //   List<LCObject> results = (await query.find())!;
    //   results.forEach((item) {
    //     String str = item['stringValue'];
    //     assert(str.startsWith('hello'));
    //   });

    //   // End
    //   query = new LCQuery('Hello');
    //   query.whereEndsWith('stringValue', 'world');
    //   results = (await query.find())!;
    //   results.forEach((item) {
    //     String str = item['stringValue'];
    //     assert(str.endsWith('world'));
    //   });

    //   // Contains
    //   query = new LCQuery('Hello');
    //   query.whereContains('stringValue', ',');
    //   results = (await query.find())!;
    //   results.forEach((item) {
    //     String str = item['stringValue'];
    //     assert(str.contains(','));
    //   });
    // });

    // test('array', () async {
    //   // equal
    //   LCQuery<LCObject> query = new LCQuery('Book');
    //   query.whereEqualTo('pages', 3);
    //   List results = (await query.find())!;
    //   results.forEach((item) {
    //     List pages = item['pages'];
    //     assert(pages.contains(3));
    //   });

    //   // contain all
    //   List containAlls = [1, 2, 3, 4, 5, 6, 7];
    //   query = new LCQuery('Book');
    //   query.whereContainsAll('pages', containAlls);
    //   results = (await query.find())!;
    //   results.forEach((item) {
    //     List pages = item['pages'];
    //     containAlls.forEach((i) {
    //       assert(pages.contains(i));
    //     });
    //   });

    //   // contain in
    //   List containIns = [4, 5, 6];
    //   query = new LCQuery('Book');
    //   query.whereContainedIn('pages', containIns);
    //   results = (await query.find())!;
    //   results.forEach((item) {
    //     List pages = item['pages'];
    //     bool f = false;
    //     containIns.forEach((i) {
    //       f |= pages.contains(i);
    //     });
    //     assert(f);
    //   });

    //   List notContainIns = [1, 2, 3];
    //   query = new LCQuery('Book');
    //   query.whereNotContainedIn('pages', notContainIns);
    //   results = (await query.find())!;
    //   results.forEach((item) {
    //     List pages = item['pages'];
    //     bool f = true;
    //     containIns.forEach((i) {
    //       f &= !pages.contains(i);
    //     });
    //     assert(!f);
    //   });

    //   // size
    //   query = new LCQuery('Book');
    //   query.whereSizeEqualTo('pages', 7);
    //   results = (await query.find())!;
    //   results.forEach((item) {
    //     List pages = item['pages'];
    //     assert(pages.length == 7);
    //   });
    // });

    // test('geo', () async {
    //   LCObject obj = new LCObject('Todo');
    //   LCGeoPoint location = new LCGeoPoint(39.9, 116.4);
    //   obj['location'] = location;
    //   await obj.save();

    //   // near
    //   LCQuery<LCObject> query = new LCQuery('Todo');
    //   LCGeoPoint point = new LCGeoPoint(39.91, 116.41);
    //   query.whereNear('location', point);
    //   List results = (await query.find())!;
    //   assert(results.length > 0);

    //   // in box
    //   query = new LCQuery('Todo');
    //   LCGeoPoint southwest = new LCGeoPoint(30, 115);
    //   LCGeoPoint northeast = new LCGeoPoint(40, 118);
    //   query.whereWithinGeoBox('location', southwest, northeast);
    //   results = (await query.find())!;
    //   assert(results.length > 0);
    // });

    // test('regex', () async {
    //   LCQuery<LCObject> query = new LCQuery('Hello');
    //   query.whereMatches('stringValue', '^HEllo.*', modifiers: 'i');
    //   List<LCObject> results = (await query.find())!;
    //   assert(results.length > 0);
    //   results.forEach((item) {
    //     String str = item['stringValue'];
    //     assert(str.startsWith('hello'));
    //   });
    // });

    // test('inquery', () async {
    //   LCQuery<LCObject> worldQuery = new LCQuery('World');
    //   worldQuery.whereEqualTo('content', '7788');
    //   LCQuery<LCObject> helloQuery = new LCQuery('Hello');
    //   helloQuery.whereMatchesQuery('objectValue', worldQuery);
    //   helloQuery.include('objectValue');
    //   List<LCObject> hellos = (await helloQuery.find())!;
    //   assert(hellos.length > 0);
    //   hellos.forEach((item) {
    //     LCObject world = item['objectValue'];
    //     assert(world['content'] == '7788');
    //   });
    // });

    test('not inquery', () async {
      LCQuery<LCObject> worldQuery = new LCQuery('World');
      worldQuery.whereEqualTo('content', '7788');
      LCQuery<LCObject> helloQuery = new LCQuery('Hello');
      helloQuery.whereDoesNotMatchQuery('objectValue', worldQuery);
      helloQuery.include('objectValue');
      List<LCObject> hellos = (await helloQuery.find())!;
      assert(hellos.length > 0);
      hellos.forEach((item) {
        LCObject world = item['objectValue'];
        assert(world != null && world['content'] != '7788');
      });
    });
  });
}
