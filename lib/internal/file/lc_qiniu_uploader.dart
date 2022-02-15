part of leancloud_storage;

/// Uploads files to Qiniu directly.
class _LCQiniuUploader {
  static Future upload(String uploadUrl, String token, String key, dynamic data,
      void Function(int count, int total)? onProgress) async {
    if (data is File) {
      return uploadFile(uploadUrl, token, key, data, onProgress);
    } else if (data is Uint8List) {
      Directory tempDir = await getTemporaryDirectory();
      String tempFilename = new _LCUuid().generateV4();
      File tempFile = new File('${tempDir.path}/$tempFilename');
      try {
        bool exists = await tempFile.exists();
        if (exists) {
          await tempFile.delete();
        }
        await tempFile.create(recursive: true);
        await tempFile.writeAsBytes(data);
        await uploadFile(uploadUrl, token, key, tempFile, onProgress);
      } finally {
        await tempFile.delete();
      }
    }
  }

  static Future uploadFile(String uploadUrl, String token, String key,
      File file, void Function(int count, int total)? onProgress) async {
    Storage storage = new Storage();
    PutController putController = new PutController();
    int fileLength = await file.length();
    putController.addProgressListener((percent) {
      if (onProgress != null) {
        onProgress((percent * fileLength).round(), fileLength);
      }
    });
    PutOptions putOptions = new PutOptions(key: key, controller: putController);
    await storage.putFile(file, token, options: putOptions);
  }
}
