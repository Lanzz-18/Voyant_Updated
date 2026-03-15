import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsItems = [
      "Account",
      "Notifications",
      "Appearance",
      "Privacy & Security",
      "Help & Support",
      "About"
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF3B0066),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: settingsItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              settingsItems[index],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          );
        },
      ),
    );
  }
}