import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  test('call', () async {
    initNorthChina();
    Map response = await LCCloud.run('hello', params: {
      'name': 'world'
    });
    print(response['result']);
    assert(response['result'] == 'hello, world');
  });

  test('call no params', () async {
    initNorthChina();
    await LCCloud.run('hello');
  });

  test('rpc', () async {
    initNorthChina();
    Map result = await LCCloud.rpc('getTycoonList');
    List tycoonList = result['result'];
    tycoonList.forEach((item) {
      print(item.objectId);
      assert(item.objectId != null);
    });
  });
}