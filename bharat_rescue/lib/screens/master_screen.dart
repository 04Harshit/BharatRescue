import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_screen.dart';
import 'complaint_screen.dart';
import 'map_screen.dart';
import 'notice_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;
  List<String> screenName = const [
    "Locate Centres",
    "Notices",
    "Your Complaints",
    "Profile"
  ];

  List<Widget> content = const [
    MapScreen(),
    NoticeScreen(),
    ComplaintScreen(),
    ProfileScreen()
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      _selectedIndex = 0;
    });
  }

  void showLogoutSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout Successful'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenName[_selectedIndex]),
        leading: (screenName[_selectedIndex] == 'Profile')
            ? InkWell(
                onTap: () {
                  logout();
                  showLogoutSnackbar(context);
                },
                child: const Icon(Icons.logout_outlined),
              )
            : Container(),
      ),
      body: SafeArea(
        child: content[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Centres'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Notices'),
          BottomNavigationBarItem(
              icon: Icon(Icons.report), label: 'Complaints'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
