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
    if (isNullOrEmpty(username)) {
      throw ArgumentError.notNull('username');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    if (objectId != null) {
      throw ArgumentError('Cannot sign up a user that already exists.');
    }
    await super.save();
    currentUser = this;
    return this;
  }

  /// 请求登录注册码
  static Future requestLogionSMSCode(String mobile, { String validateToken }) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile
    };
    if (validateToken != null) {
      data['validate_token'] = validateToken;
    }
    await LeanCloud._httpClient.post('requestLoginSmsCode', data: data);
  }

  /// 以手机号和验证码登录或注册并登录
  static Future<LCUser> signUpOrLoginByMobilePhone(String mobile, String code) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    Map response = await LeanCloud._httpClient.post('usersByMobilePhone', data: {
      'mobilePhoneNumber': mobile,
      'smsCode': code
    });
    LCObjectData objectData = LCObjectData.decode(response);
    currentUser = new LCUser();
    currentUser._merge(objectData);
    return currentUser;
  }

  /// 以账号和密码登陆
  static Future<LCUser> login(String username, String password) {
    if (isNullOrEmpty(username)) {
      throw ArgumentError.notNull('username');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    Map<String, dynamic> data = {
      'username': username,
      'password': password
    };
    return _login(data);
  }

  /// 以邮箱和密码登陆
  static Future<LCUser> loginByEmail(String email, String password) {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull('email');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    Map<String, dynamic> data = {
      'email': email,
      'password': password
    };
    return _login(data);
  }

  /// 以手机号和密码登陆
  static Future<LCUser> loginByMobilePhoneNumber(String mobile, String password) {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile,
      'password': password
    };
    return _login(data);
  }

  /// 以手机号和验证码登录
  static Future<LCUser> loginBySMSCode(String mobile, String code) {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile,
      'smsCode': code
    };
    return _login(data);
  }

  /// 使用第三方数据登录
  static Future<LCUser> loginWithAuthData(Map<String, dynamic> authData, String platform, { LCUserAuthDataLoginOption option }) {
    if (authData == null) {
      throw ArgumentError.notNull('authData');
    }
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    if (option == null) {
      option = new LCUserAuthDataLoginOption();
    }
    return _loginWithAuthData(platform, authData, option.failOnNotExist);
  }

  /// 使用第三方数据和 Union Id 登录
  static Future<LCUser> loginWithAuthDataAndUnionId(Map<String, dynamic> authData, String platform, String unionId, { LCUserAuthDataLoginOption option }) {
    if (authData == null) {
      throw ArgumentError.notNull('authData');
    }
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    if (isNullOrEmpty(unionId)) {
      throw ArgumentError.notNull('unionId');
    }
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
    Map response = await LeanCloud._httpClient.post(path, data: {
      'authData': authData
    });
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

  /// 绑定第三方登录
  Future associateAuthData(Map<String, dynamic> authData, String platform) {
    if (authData == null) {
      throw ArgumentError.notNull('authData');
    }
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    return _linkWithAuthData(platform, authData);
  }

  /// 使用 Union Id 绑定第三方登录
  Future associateAuthDataAndUnionId(Map<String, dynamic> authData, String platform, String unionId, { LCUserAuthDataLoginOption option }) {
    if (authData == null) {
      throw ArgumentError.notNull('authData');
    }
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    if (isNullOrEmpty(unionId)) {
      throw ArgumentError.notNull('unionId');
    }
    if (option == null) {
      option = new LCUserAuthDataLoginOption();
    }
    _mergeAuthData(authData, unionId, option);
    return _linkWithAuthData(platform, authData);
  }

  /// 解绑第三方登录
  Future disassociateWithAuthData(String platform) {
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    return _linkWithAuthData(platform, null);
  }

  Future _linkWithAuthData(String authType, Map<String, dynamic> data) {
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
  static Future requestEmailVerify(String email) async {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull(email);
    }
    Map<String, dynamic> data = {
      'email': email
    };
    await LeanCloud._httpClient.post('requestEmailVerify', data: data);
  }

  /// 请求手机验证码
  static Future requestMobilePhoneVerify(String mobile) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile
    };
    await LeanCloud._httpClient.post('requestMobilePhoneVerify', data: data);
  }

  /// 验证手机号
  static Future verifyMobilePhone(String mobile, String code) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    String path = 'verifyMobilePhone/$code';
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile
    };
    await LeanCloud._httpClient.post(path, data: data);
  }

  /// 设置当前用户
  static Future<LCUser> becomeWithSessionToken(String sessionToken) async {
    if (isNullOrEmpty(sessionToken)) {
      throw ArgumentError.notNull('sessionToken');
    }
    Map<String, String> headers = {
      'X-LC-Session': sessionToken
    };
    Map response = await LeanCloud._httpClient.get('users/me', headers: headers);
    LCObjectData objectData = LCObjectData.decode(response);
    currentUser = new LCUser();
    currentUser._merge(objectData);
    return currentUser;
  }

  /// 请求使用邮箱重置密码
  static Future requestPasswordReset(String email) async {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull('email');
    }
    await LeanCloud._httpClient.post('requestPasswordReset', data: {
      'email': email
    });
  }

  /// 请求验证码重置密码
  static Future requestPasswordRestBySmsCode(String mobile) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    await LeanCloud._httpClient.post('requestPasswordResetBySmsCode', data:{
      'mobilePhoneNumber': mobile
    });
  }

  /// 使用验证码重置密码
  static Future resetPasswordBySmsCode(String mobile, String code, String newPassword) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    if (isNullOrEmpty(newPassword)) {
      throw ArgumentError.notNull('newPassword');
    }
    await LeanCloud._httpClient.put('resetPasswordBySmsCode/$code', data: {
      'mobilePhoneNumber': mobile,
      'password': newPassword
    });
  }

  /// 更新密码
  Future updatePassword(String oldPassword, String newPassword) async {
    if (isNullOrEmpty(oldPassword)) {
      throw ArgumentError.notNull('oldPassword');
    }
    if (isNullOrEmpty(newPassword)) {
      throw ArgumentError.notNull('newPassword');
    }
    Map response = await LeanCloud._httpClient.put('users/$objectId/updatePassword', data: {
      'old_password': oldPassword,
      'new_password': newPassword
    });
    LCObjectData objectData = LCObjectData.decode(response);
    _merge(objectData);
  }

  /// 注销登录
  static void logout() {
    currentUser = null;
  }

  /// 是否是有效登录
  Future<bool> isAuthenticated() async {
    if (sessionToken == null || objectId == null) {
      return false;
    }
    try {
      await LeanCloud._httpClient.get('users/me');
      return true;
    } catch (Error) {
      return false;
    }
  }

  /// 私有方法
  static Future<LCUser> _login(Map<String, dynamic> data) async {
    Map response = await LeanCloud._httpClient.post('login', data: data);
    LCObjectData objectData = LCObjectData.decode(response);
    currentUser = new LCUser();
    currentUser._merge(objectData);
    return currentUser;
  }

  /// 得到 LCUser 类型的查询对象
  static LCQuery<LCUser> getQuery() {
    return new LCQuery<LCUser>(ClassName);
  }
}