import 'package:get/get.dart';
import 'package:sglab_desk/pages/contact/controller.dart';

class ContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(() => ContactController());
  }
}
