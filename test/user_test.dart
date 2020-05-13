import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  group('user', () {
    setUp(() => initNorthChina());

    test('sign up', () async {
      LCUser user = new LCUser();
      user.username = DateTime.now().millisecondsSinceEpoch.toString();
      user.password = 'world';
      String email = '${DateTime.now().millisecondsSinceEpoch}@qq.com';
      user.email = email;
      String mobile =
          '${(DateTime.now().millisecondsSinceEpoch / 100).round()}';
      user.mobile = mobile;
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
      LCUser current = await LCUser.getCurrent();
      assert(current.objectId != null);
      assert(!current.emailVerified);
      assert(!current.mobileVerified);
      assert(current.mobile == '15101006008');
      assert(!current.isAnonymous);
    });

    test('login by email', () async {
      await LCUser.loginByEmail('171253484@qq.com', 'world');
      LCUser current = await LCUser.getCurrent();
      assert(current.objectId != null);
    });

    test('login by session token', () async {
      String sessionToken = 'luo2fpl4qij2050e7enqfz173';
      await LCUser.becomeWithSessionToken(sessionToken);
      LCUser current = await LCUser.getCurrent();
      assert(current.objectId != null);
    });

    test('relate object', () async {
      await LCUser.loginByMobilePhoneNumber('15101006007', '112358');
      LCObject account = new LCObject('Account');
      account['user'] = await LCUser.getCurrent();
      await account.save();
    });

    test('login anonymous', () async {
      LCUser user = await LCUser.loginAnonymously();
      assert(user.isAnonymous);
    });

    test('login with auth data', () async {
      Map<String, dynamic> authData = {
        'expires_in': 7200,
        'openid': '${DateTime.now().millisecondsSinceEpoch}',
        'access_token': '${DateTime.now().millisecondsSinceEpoch}'
      };
      LCUser currentUser = await LCUser.loginWithAuthData(authData, 'weixin');
      print(currentUser.sessionToken);
      assert(currentUser.sessionToken != null);
      String userId = currentUser.objectId;
      print('userId: $userId');
      print(currentUser.authData);

      await LCUser.logout();
      currentUser = await LCUser.getCurrent();
      assert(currentUser == null);

      currentUser = await LCUser.loginWithAuthData(authData, 'weixin');
      print(currentUser.sessionToken);
      assert(currentUser.sessionToken != null);
      assert(currentUser.objectId == userId);
      print(currentUser.authData);
    });

    test('associate auth data', () async {
      LCUser currentUser = await LCUser.login('hello', 'world');
      Map<String, dynamic> authData = {
        'expires_in': 7200,
        'openid': '${DateTime.now().millisecondsSinceEpoch}',
        'access_token': '${DateTime.now().millisecondsSinceEpoch}'
      };
      await currentUser.associateAuthData(authData, 'weixin');
      print(currentUser.authData);
      print(currentUser.authData['weixin']);
    });

    test('disassociate auth data', () async {
      LCUser currentUser = await LCUser.login('hello', 'world');
      await currentUser.disassociateWithAuthData('weixin');
    });

    test('is authenticated', () async {
      LCUser currentUser = await LCUser.login('hello', 'world');
      bool isAuthenticated = await currentUser.isAuthenticated();
      print(isAuthenticated);
      assert(isAuthenticated);
    });

    test('update password', () async {
      LCUser currentUser = await LCUser.login('hello', 'world');
      await currentUser.updatePassword('world', 'newWorld');
      await currentUser.updatePassword('newWorld', 'world');
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
      LCUser currentUser = await LCUser.loginWithAuthDataAndUnionId(
          authData, 'weixin_app', unionId,
          option: option);
      print(currentUser.sessionToken);
      assert(currentUser.sessionToken != null);
      String userId = currentUser.objectId;
      print('userId: $userId');
      print(currentUser.authData);

      await LCUser.logout();
      currentUser = await LCUser.getCurrent();
      assert(currentUser == null);

      currentUser = await LCUser.loginWithAuthDataAndUnionId(
          authData, 'weixin_mini_app', unionId,
          option: option);
      print(currentUser.sessionToken);
      assert(currentUser.sessionToken != null);
      assert(currentUser.objectId == userId);
      print(currentUser.authData);
    });

    test('associate auth data with union id', () async {
      LCUser currentUser = await LCUser.login('hello', 'world');
      Map<String, dynamic> authData = {
        'expires_in': 7200,
        'openid': '${DateTime.now().millisecondsSinceEpoch}',
        'access_token': '${DateTime.now().millisecondsSinceEpoch}'
      };
      String unionId = '${DateTime.now().millisecondsSinceEpoch}';
      await currentUser.associateAuthDataAndUnionId(authData, 'qq', unionId);
    });

    // test('login by mobile', () async {
    //   await LCUser.loginByMobilePhoneNumber('15101006007', '112358');
    //   LCUser current = LCUser.currentUser;
    //   assert(current.objectId != null);
    // });

    // test('request login sms code', () async {
    //   await LCUser.requestLoginSMSCode('15101006007');
    // });

    // test('login by sms code', () async {
    //   await LCUser.loginBySMSCode('15101006007', '882586');
    //   LCUser current = LCUser.currentUser;
    //   assert(current.objectId != null);
    // });

    // test('request email verify', () async {
    //   await LCUser.requestEmailVerify('171253484@qq.com');
    // });

    // test('request mobile verify', () async {
    //   await LCUser.requestMobilePhoneVerify('15101006007');
    // });

    // test('verify mobile', () async {
    //   await LCUser.becomeWithSessionToken('sbhavbefqk2jc3wgfop3i6om0');
    //   await LCUser.verifyMobilePhone('15101006007', '944616');
    // });

    // test('request reset password by sms code', () async {
    //   await LCUser.requestPasswordRestBySmsCode('15101006007');
    // });

    // test('reset password by sms code', () async {
    //   await LCUser.resetPasswordBySmsCode('15101006007', '286436', '112358');
    // });
  });
}
