part of leancloud_storage;

/// [LCQuery] of [LCStatus] to find someone's statuses.
class LCStatusQuery extends LCQuery<LCStatus> {
  /// See [LCStatus.inboxType]
  late String inboxType;

  /// Queries [LCStatus] whose messageId is greater than this.
  late int sinceId;

  /// Queries [LCStatus] whose messageId is not greater than this.
  late int maxId;

  /// Constructs a [LCQuery] for [LCStatus].
  LCStatusQuery({String inboxType = LCStatus.InboxTypeDefault})
      : super('_Status') {
    this.inboxType = inboxType;
    this.sinceId = 0;
    this.maxId = 0;
  }

  /// See [LCQuery.find].
  Future<List<LCStatus>> find(
      {CachePolicy cachePolicy = CachePolicy.onlyNetwork}) async {
    LCUser? user = await LCUser.getCurrent();
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
    String? includes = condition._buildIncludes();
    if (includes != null) {
      params['include'] = includes;
    }
    String? keys = condition._buildSelectedKeys();
    if (keys != null) {
      params['keys'] = keys;
    }
    Map response = await LeanCloud._httpClient
        .get('subscribe/statuses', queryParams: params);
    List results = response['results'];
    List<LCStatus> list = [];
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
