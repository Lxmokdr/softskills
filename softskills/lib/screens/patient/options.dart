import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/patient/bookings.dart';
import 'package:softskills/screens/patient/coachingpatient.dart';
import 'package:softskills/screens/patient/doctors.dart';
import 'package:softskills/screens/patient/feeling.dart';
import 'package:softskills/screens/patient/formations.dart';

Stream<DocumentSnapshot> getUserInfoStream(String uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
}

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  final List<Map<String, dynamic>> feelings = const [
    {
      'feeling': 'Happy',
      'icon': Icons.sentiment_very_satisfied,
      'color': Color(0xFFFFD700)
    }, // Golden Yellow
    {
      'feeling': 'Sad',
      'icon': Icons.sentiment_dissatisfied,
      'color': Color(0xFF5D9BD1)
    }, // Soft Blue
    {
      'feeling': 'Angry',
      'icon': Icons.sentiment_very_dissatisfied,
      'color': Color(0xFFE57373)
    }, // Muted Red
    {
      'feeling': 'Anxious',
      'icon': Icons.sentiment_neutral,
      'color': Color(0xFFFFA07A)
    }, // Light Salmon
    {
      'feeling': 'Calm',
      'icon': Icons.self_improvement,
      'color': Color(0xFF8FBC8F)
    }, // Sage Green
    {
      'feeling': 'Excited',
      'icon': Icons.celebration,
      'color': Color(0xFF9370DB)
    }, // Lavender Purple
  ];

  final Auth _auth = Auth();
  String? uid;
  String? name;

  @override
  void initState() {
    super.initState();
    uid = _auth.getCurrentUserId();
  }

  void fetchUserName() async {
    String? fetchedName = await getUserInfo(uid: uid!, info: 'name');
    setState(() {
      name = fetchedName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image layer
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Main content layer
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: getUserInfoStream(
                                uid!), // Stream for real-time updates
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('Chargement...',
                                    style: Textstyle.darkBlue);
                              }
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Text('Utilisateur inconnu',
                                    style: Textstyle.darkBlue);
                              }
                              String userName =
                                  snapshot.data!.get('name') ?? 'Utilisateur';
                              return Text('Bonjour, $userName',
                                  style: Textstyle.darkBlue);
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Comment vous sentez vous aujourd\'hui?',
                            style: Textstyle.smallerDarkBlueText,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: color.bgColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1,
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
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Comment pouvons-nous vous aider?',
                        style: Textstyle.smallerDarkBlueText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        CustomButton(
                          text: 'Besoin d\'une consultation psychologique ?',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Doctors()),
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: 'Besoin d\'un coaching personnalisé ?',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PatientCoachingListScreen()),
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: 'Besoin de formations spécialisées ?',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Formation()),
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: 'Toutes mes réservations futures.....',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Bookings()),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Custom Button Widget for reusability
  Widget CustomButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        backgroundColor: color.bgColor,
        elevation: 0,
      ),
      child:
          Text(text, style: Textstyle.formBeige, textAlign: TextAlign.center),
    );
  }
}
