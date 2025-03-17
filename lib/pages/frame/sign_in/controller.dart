import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sglab_desk/common/apis/apis.dart';
import 'package:sglab_desk/common/entities/entities.dart';
import 'package:sglab_desk/common/routes/names.dart';
import 'package:sglab_desk/common/store/store.dart';
import 'package:sglab_desk/pages/frame/sign_in/state.dart';
import 'dart:convert';

class SignInController extends GetxController {
  SignInController();
  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['openid']);

  void handleSigIn(String type) async {
    //1:email 2: Google, 3: facebook, 4: apple, 5:phone
    try {
      if (type == "phone number") {
        if (kDebugMode) {
          print("...you are logging with phone number...");
        }
      } else if (type == 'google') {
        var account = await _googleSignIn.signIn();
        if (account != null) {
          String? displayName = account.displayName;
          String email = account.email;
          String id = account.id;
          String photoUrl = account.photoUrl ?? "assets/icons/google.png";
          LoginRequestEntity loginPanelListRequestEntity = LoginRequestEntity();
          loginPanelListRequestEntity.avatar = photoUrl;
          loginPanelListRequestEntity.name = displayName;
          loginPanelListRequestEntity.email = email;
          loginPanelListRequestEntity.open_id = id;
          loginPanelListRequestEntity.type = 2  ;
          print(jsonEncode(loginPanelListRequestEntity));
          asyncPostAllData(loginPanelListRequestEntity);
        }
      } else if (type == "apple") {
        if (kDebugMode) {
          print("...you are logging with apple...");
        }
      } else if (type == "facebook") {
        if (kDebugMode) {
          print("...you are logging with facebook...");
        }
      } else {
        if (kDebugMode) {
          print("...login type note sure...");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("...error with login $e");
      }
    }
  }

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    /*
      first save in the database
      second save in the local storage
    */

    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    UserLoginResponseEntity response =
        await UserAPI.LoginWithThirdParty(params: loginRequestEntity);

    if (response.successful == true && response.user != null) {
      await UserStore.to.saveProfile(response.user!);

      EasyLoading.dismiss();

      Get.offAllNamed(AppRoutes.Message);
    } else {
      EasyLoading.dismiss();
      Future.delayed(
          Duration(seconds: 3),
          () =>
              Get.snackbar("Tips", response.message ?? "No message available"));
    }
  }
}
