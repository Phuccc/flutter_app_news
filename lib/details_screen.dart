import 'article_model.dart';
import 'time_model.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(
            fontFamily: 'MadimiOne',
          ),
        ),
        centerTitle: true,
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: article.urlToImage != null
                      ? Image.network(
                          article.urlToImage!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'lib/assets/images/No_Image.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 25.0),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'By ${article.author ?? 'Unknown'}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 145, 145, 145),
                          fontWeight: FontWeight.bold,
                          fontFamily: "PatrickHand",
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          timeInDetail(article.publishedAt ?? ''),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 145, 145, 145),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Times New Roman",
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Text(
                  article.description ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 85, 85, 85),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  article.content ?? 'No content available',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 85, 85, 85),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}