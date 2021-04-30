part of leancloud_storage;

/// LeanCloud File
class LCFile extends LCObject {
  static const String ClassName = '_File';

  /// Gets file name.
  String get name => this['name'];

  /// Sets file name.
  set name(String value) => this['name'] = value;

  String? get mimeType => this['mime_type'];

  set mimeType(String? value) => this['mime_type'] = value!;

  String? get url => this['url'];

  set url(String? value) => this['url'] = value;

  Map<String, dynamic> get metaData => this['metaData'];

  set metaData(Map<String, dynamic> value) => this['metaData'] = value;

  Uint8List? data;

  LCFile() : super(ClassName) {
    metaData = new Map<String, dynamic>();
  }

  static LCFile fromBytes(String name, Uint8List data) {
    LCFile file = new LCFile();
    file.name = name;
    file.data = data;
    return file;
  }

  static Future<LCFile> fromPath(String name, String path) async {
    LCFile file = new LCFile();
    file.name = name;
    file.mimeType = _LCMimeTypeMap.getMimeType(path);
    File f = new File(path);
    file.data = await f.readAsBytes();
    return file;
  }

  static LCFile fromUrl(String name, String url) {
    LCFile file = new LCFile();
    file.name = name;
    file.url = url;
    return file;
  }

  void addMetaData(String key, dynamic value) {
    metaData[key] = value;
  }

  /// Saves the file to LeanCloud.
  ///
  /// Unless the file is constructed [fromUrl],
  /// this will automatically upload the file content to LeanCloud.
  @override
  Future<LCFile> save(
      {bool fetchWhenSave = false,
      LCQuery<LCObject>? query,
      void Function(int count, int total)? onProgress}) async {
    if (url != null) {
      // 外链方式
      await super.save();
    } else {
      // 上传文件
      Map<String, dynamic> uploadToken = await _getUploadToken();
      String uploadUrl = uploadToken['upload_url'];
      String key = uploadToken['key'];
      String token = uploadToken['token'];
      String provider = uploadToken['provider'];
      try {
        if (provider == 's3') {
          // AWS
          _LCAWSUploader uploader =
              new _LCAWSUploader(uploadUrl, mimeType, data!);
          await uploader.upload(onProgress);
        } else if (provider == 'qiniu') {
          // Qiniu
          _LCQiniuUploader uploader =
              new _LCQiniuUploader(uploadUrl, token, key, data!);
          await uploader.upload(onProgress);
        } else {
          throw ('$provider is not support.');
        }
        _LCObjectData objectData = _LCObjectData.decode(uploadToken);
        super._merge(objectData);
        LeanCloud._httpClient.post('fileCallback',
            data: {'result': true, 'token': token}).catchError((_) {});
      } catch (err) {
        LeanCloud._httpClient.post('fileCallback',
            data: {'result': false, 'token': token}).catchError((_) {});
        throw err;
      }
    }
    return this;
  }

  /// Also deletes the uploaded file stored on LeanCloud.
  @override
  Future delete() async {
    if (objectId == null) {
      return;
    }
    String path = 'files/$objectId';
    await LeanCloud._httpClient.delete(path);
  }

  /// Gets the thunbnail URL for an image.
  String getThumbnailUrl(int width, int height,
      {int quality = 100, bool scaleToFit = true, String format = 'png'}) {
    int mode = scaleToFit ? 2 : 1;
    return '$url?imageView/$mode/w/$width/h/$height/q/$quality/format/$format';
  }

  Future<Map<String, dynamic>> _getUploadToken() async {
    Map<String, dynamic> data = {
      'name': name,
      '__type': 'File',
      'mime_type': mimeType,
      'metaData': metaData,
    };
    if (acl != null) {
      data['ACL'] = _LCEncoder.encodeACL(acl!);
    }
    return await LeanCloud._httpClient.post('fileTokens', data: data);
  }

  static LCQuery<LCFile> getQuery() {
    return new LCQuery<LCFile>('_File');
  }
}
