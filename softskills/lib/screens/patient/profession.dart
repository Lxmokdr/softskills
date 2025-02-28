import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';

class profession extends StatefulWidget {
  const profession({super.key});

  @override
  State<profession> createState() => _professionState();
}

class _professionState extends State<profession> {
  String? profession;
  String? uid = Auth().getCurrentUserId();
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
              child: ElevatedButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  TextEditingController professionController =
                      TextEditingController(text: profession);

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
                                  // Handle cancel action
                                  setState(() {
                                    profession = null; // Reset profession
                                  });
                                  // No need to update Firestore on cancel
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
                                    profession = professionController
                                        .text; // Update local state
                                  });
                                  // Update Firestore with the new profession
                                  updateUserField(
                                      uid: uid!,
                                      info: 'profession',
                                      value: profession);
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
                            "Profession",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: color.bgColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: professionController,
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
                    Text('Profession : ', style: Textstyle.formWhite),
                    FutureBuilder<String?>(
                      future: getUserInfo(
                          uid: uid!,
                          info: 'profession'), // Call the async function
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
          )),
        ],
      ),
    );
  }
}
