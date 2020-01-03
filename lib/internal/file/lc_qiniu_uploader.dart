part of leancloud_storage;

/// 七牛直传方式
class QiniuUploader {
  String uploadUrl;

  String token;

  String key;

  MultipartFile file;

  QiniuUploader(this.uploadUrl, this.token, this.key, this.file);

  Future<void> upload() async {
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({
      'key': key,
      'token': token,
      'file': file
    });
    await dio.post(uploadUrl, data: formData);
  }
}