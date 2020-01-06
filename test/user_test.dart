import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  // test('sign up', () async {
  //   initNorthChina();
  //   LCUser user = new LCUser();
  //   user.username = DateTime.now().millisecondsSinceEpoch.toString();
  //   user.password = 'world';
  //   user.email = '171253484@qq.com';
  //   await user.signUp();

  //   print(user.username);
  //   print(user.password);

  //   assert(user.objectId != null);
  //   print(user.objectId);
  //   assert(user.sessionToken != null);
  //   print(user.sessionToken);
  // });

  // test('login', () async {
  //   initNorthChina();
  //   await LCUser.login('hello', 'world');
  //   LCUser current = LCUser.currentUser;
  //   assert(current.objectId != null);
  //   assert(!current.emailVerified);
  //   assert(!current.mobileVerified);
  // });

  // test('login by mobile', () async {
  //   initNorthChina();
  //   await LCUser.loginByMobilePhoneNumber('15101006007', 'world');
  //   LCUser current = LCUser.currentUser;
  //   assert(current.objectId != null);
  // });

  // test('login by email', () async {
  //   initNorthChina();
  //   await LCUser.loginByEmail('171253484@qq.com', 'world');
  //   LCUser current = LCUser.currentUser;
  //   assert(current.objectId != null);
  // });

  test('login by sms code', () async {
    initNorthChina();
    await LCUser.loginBySMSCode('15101006007', '882586');
    LCUser current = LCUser.currentUser;
    assert(current.objectId != null);
  });

  // test('request login sms code', () async {
  //   initNorthChina();
  //   await LCUser.requestLogionSMSCode('15101006007');
  // });

  // test('logiin by session token', () async {
  //   initNorthChina();
  //   String sessionToken = 'luo2fpl4qij2050e7enqfz173';
  //   await LCUser.becomeWithSessionToken(sessionToken);
  //   LCUser current = LCUser.currentUser;
  //   assert(current.objectId != null);
  // });
}