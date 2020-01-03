part of leancloud_storage;

/// 文件类
class LCFile extends LCObject {
  String get name => this['name'];

  set name(String value) => this['name'] = value;

  String get mimeType => this['mime_type'];

  set mimeType(String value) => this['mime_type'] = value;

  String get url => this['url'];

  set url(String value) => this['url'] = value;

  Map<String, dynamic> get metaData => this['metaData'];

  set metaData(Map<String, dynamic> value) => this['metaData'] = value;

  LCFile() : super('_File');

  void addMetaData(String key, dynamic value) {

  }

  Future<LCFile> save() async {
    return this;
  }

  @override
  Future<void> delete() async {
    if (objectId == null) {
      return;
    }
    String path = 'files/$objectId';
    String method = LCHttpRequestMethod.delete;
    LCHttpRequest request = new LCHttpRequest(path, method);
    await LeanCloud._client.send(request);
  }

  String getThumbnailUrl(int width, int height, { int quality = 100, bool scaleToFit = true, String format = 'png' }) {
    int mode = scaleToFit ? 2 : 1;
    return '$url?imageView/$mode/w/$width/h/$height/q/$quality/format/$format';
  }

  Future<Map<String, dynamic>> getUploadToken() async {

  }
}