import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/patient/download_helper_mobile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PatientCoachingListScreen extends StatefulWidget {
  const PatientCoachingListScreen({super.key});

  @override
  State<PatientCoachingListScreen> createState() =>
      _PatientCoachingListScreenState();
}

class _PatientCoachingListScreenState extends State<PatientCoachingListScreen> {
  Future<List<Map<String, dynamic>>> fetchAvailableCoachings(
      List<String> doctorUids) async {
    List<Map<String, dynamic>> coachings = [];
    String? uid = Auth().getCurrentUserId();

    for (String doctorUid in doctorUids) {
      QuerySnapshot coachingSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorUid)
          .collection('coachings')
          .get();

      for (var doc in coachingSnapshot.docs) {
        coachings.add({
          'id': doc.id,
          'doctorUid': doctorUid,
          ...doc.data() as Map<String, dynamic>
        });
      }
    }
    return coachings;
  }

  Future<void> downloadFilemessage(
      BuildContext context, String fileURL, String fileName) async {
    if (fileURL.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fichier non disponible.")),
      );
      return;
    }

    try {
      if (kIsWeb) {
        // Handle web file download
        downloadFile(fileURL, []);
      } else {
        final response = await http.get(Uri.parse(fileURL));
        if (response.statusCode == 200) {
          final directory = await getApplicationDocumentsDirectory();
          final safeFileName = fileName.replaceAll(
              RegExp(r'[<>:"/\\|?*]'), '_'); // Avoid invalid characters
          final filePath = '${directory.path}/$safeFileName.pdf';
          final file = File(filePath);

          await file.writeAsBytes(response.bodyBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$safeFileName téléchargé avec succès.")),
          );

          await openDownloadedFile(context, filePath);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur lors du téléchargement.")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec du téléchargement: $e")),
      );
    }
  }

  Future<void> openDownloadedFile(BuildContext context, String filePath) async {
    if (!kIsWeb) {
      final file = File(filePath);
      if (await file.exists()) {
        OpenFile.open(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Le fichier n'existe pas!")),
        );
      }
    }
  }

  Future<List<Map<String, String>>> getDoctorAvailabilities(String uid) async {
    try {
      CollectionReference availabilitiesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('availabilities');

      QuerySnapshot snapshot = await availabilitiesRef.get();

      return snapshot.docs.map((doc) {
        return {
          'day': doc['day'] as String,
          'time': doc['time'] as String,
        };
      }).toList();
    } catch (e) {
      print("Error fetching doctor's availabilities: $e");
      return [];
    }
  }

  Future<void> bookCoaching(
    String coachingId,
    String doctorUid,
    String uid,
    List<Map<String, String>> selectedTimes,
  ) async {
    String patientUid = uid; // Replace with actual UID from Auth

    await FirebaseFirestore.instance.collection('coaching_accesses').add({
      'coachingId': coachingId,
      'patientUid': patientUid,
      'doctorUid': doctorUid,
      'selectedTimes': selectedTimes,
      'bookedAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Coaching réservé avec succès!")),
    );
  }

  void openPDF(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coachings Disponibles")),
      body: FutureBuilder<List<String>>(
        future: fetchDoctorsIds(), // Get the doctor UIDs first
        builder: (context, doctorSnapshot) {
          if (doctorSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (doctorSnapshot.hasError) {
            return Center(child: Text("Erreur: ${doctorSnapshot.error}"));
          } else if (!doctorSnapshot.hasData || doctorSnapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun médecin disponible."));
          }

          List<String> doctorUids = doctorSnapshot.data!;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchAvailableCoachings(doctorUids),
            builder: (context, coachingSnapshot) {
              if (coachingSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (coachingSnapshot.hasError) {
                return Center(child: Text("Erreur: ${coachingSnapshot.error}"));
              } else if (!coachingSnapshot.hasData ||
                  coachingSnapshot.data!.isEmpty) {
                return const Center(child: Text("Aucun coaching disponible."));
              }

              List<Map<String, dynamic>> coachings = coachingSnapshot.data!;

              return ListView.builder(
                itemCount: coachings.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> coaching = coachings[index];

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(coaching['subject'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Prix: ${coaching['price']} DZD"),
                          const SizedBox(height: 5),
                          if (coaching['pdfUrl'] != null)
                            TextButton(
                              onPressed: () => openPDF(coaching['pdfUrl']),
                              child: const Text(
                                "Voir le PDF",
                                style: TextStyle(color: color.bgColor),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              downloadFilemessage(context, coaching['fileUrl'],
                                  coaching['subject']);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              'Download PDF',
                              style: Textstyle.smallerDarkBlueText,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String? cvUrl = await getUserInfo(
                                  uid: coaching['doctorUid'], info: 'cv');
                              String? doctorName = await getUserInfo(
                                  uid: coaching['doctorUid'], info: 'name');

                              if (cvUrl == null || doctorName == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Impossible de récupérer les informations du docteur.")),
                                );
                                return;
                              }

                              downloadFilemessage(context, cvUrl, doctorName);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              'Download Doctor CV',
                              style: Textstyle.smallerDarkBlueText,
                            ),
                          ),
                          FutureBuilder<List<Map<String, String>>>(
                            future:
                                getDoctorAvailabilities(coaching['doctorUid']),
                            builder: (context, availabilitySnapshot) {
                              if (availabilitySnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (availabilitySnapshot.hasError) {
                                return Text(
                                    "Erreur: ${availabilitySnapshot.error}");
                              } else if (!availabilitySnapshot.hasData ||
                                  availabilitySnapshot.data!.isEmpty) {
                                return const Text(
                                    "Aucune disponibilité trouvée.");
                              }

                              List<Map<String, String>> availabilities =
                                  availabilitySnapshot.data!;
                              return Column(
                                children: availabilities.map((availability) {
                                  return CheckboxListTile(
                                    title: Text(
                                        "${availability['day']} - ${availability['time']}"),
                                    value: false,
                                    onChanged: (bool? value) {
                                      // Handle selection logic here
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
