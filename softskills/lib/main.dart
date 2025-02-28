import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:softskills/screens/common/bottomnavbar.dart';
import 'package:softskills/firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softskills/screens/common/intro.dart';
import 'package:softskills/screens/common/loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('🔥 Firebase initialized successfully!');
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final role = userSnapshot.data!.get('role');
                  return CustomNavBarWidget(
                      role: role); // Use CustomNavBarWidget
                } else {
                  return const OnBoardingPage();
                }
              },
            );
          } else {
            return const OnBoardingPage();
          }
        },
      ),
    );
  }
}
