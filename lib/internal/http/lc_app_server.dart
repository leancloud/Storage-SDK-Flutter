part of leancloud_storage;

class _LCAppServer {
  String apiServer;

  String pushServer;

  String engineServer;

  late DateTime expiredAt;

  bool get isExpired => _ttl != -1 && expiredAt.compareTo(DateTime.now()) < 0;

  late int _ttl;

  _LCAppServer.fromJson(Map<String, dynamic> json)
      : apiServer = _getSchemeUrl(json['api_server']),
        pushServer = _getSchemeUrl(json['push_server']),
        engineServer = _getSchemeUrl(json['engine_server']) {
    _ttl = json['ttl'];
    Duration validDuration = new Duration(seconds: _ttl);
    DateTime fetchedAt = DateTime.now();
    expiredAt = fetchedAt.add(validDuration);
  }

  static String _getSchemeUrl(String url) {
    return url.startsWith('https://') ? url : 'https://$url';
  }

  static _LCAppServer _getInternalFallbackServer(String appId) {
    String prefix = appId.substring(0, 8).toLowerCase();
    return new _LCAppServer.fromJson({
      'api_server': 'https://$prefix.api.lncldglobal.com',
      'engine_server': 'https://$prefix.engine.lncldglobal.com',
      'push_server': 'https://$prefix.push.lncldglobal.com',
      'ttl': -1, // -1 表示永不过期
    });
  }
}
