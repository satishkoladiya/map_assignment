import 'package:flutter/material.dart';

import 'create_profile_screen.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isOtpMode = true;

  // Function to validate phone number
  bool _isValidPhoneNumber(String phone) {
    final phoneRegExp = RegExp(
        r'^(?:[+0]9)?[0-9]{10}$'); // Simple regex for phone number validation
    return phoneRegExp.hasMatch(phone);
  }

  void _login() {
    if (_isOtpMode) {
      if (!_isValidPhoneNumber(_mobileController.text)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid phone number")));
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                OtpVerificationScreen(mobile: _mobileController.text)),
      );
    } else {
      if (!_emailController.text.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email format")));
        return;
      }
      if (_passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password cannot be empty")));
        return;
      }
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const CreateProfileScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => _isOtpMode = true),
                  child: const Text("Login with OTP"),
                ),
                TextButton(
                  onPressed: () => setState(() => _isOtpMode = false),
                  child: const Text("Login with Email"),
                ),
              ],
            ),
            if (_isOtpMode)
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Mobile Number"),
              )
            else ...[
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
