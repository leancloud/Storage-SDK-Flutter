import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group("role", () {
    setUp(() => initNorthChina());

    test('new role', () async {
      LCUser currentUser = await LCUser.login('game', 'play');
      LCACL acl = new LCACL();
      acl.setPublicReadAccess(true);
      acl.setUserWriteAccess(currentUser, true);
      String name = 'role_${DateTime.now().millisecondsSinceEpoch}';
      LCRole role = LCRole.create(name, acl);
      role.addRelation('users', currentUser);
      await role.save();
    });

    test('query', () async {
      LCQuery<LCRole> query = LCRole.getQuery();
      List<LCRole> list = (await query.find())!;
      list.forEach((item) {
        LCLogger.debug('${item.objectId} : ${item.name}');
        assert(item.objectId != null);
        assert(item.roles is LCRelation);
        assert(item.users is LCRelation);
      });
    });
  });
}
