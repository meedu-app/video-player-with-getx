import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:m_player/m_player/m_player_controller.dart';
import 'package:m_player/models/video.dart';
import 'package:m_player/utils/videos.dart' as v;

class HomeController extends GetxController {
  List<Video> _videos = [];
  List<Video> get videos => _videos;

  MPlayerController _mPlayerController = MPlayerController.to;
  MPlayerController get mPlayerController => _mPlayerController;

  @override
  void onInit() {
    if (!Get.context.isTablet) {
      _mPlayerController.defaultOrientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ];
    }
  }

  @override
  void onReady() {
    this._videos = v.videos.map((e) => Video.fromJson(e)).toList();
    update();
    _mPlayerController.loadVideo(
      "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov",
    );
  }

  Future<void> play(String url) async {
    await mPlayerController.loadVideo(
      url,
      autoplay: true,
    );
  }

  @override
  Future<void> onClose() {
    _mPlayerController.dispose();
    return super.onClose();
  }
}
