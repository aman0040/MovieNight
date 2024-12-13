import 'package:flutter/material.dart';
import '../helpers/file_helper.dart';

class VotedMoviesScreen extends StatefulWidget {
  @override
  State<VotedMoviesScreen> createState() => _VotedMoviesScreenState();
}

class _VotedMoviesScreenState extends State<VotedMoviesScreen> {
  List<dynamic> votedMovies = []; // List to store voted movies

  @override
  void initState() {
    super.initState();
    fetchVotedMovies(); // Load voted movies on initialization
  }

  // Fetch voted movies from file storage
  Future<void> fetchVotedMovies() async {
    try {
      final movies = await FileHelper.getSavedMovies();
      setState(() {
        votedMovies = movies;
      });
    } catch (e) {
      debugPrint('Error loading voted movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voted Movies'),
      ),
      body: votedMovies.isEmpty
          ? const Center(
              child: Text(
                'No movies voted yet ;).',
                style: TextStyle(fontFamily: 'Exo_2'),
              ),
            )
          : ListView.builder(
              itemCount: votedMovies.length,
              itemBuilder: (context, index) {
                final movie = votedMovies[index];
                return ListTile(
                  leading: movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/images/movie.jpg'),
                  title: Text(
                    movie['title'],
                    style: const TextStyle(fontFamily: 'Exo_2'),
                  ),
                  subtitle: Text(
                    'Release Date: ${movie['release_date']}',
                    style: const TextStyle(fontFamily: 'Exo_2'),
                  ),
                );
              },
            ),
    );
  }
}
