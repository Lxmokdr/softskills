import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/screens/common/loading.dart';
import 'package:softskills/screens/patient/patientsignup.dart';
import 'package:softskills/screens/doctor/doctorsignup.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isSwitched = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: color.bgColor,
            foregroundColor: Colors.white,
            title: Text(
              isSwitched ? 'Doctor Sign Up' : 'User Sign Up',
              style: Textstyle.whiteText,
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSwitched ? 'Doctor' : 'Patient',
                    style: const TextStyle(
                        fontSize: 20, color: color.darkBluerColor),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched =
                            value; // Toggle between doctor and patient sign up
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: color.bgColor,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.black38,
                  ),
                  Text(
                    isSwitched
                        ? 'Voulez vous aider à améliorer des vies ?'
                        : 'Voulez vous améliorer votre bien etre ?',
                    style: Textstyle.darkBlue,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Creez votre compte et ... idk :sob:',
                    style: Textstyle.darkBlue,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  // Show the appropriate sign-up page based on the switch state
                  Container(
                    child: isSwitched ? DoctorSignUpPage() : UserSignUpPage(),
                  ),
                ],
              ),
            ),
          ));
    }
  }
}
