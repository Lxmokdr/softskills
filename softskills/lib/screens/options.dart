// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/screens/bottomnavbar.dart';
import 'package:softskills/screens/doctors.dart';
import 'package:softskills/screens/feeling.dart';
import 'package:softskills/screens/formations.dart';
import 'package:softskills/screens/sideMenu.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  // List of feelings with associated icons and colors
  final List<Map<String, dynamic>> feelings = const [
    {'feeling': 'Happy', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.yellow},
    {'feeling': 'Sad', 'icon': Icons.sentiment_dissatisfied, 'color': Colors.blue},
    {'feeling': 'Angry', 'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.red},
    {'feeling': 'Anxious', 'icon': Icons.sentiment_neutral, 'color': Colors.orange},
    {'feeling': 'Calm', 'icon': Icons.self_improvement, 'color': Colors.green},
    {'feeling': 'Excited', 'icon': Icons.celebration, 'color': Colors.purple},
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: color.bgColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, // Set height to fill the screen
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Color(0xff091e3a), Color(0xff2f80ed), Color(0xff2d9ee0)],
        //     stops: [0, 0.5, 1],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('Welcome Lxmix', style: Textstyle.darkBlue),
              SizedBox(height: 10),
              Text('How are you feeling today?', style: Textstyle.smallerDarkBlueTexte),
              SizedBox(height: 10),
              // Feelings grid layout
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: color.bgColor, // Background color for the feelings container
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, // Show 3 feelings per row
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1, // Make cards square-shaped
                  ),
                  itemCount: feelings.length,
                  itemBuilder: (context, index) {
                    return FeelingButton(
                      feeling: feelings[index]['feeling'],
                      icon: feelings[index]['icon'],
                      color: feelings[index]['color'],
                    );
                  },
                ),
              ),
              ),
              SizedBox(height: 30),
              Text('How can we help you today?', style: Textstyle.smallerDarkBlueTexte),
              SizedBox(height: 10),
              // Other options
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Doctors()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Set lower border radius
                          ),
                          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0),
                          backgroundColor: color.bgColor,
                          elevation: 0, // Remove elevation if you want a flat appearance
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Besoin d\'une consultation psychologique ?',
                              style: Textstyle.smallerWhiteTexte,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to coaching screen if available
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Set lower border radius
                          ),
                          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 50.0),
                          backgroundColor: color.bgColor,
                          elevation: 0, // Remove elevation if you want a flat appearance
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Besoin d\'un coaching personnalisé ?',
                              style: Textstyle.smallerWhiteTexte,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Formation()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Set lower border radius
                          ),
                          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 50.0),
                          backgroundColor: color.bgColor,
                          elevation: 0, // Remove elevation if you want a flat appearance
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Besoin de formations spécialisées ?',
                              style: Textstyle.smallerWhiteTexte,
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
      ),
    );
  }
}

// FeelingButton component to display each feeling as an ElevatedButton
