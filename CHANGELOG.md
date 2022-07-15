## [0.7.10] - 版本更新

- 修复大写文件名后缀无法被识别的 bug

## [0.7.8] - 版本更新

- 支持信息流 select
- 支持上传大文件

## [0.7.7] - 版本更新

- 支持信息流 include 查询

## [0.7.6] - 版本更新

- 修复查询缓存的 bug

## [0.7.5] - 版本更新

- 修复解析云引擎异常的 bug

## [0.7.4] - 版本更新

- 修复请求缺失本地持久化 User session 的 bug

## [0.7.3] - 版本更新

- 修复 LCObject#toString() 缺失嵌套 LCObject 的自定义字段的 bug

## [0.7.2] - 版本更新

- 修复 Null safety 错误

## [0.7.1] - 版本更新

## [0.7.0] - 版本更新

- 支持 Null safety

## [0.6.7] - 版本更新

- 支持全文搜索

## [0.6.6] - 版本更新

- 新增 Geo 查询接口

LCQuery#whereWithinRadians
LCQuery#whereWithinMiles
LCQuery#whereWithinKilometers

## [0.6.5] - 版本更新

- 修复 LCUser#save 没有将数据同步到本地的 bug

## [0.6.4] - 版本更新

- 修复 LCFile#acl 设置无效的 bug

## [0.6.3] - 版本更新

- 修复解析 http response 异常的 bug

## [0.6.2] - 版本更新

- 修复使用 unionid 登录/绑定后本地持久化异常的 bug
- 修复绑定多个第三方登录时内存数据缺失的 bug

## [0.6.0] - 版本更新

- 支持好友功能
- 修复绑定第三方账号信息失败后的缓存错误

## [0.5.0] - 版本更新

- 升级依赖库 Dio 版本为 ^3.0.10，修复 >3.0.8 版本不兼容的问题

## [0.4.3] - 版本更新

- 支持文件上传结果回调 API，避免文件上传失败产生的错误数据。
- 固定 Dio 版本为 3.0.8，Dio 在之后的小版本增加了 Breaking Changes。

## [0.4.2] - 版本更新

- 支持修改手机号验证功能

## [0.4.1] - 版本更新

- 支持切换云引擎环境

```dart
// 设置为预备环境
LCCloud.setProduction(false);
```

## [0.4.0] - 版本更新

- 支持应用内社交，包括粉丝，关注，状态，私信。[更多示例](https://github.com/leancloud/Storage-SDK-Flutter/blob/master/test/status_test.dart)

## [0.3.1] - 版本更新

- 支持 LCObject 包含 LCFile 字段的自动保存

## [0.3.0] - 版本更新

- 修复查询缓存的 bug

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
