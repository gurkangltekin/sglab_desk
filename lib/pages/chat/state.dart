import 'package:get/get.dart';
import 'package:sglab_desk/common/entities/entities.dart';

class ChatState {
  RxList<Msgcontent> msgContentList = <Msgcontent>[].obs;

  var to_user_id = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var to_online = "".obs;
  RxBool more_status = false.obs;
}
