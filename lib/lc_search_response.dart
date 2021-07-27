part of leancloud_storage;

class LCSearchResponse<T extends LCObject> {
  late int hits;
  List<T>? results;
  String? sid;
}