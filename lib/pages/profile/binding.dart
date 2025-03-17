import 'package:get/get.dart';
import 'package:sglab_desk/pages/profile/controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
