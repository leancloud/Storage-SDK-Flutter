import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  group('status', () {
    late LCUser user1;
    late LCUser user2;
    late LCUser user3;

    setUp(() => initNorthChina());

    test('follow', () async {
      user1 = new LCUser();
      user1.username = DateTime.now().millisecondsSinceEpoch.toString();
      user1.password = 'world';
      await user1.signUp();
      await LCUser.logout();

      user2 = new LCUser();
      user2.username = DateTime.now().millisecondsSinceEpoch.toString();
      user2.password = 'world';
      await user2.signUp();

      // user2 follow user1
      Map<String, dynamic> attrs = {'score': 100};
      await user2.follow(user1.objectId!, attrs: attrs);
      await LCUser.logout();

      user3 = new LCUser();
      user3.username = DateTime.now().millisecondsSinceEpoch.toString();
      user3.password = 'world';
      await user3.signUp();

      // user3 follow user2
      await user3.follow(user2.objectId!);
      await LCUser.logout();
    });

    test('query followers and followees', () async {
      await LCUser.becomeWithSessionToken(user2.sessionToken!);

      LCQuery<LCObject> query = user2.followeeQuery();
      List<LCObject> results = (await query.find())!;
      assert(results.length > 0);
      results.forEach((item) {
        assert(user1.objectId == item['followee'].objectId);
      });

      query = user2.followerQuery();
      results = (await query.find())!;
      assert(results.length > 0);
      results.forEach((item) {
        assert(user3.objectId == item['follower'].objectId);
      });

      LCFollowersAndFollowees followersAndFollowees =
          await user2.getFollowersAndFollowees(
              includeFollowee: true, includeFollower: true, returnCount: true);
      assert(followersAndFollowees.followersCount == 1);
      assert(followersAndFollowees.followeesCount == 1);

      await LCUser.logout();
    });

    test('send', () async {
      await LCUser.becomeWithSessionToken(user1.sessionToken!);

      // 给粉丝发送状态
      LCStatus status = new LCStatus();
      status.data = {'image': 'xxx.jpg', 'content': 'hello, world'};
      await LCStatus.sendToFollowers(status);
      // 给某个用户发送私信
      LCStatus privateStatus = new LCStatus();
      privateStatus.data = {'image': 'xxx.jpg', 'content': 'hello, game'};
      await LCStatus.sendPrivately(privateStatus, user2.objectId!);

      await LCUser.logout();
    });

    test('query', () async {
      await LCUser.becomeWithSessionToken(user2.sessionToken!);

      LCStatusCount statusCount =
          await LCStatus.getCount(inboxType: LCStatus.InboxTypeDefault);
      LCLogger.debug('${statusCount.total}, ${statusCount.unread}');
      LCStatusCount privateCount =
          await LCStatus.getCount(inboxType: LCStatus.InboxTypePrivate);
      LCLogger.debug('${privateCount.total}, ${privateCount.unread}');

      LCStatusQuery query =
          new LCStatusQuery(inboxType: LCStatus.InboxTypeDefault);
      query.select('content');
      // query.sinceId = 0;
      // query.maxId = 2;
      // query.limit(2);
      List<LCStatus> statuses = await query.find();
      for (LCStatus status in statuses) {
        assert(status['source'].objectId == user1.objectId);
        await status.delete();
      }

      await LCStatus.resetUnreadCount(inboxType: LCStatus.InboxTypePrivate);

      await LCUser.logout();
    });

    test('unfollow', () async {
      await LCUser.becomeWithSessionToken(user2.sessionToken!);
      await user2.unfollow(user1.objectId!);
      await LCUser.logout();

      await LCUser.becomeWithSessionToken(user3.sessionToken!);
      await user3.unfollow(user2.objectId!);
      await LCUser.logout();
    });
  });
}
