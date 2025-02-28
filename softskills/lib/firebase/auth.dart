// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:softskills/firebase/user.dart'; // Assuming this is your custom user class
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:softskills/screens/patient/doctor_calendar.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //get user's id
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  // Function to map Firebase User to custom user class
  use? _userFromFirebaseUser(User? user) {
    return user != null && user.emailVerified ? use(uid: user.uid) : null;
  }

  // Stream to listen to auth state changes and map to custom user class
  Stream<use?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<void> sendEmailVerificationLink() async {
    User? user = _firebaseAuth.currentUser;

    // Check if the user is logged in
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        print("Verification email sent to ${user.email}");
      } catch (e) {
        print("Error sending verification email: $e");
      }
    } else {
      print("No user is logged in or user is already verified.");
    }
  }

  Future<use?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await sendEmailVerificationLink();
      return use(uid: user!.uid);
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        var methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
        print('Sign in methods for this email: $methods');
      }
      print("Detailed error: $e");
      return null;
    }
  }

  Future<use?> logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null && user.emailVerified) {
        return _userFromFirebaseUser(user);
      } else {
        print("Email not verified. Please verify your email.");
        await signOut();
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<use?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential result =
            await _firebaseAuth.signInWithCredential(credential);
        if (result.user != null && result.user!.emailVerified) {
          return _userFromFirebaseUser(result.user);
        } else {
          print("Email not verified. Please verify your email.");
          await signOut();
          return null;
        }
      }
    } catch (error) {
      print(error);
    }
    return null;
  }
}

Future<void> saveUserToFirestore({
  required String uid,
  required String email,
  required String name,
  required String surname,
  required String phone,
  required String role,
}) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'surname': surname,
      'phone': phone,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("User data saved successfully");
  } catch (e) {
    print("Error saving user data: $e");
  }
}

Future<void> saveConsultation({
  required String uidPatient,
  required String uidDoctor,
  required String date,
  required String time,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('consultation')
        .doc(uidPatient + uidDoctor)
        .set({
      'patient': uidPatient,
      'doctor': uidDoctor,
      'date': date,
      'time': time,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("Consultation data saved successfully");
  } catch (e) {
    print("Error saving consultation data: $e");
  }
}

Future<String?> getUserInfo({required String uid, required String info}) async {
  try {
    // Reference to the user's document in Firestore
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Check if the document exists and contains the requested field
    if (userDoc.exists && userDoc.data() != null) {
      var userData = userDoc.data() as Map<String, dynamic>;

      // Validate the info parameter
      if (userData.containsKey(info)) {
        return userData[info] as String?;
      } else {
        print("User document does not contain the '$info' field.");
        return null;
      }
    } else {
      print("User document does not exist.");
      return null;
    }
  } catch (e) {
    print("Error fetching user $info: $e");
    return null;
  }
}

Future<void> updateUserField({
  required String uid,
  required String info, // Field name in Firestore
  required dynamic value, // Value to update in the field
}) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      info: value, // Use the value argument for the field update
    });
    print("User's $info updated successfully with value: $value");
  } catch (e) {
    print("Error updating user's $info: $e");
  }
}

Future<void> updateDoctorAvailabilities({
  required String uid,
  required List<Map<String, String>>
      availability, // New entries with 'day' and 'time'
}) async {
  try {
    CollectionReference availabilitiesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('availabilities'); // Subcollection for availability

    for (var entry in availability) {
      String day = entry['day']!;
      String time = entry['time']!;

      // Query Firestore to check if the availability already exists
      QuerySnapshot existingDocs = await availabilitiesRef
          .where('day', isEqualTo: day)
          .where('time', isEqualTo: time)
          .get();

      if (existingDocs.docs.isEmpty) {
        // If the availability does not exist, add it
        await availabilitiesRef.add({
          'day': day,
          'time': time,
        });
      }
    }
  } catch (e) {
    print("Error updating doctor's availability: $e");
  }
}

Future<bool> deleteDoctorAvailability({
  required String uid,
  required String day, // Day to delete
  required String time, // Time to delete
}) async {
  try {
    CollectionReference availabilitiesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('availabilities'); // Subcollection for availability

    // Query Firestore to find the document matching the given day and time
    QuerySnapshot snapshot = await availabilitiesRef
        .where('day', isEqualTo: day)
        .where('time', isEqualTo: time)
        .get();

    for (var doc in snapshot.docs) {
      await availabilitiesRef.doc(doc.id).delete(); // Delete the found document
    }
    return true; // Deletion successful
  } catch (e) {
    print("Error deleting doctor's availability: $e");
    return false; // Deletion failed
  }
}

Future<void> uploadUserFile({
  required String uid,
  required String fieldName,
  File? file,
  Uint8List? fileBytes,
}) async {
  try {
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('user_files')
        .child(uid)
        .child(fieldName);

    TaskSnapshot snapshot;

    if (kIsWeb && fileBytes != null) {
      // Web: Upload bytes
      snapshot = await storageRef.putData(fileBytes);
    } else if (file != null) {
      // Mobile: Upload file
      snapshot = await storageRef.putFile(file);
    } else {
      throw Exception("No valid file data provided.");
    }

    String downloadUrl = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      fieldName: downloadUrl,
    });

    print("File uploaded and URL saved to Firestore successfully");
  } on FirebaseException catch (e) {
    print("Firebase error during upload: ${e.message}");
  } catch (e) {
    print("Unexpected error uploading file: $e");
  }
}

void navigateToCalendar(
    BuildContext context, String patientUid, String doctorUid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          DoctorCalendar(patientUid: patientUid, doctorUid: doctorUid),
    ),
  );
}

Future<List<String>> fetchDoctorsIds() async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'doctor')
        .get();

    List<String> doctorIds = snapshot.docs.map((doc) => doc.id).toList();

    print("Fetched Doctor IDs: $doctorIds"); // Debugging print

    return doctorIds;
  } catch (e) {
    print('Error fetching doctor IDs: $e');
    return [];
  }
}

Future<void> saveJournalEntry({
  required String uid,
  required Map<String, dynamic> entry,
}) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('journals')
      .add(entry);
}

Future<List<Map<String, String>>> getDoctorAvailabilities(String uid) async {
  try {
    CollectionReference availabilitiesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('availabilities');

    QuerySnapshot snapshot = await availabilitiesRef.get();

    // Convert Firestore documents to List<Map<String, String>>
    List<Map<String, String>> availabilities = snapshot.docs.map((doc) {
      return {
        'day': doc['day'] as String,
        'time': doc['time'] as String,
      };
    }).toList();

    return availabilities;
  } catch (e) {
    print("Error fetching doctor's availabilities: $e");
    return [];
  }
}
