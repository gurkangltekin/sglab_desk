import 'package:flutter/material.dart';
import 'package:sglab_desk/common/middlewares/middlewares.dart';

import 'package:get/get.dart';

import 'package:sglab_desk/pages/frame/welcome/index.dart';
import 'package:sglab_desk/pages/frame/sign_in/index.dart';
import 'package:sglab_desk/pages/message/index.dart';
import 'package:sglab_desk/pages/profile/index.dart';
import 'package:sglab_desk/pages/contact/index.dart';
import 'package:sglab_desk/pages/chat/index.dart';
import 'package:sglab_desk/pages/voicecall/index.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    // ABOUT BOOT UP THE APP
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    //
    // // 需要登录
    // // GetPage(
    // //   name: AppRoutes.Application,
    // //   page: () => ApplicationPage(),
    // //   binding: ApplicationBinding(),
    // //   middlewares: [
    // //     RouteAuthMiddleware(priority: 1),
    // //   ],
    // // ),
    //
    // // 最新路由
    // GetPage(name: AppRoutes.EmailLogin, page: () => EmailLoginPage(), binding: EmailLoginBinding()),
    // GetPage(name: AppRoutes.Register, page: () => RegisterPage(), binding: RegisterBinding()),
    // GetPage(name: AppRoutes.Forgot, page: () => ForgotPage(), binding: ForgotBinding()),
    // GetPage(name: AppRoutes.Phone, page: () => PhonePage(), binding: PhoneBinding()),
    // GetPage(name: AppRoutes.SendCode, page: () => SendCodePage(), binding: SendCodeBinding()),
    // // 首页
    GetPage(
      name: AppRoutes.Contact,
      page: () => ContactPage(),
      binding: ContactBinding(),
    ),
    //message page
    GetPage(
      name: AppRoutes.Message,
      page: () => MessagePage(),
      binding: MessageBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
    //Profile Section
    GetPage(
      name: AppRoutes.Profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),

    // Chat Page
    GetPage(
        name: AppRoutes.Chat, page: () => ChatPage(), binding: ChatBinding()),
    //
    // GetPage(name: AppRoutes.Photoimgview, page: () => PhotoImgViewPage(), binding: PhotoImgViewBinding()),
    GetPage(
      name: AppRoutes.VoiceCall,
      page: () => VoiceCallPage(),
      binding: VoiceCallBinding(),
    ),
    // GetPage(name: AppRoutes.VideoCall, page: () => VideoCallPage(), binding: VideoCallBinding()),
  ];
}
