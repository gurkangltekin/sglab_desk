import 'package:get/get.dart';
import 'package:sglab_desk/common/routes/names.dart';
import 'package:sglab_desk/pages/message/state.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  void goProfile() async {
    await Get.toNamed(AppRoutes.Profile);
  }
}
