import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

String getTestEmail() {
  return '$TestPhone@leancloud.rocks';
}

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
          '13${(DateTime.now().millisecondsSinceEpoch % 1000000000).round()}';
      user.mobile = mobile;
      await user.signUp();

      LCLogger.debug(user.username);
      LCLogger.debug(user.password);

      assert(user.objectId != null);
      LCLogger.debug(user.objectId);
      assert(user.sessionToken != null);
      LCLogger.debug(user.sessionToken);
      assert(user.email == email);
    });

    test('login', () async {
      try {
        await LCUser.login(TestPhone, TestPhone);
      } on LCException catch (e) {
        if (e.code == 211) {
          LCUser user = new LCUser();
          user.username = TestPhone;
          user.password = TestPhone;
          user.mobile = TestPhone;
          user.email = getTestEmail();
          await user.signUp();
        } else {
          throw e;
        }
      }

      await LCUser.login(TestPhone, TestPhone);
      LCUser current = (await LCUser.getCurrent())!;
      assert(current.objectId != null);
      assert(!current.emailVerified!);
      assert(current.mobileVerified!);
      assert(!current.isAnonymous);
    });

    test('login by email', () async {
      await LCUser.loginByEmail(getTestEmail(), TestPhone);
      LCUser current = (await LCUser.getCurrent())!;
      assert(current.objectId != null);
    });

    test('login by session token', () async {
      LCUser user = await LCUser.login(TestPhone, TestPhone);
      String sessionToken = user.sessionToken!;
      await LCUser.logout();

      await LCUser.becomeWithSessionToken(sessionToken);
      LCUser current = (await LCUser.getCurrent())!;
      assert(current.objectId != null);
    });

    test('relate object', () async {
      await LCUser.loginByMobilePhoneNumber(TestPhone, TestPhone);
      Account account = new Account();
      account.user = (await LCUser.getCurrent())!;
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
      LCUser? currentUser = await LCUser.loginWithAuthData(authData, 'weixin');
      LCLogger.debug(currentUser.sessionToken);
      String userId = currentUser.objectId!;
      LCLogger.debug('userId: $userId');
      LCLogger.debug(currentUser.authData);

      await LCUser.logout();
      currentUser = await LCUser.getCurrent();
      assert(currentUser == null);

      currentUser = await LCUser.loginWithAuthData(authData, 'weixin');
      LCLogger.debug(currentUser.sessionToken);
      assert(currentUser.sessionToken != null);
      assert(currentUser.objectId == userId);
      LCLogger.debug(currentUser.authData);
    });

    test('associate auth data', () async {
      LCUser currentUser = await LCUser.login(TestPhone, TestPhone);
      Map<String, dynamic> authData = {
        'expires_in': 7200,
        'openid': '${DateTime.now().millisecondsSinceEpoch}',
        'access_token': '${DateTime.now().millisecondsSinceEpoch}'
      };
      await currentUser.associateAuthData(authData, 'weixin');
      LCLogger.debug(currentUser.authData);
      LCLogger.debug(currentUser.authData!['weixin']);
    });

    test('disassociate auth data', () async {
      LCUser currentUser = await LCUser.login(TestPhone, TestPhone);
      await currentUser.disassociateWithAuthData('weixin');
    });

    test('is authenticated', () async {
      LCUser currentUser = await LCUser.login(TestPhone, TestPhone);
      bool isAuthenticated = await currentUser.isAuthenticated();
      LCLogger.debug(isAuthenticated);
      assert(isAuthenticated);
    });

    test('update password', () async {
      LCUser currentUser = await LCUser.login(TestPhone, TestPhone);
      String newPassword = "newpassword";
      await currentUser.updatePassword(TestPhone, newPassword);
      await currentUser.updatePassword(newPassword, TestPhone);
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
      LCUser? currentUser = await LCUser.loginWithAuthDataAndUnionId(
          authData, 'weixin_app', unionId,
          option: option);
      LCLogger.debug(currentUser.sessionToken);
      assert(currentUser.sessionToken != null);
      String userId = currentUser.objectId!;
      LCLogger.debug('userId: $userId');
      LCLogger.debug(currentUser.authData);

      await LCUser.logout();
      currentUser = await LCUser.getCurrent();
      assert(currentUser == null);

      currentUser = await LCUser.loginWithAuthDataAndUnionId(
          authData, 'weixin_mini_app', unionId,
          option: option);
      LCLogger.debug(currentUser.sessionToken);
      assert(currentUser.sessionToken != null);
      assert(currentUser.objectId == userId);
      LCLogger.debug(currentUser.authData);
    });

    test('associate auth data with union id', () async {
      LCUser currentUser = await LCUser.login(TestPhone, TestPhone);
      Map<String, dynamic> authData = {
        'expires_in': 7200,
        'openid': '${DateTime.now().millisecondsSinceEpoch}',
        'access_token': '${DateTime.now().millisecondsSinceEpoch}'
      };
      String unionId = '${DateTime.now().millisecondsSinceEpoch}';
      await currentUser.associateAuthDataAndUnionId(authData, 'qq', unionId);
    });

    test('login by mobile', () async {
      LCUser current =
          await LCUser.loginByMobilePhoneNumber(TestPhone, TestPhone);
      assert(current.objectId != null);
    });

    // test('request login sms code', () async {
    //   await LCUser.requestLoginSMSCode('15101006007');
    // });

    test('login by sms code', () async {
      LCUser current = await LCUser.loginBySMSCode(TestPhone, TestSMSCode);
      assert(current.objectId != null);
    });

    // test('request email verify', () async {
    //   await LCUser.requestEmailVerify('171253484@qq.com');
    // });

    // test('request mobile verify', () async {
    //   await LCUser.requestMobilePhoneVerify('15101006007');
    // });

    test('verify mobile', () async {
      await LCUser.verifyMobilePhone(TestPhone, TestSMSCode);
    });

    // test('request reset password by sms code', () async {
    //   await LCUser.requestPasswordRestBySmsCode('15101006007');
    // });

    // test('reset password by sms code', () async {
    //   await LCUser.resetPasswordBySmsCode('15101006007', '286436', '112358');
    // });

    // test('request sms code for updating phone number', () async {
    //   await LCUser.login(TestPhone, TestPhone);
    //   await LCUser.requestSMSCodeForUpdatingPhoneNumber(TestPhone);
    // });

    test('verify code for updating phone number', () async {
      await LCUser.login(TestPhone, TestPhone);
      await LCUser.verifyCodeForUpdatingPhoneNumber(TestPhone, TestSMSCode);
    });
  });
}
