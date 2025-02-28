import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/common/intro.dart';
import 'package:softskills/screens/common/loading.dart';
import 'package:softskills/screens/common/profilepick.dart';
import 'package:softskills/screens/doctor/pickers.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final Auth _auth = Auth();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? uid = Auth().getCurrentUserId();
  List<Map<String, String>> dateTimeList = [];
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  String? selectedFileName;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    if (uid != null) {
      getDoctorAvailabilities(uid!).then((availabilities) {
        setState(() {
          dateTimeList = availabilities;
        });
      });
    }
  }

  Future<void> _addAvailability() async {
    String? selectedDay;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajoutez une disponibilité"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: "Sélectionnez un jour"),
              items: [
                "Lundi",
                "Mardi",
                "Mercredi",
                "Jeudi",
                "Vendredi",
                "Samedi",
                "Dimanche"
              ].map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (value) {
                selectedDay = value;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              child: const Text("Sélectionnez une heure"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedDay != null && selectedTime != null && uid != null) {
                String formattedTime = selectedTime!.format(context);

                try {
                  // Add to Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('availabilities')
                      .add({
                    'day': selectedDay!,
                    'time': formattedTime,
                  });

                  // Refresh UI
                  List<Map<String, String>> updatedAvailabilities =
                      await getDoctorAvailabilities(uid!);
                  setState(() {
                    dateTimeList = updatedAvailabilities;
                  });

                  Navigator.pop(context);
                } catch (e) {
                  print("Error adding availability: $e");
                }
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading
          ? const Center(child: Loading())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Remplissez ce formulaire pour permettre à vos patients d\'en savoir plus sur vous.',
                      style: TextStyle(fontSize: 16, color: color.bgColor),
                    ),
                    const SizedBox(height: 20),
                    ProfilePicture(uid: uid!),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          pickAndUploadImage, // Implement image picker here
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
                    IntrinsicHeight(child: SpeAge()),
                    const SizedBox(height: 10),
                    IntrinsicHeight(child: experienceWid()),
                    const SizedBox(height: 10),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(child: CVGenre()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          _addAvailability, // Trigger availability picker
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Ajoutez vos disponibilités',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dateTimeList.length,
                      itemBuilder: (context, index) {
                        final entry = dateTimeList[index];
                        String day = entry["day"] ?? "";
                        String time = entry["time"] ?? "";

                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              title: Text(
                                "$day à $time",
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  bool deleted = await deleteDoctorAvailability(
                                    day: day,
                                    uid: uid!,
                                    time: time,
                                  );

                                  if (deleted) {
                                    // Refresh the list after deletion
                                    List<Map<String, String>>
                                        updatedAvailabilities =
                                        await getDoctorAvailabilities(uid!);
                                    setState(() {
                                      dateTimeList = updatedAvailabilities;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
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
                                    builder: (context) =>
                                        const OnBoardingPage()),
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
