import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'workout_provider.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';
import 'dart:math' as math;

double roundToNearestFive(double value) {
  return (value / 5).roundToDouble() * 5;
}
class DataPoint {
  final DateTime date;
  final double weight;

  DataPoint(this.date, this.weight);
}
class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final int _selectedIndex = 0;
  String? selectedExercise;
  List<FlSpot> spots = [];
  void _onNavigate(String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }
  List<DataPoint> filteredDataPoints = [];
  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;
    final exerciseNames = workouts
        .expand((workout) => workout.exercises)
        .map((exercise) => exercise.name)
        .toSet()
        .toList();

    double? minWeight;
    double? maxWeight;
    Map<double, String> xValueToLabelMap = {};
    if (spots.isNotEmpty) {
      minWeight = spots.map((e) => e.y).reduce(math.min);
      maxWeight = spots.map((e) => e.y).reduce(math.max);
      minWeight = roundToNearestFive((minWeight * 0.95).floorToDouble());
      maxWeight = roundToNearestFive((maxWeight * 1.025).ceilToDouble());
      xValueToLabelMap = {
        for (var spot in spots)
          spot.x: DateFormat('MM/dd').format(DateTime.fromMillisecondsSinceEpoch(spot.x.toInt())),
      };
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedExercise,
              hint: const Text("Select Exercise"),
              isExpanded: true,
              items: exerciseNames.map<DropdownMenuItem<String>>((String name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedExercise = newValue;
                  filteredDataPoints = workouts
                      .expand((workout) => workout.exercises)
                      .where((exercise) => exercise.name == newValue)
                      .map((exercise) => DataPoint(exercise.date, exercise.weight))
                      .toList();
                  filteredDataPoints.sort((a, b) => a.date.compareTo(b.date));
                  spots = List.generate(filteredDataPoints.length, (index) {
                    return FlSpot(index.toDouble(), filteredDataPoints[index].weight);
                  });
                });
              },


            ),
            SizedBox(height: 20),
            Expanded(
              child: spots.isNotEmpty
                  ? LineChart(
                LineChartData(
                  minY: (minWeight),
                  maxY: (maxWeight),

                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles( // x axis
                      showTitles: true,
                      rotateAngle: 45,
                      getTitles: (value) {
                        final index = value.toInt();
                        if (index >= 0 && index < filteredDataPoints.length) {
                          return DateFormat('MM/dd').format(filteredDataPoints[index].date);
                        }
                        return '';
                      },
                    ),
                    leftTitles: SideTitles( // y axis
                      showTitles: true,
                      interval: 5,
                      getTitles: (value) => '${value.toInt()} lbs',
                      reservedSize: 45,
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.white,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final textStyle = TextStyle(
                            color: Colors.purple, // Text color for the tooltip
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          return LineTooltipItem(
                            '${touchedSpot.y} lbs',
                            textStyle,
                          );
                        }).toList();
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      colors: [Theme.of(context).primaryColor],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              )
                  : Center(child: Text('No data available')),
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
