part of leancloud_storage;

/// 角色
class LCRole extends LCObject {
  static const String ClassName = '_Role';

  /// 获取角色名字
  String get name => this['name'];

  /// 设置角色名字
  set name(String value) => this['name'] = value;

  /// 获取角色 Relation
  LCRelation get roles => this['roles'];

  /// 获取用户 Relation
  LCRelation get users => this['users'];

  LCRole() : super(ClassName);

  static LCRole create(String name, LCACL acl) {
    LCRole role = new LCRole();
    role.name = name;
    role.acl = acl;
    return role;
  }

  /// 获取角色查询对象
  static LCQuery<LCRole> getQuery() {
    return new LCQuery<LCRole>(ClassName);
  }
}
