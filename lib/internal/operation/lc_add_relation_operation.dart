part of leancloud_storage;

class _LCAddRelationOperation extends _LCOperation {
  late List<LCObject> valueList;

  _LCAddRelationOperation(dynamic value) {
    valueList = List.from([value]);
  }

  @override
  apply(oldValue, String key) {
    LCRelation relation = new LCRelation();
    relation.targetClass = valueList[0].className!;
    return relation;
  }

  @override
  encode() {
    return {'__op': 'AddRelation', 'objects': _LCEncoder.encodeList(valueList)};
  }

  @override
  _LCOperation mergeWithPrevious(_LCOperation previousOp) {
    if (previousOp is _LCSetOperation || previousOp is _LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is _LCAddRelationOperation) {
      valueList.addAll(previousOp.valueList);
      return this;
    }
    throw new ArgumentError('Operation is invalid after previous operation.');
  }

  @override
  List? getNewObjectList() {
    return valueList;
  }
}
