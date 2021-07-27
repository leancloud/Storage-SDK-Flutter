import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group('sms', () {
    setUp(() => initNorthChina());

    // test('request sms', () async {
    //   await LCSMSClient.requestSMSCode('15101006007',
    //       template: 'test_template',
    //       signature: 'flutter-test',
    //       variables: {'k1': 'v1'});
    // });

    // test('request voice', () async {
    //   await LCSMSClient.requestVoiceCode('15101006007');
    // });

    test('verify', () async {
      await LCSMSClient.verifyMobilePhone(TestPhone, TestSMSCode);
    });
  });
}
