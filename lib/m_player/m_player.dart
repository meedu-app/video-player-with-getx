import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:m_player/m_player/m_player_controller.dart';
import 'package:m_player/m_player/m_player_controls.dart';
import 'package:video_player/video_player.dart';

class MPlayer extends StatelessWidget {
  final MPlayerController controller;
  MPlayer({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MPlayerController>(
      builder: (_) => AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _.videoController != null && _.videoController.value.initialized
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPlayer(_.videoController),
                    )
                  : Container(),
              Obx(() {
                if (_.loading) {
                  return CircularProgressIndicator();
                } else if (_.error) {
                  return Text(
                    "Error",
                    style: TextStyle(color: Colors.white),
                  );
                } else if (_.none) {
                  return Container();
                }
                return MPlayerControls();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
