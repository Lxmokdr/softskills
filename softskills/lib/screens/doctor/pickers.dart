import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/common/multiusebutton.dart';

class SpeAge extends StatefulWidget {
  const SpeAge({super.key});

  @override
  State<SpeAge> createState() => _SpeAgeState();
}

class _SpeAgeState extends State<SpeAge> {
  String age = 'add';
  String specialite = 'add';
  String? experience;
  String? uid = Auth().getCurrentUserId();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SelectableDialogButton(
          title: 'Specialite : ',
          field: 'specialite',
          options: [
            'High School',
            'Diploma',
            'Bachelor\'s Degree',
            'Postgraduate'
          ],
          onUpdate: (value) {
            setState(() {
              specialite = value;
            });
          },
          backgroundColor: color.bgColor,
          uid: uid,
        ),
        const SizedBox(width: 10),
        SelectableDialogButton(
          title: 'Age : ',
          field: 'age',
          options: ['18-25', '26-35', '36-45', '46-55', '56-65', '66+'],
          onUpdate: (value) {
            setState(() {
              age = value;
            });
          },
          backgroundColor: color.bgColor,
          uid: uid,
        ),
      ],
    );
  }
}

class experienceWid extends StatefulWidget {
  const experienceWid({super.key});

  @override
  State<experienceWid> createState() => _experienceWidState();
}

class _experienceWidState extends State<experienceWid> {
  String? experience;
  String? uid = Auth().getCurrentUserId();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: true, // Allows dismissal by tapping outside
                builder: (BuildContext context) {
                  TextEditingController experienceController =
                      TextEditingController(text: experience);
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    experience = null;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: color.bgColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle save action
                                  setState(() {
                                    experience = experienceController
                                        .text; // Update local state
                                  });
                                  // Update Firestore with the new profession
                                  updateUserField(
                                      uid: uid!,
                                      info: 'experience',
                                      value: experience);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(color: color.bgColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "experience",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: color.bgColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: experienceController,
                                maxLines: null, // Allows for multiline input
                                decoration: InputDecoration(
                                  labelText: 'experience',
                                  labelStyle: TextStyle(
                                      color: color
                                          .bgColor), // Ensure label text is bgcolor
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: color
                                            .bgColor), // Make border bgcolor
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: color
                                            .bgColor), // Make border bgcolor when focused
                                  ),
                                ),
                                style: TextStyle(
                                    color: color
                                        .bgColor), // Ensure input text is bgcolor
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(20.0),
              backgroundColor: color.bgColor,
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('experience : ', style: Textstyle.formWhite),
                    FutureBuilder<String?>(
                      future: getUserInfo(
                          uid: uid!,
                          info: 'experience'), // Call the async function
                      builder: (BuildContext context,
                          AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // While the data is loading, show a loading spinner or placeholder
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Handle error state
                          return Text('Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.red));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          // Handle case where no data is returned
                          return Text('add',
                              style: TextStyle(color: Colors.white));
                        } else {
                          // If data is available, display it
                          return Text(
                            snapshot.data!, // Safely unwrap the data
                            style: TextStyle(
                                color: Colors
                                    .white), // Adjust the color or other style properties as needed
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CVGenre extends StatefulWidget {
  const CVGenre({super.key});

  @override
  State<CVGenre> createState() => _CVGenreState();
}

class _CVGenreState extends State<CVGenre> {
  String? uid = Auth().getCurrentUserId();
  String? civil = 'add';
  String? selectedFileName;
  Future<void> pickAndUploadFile(String fieldName) async {
    if (uid == null) {
      print("UID is null. Cannot upload file.");
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        PlatformFile platformFile = result.files.first;

        setState(() {
          selectedFileName = platformFile.name;
        });

        if (kIsWeb) {
          if (platformFile.bytes != null) {
            await uploadUserFile(
              uid: uid!,
              fieldName: fieldName,
              fileBytes: platformFile.bytes!,
            );
          } else {
            print("No file bytes available for web upload.");
          }
        } else {
          if (platformFile.path != null) {
            File file = File(platformFile.path!);
            await uploadUserFile(
              uid: uid!,
              fieldName: fieldName,
              file: file,
            );
          } else {
            print("File path is null. Cannot create a File object.");
          }
        }
      } else {
        print("File selection canceled.");
      }
    } catch (e) {
      print("Error selecting or uploading file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true, // Allows dismissal by tapping outside
              builder: (BuildContext context) {
                String?
                    selectedFileName; // Variable to store the selected file name

                return StatefulBuilder(
                  // Using StatefulBuilder to update UI inside dialog
                  builder: (BuildContext context, StateSetter setState) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedFileName =
                                          null; // Reset file name
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors
                                            .blue), // Replace with `color.bgColor` if applicable
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    print('saved');
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        color: Colors
                                            .blue), // Replace with `color.bgColor` if applicable
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "CV",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => pickAndUploadFile('cv'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .blue, // Replace with `color.bgColor` if applicable
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.attach_file,
                                      color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text(
                                    selectedFileName ?? 'Upload Document',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
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
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(20.0),
            backgroundColor:
                color.bgColor, // Replace with `color.bgColor` if applicable
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('CV : ',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('Upload your CV',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SelectableDialogButton(
          title: 'Genre',
          field: 'genre',
          options: const ['Homme', 'Femme'],
          onUpdate: (value) {
            setState(() {
              civil = value;
            });
          },
          backgroundColor: color.bgColor,
          uid: uid,
        )
      ],
    );
  }
}
