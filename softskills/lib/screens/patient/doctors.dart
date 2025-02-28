import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/screens/patient/listDoctors.dart';
import 'package:softskills/screens/common/loading.dart';

class Doctors extends StatefulWidget {
  const Doctors({Key? key}) : super(key: key);

  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  String _selectedGenreFilter = "all"; // Add this state variable

  Future<List<Map<String, dynamic>>> fetchDoctorsInfo() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      List<Map<String, dynamic>> doctorsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> doctorData = doc.data() as Map<String, dynamic>;

        List<Map<String, String>> availabilityList = [];
        if (doctorData['availability'] != null) {
          for (var avail in doctorData['availability']) {
            if (avail is Map<String, dynamic>) {
              availabilityList.add({
                'day': avail['day'] ?? '',
                'time': avail['time'] ?? '',
              });
            }
          }
        }

        return {
          'uid': doc.id,
          'name': doctorData['name'] ?? 'N/A',
          'surname': doctorData['surname'] ?? 'N/A',
          'specialite': doctorData['specialite'] ?? 'N/A',
          'genre': doctorData['genre'] ?? 'all',
          'availability': availabilityList,
          'CV': doctorData['cv'] ?? 'N/A',
        };
      }).toList();

      return doctorsList;
    } catch (e) {
      print("Error fetching doctors info: $e");
      return [];
    }
  }

  List<Map<String, dynamic>> _filterDoctorsByGenre(
      List<Map<String, dynamic>> doctors) {
    if (_selectedGenreFilter == 'all') return doctors;

    return doctors.where((doctor) {
      return doctor['genre'] == _selectedGenreFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Choisi ton docteur"),
        backgroundColor: color.bgColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Filter by Genre'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<String>(
                          title: const Text("Femmes"),
                          value: "Femme",
                          groupValue: _selectedGenreFilter,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGenreFilter = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text("Hommes"),
                          value: "Homme",
                          groupValue: _selectedGenreFilter,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGenreFilter = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text("Tous"),
                          value: "all",
                          groupValue: _selectedGenreFilter,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGenreFilter = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDoctorsInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(); // Show your custom Loading() screen here
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading doctors"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No doctors found"));
          } else {
            List<Map<String, dynamic>> filteredDoctors =
                _filterDoctorsByGenre(snapshot.data!);

            return ListView(
              children: filteredDoctors.map((doctor) {
                return DoctorButton(
                    uid: doctor['uid'],
                    name: doctor['name'],
                    surname: doctor['surname'],
                    specialite: doctor['specialite'],
                    availability:
                        List<Map<String, String>>.from(doctor['availability']),
                    cv: doctor['CV']);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
