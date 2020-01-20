part of leancloud_storage;

/// 文件类
class LCFile extends LCObject {
  static const String ClassName = '_File';

  /// 获取文件名
  String get name => this['name'];

  /// 设置文件名
  set name(String value) => this['name'] = value;

  /// 获取文件类型
  String get mimeType => this['mime_type'];

  /// 设置文件类型
  set mimeType(String value) => this['mime_type'] = value;

  /// 获取 url
  String get url => this['url'];

  /// 设置 url
  set url(String value) => this['url'] = value;

  /// 获取文件元数据
  Map<String, dynamic> get metaData => this['metaData'];

  /// 设置文件元数据
  set metaData(Map<String, dynamic> value) => this['metaData'] = value;

  Uint8List data;

  LCFile() : super(ClassName) {
    metaData = new Map<String, dynamic>();
  }

  /// 根据字节数组创建对象
  static LCFile fromBytes(String name, Uint8List data) {
    LCFile file = new LCFile();
    file.name = name;
    file.data = data;
    return file;
  }

  /// 根据路径创建对象
  static Future<LCFile> fromPath(String name, String path) async {
    LCFile file = new LCFile();
    file.name = name;
    String suffix = path.substring(path.lastIndexOf('.') + 1);
    file.mimeType = _LCMimeTypeMap.getMimeTypeBySuffix(suffix);
    File f = new File(path);
    file.data = await f.readAsBytes();
    return file;
  }

  /// 根据外链 URL 创建对象
  static LCFile fromUrl(String name, String url) {
    LCFile file = new LCFile();
    file.name = name;
    file.url = url;
    return file;
  }

  /// 添加元数据
  void addMetaData(String key, dynamic value) {
    metaData[key] = value;
  }

  /// 保存
  @override
  Future<LCFile> save(
      {bool fetchWhenSave = false,
      LCQuery<LCObject> query,
      void Function(int count, int total) onProgress}) async {
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
      if (provider == 's3') {
        // AWS
        _LCAWSUploader uploader = new _LCAWSUploader(uploadUrl, mimeType, data);
        await uploader.upload(onProgress);
      } else if (provider == 'qiniu') {
        // Qiniu
        _LCQiniuUploader uploader =
            new _LCQiniuUploader(uploadUrl, token, key, data);
        await uploader.upload(onProgress);
      } else {
        throw ('$provider not support.');
      }
      _LCObjectData objectData = _LCObjectData.decode(uploadToken);
      super._merge(objectData);
    }
    return this;
  }

  /// 删除
  @override
  Future delete() async {
    if (objectId == null) {
      return;
    }
    String path = 'files/$objectId';
    await LeanCloud._httpClient.delete(path);
  }

  /// 获取缩略图 url
  String getThumbnailUrl(int width, int height,
      {int quality = 100, bool scaleToFit = true, String format = 'png'}) {
    int mode = scaleToFit ? 2 : 1;
    return '$url?imageView/$mode/w/$width/h/$height/q/$quality/format/$format';
  }

  Future<Map> _getUploadToken() async {
    Map<String, dynamic> data = {
      'name': name,
      'key': _newUUID(),
      '__type': 'File',
      'mime_type': mimeType,
      'metaData': metaData
    };
    return await LeanCloud._httpClient.post('fileTokens', data: data);
  }

  String _newUUID() {
    _LCUuid uuid = new _LCUuid();
    return uuid.generateV4();
  }
}
