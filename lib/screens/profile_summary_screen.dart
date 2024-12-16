import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileSummaryScreen extends StatelessWidget {
  final User? user;

  ProfileSummaryScreen({this.user});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isProfileComplete');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = user ??
        User(
          firstName: "John",
          lastName: "Doe",
          dateOfBirth: "1990-01-01",
          location: "Unknown Location",
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Summary"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(user: userDetails),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("First Name: ${userDetails.firstName}"),
            Text("Last Name: ${userDetails.lastName}"),
            Text("Date of Birth: ${userDetails.dateOfBirth}"),
            Text("Location: ${userDetails.location}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
