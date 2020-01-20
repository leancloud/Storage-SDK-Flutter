import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group('user', () {
    setUp(() => initNorthChina());

    test('sign up', () async {
      LCUser user = new LCUser();
      user.username = DateTime.now().millisecondsSinceEpoch.toString();
      user.password = 'world';
      String email = '${DateTime.now().millisecondsSinceEpoch}@qq.com';
      user.email = email;
      await user.signUp();

      print(user.username);
      print(user.password);

      assert(user.objectId != null);
      print(user.objectId);
      assert(user.sessionToken != null);
      print(user.sessionToken);
      assert(user.email == email);
    });

    test('login', () async {
      await LCUser.login('hello', 'world');
      LCUser current = LCUser.currentUser;
      assert(current.objectId != null);
      assert(!current.emailVerified);
      assert(!current.mobileVerified);
      assert(current.mobile == '15101006008');
    });

    // test('login by mobile', () async {
    //   await LCUser.loginByMobilePhoneNumber('15101006007', '112358');
    //   LCUser current = LCUser.currentUser;
    //   assert(current.objectId != null);
    // });

    test('login by email', () async {
      await LCUser.loginByEmail('171253484@qq.com', 'world');
      LCUser current = LCUser.currentUser;
      assert(current.objectId != null);
    });

    // test('login by sms code', () async {
    //   await LCUser.loginBySMSCode('15101006007', '882586');
    //   LCUser current = LCUser.currentUser;
    //   assert(current.objectId != null);
    // });

    // test('request login sms code', () async {
    //   await LCUser.requestLogionSMSCode('15101006007');
    // });

    // test('login by sms code', () async {
    //   await LCUser.loginBySMSCode('15101006007', '925752');l
    // });

    test('login by session token', () async {
      String sessionToken = 'luo2fpl4qij2050e7enqfz173';
      await LCUser.becomeWithSessionToken(sessionToken);
      LCUser current = LCUser.currentUser;
      assert(current.objectId != null);
    });

    // test('request mobile verify', () async {
    //   await LCUser.requestMobilePhoneVerify('15101006007');
    // });

    // test('verify mobile', () async {
    //   await LCUser.becomeWithSessionToken('sbhavbefqk2jc3wgfop3i6om0');
    //   await LCUser.verifyMobilePhone('944616');
    // });

    // test('request email verify', () async {
    //   await LCUser.requestEmailVerify('171253484@qq.com');
    // });

    // test('request reset password by sms code', () async {
    //   await LCUser.requestPasswordRestBySmsCode('15101006007');
    // });

    // test('reset password by sms code', () async {
    //   await LCUser.resetPasswordBySmsCode('15101006007', '286436', '112358');
    // });

    test('relate object', () async {
      await LCUser.loginByMobilePhoneNumber('15101006007', '112358');
      LCObject account = new LCObject('Account');
      account['user'] = LCUser.currentUser;
      await account.save();
    });

    test('login anonymous', () async {
      await LCUser.loginAnonymously();
    });

    test('login with auth data', () async {
      Map<String, dynamic> authData = {
        'expires_in': 7200,
        'openid': '${DateTime.now().millisecondsSinceEpoch}',
        'access_token': '${DateTime.now().millisecondsSinceEpoch}'
      };
      await LCUser.loginWithAuthData(authData, 'weixin');
      print(LCUser.currentUser.sessionToken);
      assert(LCUser.currentUser.sessionToken != null);
      String userId = LCUser.currentUser.objectId;
      print('userId: $userId');
      print(LCUser.currentUser.authData);

      LCUser.logout();
      assert(LCUser.currentUser == null);

      await LCUser.loginWithAuthData(authData, 'weixin');
      print(LCUser.currentUser.sessionToken);
      assert(LCUser.currentUser.sessionToken != null);
      assert(LCUser.currentUser.objectId == userId);
      print(LCUser.currentUser.authData);
    });
    
    test('associate auth data', () async {
      await LCUser.login('hello', 'world');
      Map<String, dynamic> authData = {
        'expires_in': 7200,
        'openid': '${DateTime.now().millisecondsSinceEpoch}',
        'access_token': '${DateTime.now().millisecondsSinceEpoch}'
      };
      await LCUser.currentUser.associateAuthData(authData, 'weixin');
      print(LCUser.currentUser.authData);
      print(LCUser.currentUser.authData['weixin']);
    });

    test('disassociate auth data', () async {
      await LCUser.login('hello', 'world');
      await LCUser.currentUser.disassociateWithAuthData('weixin');
    });

    test('is authenticated', () async {
      await LCUser.login('hello', 'world');
      bool isAuthenticated = await LCUser.currentUser.isAuthenticated();
      print(isAuthenticated);
      assert(isAuthenticated);
    });

    test('update password', () async {
      await LCUser.login('hello', 'world');
      await LCUser.currentUser.updatePassword('world', 'newWorld');
      await LCUser.currentUser.updatePassword('newWorld', 'world');
    });

    test('login with auth data and union id', () async {
      Map<String, dynamic> authData = {
        'expires_in': 7200,
        'openid': '${DateTime.now().millisecondsSinceEpoch}',
        'access_token': '${DateTime.now().millisecondsSinceEpoch}'
      };
      String unionId = '${DateTime.now().millisecondsSinceEpoch}';
      LCUserAuthDataLoginOption option = new LCUserAuthDataLoginOption();
      option.asMainAccount = true;
      await LCUser.loginWithAuthDataAndUnionId(authData, 'weixin_app', unionId, option: option);
      print(LCUser.currentUser.sessionToken);
      assert(LCUser.currentUser.sessionToken != null);
      String userId = LCUser.currentUser.objectId;
      print('userId: $userId');
      print(LCUser.currentUser.authData);

      LCUser.logout();
      assert(LCUser.currentUser == null);

      await LCUser.loginWithAuthDataAndUnionId(authData, 'weixin_mini_app', unionId, option: option);
      print(LCUser.currentUser.sessionToken);
      assert(LCUser.currentUser.sessionToken != null);
      assert(LCUser.currentUser.objectId == userId);
      print(LCUser.currentUser.authData);
    });
  });
}