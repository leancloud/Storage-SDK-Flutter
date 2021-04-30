import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group('operation', () {
    setUp(() => initNorthChina());

    test('increment', () async {
      LCObject account = new LCObject('Account');
      account['balance'] = 0;
      await account.save();
      LCLogger.debug(account['balance']);
      int balance = account['balance'];
      account.increment('balance', 100);
      await account.save();
      LCLogger.debug(account['balance']);
      assert(account['balance'] == balance + 100);
    });

    test('decrement', () async {
      LCObject account = new LCObject('Account');
      account['balance'] = 0;
      await account.save();
      LCLogger.debug(account['balance']);
      int balance = account['balance'];
      account.decrement('balance', 10);
      await account.save();
      LCLogger.debug(account['balance']);
      assert(account['balance'] == balance - 10);
    });

    test('add and remove', () async {
      LCObject book = new LCObject('Book');
      book['pages'] = [1, 2, 3, 4, 5];
      await book.save();

      // add
      book.add('pages', 6);
      await book.save();
      LCLogger.debug(book['pages']);
      assert(book['pages'].length == 6);
      book.addAll('pages', [7, 8, 9]);
      await book.save();
      LCLogger.debug(book['pages']);
      assert(book['pages'].length == 9);

      // remove
      book.remove('pages', 2);
      LCLogger.debug(book['pages']);
      await book.save();
      assert(book['pages'].length == 8);
      book.removeAll('pages', [1, 2, 3]);
      await book.save();
      LCLogger.debug(book['pages']);
      assert(book['pages'].length == 6);
    });

    test('add unique', () async {
      LCObject book = new LCObject('Book');
      book['pages'] = [1, 2, 3, 4, 5];
      await book.save();

      // add
      book.addUnique('pages', 1);
      await book.save();
      LCLogger.debug(book['pages']);
      assert(book['pages'].length == 5);

      book.addAllUnique('pages', [5, 6, 7]);
      await book.save();
      LCLogger.debug(book['pages']);
      assert(book['pages'].length == 7);
    });
  });
}
