part of leancloud_storage;

class _LCAWSUploader {
  String uploadUrl;

  String mimeType;

  Uint8List data;

  _LCAWSUploader(this.uploadUrl, this.mimeType, this.data);

  Future upload(void Function(int count, int total) onProgress) async {
    Dio dio = new Dio(); 
    Uri uri = Uri.parse(uploadUrl);
    var stream = Stream.fromIterable(data.map((item) => [item]));
    Options opt = Options(headers: {
        'Cache-Control': 'public, max-age=31536000',
        Headers.contentLengthHeader: data.length
    }, contentType: mimeType);
    await dio.putUri(uri, data: stream, options: opt, onSendProgress: onProgress);
  }
}