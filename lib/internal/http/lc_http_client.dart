part of leancloud_storage;

class _LCHttpClient {
  String appKey;

  LCAppRouter _appRouter;

  Dio _dio;

  static Future<_LCHttpClient> create(String appId, String appKey, String server, String version) async {
    _LCHttpClient httpClient = new _LCHttpClient();
    httpClient.appKey = appKey;
    httpClient._appRouter = new LCAppRouter(appId, server);
    String apiServer = await httpClient._appRouter.getApiServer();
    BaseOptions options = new BaseOptions(
      baseUrl: '$apiServer/$version/', 
      headers: {
        'X-LC-Id': appId,
        'Content-Type': ContentType.parse('application/json')
      });
    httpClient._dio = new Dio(options);
    httpClient._dio.interceptors.add(new LogInterceptor(requestBody: true, responseBody: true));
    return httpClient;
  }

  Future get(String path, { Map<String, dynamic> headers, Map<String, dynamic> queryParams }) async {
    Options options = _toOptions(headers);
    try {
      Response response = await _dio.get(path, options: options, queryParameters: queryParams);
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
    }
  }

  Future post(String path, { Map<String, dynamic> headers, dynamic data, Map<String, dynamic> queryParams }) async {
    Options options = _toOptions(headers);
    try {
      Response response = await _dio.post(path, options: options, data: data, queryParameters: queryParams);
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
    }
  }

  Future put(String path, { Map<String, dynamic> headers, dynamic data, Map<String, dynamic> queryParams }) async {
    Options options = _toOptions(headers);
    try {
      Response response = await _dio.put(path, options: options, data: data, queryParameters: queryParams);
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
    }
  }

  Future delete(String path, { Map<String, dynamic> headers, dynamic data, Map<String, dynamic> queryParams }) async {
    Options options = _toOptions(headers);
    try {
      Response response = await _dio.delete(path, options: options, data: data, queryParameters: queryParams);
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
    }
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

  void _handleError(DioError e) {
    Response response = e.response;
    int code = response.statusCode ~/ 100;
    if (code == 4) {
      int code = response.data['code'];
      String message = response.data['error'];
      throw new LCError(code, message);
    }
    throw new LCError(response.statusCode, response.statusMessage);
  }
}
