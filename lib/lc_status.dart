part of leancloud_storage;

/// 状态数量
class LCStatusCount {
  /// 总数
  int total;

  /// 未读数
  int unread;
}

/// 状态
class LCStatus extends LCObject {
  static const String ClassName = '_Status';

  /// 公开，会进入到关注者的时间线
  static const String InboxTypeDefault = 'default';

  /// 私信，不会公开显示
  static const String InboxTypePrivate = 'private';

  /// Keys
  static const String SourceKey = 'source';
  static const String InboxTypeKey = 'inboxType';
  static const String OwnerKey = 'owner';
  static const String MessageIdKey = 'messageId';

  int messageId;

  String inboxType;

  LCQuery query;

  Map<String, dynamic> data;

  LCStatus() : super(ClassName) {
    inboxType = InboxTypeDefault;
    data = {};
  }

  /// 向粉丝群体发送 [status] 状态
  static Future<LCStatus> sendToFollowers(LCStatus status) async {
    if (status == null) {
      throw ArgumentError.notNull('status');
    }
    LCUser user = await LCUser.getCurrent();
    if (user == null) {
      throw ArgumentError.notNull('current user');
    }

    status.data[SourceKey] = user;

    LCQuery<LCObject> query = new LCQuery('_Follower');
    query.whereEqualTo('user', user);
    query.select('follower');
    status.query = query;

    status.inboxType = InboxTypeDefault;

    return await status.send();
  }

  /// 向 [targetId] 用户发送 [status] 状态
  static Future<LCStatus> sendPrivately(
      LCStatus status, String targetId) async {
    if (status == null) {
      throw ArgumentError.notNull('status');
    }
    if (isNullOrEmpty(targetId)) {
      throw new ArgumentError.notNull('targetId');
    }
    LCUser user = await LCUser.getCurrent();
    if (user == null) {
      throw ArgumentError.notNull('current user');
    }

    status.data[SourceKey] = user;

    LCQuery<LCObject> query = new LCQuery('_User');
    query.whereEqualTo('objectId', targetId);
    status.query = query;

    status.inboxType = InboxTypePrivate;

    return await status.send();
  }

  /// 发布状态
  Future<LCStatus> send() async {
    LCUser user = await LCUser.getCurrent();
    if (user == null) {
      throw ArgumentError.notNull('current user');
    }

    Map formData = {
      InboxTypeKey: inboxType,
    };
    if (data != null) {
      formData['data'] = _LCEncoder.encode(data);
    }
    if (query != null) {
      Map queryData = {'className': query.className};
      Map<String, dynamic> params = query._buildParams();
      if (params.containsKey('where')) {
        queryData['where'] = jsonDecode(params['where']);
      }
      if (params.containsKey('keys')) {
        queryData['keys'] = params['keys'];
      }
      formData['query'] = queryData;
    }
    Map response = await LeanCloud._httpClient.post('statuses', data: formData);
    _LCObjectData objectData = _LCObjectData.decode(response);
    _merge(objectData);
    return this;
  }

  /// 删除状态。如果当前用户是 Status 的发布者，则直接删掉源 Status；否则从当前用户的时间线上删除
  Future delete() async {
    LCUser user = await LCUser.getCurrent();
    if (user == null) {
      throw ArgumentError.notNull('current user');
    }

    LCUser source = data[SourceKey] ?? this[SourceKey];
    if (source != null && source.objectId == user.objectId) {
      // 如果当前用户是 Status 的发布者，则直接删掉源 Status
      await LeanCloud._httpClient.delete('statuses/${super.objectId}');
    } else {
      // 否则从当前用户的时间线上删除
      Map<String, dynamic> data = {
        OwnerKey: jsonEncode(_LCEncoder.encode(user)),
        InboxTypeKey: inboxType,
        MessageIdKey: messageId
      };
      await LeanCloud._httpClient
          .delete('subscribe/statuses/inbox', queryParams: data);
    }
  }

  /// 获取 [inboxType] 类型状态的数量
  static Future<LCStatusCount> getCount({String inboxType}) async {
    LCUser user = await LCUser.getCurrent();
    if (user == null) {
      throw ArgumentError.notNull('current user');
    }

    Map<String, dynamic> params = {
      OwnerKey: jsonEncode(_LCEncoder.encode(user))
    };
    if (!isNullOrEmpty(inboxType)) {
      params[InboxTypeKey] = inboxType;
    }
    Map response = await LeanCloud._httpClient
        .get('subscribe/statuses/count', queryParams: params);
    LCStatusCount statusCount = new LCStatusCount();
    statusCount.total = response['total'];
    statusCount.unread = response['unread'];
    return statusCount;
  }

  /// 重置 [inboxType] 类型状态的数量
  static Future resetUnreadCount({String inboxType}) async {
    LCUser user = await LCUser.getCurrent();
    if (user == null) {
      throw ArgumentError.notNull('current user');
    }

    Map<String, dynamic> params = {
      OwnerKey: jsonEncode(_LCEncoder.encode(user))
    };
    if (!isNullOrEmpty(inboxType)) {
      params[InboxTypeKey] = inboxType;
    }
    await LeanCloud._httpClient
        .post('subscribe/statuses/resetUnreadCount', queryParams: params);
  }
}
