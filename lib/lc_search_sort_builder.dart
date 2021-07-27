part of leancloud_storage;

class LCSearchSortBuilder {
  late List<dynamic> _fields;

  LCSearchSortBuilder() {
    _fields = <dynamic>[];
  }

  LCSearchSortBuilder orderByAscending(String key, { String? mode, String? missing }) {
    return _addField(key, 'asc', mode, missing);
  }

  LCSearchSortBuilder orderByDescending(String key, { String? mode, String? missing }) {
    return _addField(key, 'desc', mode, missing);
  }

  LCSearchSortBuilder whereNear(String key, LCGeoPoint point, { String? order, String? mode, String? unit }) {
    _fields.add({
      '_geo_distance': {
        key: {
          'lat': point.latitude,
          'lon': point.longitude
        },
        'order': order ?? 'asc',
        'mode': mode ?? 'avg',
        'unit': unit ?? 'km'
      }
    });
    return this;
  }

  LCSearchSortBuilder _addField(String key, String? order, String? mode, String? missing) {
    _fields.add({
      key: {
        'order': order ?? 'asc',
        'mode': mode ?? 'avg',
        'missing': '_${missing ?? 'last'}'
      }
    });
    return this;
  }

  String _build() {
    return jsonEncode(_LCEncoder.encode(_fields));
  }
}