## [0.2.9] - 版本更新

- 支持查询 includeACL 接口

## [0.2.8] - 版本更新

- 修复 web 环境下登录异常的 bug

## [0.2.7] - 版本更新

- 增加 LCQuery 条件查询接口

```dart
/// [key] 字段不满足 [query] 查询
LCQuery<T> whereDoesNotMatchQuery(String key, LCQuery query)
```

- 增加 LCQuery 排序接口

```dart
/// 按 [key] 升序
LCQuery<T> orderByAscending(String key)
/// 按 [key] 降序
LCQuery<T> orderByDescending(String key)
/// 增加按 [key] 升序
LCQuery<T> addAscendingOrder(String key)
/// 增加按 [key] 降序
LCQuery<T> addDescendingOrder(String key)
```

## [0.2.6] - 版本更新

- 增加 LCObject 序列化和反序列化方法

```dart
String toString();
static LCObject parseObject(String str)
```

- 增加 LCUser 获取是否是匿名登录属性

```dart
bool get isAnonymous;
```

- 增加 LCQuery 接口

```dart
/// 不包含查询
LCQuery<T> whereNotContainedIn(String key, Iterable values);

/// 正则查询
LCQuery<T> whereMatches(String key, String regex, {String modifiers});

/// 关系查询
LCQuery<T> whereMatchesQuery(String key, LCQuery query)
```

## [0.2.5] - 版本更新

- 支持 Flutter Storage SDK fetchAll 功能
- 增加子类化集合属性的单元测试

## [0.2.4] - 版本更新

- 修复操作未赋值属性时的异常

## [0.2.3] - 版本更新

- 增加 LCCaptchaClient 验证码相关接口
- 增加 LCSMSClient 短信相关接口

## [0.2.1] - 版本更新

- 完善 API 文档

## [0.1.4] - 版本更新

- 修复批量删除的 bug
- 修复地理坐标经度 key 的 bug

## [0.1.3] - 版本更新

- 支持缓存查询（iOS/Android），用法如下：

```dart
// 初始化
LeanCloud.initialize( 'xxx', 'yyy',  server: 'https://zzz.com', queryCache: new LCQueryCache());

// 查询
List<LCObject> list = await query.find(cachePolicy: CachePolicy.networkElseCache);
```

## [0.1.2] - 版本更新

- 支持 iOS/Android 环境下保存登录用户数据
- 重构获取当前用户接口为异步方法

```dart
LCUser currentUser = await LCUser.getCurrent();
```

## [0.1.1] - 版本更新

- 完善时间，时区相关实现
- 完善 Geo 相关接口和实现
- 支持正则查询
- 增加 User-Agent 统计
- 完善单元测试，覆盖了 79.9%

## [0.1.0] - 基础版本

## [0.0.6] - test

## [0.0.5] - test

## [0.0.4] - test

## [0.0.3] - test

## [0.0.2] - 调整依赖库版本

## [0.0.1] - test
