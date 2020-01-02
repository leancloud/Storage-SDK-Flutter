part of leancloud_storage;

class LCHttpRequestMethod {
  static const get = 'GET';
  static const post = 'POST';
  static const put = 'PUT';
  static const delete = 'DELETE';
  static const header = 'HEADER';
  static const open = 'OPEN';
  static const patch = 'PATCH';
}

/// Http 请求类
class LCHttpRequest {
  /// 请求接口
  String path;

  /// 请求方法
  String method;

  Map<String, String> headers;

  /// 请求数据
  Map<String, dynamic> data;

  LCHttpRequest(this.path, this.method, { this.headers, this.data });
}