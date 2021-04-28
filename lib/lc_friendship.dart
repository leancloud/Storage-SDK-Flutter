part of leancloud_storage;

class LCFriendshipRequest extends LCObject {
  static const String ClassName = '_FriendshipRequest';

  LCFriendshipRequest() : super(ClassName);
}

class LCFriendship {
  static Future request(String userId,
      {Map<String, dynamic>? attributes}) async {
    LCUser? user = await LCUser.getCurrent();
    if (user == null) {
      throw new ArgumentError('Current user is null.');
    }
    String path = 'users/friendshipRequests';
    LCObject friend = LCObject.createWithoutData('_User', userId);
    await LeanCloud._httpClient.post(path,
        data: {'user': _LCEncoder.encodeLCObject(user), 'friend': _LCEncoder.encodeLCObject(friend), 'friendship': attributes});
  }

  static Future acceptRequest(LCFriendshipRequest request,
      {Map<String, dynamic>? attributes}) async {
    String path = 'users/friendshipRequests/${request.objectId}/accept';
    Map<String, dynamic>? data;
    if (attributes != null) {
      data = {'friendship': attributes};
    }
    await LeanCloud._httpClient.put(path, data: data);
  }

  static Future declineRequest(LCFriendshipRequest request) async {
    String path = 'users/friendshipRequests/${request.objectId}/decline';
    await LeanCloud._httpClient.put(path);
  }
}
