import 'dart:convert';
import 'article_model.dart';
import 'details_screen.dart';
import 'time_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Flutter'),
            const Text(
              'News',
              style: TextStyle(color: Color.fromARGB(255, 22, 157, 230)),
            ),
            const Spacer(), // Tạo khoảng trống để căn chỉnh vị trí
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                getCurrentDate(),
                style: const TextStyle(
                  color: Color.fromARGB(255, 10, 10, 10),
                  fontFamily: 'MadimiOne',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        backgroundColor: const Color.fromARGB(255, 215, 236, 247),
      ),
      body: Column( 
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: TextFormField(
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 191, 191, 192),
                filled: true,
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for article',
              ),
            ),
          ),
          const SizedBox(height: 20),
              // Thanh danh sách thể loại
          const SizedBox(
            height: 40,
            child: CategoriesBar(),
          ),
          // Danh sách bài báo
          const SizedBox(height: 16.0), 
          Expanded(
            child: FutureBuilder(
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
          ),
        ],
      ),
    );
  }

  Widget customListTile(Article article, BuildContext context) {
    final formattedDifference = getFormattedDifference(article.publishedAt!);
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
        margin: const EdgeInsets.only(right: 12, left: 12),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 250, 255),
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
                      fontWeight: FontWeight.bold,
                      fontFamily: "PatrickHand",
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    formattedDifference,
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

class CategoriesBar extends StatefulWidget {
  const CategoriesBar({super.key});

  @override
  State<CategoriesBar> createState() => _CategoriesBarState();
}

class _CategoriesBarState extends State<CategoriesBar> {
  List<String> categories = const [
    'All',
    'Politics',
    'Sports',
    'Health',
    'Music',
    'Tech'
  ];

  int currentCategory = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            currentCategory = index;
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(
              // vertical: 8.0,
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
              color: currentCategory == index ? Colors.black : const Color.fromARGB(255, 255, 255, 255),
              border: Border.all(),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Text(
                categories.elementAt(index),
                style: TextStyle(
                  color: currentCategory == index ? Colors.white : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
