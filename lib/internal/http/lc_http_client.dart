part of leancloud_storage;

class LCHttpClient {
  static const MediaType = 'application/json';

  String appId;
  String appKey;
  String authority;
  
  LCHttpClient(this.appId, this.appKey, this.authority);

  Future<Map<String, dynamic>> post(String path, { Map<String, dynamic> data }) async {
    var client = new HttpClient();
    var uri = new Uri.https(authority, path);
    var request = await client.postUrl(uri);
    request.headers
      ..add('X-LC-Id', appId)
      ..add('X-LC-Key', appKey)
      ..add('Content-Type', MediaType);
    if (data != null) {
      request.write(jsonEncode(data));
    }
    var response = await request.close();
    var body = await response.transform(utf8.decoder).join();
    // TODO

    Map<String, dynamic> result = jsonDecode(body);
    return result;
  }

  Future<Map<String, dynamic>> getObject(String path, String objectId) async {
    var client = new HttpClient();
    var uri = new Uri.https(authority, '$path/$objectId');
    var request = await client.getUrl(uri);
    request.headers
      ..add('X-LC-Id', appId)
      ..add('X-LC-Key', appKey)
      ..add('Content-Type', MediaType);
    var response = await request.close();
    var body = await response.transform(utf8.decoder).join();

    Map<String, dynamic> result = jsonDecode(body);
    return result;
  }

  Future<T> send<T>(LCHttpRequest request) async {
    var client = new HttpClient();
    print(authority);
    print(request.path);
    var uri = new Uri.https(authority, request.path);
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
    print('----------- Http Request Start ------------');
    
    print(req.uri);
    if (request.data != null) {
      String content = jsonEncode(LCEncoder.encodeMap(request.data));
      print(content);
      req.write(content);
    }
    print('----------- Http Request End --------------');
    var response = await req.close();
    var body = await response.transform(utf8.decoder).join();
    T result = jsonDecode(body);
    print('----------- Http Response Start -----------');
    print(result);
    print('----------- Http Response End -------------');
    return result;
  }
}
