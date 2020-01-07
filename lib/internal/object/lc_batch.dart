part of leancloud_storage;

/// 对象保存时的辅助批次类
class LCBatch {
  /// 包含的对象
  HashSet<LCObject> objects;

  LCBatch(Iterable<LCObject> objs) {
    objects = new HashSet<LCObject>();
    if (objs != null) {
      objs.forEach((item) {
        objects.add(item);
      });
    }
  }

  static bool hasCircleReference(Object object, HashSet<LCObject> parents) {
    if (parents.contains(object)) {
      return true;
    }
    Iterable deps;
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
      for (Object dep in deps) {
        HashSet<LCObject> ps = HashSet<LCObject>.from(depParents);
        if (hasCircleReference(dep, ps)) {
          return true;
        }
      }
    }
    return false;
  }

  static Queue<LCBatch> batchObjects(Iterable<LCObject> objects, bool containSelf) {
    Queue<LCBatch> batches = new Queue<LCBatch>();
    if (containSelf) {
      batches.addLast(new LCBatch(objects));
    }
    HashSet<Object> deps = new HashSet<Object>();
    objects.forEach((item) {
      Iterable it = item._operationMap.values.map((op) {
        return op.getNewObjectList();
      });
      deps.addAll(it);
    });
    do {
      HashSet<Object> childSet = new HashSet<Object>();
      deps.forEach((dep) {
        Iterable children;
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
      List<LCObject> depObjs = deps.where((item) {
        return (item is LCObject) && (item.objectId == null);
      }).cast<LCObject>().toList();
      if (depObjs != null && depObjs.length > 0) {
        batches.addLast(new LCBatch(depObjs));
      }
      deps = childSet;
    } while (deps != null && deps.length > 0);
    return batches;
  }
}