import 'package:get/get.dart';
import 'package:sglab_desk/common/routes/names.dart';
import 'package:sglab_desk/pages/frame/welcome/state.dart';

class WelcomeController extends GetxController {
  WelcomeController();
  final title = "SGLab Desk .";
  final state = WelcomeState();

  @override
  void onReady() {
    super.onReady();
    print(" WelcomeController ");

    Future.delayed(
        Duration(seconds: 3), () => Get.offAllNamed(AppRoutes.Message));
  }
}
