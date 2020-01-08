part of leancloud_storage;

/// 用户类
class LCUser extends LCObject {
  static const String ClassName = '_User';

  /// 用户名
  String get username => this['username'];

  set username(String value) => this['username'] = value;

  /// 密码
  String get password => this['password'];

  set password(String value) => this['password'] = value;

  /// 邮箱
  String get email => this['email'];
   
  set email(String value) => this["email"] = value;

  /// 手机号
  String get mobile => this['mobilePhoneNumber'];

  set mobile(String value) => this['mobilePhoneNumber'] = value;

  /// Session Token
  String get sessionToken => this['sessionToken'];

  set sessionToken(String value) => this['sessionToken'] = value;

  /// 是否验证邮箱
  bool get emailVerified => this['emailVerified'];

  /// 是否验证手机号
  bool get mobileVerified => this['mobilePhoneVerified'];

  /// 第三方授权信息
  Map get authData => this['authData'];

  set authData(Map value) => this['authData'] = value;

  /// 当前用户
  static LCUser currentUser;

  LCUser() : super(LCUser.ClassName);

  /// 注册
  Future<LCUser> signUp() async {
    // 检查参数合法性
    if (username == null || username.isEmpty) {
      throw new Error();
    }
    if (password == null || password.isEmpty) {
      throw new Error();
    }
    if (objectId != null) {
      throw new Error();
    }
    LCHttpRequest request = getRequest();
    Map<String, dynamic> response = await LeanCloud._client.send<Map<String, dynamic>>(request);
    LCObjectData data = LCObjectData.decode(response);
    _merge(data);
    currentUser = this;
    return this;
  }

  /// 请求登录注册码
  static Future<void> requestLogionSMSCode(String mobile, { String validateToken }) async {
    // TODO 参数合法性判断

    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile
    };
    if (validateToken != null) {
      data['validate_token'] = validateToken;
    }
    LCHttpRequest request = new LCHttpRequest('requestLoginSmsCode', LCHttpRequestMethod.post, data: data);
    await LeanCloud._client.send(request);
  }

  /// 以手机号和验证码登录或注册并登录
  static Future<LCUser> signUpOrLoginByMobilePhone(String mobile, String code) async {
    LCHttpRequest request = LCHttpRequest.createPostRequest('usersByMobilePhone', data: {
      'mobilePhoneNumber': mobile,
      'smsCode': code
    });
    Map<String, dynamic> response = await LeanCloud._client.send<Map<String, dynamic>>(request);
    LCObjectData objectData = LCObjectData.decode(response);
    currentUser = new LCUser();
    currentUser._merge(objectData);
    return currentUser;
  }

  /// 以账号和密码登陆
  static Future<LCUser> login(String username, String password) {
    // TODO 参数合法性判断

    Map<String, dynamic> data = {
      'username': username,
      'password': password
    };
    return _login(data);
  }

  /// 以邮箱和密码登陆
  static Future<LCUser> loginByEmail(String email, String password) {
    // TODO 参数合法性判断

    Map<String, dynamic> data = {
      'email': email,
      'password': password
    };
    return _login(data);
  }

  /// 以手机号和密码登陆
  static Future<LCUser> loginByMobilePhoneNumber(String mobile, String password) {
    // TODO 参数合法性判断

    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile,
      'password': password
    };
    return _login(data);
  }

  /// 以手机号和验证码登录
  static Future<LCUser> loginBySMSCode(String mobile, String code) {
    // TODO 参数合法性判断

    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile,
      'smsCode': code
    };
    return _login(data);
  }

  static Future<LCUser> loginWithAuthData(Map<String, dynamic> authData, String platform, { LCUserAuthDataLoginOption option }) {
    if (option == null) {
      option = new LCUserAuthDataLoginOption();
    }
    return _loginWithAuthData(platform, authData, option.failOnNotExist);
  }

  static Future<LCUser> loginWithAuthDataAndUnionId(Map<String, dynamic> authData, String platform, String unionId, { LCUserAuthDataLoginOption option }) {
    if (option == null) {
      option = new LCUserAuthDataLoginOption();
    }
    _mergeAuthData(authData, unionId, option);
    return _loginWithAuthData(platform, authData, option.failOnNotExist);
  }

  static Future<LCUser> _loginWithAuthData(String authType, Map<String, dynamic> data, bool failOnNotExist) async {
    Map<String, dynamic> authData = {
      authType: data
    };
    String path = failOnNotExist ? 'users?failOnNotExist=true' : 'users';
    LCHttpRequest request = LCHttpRequest.createPostRequest(path, data: {
      'authData': authData
    });
    Map<String, dynamic> response = await LeanCloud._client.send<Map<String, dynamic>>(request);
    LCObjectData objectData = LCObjectData.decode(response);
    currentUser = new LCUser();
    currentUser._merge(objectData);
    return currentUser;
  }

  static void _mergeAuthData(Map<String, dynamic> authData, String unionId, LCUserAuthDataLoginOption option) {
    authData['platform'] = option.unionIdPlatform;
    authData['main_account'] = option.asMainAccount;
    authData['unionid'] = unionId;
  }

  Future<void> associateAuthData(Map<String, dynamic> authData, String platform) {
    return _linkWithAuthData(platform, authData);
  }

  Future<void> associateAuthDataAndUnionId(Map<String, dynamic> authData, String platform, String unionId, { LCUserAuthDataLoginOption option }) {
    if (option == null) {
      option = new LCUserAuthDataLoginOption();
    }
    _mergeAuthData(authData, unionId, option);
    return _linkWithAuthData(platform, authData);
  }

  Future<void> disassociateWithAuthData(String platform) {
    return _linkWithAuthData(platform, null);
  }

  Future<void> _linkWithAuthData(String authType, Map<String, dynamic> data) {
    this.authData = {
      authType: data
    };
    return super.save();
  }

  /// 匿名登录
  static Future<LCUser> loginAnonymously() {
    Map<String, dynamic> data = {
      'id': new Uuid().generateV4()
    };
    return loginWithAuthData(data, 'anonymous');
  }

  /// 请求验证邮箱
  static Future<void> requestEmailVerify(String email) async {
    // TODO 参数合法性判断

    Map<String, dynamic> data = {
      'email': email
    };
    LCHttpRequest request = new LCHttpRequest('requestEmailVerify', LCHttpRequestMethod.post, data: data);
    await LeanCloud._client.send(request);
  }

  /// 请求手机验证码
  static Future<void> requestMobilePhoneVerify(String mobile) async {
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile
    };
    LCHttpRequest request = new LCHttpRequest('requestMobilePhoneVerify', LCHttpRequestMethod.post, data: data);
    await LeanCloud._client.send(request);
  }

  /// 验证手机号
  static Future<void> verifyMobilePhone(String mobile, String code) async {
    String path = 'verifyMobilePhone/$code';
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile
    };
    LCHttpRequest request = new LCHttpRequest(path, LCHttpRequestMethod.post, data: data);
    await LeanCloud._client.send(request);
  }

  /// 设置当前用户
  static Future<LCUser> becomeWithSessionToken(String sessionToken) async {
    Map<String, String> headers = {
      'X-LC-Session': sessionToken
    };
    LCHttpRequest request = new LCHttpRequest('users/me', LCHttpRequestMethod.get, headers: headers);
    Map<String, dynamic> response = await LeanCloud._client.send<Map<String, dynamic>>(request);
    LCObjectData objectData = LCObjectData.decode(response);
    currentUser = new LCUser();
    currentUser._merge(objectData);
    return currentUser;
  }

  /// 请求使用邮箱重置密码
  static Future<void> requestPasswordReset(String email) async {
    LCHttpRequest request = LCHttpRequest.createPostRequest('requestPasswordReset', data: {
      'email': email
    });
    await LeanCloud._client.send(request);
  }

  /// 请求验证码重置密码
  static Future<void> requestPasswordRestBySmsCode(String mobile) async {
    LCHttpRequest request = LCHttpRequest.createPostRequest('requestPasswordResetBySmsCode', data:{
      'mobilePhoneNumber': mobile
    });
    await LeanCloud._client.send(request);
  }

  /// 使用验证码重置密码
  static Future<void> resetPasswordBySmsCode(String mobile, String code, String newPassword) async {
    LCHttpRequest request = LCHttpRequest.createPutRequest('resetPasswordBySmsCode/$code', data: {
      'mobilePhoneNumber': mobile,
      'password': newPassword
    });
    await LeanCloud._client.send(request);
  }

  /// 更新密码
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    LCHttpRequest request = LCHttpRequest.createPutRequest('users/$objectId/updatePassword', data: {
      'old_password': oldPassword,
      'new_password': newPassword
    });
    Map<String, dynamic> response = await LeanCloud._client.send<Map<String, dynamic>>(request);
    LCObjectData objectData = LCObjectData.decode(response);
    _merge(objectData);
  }

  /// 注销登录
  static void logout() {
    currentUser = null;
  }

  Future<bool> isAuthenticated() async {
    if (sessionToken == null || objectId == null) {
      return false;
    }
    LCHttpRequest request = LCHttpRequest.createGetRequest('users/me');
    try {
      await LeanCloud._client.send(request);
      return true;
    } catch (Error) {
      return false;
    }
  }

  /// 私有方法
  static Future<LCUser> _login(Map<String, dynamic> data) async {
    LCHttpRequest request = new LCHttpRequest('login', LCHttpRequestMethod.post, data: data);
    Map<String, dynamic> response = await LeanCloud._client.send<Map<String, dynamic>>(request);
    LCObjectData objectData = LCObjectData.decode(response);
    currentUser = new LCUser();
    currentUser._merge(objectData);
    return currentUser;
  }

  static LCQuery<LCUser> getQuery() {
    return new LCQuery<LCUser>(ClassName);
  }
}