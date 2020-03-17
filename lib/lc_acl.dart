part of leancloud_storage;

/// 访问控制
class LCACL {
  static const String PublicKey = '*';
  static const String RoleKeyPrefix = 'role:';

  Set<String> readers = new Set<String>();
  Set<String> writers = new Set<String>();

  LCACL();

  /// 创建属于 [LCUser] 的 ACL 对象
  static LCACL createWithOwner(LCUser owner) {
    LCACL acl = new LCACL();
    acl.setUserReadAccess(owner, true);
    acl.setUserWriteAccess(owner, true);
    return acl;
  }

  /// 是否公共可读
  bool getPublilcReadAccess() {
    return _getAccess(readers, PublicKey);
  }

  /// 设置 [value] 公共可读
  void setPublicReadAccess(bool value) {
    _setAccess(readers, PublicKey, value);
  }

  /// 是否公共可写
  bool getPublicWriteAccess() {
    return _getAccess(writers, PublicKey);
  }

  /// 设置 [value] 公共可写
  void setPublicWriteAccess(bool value) {
    _setAccess(writers, PublicKey, value);
  }

  /// [userId] 是否可读
  bool getUserIdReadAccess(String userId) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError.notNull('userId');
    }
    return _getAccess(readers, userId);
  }

  /// 设置 [userId] 可读 [value]
  void setUserIdReadAccess(String userId, bool value) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError.notNull('userId');
    }
    _setAccess(readers, userId, value);
  }

  /// [userId] 是否可写
  bool getUserIdWriteAccess(String userId) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError.notNull('userId');
    }
    return _getAccess(writers, userId);
  }

  /// 设置 [userId] 可写 [value]
  void setUserIdWriteAccess(String userId, bool value) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError.notNull('userId');
    }
    _setAccess(writers, userId, value);
  }

  /// [user] 是否可读
  bool getUserReadAccess(LCUser user) {
    if (user == null) {
      throw ArgumentError.notNull('user');
    }
    return getUserIdReadAccess(user.objectId);
  }

  /// 设置 [user] 可读 [value]
  void setUserReadAccess(LCUser user, bool value) {
    if (user == null) {
      throw ArgumentError.notNull('user');
    }
    _setAccess(readers, user.objectId, value);
  }

  /// [user] 是否可写
  bool getUserWriteAccess(LCUser user) {
    if (user == null) {
      throw ArgumentError.notNull('user');
    }
    return getUserIdWriteAccess(user.objectId);
  }

  /// 设置 [user] 可写 [value]
  void setUserWriteAccess(LCUser user, bool value) {
    if (user == null) {
      throw ArgumentError.notNull('user');
    }
    _setAccess(writers, user.objectId, value);
  }

  /// [role] 是否可读
  bool getRoleReadAccess(LCRole role) {
    if (role == null) {
      throw ArgumentError.notNull('role');
    }
    return _getAccess(readers, '$RoleKeyPrefix${role.name}');
  }

  /// 设置 [role] 可读 [value]
  void setRoleReadAccess(LCRole role, bool value) {
    if (role == null) {
      throw ArgumentError.notNull('role');
    }
    _setAccess(readers, '$RoleKeyPrefix${role.name}', value);
  }

  /// [role] 是否可写
  bool getRoleWriteAccess(LCRole role) {
    if (role == null) {
      throw ArgumentError.notNull('role');
    }
    return _getAccess(writers, '$RoleKeyPrefix${role.name}');
  }

  /// 设置 [role] 可写 [value]
  void setRoleWriteAccess(LCRole role, bool value) {
    if (role == null) {
      throw ArgumentError.notNull('role');
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
