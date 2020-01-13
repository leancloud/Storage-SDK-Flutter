part of leancloud_storage;

class _LCHttpClient {
  String appId;

  String appKey;

  String server;

  String version;

  _LCAppRouter _appRouter;

  Dio _dio;

  LogInterceptor _logInterceptor;

  _LCHttpClient(this.appId, this.appKey, this.server, this.version) {
    _appRouter = new _LCAppRouter(appId, server);
    BaseOptions options = new BaseOptions(
      headers: {
        'X-LC-Id': appId,
        'Content-Type': ContentType.parse('application/json')
      });
    _dio = new Dio(options);
  }

  void enableLog() {
    if (_logInterceptor == null) {
      _logInterceptor = new LogInterceptor(requestBody: true, responseBody: true);
    }
    _dio.interceptors.add(_logInterceptor);
  }

  Future get(String path, { Map<String, dynamic> headers, Map<String, dynamic> queryParams }) async {
    await _refreshServer();
    Options options = _toOptions(headers);
    try {
      Response response = await _dio.get(path, options: options, queryParameters: queryParams);
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
    }
  }

  Future post(String path, { Map<String, dynamic> headers, dynamic data, Map<String, dynamic> queryParams }) async {
    await _refreshServer();
    Options options = _toOptions(headers);
    try {
      Response response = await _dio.post(path, options: options, data: data, queryParameters: queryParams);
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
    }
  }

  Future put(String path, { Map<String, dynamic> headers, dynamic data, Map<String, dynamic> queryParams }) async {
    await _refreshServer();
    Options options = _toOptions(headers);
    try {
      Response response = await _dio.put(path, options: options, data: data, queryParameters: queryParams);
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
    }
  }

  Future delete(String path, { Map<String, dynamic> headers, dynamic data, Map<String, dynamic> queryParams }) async {
    await _refreshServer();
    Options options = _toOptions(headers);
    try {
      Response response = await _dio.delete(path, options: options, data: data, queryParameters: queryParams);
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
    }
  }

  Future _refreshServer() async {
    // 以防 server 过期
    String apiServer = await _appRouter.getApiServer();
    _dio.options.baseUrl = '$apiServer/$version/';
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
    if (LCUser.currentUser != null) {
      headers['X-LC-Session'] = LCUser.currentUser.sessionToken;
    }
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
