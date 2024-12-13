import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/share_code_screen.dart';
import 'screens/enter_code_screen.dart';
import 'screens/movie_selection_screen.dart';
import 'screens/voted_movies_screen.dart';

void main() => runApp(MovieNightApp());

class MovieNightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 20,
            fontFamily: 'Exo_2',
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(
            fontSize: 30,
            fontFamily: 'Exo_2',
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/share_code': (context) => ShareCodeScreen(),
        '/enter_code': (context) => EnterCodeScreen(),
        '/movie_selection': (context) => MovieSelectionScreen(),
        '/voted_movies': (context) => VotedMoviesScreen(),
      },
    );
  }
}
