import 'package:flutter/material.dart';
import 'package:geolocation/core/bindings/app_binding.dart';
import 'package:geolocation/core/theme/app_theme.dart';
import 'package:geolocation/features/event/event_page.dart';
import 'package:geolocation/features/home/admin_home_main_page.dart';
import 'package:geolocation/features/map/sample_map.dart';
import 'package:geolocation/features/members/member_page.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/playground/modal_test_page.dart';
import 'package:geolocation/features/role/login_selection_page.dart';
import 'package:geolocation/features/signin/controllers/login_controller.dart';
import 'package:geolocation/features/signin/login_page.dart';
import 'package:geolocation/features/signup/signup_page.dart';
import 'package:geolocation/features/task/task_page.dart';
import 'package:get/get.dart';

void main() async  {
   WidgetsFlutterBinding.ensureInitialized();
   AppBinding().dependencies();
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
      home: ModalTestPage(),
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/login-selection', page: () => LoginSelectionPage()),
        GetPage(name: '/sign-up', page: () => SignupPage()),
        GetPage(name: '/home-main', page: () => AdminHomeMainPage()),
        GetPage(name: '/event', page: () => EventPage()),
        GetPage(name: '/notifications', page: () => NotificationPage()),
        GetPage(name: '/members', page: () => MemberPage()),
      ],
    );
  }
}