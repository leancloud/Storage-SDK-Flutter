part of leancloud_storage;

class SubclassInfo {
  String className;
  Type classType;
  Function constructor;

  SubclassInfo(this.className, this.classType, this.constructor);
}