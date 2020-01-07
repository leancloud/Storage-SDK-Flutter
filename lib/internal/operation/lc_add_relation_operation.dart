part of leancloud_storage;

class LCAddRelationOperation extends LCOperation {
  List<LCObject> valueList;

  LCAddRelationOperation() {
    valueList = new List<LCObject>();
  }

  @override
  apply(oldValue, String key) {
    LCRelation relation = new LCRelation();
    relation.targetClass = valueList[0].className;
    return relation;
  }

  @override
  encode() {
    return {
      '__op': 'AddRelation',
      'objects': LCEncoder.encodeList(valueList)
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCAddRelationOperation) {
      this.valueList.addAll(previousOp.valueList);
      return this;
    }
    // TODO 不支持的类型
    throw new Error();
  }

  @override
  List<LCObject> getNewObjectList() {
    return valueList;
  }
  
}