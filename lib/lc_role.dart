part of leancloud_storage;

/// 角色
class LCRole extends LCObject {
  static const String ClassName = '_Role';

  String get name => this['name'];

  set name(String value) => this['name'] = value;

  LCRelation get roles => this['roles'];

  LCRelation get users => this['users'];

  LCRole() : super(ClassName);

  static LCRole create(String name, LCACL acl) {
    LCRole role = new LCRole();
    role.name = name;
    role.acl = acl;
    return role;
  }

  static LCQuery<LCRole> getQuery() {
    return new LCQuery<LCRole>(ClassName);
  }
}