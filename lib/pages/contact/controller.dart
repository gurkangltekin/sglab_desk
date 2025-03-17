import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sglab_desk/common/apis/apis.dart';
import 'package:sglab_desk/common/entities/entities.dart';
import 'package:sglab_desk/common/store/store.dart';
import 'package:sglab_desk/pages/contact/state.dart';

class ContactController extends GetxController {
  ContactController();
  final state = ContactState();
  final userId = UserStore.to.profile.id;
  final db = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();

    asyncLoadAllData();
  }

  void goChat(ContactItem item) async {
    var fromMessages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_user_id", isEqualTo: userId)
        .where("to_user_id", isEqualTo: item.contactUserId)
        .get();

    var toMessages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_user_id", isEqualTo: item.contactUserId)
        .where("to_user_id", isEqualTo: userId)
        .get();

    if (fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
      var profile = UserStore.to.profile;
      Msg msg = Msg(
        from_avatar: profile.avatar,
        from_name: profile.name,
        from_user_id: profile.id,
        to_user_id: item.contactUserId,
        to_avatar: item.avatar,
        to_name: item.name,
        from_online: profile.online,
        to_online: item.online,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );
    }
  }

  Future<void> asyncLoadAllData() async {
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    state.contactList.clear();

    ContactResponseEntity response = await ContactAPI.post_contact("123");

    if (response.successful! && response.data != null) {
      print(response.data!);

      state.contactList.addAll(response.data!);
    } else {
      Future.delayed(
          Duration(seconds: 3),
          () =>
              Get.snackbar("Tips", response.message ?? "No message available"));
    }
    EasyLoading.dismiss();
  }
}
