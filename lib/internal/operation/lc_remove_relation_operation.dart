part of leancloud_storage;

class LCRemoveRelationOperation extends LCOperation {
  List<LCObject> valueList;

  LCRemoveRelationOperation() {
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
      '__op': 'RemoveRelation',
      'objects': LCEncoder.encodeList(valueList.toList())
    };
  }

  @override
  LCOperation mergeWithPrevious(LCOperation previousOp) {
    if (previousOp is LCSetOperation || previousOp is LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is LCRemoveRelationOperation) {
      valueList.addAll(previousOp.valueList);
      return this;
    }
    // TODO 不支持的类型
    return null;
  }

  @override
  List getNewObjectList() {
    return null;
  }
  
}