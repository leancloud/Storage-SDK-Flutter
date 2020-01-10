part of leancloud_storage;

class LCAppRouter {
  String appId;

  String server;

  LCAppRouter(this.appId, this.server) {
    if (!_isInternalApp(appId) && isNullOrEmpty(server)) {
      throw('Please init with your server url.');
    }
  }

  _LCAppServer _appServer;

  Future<String> getApiServer() async {
    // 优先返回用户自定义域名
    if (!isNullOrEmpty(server)) {
      return server;
    }
    // 判断节点地区
    if (!_isInternalApp(appId)) {
      // 国内节点必须配置自定义域名
      // throw new LCError(code, message)
      throw('Please init with your server url.');
    }
    // 向 App Router 请求地址
    if (_appServer == null || _appServer.isExpired) {
      // 如果没有拉取或已经过期，则重新拉取并缓存
      _appServer = await fetch();
    }
    return _appServer.apiServer;
  }

  Future<_LCAppServer> fetch() async {
    try {
      BaseOptions options = new BaseOptions(baseUrl: 'https://app-router.com/');
      Dio dio = new Dio(options);
      dio.interceptors.add(new LogInterceptor(requestBody: true, responseBody: true));
      String path = '2/route';
      Map<String, dynamic> queryParams = {
        'appId': appId
      };
      Response response = await dio.get(path, queryParameters: queryParams);
      Map data = response.data;
      return _LCAppServer.fromJson(data);
    } on DioError {
      return _LCAppServer._getInternalFallbackServer(appId);
    }
  }

  static bool _isInternalApp(String appId) {
    if (appId.length < 9) {
      return false;
    }
    String suffix = appId.substring(appId.length - 9);
    return suffix == '-MdYXbMMI';
  }
}