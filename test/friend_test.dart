import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

Future<LCUser> signUp() async {
  LCUser user1 = new LCUser();
  user1.username = DateTime.now().millisecondsSinceEpoch.toString();
  user1.password = 'world';
  return await user1.signUp();
}

Future<LCFriendshipRequest?> getRequest() async {
  LCUser? user = await LCUser.getCurrent();
  LCQuery<LCFriendshipRequest> query =
      new LCQuery<LCFriendshipRequest>('_FriendshipRequest')
          .whereEqualTo('friend', user)
          .whereEqualTo('status', 'pending');
  return await query.first();
}

Future<List<LCObject>?> getFriends() async {
  LCUser? user = await LCUser.getCurrent();
  LCQuery<LCObject> query = new LCQuery<LCObject>('_Followee')
      .whereEqualTo('user', user)
      .whereEqualTo('friendStatus', true);
  return await query.find();
}

void main() {
  SharedPreferences.setMockInitialValues({});

  late LCUser user1;
  late LCUser user2;

  group('friend', () {
    setUp(() => initNorthChina());

    test('init', () async {
      user1 = await signUp();

      user2 = await signUp();
      Map<String, dynamic> attrs = {'group': 'sport'};
      await LCFriendship.request(user1.objectId!, attributes: attrs);

      // user3
      await signUp();
      await LCFriendship.request(user1.objectId!);

      await LCUser.becomeWithSessionToken(user1.sessionToken!);
    });

    test('accept', () async {
      // 查询
      LCFriendshipRequest? request = await getRequest();

      // 接受
      await LCFriendship.acceptRequest(request!);

      // 查询好友
      assert((await getFriends())!.length > 0);
    });

    test('decline', () async {
      // 查询
      LCFriendshipRequest? request = await getRequest();

      // 拒绝
      await LCFriendship.declineRequest(request!);
    });

    test('attributes', () async {
      LCObject followee = (await getFriends())!.first;
      followee['group'] = 'friend';
      await followee.save();
    });

    test('delete', () async {
      await user1.unfollow(user2.objectId!);
      // 查询好友
      assert((await getFriends())!.length == 0);
    });
  });
}
