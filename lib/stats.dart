import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// Ensure this import is correct to access BottomNavBar
import 'navbar.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final int _selectedIndex = 0;

  void _onNavigate(String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Your Strength Over Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              height: 500,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: 800, // width can be adjusted based on the number of data points
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Jan';
                              case 1:
                                return 'Feb';
                              case 2:
                                return 'Mar';
                              case 3:
                                return 'Apr';
                              case 4:
                                return 'May';
                              case 5:
                                return 'Jun';
                              case 6:
                                return 'Jul';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitles: (value) {
                            return '${value.toInt()} lbs';
                          },
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 150),
                            FlSpot(1, 153),
                            FlSpot(2, 150),
                            FlSpot(3, 155),
                            FlSpot(4, 158),
                            FlSpot(5, 157),
                            FlSpot(6, 160),
                          ],
                          isCurved: true,
                          colors: [Colors.blue],
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                          ),
                          belowBarData: BarAreaData(show: false),
                        )
                      ],
                    ),
                  ),
                ),
              ),
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
