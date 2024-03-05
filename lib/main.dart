import 'package:flutter/material.dart';
import 'settings.dart';
import 'create_workout.dart';
import 'stats.dart';
import 'navbar.dart';
import 'edit_workout.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delta Gains',
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/createWorkout': (context) => CreateWorkoutPage(),
        '/editWorkout': (context) => EditWorkoutPage(),
        '/settings': (context) => SettingsPage(),
        '/stats': (context) => StatsPage(),
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
        title: Text('Workout App'),
      ),
      body: Center(
        child: Text('LETS MAKE SOME DELTA GAINS!'),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}


