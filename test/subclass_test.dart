import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

class Account extends LCObject {
  int get balance => this['balance'];

  set balance(int value) => this['balance'] = value;

  Account() : super('Account');
}

void main() {
  // test('create', () async {
  //   initNorthChina();
  //   LCObject.registerSubclass<Account>('Account', (className) => new Account());
  //   Account account = new Account();
  //   account.balance = 1000;
  //   await account.save();
  //   print(account.objectId);
  //   assert(account.objectId != null);
  // });

  // test('query', () async {
  //   initNorthChina();
  //   LCObject.registerSubclass<Account>('Account', (className) => new Account());
  //   LCQuery<Account> query = new LCQuery<Account>('Account');
  //   query.whereGreaterThan('balance', 500);
  //   List<Account> list = await query.find();
  //   print(list.length);
  //   assert(list.length > 0);
  //   list.forEach((item) {
  //     assert(item.objectId != null);
  //   });
  // });

  test('delete', () async {
    initNorthChina();
    LCObject.registerSubclass<Account>('Account', (className) => new Account());
    Account account = new Account();
    account.balance = 1024;
    await account.save();
    await account.delete();
  });
}