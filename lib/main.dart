import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sglab_desk/common/routes/pages.dart';
import 'package:sglab_desk/common/style/theme.dart';
import 'package:sglab_desk/global.dart';

void main() async {
 await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 780),
      builder: (context, child) => GetMaterialApp(
            title: 'SGLab DESK .',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
      builder:  (context, child) {
        return EasyLoading.init()(context, child!); // Doğru kullanım
    },
          ),
    );
  }
}
