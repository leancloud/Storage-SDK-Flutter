import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group('relation', () {
    setUp(() => initNorthChina());

    late LCObject parent;
    late LCObject c1;
    late LCObject c2;

    test('add and remove', () async {
      parent = new LCObject('Parent');
      c1 = new LCObject('Child');
      parent.addRelation('children', c1);
      c2 = new LCObject('Child');
      parent.addRelation('children', c2);
      await parent.save();

      LCRelation relation = parent['children'];
      LCQuery<LCObject> query = relation.query();
      int count = await query.count();

      LCLogger.debug('count: $count');
      assert(count == 2);

      parent.removeRelation('children', c2);
      await parent.save();

      int count2 = await query.count();
      LCLogger.debug('count: $count2');
      assert(count2 == 1);
    });

    test('query', () async {
      LCQuery<LCObject> query = new LCQuery<LCObject>('Parent');
      LCObject queryParent = (await query.get(parent.objectId!))!;
      LCRelation relation = queryParent['children'];

      LCLogger.debug(relation.key);
      LCLogger.debug(relation.parent);
      LCLogger.debug(relation.targetClass);

      LCQuery<LCObject> relationQuery = relation.query();
      List<LCObject> list = (await relationQuery.find())!;
      list.forEach((item) {
        LCLogger.debug(item.objectId);
        assert(item.objectId != null);
      });
    });
  });
}
