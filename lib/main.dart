import 'package:flutter/material.dart';
import 'package:geolocation/core/api/globalcontroller/modal_controller.dart';
import 'package:geolocation/core/bindings/app_binding.dart';
import 'package:geolocation/core/bindings/global_binding.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/services/firebase_service.dart';
import 'package:geolocation/core/theme/app_theme.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/middleware/auth_middleware.dart';
import 'package:geolocation/features/auth/middleware/guest_middleware.dart';
import 'package:geolocation/features/council_positions/pages/create_or_edit_council_member_page.dart';
import 'package:geolocation/features/councils/pages/council_list_page.dart';
import 'package:geolocation/features/event/event_page.dart';
import 'package:geolocation/features/globalpage/forbidden_page.dart';
import 'package:geolocation/features/home/admin_home_main_page.dart';
import 'package:geolocation/features/home/middleware/full_access_middleware.dart';
import 'package:geolocation/features/map/sample_map.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page.dart';
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
import 'package:geolocation/features/task/member_task_page.dart';
import 'package:geolocation/features/task/task_page.dart';
import 'package:get/get.dart';

Future<void> main() async  {
   WidgetsFlutterBinding.ensureInitialized();
   GlobalBinding().dependencies();   
   await FirebaseService.initializeApp().then((value){
    print(value);
   }).catchError((e){
    print(e.toString());
    Modal.showToast(msg: e.toString());
   });
   await AuthController.controller.loadTokenAndUser(showModal: false);
   ModalController.controller.setDialog(false);
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
    Future.delayed(Duration.zero, () async {
      
      if(AuthController.controller.token.value.isNotEmpty){
        await AuthController.controller.fetchAndUpdateUserDetails(showModal: true);
      }
      AuthController.controller.updateDeviceToken();
    });  
    
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
       
      
        GetPage(name: '/login', page: () => LoginPage(), middlewares:[GuestMiddleware()]),
        GetPage(name: '/sign-up', page: () => SignupPage(),middlewares:[GuestMiddleware()]),
        GetPage(name: '/login-selection', page: () => LoginSelectionPage(), middlewares: []),
        GetPage(name: '/home-main', page: () => AdminHomeMainPage(), middlewares: [AuthMiddleware(), FullAccessMiddleware()]),

        GetPage(name: '/councils', page: () => CouncilListPage(), middlewares: []),
        GetPage(name: '/members', page: () => CouncilMemberPositionListPage(), middlewares: []),
        GetPage(name: '/create-or-edit', page: () => CreateOrEditCouncilMemberPage(), middlewares: []),

        GetPage(name: '/tasks', page: () => MemberTaskPage(), middlewares: []),
        GetPage(name: '/event', page: () => EventPage(), middlewares: []),

        GetPage(name: '/notifications', page: () => NotificationPage(), middlewares: []),
        


        GetPage(name: '/settings', page: () => SettingsPage(), middlewares: []),
        GetPage(name: '/councils', page: () => CouncilListPage(), middlewares: []),
        GetPage(name: '/forbidden', page: () => ForbiddenPage(), middlewares: []),
      ],
    );
  }
}