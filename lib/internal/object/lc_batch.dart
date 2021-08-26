part of leancloud_storage;

/// LeanCloud batch saving utilities.
class _LCBatch {
  late HashSet<LCObject> objects;

  _LCBatch(Iterable<LCObject>? objs) {
    objects = new HashSet<LCObject>();
    if (objs != null) {
      objs.forEach((item) {
        objects.add(item);
      });
    }
  }

  static bool hasCircleReference(Object? object, {HashSet<LCObject>? parents}) {
    if (parents == null) {
      parents = new HashSet();
    }
    if (parents.contains(object)) {
      return true;
    }
    Iterable? deps;
    if (object is List) {
      deps = object;
    } else if (object is Map) {
      deps = object.values;
    } else if (object is LCObject) {
      deps = object._estimatedData.values;
    }
    HashSet<LCObject> depParents = HashSet<LCObject>.from(parents);
    if (object is LCObject) {
      depParents.add(object);
    }
    if (deps != null) {
      for (Object? dep in deps) {
        HashSet<LCObject> ps = HashSet<LCObject>.from(depParents);
        if (hasCircleReference(dep, parents: ps)) {
          return true;
        }
      }
    }
    return false;
  }

  static Queue<_LCBatch> batchObjects(
      Iterable<LCObject> objects, bool containSelf) {
    Queue<_LCBatch> batches = new Queue<_LCBatch>();
    if (containSelf) {
      batches.addLast(new _LCBatch(objects));
    }
    HashSet deps = new HashSet();
    objects.forEach((item) {
      Iterable it = item._operationMap.values.map((op) {
        return op.getNewObjectList();
      });
      deps.addAll(it);
    });
    do {
      HashSet childSet = new HashSet();
      deps.forEach((dep) {
        Iterable? children;
        if (dep is List) {
          children = dep;
        } else if (dep is Map) {
          children = dep.values;
        } else if (dep is LCObject && dep.objectId == null) {
          children = dep._operationMap.values.map((op) {
            return op.getNewObjectList();
          });
        }
        if (children != null) {
          children.forEach((item) {
            childSet.add(item);
          });
        }
      });
      List<LCObject> depObjs = deps
          .where((item) {
            return (item is LCObject) && (item.objectId == null);
          })
          .cast<LCObject>()
          .toList();
      if (depObjs.length > 0) {
        batches.addLast(new _LCBatch(depObjs));
      }
      deps = childSet;
    } while (deps.length > 0);
    return batches;
  }
}
