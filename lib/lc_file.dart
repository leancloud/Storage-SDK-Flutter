part of leancloud_storage;

/// 文件类
class LCFile extends LCObject {
  static const String ClassName = '_File';

  String get name => this['name'];

  set name(String value) => this['name'] = value;

  String get mimeType => this['mime_type'];

  set mimeType(String value) => this['mime_type'] = value;

  String get url => this['url'];

  set url(String value) => this['url'] = value;

  Map<String, dynamic> get metaData => this['metaData'];

  set metaData(Map<String, dynamic> value) => this['metaData'] = value;

  Uint8List data;

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
    String suffix = path.substring(path.lastIndexOf('.') + 1);
    file.mimeType = MimeTypeMap.getMimeTypeBySuffix(suffix);
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

  Future<LCFile> save({ void Function(int count, int total) onProgress }) async {
    if (url != null) {
      // 外链方式
      await super.save();
    } else {
      // 上传文件
      Map<String, dynamic> uploadToken = await getUploadToken();
      String uploadUrl = uploadToken['upload_url'];
      String key = uploadToken['key'];
      String token = uploadToken['token'];
      String provider = uploadToken['provider'];
      if (provider == 's3') {
        // AWS
        AWSUploader uploader = new AWSUploader(uploadUrl, mimeType, data);
        await uploader.upload(onProgress);
      } else if (provider == 'qiniu') {
        // Qiniu
        QiniuUploader uploader = new QiniuUploader(uploadUrl, token, key, data);
        await uploader.upload(onProgress);
      } else {
        throw new Error();
      }
      LCObjectData objectData = LCObjectData.decode(uploadToken);
      super._merge(objectData);
    }
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
    Map<String, dynamic> data = {
      'name': name,
      'key': newUUID(),
      '__type': 'File',
      'mime_type': mimeType,
      'metaData': metaData
    };
    LCHttpRequest request = new LCHttpRequest('fileTokens', LCHttpRequestMethod.post, data: data);
    return await LeanCloud._client.send(request);
  }

  String newUUID() {
    Uuid uuid = new Uuid();
    return uuid.generateV4();
  }
}