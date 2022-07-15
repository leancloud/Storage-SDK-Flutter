library leancloud_storage;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';

/// Encoding & Decoding
part 'internal/codec/lc_decoder.dart';
part 'internal/codec/lc_encoder.dart';

/// http
part 'internal/http/lc_http_client.dart';
part 'internal/http/lc_app_router.dart';
part 'internal/http/lc_app_server.dart';

/// Object Utilities
part 'internal/object/lc_object_data.dart';
part 'internal/object/lc_batch.dart';
part 'internal/object/lc_subclass_info.dart';

/// Operations
part 'internal/operation/lc_operation.dart';
part 'internal/operation/lc_set_operation.dart';
part 'internal/operation/lc_delete_operation.dart';
part 'internal/operation/lc_add_relation_operation.dart';
part 'internal/operation/lc_remove_relation_operation.dart';
part 'internal/operation/lc_add_operation.dart';
part 'internal/operation/lc_remove_operation.dart';
part 'internal/operation/lc_add_unique_operation.dart';
part 'internal/operation/lc_increment_operation.dart';
part 'internal/operation/lc_decrement_operation.dart';

/// Query Conditions
part 'internal/query/lc_query_condition.dart';
part 'internal/query/lc_equal_condition.dart';
part 'internal/query/lc_operation_condition.dart';
part 'internal/query/lc_related_condition.dart';
part 'internal/query/lc_compositional_condition.dart';

/// File
part 'internal/file/lc_aws_uploader.dart';
part 'internal/file/lc_qiniu_uploader.dart';

/// Utilities
part 'internal/utils/lc_uuid.dart';
part 'internal/utils/lc_utils.dart';

/// Public Interface
part 'lc_acl.dart';
part 'lc_cloud.dart';
part 'lc_captcha_client.dart';
part 'lc_sms_client.dart';
part 'lc_exception.dart';
part 'lc_file.dart';
part 'lc_geo_point.dart';
part 'lc_object.dart';
part 'lc_query.dart';
part 'lc_query_cache.dart';
part 'lc_relation.dart';
part 'lc_role.dart';
part 'lc_user.dart';
part 'lc_user_auth_data_login_option.dart';
part 'lc_logger.dart';
part 'lc_status.dart';
part 'lc_status_query.dart';
part 'lc_friendship.dart';
part 'lc_search_query.dart';
part 'lc_search_response.dart';
part 'lc_search_sort_builder.dart';

const String SDKVersion = '0.7.10';

const String APIVersion = '1.1';

/// SDK Entry Point
class LeanCloud {
  // static String _appId;

  // static String _appKey;

  // static String _appServer;

  static late _LCHttpClient _httpClient;

  /// Initialization
  static void initialize(String appId, String appKey,
      {String? server, LCQueryCache? queryCache}) {
    if (isNullOrEmpty(appId)) {
      throw new ArgumentError.notNull('appId');
    }
    if (isNullOrEmpty(appKey)) {
      throw new ArgumentError.notNull('appKey');
    }

    // Subclass
    LCObject.registerSubclass<LCFile>(LCFile.ClassName, () => new LCFile());
    LCObject.registerSubclass<LCUser>(LCUser.ClassName, () => new LCUser());
    LCObject.registerSubclass<LCRole>(LCRole.ClassName, () => new LCRole());
    LCObject.registerSubclass<LCStatus>(
        LCStatus.ClassName, () => new LCStatus());
    LCObject.registerSubclass<LCFriendshipRequest>(
        LCFriendshipRequest.ClassName, () => new LCFriendshipRequest());

    _httpClient = new _LCHttpClient(
        appId, appKey, server, SDKVersion, APIVersion, queryCache);
  }

  static Future<bool> clearAllCache() {
    return _httpClient.clearAllCache();
  }
}
