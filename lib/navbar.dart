import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(String) onItemSelected;

  const BottomNavBar({super.key, required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_graph),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Create Workout',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            onItemSelected('/stats');
            break;
          case 1:
            onItemSelected('/editWorkout');
            break;
          case 2:
            onItemSelected('/settings');
            break;
        }
      },
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,

    );
  }
}

