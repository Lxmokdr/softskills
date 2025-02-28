import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:softskills/messages/home.dart';
import 'package:softskills/screens/doctor/doctorHome.dart';
import 'package:softskills/screens/doctor/doctorprofile.dart';
import 'package:softskills/screens/patient/options.dart';
import 'package:softskills/screens/patient/patientprofile.dart';

class CustomNavBarWidget extends StatefulWidget {
  final String role;

  const CustomNavBarWidget({Key? key, required this.role}) : super(key: key);

  @override
  _CustomNavBarWidgetState createState() => _CustomNavBarWidgetState();
}

class _CustomNavBarWidgetState extends State<CustomNavBarWidget> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  /// 📌 Defines the screens for the bottom navigation bar
  List<Widget> _buildScreens() {
    return widget.role == 'patient'
        ? [Options(), ProfilePage(), MessageListPage()]
        : [DoctorHome(), DoctorProfile(), MessageListPage()];
  }

  /// 📌 Defines the items for the bottom navigation bar
  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.message),
        title: "Message",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarItems(), // ✅ Now it's correctly defined
      navBarStyle: NavBarStyle.style3,
    );
  }
}
