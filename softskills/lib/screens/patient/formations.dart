import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/database.dart';
import 'package:softskills/screens/common/loading.dart';
import 'package:softskills/screens/common/profilepick.dart';
import 'package:softskills/screens/patient/download_helper.dart';
import '../../firebase/auth.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Formation extends StatefulWidget {
  Formation({super.key});

  @override
  State<Formation> createState() => _FormationState();
}

class _FormationState extends State<Formation> {
  String? uid = Auth().getCurrentUserId();
  DatabaseService databaseService = DatabaseService();

  Future<List<String>> doctorsIds = fetchDoctorsIds();

  Future<List<Map<String, dynamic>>> _fetchFormationsForDoctors(
      List<String> doctorIds) async {
    print("Doctor IDs: $doctorIds"); // Debugging print
    if (doctorIds.isEmpty) {
      print("No doctor IDs found.");
      return [];
    }
    try {
      List<Future<List<Map<String, dynamic>>>> futures = [];
      for (String doctorId in doctorIds) {
        futures.add(databaseService.fetchFormations(doctorId));
      }
      List<List<Map<String, dynamic>>> allFormationsLists =
          await Future.wait(futures);
      return allFormationsLists.expand((formations) => formations).toList();
    } catch (e) {
      print('Error fetching formations: $e');
      return [];
    }
  }

  Future<void> joinFormation(
      String doctorUid, String formationId, String patientUid) async {
    try {
      final enrollmentRef = FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorUid)
          .collection('formations')
          .doc(formationId)
          .collection('enrolledPatients')
          .doc(
              patientUid); // Use patientUid as doc ID to avoid duplicate entries

      await enrollmentRef.set({
        'patientUid': patientUid,
        'enrolledAt': FieldValue.serverTimestamp(), // Store the timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully enrolled in the formation')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error enrolling in formation: $e')),
      );
    }
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

  void showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Payment Method"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("CIB Card"),
                leading: Radio<String>(
                  value: "CIB Card",
                  groupValue: null,
                  onChanged: (String? value) {
                    Navigator.pop(context); // Close dialog
                    print("Payment method: CIB Card");
                  },
                ),
              ),
              ListTile(
                title: const Text("Edahabiya Card"),
                leading: Radio<String>(
                  value: "Edahabiya Card",
                  groupValue: null,
                  onChanged: (String? value) {
                    Navigator.pop(context); // Close dialog
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Enter Edahabiya Card Info",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                // Card Number
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Card Number",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                // Expiration Date Dropdown (Month and Year)
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          labelText: "Month",
                                          border: OutlineInputBorder(),
                                        ),
                                        items: List.generate(12, (index) {
                                          return DropdownMenuItem(
                                            value: (index + 1)
                                                .toString()
                                                .padLeft(2, '0'),
                                            child: Text(
                                              (index + 1)
                                                  .toString()
                                                  .padLeft(2, '0'),
                                            ),
                                          );
                                        }),
                                        onChanged: (value) {
                                          print("Selected month: $value");
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          labelText: "Year",
                                          border: OutlineInputBorder(),
                                        ),
                                        items: List.generate(10, (index) {
                                          int year =
                                              DateTime.now().year + index;
                                          return DropdownMenuItem(
                                            value: year.toString(),
                                            child: Text(year.toString()),
                                          );
                                        }),
                                        onChanged: (value) {
                                          print("Selected year: $value");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // CVV
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "CVV",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                // Submit Button
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle payment processing here
                                    Navigator.pop(
                                        context); // Close the bottom sheet
                                    print("Card information submitted");
                                  },
                                  child: const Text("Submit"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context); // Close dialog without selection
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Choisissez une formation'),
        backgroundColor: color.bgColor,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDoctorsIds().then((doctorsIds) =>
            _fetchFormationsForDoctors(doctorsIds.cast<String>())),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading(); // Custom loading widget
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text("No formations found."));
          }

          final formations = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: formations.length,
            itemBuilder: (context, index) {
              final formation = formations[index];
              DateTime? dateTime;
              if (formation['date'] is Timestamp) {
                dateTime = (formation['date'] as Timestamp).toDate();
              } else if (formation['date'] is int) {
                dateTime =
                    DateTime.fromMillisecondsSinceEpoch(formation['date']);
              }
              String formattedDate = dateTime != null
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(dateTime)
                  : 'N/A';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.bgColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfilePicture(
                              uid: formation['doctorUid'] ?? "Unknown"),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FutureBuilder<List<dynamic>>(
                              future: Future.wait([
                                getUserInfo(
                                    uid: formation['doctorUid'], info: 'name'),
                                getUserInfo(
                                    uid: formation['doctorUid'],
                                    info: 'specialite'),
                              ]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return Text('Doctor info not available',
                                      style: Textstyle.whiteText);
                                }

                                final name = snapshot.data![0] ?? 'Unknown';
                                final speciality = snapshot.data![1] ??
                                    'Specialty not available';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: Textstyle.whiteText),
                                    Text(speciality,
                                        style: Textstyle.smallerWhiteText),
                                    Text(
                                        'Subject: ${formation['subject'] ?? 'N/A'}',
                                        style: Textstyle.smallerWhiteText),
                                    Text(formattedDate,
                                        style: Textstyle.smallerWhiteText),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Price: ${formation['price'] ?? '0'} DA',
                          style: Textstyle.smallerWhiteText),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (uid == null) {
                                print("Error: uid is null.");
                                return;
                              }

                              joinFormation(
                                formation['doctorUid'],
                                formation['formationId'],
                                uid!,
                              );
                              showPaymentDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              'Join',
                              style: Textstyle.smallerDarkBlueText,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              downloadFilemessage(context, formation['pdfFile'],
                                  formation['subject']);
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
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
