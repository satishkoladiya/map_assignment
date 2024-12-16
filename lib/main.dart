import 'package:flutter/material.dart';
import 'package:map_assignment/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/profile_summary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check FTU or profile completion
  final prefs = await SharedPreferences.getInstance();
  final isProfileComplete = prefs.getBool('isProfileComplete') ?? false;

  runApp(MyApp(isProfileComplete: isProfileComplete));
}

class MyApp extends StatelessWidget {
  final bool isProfileComplete;

  const MyApp({super.key, required this.isProfileComplete});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isProfileComplete ? ProfileSummaryScreen() : LoginScreen(),
      ),
    );
  }
}
