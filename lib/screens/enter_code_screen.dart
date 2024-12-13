import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_keys.dart';

class EnterCodeScreen extends StatefulWidget {
  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _joinSession(String code) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.parse(
        '${MOVIE_NIGHT_API_BASE_URL}join-session?device_id=E5446E3E-8BB4-4DC8-A82F-7F540E449195&code=$code',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final sessionId = data['session_id'];

        setState(() {
          isLoading = false;
        });

        Navigator.pushNamed(context, '/movie_selection');
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Invalid code. Please try again!';
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
      appBar: AppBar(title: Text('Enter the Code')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: InputDecoration(
                        labelText: 'Enter the Code from your friend',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final code = _codeController.text.trim();
                        if (code.length == 4) {
                          _joinSession(code);
                        } else {
                          setState(() {
                            errorMessage = 'Please enter a 4-digit code.';
                          });
                        }
                      },
                      child: Text(
                        'Begin',
                        style: TextStyle(
                          fontFamily: 'Exo_2',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
