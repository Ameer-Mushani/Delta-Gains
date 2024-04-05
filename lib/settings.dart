import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'workout_provider.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final int _selectedIndex = 2;
  bool isLbs = true;

  void _onNavigate(String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {

    Future<void> saveWorkoutsToFile() async {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/workouts.json');
      final json = Provider.of<WorkoutProvider>(context, listen: false).workoutsToJson();
      await file.writeAsString(json);
      Share.shareFiles([file.path], text: 'My Workouts Export');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 75),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text('Data exported successfully!', textAlign: TextAlign.center),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [

          CheckboxListTile(
            value: isLbs,
            title: const Text("Lbs"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (newValue) {
              setState(() {
                // need exclamation for null safety see https://dart.dev/null-safety
                isLbs = newValue!;
              });
            },
          ),
          CheckboxListTile(
            value: !isLbs,
            title: const Text("Kgs"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (newValue) {
              setState(() {
                isLbs = !newValue!;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              saveWorkoutsToFile();
            },
            child: Text('Export Data to JSON'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}
