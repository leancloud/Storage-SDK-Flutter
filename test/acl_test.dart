import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  group('acl', () {
    setUp(() => initNorthChina());

    test('private read and write', () async {
      LCObject account = new LCObject('Account');
      LCACL acl = new LCACL();
      acl.setPublicReadAccess(false);
      acl.setPublicWriteAccess(false);
      account.acl = acl;
      account['balance'] = 1024;
      await account.save();
      assert(acl.getPublicWriteAccess() == false);
      assert(acl.getPublilcReadAccess() == false);
    });

    test('user read and write', () async {
      await LCUser.login('hello', 'world');
      LCObject account = new LCObject('Account');
      LCUser currentUser = await LCUser.getCurrent();
      LCACL acl = LCACL.createWithOwner(currentUser);
      account.acl = acl;
      account['balance'] = 512;
      await account.save();

      assert(acl.getUserReadAccess(currentUser) == true);
      assert(acl.getUserWriteAccess(currentUser) == true);

      LCQuery<LCObject> query = new LCQuery('Account');
      LCObject result = await query.get(account.objectId);
      print(result.objectId);
      assert(result.objectId != null);

      await LCUser.logout();
      result = await query.get(account.objectId);
      assert(result == null);
    });

    test('role read and write', () async {
      LCQuery<LCRole> query = LCRole.getQuery();
      LCRole owner = await query.get('5e1440cbfc36ed006add1b8d');
      LCObject account = new LCObject('Account');
      LCACL acl = new LCACL();
      acl.setRoleReadAccess(owner, true);
      acl.setRoleWriteAccess(owner, true);
      account.acl = acl;
      await account.save();
      assert(acl.getRoleReadAccess(owner) == true);
      assert(acl.getRoleWriteAccess(owner) == true);
    });

    test('query', () async {
      await LCUser.login('game', 'play');
      LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
      LCObject account = await query.get('5e144525dd3c13006a8f8de2');
      print(account.objectId);
    });

    test('demo', () async {
      // 新建一个帖子对象
      LCObject post = LCObject("Post");
      // 为属性赋值
      post['title'] = '我是 Flutter';
      //新建一个 ACL 实例

      LCACL acl = LCACL();
      acl.setPublicReadAccess(true); // 设置公开的「读」权限，任何人都可阅读
      LCUser currentUser = await LCUser.login(
          'hello', 'world'); // 为当前用户赋予「写」权限，有且仅有当前用户可以修改这条 Post
      acl.setUserWriteAccess(currentUser, true); //将 ACL 实例赋予 Post对象
      post.acl = acl;

      await post.save();
    });

    test('serialization', () async {
      await LCUser.login('hello', 'world');
      LCQuery<LCObject> query = new LCQuery('Account');
      query.includeACL(true).orderByDescending('createdAt');
      List<LCObject> accounts = await query.find();
      for (LCObject account in accounts) {
        print('public read access: ${account.acl.getPublilcReadAccess()}');
        print('public write access: ${account.acl.getPublicWriteAccess()}');
      }
    });
  });
}
