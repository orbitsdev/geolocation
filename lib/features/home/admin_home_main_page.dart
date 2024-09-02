import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/attendance_page.dart';
import 'package:geolocation/features/chat/chat_page.dart';
import 'package:geolocation/features/home/dashboard/dashboard_page.dart';
import 'package:geolocation/features/management/management_page.dart';
import 'package:geolocation/features/map/sample_map.dart';
import 'package:geolocation/features/profile/user_profile_page.dart';
import 'package:get/get.dart';

class AdminHomeMainPage extends StatefulWidget {
  const AdminHomeMainPage({Key? key}) : super(key: key);

  @override
  State<AdminHomeMainPage> createState() => _AdminHomeMainPageState();
}

class _AdminHomeMainPageState extends State<AdminHomeMainPage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    DashboardPage(),
    MapSample(),
    ChatboxPage(),
    UserProfilePage()
    
  ];

  void _onItemTapped(int index) {
    _selectedIndex = index;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Palette.PRIMARY,
        unselectedItemColor: Palette.LIGHT_PRIMARY,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        selectedItemColor: Colors.white,
        selectedLabelStyle: Get.textTheme.bodyMedium,
        unselectedLabelStyle: Get.textTheme.bodyMedium,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: FaIcon(FontAwesomeIcons.houseChimney, size: 22,),
            icon: FaIcon(FontAwesomeIcons.house, size: 22,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: FaIcon(FontAwesomeIcons.solidCompass,size: 22,),

            icon: FaIcon(FontAwesomeIcons.compass,size: 22,),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            activeIcon: FaIcon(FontAwesomeIcons.commentSms,size: 22,),

            icon: FaIcon(FontAwesomeIcons.commentSms,size: 22,),
            label: 'message',
          ),
         
          BottomNavigationBarItem(
            activeIcon: FaIcon(FontAwesomeIcons.solidUser),
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
