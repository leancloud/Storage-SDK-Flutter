import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group('full text search', () {
    setUp(() {
      initNorthChina();
      LCObject.registerSubclass<Account>('Account', () => new Account());
    });

    test('query with order', () async {
      LCSearchQuery<Account> query = new LCSearchQuery<Account>('Account');
      query.queryString('*');
      query.orderByDescending('balance');
      query.limit(200);
      LCSearchResponse<Account> response = await query.find();
      assert(response.hits > 0);
      List<Account> results = response.results!;
      for (int i = 0; i < results.length - 1; i++) {
        int b1 = results[i].balance;
        int b2 = results[i + 1].balance;
        assert(b1 >= b2);
      }
    });

    test('query with sort', () async {
      LCSearchQuery<Account> query = new LCSearchQuery<Account>('Account');
      query.queryString('*');
      query.limit(200);
      LCSearchSortBuilder sortBuilder = new LCSearchSortBuilder();
      sortBuilder.orderByAscending('balance');
      query.sortBy(sortBuilder);
      LCSearchResponse<Account> response = await query.find();
      assert(response.hits > 0);
      List<Account> results = response.results!;
      for (int i = 0; i < results.length - 1; i++) {
        int b1 = results[i].balance;
        int b2 = results[i + 1].balance;
        assert(b1 <= b2);
      }
    });
  });
}
