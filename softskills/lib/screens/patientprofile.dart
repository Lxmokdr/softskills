import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String education = 'add';
  String age = 'add';
  String civil = 'add';
  String genre = 'add';
  String besoin = 'add';
  String isFirst = 'add';
  String? profession = null;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: color.bgColor,
        title: const Text('Questionnaire : ', style: Textstyle.whiteText,),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Repondez a autant de questions que possible pour nous permettre de vous apporter la meilleure aide que l\'on puisse.',
              style: Textstyle.smallerDarkBlueTexte,
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
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
                                              education = 'add';
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
                                      "Education",
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
                                                education = 'High School';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Diploma"),
                                            onTap: () {
                                              setState(() {
                                                education = 'Diploma';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Bachelor's Degree"),
                                            onTap: () {
                                              setState(() {
                                                education = 'Bachelor\'s Degree';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Postgraduate"),
                                            onTap: () {
                                              setState(() {
                                                education = 'Postgraduate';
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
                              const Text('Education : ', style: Textstyle.formWhite),
                              Text(education, style: Textstyle.smallerWhiteTexte),
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
                ],
              ),
            ),
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
                            TextEditingController professionController = TextEditingController(text: profession);

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
                                              profession = null;
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
                                              profession = professionController.text;
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
                                      "Profession",
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
                                          controller: professionController,
                                          decoration: const InputDecoration(
                                            labelText: 'Profession',
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
                              const Text('Profession : ', style: Textstyle.formWhite),
                              Text(profession ?? 'add', style: Textstyle.smallerWhiteTexte),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
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
                                              civil = 'add';
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
                                      "Etat Civil",
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
                                            title: const Text("Celibataire"),
                                            onTap: () {
                                              setState(() {
                                                civil = 'Celibataire';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Marié(e)"),
                                            onTap: () {
                                              setState(() {
                                                civil = 'Marié(e)';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Divorcé(e)"),
                                            onTap: () {
                                              setState(() {
                                                civil = 'Divorcé(e)';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Ne pas spécifier"),
                                            onTap: () {
                                              setState(() {
                                                civil = 'Ne pas spécifier';
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
                              const Text('Etat civil : ', style: Textstyle.formWhite),
                              Text(civil, style: Textstyle.smallerWhiteTexte),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                   const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true, // Allows dismissal by tapping outside
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
                                              genre = 'add';
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
                                      "Genre",
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
                                            title: const Text("Homme"),
                                            onTap: () {
                                              setState(() {
                                                genre = 'Homme';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Femme"),
                                            onTap: () {
                                              setState(() {
                                                genre = 'Femme';
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
                              const Text('Genre : ', style: Textstyle.formWhite),
                              Text(genre, style: Textstyle.smallerWhiteTexte),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true, // Allows dismissal by tapping outside
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
                                              isFirst = 'add';
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
                                      "Est-ce votre première expérience en psychologie ?",
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
                                            title: const Text("Oui"),
                                            onTap: () {
                                              setState(() {
                                                isFirst = 'Oui';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Non"),
                                            onTap: () {
                                              setState(() {
                                                isFirst = 'Non';
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Est-ce votre première expérience en psychologie ?',
                            style: Textstyle.formWhite,
                            maxLines: 2, 
                          ),
                          Text(isFirst, style: Textstyle.smallerWhiteTexte),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
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
                                              besoin = 'add';
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
                                      "Education",
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
                                            title: const Text("Developpement personnel"),
                                            onTap: () {
                                              setState(() {
                                                besoin = 'Developpement personnel';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Problèmes familliaux"),
                                            onTap: () {
                                              setState(() {
                                                besoin = 'Problèmes familliaux';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Depression"),
                                            onTap: () {
                                              setState(() {
                                                besoin = 'Depression';
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: const Text("Stress"),
                                            onTap: () {
                                              setState(() {
                                                besoin = 'Stress';
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
                              const Text('De quel genre d\'aide avez vous besoin ? ', style: Textstyle.formWhite),
                              Text(besoin, style: Textstyle.smallerWhiteTexte),
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
