import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
            leading: const Icon(Icons.shopping_bag, color: Color(0xFF4299E1)),
            title: const Text('Order Update'),
            subtitle: const Text('Your pattern order has been completed.'),
            trailing: const Icon(Icons.check_circle, color: Color(0xFF48BB78)),
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb, color: Color(0xFFED8936)),
            title: const Text('AI Suggestion'),
            subtitle: const Text('Try the new Fit Finder tool for better accuracy.'),
            trailing: const Icon(Icons.star, color: Color(0xFF6B73FF)),
          ),
        ],
      ),
    );
  }
}
