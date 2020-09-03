import 'package:flutter/material.dart';
import 'package:m_player/m_player/m_player.dart';
import 'package:m_player/m_player/m_player_controller.dart';

class MPlayerFullscreen extends StatelessWidget {
  final MPlayerController controller;
  const MPlayerFullscreen({Key key, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: MPlayer(controller: this.controller),
      ),
    );
  }
}
