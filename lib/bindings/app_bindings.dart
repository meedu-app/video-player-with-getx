import 'package:get/get.dart';
import 'package:m_player/m_player/m_player_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MPlayerController());
  }
}
