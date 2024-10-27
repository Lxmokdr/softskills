import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key, required this.selectedIndex, required this.onItemTapped,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Doctors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Formation',
        ),
        // Add more items as needed
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue, // Customize the selected item color
      unselectedItemColor: Colors.grey, // Customize the unselected item color
      onTap: onItemTapped,
    );
  }
}
