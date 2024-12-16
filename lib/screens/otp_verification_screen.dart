import 'package:flutter/material.dart';
import 'package:map_assignment/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'create_profile_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobile;

  OtpVerificationScreen({required this.mobile});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _verifyOtp() {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    if (provider.validateOtp(_otpController.text)) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const CreateProfileScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Enter the OTP sent to ${widget.mobile}"),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "OTP"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
