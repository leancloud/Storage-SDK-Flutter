# leancloud_storage

LeanCloud 数据存储 Flutter SDK。

## 安装

在 pubspec.yaml 依赖中增加 SDK 库：

```dart
dependencies:
  ...
  leancloud_storage: ^0.2.7
```

在控制台中执行安装命令：

```sh
$ flutter pub get
```

## 导入

在需要使用 SDK 的 .dart 文件中，引入 SDK：

```dart
import 'package:leancloud_storage/leancloud.dart';
```

## 初始化

```dart
LeanCloud.initialize(APP_ID, APP_KEY, server: APP_SERVER);
```

## 调试

开启调试日志

```dart
LCLogger.setLevel(LCLogger.DebugLevel);
```

## 用法

### 对象

```dart
LCObject object = new LCObject('Hello');
object['intValue'] = 123;
await object.save();
```

更多关于**对象**用法：[参考](https://github.com/leancloud/Storage-SDK-Flutter/blob/master/test/object_test.dart)

### 查询

```dart
LCQuery<LCObject> query = new LCQuery<LCObject>('Hello');
query.limit(limit);
List<LCObject> list = await query.find();
```

更多关于**查询**用法：[参考](https://github.com/leancloud/Storage-SDK-Flutter/blob/master/test/query_test.dart)

### 文件

```dart
LCFile file = await LCFile.fromPath('avatar', './avatar.jpg');
await file.save(onProgress: (int count, int total) {
    print('$count/$total');
    if (count == total) {
        print('done');
    }
});
```

更多关于**文件**用法：[参考](https://github.com/leancloud/Storage-SDK-Flutter/blob/master/test/file_test.dart)

### 用户

```dart
await LCUser.login('hello', 'world');
```

更多关于**用户**用法：[参考](https://github.com/leancloud/Storage-SDK-Flutter/blob/master/test/user_test.dart)

### GeoPoint

```dart
LCGeoPoint p1 = new LCGeoPoint(20.0059, 110.3665);
```

更多关于 **GeoPoint** 用法：[参考](https://github.com/leancloud/Storage-SDK-Flutter/blob/master/test/geo_test.dart)
