import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  // test('add', () async {
  //   initNorthChina();
  //   LCObject parent = new LCObject('Parent');
  //   LCObject c1 = new LCObject('Child');
  //   parent.addRelation('children', c1);
  //   LCObject c2 = new LCObject('Child');
  //   parent.addRelation('children', c2);
  //   await parent.save();
  // });

  test('query', () async {
    initNorthChina();
    LCQuery<LCObject> query = new LCQuery<LCObject>('Parent');
    LCObject parent = await query.get('5e13112021b47e0070ed0922');
    LCRelation relation = parent['children'];

    print(relation.key);
    print(relation.parent);
    print(relation.targetClass);

    assert(relation.key != null);
    assert(relation.parent != null);
    assert(relation.targetClass != null);

    LCQuery<LCObject> relationQuery = relation.query();
    List<LCObject> list = await relationQuery.find();
    list.forEach((item) {
      print(item.objectId);
      assert(item.objectId != null);
    });
  });
}