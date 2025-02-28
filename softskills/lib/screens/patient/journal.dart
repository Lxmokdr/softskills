import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/firebase/auth.dart';

// ignore: must_be_immutable
class Journal extends StatefulWidget {
  String feeling;
  Color colour;
  Journal({super.key, required this.feeling, required this.colour});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  final Auth _auth = Auth();
  String? uid;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _journalController = TextEditingController();
  bool isSaving = false;
  List<Map<String, dynamic>> previousJournals = [];
  Map<String, bool> expandedEntries = {};

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    uid = _auth.getCurrentUserId();
    await fetchJournals();
  }

  Future<void> _saveJournal(String title, String text, bool isPrivate) async {
    if (uid == null || text.isEmpty || title.isEmpty) return;

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('journals')
          .add({
        'title': title,
        'text': text,
        'isPrivate': isPrivate,
        'color': '#${widget.colour.value.toRadixString(16).padLeft(8, '0')}',
        'feeling': widget.feeling,
        'timestamp': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isPrivate
              ? 'Journal saved privately!'
              : 'Journal saved publicly!'),
        ),
      );

      _titleController.clear();
      _journalController.clear();
      await fetchJournals();
    } catch (e) {
      debugPrint('Error saving journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save journal.'),
        ),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Future<void> fetchJournals() async {
    if (uid == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('journals')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        previousJournals =
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      });
    } catch (e) {
      debugPrint('Error fetching journals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      backgroundColor: color.bgColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: color.bgColor,
        title: Text(
          'Journal Intime',
          style: GoogleFonts.dancingScript(fontSize: 28, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                style: GoogleFonts.dancingScript(
                    fontSize: 22, color: color.bgColor),
                decoration: InputDecoration(
                  labelText: 'Titre',
                  labelStyle: GoogleFonts.dancingScript(
                      fontSize: 22, color: color.bgColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 179, 176, 176),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _journalController,
                maxLines: 8,
                style: GoogleFonts.dancingScript(
                    fontSize: 20, color: color.bgColor),
                decoration: InputDecoration(
                  labelText: 'Exprime tes pensées...',
                  labelStyle: GoogleFonts.dancingScript(
                      fontSize: 22, color: color.bgColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 179, 176, 176),
                ),
              ),
              const SizedBox(height: 20),

              if (isSaving)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 179, 176, 176),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _saveJournal(
                          _titleController.text,
                          _journalController.text,
                          true,
                        ),
                        child: Text(
                          'Privé',
                          style: GoogleFonts.dancingScript(
                            fontSize: 18,
                            color: color.bgColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 179, 176, 176),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _saveJournal(
                          _titleController.text,
                          _journalController.text,
                          false,
                        ),
                        child: Text(
                          'Public',
                          style: GoogleFonts.dancingScript(
                            fontSize: 18,
                            color: color.bgColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),

              // Display Previous Journals
              Column(
                children: previousJournals.map((journal) {
                  String title = journal['title'] ?? 'Sans titre';
                  String date = journal['timestamp'].split('T')[0];
                  String text = journal['text'] ?? '';
                  bool isPrivate = journal['isPrivate'] ?? true;
                  String privacyStatus = isPrivate ? "Privé" : "Public";

                  Color bgColor = Color(
                    int.parse(journal['color'].substring(1), radix: 16) |
                        0xFF000000,
                  ).withOpacity(0.4);

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgColor.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              expandedEntries[title] =
                                  !(expandedEntries[title] ?? false);
                            });
                          },
                          child: Text(
                            '$title - $date [$privacyStatus]',
                            style: GoogleFonts.dancingScript(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (expandedEntries[title] ?? false)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            text,
                            style: GoogleFonts.dancingScript(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
