import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/doctor/doctorHome.dart';
import 'package:softskills/screens/common/loading.dart';
import 'package:softskills/screens/patient/options.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final Auth _auth = Auth();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  String code = '';
  
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Login'),
              backgroundColor: Colors.white,
              foregroundColor: color.bgColor,
            ),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: color.bgColor,
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                              onSaved: (value) {
                                email = value!;
                              },
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
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
                            SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              obscureText: true,
                              style: TextStyle(color: Colors.white),
                              onSaved: (value) {
                                password = value!;
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
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
                            SizedBox(height: 24.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Code de vérification (médecins)',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              obscureText: true,
                              style: TextStyle(color: Colors.white),
                              onSaved: (value) {
                                code = value ?? ''; // Optional
                              },
                              onChanged: (val) {
                                setState(() {
                                  code = val;
                                });
                              },
                            ),
                            SizedBox(height: 24.0),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    dynamic result = await _auth.logInWithEmailAndPassword(email, password);
                                    
                                    if (result == null) {
                                      setState(() {
                                        error = 'Could not log in with these credentials';
                                        loading = false;
                                      });
                                    } else {
                                      User? user = FirebaseAuth.instance.currentUser;
                                      await user?.reload();
                                      
                                      if (user != null && !user.emailVerified) {
                                        setState(() {
                                          error = 'Your email is not verified. Please verify it before logging in.';
                                          loading = false;
                                        });
                                        try {
                                          await user.sendEmailVerification();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Verification email sent! Please check your inbox.')),
                                          );
                                        } catch (e) {
                                          print('Error sending verification email: $e');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Failed to send verification email. Please try again later.')),
                                          );
                                        }
                                      } else {
                                        // Check user role from Firestore
                                        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
                                        
                                        if (userDoc.exists) {
                                          String role = userDoc.get('role');
                                          setState(() => loading = false);
                                          
                                          // Navigate based on the role
                                          if (role == 'doctor') {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => const DoctorHome()),
                                            );
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => const Options()),
                                            );
                                          }
                                        } else {
                                          setState(() {
                                            error = 'User role not found.';
                                            loading = false;
                                          });
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                  'Login',
                                  style: Textstyle.darkBlue,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Center(
                              child: Text(
                                error,
                                style: TextStyle(color: Colors.red, fontSize: 14.0),
                              ),
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
