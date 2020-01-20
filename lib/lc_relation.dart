part of leancloud_storage;

/// 关系类
class LCRelation<T extends LCObject> {
  /// 字段名
  String key;

  /// 父对象
  LCObject parent;

  /// 关联类型名
  String targetClass;

  LCRelation();

  /// 获取 Relation 的查询对象
  LCQuery<T> query() {
    LCQuery<T> query = new LCQuery(targetClass);
    query.whereRelatedTo(parent, key);
    return query;
  }
}
