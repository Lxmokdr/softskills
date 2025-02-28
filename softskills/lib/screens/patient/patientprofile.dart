import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/common/intro.dart';
import 'dart:typed_data';
import 'package:softskills/screens/common/profilepick.dart';
import 'package:softskills/screens/patient/eduage.dart';
import 'package:softskills/screens/patient/etagenre.dart';
import 'package:softskills/screens/patient/firstbesoin.dart';
import 'package:softskills/screens/patient/profession.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Auth _auth = Auth();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  String? selectedFileName;
  String? profileImageUrl;

  Future<void> pickAndUploadImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        Uint8List imageBytes = await pickedFile.readAsBytes();

        // Upload and get the download URL
        String downloadUrl = await uploadProfileImage(uid!, imageBytes);

        // Update Firestore with new image URL
        await _firestore.collection('users').doc(uid!).update({
          'profilePicture': downloadUrl,
        });

        // Update UI
        setState(() {
          profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Photo de profil mise à jour !")),
        );
      } catch (e) {
        print("Erreur lors de l'envoi de l'image : $e");
      }
    }
  }

  Future<String> uploadProfileImage(String uid, Uint8List imageBytes) async {
    Reference storageRef =
        _storage.ref().child('users/$uid/profilePicture.jpg');

    // Overwrite the existing profile picture
    await storageRef.putData(imageBytes);
    return await storageRef.getDownloadURL();
  }

  String? uid = Auth().getCurrentUserId();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Repondez a autant de questions que possible pour nous permettre de vous apporter la meilleure aide que l\'on puisse.',
                style: Textstyle.smallerDarkBlueText,
              ),
              const SizedBox(
                height: 20,
              ),
              ProfilePicture(uid: uid!),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickAndUploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text('Pick Profile Picture',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              eduage(),
              const SizedBox(height: 10),
              profession(),
              const SizedBox(height: 10),
              etagenre(),
              const SizedBox(height: 10),
              firstbesoin(),
              SizedBox(
                height: 10,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                        child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 248, 17, 0)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      color: Colors.red,
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OnBoardingPage()),
                        );
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: color.bgColor,
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
