import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocation/core/globalcontroller/modal_controller.dart';
import 'package:geolocation/core/bindings/app_binding.dart';
import 'package:geolocation/core/bindings/global_binding.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/services/firebase_service.dart';
import 'package:geolocation/core/services/notificaiton_service.dart';
import 'package:geolocation/core/theme/app_theme.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/middleware/auth_middleware.dart';
import 'package:geolocation/features/auth/middleware/guest_middleware.dart';
import 'package:geolocation/features/collections/collection_page.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page_admin.dart';
import 'package:geolocation/features/council_positions/pages/create_or_edit_council_member_page.dart';
import 'package:geolocation/features/councils/pages/council_list_page.dart';
import 'package:geolocation/features/event/event_page.dart';
import 'package:geolocation/features/globalpage/forbidden_page.dart';
import 'package:geolocation/features/home/admin_home_main_page.dart';
import 'package:geolocation/features/home/all_tab.dart';
import 'package:geolocation/features/home/dashboard/dashboard_page.dart';
import 'package:geolocation/features/home/middleware/full_access_middleware.dart';
import 'package:geolocation/features/home/middleware/role_middleware.dart';
import 'package:geolocation/features/map/sample_map.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/officers/alltasks/task_main.dart';
import 'package:geolocation/features/officers/officer_files_page.dart';
import 'package:geolocation/features/playground/login_page_test.dart';
import 'package:geolocation/features/playground/modal_test_page.dart';
import 'package:geolocation/features/playground/officer_home_page.dart';
import 'package:geolocation/features/playground/page1.dart';
import 'package:geolocation/features/playground/page1_middleware.dart';
import 'package:geolocation/features/playground/page2.dart';
import 'package:geolocation/features/playground/page2_middleware.dart';
import 'package:geolocation/features/playground/page3.dart';
import 'package:geolocation/features/playground/test.dart';
import 'package:geolocation/features/post/post_page.dart';
import 'package:geolocation/features/reports/page/report_page.dart';
import 'package:geolocation/features/role/login_selection_page.dart';
import 'package:geolocation/features/auth/controller/login_controller.dart';
import 'package:geolocation/features/auth/pages/login_page.dart';
import 'package:geolocation/features/auth/pages/signup_page.dart';
import 'package:geolocation/features/settings/profile_page.dart';
import 'package:geolocation/features/task/member_task_page.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point') 
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  NotificationsService.handleBackground(message);
}
Future<void> main() async  {
   WidgetsFlutterBinding.ensureInitialized();
    NotificationsService.init();
  
   await FirebaseService.initializeApp().then((value){
    print(value);
   }).catchError((e){
    print(e.toString());
    Modal.showToast(msg: e.toString());
   });
    GlobalBinding().dependencies();   
   await AuthController.controller.loadTokenAndUser(showModal: false);
   ModalController.controller.setDialog(false);
   await NotificationsService().requestNotification();
   

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationsService.handleForground(message);
  });
  

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    NotificationsService.handleWhenOfficialNotificationClick(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Palette.card3 ,// Change this to your desired color
      statusBarIconBrightness: Brightness.light, // For light icons
      statusBarBrightness: Brightness.dark, // For iOS
    ));
    return GetMaterialApp(
      theme: AppTheme.UI,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', 
      getPages: [
       
      
        GetPage(name: '/login', page: () => LoginPage(), middlewares:[GuestMiddleware()]),
        GetPage(name: '/sign-up', page: () => SignupPage(),middlewares:[GuestMiddleware()]),
        GetPage(name: '/login-selection', page: () => LoginSelectionPage(), middlewares: []),
        GetPage(name: '/dashboard', page: () => DashboardPage(), middlewares: [AuthMiddleware(),RoleMiddleware()]),
        
        // GetPage(name: '/home-main', page: () => AdminHomeMainPage(), middlewares: [AuthMiddleware(), RoleMiddleware()]),
        GetPage(name: '/home-officer', page: () => OfficerHomePage(), middlewares: [AuthMiddleware()]),

        GetPage(name: '/councils', page: () => CouncilListPage(), middlewares: []),
        GetPage(name: '/members', page: () => CouncilMemberPositionListPage(), middlewares: []),
        GetPage(name: '/members-admin', page: () => CouncilMemberPositionListAdmin(), middlewares: []),
        GetPage(name: '/create-or-edit', page: () => CreateOrEditCouncilMemberPage(), middlewares: []),

        GetPage(name: '/tasks', page: () => MemberTaskPage(), middlewares: []),
        GetPage(name: '/collections', page: () => CollectionPage(), middlewares: []),
        GetPage(name: '/events', page: () => EventPage(), middlewares: []),

        GetPage(name: '/notifications', page: () => NotificationPage(), middlewares: []),
        GetPage(name: '/posts', page: () => PostPage(), middlewares: []),
        GetPage(name: '/files', page: () => OfficerFilesPage(), middlewares: []),
        GetPage(name: '/reports', page: () => ReportPage(), middlewares: [AuthMiddleware()]),

        


        GetPage(name: '/settings', page: () => ProfilePage(), middlewares: []),
        GetPage(name: '/councils', page: () => CouncilListPage(), middlewares: []),
        GetPage(name: '/forbidden', page: () => ForbiddenPage(), middlewares: []),
        GetPage(name: '/officers-task-main', page: () => TaskMain(), middlewares: []),
        GetPage(name: '/test', page: () => Test(), middlewares: []),
      ],
    );
  }
}