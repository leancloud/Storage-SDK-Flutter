part of leancloud_storage;

class LCHttpClient {
  static const MediaType = 'application/json';

  String appId;
  String appKey;
  String authority;
  String version;
  
  LCHttpClient(this.appId, this.appKey, this.authority, this.version);

  /// 发送 http 请求
  Future<T> send<T>(LCHttpRequest request) async {
    var client = new HttpClient();
    print(authority);
    print(request.path);
    var uri = new Uri.https(authority, '/$version/${request.path}', request.queryParams);
    HttpClientRequest req;
    switch (request.method) {
      case LCHttpRequestMethod.get:
        req = await client.getUrl(uri);
      break;
      case LCHttpRequestMethod.post:
        req = await client.postUrl(uri);
      break;
      case LCHttpRequestMethod.put:
        req = await client.putUrl(uri);
      break;
      case LCHttpRequestMethod.delete:
        req = await client.deleteUrl(uri);
      break;
      default:
      break;
    }
    req.headers
      ..add('X-LC-Id', appId)
      ..add('X-LC-Key', appKey)
      ..add('Content-Type', MediaType);
    print('=== Http Request Start ===');
    print('URL: ${req.uri}');
    print('Method: ${req.method}');
    if (request.headers != null) {
      request.headers.forEach((String key, String value) {
        req.headers.add(key, value);
      });
    }
    print('Headers: ${req.headers}');
    if (request.data != null) {
      String content = jsonEncode(LCEncoder.encodeMap(request.data));
      print(content);
      req.write(content);
    }
    print('=== Http Request End =====');
    HttpClientResponse response = await req.close();
    var body = await response.transform(utf8.decoder).join();
    T result = jsonDecode(body);
    print('=== Http Response Start ===');
    print('Status Code: ${response.statusCode}');
    print('Content: $result');
    print('=== Http Response End =====');
    return result;
  }
}
