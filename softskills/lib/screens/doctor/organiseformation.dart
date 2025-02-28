// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:intl/intl.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/firebase/database.dart';
import 'package:softskills/screens/common/loading2.dart';
import 'package:softskills/screens/common/profilepick.dart';
import 'package:softskills/screens/doctor/listenrolledpatients.dart';

class PlanFormationScreen extends StatefulWidget {
  final String doctorUid;

  const PlanFormationScreen({required this.doctorUid, super.key});

  @override
  _PlanFormationScreenState createState() => _PlanFormationScreenState();
}

class _PlanFormationScreenState extends State<PlanFormationScreen> {
  String? uid = Auth().getCurrentUserId();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  File? _pdfFile;
  Uint8List? _pdfBytes; // For web
  DatabaseService databaseService = DatabaseService();

  String get _formattedDate {
    return _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : 'Select Date';
  }

  Future<void> _planFormation() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_selectedDate == null || _selectedTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a date and time')),
          );
          return;
        }

        // Convert TimeOfDay to a string format (e.g., "1440" for 14:40)
        String formattedTime =
            '${_selectedTime!.hour.toString().padLeft(2, '0')}${_selectedTime!.minute.toString().padLeft(2, '0')}';

        // Generate a structured formation ID
        final formationId = '${_selectedDate}_$formattedTime';

        final formationData = FirebaseFirestore.instance
            .collection('doctors')
            .doc(widget.doctorUid)
            .collection('formations')
            .doc(formationId);

        await formationData.set({
          'doctorUid': widget.doctorUid,
          'date': _selectedDate,
          'time':
              '${_selectedTime!.hour}:${_selectedTime!.minute}', // Store readable time
          'subject': _subjectController.text,
          'price': double.parse(_priceController.text),
          'pdfFile': _pdfFile != null ? await _uploadPdfFile(_pdfFile!) : null,
          'formationId': formationId, // Store it for easier retrieval
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formation planned successfully')),
        );

        // Reset the form
        _formKey.currentState!.reset();
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _pdfFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error planning formation: $e')),
        );
      }
    }
  }

  Future<String?> _uploadPdfFile(File pdfFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final pdfRef = storageRef
          .child('formations/${DateTime.now().millisecondsSinceEpoch}.pdf');
      final uploadTask = pdfRef.putFile(pdfFile);
      await uploadTask;
      final downloadUrl = await pdfRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading PDF file: $e')),
      );
      return null;
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Round to nearest 5 minutes
      int roundedMinute = (pickedTime.minute / 5).round() * 5;
      if (roundedMinute == 60) {
        // Handle overflow to next hour
        pickedTime = TimeOfDay(hour: pickedTime.hour + 1, minute: 0);
      } else {
        pickedTime = TimeOfDay(hour: pickedTime.hour, minute: roundedMinute);
      }

      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        if (kIsWeb) {
          setState(() {
            _pdfBytes = result.files.first.bytes;
          });
        } else {
          setState(() {
            _pdfFile = File(result.files.single.path!);
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF file successfully selected')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No PDF file selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting PDF file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Plan a Formation', style: Textstyle.whiteText),
        backgroundColor: color.bgColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a subject' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
              ),
              ListTile(
                title: Text('Date: $_formattedDate',
                    style: Textstyle.smallerDarkBlueText),
                trailing:
                    const Icon(Icons.calendar_today, color: color.bgColor),
                onTap: _pickDate,
              ),
              ListTile(
                title: Text(
                  _selectedTime == null
                      ? 'Select Time'
                      : 'Time: ${_selectedTime!.format(context)}',
                  style: Textstyle.smallerDarkBlueText,
                ),
                trailing: const Icon(Icons.access_time, color: color.bgColor),
                onTap: _pickTime,
              ),
              ListTile(
                title: Text(
                    _pdfFile == null && _pdfBytes == null
                        ? 'Select PDF'
                        : 'PDF Selected',
                    style: Textstyle.smallerDarkBlueText),
                trailing:
                    const Icon(Icons.picture_as_pdf, color: color.bgColor),
                onTap: _pickPDF,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _planFormation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.bgColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Plan Formation')),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 300,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: databaseService.fetchFormations(uid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Loading2();
                          } else if (snapshot.hasError ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No formations found."));
                          }
                          final formations = snapshot.data!;
                          return ListView.builder(
                            itemCount: formations.length,
                            itemBuilder: (context, index) {
                              final formation = formations[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: color.bgColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ProfilePicture(
                                              uid: formation['doctorUid']),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: FutureBuilder<List<dynamic>>(
                                              future: Future.wait([
                                                getUserInfo(
                                                    uid: formation['doctorUid'],
                                                    info: 'name'),
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
                                                  return Text(
                                                      'Doctor info not available',
                                                      style:
                                                          Textstyle.whiteText);
                                                }

                                                final name =
                                                    snapshot.data![0] ??
                                                        'Unknown';
                                                final speciality = snapshot
                                                        .data![1] ??
                                                    'Specialty not available';

                                                DateTime? dateTime;
                                                if (formation['date']
                                                    is Timestamp) {
                                                  dateTime = (formation['date']
                                                          as Timestamp)
                                                      .toDate();
                                                } else if (formation['date']
                                                    is int) {
                                                  dateTime = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          formation['date']);
                                                }

                                                String formattedDate = dateTime !=
                                                        null
                                                    ? DateFormat(
                                                            'dd MMM yyyy, hh:mm a')
                                                        .format(dateTime)
                                                    : 'N/A';

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(name,
                                                        style: Textstyle
                                                            .whiteText),
                                                    Text(speciality,
                                                        style: Textstyle
                                                            .smallerWhiteText),
                                                    Text(
                                                        'Subject: ${formation['subject'] ?? 'N/A'}',
                                                        style: Textstyle
                                                            .smallerWhiteText),
                                                    Text(formattedDate,
                                                        style: Textstyle
                                                            .smallerWhiteText),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const SizedBox(height: 10),
                                              Text(
                                                  '${formation['price'] ?? '0'} DA',
                                                  style: Textstyle
                                                      .smallerWhiteText),
                                            ],
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          print(
                                              "Button Clicked: ${formation['formationId']}");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Listenrolledpatients(
                                                formationId:
                                                    formation['formationId'],
                                                doctorUid:
                                                    formation['doctorUid'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                            "View Enrolled Patients"),
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
