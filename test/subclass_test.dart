import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

class Hello extends LCObject {
  World get world => this['objectValue'];

  Hello() : super('Hello');
}

class World extends LCObject {
  String get content => this['content'];

  set content(String value) => this['content'] = value;

  World() : super('World');
}

class Account extends LCObject {
  int get balance => this['balance'];

  set balance(int value) => this['balance'] = value;

  Account() : super('Account');

  static create(int balance) {
    Account account = new Account();
    account.balance = balance;
    return account;
  }
}

class Bank extends LCObject {
  List<Account> get accounts => List<Account>.from(this['accounts']);

  set accounts(List<Account> value) => this['accounts'] = value;

  Bank() : super('Bank');
}

void main() {
  group('subclass', () {
    setUp(() => initNorthChina());

    test('create', () async {
      LCObject.registerSubclass<Account>('Account', () => new Account());
      Account account = new Account();
      account.balance = 1000;
      await account.save();
      print(account.objectId);
      assert(account.objectId != null);
    });

    test('query', () async {
      LCObject.registerSubclass<Account>('Account', () => new Account());
      LCQuery<Account> query = new LCQuery<Account>('Account');
      query.whereGreaterThan('balance', 500);
      List<Account> list = (await query.find())!;
      print(list.length);
      assert(list.length > 0);
      list.forEach((item) {
        assert(item.objectId != null);
      });
    });

    test('delete', () async {
      LCObject.registerSubclass<Account>('Account', () => new Account());
      Account account = new Account();
      account.balance = 1024;
      await account.save();
      await account.delete();
    });

    test('include', () async {
      LCObject.registerSubclass<Hello>('Hello', () => new Hello());
      LCObject.registerSubclass<World>('World', () => new World());

      LCQuery<Hello> helloQuery = new LCQuery<Hello>('Hello');
      helloQuery.include('objectValue');
      Hello hello = (await helloQuery.get('5e0d55aedd3c13006a53cd87'))!;
      World world = hello.world;

      print(hello.objectId);
      assert(hello.objectId == '5e0d55aedd3c13006a53cd87');
      print(world.objectId);
      assert(world.objectId == '5e0d55ae21460d006a1ec931');
      assert(world.content == '7788');
    });

    test('subclass collection', () async {
      LCObject.registerSubclass<Account>('Account', () => new Account());
      LCObject.registerSubclass<Bank>('Bank', () => new Bank());

      Bank bank = new Bank();
      bank.accounts = [Account.create(100), Account.create(200)];
      await bank.save();

      List<Account> accounts = bank.accounts;
      assert(accounts[0].balance == 100);
      assert(accounts[1].balance == 200);
    });
  });
}
