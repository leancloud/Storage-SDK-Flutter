part of leancloud_storage;

/// [LCStatus] count.
class LCStatusCount {
  late int total;

  late int unread;
}

/// LeanCloud Status
class LCStatus extends LCObject {
  static const String ClassName = '_Status';

  /// Public, shown on followees' timeline.
  static const String InboxTypeDefault = 'default';

  /// Private.
  static const String InboxTypePrivate = 'private';

  /// Keys
  static const String SourceKey = 'source';
  static const String InboxTypeKey = 'inboxType';
  static const String OwnerKey = 'owner';
  static const String MessageIdKey = 'messageId';

  /// Id.
  int? messageId;

  /// The type of inbox.
  /// 
  /// There are two built-in inbox types:
  /// `timeline` (alias: `default`) and `private`.
  /// You can customize your own inbox types.
  late String inboxType;

  /// A query for targets of status. 
  LCQuery? query;

  /// Content.
  late Map<String, dynamic> data;

  LCStatus() : super(ClassName) {
    inboxType = InboxTypeDefault;
    data = {};
  }

  /// Send a status to current signined user's followers.
  static Future<LCStatus> sendToFollowers(LCStatus status) async {
    LCUser? user = await LCUser.getCurrent();
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

  /// Send a status from current signined user to private inbox of [targetId].
  static Future<LCStatus> sendPrivately(
      LCStatus status, String targetId) async {
    LCUser? user = await LCUser.getCurrent();
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

  /// Send a status to users matching a [LCQuery].
  Future<LCStatus> send() async {
    LCUser? user = await LCUser.getCurrent();
    if (user == null) {
      throw ArgumentError.notNull('current user');
    }

    Map formData = {
      InboxTypeKey: inboxType,
    };
    formData['data'] = _LCEncoder.encode(data);
    if (query != null) {
      Map queryData = {'className': query!.className};
      Map<String, dynamic> params = query!._buildParams();
      if (params.containsKey('where')) {
        queryData['where'] = jsonDecode(params['where']);
      }
      if (params.containsKey('keys')) {
        queryData['keys'] = params['keys'];
      }
      formData['query'] = queryData;
    }
    Map<String, dynamic> response = await LeanCloud._httpClient.post('statuses', data: formData);
    _LCObjectData objectData = _LCObjectData.decode(response);
    _merge(objectData);
    return this;
  }

  /// Deletes this status.
  ///
  /// If the current signed in [LCUser] is the publisher,
  /// this will delete this status and it will not be avaiable in other [LCUser]'s inboxes.
  /// If not, this will just delete this status from the current [LCUser]'s timeline.
  Future delete() async {
    LCUser? user = await LCUser.getCurrent();
    if (user == null) {
      throw ArgumentError.notNull('current user');
    }

    LCUser? source = data[SourceKey] ?? this[SourceKey];
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

  /// Counts the statuses of [inboxType].
  static Future<LCStatusCount> getCount({String? inboxType}) async {
    LCUser? user = await LCUser.getCurrent();
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

  /// Resets unread count of [inboxType].
  static Future resetUnreadCount({String? inboxType}) async {
    LCUser? user = await LCUser.getCurrent();
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
