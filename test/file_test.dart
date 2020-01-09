import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'utils.dart';

void main() {
  // test('query file', () async {
  //   initNorthChina();
  //   LCQuery<LCFile> query = new LCQuery<LCFile>('_File');
  //   LCFile file = await query.get('5e0dbfa0562071008e21c142');
  //   print(file.url);
  //   print(file.getThumbnailUrl(32, 32));
  // });

  test('save from path', () async {
    initNorthChina();
    LCFile file = await LCFile.fromPath('avatar', './avatar.jpg');
    await file.save(onProgress: (int count, int total) {
      print('$count/$total');
      if (count == total) {
        print('done');
      }
    });
    print(file.objectId);
    assert(file.objectId != null);
  });

  test('save from memory', () async {
    initNorthChina();
    String text = 'hello, world';
    Uint8List data = utf8.encode(text);
    LCFile file = LCFile.fromBytes('text', data);
    await file.save();
    print(file.objectId);
    assert(file.objectId != null);
  });

  // test('save from url', () async {
  //   initNorthChina();
  //   LCFile file = LCFile.fromUrl('scene', 'http://img95.699pic.com/photo/50015/9034.jpg_wh300.jpg');
  //   file.addMetaData('size', 1024);
  //   file.addMetaData('width', 128);
  //   file.addMetaData('height', 256);
  //   file.mimeType = 'image/jpg';
  //   await file.save();
  //   print(file.objectId);
  //   assert(file.objectId != null);
  // });

  // test('aws', () async {
  //   initUS();
  //   LCFile file = await LCFile.fromPath('avatar', './avatar.jpg');
  //   await file.save();
  //   print(file.objectId);
  //   assert(file.objectId != null);
  // });
}