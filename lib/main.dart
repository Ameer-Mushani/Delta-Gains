import 'package:delta_gains/workout.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'settings.dart';
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
      // routes: {
      //   '/': (context) => const LandingPage(),
      //   '/editWorkout': (context) => const EditWorkoutPage(),
      //   '/settings': (context) => const SettingsPage(),
      //   '/stats': (context) => const StatsPage(),
      // },
      onGenerateRoute: (settings) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        if (settings.name == "/editWorkout") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => EditWorkoutPage(),
              transitionsBuilder: (_, a, __, c) {
                final offsetAnimation = a.drive(tween);
                return SlideTransition(position: offsetAnimation, child: c);
              },
              transitionDuration: const Duration(milliseconds: 500)
          );
        }
        if (settings.name == "/stats") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => StatsPage(),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)
          );
        }
        if (settings.name == "/") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => LandingPage(),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)
          );
        }
        if (settings.name == "/settings") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => SettingsPage(),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)
          );
        }
        return MaterialPageRoute(builder: (_) => const LandingPage());
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
  DateTime? _selectedDay = DateTime.now();
  Map<DateTime, List<UniqueKey>> _events = {};
  List<Workout> workouts = [];
  List<Workout> selectedDaysWorkouts = [];

  @override
  void initState() {
    super.initState();
    _events = {};
  }

  // get workouts to load calendar events
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    workouts = Provider.of<WorkoutProvider>(context, listen: true).workouts;
    updateEvents();
    updateSelectedDayWorkouts();
  }

  // update calendar events based on workouts
  //caled from didChangeDependencies()
  void updateEvents() {
    _events = {};
    for (final workout in workouts) {
      final dateKey = DateUtils.dateOnly(workout.date);
      //only add workout if key is not already in events map
      if (!_events.containsValue(workout.key)) {
        if (_events.containsKey(dateKey)) {
          _events[dateKey]!.add(workout.key);
        } else {
          _events[dateKey] = [workout.key];
        }
      }
    }
  }

  //calendar method
  List<UniqueKey> _getEventsForDay(DateTime day) {
    final dayOnly = DateUtils.dateOnly(day);
    return _events[dayOnly] ?? <UniqueKey>[];
  }

  updateSelectedDayWorkouts(){
    selectedDaysWorkouts = [];
    for (final workout in workouts) {
      if (DateUtils.dateOnly(workout.date) ==
          DateUtils.dateOnly(_selectedDay!)) {
        selectedDaysWorkouts.add(workout);
      }
    }
  }

  void _onNavigate(String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }
  String _getFormattedDate(DateTime dateTime) {
    return '${_getMonthName(dateTime.month)} ${dateTime.day}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
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
                focusedDay: _focusedDay,
                eventLoader: _getEventsForDay,
                headerStyle: const HeaderStyle(titleCentered: true),
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
                  updateSelectedDayWorkouts();
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
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text("Workouts: ${_getFormattedDate(_selectedDay!)}", style: TextStyle(fontSize: 25),),
                  )
              ),
              Expanded(
                child: Consumer<WorkoutProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: selectedDaysWorkouts.length,
                      itemBuilder: (context, index) {
                        final workout = selectedDaysWorkouts[index];
                        return Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ExpansionTileCard(
                                expandedColor: Theme.of(context).colorScheme.secondaryContainer,
                                baseColor: Theme.of(context).colorScheme.secondaryContainer,
                                title: Text(workout.name),
                                subtitle: Text(
                                    'Date: ${workout.date.toIso8601String().split('T').first}'),
                                children: workout.exercises.map((exercise) {
                                  return ListTile(
                                    title: Text(exercise.name),
                                    subtitle: Text(
                                        'Sets: ${exercise.sets}, Reps: ${exercise.reps}, Weight: ${exercise.weight}'),
                                  );
                                }).toList()
                            )
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}
