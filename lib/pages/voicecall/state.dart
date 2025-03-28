import 'package:get/get.dart';

class VoiceCallState {
  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool enableSpeaker = true.obs;
  RxString callTime = "00:00".obs;
  RxString callTimeStatus = "not connected".obs;

  var to_user_id = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var doc_id = "".obs;
  var call_role = "audience".obs;
}
