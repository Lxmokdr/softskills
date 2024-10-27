import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';

class doctorProfile extends StatefulWidget {
  const doctorProfile({super.key});

  @override
  State<doctorProfile> createState() => _doctorProfileState();
}

class _doctorProfileState extends State<doctorProfile> {
  String age = 'add';
  String specialite = 'add';
  String? experience = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: color.bgColor,
        title: const Text('Questionnaire : ', style: Textstyle.whiteText,),
      ),
      body:Padding(
        padding:const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Remplissez ce formulaire pour permettre a vos patients d\'en savoir plus sur vous.',
              style: Textstyle.smallerDarkBlueTexte,
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(child: Row(children: [
Expanded(
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
                                            setState(() {
                                              specialite = 'add';
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
                                      "Specialite",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: color.bgColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: const Text("High School"),
                                            onTap: () {
                                              setState(() {
                                                specialite = 'High School';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Diploma"),
                                            onTap: () {
                                              setState(() {
                                                specialite = 'Diploma';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Bachelor's Degree"),
                                            onTap: () {
                                              setState(() {
                                                specialite = 'Bachelor\'s Degree';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Postgraduate"),
                                            onTap: () {
                                              setState(() {
                                                specialite = 'Postgraduate';
                                              });
                                              Navigator.pop(context);
                                            },
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
                              const Text('Specialité : ', style: Textstyle.formWhite),
                              Text(specialite, style: Textstyle.smallerWhiteTexte),
                            ],
                          ),
                        ],
                      ),
                    )

                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true, // allows the dialog to be dismissed by tapping outside
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
                                            setState(() {
                                              age = 'add';
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
                                      "Age",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: color.bgColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: const Text("18-22"),
                                            onTap: () {
                                              setState(() {
                                                age = '18-22';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("22-25"),
                                            onTap: () {
                                              setState(() {
                                                age = '22-25';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("25-30"),
                                            onTap: () {
                                              setState(() {
                                                age = '25-30';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("30 ou plus"),
                                            onTap: () {
                                              setState(() {
                                                age = '30 ou plus';
                                              });
                                              Navigator.pop(context);
                                            },
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
                              const Text('Age : ', style: Textstyle.formWhite),
                              Text(age, style: Textstyle.smallerWhiteTexte),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),              
            ],),),
            const SizedBox(height: 10),
IntrinsicHeight(
  child: Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true, // Allows dismissal by tapping outside
              builder: (BuildContext context) {
                TextEditingController experienceController = TextEditingController(text: experience);

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
                                setState(() {
                                  experience = experienceController.text;
                                });
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              controller: experienceController,
                              maxLines: null, // Allows for multiline input
                              decoration: const InputDecoration(
                                labelText: 'experience',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
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
                  const Text('experience : ', style: Textstyle.formWhite),
                  Text(experience ?? 'add', style: Textstyle.smallerWhiteTexte),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),
           
          ],
        ),
      ),
    );
  }
}