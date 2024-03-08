import 'dart:ui';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Ensure this import is correct to access BottomNavBar
import 'navbar.dart';
import 'workout_provider.dart';
import 'workout.dart';
import 'exercise.dart';
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
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return Center(
            child: Column(
              // Align the column's children to the center of the screen
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20), // Provides some spacing between the text and the button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Edit Workout page when the button is pressed
                    Navigator.pushNamed(context, '/editWorkout');
                  },
                  child: Text('Create Workout'), // Set the button text
                ),
                Expanded(child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: workoutProvider.workouts.length,
                    itemBuilder: (context, i) {
                      Workout curWorkout = workoutProvider.workouts[i];
                      return ExpansionTileCard(
                        title: Text(curWorkout.name),
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: curWorkout.exercises.length,
                              itemBuilder: (context, j) {
                                Exercise curExer = curWorkout.exercises[j];
                                return Column(children: [
                                  Text("Exercise: ${curExer.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                  Text("Sets: ${curExer.sets}"),
                                  Text("Reps: ${curExer.reps}"),
                                  Text("Weight: ${curExer.weight}"),
                                  SizedBox(height: 20,)
                                ],);
                              }
                          ),
                        ],
                      );
                    }
                ) )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}
