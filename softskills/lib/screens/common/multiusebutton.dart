import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';

class SelectableDialogButton extends StatelessWidget {
  final String title;
  final String field;
  final List<String> options;
  final String? uid;
  final Function(String value) onUpdate;
  final Color backgroundColor;

  const SelectableDialogButton({
    Key? key,
    required this.title,
    required this.field,
    required this.options,
    required this.onUpdate,
    required this.backgroundColor,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: color.bgColor),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
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
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: options.map((option) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(option),
                                  onTap: () async {
                                    onUpdate(option);
                                    if (uid != null) {
                                      // Call the existing Firestore function to update user field
                                      await updateUserField(uid: uid!, info: field, value: option);
                                    } else {
                                      print("User ID is null");
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                                const Divider(),
                              ],
                            );
                          }).toList(),
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
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        child: Align(
          alignment: Alignment.centerLeft,  // Align content to the left
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('$title ', style: Textstyle.formWhite),
              FutureBuilder<String?>(
                future: getUserInfo(uid: uid ?? '', info: field), // Call the existing Firestore function
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('add', style: TextStyle(color: Colors.white));
                  } else {
                    return Text(
                      snapshot.data!,
                      style: Textstyle.smallerWhiteText,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
