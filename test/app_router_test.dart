import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

void main() {
  test('fetch', () async {
    LCAppRouter appRouter = new LCAppRouter('UlCpyvLm8aMzQsW6KnP6W3Wt-MdYXbMMI', null);
    String apiServer = await appRouter.getApiServer();
    print(apiServer);
  });
}