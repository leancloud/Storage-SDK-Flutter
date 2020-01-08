part of leancloud_storage;

class LCUserAuthDataLoginOption {
  String unionIdPlatform;

  bool asMainAccount;

  bool failOnNotExist;

  LCUserAuthDataLoginOption() {
    unionIdPlatform = 'weixin';
    asMainAccount = false;
    failOnNotExist = false;
  } 
}