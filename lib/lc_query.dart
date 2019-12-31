part of leancloud_storage;

/// 查询类
class LCQuery<T extends LCObject> {
  String className;

  int skip;

  int limit;

  String order;

  LCQuery(this.className);

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
    assert(objectId != null && objectId.length > 0);

  }

  Future<List<T>> find() async {
    var path = '/1.1/classes/$className';
    var method = LCHttpRequestMethod.get;
    var request = new LCHttpRequest(path, method);
    var response = await LeanCloud._client.send(request);
    List results = response['results'];
    // TODO 判断是否返回正确

    List<T> list = new List();
    results.forEach((item) {
      LCObjectData objectData = LCObjectData.decode(item);
      LCObject object = new LCObject(className);
      object._merge(objectData);
      list.add(object);
    });
    return list;
  }

  Future<T> getFirst() {

  }

  static LCQuery<T> and<T extends LCObject>(List<LCQuery<T>> queryList) {

  }

  static LCQuery<T> or<T extends LCObject>(List<LCQuery<T>> queryList) {

  }
}