import 'package:flutter_test/flutter_test.dart';

import 'package:leancloud_storage/leancloud.dart';
import 'utils.dart';

void main() {
  test('object save', () async {
    initNorthChina();
    LCObject object = LCObject('Hello');
    object['intValue'] = 123;
    object['boolValue'] = true;
    object['stringValue'] = 'hello, world';
    await object.save();

    print(object.objectId);
    print(object.createdAt);
    print(object.updatedAt);
    print(object['intValue']);
    print(object['boolValue']);
    print(object['stringValue']);

    assert(object.objectId != null);
    // assert(object.className != null);
    assert(object.createdAt != null);
    assert(object.updatedAt != null);
    assert(object['intValue'] == 123);
    assert(object['boolValue'] == true);
    assert(object['stringValue'] == 'hello, world');
  });
}