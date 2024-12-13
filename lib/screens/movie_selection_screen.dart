import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_keys.dart';
import '../helpers/file_helper.dart';

class MovieSelectionScreen extends StatefulWidget {
  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  List<Map<String, dynamic>> movies = [];
  int currentIndex = 0;
  bool isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          '${TMDB_BASE_URL}movie/popular?api_key=$TMDB_API_KEY&page=$currentPage');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        setState(() {
          movies.addAll(results.map((movie) => {
                'id': movie['id'],
                'title': movie['title'],
                'poster_path': movie['poster_path'],
                'release_date': movie['release_date'],
                'overview': movie['overview'],
              }));
          currentPage++;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> voteMovie(int movieId, bool vote) async {
    try {
      final sessionId = 'e15d1aaf-1dc5-464c-9168-86d153bbf3e1';
      final url = Uri.parse(
          '${MOVIE_NIGHT_API_BASE_URL}vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];

        if (vote) {
          await FileHelper.saveMovie(movies[currentIndex]);
        }

        if (data['match'] == true) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'It’s a Match!',
                style: TextStyle(fontFamily: 'Exo_2'),
              ),
              content: Text(
                'You and your partner matched on ${data['movie_id']}!',
                style: TextStyle(fontFamily: 'Exo_2', fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('Error voting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && movies.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Movie Choices')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Choices'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/voted_movies');
            },
          ),
        ],
      ),
      body: movies.isEmpty
          ? Center(
              child: Text(
              'No movies available.',
              style: TextStyle(fontFamily: 'Exo_2'),
            ))
          : Dismissible(
              key: Key(movies[currentIndex]['id'].toString()),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                final movie = movies[currentIndex];
                final vote = direction == DismissDirection.endToStart;

                voteMovie(movie['id'], vote);

                setState(() {
                  currentIndex++;
                  if (currentIndex >= movies.length) {
                    fetchMovies();
                  }
                });
              },
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.thumb_up, color: Colors.white, size: 48),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Icon(Icons.thumb_down, color: Colors.white, size: 48),
              ),
              child: buildMovieCard(movies[currentIndex]),
            ),
    );
  }

  Widget buildMovieCard(Map<String, dynamic> movie) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          movie['poster_path'] != null
              ? Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                  fit: BoxFit.cover,
                  height: 300,
                )
              : Image.asset(
                  'assets/images/movie.jpg',
                  height: 300,
                ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Text(
                  'Release Date: ${movie['release_date']}',
                  style: TextStyle(fontFamily: 'Exo_2'),
                ),
                SizedBox(height: 16),
                Text(
                  movie['overview'] ?? 'No description available.',
                  style: TextStyle(fontFamily: 'Exo_2'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
