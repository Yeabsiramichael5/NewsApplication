import 'HomePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedNewsPage extends StatefulWidget {
  @override
  _SavedNewsPageState createState() => _SavedNewsPageState();
}

class _SavedNewsPageState extends State<SavedNewsPage> {
  List<dynamic> savedNews = [];
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    fetchSavedNews();
  }

  Future<void> fetchSavedNews() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: User not logged in");
        return;
      }

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          savedNews = userDoc.data()!['savednews'] ?? [];
        });
      }
    } catch (e) {
      print("Error fetching saved news: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching data
      });
    }
  }

  Future<void> deleteNewsItem(int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: User not logged in");
        return;
      }

      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Remove the news item locally and in the database
      setState(() {
        savedNews.removeAt(index);
      });

      await userRef.update({'savednews': savedNews});
      print("News item deleted successfully");
    } catch (e) {
      print("Error deleting news item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved News'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : savedNews.isEmpty
              ? Center(
                  child: Text("No saved news"), // Show "No saved news" message
                )
              : ListView.builder(
                  itemCount: savedNews.length,
                  itemBuilder: (context, index) {
                    final news = savedNews[index];
                    return GestureDetector(
                      onTap: () async {
                        if (news['url'] != null &&
                            await canLaunchUrl(Uri.parse(news['url']))) {
                          await launchUrl(Uri.parse(news['url']),
                              mode: LaunchMode.externalApplication);
                        } else {
                          print("Could not launch URL");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: news['imageurl'] != null
                                        ? Image.network(
                                            news['imageurl'],
                                            height: 120,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox(
                                            height: 120,
                                            width: 100,
                                            child: Center(
                                              child: Icon(Icons.image,
                                                  size: 50, color: Colors.grey),
                                            ),
                                          ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          news['title'] ?? "No title",
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                        SizedBox(height: 7.0),
                                        Text(
                                          news['desc'] ?? "No description",
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteNewsItem(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
