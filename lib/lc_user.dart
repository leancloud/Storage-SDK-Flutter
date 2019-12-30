part of leancloud_storage;

/// 用户类
class LCUser extends LCObject {
  /// 用户名
  String username;

  /// 密码
  String password;

  /// 邮箱
  String email;

  /// 手机号
  String mobile;

  /// 当前用户
  static LCUser currentUser;

  bool get isAuthenticated => false;

  LCUser() : super('_User') {
    
  }

  /// 注册
  Future<LCUser> signUp() {

  }

  /// 请求注册码
  static Future<void> requestSMSCode(String mobile) {

  }

  /// 请求登录注册码
  static Future<void> requestLogionSMSCode(String mobile) {

  }

  /// 以手机号和验证码登录或注册并登录
  static Future<LCUser> signUpOrLoginByMobilePhone(String mobile, String code) {

  }

  /// 以账号和密码登陆
  static Future<LCUser> login(String username, String password) {

  }

  /// 以邮箱和密码登陆
  static Future<LCUser> loginByEmail(String email, String password) {

  }

  /// 以手机号和密码登陆
  static Future<LCUser> loginByMobilePhoneNumber(String mobile, String password) {

  }

  /// 请求手机验证码
  static Future<void> requestMobilePhoneVerify(String mobile) {

  }

  /// 验证手机号
  static Future<void> verifyMobilePhone(String code) {

  }

  /// 设置当前用户
  static Future<LCUser> becomeWithSessionToken(String sessionToken) {

  }

  /// 请求使用邮箱 
  static Future<void> requestPasswordReset(String email) {

  }
}