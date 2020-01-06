import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  test('add', () async {
    initNorthChina();
    LCObject parent = new LCObject('Parent');
    LCObject c1 = new LCObject('Child');
    parent.addRelation('children', c1);
    LCObject c2 = new LCObject('Child');
    parent.addRelation('children', c2);
    await parent.save();
  });
}