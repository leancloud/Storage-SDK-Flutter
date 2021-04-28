import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group('relation', () {
    setUp(() => initNorthChina());

    test('add and remove', () async {
      LCObject parent = new LCObject('Parent');
      LCObject c1 = new LCObject('Child');
      parent.addRelation('children', c1);
      LCObject c2 = new LCObject('Child');
      parent.addRelation('children', c2);
      await parent.save();

      LCRelation relation = parent['children'];
      LCQuery<LCObject> query = relation.query();
      int count = await query.count();

      print('count: $count');
      assert(count == 2);

      parent.removeRelation('children', c2);
      await parent.save();

      int count2 = await query.count();
      print('count: $count2');
      assert(count2 == 1);
    });

    test('query', () async {
      LCQuery<LCObject> query = new LCQuery<LCObject>('Parent');
      LCObject parent = (await query.get('5e13112021b47e0070ed0922'))!;
      LCRelation relation = parent['children'];

      print(relation.key);
      print(relation.parent);
      print(relation.targetClass);

      assert(relation.key != null);
      assert(relation.parent != null);
      assert(relation.targetClass != null);

      LCQuery<LCObject> relationQuery = relation.query();
      List<LCObject> list = (await relationQuery.find())!;
      list.forEach((item) {
        print(item.objectId);
        assert(item.objectId != null);
      });
    });
  });
}
