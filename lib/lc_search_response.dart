part of leancloud_storage;

class LCSearchResponse<T extends LCObject> {
  int hits;
  List<T> results;
  String sid;
}