part of leancloud_storage;

/// An image CAPTCHA to prevent SMS abuse.
class LCCaptcha {
  String url;
  String token;

  LCCaptcha(this.url, this.token);
}

/// Requests a CAPTCHA image and sends the verification code.
class LCCaptchaClient {
  /// Requests a CAPTCHA image ([width] x [height]) from LeanCloud.
  ///
  /// LeanCloud will send back a [LCCaptcha].
  static Future<LCCaptcha> requestCaptcha(
      {int width = 85, int height = 39}) async {
    String path = 'requestCaptcha';
    Map<String, dynamic> params = {'width': width, 'height': height};
    Map response = await LeanCloud._httpClient.get(path, queryParams: params);
    return new LCCaptcha(response['captcha_url'], response['captcha_token']);
  }

  /// Sends the [code] entered by the user to LeanCloud for verification.
  ///
  /// Also sends the [token] so LeanCloud can recognize which CAPTCHA to verify.
  static Future verifyCaptcha(String code, String token) async {
    String path = 'verifyCaptcha';
    Map<String, dynamic> data = {'captcha_code': code, 'captcha_token': token};
    await LeanCloud._httpClient.post(path, data: data);
  }
}
