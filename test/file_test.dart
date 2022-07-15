import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'utils.dart';

const String kTemporaryPath = './temporaryPath';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return kTemporaryPath;
  }
}

void main() {
  SharedPreferences.setMockInitialValues({});

  group("file in China", () {
    late LCFile logo;

    setUp(() {
      initNorthChina();
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });

    test('save from path', () async {
      logo = await LCFile.fromPath('video.mp4', './video.mp4');
      await logo.save(onProgress: (int count, int total) {
        LCLogger.debug('$count/$total');
        if (count == total) {
          LCLogger.debug('done');
        }
      });
      LCLogger.debug(logo.objectId);
      assert(logo.objectId != null);
      assert(logo.mimeType == 'video/mp4');
    }, timeout: Timeout(Duration(seconds: 100)));

    test('query file', () async {
      LCQuery<LCFile> query = LCFile.getQuery();
      LCFile file = (await query.get(logo.objectId!))!;
      LCLogger.debug(file.url);
      LCLogger.debug(file.getThumbnailUrl(32, 32));
    });

    test('save from memory', () async {
      String text = 'hello, world';
      LCFile file =
          LCFile.fromBytes('text', Uint8List.fromList(utf8.encode(text)));
      await file.save();
      LCLogger.debug(file.objectId);
      assert(file.objectId != null);
    }, timeout: Timeout(Duration(seconds: 100)));

    test('save from url', () async {
      LCFile file = LCFile.fromUrl(
          'scene', 'http://img95.699pic.com/photo/50015/9034.jpg_wh300.jpg');
      file.addMetaData('size', 1024);
      file.addMetaData('width', 128);
      file.addMetaData('height', 256);
      file.mimeType = 'image/jpg';
      await file.save();
      LCLogger.debug(file.objectId);
      assert(file.objectId != null);
    });

    test('object with file', () async {
      LCFile file = await LCFile.fromPath('logo', './logo.jpg');
      LCObject obj = new LCObject('FileObject');
      obj['file'] = file;
      String text = 'hello, world';
      Uint8List data = Uint8List.fromList(utf8.encode(text));
      LCFile file2 = LCFile.fromBytes('text', data);
      obj['files'] = [file, file2];
      await obj.save();
      assert(file.objectId != null && file.url != null);
      assert(file2.objectId != null && file2.url != null);
      assert(obj.objectId != null);
    });

    test('query object with file', () async {
      LCQuery<LCObject> query = new LCQuery('FileObject');
      query.include('files');
      List<LCObject>? objs = await query.find();
      objs?.forEach((item) {
        LCFile file = item['file'] as LCFile;
        assert(file.objectId != null && file.url != null);
        List files = item['files'] as List;
        files.forEach((f) {
          assert(f is LCFile);
          assert(f.objectId != null && f.url != null);
        });
      });
    });

    test('file acl', () async {
      LCUser user = await LCUser.loginAnonymously();

      LCFile file = await LCFile.fromPath('logo', './logo.jpg');
      LCACL acl = new LCACL();
      acl.setUserReadAccess(user, true);
      file.acl = acl;
      await file.save();

      LCQuery<LCFile> query = new LCQuery(LCFile.ClassName);
      LCFile? logo = await query.get(file.objectId!);
      assert(logo!.objectId != null);

      await LCUser.loginAnonymously();

      try {
        await query.get(file.objectId!);
      } on LCException catch (e) {
        assert(e.code == 403);
      }
    });
  });

  group('file in US', () {
    setUp(() => initUS());

    test('aws file', () async {
      LCFile file = await LCFile.fromPath('logo', './logo.jpg');
      await file.save();
      LCLogger.debug(file.objectId);
      assert(file.objectId != null);
    });

    test('awa bytes', () async {
      String text = 'hello, world';
      LCFile file =
          LCFile.fromBytes('text.txt', Uint8List.fromList(utf8.encode(text)));
      await file.save();
      LCLogger.debug(file.objectId);
      assert(file.objectId != null);
    });
  });
}
