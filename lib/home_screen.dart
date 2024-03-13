import 'dart:convert';
import 'article_model.dart';
import 'details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Flutter'),Text('News', style: TextStyle(color: Color.fromARGB(255, 217, 49, 49),),)],
          ),
        titleTextStyle: const TextStyle( 
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold, 
          fontSize: 25),
        backgroundColor: Color.fromARGB(255, 204, 235, 251),
      ),
      body: FutureBuilder(
        future: getArticles(),
        builder: (context, snapshot) {  
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                final List<Article> articles = snapshot.data!;
                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return customListTile(articles[index], context);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: Text('No articles found.'),
                );
              }
          }
        },
      ),
    );
  }

  Widget customListTile(Article article, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticlePage(
                    article: article,
                  )));
      },
      child: Container(
        margin: const EdgeInsets.all(12.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 243, 250, 255),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(31, 0, 0, 0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: article.urlToImage != null
                    ? DecorationImage(
                        image: NetworkImage(article.urlToImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'By ${article.author ?? 'Unknown'}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 115, 115, 115),
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    article.publishedAt ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Article>> getArticles() async {
    const url =
        'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=95ad061681af49c898335c33ab37c383';
    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body) as Map<String, dynamic>;
    final List<Article> result = [];
    for (final article in body['articles']) {
      result.add(
        Article(
          title: article['title'],
          author: article['author'],
          description: article['description'],
          url: article['url'],
          urlToImage: article['urlToImage'],
          publishedAt: article['publishedAt'],
          content: article['content'],
          source: Source(
            id: article['source']['id'],
            name: article['source']['name'],
          ),
        ),
      );
    }
    return result;
  }
}