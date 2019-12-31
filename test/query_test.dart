import 'package:flutter_test/flutter_test.dart';

import 'package:leancloud_storage/leancloud.dart';
import 'utils.dart';

void main() {
  test('base query', () async {
    initNorthChina();
    LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
    List<LCObject> list = await query.find();
    print(list.length);
    assert(list.length > 0);

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
}