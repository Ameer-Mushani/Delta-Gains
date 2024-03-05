import 'package:flutter/material.dart';
import 'main.dart'; // Ensure this import is correct to access BottomNavBar
import 'navbar.dart';
class EditWorkoutPage extends StatefulWidget {
  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  int _selectedIndex = 1;

  void _onNavigate(String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit workout'),
      ),
      body: Center(
        child: Text('Edit Workout'),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}
