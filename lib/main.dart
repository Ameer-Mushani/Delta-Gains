import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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
                    title: Text("Feature coming soon!"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: ()  {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"))
                    ],
                  );
                })
              }, child: Text("Export to CSV"),)
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


