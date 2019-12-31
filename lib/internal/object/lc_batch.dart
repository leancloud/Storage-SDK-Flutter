part of leancloud_storage;

/// 对象保存时的辅助批次类
class Batch {
  /// 包含的对象
  HashSet<LCObject> objects;

  Batch(Iterable<LCObject> objs) {
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

  static Queue<Batch> batchObjects(Iterable<LCObject> objects, bool containSelf) {
    Queue<Batch> batches = new Queue<Batch>();
    if (containSelf) {
      batches.addLast(new Batch(objects));
    }
    HashSet<Object> deps = new HashSet<Object>();
    objects.forEach((item) {
      deps.addAll(item._estimatedData.values);
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
          children = dep._estimatedData.values;
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
        batches.addLast(new Batch(depObjs));
      }
      deps = childSet;
    } while (deps != null && deps.length > 0);
    return batches;
  }
}