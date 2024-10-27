import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/screens/loading.dart';
import 'package:softskills/screens/patientsignup.dart';
import 'package:softskills/screens/doctorsignup.dart';

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
          backgroundColor:  color.bgColor,
          title: Text(isSwitched ? 'Doctor Sign Up' : 'User Sign Up',style: Textstyle.whiteText,),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isSwitched ? 'Doctor' : 'Patient',
                style: const TextStyle(fontSize: 20, color: color.darkBluerColor),
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value; // Toggle between doctor and patient sign up
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
              ),
              const Text(
                'Creez votre compte et ... idk :sob:',
                style: Textstyle.darkBlue,
              ),
              const SizedBox(height: 16.0),
              // Show the appropriate sign-up page based on the switch state
              Container(
                child: isSwitched
                    ?  DoctorSignUpPage()
                    : UserSignUpPage(),
              ),
              
            ],
          ),
        ),
      );
    }
  }
}
