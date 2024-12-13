import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_keys.dart';

class ShareCodeScreen extends StatefulWidget {
  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String? sessionCode;
  String? sessionId;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    startSession();
  }

  Future<void> startSession() async {
    try {
      final url = Uri.parse(
          '${MOVIE_NIGHT_API_BASE_URL}start-session?device_id=E5446E3E-8BB4-4DC8-A82F-7F540E449195');

      final response = await http.get(url);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          sessionCode = data['code'];
          sessionId = data['session_id'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to start the session. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Please check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Code'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
                ? Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Code: $sessionCode',
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Exo_2',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, '/movie_selection'),
                        child: const Text(
                          'Start Matching',
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
