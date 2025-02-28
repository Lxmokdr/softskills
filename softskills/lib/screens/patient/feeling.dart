import 'package:flutter/material.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/patient/journal.dart';

class FeelingButton extends StatelessWidget {
  final String feeling;
  final IconData icon;
  final Color color;

  const FeelingButton({
    super.key,
    required this.feeling,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        String? uid = Auth().getCurrentUserId();
        if (uid != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Feeling $feeling selected'),
              duration: Duration(seconds: 1), // Set duration to 1 second
            ),
          );
          //navigate to journal page
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Journal(feeling: feeling,  colour: color,)),
            );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not logged in.'),
              duration: Duration(seconds: 1), // Set duration to 1 second
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(0), // Adjust padding for the button
        backgroundColor: color.withOpacity(0.3), // Background color for the button
        elevation: 0, // Remove elevation
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color), 
          SizedBox(height: 4.0), 
          Text(
            feeling,
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: color), 
          ),
        ],
      ),
    );
  }
}
