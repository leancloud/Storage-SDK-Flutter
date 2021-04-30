import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  group("file in China", () {
    late LCFile avatar;

    setUp(() => initNorthChina());

    test('save from path', () async {
      avatar = await LCFile.fromPath('avatar', './avatar.jpg');
      await avatar.save(onProgress: (int count, int total) {
        LCLogger.debug('$count/$total');
        if (count == total) {
          LCLogger.debug('done');
        }
      });
      LCLogger.debug(avatar.objectId);
      assert(avatar.objectId != null);
    });

    test('query file', () async {
      LCQuery<LCFile> query = LCFile.getQuery();
      LCFile file = (await query.get(avatar.objectId!))!;
      LCLogger.debug(file.url);
      LCLogger.debug(file.getThumbnailUrl(32, 32));
    });

    test('save from memory', () async {
      String text = 'hello, world';
      LCFile file = LCFile.fromBytes('text', Uint8List.fromList(utf8.encode(text)));
      await file.save();
      LCLogger.debug(file.objectId);
      assert(file.objectId != null);
    });

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
      LCFile file = await LCFile.fromPath('avatar', './avatar.jpg');
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

      LCFile file = await LCFile.fromPath('avatar', './avatar.jpg');
      LCACL acl = new LCACL();
      acl.setUserReadAccess(user, true);
      file.acl = acl;
      await file.save();

      LCQuery<LCFile> query = new LCQuery(LCFile.ClassName);
      LCFile? avatar = await query.get(file.objectId!);
      assert(avatar!.objectId != null);

      await LCUser.loginAnonymously();
      
      try {
        await query.get(file.objectId!);
      } on LCException catch (e) {
        assert(e.code == 403);
      }
    });
  });

  // group('file in US', () {
  //   setUp(() => initUS());

  //   test('aws', () async {
  //     LCFile file = await LCFile.fromPath('avatar', './avatar.jpg');
  //     await file.save();
  //     LCLogger.debug(file.objectId);
  //     assert(file.objectId != null);
  //   });
  // });
}
