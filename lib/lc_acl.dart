part of leancloud_storage;

/// LeanCloud Access Control Lists.
class LCACL {
  static const String PublicKey = '*';
  static const String RoleKeyPrefix = 'role:';

  Map<String, bool> readAccess = new Map<String, bool>();
  Map<String, bool> writeAccess = new Map<String, bool>();

  LCACL();

  /// Creates an ACL object of [LCUser].
  static LCACL createWithOwner(LCUser owner) {
    LCACL acl = new LCACL();
    acl.setUserReadAccess(owner, true);
    acl.setUserWriteAccess(owner, true);
    return acl;
  }

  bool getPublilcReadAccess() {
    return _getAccess(readAccess, PublicKey);
  }

  void setPublicReadAccess(bool value) {
    _setAccess(readAccess, PublicKey, value);
  }

  bool getPublicWriteAccess() {
    return _getAccess(writeAccess, PublicKey);
  }

  void setPublicWriteAccess(bool value) {
    _setAccess(writeAccess, PublicKey, value);
  }

  bool getUserIdReadAccess(String userId) {
    return _getAccess(readAccess, userId);
  }

  void setUserIdReadAccess(String userId, bool value) {
    _setAccess(readAccess, userId, value);
  }

  bool getUserIdWriteAccess(String userId) {
    return _getAccess(writeAccess, userId);
  }

  void setUserIdWriteAccess(String userId, bool value) {
    _setAccess(writeAccess, userId, value);
  }

  bool getUserReadAccess(LCUser user) {
    return getUserIdReadAccess(user.objectId!);
  }

  void setUserReadAccess(LCUser user, bool value) {
    setUserIdReadAccess(user.objectId!, value);
  }

  bool getUserWriteAccess(LCUser user) {
    return getUserIdWriteAccess(user.objectId!);
  }

  void setUserWriteAccess(LCUser user, bool value) {
    setUserIdWriteAccess(user.objectId!, value);
  }

  bool getRoleReadAccess(LCRole role) {
    return _getAccess(readAccess, '$RoleKeyPrefix${role.name}');
  }

  void setRoleReadAccess(LCRole role, bool value) {
    _setAccess(readAccess, '$RoleKeyPrefix${role.name}', value);
  }

  bool getRoleWriteAccess(LCRole role) {
    return _getAccess(writeAccess, '$RoleKeyPrefix${role.name}');
  }

  void setRoleWriteAccess(LCRole role, bool value) {
    _setAccess(writeAccess, '$RoleKeyPrefix${role.name}', value);
  }

  bool _getAccess(Map<String, bool> access, String key) {
    return access[key] ?? false;
  }

  void _setAccess(Map<String, bool> access, String key, bool value) {
    access[key] = value;
  }
}
