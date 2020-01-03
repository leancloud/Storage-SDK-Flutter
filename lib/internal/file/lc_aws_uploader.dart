part of leancloud_storage;

class AWSUploader {
  String uploadUrl;

  String mimeType;

  Uint8List data;

  AWSUploader(this.uploadUrl, this.mimeType, this.data);

  Future<void> upload() async {
    HttpClient client = new HttpClient();
    Uri uri = Uri.parse(uploadUrl);
    HttpClientRequest request = await client.putUrl(uri);
    request.headers
      ..add('Cache-Control', 'public, max-age=31536000')
      ..contentType = ContentType.parse(mimeType)
      ..contentLength = data.length;
    request.write(data);
    HttpClientResponse response = await request.close();
    String body = await response.transform(utf8.decoder).join();
    print(body);
  }
}