import 'package:get/get.dart';
import 'package:sglab_desk/pages/voicecall/controller.dart';

class VoiceCallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceCallController>(() => VoiceCallController());
  }
}
