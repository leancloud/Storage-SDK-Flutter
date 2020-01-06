part of leancloud_storage;

class LCRole extends LCObject {
  String get name => this['name'];

  set name(String value) => this['name'] = value;

  LCRelation get roles => this['roles'];

  LCRelation get users => this['users'];

  LCRole() : super('_Role');
}