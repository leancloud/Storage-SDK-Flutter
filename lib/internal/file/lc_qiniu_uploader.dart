part of leancloud_storage;

/// Uploads files to Qiniu directly.
class _LCQiniuUploader {
  String uploadUrl;

  String token;

  String key;

  Uint8List data;

  _LCQiniuUploader(this.uploadUrl, this.token, this.key, this.data);

  Future upload(void Function(int count, int total) onProgress) async {
    Dio dio = new Dio();
    FormData formData = FormData.fromMap(
        {'key': key, 'token': token, 'file': MultipartFile.fromBytes(data)});
    await dio.post(uploadUrl, data: formData, onSendProgress: onProgress);
  }
}
