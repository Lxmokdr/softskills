// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/loading.dart';
import 'package:softskills/screens/options.dart';

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

  @override
  Widget build(BuildContext context) {
    return loading // Check if loading to show spinner
        ? Loading() // Loading widget with spinner
        : Scaffold(
            appBar: AppBar(
              title: Text('Login'),
              backgroundColor: Colors.white,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1488cc), Color(0xff2b32b2)],
                  stops: [0, 1],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Options()),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: Textstyle.darkBlue
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
            )
          );
  }
}
