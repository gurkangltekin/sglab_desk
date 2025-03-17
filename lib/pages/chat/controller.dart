import 'package:get/get.dart';
import 'package:sglab_desk/pages/chat/state.dart';

class ChatController extends GetxController {
  ChatController();
  final title = "SGLab Desk .";
  final state = ChatState();
  late String doc_id;

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;

    print(data);
    doc_id = data['doc_id']!;
    state.to_user_id.value = data['to_user_id'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
    state.to_online.value = data['to_online'] ?? "false";
  }
}
