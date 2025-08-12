import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';
import 'terms_policy_screen.dart';

class UtilitySupportScreen extends StatelessWidget {
  const UtilitySupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Utility & Support',
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
          _buildSectionTitle('Settings'),
          _buildSettingsCard(context),
          const SizedBox(height: 24.0),
          _buildSectionTitle('Help & Support'),
          _buildHelpSupportCard(context),
          const SizedBox(height: 24.0),
          _buildSectionTitle('Terms & Privacy Policy'),
          _buildTermsCard(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: const Icon(Icons.settings, color: Color(0xFF6B73FF)),
        title: const Text('Preferences'),
        subtitle: const Text('Units, region sizes, theme mode'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      ),
    );
  }

  // Notifications card removed

  Widget _buildHelpSupportCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: const Icon(Icons.help_outline, color: Color(0xFF4299E1)),
        title: const Text('Help & Support'),
        subtitle: const Text('FAQs and contact support'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
          );
        },
      ),
    );
  }

  Widget _buildTermsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: const Icon(Icons.privacy_tip, color: Color(0xFF48BB78)),
        title: const Text('Terms & Privacy Policy'),
        subtitle: const Text('View app terms and privacy policy'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TermsPolicyScreen()),
          );
        },
      ),
    );
  }
}
