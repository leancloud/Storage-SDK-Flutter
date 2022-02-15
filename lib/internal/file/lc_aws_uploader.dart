part of leancloud_storage;

class _LCAWSUploader {
  static Future upload(String uploadUrl, String? mimeType, dynamic data,
      void Function(int count, int total)? onProgress) async {
    if (data is Uint8List) {
      return uploadData(uploadUrl, mimeType, data, onProgress);
    } else if (data is File) {
      Uint8List bytes = await data.readAsBytes();
      return uploadData(uploadUrl, mimeType, bytes, onProgress);
    }
  }

  static Future uploadData(String uploadUrl, String? mimeType, Uint8List data,
      void Function(int count, int total)? onProgress) async {
    Dio dio = new Dio();
    Uri uri = Uri.parse(uploadUrl);
    var stream = Stream.fromIterable(data.map((item) => [item]));
    Options opt = Options(headers: {
      'Cache-Control': 'public, max-age=31536000',
      Headers.contentLengthHeader: data.length
    }, contentType: mimeType);
    await dio.putUri(uri,
        data: stream, options: opt, onSendProgress: onProgress);
  }
}
