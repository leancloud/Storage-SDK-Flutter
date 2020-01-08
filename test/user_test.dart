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
  //   await LCUser.loginByMobilePhoneNumber('15101006007', '112358');
  //   LCUser current = LCUser.currentUser;
  //   assert(current.objectId != null);
  // });

  // test('login by email', () async {
  //   initNorthChina();
  //   await LCUser.loginByEmail('171253484@qq.com', 'world');
  //   LCUser current = LCUser.currentUser;
  //   assert(current.objectId != null);
  // });

  // test('login by sms code', () async {
  //   initNorthChina();
  //   await LCUser.loginBySMSCode('15101006007', '882586');
  //   LCUser current = LCUser.currentUser;
  //   assert(current.objectId != null);
  // });

  // test('request login sms code', () async {
  //   initNorthChina();
  //   await LCUser.requestLogionSMSCode('15101006007');
  // });

  // test('login by sms code', () async {
  //   initNorthChina();
  //   await LCUser.loginBySMSCode('15101006007', '925752');l
  // });

  // test('login by session token', () async {
  //   initNorthChina();
  //   String sessionToken = 'luo2fpl4qij2050e7enqfz173';
  //   await LCUser.becomeWithSessionToken(sessionToken);
  //   LCUser current = LCUser.currentUser;
  //   assert(current.objectId != null);
  // });

  // test('request mobile verify', () async {
  //   initNorthChina();
  //   await LCUser.requestMobilePhoneVerify('15101006007');
  // });

  // test('verify mobile', () async {
  //   initNorthChina();
  //   await LCUser.becomeWithSessionToken('sbhavbefqk2jc3wgfop3i6om0');
  //   await LCUser.verifyMobilePhone('944616');
  // });

  // test('request email verify', () async {
  //   initNorthChina();
  //   await LCUser.requestEmailVerify('171253484@qq.com');
  // });

  // test('request reset password by sms code', () async {
  //   initNorthChina();
  //   await LCUser.requestPasswordRestBySmsCode('15101006007');
  // });

  // test('reset password by sms code', () async {
  //   initNorthChina();
  //   await LCUser.resetPasswordBySmsCode('15101006007', '286436', '112358');
  // });

  // test('relate object', () async {
  //   initNorthChina();
  //   await LCUser.loginByMobilePhoneNumber('15101006007', '112358');
  //   LCObject account = new LCObject('Account');
  //   account['user'] = LCUser.currentUser;
  //   await account.save();
  // });

  // test('login anonymous', () async {
  //   initNorthChina();
  //   await LCUser.loginAnonymously();
  // });

  // test('login with auth data', () async {
  //   initNorthChina();
  
  //   Map<String, dynamic> authData = {
  //     'expires_in': 7200,
  //     'openid': new Uuid().generateV4(),
  //     'access_token': new Uuid().generateV4()
  //   };
  //   await LCUser.loginWithAuthData(authData, 'weixin');
  //   print(LCUser.currentUser.sessionToken);
  //   assert(LCUser.currentUser.sessionToken != null);
  //   String userId = LCUser.currentUser.objectId;
  //   print('userId: $userId');
  //   print(LCUser.currentUser.authData);

  //   LCUser.logout();
  //   assert(LCUser.currentUser == null);

  //   await LCUser.loginWithAuthData(authData, 'weixin');
  //   print(LCUser.currentUser.sessionToken);
  //   assert(LCUser.currentUser.sessionToken != null);
  //   assert(LCUser.currentUser.objectId == userId);
  //   print(LCUser.currentUser.authData);
  // });
  
  // test('associate auth data', () async {
  //   initNorthChina();

  //   await LCUser.login('hello', 'world');
  //   Map<String, dynamic> authData = {
  //     'expires_in': 7200,
  //     'openid': new Uuid().generateV4(),
  //     'access_token': new Uuid().generateV4()
  //   };
  //   await LCUser.currentUser.associateAuthData(authData, 'weixin');
  //   print(LCUser.currentUser.authData);
  //   print(LCUser.currentUser.authData['weixin']);
  // });

  // test('disassociate auth data', () async {
  //   initNorthChina();

  //   await LCUser.login('hello', 'world');
  //   await LCUser.currentUser.disassociateWithAuthData('weixin');
  // });

  test('is authenticated', () async {
    initNorthChina();
    await LCUser.login('hello', 'world');
    bool isAuthenticated = await LCUser.currentUser.isAuthenticated();
    print(isAuthenticated);
    assert(isAuthenticated);
  });
}