import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/doctor/doctorpatientprofile.dart';
import 'package:softskills/screens/common/loading.dart';

class ListPatients extends StatefulWidget {
  const ListPatients({super.key});

  @override
  State<ListPatients> createState() => _ListPatientsState();
}

class _ListPatientsState extends State<ListPatients> {
  final Auth _auth = Auth();
  Future<List<Map<String, dynamic>>>? _patientsWithConsultationsFuture;

  @override
  void initState() {
    super.initState();
    String? doctorUid = _auth.getCurrentUserId();
    if (doctorUid != null) {
      _patientsWithConsultationsFuture =
          _getPatientsWithConsultationDetails(doctorUid);
    }
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingConsultations(
      String doctorUid) async {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final consultationsQuery = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorUid)
        .collection('consultations')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .orderBy('date')
        .get();

    return consultationsQuery.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> _getPatientsWithConsultationDetails(
      String doctorUid) async {
    List<Map<String, dynamic>> consultations =
        await fetchUpcomingConsultations(doctorUid);
    List<Map<String, dynamic>> patientsWithDetails = [];

    for (var consultation in consultations) {
      final patientId = consultation['patientUid'];
      String? nom = await getUserInfo(uid: patientId, info: 'name');
      String? prenom = await getUserInfo(uid: patientId, info: 'surname');
      String? besoin = await getUserInfo(uid: patientId, info: 'besoin');

      patientsWithDetails.add({
        'patientUid': patientId,
        'nom': nom ?? 'Unknown',
        'prenom': prenom ?? 'Unknown',
        'besoin': besoin ?? 'Not specified',
        'date': consultation['date'],
        'time': consultation['time'],
      });
    }
    return patientsWithDetails;
  }

  Future<Map<String, dynamic>> fetchAdditionalUserInfo(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  void showUserInfoDialog(
      BuildContext context, Map<String, dynamic> patient) async {
    final userInfo = await fetchAdditionalUserInfo(patient['patientUid']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Patient: ${patient['nom']} ${patient['prenom']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Age: ${userInfo['age'] ?? 'Not specified'}"),
            Text("Genre: ${userInfo['genre'] ?? 'Not specified'}"),
            Text("Profession: ${userInfo['profession'] ?? 'Not specified'}"),
            Text("Besoin: ${patient['besoin']}"),
            Text("Civil: ${userInfo['civil'] ?? 'Not specified'}"),
            Text(
                "Est-ce leur première experience en psychologie : ${userInfo['isFirst'] ?? 'Not specified'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("List of Patients"),
          backgroundColor: color.bgColor,
          foregroundColor: Colors.white),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _patientsWithConsultationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Loading()); // Use your custom Loading widget here
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No patients found"));
          } else {
            final patientsWithDetails = snapshot.data!;
            return ListView.builder(
              itemCount: patientsWithDetails.length,
              itemBuilder: (context, index) {
                final patient = patientsWithDetails[index];
                final Timestamp dateTimestamp = patient['date'];
                final DateTime date = dateTimestamp.toDate();
                return ListTile(
                  title:
                      Text("Patient: ${patient['nom']} ${patient['prenom']}"),
                  subtitle: Text(
                    "Besoin: ${patient['besoin']}\n"
                    "Consultation Date: ${DateFormat('yyyy-MM-dd').format(date)}\n"
                    "Time: ${patient['time']}",
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
                              doctorPatientProfile(uid: patient['patientUid']),
                        ),
                      );
                    },
                    child: const Text("More Info"),
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
