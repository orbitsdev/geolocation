import 'package:flutter/material.dart';
import 'package:geolocation/core/bindings/app_binding.dart';
import 'package:geolocation/core/bindings/global_binding.dart';
import 'package:geolocation/core/theme/app_theme.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/middleware/auth_middleware.dart';
import 'package:geolocation/features/auth/middleware/guest_middleware.dart';
import 'package:geolocation/features/event/event_page.dart';
import 'package:geolocation/features/home/admin_home_main_page.dart';
import 'package:geolocation/features/map/sample_map.dart';
import 'package:geolocation/features/members/member_page.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/playground/login_page_test.dart';
import 'package:geolocation/features/playground/modal_test_page.dart';
import 'package:geolocation/features/playground/page1.dart';
import 'package:geolocation/features/playground/page1_middleware.dart';
import 'package:geolocation/features/playground/page2.dart';
import 'package:geolocation/features/playground/page2_middleware.dart';
import 'package:geolocation/features/playground/page3.dart';
import 'package:geolocation/features/role/login_selection_page.dart';
import 'package:geolocation/features/auth/controller/login_controller.dart';
import 'package:geolocation/features/auth/pages/login_page.dart';
import 'package:geolocation/features/auth/pages/signup_page.dart';
import 'package:geolocation/features/settings/settings_page.dart';
import 'package:geolocation/features/task/task_page.dart';
import 'package:get/get.dart';

void main() async  {
   WidgetsFlutterBinding.ensureInitialized();
   GlobalBinding().dependencies();
   await AuthController.controller.loadTokenAndUser();
   print(AuthController.controller.token.value);
   print(AuthController.controller.user.toString());
   runApp(const GeoLocationApp());
}



class GeoLocationApp extends StatefulWidget   {
  
  const GeoLocationApp({ Key? key }) : super(key: key);

  @override
  _GeoLocationAppState createState() => _GeoLocationAppState();
}


class _GeoLocationAppState extends State<GeoLocationApp>  with WidgetsBindingObserver {
  
   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
      print('resume');
      case AppLifecycleState.inactive:
      print('ianctive');
      case AppLifecycleState.detached:
      print('detach');
      print('detach');
      case AppLifecycleState.paused:
      print('pause');
      default:
    }
  }

  @override
  void dispose() {
     WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.UI,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', 
      getPages: [
       
        GetPage(name: '/loading', page: () => Page1(), middlewares:[GuestMiddleware()]),
        GetPage(name: '/login', page: () => LoginPage(), middlewares:[GuestMiddleware()]),
        GetPage(name: '/sign-up', page: () => SignupPage(),middlewares:[GuestMiddleware()]),
        GetPage(name: '/login-selection', page: () => LoginSelectionPage(), middlewares: [AuthMiddleware()]),
        GetPage(name: '/home-main', page: () => AdminHomeMainPage(), middlewares: [AuthMiddleware()]),
        GetPage(name: '/event', page: () => EventPage(), middlewares: [AuthMiddleware()]),
        GetPage(name: '/notifications', page: () => NotificationPage(), middlewares: [AuthMiddleware()]),
        GetPage(name: '/members', page: () => MemberPage(), middlewares: [AuthMiddleware()]),
        GetPage(name: '/settings', page: () => SettingsPage(), middlewares: [AuthMiddleware()]),
      ],
    );
  }
}