import 'package:flutter/material.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/screens/doctor/doctorprofile.dart';
import 'package:softskills/screens/common/homeScreen.dart';
import 'package:softskills/screens/common/login.dart';
import 'package:softskills/screens/patient/patientprofile.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final Auth _auth = Auth();
  String? name;
  String? email;
  String? surname;
  String? uid = Auth().getCurrentUserId();
  String role = ''; // Initialize role as an empty string

  @override
  void initState() {
    super.initState();
    uid = _auth.getCurrentUserId();
    fetchUserInfo(uid!);
  }

  Future<void> fetchUserInfo(String uid) async {
    String? fetchedName = await getUserInfo(uid: uid, info: 'name');
    String? fetchedEmail = await getUserInfo(uid: uid, info: 'email');
    String? fetchedSurname = await getUserInfo(uid: uid, info: 'surname');
    String fetchedRole = await getUserInfo(uid: uid, info: 'role') ?? '';

    setState(() {
      name = fetchedName;
      email = fetchedEmail;
      surname = fetchedSurname;
      role = fetchedRole; // Store the role in state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Row(
              children: [
                Text(
                  name ?? "Loading...",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  surname ?? "Loading...",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            accountEmail: Text(
              email ?? "Loading...",
              style: const TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            decoration: const BoxDecoration(color: color.darkBluerColor),
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle_rounded,
              color: color.darkBluerColor,
            ),
            title: const Text(
              'Profile',
              style: TextStyle(color: color.darkBluerColor),
            ),
            onTap: () {
              if (role == 'doctor') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorProfile()),
                );
              } else if (role == 'patient') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              } else {
                // Default screen if role is unknown
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: color.bgColor,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(color: color.darkBluerColor),
            ),
            onTap: () async {
              await _auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
