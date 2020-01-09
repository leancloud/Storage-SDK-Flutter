part of leancloud_storage;

class LCHttpClient {
  static const Version = '1.1';
  static const MediaType = '';

  String appId;
  String appKey;
  String server;
  String version;

  Dio _dio;
  
  LCHttpClient(this.appId, this.appKey, this.server, this.version) {
    // TODO 参数合法性

    BaseOptions options = new BaseOptions(
      baseUrl: '$server/$Version/', 
      headers: {
        'X-LC-Id': appId,
        'Content-Type': ContentType.parse(MediaType)
      });
    _dio = new Dio(options);
    _dio.interceptors.add(new LogInterceptor(requestBody: true, responseBody: true));
  }

  Future get(String path, { Map<String, dynamic> headers, Map<String, dynamic> queryParams }) async {
    Options options = _toOptions(headers);
    Response response = await _dio.get(path, options: options, queryParameters: queryParams);
    return response.data;
  }

  Future post(String path, { Map<String, dynamic> headers, Map<String, dynamic> data, Map<String, dynamic> queryParams }) async {
    Options options = _toOptions(headers);
    Response response = await _dio.post(path, options: options, data: data, queryParameters: queryParams);
    return response.data;
  }

  Future put(String path, { Map<String, dynamic> headers, Map<String, dynamic> data, Map<String, dynamic> queryParams }) async {
    Options options = _toOptions(headers);
    Response response = await _dio.put(path, options: options, data: data, queryParameters: queryParams);
    return response.data;
  }

  Future delete(String path, { Map<String, dynamic> headers, Map<String, dynamic> data, Map<String, dynamic> queryParams }) async {
    Options options = _toOptions(headers);
    Response response = await _dio.delete(path, options: options, data: data, queryParameters: queryParams);
    return response.data;
  }

  Options _toOptions(Map<String, dynamic> headers) {    
    if (headers == null) {
      headers = new Map<String, dynamic>();
    }
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    Uint8List data = Utf8Encoder().convert('$timestamp$appKey');
    Digest digest = md5.convert(data);
    String sign = hex.encode(digest.bytes);
    headers['X-LC-Sign'] = '$sign,$timestamp';
    return new Options(headers: headers);
  }
}
