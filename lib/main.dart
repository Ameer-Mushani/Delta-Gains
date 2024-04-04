import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'settings.dart';
import 'create_workout.dart';
import 'stats.dart';
import 'navbar.dart';
import 'edit_workout.dart';
import 'workout_provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) {
      final provider = WorkoutProvider();
      provider.loadWorkouts();
      return provider;
    },
    child: const MyApp(),
  ),
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delta Gains',
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/createWorkout': (context) => const CreateWorkoutPage(),
        '/editWorkout': (context) => const EditWorkoutPage(),
        '/settings': (context) => const SettingsPage(),
        '/stats': (context) => const StatsPage(),
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final int _selectedIndex = 1;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onNavigate(String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Δ Delta Gains')),
      ),
      body: Center(
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime(2100, 12, 31),
                focusedDay: DateTime.now(),
                headerStyle: const HeaderStyle(
                  titleCentered: true
                ),
                calendarFormat: _calendarFormat,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay; // update `_focusedDay` here as well
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              TextButton(onPressed: () => {
                showDialog(context: context, builder: (BuildContext context) {
                  return  AlertDialog(
                    title: const Text("Feature coming soon!"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: ()  {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"))
                    ],
                  );
                })
              }, child: const Text("Export to CSV"),
              ),

              Expanded(
                child: Consumer<WorkoutProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: provider.workouts.length,
                      itemBuilder: (context, index) {
                        final workout = provider.workouts[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            title: Text(workout.name),
                            subtitle: Text('Date: ${workout.date.toIso8601String().split('T').first}'),
                            children: workout.exercises.map((exercise) {
                              return ListTile(
                                title: Text(exercise.name),
                                subtitle: Text('Sets: ${exercise.sets}, Reps: ${exercise.reps}, Weight: ${exercise.weight}'),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            ],

          )

      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}


