import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  final String uid;

  const ProfilePicture({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {

    Future<String?> fetchProfilePicture(String uid) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists && doc.data()?['profilePicture'] != null) {
      return doc.data()?['profilePicture'] as String?;
    }
  } catch (e) {
    debugPrint("Error fetching profile picture: $e");
  }
  return null; // Return null if the profile picture doesn't exist or an error occurs
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: fetchProfilePicture(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            radius: 50,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          );
        } else {
          return CircleAvatar(
            radius: 50, // Adjust radius for your design
            backgroundImage: NetworkImage(snapshot.data!),
            onBackgroundImageError: (_, __) {
              // Handle image load errors gracefully
              debugPrint("Error loading profile picture");
            },
          );
        }
      },
    );
  }
}
