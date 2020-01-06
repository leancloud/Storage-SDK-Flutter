import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  // test('private read and write', () async {
  //   initNorthChina();
  //   LCObject account = new LCObject('Account');
  //   LCACL acl = new LCACL();
  //   account.acl = acl;
  //   account['balance'] = 1024;
  //   await account.save();
  // });

  // test('user read and write', () async {
  //   initNorthChina();

  //   await LCUser.login('hello', 'world');
  //   LCObject account = new LCObject('Account');
  //   LCACL acl = LCACL.createWithOwner(LCUser.currentUser);
  //   account.acl = acl;
  //   account['balance'] = 512;
  //   await account.save();

  //   // LCQuery<LCObject> query = new LCQuery('Account');
  //   // LCObject result = await query.get(account.objectId); 
  //   // print(result.objectId);

  //   // LCUser.logout();
  //   // result = await query.get(account.objectId); 
  //   // print(result.objectId);
  // });

  test('role read and write', () async {

  });
}