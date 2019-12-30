part of leancloud_storage;

/// 文件类
class LCFile extends LCObject {
  /// 文件大小
  int get size => 0;

  /// 文件链接
  String get url => "";


  LCFile(String name, Uint8List bytes) : super('_File') {

  }

  void addMetaData(String key, dynamic value) {

  }

  Future<LCFile> save() {

  }

  Future<void> delete() {

  }

  String getThumbnailUrl(bool scaleToFit, int width, int height) {

  }
}