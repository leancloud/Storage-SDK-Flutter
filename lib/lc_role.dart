part of leancloud_storage;

/// LeanCloud Role, a group of users for the purposes of granting permissions.
/// 
/// Role is specified by their sets of child [LCUser]s and child [LCRole]s,
/// all of which are granted any permissions that the parent role has.
/// 
class LCRole extends LCObject {
  static const String ClassName = '_Role';

  String get name => this['name'];

  set name(String value) => this['name'] = value;

  LCRelation get roles => this['roles'];

  LCRelation get users => this['users'];

  LCRole() : super(ClassName);

  /// Creates a role.
  /// 
  /// Role must have a name (which cannot be changed after creation),
  /// and must specify a [LCACL].
  static LCRole create(String name, LCACL acl) {
    LCRole role = new LCRole();
    role.name = name;
    role.acl = acl;
    return role;
  }

  /// Constructs a [LCQuery] for this role.
  static LCQuery<LCRole> getQuery() {
    return new LCQuery<LCRole>(ClassName);
  }
}
