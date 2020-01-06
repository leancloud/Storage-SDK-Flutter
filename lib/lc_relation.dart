part of leancloud_storage;

/// 关系类
class LCRelation<T extends LCObject> {
  String key;

  LCObject parent;

  String targetClass;

  LCRelation();

  void add(T object) {
    if (object == null) {
      // TODO 错误提示

      throw new Error();
    }
    if (targetClass == null || targetClass.isEmpty) {
      targetClass = object.className;
    }
    
  }
}