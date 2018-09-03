import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'platform_messages.dart';

class FileUtil {

  // 创建本地文件
  static Future<File> createLocalFile(String filename) async {
    // 获取本地文档目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    // 返回本地文件目录
    return new File('$dir/$filename');
  }

  // 获取本地文件
  static Future<File> getLocalFile(String filename) async {
    try {
      File file = await FileUtil.createLocalFile(filename);
      int len = await file.length();
      if(len>=0){
        return file;
      }
      return null;
    } on FileSystemException {
      // 发生异常时返回默认值
      return null;
    }
  }

  // 读取文本文件
  static Future<String> readFileAsString(String filename) async {
    try {
      File file = await FileUtil.createLocalFile(filename);
      // 使用给定的编码将整个文件内容读取为字符串
      return await file.readAsString();
    } on FileSystemException {
      // 发生异常时返回默认值
      return null;
    }
  }

  // 写入文件
  static Future<Null> writeFileAsString(String filename,String txt) async {
    // 将存储点击数的变量作为字符串写入文件
    await (await FileUtil.createLocalFile(filename)).writeAsString(txt);
  }

  static Future<Null> deleteFile(String filename) async {
    await (await FileUtil.createLocalFile(filename)).delete();
  }

  //保存图片到某个路径
  static Future<Null> saveImageFile(String filename,File file) async {
    String newPath = (await getApplicationDocumentsDirectory()).path+'/'+filename;
    file.copySync(newPath);
  }

  static Future<ByteData> loadAsset(String key) async {
    final Uint8List encoded = utf8.encoder.convert(new Uri(path: Uri.encodeFull(key)).path);
    final ByteData asset =
    await BinaryMessages.send('flutter/assets', encoded.buffer.asByteData());
    if (asset == null)
      throw new FlutterError('Unable to load asset: $key');
    return asset;
  }

  static Future<String> loadAssetString(String key, { bool cache = true }) async {
    final ByteData data = await loadAsset(key);
    if (data == null)
      throw new FlutterError('Unable to load asset: $key');
    if (data.lengthInBytes < 10 * 1024) {
      // 10KB takes about 3ms to parse on a Pixel 2 XL.
      // See: https://github.com/dart-lang/sdk/issues/31954
      return utf8.decode(data.buffer.asUint8List());
    }
    return compute(_utf8decode, data, debugLabel: 'UTF8 decode for "$key"');
  }

  static String _utf8decode(ByteData data) {
    return utf8.decode(data.buffer.asUint8List());
  }
}