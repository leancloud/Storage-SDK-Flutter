import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  setUp(() => initNorthChina());

  test('calculate', () async {
    LCGeoPoint p1 = new LCGeoPoint(20.0059, 110.3665);
    LCGeoPoint p2 = new LCGeoPoint(20.0353, 110.3645);
    double kilometers = p1.kilometersTo(p2);
    LCLogger.debug(kilometers);
    assert((kilometers - 3.275) < 0.01);
    double miles = p1.milesTo(p2);
    LCLogger.debug(miles);
    assert((miles - 2.035) < 0.01);
    double radians = p1.radiansTo(p2);
    LCLogger.debug(radians);
    assert((radians - 0.0005) < 0.0001);
  });

  test('query', () async {
    LCObject geoObj = new LCObject('GeoObj');
    Random random = new Random();
    LCGeoPoint p1 = new LCGeoPoint(-90 + random.nextDouble() * 180, -180 + random.nextDouble() * 360);
    geoObj['location'] = p1;
    await geoObj.save();

    LCGeoPoint p2 = new LCGeoPoint(p1.latitude + 0.01, p1.longitude + 0.01);

    double km = p1.kilometersTo(p2);
    LCQuery<LCObject> query = new LCQuery('GeoObj');
    query.whereWithinKilometers('location', p2, km.ceil().toDouble());
    assert((await query.find())!.length > 0);

    double miles = p1.milesTo(p2);
    query = new LCQuery('GeoObj');
    query.whereWithinMiles('location', p2, miles.ceil().toDouble());
    assert((await query.find())!.length > 0);

    double radians = p1.radiansTo(p2);
    query = new LCQuery('GeoObj');
    query.whereWithinRadians('location', p2, radians.ceil().toDouble());
    assert((await query.find())!.length > 0);
  });
}
