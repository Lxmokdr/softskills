import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart'; // Ensure color.bgColor is defined here
import 'package:softskills/classes/textstyle.dart'; // Ensure Textstyle.formWhite is defined here
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/doctor/coachingDoctor.dart';
import 'package:softskills/screens/doctor/list_patients.dart';
import 'package:softskills/screens/doctor/organiseformation.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  final Auth _auth = Auth();
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = _auth.getCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/bg.png'), // Replace with your actual image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListPatients()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 40.0, horizontal: 80.0),
                    backgroundColor: color.bgColor,
                    elevation: 0,
                  ),
                  child: Text(
                    'Liste de rendez-vous',
                    style: Textstyle.formWhite,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (uid != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlanFormationScreen(doctorUid: uid!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error: User not found')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 40.0, horizontal: 70.0),
                    backgroundColor: color.bgColor,
                    elevation: 0,
                  ),
                  child: Text(
                    'Organiser une formation',
                    style: Textstyle.formWhite,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorCoachingScreen(
                                doctorUid: uid!,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 40.0, horizontal: 80.0),
                    backgroundColor: color.bgColor,
                    elevation: 0,
                  ),
                  child: Text(
                    'Organiser un coaching',
                    style: Textstyle.formWhite,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
