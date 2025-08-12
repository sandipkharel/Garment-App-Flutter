import 'package:flutter/material.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/garment_measure/garment_measurement_upload_screen.dart';
import '../features/garment_recognize/garment_recognition_upload_screen.dart';
import '../features/chatbot/chatbot_screen.dart';
import '../features/pattern_adjust/pattern_adjustment_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/garment-measurement':
        return MaterialPageRoute(builder: (_) => const GarmentMeasurementUploadScreen());
      case '/garment-recognition':
        return MaterialPageRoute(builder: (_) => const GarmentRecognitionUploadScreen());
      case '/chatbot':
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());
      case '/pattern-adjustment':
        return MaterialPageRoute(builder: (_) => const PatternAdjustmentScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
