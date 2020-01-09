part of leancloud_storage;

/// 云引擎
class LCCloud {
  /// 调用云函数
  static Future run(String name, { Map<String, dynamic> params }) async {
    String path = 'functions/$name';
    return await LeanCloud._httpClient.post(path, data: params);
  }

  static Future rpc(String name, { Map<String, dynamic> params }) async {
    String path = 'call/$name';
    Map response = await LeanCloud._httpClient.post(path, data: params);
    return LCDecoder.decode(response);
  }
}