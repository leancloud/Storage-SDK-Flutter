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

  set url(String? value) => this['url'] = value!;

  Map<String, dynamic>? get metaData => this['metaData'];

  set metaData(Map<String, dynamic>? value) => this['metaData'] = value;

  File? file;

  Uint8List? data;

  LCFile() : super(ClassName);

  static LCFile fromBytes(String name, Uint8List data) {
    LCFile file = new LCFile();
    file.name = name;
    file.data = data;
    return file;
  }

  static Future<LCFile> fromPath(String name, String path) async {
    LCFile file = new LCFile();
    file.name = name;
    file.file = new File(path);
    return file;
  }

  static LCFile fromUrl(String name, String url) {
    LCFile file = new LCFile();
    file.name = name;
    file.url = url;
    return file;
  }

  void addMetaData(String key, dynamic value) {
    if (metaData == null) {
      metaData = new Map<String, dynamic>();
    }
    metaData![key] = value;
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
      this.mimeType = uploadToken['mime_type'];
      try {
        if (provider == 's3') {
          // AWS
          await _LCAWSUploader.upload(
              uploadUrl, this.mimeType, file != null ? file : data, onProgress);
        } else if (provider == 'qiniu') {
          // Qiniu
          await _LCQiniuUploader.upload(
              uploadUrl, token, key, file != null ? file : data, onProgress);
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
