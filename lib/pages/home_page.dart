import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:m_player/controllers/home_controller.dart';
import 'package:m_player/m_player/m_player.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) => Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: OrientationBuilder(
              builder: (ctx, orientation) {
                final player = MPlayer(
                  controller: _.mPlayerController,
                );

                final videoList = ListView.builder(
                  itemBuilder: (ctx, index) {
                    final video = _.videos[index];
                    return ListTile(
                      onTap: () {
                        _.play(video.url);
                      },
                      leading: Image.network(video.image),
                      title: Text(video.title),
                      subtitle: Text(
                        video.description,
                        maxLines: 2,
                      ),
                    );
                  },
                  itemCount: _.videos.length,
                );

                if (orientation == Orientation.portrait) {
                  return Column(
                    children: [
                      player,
                      Expanded(
                        child: videoList,
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: player,
                      flex: 1,
                    ),
                    Expanded(
                      child: videoList,
                      flex: 1,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
