import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<List<Map<String, dynamic>>> fetchFormations(String doctorId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('formations')
          .get();

      List<Map<String, dynamic>> formations = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>, // Ensure it's properly cast
        };
      }).toList();

      return formations;
    } catch (e) {
      print('Error fetching formations: $e');
      return [];
    }
  }
}

Future<List<Map<String, dynamic>>> getAllBookingsForPatient(
    String uid, List<String> doctorIds) async {
  List<Map<String, dynamic>> bookings = [];

  for (String doctorId in doctorIds) {
    // 1️⃣ Fetch all consultations where `patientUid` matches
    QuerySnapshot consultationsSnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('consultations')
        .where('patientUid', isEqualTo: uid)
        .get();

    for (var doc in consultationsSnapshot.docs) {
      bookings.add({
        'type': 'Consultation',
        'doctorUid': doctorId,
        'date': doc['date'], // Fetching date field
        'time': doc['time'], // Fetching time field
      });
    }

    // 2️⃣ Fetch formations where the patient is enrolled
    QuerySnapshot formationsSnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('formations')
        .get();

    for (var formationDoc in formationsSnapshot.docs) {
      String formationId = formationDoc.id;

      DocumentSnapshot enrolledPatientDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('formations')
          .doc(formationId)
          .collection('enrolledPatients')
          .doc(uid)
          .get();

      if (enrolledPatientDoc.exists) {
        bookings.add({
          'type': 'Formation',
          'doctorUid': doctorId,
          'formationId': formationId,
          'subject': formationDoc['subject'],
          'date': formationDoc['date'], // Fetching date field
          'time': formationDoc['time'], // Fetching time field
        });
      }
    }
  }

  return bookings;
}
