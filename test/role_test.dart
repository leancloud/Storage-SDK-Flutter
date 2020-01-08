import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  // test('new role', () async {
  //   initNorthChina();
  //   await LCUser.login('game', 'play');
  //   LCRole role = new LCRole();
  //   role.name = 'owner';
  //   LCACL acl = new LCACL();
  //   acl.setPublicReadAccess(true);
  //   acl.setUserWriteAccess(LCUser.currentUser, true);
  //   role.acl = acl;
  //   role.addRelation('users', LCUser.currentUser);
  //   await role.save();
  // });

  test('query', () async {
    initNorthChina();
    LCQuery<LCRole> query = LCRole.getQuery();
    List<LCRole> list = await query.find();
    list.forEach((item) {
      print('${item.objectId} : ${item.name}');
      assert(item.objectId != null);
      assert(item.name != null);
      assert(item.roles is LCRelation);
      assert(item.users is LCRelation);
    });
  });
}