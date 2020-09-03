import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_player/m_player/m_player_controller.dart';
import 'package:m_player/utils/extras.dart';

class MSlider extends StatelessWidget {
  const MSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MPlayerController>(
      builder: (_) => Expanded(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              child: LayoutBuilder(builder: (ctx, constraints) {
                return Obx(
                  () {
                    double percent = 0;
                    if (_.bufferedLoaded != null &&
                        _.bufferedLoaded.inSeconds > 0) {
                      percent =
                          _.bufferedLoaded.inSeconds / _.duration.inSeconds;
                    }
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      color: Colors.white30,
                      width: constraints.maxWidth * percent,
                      height: 5,
                    );
                  },
                );
              }),
            ),
            Obx(() {
              final int value = _.sliderPosition.inSeconds;
              final double max = _.duration.inSeconds.toDouble();
              if (value > max || max <= 0) {
                return Container();
              }
              return SliderTheme(
                data: SliderThemeData(
                  trackShape: MSliderTrackShape(),
                ),
                child: Slider(
                  min: 0,
                  divisions: _.duration.inSeconds,
                  value: value.toDouble(),
                  onChangeStart: (v) {
                    _.onChangedSliderStart();
                  },
                  onChangeEnd: (v) {
                    _.onChangedSliderEnd();
                    _.seekTo(
                      Duration(
                        seconds: v.floor(),
                      ),
                    );
                  },
                  label: parseDuration(_.sliderPosition),
                  max: max,
                  onChanged: _.onChangedSlider,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    return Rect.fromLTWH(
      offset.dx,
      offset.dy + parentBox.size.height / 2 - 2,
      parentBox.size.width,
      4,
    );
  }
}
