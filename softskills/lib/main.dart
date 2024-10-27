import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:softskills/doctorprofile.dart';
import 'package:softskills/firebase/firebase_options.dart';
import 'package:softskills/screens/homeScreen.dart';
import 'package:softskills/screens/options.dart';
import 'package:softskills/screens/patientprofile.dart';
import 'package:softskills/screens/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomeScreen(),
      // home: Options(),
      // home: SignUpPage(),
      // home: ProfilePage(),
      home : doctorProfile(),

    );
  }
}