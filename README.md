# leancloud_storage

![build](https://img.shields.io/github/workflow/status/leancloud/Storage-SDK-Flutter/Publish%20plugin)
![the latest version](https://img.shields.io/pub/v/leancloud_storage)
![platform](https://img.shields.io/badge/platform-flutter%7Cdart%20vm-ff69b4.svg)

LeanCloud Storage Flutter SDK

## Install

Adding dependency in `pubspec.yaml`:

```dart
dependencies:
  ...
  leancloud_storage: ^0.7.10
```

Then run the following command:

```sh
$ flutter pub get
```

## Import

```dart
import 'package:leancloud_storage/leancloud.dart';
```

## Initialize

```dart
LeanCloud.initialize(
  APP_ID, APP_KEY,
  server: APP_SERVER, // to use your own custom domain
  queryCache: new LCQueryCache() // optinoal, enable cache
);
```

## Debug

Enable debug logs:

```dart
LCLogger.setLevel(LCLogger.DebugLevel);
```

## Usage

### Objects

```dart
LCObject object = new LCObject('Hello');
object['intValue'] = 123;
await object.save();
```

### Queries

```dart
LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
query.limit(limit);
List<LCObject> list = await query.find();
```

### Files

```dart
LCFile file = await LCFile.fromPath('avatar', './avatar.jpg');
await file.save(onProgress: (int count, int total) {
    print('$count/$total');
    if (count == total) {
        print('done');
    }
});
```

### Users

```dart
await LCUser.login('hello', 'world');
```

### GeoPoints

```dart
LCGeoPoint p1 = new LCGeoPoint(20.0059, 110.3665);
```

## More

Refer to [LeanStorage Flutter Guide][guide] for more usage information.
The guide is also available in Chinese ([中文指南][zh]).

[guide]: https://docs.leancloud.app/leanstorage_guide-flutter.html
[zh]: https://leancloud.cn/docs/leanstorage_guide-flutter.html

For LeanMessage, check out [LeanCloud Official Plugin][plugin].

[plugin]: https://pub.dev/packages/leancloud_official_plugin
