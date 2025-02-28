import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<List<Map<String, String>>> fetchDoctorAvailability(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        return (userDoc.get('availability') as List)
            .map((entry) => {
                  'day': entry['day'] as String,
                  'time': entry['time'] as String,
                })
            .toList();
      }
    } catch (e) {
      print("Error retrieving doctor's availability: $e");
    }
    return [];
  }

  Future<String?> loadProfileImage(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc['profilePicture'] ?? null;
    } catch (e) {
      print("Error loading profile image: $e");
      return null;
    }
  }

  Future<void> pickAndUploadFile(String uid, String fieldName) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        PlatformFile platformFile = result.files.first;

        if (kIsWeb) {
          await uploadUserFile(
            uid: uid,
            fieldName: fieldName,
            fileBytes: platformFile.bytes,
          );
        } else {
          File file = File(platformFile.path!);
          await uploadUserFile(
            uid: uid,
            fieldName: fieldName,
            file: file,
          );
        }
      }
    } catch (e) {
      print("Error selecting or uploading file: $e");
    }
  }

  Future<void> pickAndUploadImage(String uid) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        Uint8List imageBytes = await pickedFile.readAsBytes();
        String downloadUrl = await uploadProfileImage(uid, imageBytes);

        await _firestore.collection('users').doc(uid).update({
          'profilePicture': downloadUrl,
        });
      } catch (e) {
        print("Error uploading profile image: $e");
      }
    }
  }

  Future<String> uploadProfileImage(String uid, Uint8List imageBytes) async {
    Reference storageRef =
        _storage.ref().child('users/$uid/profilePicture.jpg');
    await storageRef.putData(imageBytes);
    return await storageRef.getDownloadURL();
  }

  Future<void> uploadUserFile({
    required String uid,
    required String fieldName,
    Uint8List? fileBytes,
    File? file,
  }) async {
    try {
      Reference ref = _storage.ref().child('users/$uid/$fieldName');
      if (fileBytes != null) {
        await ref.putData(fileBytes);
      } else if (file != null) {
        await ref.putFile(file);
      }
      String downloadUrl = await ref.getDownloadURL();
      await _firestore.collection('users').doc(uid).update({
        fieldName: downloadUrl,
      });
    } catch (e) {
      print("Error uploading file: $e");
    }
  }

  Future<void> updateDoctorAvailabilities({
    required String uid,
    required List<Map<String, String>> availability,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'availability': availability,
    });
  }
}
