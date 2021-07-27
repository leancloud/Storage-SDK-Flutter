import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

void main() {
  late Account account;

  SharedPreferences.setMockInitialValues({});

  group('acl', () {
    setUp(() => initNorthChina());

    test('private read and write', () async {
      Account account = new Account();
      LCACL acl = new LCACL();
      acl.setPublicReadAccess(false);
      acl.setPublicWriteAccess(false);
      account.acl = acl;
      account.balance = 1024;
      await account.save();
      assert(acl.getPublicWriteAccess() == false);
      assert(acl.getPublilcReadAccess() == false);
    });

    test('user read and write', () async {
      await LCUser.login(TestPhone, TestPhone);
      Account account = new Account();
      LCUser currentUser = (await LCUser.getCurrent())!;
      LCACL acl = LCACL.createWithOwner(currentUser);
      account.acl = acl;
      account.balance = 512;
      await account.save();

      assert(acl.getUserReadAccess(currentUser) == true);
      assert(acl.getUserWriteAccess(currentUser) == true);

      LCQuery<LCObject> query = new LCQuery('Account');
      LCObject? result = await query.get(account.objectId!);
      LCLogger.debug(result?.objectId);
      assert(result?.objectId != null);

      await LCUser.logout();
      try {
        result = await query.get(account.objectId!);
      } on LCException catch (e) {
        assert(e.code == 403);
      }
    });

    test('role read and write', () async {
      LCUser currentUser = await LCUser.login(TestPhone, TestPhone);
      String name = 'role_${DateTime.now().millisecondsSinceEpoch}';
      LCACL roleACL = new LCACL();
      roleACL.setUserReadAccess(currentUser, true);
      roleACL.setUserWriteAccess(currentUser, true);
      LCRole role = LCRole.create(name, roleACL);
      role.addRelation('users', currentUser);
      await role.save();

      account = new Account();
      LCACL acl = new LCACL();
      acl.setRoleReadAccess(role, true);
      acl.setRoleWriteAccess(role, true);
      account.acl = acl;
      await account.save();
      assert(acl.getRoleReadAccess(role) == true);
      assert(acl.getRoleWriteAccess(role) == true);
    });

    test('query', () async {
      await LCUser.login(TestPhone, TestPhone);
      LCQuery<LCObject> query = new LCQuery<LCObject>('Account');
      LCObject? queryAccount = await query.get(account.objectId!);
      LCLogger.debug(queryAccount!.objectId);
      assert(queryAccount.objectId != null);
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
      List<LCObject>? accounts = await query.find();
      if (accounts != null) {
        for (LCObject account in accounts) {
          LCLogger.debug('public read access: ${account.acl!.getPublilcReadAccess()}');
          LCLogger.debug('public write access: ${account.acl!.getPublicWriteAccess()}');
        }
      }
    });
  });
}
