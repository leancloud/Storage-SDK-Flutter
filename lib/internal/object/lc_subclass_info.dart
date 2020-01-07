part of leancloud_storage;

class LCSubclassInfo {
  String className;
  Type classType;
  Function constructor;

  LCSubclassInfo(this.className, this.classType, this.constructor);
}