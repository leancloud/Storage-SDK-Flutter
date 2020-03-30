part of leancloud_storage;

/// 验证码
class LCCaptcha {
  String url;
  String token;

  LCCaptcha(this.url, this.token);
}

/// 验证码模块
class LCCaptchaClient {
  /// 请求宽 [width]，高 [height] 的验证码
  static Future<LCCaptcha> requestCaptcha(
      {int width = 85, int height = 39}) async {
    String path = 'requestCaptcha';
    Map<String, dynamic> params = {'width': width, 'height': height};
    Map response = await LeanCloud._httpClient.get(path, queryParams: params);
    return new LCCaptcha(response['captcha_url'], response['captcha_token']);
  }

  /// 使用 [token] 验证
  static Future verifyCaptcha(String code, String token) async {
    String path = 'verifyCaptcha';
    Map<String, dynamic> data = {'captcha_code': code, 'captcha_token': token};
    await LeanCloud._httpClient.post(path, data: data);
  }
}
