// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/screens/common/signup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity, // Ensures full width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Align center horizontally
              children: [
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bienvenue à ', style: Textstyle.bodyText),
                    Text('SoftSkills', style: Textstyle.lightBlue),
                  ],
                ),
                Text('Ton allié pour évoluer',
                    style: Textstyle.bodyText, textAlign: TextAlign.center),
                Text('Personnellement',
                    style: Textstyle.lightBlue, textAlign: TextAlign.center),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('et ', style: Textstyle.bodyText),
                    Text('Professionnellement', style: Textstyle.lightBlue),
                    Text('!', style: Textstyle.bodyText),
                  ],
                ),
                const SizedBox(height: 50),
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 50),
                Text('Ici, tu trouveras un accompagnement ',
                    style: Textstyle.bodyText, textAlign: TextAlign.center),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('personnalisé ', style: Textstyle.lightBlue),
                    Text('pour cultiver ton ', style: Textstyle.bodyText),
                  ],
                ),
                Text('bien-être mental.',
                    style: Textstyle.lightBlue, textAlign: TextAlign.center),
                Text('Avec des experts qualifiés, des',
                    style: Textstyle.bodyText, textAlign: TextAlign.center),
                Text('ressources éducatives enrichissantes,',
                    style: Textstyle.bodyText, textAlign: TextAlign.center),
                Text('et des espaces dédiés à l\'écoute ',
                    style: Textstyle.bodyText, textAlign: TextAlign.center),
                Text('et à l\'orientation.',
                    style: Textstyle.bodyText, textAlign: TextAlign.center),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: color.bgColor,
                  ),
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    style: ButtonStyle(
                      padding:
                          WidgetStateProperty.all(const EdgeInsets.all(20)),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text('Continue ...', style: Textstyle.whiteText),
                  ),
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
