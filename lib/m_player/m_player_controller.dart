import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_player/m_player/m_player_fullscreen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

enum SourceStatus { none, loading, loaded, error }
enum PlayingStatus { stopped, playing, paused }

class MPlayerController extends GetxController {
  final List<DeviceOrientation> defaultOrientations;

  VideoPlayerController _videoController;

  MPlayerController(this.defaultOrientations);

  VideoPlayerController get videoController => _videoController;

  Rx<SourceStatus> _sourceStatus = SourceStatus.none.obs;
  Rx<PlayingStatus> _playingStatus = PlayingStatus.paused.obs;
  SourceStatus get sourceStatus => _sourceStatus.value;

  Rx<Duration> _position = Duration.zero.obs;
  Rx<Duration> _sliderPosition = Duration.zero.obs;
  Rx<Duration> _duration = Duration.zero.obs;
  Rx<Duration> _bufferedLoaded = Duration.zero.obs;
  Duration get bufferedLoaded => _bufferedLoaded.value;
  RxBool _mute = false.obs;
  RxBool _fullscreen = false.obs;
  RxBool _showControls = true.obs;
  bool get mute => _mute.value;
  bool get fullscreen => _fullscreen.value;
  bool get showControls => _showControls.value;
  Duration get position => _position.value;
  Duration get sliderPosition => _sliderPosition.value;
  Duration get duration => _duration.value;
  Timer _timer;

  bool _isSliderMoving = false;

  bool get none {
    return _sourceStatus.value == SourceStatus.none;
  }

  bool get loading {
    return _sourceStatus.value == SourceStatus.loading;
  }

  bool get loaded {
    return _sourceStatus.value == SourceStatus.loaded;
  }

  bool get error {
    return _sourceStatus.value == SourceStatus.error;
  }

  bool get playing {
    return _playingStatus.value == PlayingStatus.playing;
  }

  bool get paused {
    return _playingStatus.value == PlayingStatus.paused;
  }

  bool get stopped {
    return _playingStatus.value == PlayingStatus.stopped;
  }

  Future<void> loadVideo(String url, {bool autoplay = false}) async {
    try {
      _playingStatus.value = PlayingStatus.paused;
      _sourceStatus.value = SourceStatus.loading;

      VideoPlayerController tmp;

      if (_videoController != null) {
        tmp = _videoController;
      }

      _videoController = VideoPlayerController.network(url);
      await _videoController.initialize();

      final duration = _videoController.value.duration;
      if (duration != null && _duration.value.inSeconds != duration.inSeconds) {
        _duration.value = duration;
      }

      _videoController.addListener(() {
        final position = _videoController.value.position;
        _position.value = position;

        if (!_isSliderMoving) {
          _sliderPosition.value = position;
        }

        if (_position.value.inSeconds >= duration.inSeconds && !stopped) {
          _playingStatus.value = PlayingStatus.stopped;
        }

        final buffered = _videoController.value.buffered;
        if (buffered.isNotEmpty) {
          _bufferedLoaded.value = buffered.last.end;
        }
      });

      _sourceStatus.value = SourceStatus.loaded;
      update();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (tmp != null) {
          await tmp.dispose();
          tmp = null;
        }
      });
      if (autoplay) {
        await this.play();
      }
    } catch (e, s) {
      _sourceStatus.value = SourceStatus.error;
      print(e);
      print(s);
    }
  }

  Future<void> play() async {
    if (stopped || paused) {
      if (stopped) {
        await seekTo(Duration.zero);
      }
      await _videoController.play();
      _playingStatus.value = PlayingStatus.playing;
      _hideTaskControls();
    }
  }

  Future<void> pause() async {
    if (playing) {
      await _videoController.pause();
      _playingStatus.value = PlayingStatus.paused;
    }
  }

  Future<void> seekTo(Duration position) async {
    await _videoController.seekTo(position);
  }

  Future<void> fastForward() async {
    final to = position.inSeconds + 10;
    if (duration.inSeconds > to) {
      await seekTo(Duration(seconds: to));
    }
  }

  Future<void> rewind() async {
    final to = position.inSeconds - 10;
    await seekTo(Duration(seconds: to < 0 ? 0 : to));
  }

  void onChangedSliderStart() {
    _isSliderMoving = true;
  }

  void onChangedSliderEnd() {
    _isSliderMoving = false;
    if (stopped) {
      _playingStatus.value = PlayingStatus.playing;
    }
  }

  onChangedSlider(double v) {
    _sliderPosition.value = Duration(seconds: v.floor());
  }

  Future<void> onMute() async {
    _mute.value = !_mute.value;
    await _videoController.setVolume(mute ? 0 : 1);
  }

  onShowControls() {
    _showControls.value = !_showControls.value;
    if (_timer != null) {
      _timer.cancel();
    }
    if (showControls) {
      _hideTaskControls();
    }
  }

  void _hideTaskControls() {
    _timer = Timer(Duration(seconds: 5), () {
      onShowControls();
      _timer = null;
    });
  }

  Future<void> onFullscreen() async {
    _fullscreen.value = !_fullscreen.value;

    if (fullscreen) {
      await _fullscreenOn();
    } else {
      Get.back();
    }
  }

  Future<void> _fullscreenOn() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await Get.to(
      MPlayerFullscreen(controller: this),
      transition: Transition.fade,
      duration: Duration.zero,
    );
    await SystemChrome.setPreferredOrientations(this.defaultOrientations);
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _fullscreen.value = false;
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _videoController?.dispose();
  }
}
