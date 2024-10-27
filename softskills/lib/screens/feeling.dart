import 'package:flutter/material.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feeling $feeling selected')),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(8.0), // Adjust padding for the button
        backgroundColor: color.withOpacity(0.2), // Background color for the button
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
