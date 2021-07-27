import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group('subclass', () {
    setUp(() => initNorthChina());

    test('create', () async {
      Account account = new Account();
      account.balance = 1000;
      await account.save();
      LCLogger.debug(account.objectId);
      assert(account.objectId != null);
    });

    test('query', () async {
      LCQuery<Account> query = new LCQuery<Account>('Account');
      query.whereGreaterThan('balance', 500);
      List<Account> list = (await query.find())!;
      LCLogger.debug(list.length);
      assert(list.length > 0);
      list.forEach((item) {
        assert(item.objectId != null);
      });
    });

    test('delete', () async {
      Account account = new Account();
      account.balance = 1024;
      await account.save();
      await account.delete();
    });

    test('include', () async {
      LCQuery<Hello> helloQuery = new LCQuery<Hello>('Hello');
      helloQuery.include('objectValue');
      Hello hello = (await helloQuery.get('5e0d55aedd3c13006a53cd87'))!;
      World world = hello.world;

      LCLogger.debug(hello.objectId);
      assert(hello.objectId == '5e0d55aedd3c13006a53cd87');
      LCLogger.debug(world.objectId);
      assert(world.objectId == '5e0d55ae21460d006a1ec931');
      assert(world.content == '7788');
    });

    test('subclass collection', () async {
      Bank bank = new Bank();
      bank.accounts = [Account.create(100), Account.create(200)];
      await bank.save();

      List<Account> accounts = bank.accounts;
      assert(accounts[0].balance == 100);
      assert(accounts[1].balance == 200);
    });
  });
}
