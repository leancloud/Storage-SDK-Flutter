part of leancloud_storage;

/// LeanCloud Relation.
/// 
/// This can be used to access all of the children of a many-to-many relationship.
/// Each relation is associated with a particular parent object and key. 
class LCRelation<T extends LCObject> {
  late String key;

  late LCObject parent;

  late String targetClass;

  LCRelation();

  /// Constructs a [LCQuery] that is limited to [LCObject] in this relation.
  LCQuery<T> query() {
    LCQuery<T> query = new LCQuery(targetClass);
    query.whereRelatedTo(parent, key);
    return query;
  }
}
