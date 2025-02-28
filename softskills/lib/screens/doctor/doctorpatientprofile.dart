import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/screens/common/profilepick.dart';

class doctorPatientProfile extends StatefulWidget {
  final String uid;

  const doctorPatientProfile({super.key, required this.uid});

  @override
  State<doctorPatientProfile> createState() => _doctorPatientProfileState();
}

class _doctorPatientProfileState extends State<doctorPatientProfile> {
  List<Map<String, dynamic>> previousJournals = [];
  Map<String, bool> expandedEntries = {};
  bool isLoadingJournals = true;

  @override
  void initState() {
    super.initState();
    fetchJournals(); // Fetch journals on initialization
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      return snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return {};
    }
  }

  Future<void> fetchJournals() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('journals')
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        debugPrint('No journals found for this user.');
      } else {
        for (var doc in snapshot.docs) {
          debugPrint('Fetched Journal: ${doc.data()}'); // Debugging
        }
      }

      setState(() {
        previousJournals =
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
        isLoadingJournals = false; // ✅ Stop the loading indicator
      });
    } catch (e) {
      debugPrint('Error fetching journals: $e');
      setState(() {
        isLoadingJournals = false; // ✅ Ensure loading stops on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: color.bgColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Failed to load user data.',
                style: GoogleFonts.dancingScript(
                    fontSize: 20, color: Colors.black54),
              ),
            );
          }

          final userData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  ProfilePicture(uid: widget.uid),
                  const SizedBox(height: 16),
                  // User Information
                  ProfileDetailRow(
                      label: 'Name', value: userData['name'] ?? 'N/A'),
                  ProfileDetailRow(
                      label: 'Surname', value: userData['surname'] ?? 'N/A'),
                  ProfileDetailRow(
                      label: 'Age',
                      value: userData['age']?.toString() ?? 'N/A'),
                  ProfileDetailRow(
                      label: 'Civil Status',
                      value: userData['besoinCivil'] ?? 'N/A'),
                  ProfileDetailRow(
                      label: 'Education',
                      value: userData['education'] ?? 'N/A'),
                  ProfileDetailRow(
                      label: 'Gender', value: userData['genre'] ?? 'N/A'),
                  ProfileDetailRow(
                    label: 'Is First Time?',
                    value: (userData['isFirst'] == true) ? 'Yes' : 'No',
                  ),

                  ProfileDetailRow(
                      label: 'Phone', value: userData['phone'] ?? 'N/A'),
                  ProfileDetailRow(
                      label: 'Profession',
                      value: userData['profession'] ?? 'N/A'),

                  const SizedBox(height: 20),
                  Text(
                    "Journals",
                    style: GoogleFonts.dancingScript(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Display loading state for journals
                  if (isLoadingJournals)
                    const Center(child: CircularProgressIndicator())
                  else if (previousJournals.isEmpty)
                    const Text("No journals available.")
                  else
                    Column(
                      children: previousJournals.map((journal) {
                        String title = journal['title'] ?? 'Untitled';
                        String date =
                            journal['timestamp']?.toString() ?? 'Unknown Date';
                        String text =
                            journal['text'] ?? 'No content available.';

                        bool isPrivate =
                            (journal['isPrivate'] ?? false) as bool;

                        String privacyStatus = isPrivate ? "Privé" : "Public";

                        Color bgColor =
                            Colors.grey.withOpacity(0.4); // Default color
                        if (journal['color'] != null &&
                            journal['color'].startsWith("#")) {
                          try {
                            bgColor = Color(int.parse(
                                        journal['color'].substring(1),
                                        radix: 16) |
                                    0xFF000000)
                                .withOpacity(0.4);
                          } catch (e) {
                            debugPrint(
                                'Invalid color format: ${journal['color']}');
                          }
                        }

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
          );
        },
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
