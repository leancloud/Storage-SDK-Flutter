part of leancloud_storage;

/// [LCUser] UnionID login parameters.
class LCUserAuthDataLoginOption {
  /// The platform of the UnionID.
  /// 
  /// This name can be specified by the developer.
  String unionIdPlatform;

  /// Whether the current authentication information will be used as the main account.
  bool asMainAccount;

  /// Whether the login request will fail if no user matching this authData exists.
  bool failOnNotExist;

  LCUserAuthDataLoginOption() {
    unionIdPlatform = 'weixin';
    asMainAccount = false;
    failOnNotExist = false;
  }
}
