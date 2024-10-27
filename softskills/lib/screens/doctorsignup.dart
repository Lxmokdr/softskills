// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/login.dart';

class DoctorSignUpPage extends StatefulWidget {

  @override
  _DoctorSignUpPageState createState() => _DoctorSignUpPageState();
}

class _DoctorSignUpPageState extends State<DoctorSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final Auth _auth = Auth();

  String name = '';
  String surname = '';
  String email = '';
  String password = '';
  String error = '';
  String gender = '';

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24.0),
    child: Container(
      decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(30), 
                // gradient: const LinearGradient(
                //   colors: [Color(0xff1488cc), Color(0xff2b32b2)],
                //   stops: [0, 1],
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                // ),
                color: color.bgColor
              ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: Colors.white), // White label text
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when focused
                  ),
                ),
                style: const TextStyle(color: Colors.white), // White input text
                onSaved: (value) {
                  name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre Nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Prenom',
                  labelStyle: TextStyle(color: Colors.white), // White label text
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when focused
                  ),
                ),
                style: const TextStyle(color: Colors.white), // White input text
                onSaved: (value) {
                  surname = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre prenom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Phone Number input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                onSaved: (value) {
                  // Save the phone number value here if needed
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!RegExp(r'^\+?1?\d{9,15}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Code',
                  labelStyle: TextStyle(color: Colors.white), // White label text
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when focused
                  ),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white), // White input text
                onSaved: (value) {
                  password = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre Code';
                  } else if (value.length < 6) {
                    return 'Le Code doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white), // White label text
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when focused
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white), // White input text
                onSaved: (value) {
                  email = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre email';
                  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Entrez un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(color: Colors.white), // White label text
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // White border when focused
                  ),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white), // White input text
                onSaved: (value) {
                  password = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre mot de passe';
                  } else if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              // Sign Up button
              Center(
                child: Column(
                  children: [
                   ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          

                          dynamic result = await _auth.signUpWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Please supply a valid email';
                            });
                          } else {
                            // Handle success
                            await _auth.sendEmailVerificationLink();
                            
                          }
                        }
                      },
                  child: const Text(
                    'S\'inscrire',
                    style:  Textstyle.darkBlue
                  ),
                ),
                Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                const SizedBox(height: 16.0),
                const Text('Vous avez deja un compte ?',
                    style: Textstyle.smallerWhiteTexte,),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Se connecter',
                        style: Textstyle.darkBlue
                      ),
                    ),
                  ],
                ),
                
              ),
                    // Text('s\'inscrire avec : ' , 
                    // style: Textstyle.smallerWhiteTexte,),
                    // Center(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       IconButton(
                    //         icon: Container(
                    //           width: 50, // Set a fixed width
                    //           height: 50, // Set a fixed height
                    //           padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    //           decoration: BoxDecoration(
                    //             color: color.darkBluerColor, // Background color
                    //             border: Border.all(
                    //               color: Colors.black, // Border color
                    //               width: 5, // Border width
                    //             ),
                    //             borderRadius: BorderRadius.circular(30), // Border radius
                    //           ),
                    //           child: Image.asset(
                    //             'assets/google.png',
                    //             width: 24,
                    //             height: 24,
                    //           ),
                    //         ),
                    //         onPressed: () async {
                    //           // Call your sign in with Google method
                    //           await Auth().signInWithGoogle();
                    //         },
                    //       ),


                    //       SizedBox(height: 16.0),
                    //       IconButton(
                    //         icon: Container(
                    //           width: 50,  // Set a fixed width
                    //           height: 50, // Set a fixed height
                    //           padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    //           decoration: BoxDecoration(
                    //             color: color.darkBluerColor, // Background color
                    //             border: Border.all(
                    //               color: Colors.black, // Border color
                    //               width: 5,           // Border width
                    //             ),
                    //             borderRadius: BorderRadius.circular(30), // Border radius
                    //           ),
                    //           child: Image.asset(
                    //             'assets/apple.png',
                    //             width: 24,
                    //             height: 24,
                    //           ),
                    //         ),
                    //         onPressed: () {

                    //         },
                    //       ),
                    //       SizedBox(height: 16.0),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
          ),
        )
      );
  }
}
