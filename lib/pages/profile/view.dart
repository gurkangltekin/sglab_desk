import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sglab_desk/common/values/colors.dart';
import 'package:sglab_desk/pages/profile/controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  AppBar _buildAppBar(){
    return AppBar(
      title: Text(
        "Profile",
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,

        ),
      ),
    );
  }

  Widget _buildProfilePhoto(){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: AppColors.primarySecondaryBackground,
            borderRadius: BorderRadius.all(Radius.circular(60.w),),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Image(
            height: 120.h,
            width: 120.w,
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/images/account_header.png",
            ),
          ),
        ),
        Positioned(
          bottom: 0.w,
          right: 0.w,
          height: 35.w,
          child: GestureDetector(
            child: Container(
              height: 35.w,
              width: 35.w,
              padding: EdgeInsets.all(7.w),
              decoration: BoxDecoration(
                color: AppColors.primaryElement,
                borderRadius: BorderRadius.all(Radius.circular(40.w)),
              ),
              child: Image.asset("assets/icons/edit.png"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color backgroudColor, Color textColor, Function onTapFunc){
    return GestureDetector(
      onTap: () => onTapFunc(),
      child: Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(top: 0.h, bottom: 30.h),
        decoration: BoxDecoration(
          color: backgroudColor,
          borderRadius: BorderRadius.all(Radius.circular(5.w)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
          ],
        ),
      ),
    );
  }

  void completeFunc(){

  }

  void logoutFunc(){
    Get.defaultDialog(
      title: "Are you sure to log out?",
      content: Container(),
      onConfirm: () {
        controller.goLogOut();
      },
      onCancel: (){},
      textConfirm: "Confirm",
      textCancel: "Cancel",
        confirmTextColor: Colors.white
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfilePhoto(),
                    SizedBox(height: 60.h,),
                    _buildButton("Complete",
                        AppColors.primaryElement,
                        AppColors.primaryElementText,
                        completeFunc,
                    ),
                    _buildButton("Log Out",
                        AppColors.primarySecondaryElementText,
                        AppColors.primaryElementText,
                        logoutFunc,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
