import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  test('query file', () async {
    initNorthChina();
    LCQuery<LCFile> query = new LCQuery<LCFile>('_File');
    LCFile file = await query.get('5e0dbfa0562071008e21c142');
    print(file.url);
    print(file.getThumbnailUrl(32, 32));
  });
}