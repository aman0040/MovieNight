import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Future<List<DataModel>> data;

  @override
  void initState() {
    super.initState();
    data = fetchData();
  }

  Future<List<DataModel>> fetchData() async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'); // New API URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body)['results'] as List;
        return jsonResponse.map((item) => DataModel.fromJSON(item)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon List'),
      ),
      body: FutureBuilder<List<DataModel>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found.'));
          } else {
            final dataList = snapshot.data!;
            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      dataList[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(dataList[index].description),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DataModel {
  final String title;
  final String description;

  DataModel({required this.title, required this.description});

  factory DataModel.fromJSON(Map<String, dynamic> json) {
    return DataModel(
      title: json['name'], // Use the "name" field from the API response
      description: json['url'], // Use the "url" field for the Pokémon details link
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Pokémon List',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
          .copyWith(secondary: Colors.amber),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.grey[700]),
      ),
    ),
    home: DataPage(),
  ));
}
