part of leancloud_storage;

/// [LCUser] UnionID login parameters.
class LCUserAuthDataLoginOption {
  /// The platform of the UnionID.
  /// 
  /// This name can be specified by the developer.
  late String unionIdPlatform;

  /// Whether the current authentication information will be used as the main account.
  late bool asMainAccount;

  /// Whether the login request will fail if no user matching this authData exists.
  late bool failOnNotExist;

  LCUserAuthDataLoginOption() {
    unionIdPlatform = 'weixin';
    asMainAccount = false;
    failOnNotExist = false;
  }
}
