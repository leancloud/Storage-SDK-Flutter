part of leancloud_storage;

/// 收件箱状态查询
class LCStatusQuery extends LCQuery<LCStatus> {
  String inboxType;

  int sinceId;

  int maxId;

  LCStatusQuery({String inboxType = LCStatus.InboxTypeDefault})
      : super('_Status') {
    this.inboxType = inboxType;
    this.sinceId = 0;
    this.maxId = 0;
  }

  /// 查找
  Future<List<LCStatus>> find(
      {CachePolicy cachePolicy = CachePolicy.onlyNetwork}) async {
    LCUser user = await LCUser.getCurrent();
    if (user == null) {
      throw new ArgumentError.notNull('current user');
    }

    Map<String, dynamic> params = {
      LCStatus.OwnerKey: jsonEncode(_LCEncoder.encode(user)),
      LCStatus.InboxTypeKey: inboxType,
      'where': _buildWhere(),
      'sinceId': sinceId,
      'maxId': maxId,
      'limit': condition.limit
    };
    Map response = await LeanCloud._httpClient
        .get('subscribe/statuses', queryParams: params);
    List results = response['results'];
    List<LCStatus> list = new List();
    results.forEach((item) {
      _LCObjectData objectData = _LCObjectData.decode(item);
      LCStatus status = new LCStatus();
      status._merge(objectData);
      status.messageId = objectData.customPropertyMap[LCStatus.MessageIdKey];
      status.data = objectData.customPropertyMap;
      status.inboxType = objectData.customPropertyMap[LCStatus.InboxTypeKey];
      list.add(status);
    });
    return list;
  }
}
