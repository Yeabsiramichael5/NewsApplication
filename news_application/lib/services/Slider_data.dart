import 'dart:convert';
import 'package:news_application/model/Slider_model.dart';
import 'package:http/http.dart' as http;

class Sliders {
  List<SliderModel> sliders = [];

  Future<void> getSliders() async {
    String url =
        "https://gnews.io/api/v4/top-headlines?category=sport&lang=en&country=us&max=10&apikey=";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['articles'] != null) {
          for (var element in jsonData['articles']) {
            if (element['image'] != null &&
                element['description'] != null &&
                await _isImageAccessible(element['image'])) {
              SliderModel sliderModel = SliderModel(
                title: element["title"],
                description: element["description"],
                url: element["url"],
                image: element["image"],
                content: element["content"],
              );
              sliders.add(sliderModel);
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
