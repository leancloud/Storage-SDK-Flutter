part of leancloud_storage;

/// 第三方登录选项
class LCUserAuthDataLoginOption {
  /// Union Id 平台
  String unionIdPlatform;

  /// 是否作为主账号
  bool asMainAccount;

  /// 是否在不存在的情况下返回失败
  bool failOnNotExist;

  LCUserAuthDataLoginOption() {
    unionIdPlatform = 'weixin';
    asMainAccount = false;
    failOnNotExist = false;
  } 
}