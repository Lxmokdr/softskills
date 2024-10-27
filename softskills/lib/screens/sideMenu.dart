// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/screens/homeScreen.dart';
import 'package:softskills/screens/patientprofile.dart';

class SideMenu extends StatelessWidget {

  final Auth _auth = Auth();
  

  SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: Drawer(
      backgroundColor:   const Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        children:  [
          UserAccountsDrawerHeader(
            accountName: const Text('Lxmix',
            style: TextStyle(
              color:  Colors.white
            ),), 
            accountEmail: const Text('lamia.koudri@g.enp.edu.dz',
            style: TextStyle(
              color:  Colors.white
            ),),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            decoration:const BoxDecoration(
              color: color.darkBluerColor
            ),
            ),
      
            ListTile(
              leading: const Icon(Icons.account_circle_rounded, color: color.darkBluerColor,),
              title: const Text('Profile', style: TextStyle(color: color.darkBluerColor,),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            
            ListTile(
              
              leading: const Icon(Icons.logout_rounded, color: color.darkBluerColor,),
              title: const Text('Logout', style: TextStyle(color: color.darkBluerColor,),),
              onTap: () async {
                await _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
        ],
      )
    ),
    );
  }
}