import 'package:flutter/material.dart';
import 'main.dart'; // Ensure this import is correct to access BottomNavBar
import 'navbar.dart';
class CreateWorkoutPage extends StatefulWidget {
  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
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
        title: Text('Create Workout'),
      ),
      body: Center(
        child: Column(
          // Align the column's children to the center of the screen
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Create your workout here'),
            SizedBox(height: 20), // Provides some spacing between the text and the button
            ElevatedButton(
              onPressed: () {
                // Navigate to the Edit Workout page when the button is pressed
                Navigator.pushNamed(context, '/editWorkout');
              },
              child: Text('Create Workout'), // Set the button text
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}
