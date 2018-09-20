import 'dart:async';
import 'dart:io' as Io;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';


class SaveFile {

  Future<String> get _localPath async {
    if (Io.Platform.isIOS) {
      final directory = await getTemporaryDirectory();
      return directory.path;
    } else {
      final directory = await getExternalStorageDirectory();
      return directory.path;
    }
  }

  Future<Io.File> getFileFromNetwork(String url) async {
    var cacheManager = await CacheManager.getInstance();
    Io.File file = await cacheManager.getFile(url);
    return file;
  }

  Future<Io.File> saveImage(String url) async {
    final file = await getFileFromNetwork(url);
    //retrieve local path for device
    var path = await _localPath;
    Image image = decodeImage(file.readAsBytesSync());
//
    print("image path==" + path);
//    // Save the thumbnail as a PNG.
    return new Io.File('$path/${DateTime.now().toUtc().toIso8601String()}.png')
      ..writeAsBytesSync(encodePng(image));
  }

  Future<Io.File> saveVideo(String url) async {
    final file = await getFileFromNetwork(url);
    //retrieve local path for device
    var path = await _localPath;
//
    print("video path==" + path);
//    // Save the thumbnail as a PNG.
    return new Io.File('$path/${DateTime.now().toUtc().toIso8601String()}.mp4')
      ..writeAsBytesSync(file.readAsBytesSync());
  }
}