part of leancloud_storage;

class LCSearchQuery<T extends LCObject> {
  late String className;

  String? _queryString;
  List<String>? _highlights;
  List<String>? _includeKeys;
  late int _limit;
  late int _skip;
  String? _sid;
  List<String>? _orders;
  LCSearchSortBuilder? _sortBuilder;

  LCSearchQuery(this.className) {
    _limit = 100;
    _skip = 0;
  }

  LCSearchQuery<T> queryString(String q) {
    _queryString = q;
    return this;
  }

  LCSearchQuery<T> highlights(List<String> highlights) {
    _highlights = highlights;
    return this;
  }

  LCSearchQuery<T> include(List<String> keys) {
    _includeKeys = keys;
    return this;
  }

  LCSearchQuery<T> limit(int amount) {
    _limit = amount;
    return this;
  }

  LCSearchQuery<T> skip(int amount) {
    _skip = amount;
    return this;
  }

  LCSearchQuery<T> sid(String sid) {
    _sid = sid;
    return this;
  }

  LCSearchQuery<T> orderByAscending(String key) {
    _orders = <String>[key];
    return this;
  }

  LCSearchQuery<T> orderByDescending(String key) {
    return orderByAscending('-$key');
  }

  LCSearchQuery<T> addAscendingOrder(String key) {
    if (_orders == null) {
      _orders = <String>[];
    }
    _orders!.add(key);
    return this;
  }

  LCSearchQuery<T> addDescendingOrder(String key) {
    return addAscendingOrder('-$key');
  }

  LCSearchQuery<T> sortBy(LCSearchSortBuilder builder) {
    _sortBuilder = builder;
    return this;
  }

  Future<LCSearchResponse<T>> find() async {
    String path = 'search/select';
    Map<String, dynamic> queryParams = {
      'clazz': className,
      'limit': _limit,
      'skip': _skip
    };
    if (_queryString != null) {
      queryParams['q'] = _queryString;
    }
    if (_highlights != null && _highlights!.length > 0) {
      queryParams['highlights'] = _highlights!.join(',');
    }
    if (_includeKeys != null && _includeKeys!.length > 0) {
      queryParams['include'] = _includeKeys!.join(',');
    }
    if (_sid != null) {
      queryParams['sid'] = _sid;
    }
    if (_orders != null && _orders!.length > 0) {
      queryParams['order'] = _orders!.join(',');
    }
    if (_sortBuilder != null) {
      queryParams['sort'] = _sortBuilder!._build();
    }

    Map response = await LeanCloud._httpClient
        .get(path, queryParams: queryParams);
    LCSearchResponse<T> ret = new LCSearchResponse<T>();
    ret.hits = response['hits'];
    ret.sid = response['sid'];
    ret.results = <T>[];
    List results = response['results'];
    results.forEach((item) {
      _LCObjectData objectData = _LCObjectData.decode(item);
      T object = LCObject._create<T>(className);
      object._merge(objectData);
      ret.results!.add(object);
    });
    return ret;
  }
}