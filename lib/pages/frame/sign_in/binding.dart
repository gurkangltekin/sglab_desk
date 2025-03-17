import 'package:get/get.dart';
import 'package:sglab_desk/pages/frame/sign_in/controller.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
