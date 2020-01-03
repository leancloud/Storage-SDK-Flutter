library leancloud_storage;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// 编解码
part 'internal/encode/lc_decoder.dart';
part 'internal/encode/lc_encoder.dart';

/// http
part 'internal/http/lc_http_client.dart';
part 'internal/http/lc_http_request.dart';

/// 日志
part 'internal/log/logger.dart';

/// Object 辅助
part 'internal/object/lc_object_data.dart';
part 'internal/object/lc_batch.dart';
part 'internal/object/lc_subclass_info.dart';

/// 操作
part 'internal/operation/lc_operation.dart';
part 'internal/operation/lc_set_operation.dart';
part 'internal/operation/lc_delete_operation.dart';

/// 查询条件
part 'internal/query/lc_query_condition.dart';
part 'internal/query/lc_equal_condition.dart';
part 'internal/query/lc_operation_condition.dart';
part 'internal/query/lc_related_condition.dart';
part 'internal/query/lc_compositional_condition.dart';

/// 文件
part 'internal/file/lc_aws_uploader.dart';
part 'internal/file/lc_qiniu_uploader.dart';
part 'internal/file/lc_mime_type_map.dart';

/// 工具
part 'internal/utils/lc_uuid.dart';

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

const String HttpVersion = '1.1';

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
    _client = new LCHttpClient(appId, appKey, server, HttpVersion);
    // 注册子类化
    LCObject.registerSubclass<LCFile>('_File', () => new LCFile());
    LCObject.registerSubclass<LCUser>('_User', () => new LCUser());
  }
}