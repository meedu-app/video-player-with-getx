import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:m_player/m_player/m_picture_in_picture.dart';
import 'package:m_player/m_player/m_player_controller.dart';
import 'package:m_player/m_player/m_slider.dart';
import 'package:m_player/utils/extras.dart';

class MPlayerControls extends StatelessWidget {
  const MPlayerControls({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MPlayerController>(
      builder: (_) => Positioned.fill(
        child: Obx(
          () => GestureDetector(
            onTap: _.onShowControls,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              color: _.showControls ? Colors.black54 : Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AbsorbPointer(
                    absorbing: !_.showControls,
                    child: AnimatedOpacity(
                      opacity: _.showControls ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PlayerButton(
                            onPressed: _.rewind,
                            size: 50,
                            iconPath: 'assets/icons/rewind.png',
                          ),
                          SizedBox(width: 20),
                          Obx(() {
                            String iconPath = 'assets/icons/repeat.png';

                            if (_.playing) {
                              iconPath = 'assets/icons/pause.png';
                            } else if (_.paused) {
                              iconPath = 'assets/icons/play.png';
                            }
                            return PlayerButton(
                              onPressed: () {
                                if (_.playing) {
                                  _.pause();
                                } else {
                                  _.play();
                                }
                              },
                              size: 60,
                              iconPath: iconPath,
                            );
                          }),
                          SizedBox(width: 20),
                          PlayerButton(
                            onPressed: _.fastForward,
                            size: 50,
                            iconPath: 'assets/icons/fast-forward.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    bottom: _.showControls ? 0 : -70,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.black26,
                      child: Row(
                        children: [
                          Obx(
                            () => Text(
                              parseDuration(_.position),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          MSlider(),
                          SizedBox(width: 10),
                          Obx(
                            () => Text(
                              parseDuration(_.duration),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Obx(() {
                            return PlayerButton(
                              size: 40,
                              circle: false,
                              backgrounColor: Colors.transparent,
                              iconColor: Colors.white,
                              iconPath: _.mute
                                  ? 'assets/icons/mute.png'
                                  : 'assets/icons/sound.png',
                              onPressed: _.onMute,
                            );
                          }),
                          if (GetPlatform.isAndroid)
                            PlayerButton(
                              onPressed: () {
                                if (!_.fullscreen) {
                                  _.onFullscreen();
                                }
                                MPictureInPicture.instance.pip();
                              },
                              size: 40,
                              circle: false,
                              backgrounColor: Colors.transparent,
                              iconColor: Colors.white,
                              iconPath: 'assets/icons/picture-in-picture.png',
                            ),
                          Obx(
                            () => PlayerButton(
                              size: 40,
                              circle: false,
                              backgrounColor: Colors.transparent,
                              iconColor: Colors.white,
                              iconPath: _.fullscreen
                                  ? 'assets/icons/minimize.png'
                                  : 'assets/icons/fullscreen.png',
                              onPressed: _.onFullscreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerButton extends StatelessWidget {
  final double size;
  final String iconPath;
  final VoidCallback onPressed;
  final Color backgrounColor, iconColor;
  final bool circle;
  const PlayerButton({
    Key key,
    this.size = 40,
    @required this.iconPath,
    @required this.onPressed,
    this.circle = true,
    this.backgrounColor = Colors.white54,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        width: this.size,
        height: this.size,
        padding: EdgeInsets.all(this.size * 0.25),
        child: Image.asset(
          this.iconPath,
          color: this.iconColor,
        ),
        decoration: BoxDecoration(
          color: this.backgrounColor,
          shape: this.circle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
      onPressed: this.onPressed,
    );
  }
}
