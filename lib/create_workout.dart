import 'package:flutter/material.dart';

class CreateWorkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Workout'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Bruh'),
            onTap: () {
              // Handle the tap, possibly navigate to the Account settings page
            },
          ),
        ],
      ),
    );
  }
}
