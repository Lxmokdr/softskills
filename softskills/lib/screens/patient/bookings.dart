import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/firebase/database.dart';
import 'package:softskills/screens/common/loading.dart';
import 'package:softskills/screens/patient/download_helper_mobile.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  String? uid = Auth().getCurrentUserId();

  // Function to format Firestore timestamps
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } else if (timestamp is String) {
      return timestamp; // Assume already formatted
    }
    return "Date inconnue"; // Default fallback
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        centerTitle: true,
      ),
      body: uid == null
          ? const Center(child: Text("Utilisateur non connecté."))
          : FutureBuilder<List<String>>(
              future: fetchDoctorsIds(),
              builder: (context, doctorsSnapshot) {
                if (doctorsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: Loading());
                } else if (doctorsSnapshot.hasError) {
                  return Center(
                      child: Text("Erreur: ${doctorsSnapshot.error}"));
                } else if (!doctorsSnapshot.hasData ||
                    doctorsSnapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun médecin trouvé."));
                }

                List<String> doctorIds = doctorsSnapshot.data!;

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: getAllBookingsForPatient(uid!, doctorIds),
                  builder: (context, bookingsSnapshot) {
                    if (bookingsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (bookingsSnapshot.hasError) {
                      return Center(
                          child: Text("Erreur: ${bookingsSnapshot.error}"));
                    } else if (!bookingsSnapshot.hasData ||
                        bookingsSnapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("Aucune réservation trouvée."));
                    }

                    List<Map<String, dynamic>> bookings =
                        bookingsSnapshot.data!;

                    return ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];

                        String formattedDateTime;
                        String bookingType = booking['type'] ?? 'Inconnu';
                        String bookingSubject =
                            booking['subject'] ?? 'Sans sujet';
                        String? fileUrl = booking['pdfFile'];
                        print(fileUrl);

                        if (bookingType == 'Consultation') {
                          String formattedDate =
                              formatTimestamp(booking['date']);
                          String formattedTime =
                              booking['time'] ?? 'Non précisé';
                          formattedDateTime = "$formattedDate à $formattedTime";
                        } else {
                          formattedDateTime = formatTimestamp(booking['date']);
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            leading: Icon(
                              bookingType == 'Consultation'
                                  ? Icons.medical_services
                                  : Icons.school,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              bookingType == 'Consultation'
                                  ? 'Consultation'
                                  : 'Formation: $bookingSubject',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Date et Heure: $formattedDateTime'),
                            trailing: fileUrl != null
                                ? ElevatedButton(
                                    onPressed: () {
                                      downloadFilemessage(
                                          context, fileUrl, bookingSubject);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Text(
                                      'Download PDF',
                                      style: Textstyle.smallerDarkBlueText,
                                    ),
                                  )
                                : null,
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
