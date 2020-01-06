part of leancloud_storage;

class LCAddRelationOperation extends LCOperation {
  List<LCObject> values;

  LCAddRelationOperation() {
    values = new List<LCObject>();
  }

  @override
  apply(oldValue, String key) {
    List<LCObject> result = oldValue != null ? List.from(oldValue) : new List<LCObject>();
    result.addAll(values);
    return result;
  }

  @override
  encode() {
    return {
      '__op': 'AddRelation',
      'objects': LCEncoder.encodeList(values.toList())
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCAddRelationOperation) {
      this.values.addAll(previousOp.values);
      return this;
    }
    // TODO 不支持的类型
    throw new Error();
  }
  
}