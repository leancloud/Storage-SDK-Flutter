import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

void main() {
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
}
