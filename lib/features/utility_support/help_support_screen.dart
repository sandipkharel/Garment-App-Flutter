import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Help & Support',
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
            leading: const Icon(Icons.question_answer, color: Color(0xFF4299E1)),
            title: const Text('FAQs'),
            subtitle: const Text('Frequently Asked Questions'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF48BB78)),
            title: const Text('Contact Support'),
            subtitle: const Text('Email or chat with our support team'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
