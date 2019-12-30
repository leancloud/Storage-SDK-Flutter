library leancloud_storage;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// 编解码
part 'internal/encode/lc_decoder.dart';

/// http
part 'internal/http/lc_http_client.dart';
part 'internal/http/lc_http_request.dart';

/// 日志
part 'internal/log/logger.dart';

/// Object 相关操作
part 'internal/object/lc_object_data.dart';
part 'internal/operation/lc_operation.dart';
part 'internal/operation/lc_set_operation.dart';

/// 公开接口
part 'lc_acl.dart';
part 'lc_cloud.dart';
part 'lc_error.dart';
part 'lc_file.dart';
part 'lc_geo_point.dart';
part 'lc_object.dart';
part 'lc_query.dart';
part 'lc_relation.dart';
part 'lc_role.dart';
part 'lc_user.dart';

/// SDK 入口
class LeanCloud {
  static String _appId;

  static String _appKey;

  static String _appServer;

  static LCHttpClient _client;

  /// 初始化
  static void initialize(String appId, String appKey, String server) {
    _appId = appId;
    _appKey = appKey;
    _appServer = server;
    _client = new LCHttpClient(appId, appKey, server);
  }
}