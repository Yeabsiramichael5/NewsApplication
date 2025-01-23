import 'dart:convert';
import 'package:news_application/model/articl_model.dart'; // Ensure correct import
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    String url =
        "https://gnews.io/api/v4/search?q=example&lang=en&country=us&max=10&apikey=5e78821684862c88029498e7a9e74f9e";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['articles'] != null) {
          for (var element in jsonData['articles']) {
            if (element['image'] != null &&
                element['description'] != null &&
                await _isImageAccessible(element['image'])) {
              ArticleModel articleModel = ArticleModel(
                title: element["title"],
                description: element["description"],
                url: element["url"],
                image: element["image"],
                content: element["content"],
              );
              news.add(articleModel);
            }
          }
        } else {
          print("No articles found in API response");
        }
      } else {
        print("Failed to fetch news. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e");
    }
  }

  Future<bool> _isImageAccessible(String imageUrl) async {
    try {
      var response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200; // Accessible if status is OK
    } catch (e) {
      print("Error checking image accessibility: $e");
      return false; // Return false if there's an error
    }
  }
}
