part of leancloud_storage;

class _LCRemoveRelationOperation extends _LCOperation {
  late List<LCObject> valueList;

  _LCRemoveRelationOperation(dynamic value) {
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
    return {
      '__op': 'RemoveRelation',
      'objects': _LCEncoder.encodeList(valueList.toList())
    };
  }

  @override
  _LCOperation mergeWithPrevious(_LCOperation previousOp) {
    if (previousOp is _LCSetOperation || previousOp is _LCDeleteOperation) {
      return previousOp;
    }
    if (previousOp is _LCRemoveRelationOperation) {
      valueList.addAll(previousOp.valueList);
      return this;
    }
    throw new ArgumentError('Operation is invalid after previous operation.');
  }

  @override
  List? getNewObjectList() {
    return null;
  }
}
