part of leancloud_storage;

enum LCHttpRequestMethod {
  get,
  post,
  put,
  delete,
  header,
  open,
  patch,
}

/// Http 请求类
class LCHttpRequest {
  /// 请求接口
  String path;

  /// 请求方法
  LCHttpRequestMethod method;

  /// 请求数据
  Map<String, dynamic> data;

  LCHttpRequest(this.path, this.method, { this.data });
}