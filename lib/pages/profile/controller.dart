import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sglab_desk/common/store/store.dart';
import 'package:sglab_desk/pages/profile/state.dart';

class ProfileController extends GetxController {
  ProfileController();
  final state = ProfileState();

  void goLogOut() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }
}
