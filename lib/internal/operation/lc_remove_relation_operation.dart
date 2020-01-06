part of leancloud_storage;

class LCRemoveRelationOperation extends LCOperation {
  Set<LCObject> values;

  LCRemoveRelationOperation() {
    values = new Set<LCObject>();
  }

  @override
  apply(oldValue, String key) {
    Set<LCObject> result = Set.from(oldValue);
    result.removeAll(values);
    return result;
  }

  @override
  encode() {
    return {
      '__op': 'RemoveRelation',
      'objects': LCEncoder.encodeList(values.toList())
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCRemoveRelationOperation) {
      this.values.addAll(previousOp.values);
      return this;
    }
    // TODO 不支持的类型
    return null;
  }
  
}