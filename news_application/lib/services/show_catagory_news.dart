import 'dart:convert';
import 'package:news_application/model/Slider_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_application/model/show_catagory.dart';
// import 'package:flutter/material.dart';


class ShowCategoryNews {
  List<ShowCategoryModel> categories = [];

  Future<void> getCatagoriesNews(String category) async {
    String url =
        "https://gnews.io/api/v4/top-headlines?category=$category&lang=en&country=us&max=10&apikey=5e78821684862c88029498e7a9e74f9e";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['articles'] != null) {
          for (var element in jsonData['articles']) {
            if (element['image'] != null &&
                element['description'] != null &&
                await _isImageAccessible(element['image'])) {
              ShowCategoryModel categoryModel = ShowCategoryModel(
                title: element["title"],
                description: element["description"],
                url: element["url"],
                image: element["image"],
                content: element["content"],
              );
              categories.add(categoryModel);
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
