import 'package:leancloud_storage/leancloud.dart';

class Hello extends LCObject {
  World get world => this['objectValue'];

  set world(World value) => this['objectValue'] = value;

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

  LCUser get user => this["user"];

  set user(LCUser value) => this["user"] = value;

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

const String TestPhone = "18888888888";
const String TestSMSCode = "235750";

void initNorthChina() {
  LeanCloud.initialize(
      'ikGGdRE2YcVOemAaRbgp1xGJ-gzGzoHsz', 'NUKmuRbdAhg1vrb2wexYo1jo',
      server: 'https://ikggdre2.lc-cn-n1-shared.com');
  LCLogger.setLevel(LCLogger.DebugLevel);
  registerSubclass();
}

void initUS() {
  LeanCloud.initialize(
      'EgjCUfNdGw3Tu0TPdKkuG7yy-MdYXbMMI', 'Gc2YoMOt0kKEYrAL8ECTujbH');
  LCLogger.setLevel(LCLogger.DebugLevel);
}

void registerSubclass() {
  LCObject.registerSubclass<Hello>("Hello", () => new Hello());
  LCObject.registerSubclass<World>("World", () => new World());
  LCObject.registerSubclass<Account>("Account", () => new Account());
  LCObject.registerSubclass<Bank>("Bank", () => new Bank());
}
