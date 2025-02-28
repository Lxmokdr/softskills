import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DoctorCoachingScreen extends StatefulWidget {
  final String doctorUid;
  const DoctorCoachingScreen({super.key, required this.doctorUid});

  @override
  State<DoctorCoachingScreen> createState() => _DoctorCoachingScreenState();
}

class _DoctorCoachingScreenState extends State<DoctorCoachingScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  PlatformFile? selectedFile;
  bool isLoading = false;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  Future<void> saveCoaching() async {
    if (_subjectController.text.isEmpty ||
        _priceController.text.isEmpty ||
        selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Remplissez tous les champs et ajoutez un fichier.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String? fileUrl = await _uploadFile(selectedFile!);
      if (fileUrl == null) {
        throw Exception("Échec de l'upload du fichier.");
      }

      String coachingId = FirebaseFirestore.instance
          .collection("doctors")
          .doc(widget.doctorUid)
          .collection("coachings")
          .doc()
          .id;

      await FirebaseFirestore.instance
          .collection("doctors")
          .doc(widget.doctorUid)
          .collection("coachings")
          .doc(coachingId)
          .set({
        'subject': _subjectController.text,
        'price': double.parse(_priceController.text),
        'fileUrl': fileUrl, // Sauvegarde l'URL du fichier au lieu du nom
        'fileName': selectedFile!.name,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Coaching ajouté avec succès!")),
      );

      _subjectController.clear();
      _priceController.clear();
      setState(() {
        selectedFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

// ✅ Fonction pour uploader le fichier vers Firebase Storage
  Future<String?> _uploadFile(PlatformFile file) async {
    try {
      if (file.path == null) {
        throw Exception("Le fichier sélectionné est invalide.");
      }

      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child(
          'coachings/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
      final uploadTask = fileRef.putFile(File(file.path!));

      await uploadTask;
      return await fileRef.getDownloadURL(); // Retourne l'URL du fichier
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'upload du fichier: $e')),
      );
      return null;
    }
  }

  Future<void> deleteCoaching(String coachingId, String fileUrl) async {
    try {
      // Delete the file from Firebase Storage
      await FirebaseStorage.instance.refFromURL(fileUrl).delete();

      // Delete the coaching document from Firestore
      await FirebaseFirestore.instance
          .collection("doctors")
          .doc(widget.doctorUid)
          .collection("coachings")
          .doc(coachingId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Coaching supprimé avec succès!")),
      );
      setState(() {}); // Refresh UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Planifier un Coaching")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: "Sujet")),
            TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickFile,
              child: Text(selectedFile != null
                  ? "Fichier sélectionné: ${selectedFile!.name}"
                  : "Choisir un fichier"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : saveCoaching,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Enregistrer le Coaching"),
            ),
            const SizedBox(height: 20),
            const Text("Coachings Planifiés",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(child: _buildCoachingList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachingList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("doctors")
          .doc(widget.doctorUid)
          .collection("coachings")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Aucun coaching planifié."));
        }

        List<QueryDocumentSnapshot> coachings = snapshot.data!.docs;

        return ListView.builder(
          itemCount: coachings.length,
          itemBuilder: (context, index) {
            var coaching = coachings[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(coaching['subject'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Prix: ${coaching['price']} DZD"),
                    Text("Fichier: ${coaching['fileName']}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      deleteCoaching(coaching.id, coaching['fileUrl']),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
