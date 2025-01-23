import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlView extends StatelessWidget {
  final String blogUrl;

  ArticlView({required this.blogUrl});

  @override
  Widget build(BuildContext context) {
    // Launch the URL immediately when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _launchURL(context);
    });

    // Return an empty container or a loading state
    return Container(); // Essentially a blank screen
  }

  void _launchURL(BuildContext context) async {
    if (await canLaunch(blogUrl)) {
      await launch(blogUrl);
      // Close the current screen after launching the URL
      Navigator.pop(context);
    }
  }
}