import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(NewsApp());

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsListPage(),
    );
  }
}

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiKey = '993e40fb28b94c2185d5ba4ee052a5a4';
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      setState(() {
        articles = jsonDecode(response.body)['articles'];
      });
    }
  }

  void navigateToDetailPage(dynamic article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => navigateToDetailPage(articles[index]),
            child: Card(
              child: ListTile(
                title: Text(articles[index]['title']),
                subtitle: Text(articles[index]['description']),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final dynamic article;

  NewsDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(article['urlToImage']),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    article['description'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Author: ${article['author']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Published At: ${article['publishedAt']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
