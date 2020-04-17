part of leancloud_storage;

const String CurrentUserKey = 'current_user';

/// 用户
class LCUser extends LCObject {
  static const String ClassName = '_User';

  /// 获取用户名
  String get username => this['username'];

  /// 设置用户名为 [value]
  set username(String value) => this['username'] = value;

  /// 获取密码
  String get password => this['password'];

  /// 设置密码为 [value]
  set password(String value) => this['password'] = value;

  /// 获取邮箱
  String get email => this['email'];

  /// 设置邮箱为 [value]
  set email(String value) => this["email"] = value;

  /// 获取手机号
  String get mobile => this['mobilePhoneNumber'];

  /// 设置手机号为 [value]
  set mobile(String value) => this['mobilePhoneNumber'] = value;

  /// 获取 Session Token
  String get sessionToken => this['sessionToken'];

  /// 设置 Session Token 为 [value]
  set sessionToken(String value) => this['sessionToken'] = value;

  /// 是否已经验证邮箱
  bool get emailVerified => this['emailVerified'];

  /// 是否已经验证手机号
  bool get mobileVerified => this['mobilePhoneVerified'];

  /// 获取第三方授权信息
  Map get authData => this['authData'];

  /// 设置第三方授权信息为 [value]
  set authData(Map value) => this['authData'] = value;

  /// 当前用户
  static LCUser _currentUser;

  LCUser() : super(LCUser.ClassName);

  static LCUser _fromObjectData(_LCObjectData objectData) {
    LCUser user = new LCUser();
    user._merge(objectData);
    return user;
  }

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
    _currentUser = this;
    await _saveToLocal();
    return this;
  }

  /// 手机号 [mobile] 请求登录注册码，图像验证码为 [validateToken]
  static Future requestLogionSMSCode(String mobile,
      {String validateToken}) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile};
    if (validateToken != null) {
      data['validate_token'] = validateToken;
    }
    await LeanCloud._httpClient.post('requestLoginSmsCode', data: data);
  }

  /// 以手机号 [mobile] 和验证码 [code] 登录或注册并登录
  static Future<LCUser> signUpOrLoginByMobilePhone(
      String mobile, String code) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    Map response = await LeanCloud._httpClient.post('usersByMobilePhone',
        data: {'mobilePhoneNumber': mobile, 'smsCode': code});
    _LCObjectData objectData = _LCObjectData.decode(response);
    _currentUser = LCUser._fromObjectData(objectData);
    await _saveToLocal();
    return _currentUser;
  }

  /// 以账号 [username] 和密码 [password] 登陆
  static Future<LCUser> login(String username, String password) {
    if (isNullOrEmpty(username)) {
      throw ArgumentError.notNull('username');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    Map<String, dynamic> data = {'username': username, 'password': password};
    return _login(data);
  }

  /// 以邮箱 [email] 和密码 [password] 登陆
  static Future<LCUser> loginByEmail(String email, String password) {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull('email');
    }
    if (isNullOrEmpty(password)) {
      throw ArgumentError.notNull('password');
    }
    Map<String, dynamic> data = {'email': email, 'password': password};
    return _login(data);
  }

  /// 以手机号 [mobile] 和密码 [password] 登陆
  static Future<LCUser> loginByMobilePhoneNumber(
      String mobile, String password) {
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

  /// 以手机号 [mobile] 和验证码 [code] 登录
  static Future<LCUser> loginBySMSCode(String mobile, String code) {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile, 'smsCode': code};
    return _login(data);
  }

  /// 使用第三方数据 [authData]，平台 [platform] 及第三方登录选项 [option] 登录
  static Future<LCUser> loginWithAuthData(
      Map<String, dynamic> authData, String platform,
      {LCUserAuthDataLoginOption option}) {
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

  /// 使用第三方数据 [authData]，平台 [platfoirm]，[unionId] 及第三方登录选项 [option] 登录
  static Future<LCUser> loginWithAuthDataAndUnionId(
      Map<String, dynamic> authData, String platform, String unionId,
      {LCUserAuthDataLoginOption option}) {
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

  static Future<LCUser> _loginWithAuthData(
      String authType, Map<String, dynamic> data, bool failOnNotExist) async {
    Map<String, dynamic> authData = {authType: data};
    String path = failOnNotExist ? 'users?failOnNotExist=true' : 'users';
    Map response =
        await LeanCloud._httpClient.post(path, data: {'authData': authData});
    _LCObjectData objectData = _LCObjectData.decode(response);
    _currentUser = LCUser._fromObjectData(objectData);
    await _saveToLocal();
    return _currentUser;
  }

  static void _mergeAuthData(Map<String, dynamic> authData, String unionId,
      LCUserAuthDataLoginOption option) {
    authData['platform'] = option.unionIdPlatform;
    authData['main_account'] = option.asMainAccount;
    authData['unionid'] = unionId;
  }

  /// 与第三方登录数据 [authData]，平台 [platform] 进行绑定
  Future associateAuthData(Map<String, dynamic> authData, String platform) {
    if (authData == null) {
      throw ArgumentError.notNull('authData');
    }
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    return _linkWithAuthData(platform, authData);
  }

  /// 与第三方登录数据 [authData]，平台 [platform]，[unionId] 进行绑定
  Future associateAuthDataAndUnionId(
      Map<String, dynamic> authData, String platform, String unionId,
      {LCUserAuthDataLoginOption option}) {
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

  /// 解绑 [platform] 平台的第三方登录数据
  Future disassociateWithAuthData(String platform) {
    if (isNullOrEmpty(platform)) {
      throw ArgumentError.notNull('platform');
    }
    return _linkWithAuthData(platform, null);
  }

  Future _linkWithAuthData(String authType, Map<String, dynamic> data) {
    this.authData = {authType: data};
    return super.save();
  }

  /// 匿名登录
  static Future<LCUser> loginAnonymously() {
    Map<String, dynamic> data = {'id': new _LCUuid().generateV4()};
    return loginWithAuthData(data, 'anonymous');
  }

  /// 请求验证邮箱 [email]
  static Future requestEmailVerify(String email) async {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull(email);
    }
    Map<String, dynamic> data = {'email': email};
    await LeanCloud._httpClient.post('requestEmailVerify', data: data);
  }

  /// 请求手机 [mobile] 验证码
  static Future requestMobilePhoneVerify(String mobile) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile};
    await LeanCloud._httpClient.post('requestMobilePhoneVerify', data: data);
  }

  /// 用验证码 [code] 验证手机号 [mobile]
  static Future verifyMobilePhone(String mobile, String code) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    String path = 'verifyMobilePhone/$code';
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile};
    await LeanCloud._httpClient.post(path, data: data);
  }

  /// 设置当前用户的 [sessionToken]
  static Future<LCUser> becomeWithSessionToken(String sessionToken) async {
    if (isNullOrEmpty(sessionToken)) {
      throw ArgumentError.notNull('sessionToken');
    }
    Map<String, String> headers = {'X-LC-Session': sessionToken};
    Map response =
        await LeanCloud._httpClient.get('users/me', headers: headers);
    _LCObjectData objectData = _LCObjectData.decode(response);
    _currentUser = LCUser._fromObjectData(objectData);
    await _saveToLocal();
    return _currentUser;
  }

  /// 请求使用邮箱 [email] 重置密码
  static Future requestPasswordReset(String email) async {
    if (isNullOrEmpty(email)) {
      throw ArgumentError.notNull('email');
    }
    await LeanCloud._httpClient
        .post('requestPasswordReset', data: {'email': email});
  }

  /// 请求手机 [mobile] 验证码重置密码
  static Future requestPasswordRestBySmsCode(String mobile) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    await LeanCloud._httpClient.post('requestPasswordResetBySmsCode',
        data: {'mobilePhoneNumber': mobile});
  }

  /// 使用验证码 [code] 重置手机 [mobile] 的密码 [newPassword]
  static Future resetPasswordBySmsCode(
      String mobile, String code, String newPassword) async {
    if (isNullOrEmpty(mobile)) {
      throw ArgumentError.notNull('mobile');
    }
    if (isNullOrEmpty(code)) {
      throw ArgumentError.notNull('code');
    }
    if (isNullOrEmpty(newPassword)) {
      throw ArgumentError.notNull('newPassword');
    }
    await LeanCloud._httpClient.put('resetPasswordBySmsCode/$code',
        data: {'mobilePhoneNumber': mobile, 'password': newPassword});
  }

  /// 使用 [newPassword] 更新旧密码 [oldPassword]
  Future updatePassword(String oldPassword, String newPassword) async {
    if (isNullOrEmpty(oldPassword)) {
      throw ArgumentError.notNull('oldPassword');
    }
    if (isNullOrEmpty(newPassword)) {
      throw ArgumentError.notNull('newPassword');
    }
    Map response = await LeanCloud._httpClient.put(
        'users/$objectId/updatePassword',
        data: {'old_password': oldPassword, 'new_password': newPassword});
    _LCObjectData objectData = _LCObjectData.decode(response);
    _merge(objectData);
  }

  /// 注销登录
  static Future logout() async {
    _currentUser = null;
    if (isMobilePlatform()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(CurrentUserKey);
    }
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

  /// 是否是匿名登录
  bool get isAnonymous => authData != null && authData['anonymous'] != null;

  /// 私有方法
  static Future<LCUser> _login(Map<String, dynamic> data) async {
    Map response = await LeanCloud._httpClient.post('login', data: data);
    _LCObjectData objectData = _LCObjectData.decode(response);
    _currentUser = LCUser._fromObjectData(objectData);
    await _saveToLocal();
    return _currentUser;
  }

  static Future _saveToLocal() async {
    if (isMobilePlatform()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userData = jsonEncode(_LCObjectData.encode(_currentUser._data));
        await prefs.setString(CurrentUserKey, userData);
      } on Error catch (e) {
        LCLogger.error(e.toString());
      }
    }
  }

  /// 得到 LCUser 类型的查询对象
  static LCQuery<LCUser> getQuery() {
    return new LCQuery<LCUser>(ClassName);
  }

  /// 获取当前用户
  static Future<LCUser> getCurrent() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    if (isMobilePlatform()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userData = prefs.getString(CurrentUserKey);
        _LCObjectData objectData = _LCObjectData.decode(jsonDecode(userData));
        _currentUser = LCUser._fromObjectData(objectData);
      } on Error catch (e) {
        LCLogger.error(e.toString());
      }
    }
    return _currentUser;
  }
}
