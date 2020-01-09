part of leancloud_storage;

/// 访问控制类
class LCACL {
  static const String PublicKey = '*';
  static const String RoleKeyPrefix = 'role:';

  Set<String> readers = new Set<String>();
  Set<String> writers = new Set<String>();

  LCACL();

  /// 创建属于某个用户的 ACL 对象
  static LCACL createWithOwner(LCUser owner) {
    LCACL acl = new LCACL();
    acl.setUserReadAccess(owner, true);
    acl.setUserWriteAccess(owner, true);
    return acl;
  }
  
  /// Public
  /// 是否公共可读
  bool getPublilcReadAccess() {
    return _getAccess(readers, PublicKey);
  }

  /// 设置是否公共可读
  void setPublicReadAccess(bool value) {
    _setAccess(readers, PublicKey, value);
  }

  /// 是否公共可写
  bool getPublicWriteAccess() {
    return _getAccess(writers, PublicKey);
  }

  /// 设置是否公共可写
  void setPublicWriteAccess(bool value) {
    _setAccess(writers, PublicKey, value);
  }

  /// User
  /// 是否对某个用户可读
  bool getUserIdReadAccess(String userId) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError.notNull('userId');
    }
    return _getAccess(readers, userId);
  }

  /// 设置某个用户是否可读
  void setUserIdReadAccess(String userId, bool value) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError.notNull('userId');
    }
    _setAccess(readers, userId, value);
  }

  /// 是否对某个用户可写
  bool getUserIdWriteAccess(String userId) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError.notNull('userId');
    }
    return _getAccess(writers, userId);
  }

  /// 设置某个用户是否可写
  void setUserIdWriteAccess(String userId, bool value) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError.notNull('userId');
    }
    _setAccess(writers, userId, value);
  }

  /// 是否对某个用户可读
  bool getUserReadAccess(LCUser user) {
    if (user == null) {
      throw ArgumentError.notNull('user');
    }
    return getUserIdReadAccess(user.objectId);
  }

  /// 设置某个用户是否可读
  void setUserReadAccess(LCUser user, bool value) {
    if (user == null) {
      throw ArgumentError.notNull('user');
    }
    _setAccess(readers, user.objectId, value);
  }

  /// 是否对某个用户可写
  bool getUserWriteAccess(LCUser user) {
    if (user == null) {
      throw ArgumentError.notNull('user');
    }
    return getUserIdWriteAccess(user.objectId);
  }

  /// 设置某个用户是否可写
  void setUserWriteAccess(LCUser user, bool value) {
    if (user == null) {
      throw ArgumentError.notNull('user');
    }
    _setAccess(writers, user.objectId, value);
  }

  /// Role
  /// 是否对某个角色可读
  bool getRoleReadAccess(LCRole role) {
    if (role == null) {
      throw ArgumentError.notNull('role');
    }
    return _getAccess(readers, '$RoleKeyPrefix${role.name}');
  }

  /// 设置某个角色是否可读
  void setRoleReadAccess(LCRole role, bool value) {
    if (role == null) {
      throw ArgumentError.notNull('role');
    }
    _setAccess(readers, '$RoleKeyPrefix${role.name}', value);
  }

  /// 是否对某个角色可写
  bool getRoleWriteAccess(LCRole role) {
    if (role == null) {
      throw ArgumentError.notNull('role');
    }
    return _getAccess(writers, '$RoleKeyPrefix${role.name}');
  }

  /// 设置某个角色是否可写
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