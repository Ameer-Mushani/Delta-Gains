import 'package:flutter/material.dart';
import 'exercise.dart';
import 'dart:math' as math;

class WeightSelector extends StatefulWidget {
  final Exercise exercise;

  WeightSelector({required this.exercise});

  @override
  _WeightSelectorState createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  void addWeight(double weight) {
    setState(() {
      widget.exercise.weight += weight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Total Weight: ${widget.exercise.weight} lbs', style: TextStyle(fontSize: 25)),
        Wrap(
          spacing: 8.0,
          children: <Widget>[
            HexagonButton(size: 110.0, weight: 45.0, onPressed: () => addWeight(45.0), label: '45 lbs'),
            HexagonButton(size: 110.0, weight: 35.0, onPressed: () => addWeight(35.0), label: '35 lbs'),
            HexagonButton(size: 110.0, weight: 25.0, onPressed: () => addWeight(25.0), label: '25 lbs'),
            HexagonButton(size: 110.0, weight: 10.0, onPressed: () => addWeight(10.0), label: '10 lbs'),
            HexagonButton(size: 110.0, weight: 5.0, onPressed: () => addWeight(5.0), label: '5 lbs'),
            HexagonButton(size: 110.0, weight: 2.5, onPressed: () => addWeight(2.5), label: '2.5 lbs'),
          ],
        ),
      ],
    );
  }
}

class HexagonButton extends StatelessWidget {
  final double size;
  final double weight;
  final VoidCallback onPressed;
  final String label;

  HexagonButton({
    required this.size,
    required this.weight,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        child: CustomPaint(
          painter: OctagonPainter(),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: size * 0.22), // Adjust font size based on button size
            ),
          ),
        ),
      ),
    );
  }
}


class OctagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Center of the canvas
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // The distance from the center to a vertex.
    final radius = size.width / 2;
    final angle = (math.pi * 2) / 8; // Angle between vertices

    final path = Path();

    // Generate points for each vertex of the octagon
    final points = List.generate(8, (i) {
      final x = centerX + radius * math.cos(angle * i - math.pi / 8);
      final y = centerY + radius * math.sin(angle * i - math.pi / 8);
      return Offset(x, y);
    });

    // Move to the first point
    path.moveTo(points[0].dx, points[0].dy);

    // Draw lines to each of the other points
    for (var point in points) {
      path.lineTo(point.dx, point.dy);
    }

    path.close(); // Close the path to form a shape

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


