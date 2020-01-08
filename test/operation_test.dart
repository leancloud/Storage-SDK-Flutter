import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  test('increment', () async {
    initNorthChina();
    LCQuery<LCObject> query = new LCQuery('Account');
    LCObject account = await query.get('5e154a5143c257006fbff63f');
    print(account['balance']);
    int balance = account['balance'];
    account.increment('balance', 100);
    await account.save();
    print(account['balance']);
    assert(account['balance'] == balance + 100);
  });

  test('decrement', () async {
    initNorthChina();
    LCQuery<LCObject> query = new LCQuery('Account');
    LCObject account = await query.get('5e154a5143c257006fbff63f');
    print(account['balance']);
    int balance = account['balance'];
    account.decrement('balance', 10);
    await account.save();
    print(account['balance']);
    assert(account['balance'] == balance - 10);
  });
}