import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/common/profilepick.dart';
import 'package:softskills/screens/patient/doctor_calendar.dart';
import 'package:softskills/screens/patient/download_helper.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'dart:io';

class DoctorButton extends StatefulWidget {
  final String name;
  final String surname;
  final String specialite;
  final List<Map<String, String>> availability;
  final String uid;
  final String cv;

  DoctorButton({
    Key? key,
    required this.uid,
    required this.name,
    required this.surname,
    required this.specialite,
    required this.availability,
    required this.cv,
  }) : super(key: key);

  @override
  State<DoctorButton> createState() => _DoctorButtonState();
}

class _DoctorButtonState extends State<DoctorButton> {
  final Auth auth = Auth();
  String? patientUid;

  @override
  void initState() {
    super.initState();
    patientUid = auth.getCurrentUserId();
  }

  Future<void> openDownloadedFile() async {
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/doctor_cv.pdf';
      final file = File(filePath);

      if (await file.exists()) {
        OpenFile.open(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Le fichier n'existe pas!")),
        );
      }
    }
  }

  Future<void> downloadDoctorCV() async {
    if (widget.cv.isNotEmpty) {
      if (kIsWeb) {
        // Directly trigger download on web
        downloadFile(widget.cv, []);
      } else {
        try {
          final response = await http.get(Uri.parse(widget.cv));
          if (response.statusCode == 200) {
            downloadFile("doctor_cv.pdf", response.bodyBytes);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("CV téléchargé avec succès.")),
            );
            await openDownloadedFile();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur lors du téléchargement.")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Échec du téléchargement: $e")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("CV non disponible.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
      child: ElevatedButton(
        onPressed: () {
          if (patientUid != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorCalendar(
                  patientUid: patientUid!,
                  doctorUid: widget.uid,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Patient UID introuvable.")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          backgroundColor: color.bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              child: ClipOval(child: ProfilePicture(uid: widget.uid)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.name} ${widget.surname}',
                      style: Textstyle.formWhite),
                  const SizedBox(height: 4),
                  Text(widget.specialite, style: Textstyle.smallerWhiteText),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '2000 Da/session',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: downloadDoctorCV,
                  icon: Icon(Icons.download, color: Colors.white, size: 20),
                  label: Text("Télécharger CV",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
