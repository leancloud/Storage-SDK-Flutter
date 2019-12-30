part of leancloud_storage;

/// 查询类
class LCQuery<T extends LCObject> {
  String className;

  int skip;

  int limit;

  String order;

  LCQuery(this.className) {

  }

  LCQuery<T> include(String key) {

  }

  LCQuery<T> whereEqualTo(String key, dynamic value) {

  }

  LCQuery<T> whereLessThan(String key, dynamic value) {

  }

  LCQuery<T> whereGreaterThan(String key, dynamic value) {

  }

  LCQuery<T> whereContainedIn(String key, Iterable<T> values) {
    
  }

  LCQuery<T> whereConatins(String key, String subString) {

  }

  Future<int> count() {

  }

  Future<T> get(String objectId) {

  }

  Future<List<T>> find() {

  }

  Future<T> getFirst() {

  }

  static LCQuery<T> and<T extends LCObject>(List<LCQuery<T>> queryList) {

  }

  static LCQuery<T> or<T extends LCObject>(List<LCQuery<T>> queryList) {

  }
}