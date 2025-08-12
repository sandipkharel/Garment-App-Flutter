import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.straighten, color: Color(0xFF4299E1)),
            title: const Text('Units'),
            subtitle: const Text('Switch between cm/inches'),
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF48BB78)),
            title: const Text('Region Sizes'),
            subtitle: const Text('Select your region size chart'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6, color: Color(0xFFED8936)),
            title: const Text('Theme Mode'),
            subtitle: const Text('Light / Dark'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
