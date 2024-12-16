import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_assignment/providers/auth_provider.dart';
import 'package:map_assignment/screens/profile_summary_screen.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isFetchingLocation = false;

  // Fetch user's current location and perform reverse geocoding
  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied");
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Perform reverse geocoding to get address components
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String location =
            "${place.subLocality}, ${place.locality}"; // Area, City
        _locationController.text = location;
      } else {
        throw Exception("No address found for the current location.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to fetch location: $e"),
      ));
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  void _submitProfile() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    final user = User(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dateOfBirth: _dobController.text,
      location: _locationController.text,
    );

    Provider.of<AuthProvider>(context, listen: false).setUser(user);
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ProfileSummaryScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
              textCapitalization: TextCapitalization.words,
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: "Last Name"),
              textCapitalization: TextCapitalization.words,
            ),
            TextField(
              controller: _dobController,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Date of Birth"),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  _dobController.text = "${picked.toLocal()}".split(' ')[0];
                }
              },
            ),
            TextField(
              controller: _locationController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Current Location",
                suffixIcon: _isFetchingLocation
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: _fetchCurrentLocation,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProfile,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
