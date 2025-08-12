import 'package:flutter/material.dart';
import '../orders/order_review_screen.dart';
import '../orders/order_history_screen.dart';
import '../utility_support/utility_support_screen.dart';
import '../auth/profile_screen.dart';
import '../utility_support/notifications_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'AI Garment App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6A82FB),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'utility_support') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UtilitySupportScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'utility_support',
                child: Text('Utility & Support'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Ready to create your perfect garment?',
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            // What Would You Like To Do?
            const Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16.0),
            // Feature Cards (Gradient Backgrounds)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.1,
              children: [
                _buildFeatureCard(
                  context,
                  'Measure Garment',
                  Icons.straighten,
                  const Color(0xFF6A82FB),
                  () {
                    Navigator.pushNamed(context, '/garment-measurement');
                  },
                ),
                _buildFeatureCard(
                  context,
                  'Recognize Garment',
                  Icons.camera_alt,
                  const Color(0xFFFC5C7D),
                  () {
                    Navigator.pushNamed(context, '/garment-recognition');
                  },
                ),
                _buildFeatureCard(
                  context,
                  'AI Chatbot',
                  Icons.chat_bubble,
                  const Color(0xFF8B5CF6),
                  () {
                    Navigator.pushNamed(context, '/chatbot');
                  },
                ),
                _buildFeatureCard(
                  context,
                  'Pattern Adjust',
                  Icons.tune,
                  const Color(0xFFE53E3E),
                  () {
                    Navigator.pushNamed(context, '/pattern-adjustment');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16.0),
            _buildQuickActionCard(
              context,
              'Orders & Payment',
              'Review your orders and proceed to payment',
              Icons.shopping_bag,
              const Color(0xFF6A82FB),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderReviewScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            _buildQuickActionCard(
              context,
              'Order History',
              'List of your past orders and downloads',
              Icons.history,
              const Color(0xFFFC5C7D),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderHistoryScreen(),
                  ),
                );
              },
            ),
            // Removed: Saved Measurements card
          ],
        ),
      ),
    );
  }

  // Enhanced Feature Card with Gradient Background
  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color baseColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              baseColor.withOpacity(0.9),
              Color.lerp(
                baseColor,
                const Color(0xFFFC5C7D),
                0.5,
              )!.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: baseColor.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32.0, color: Colors.white),
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Quick Action Card with Icon and Gradient Accent
  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(icon, size: 24.0, color: Colors.white),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
