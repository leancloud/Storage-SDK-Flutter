part of leancloud_storage;

/// 访问控制类
class LCACL {
  static const String PublicKey = '*';
  static const String RoleKeyPrefix = 'role:';

  Set<String> readers = new Set<String>();
  Set<String> writers = new Set<String>();

  LCACL();

  static LCACL createWithOwner(LCUser owner) {
    LCACL acl = new LCACL();
    acl.setUserReadAccess(owner, true);
    acl.setUserWriteAccess(owner, true);
    return acl;
  }
  
  /// Public
  bool getPublilcReadAccess() {
    return _getAccess(readers, PublicKey);
  }

  void setPublicReadAccess(bool value) {
    _setAccess(readers, PublicKey, value);
  }

  bool getPublicWriteAccess() {
    return _getAccess(writers, PublicKey);
  }

  void setPublicWriteAccess(bool value) {
    _setAccess(writers, PublicKey, value);
  }

  /// User
  bool getUserIdReadAccess(String userId) {
    if (userId == null || userId.isEmpty) {
      return false;
    }
    return _getAccess(readers, userId);
  }

  void setUserIdReadAccess(String userId, bool value) {
    if (userId == null || userId.isEmpty) {
      return;
    }
    _setAccess(readers, userId, value);
  }

  bool getUserIdWriteAccess(String userId) {
    if (userId == null || userId.isEmpty) {
      return false;
    }
    return _getAccess(writers, userId);
  }

  void setUserIdWriteAccess(String userId, bool value) {
    if (userId == null || userId.isEmpty) {
      return;
    }
    _setAccess(writers, userId, value);
  }

  bool getUserReadAccess(LCUser user) {
    if (user == null) {
      return false;
    }
    return getUserIdReadAccess(user.objectId);
  }

  void setUserReadAccess(LCUser user, bool value) {
    if (user == null) {
      return;
    }
    _setAccess(readers, user.objectId, value);
  }

  bool getUserWriteAccess(LCUser user) {
    if (user == null) {
      return false;
    }
    return getUserIdWriteAccess(user.objectId);
  }

  void setUserWriteAccess(LCUser user, bool value) {
    if (user == null) {
      return;
    }
    _setAccess(writers, user.objectId, value);
  }

  /// Role
  bool getRoleReadAccess(LCRole role) {
    if (role == null) {
      return false;
    }
    return _getAccess(readers, '$RoleKeyPrefix${role.name}');
  }

  void setRoleReadAccess(LCRole role, bool value) {
    if (role == null) {
      return;
    }
    _setAccess(readers, '$RoleKeyPrefix${role.name}', value);
  }

  bool getRoleWriteAccess(LCRole role) {
    if (role == null) {
      return false;
    }
    return _getAccess(writers, '$RoleKeyPrefix${role.name}');
  }

  void setRoleWriteAccess(LCRole role, bool value) {
    if (role == null) {
      return;
    }
    _setAccess(writers, '$RoleKeyPrefix${role.name}', value);
  }

  bool _getAccess(Set<String> s, String key) {
    return s.contains(key);
  }

  void _setAccess(Set<String> s, String key, bool value) {
    if (value) {
      s.add(key);
    } else {
      s.remove(key);
    }
  }
}