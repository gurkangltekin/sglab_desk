import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sglab_desk/common/store/store.dart';
import 'package:sglab_desk/common/values/values.dart';
import 'package:sglab_desk/pages/voicecall/state.dart';

class VoiceCallController extends GetxController {
  VoiceCallController();
  final state = VoiceCallState();
  final player = AudioPlayer();
  String appId = APPID;
  final db = FirebaseFirestore.instance;
  final profile_token = UserStore.to.profile.token;
  late final RtcEngine engine;

  void changeMicrophone() {
    state.openMicrophone.value = !state.openMicrophone.value;
  }

  void changeConnectStatus() {
    state.isJoined.value = !state.isJoined.value;
  }

  void changeSpeaker() {
    state.enableSpeaker.value = !state.enableSpeaker.value;
  }

  @override
  void onInit() {
    super.onInit();

    var data = Get.parameters;

    state.doc_id.value = data['doc_id'] ?? "";
    state.to_user_id.value = data['to_user_id'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
  }

  Future<void> initEngine() async {
    player.setAsset("assets/Sound_Horizon.mp3");

    engine = createAgoraRtcEngine();

    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));
  }
}
