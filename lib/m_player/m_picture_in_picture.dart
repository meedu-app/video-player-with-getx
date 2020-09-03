import 'package:flutter/services.dart';
import 'package:get/utils.dart';
import 'package:get_version/get_version.dart';

class MPictureInPicture {
  MPictureInPicture._internal();
  static MPictureInPicture _instance = MPictureInPicture._internal();
  static MPictureInPicture get instance => _instance;

  final _channel = MethodChannel("app.meedu/m_player");

  Future<void> pip() async {
    if (GetPlatform.isAndroid) {
      String version = await GetVersion.platformVersion;
      version = version.replaceFirst("Android ", "");
      final v = double.parse(version);
      if (v > 7) {
        print("🤪 pip");
        await _channel.invokeMethod("pip");
      }
    }
  }
}
