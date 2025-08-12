import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Profile',
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
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF6B73FF),
                  child: Icon(Icons.person, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 12.0),
                const Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                const SizedBox(height: 4.0),
                const Text('johndoe@email.com', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          ListTile(
            leading: const Icon(Icons.edit, color: Color(0xFF6B73FF)),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.straighten, color: Color(0xFF4299E1)),
            title: const Text('Size Region'),
            subtitle: const Text('US'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.save, color: Color(0xFF48BB78)),
            title: const Text('Saved Measurements'),
            subtitle: const Text('View or edit your saved measurements'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFFED8936)),
            title: const Text('Order History'),
            subtitle: const Text('View your past orders'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFE53E3E)),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
