part of leancloud_storage;

/// LeanCloud SMS Client
class LCSMSClient {
  /// Requests an SMS code for operation verification.
  static Future requestSMSCode(String mobile,
      {String? template,
      String? signature,
      String? captchaToken,
      Map<String, dynamic>? variables}) async {
    String path = 'requestSmsCode';
    Map<String, dynamic> data = {'mobilePhoneNumber': mobile};
    if (template != null) {
      data['template'] = template;
    }
    if (signature != null) {
      data['sign'] = signature;
    }
    if (captchaToken != null) {
      data['validate_token'] = captchaToken;
    }
    if (variables != null) {
      variables.forEach((k, v) {
        data[k] = v;
      });
    }
    await LeanCloud._httpClient.post(path, data: data);
  }

  /// Requests to send the verification code via phone call. 
  static Future requestVoiceCode(String mobile) async {
    String path = 'requestSmsCode';
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile,
      'smsType': 'voice'
    };
    await LeanCloud._httpClient.post(path, data: data);
  }

  static Future verifyMobilePhone(String mobile, String code) async {
    String path = 'verifySmsCode/$code';
    Map<String, dynamic> data = {
      'mobilePhoneNumber': mobile,
    };
    await LeanCloud._httpClient.post(path, data: data);
  }
}
