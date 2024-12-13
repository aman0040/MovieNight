import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? deviceId; // Device ID to be fetched

  @override
  void initState() {
    super.initState();
    fetchDeviceId(); // Fetch the device ID during initialization
  }

  // Fetch the device ID using the platform_device_id plugin
  Future<void> fetchDeviceId() async {
    try {
      final id = await PlatformDeviceId.getDeviceId;
      setState(() {
        deviceId = id; // Update state with the device ID
      });
      debugPrint('Device ID: $deviceId');
    } catch (e) {
      debugPrint('Error fetching device ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night!'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/share_code'),
              child: const Text(
                'Get a Code',
                style: TextStyle(
                  fontFamily: 'Exo_2',
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/enter_code'),
              child: const Text(
                'Enter a Code',
                style: TextStyle(
                  fontFamily: 'Exo_2',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
