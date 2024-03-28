import 'package:flutter/material.dart';
// Ensure this import is correct to access BottomNavBar
import 'navbar.dart';
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
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}
