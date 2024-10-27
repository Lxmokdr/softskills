// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/screens/signup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 4, 36, 5),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //   colors: [Color(0xff091e3a), Color(0xff2f80ed), Color(0xff2d9ee0)],
        //   stops: [0, 0.5, 1],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // )
        // ),
        child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenue à ',
                    style: Textstyle.bodyText,
                  ),
                  Text(
                    'SoftSkills',
                    style: Textstyle.lightBlue,
                  )
                ],
              ),
              const Text(
                'Ton allié pour évoluer',
                style: Textstyle.bodyText,
              ),
              const Text(
                'Personnellement',
                style: Textstyle.lightBlue,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'et ',
                    style: Textstyle.bodyText,
                  ),
                  Text(
                    'Professionnellement',
                    style: Textstyle.lightBlue,
                  ),
                  Text(
                    '!',
                    style: Textstyle.bodyText,
                  )
                ],
              ),
              const SizedBox(height: 50),
              Image.asset(
                'assets/logo.png',
                height: 150,
              ),
              const SizedBox(height: 50),
              const Text(
                'Ici, tu trouveras un accompagnement ',
                style: Textstyle.bodyText,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'personnalisé ',
                    style: Textstyle.lightBlue,
                  ),
                  Text(
                    'pour cultiver ton ',
                    style: Textstyle.bodyText,
                  ),
                  
                ],
                
              ),
              Text(
                    'bien-être mental.',
                    style: Textstyle.lightBlue,
                  ),
              const Text(
                'Avec des experts qualifiés, des',
                style: Textstyle.bodyText,
              ),
              const Text(
                'ressources éducatives enrichissantes,',
                style: Textstyle.bodyText,
              ),
              const Text(
                'et des espaces dédiés à l\'écoute ',
                style: Textstyle.bodyText,
              ),
              const Text(
                'et à l\'orientation.',
                style: Textstyle.bodyText,
              ),
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  // gradient: LinearGradient(
                  //   colors: [Color(0xff2b5876), Color(0xff4e4376)],
                  //   stops: [0, 1],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // )
                  color: color.bgColor
                
                
                ),
                child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  SignUpPage()),
                  );
                },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  backgroundColor: WidgetStateProperty.all( Colors.transparent),
                ),
                child: const Text(
                  'Continue ...',
                  style: Textstyle.whiteText,
                ),
              ),
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
      )
    );
  }
}
