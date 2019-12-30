part of leancloud_storage;

/// 坐标类
class LCGeoPoint {
  /// 纬度
  double latitude;

  // 经度
  double longitude;

  LCGeoPoint(this.latitude, this.longitude);

  LCGeoPoint.origin() {
    latitude = 0;
    longitude = 0;
  }

  double distanceInKilometersTo(LCGeoPoint point) {

  }

  double distanceMilesTo(LCGeoPoint point) {

  }

  double distanceInRadiansTo(LCGeoPoint point) {

  }
}