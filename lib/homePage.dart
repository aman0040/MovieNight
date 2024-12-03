import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top half with background image
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // Ensure this asset exists
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Bottom half with text and transformation
        Expanded(
          flex: 1,
          child: Container(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
            child: Center(
              child: Transform.scale(
                scale: 1.2, // Example transformation
                child: Text(
                  'Welcome to the App!',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
