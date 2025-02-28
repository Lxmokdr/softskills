import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/common/loading.dart';
import 'package:softskills/screens/doctor/doctorpatientprofile.dart';

class Listenrolledpatients extends StatelessWidget {
  final String doctorUid;
  final String formationId;

  const Listenrolledpatients({
    Key? key,
    required this.formationId,
    required this.doctorUid,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> getEnrolledPatients() async {
    try {
      final enrollmentRef = FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorUid)
          .collection('formations')
          .doc(formationId)
          .collection('enrolledPatients');

      final querySnapshot = await enrollmentRef.get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> patients = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final uid = doc.id;
          final name = await getUserInfo(uid: uid, info: 'name') ?? 'Unknown';
          final surname = await getUserInfo(uid: uid, info: 'surname') ?? '';
          final email =
              await getUserInfo(uid: uid, info: 'email') ?? 'No email';
          final phone =
              await getUserInfo(uid: uid, info: 'phone') ?? 'No phone';
          final besoin = await getUserInfo(uid: uid, info: 'besoin') ?? 'N/A';
          final time = await getUserInfo(uid: uid, info: 'time') ?? 'Unknown';
          final dateTimestamp =
              await getUserInfo(uid: uid, info: 'date') ?? Timestamp.now();

          final DateTime date = (dateTimestamp is Timestamp)
              ? dateTimestamp.toDate()
              : DateTime.now();

          return {
            'uid': uid,
            'name': name,
            'surname': surname,
            'email': email,
            'phone': phone,
            'besoin': besoin,
            'time': time,
            'date': date,
          };
        }),
      );
      print("Fetched patient data: $patients");

      return patients;
    } catch (e) {
      print('Error fetching enrolled patients: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Patients"),
        backgroundColor: color.bgColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getEnrolledPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loading());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No patients found",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            final patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(patient['date']);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      "Patient: ${patient['name']} ${patient['surname']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Besoin: ${patient['besoin']?.toString() ?? 'Not provided'}\n"
                      "Consultation Date: $formattedDate\n"
                      "Time: ${patient['time']?.toString() ?? 'Not set'}",
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.bgColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                doctorPatientProfile(uid: patient['uid']),
                          ),
                        );
                      },
                      child: const Text("More Info"),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
