import 'package:flutter/material.dart';
import 'package:news_application/model/show_catagory.dart';
import 'package:news_application/services/show_catagory_news.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class CatagoryNews extends StatefulWidget {
   String name;

   CatagoryNews({required this.name});

  @override
  State<CatagoryNews> createState() => _CatagoryNewsState();
}

class _CatagoryNewsState extends State<CatagoryNews> {


List<ShowCategoryModel> catagories = [];
bool _loading=true;

@override
void initState(){
  super.initState();
  getNews();
  
}

getNews() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCatagoriesNews(widget.name.toLowerCase());
    catagories = showCategoryNews.categories;
    setState(() {
      _loading = false;
    });
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        widget.name,
        style: TextStyle(color: const Color.fromARGB(255, 9, 43, 82), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0.0,
    ),
    body:_loading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          :
     Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: catagories.length,
            itemBuilder: (context, index) {
              return ShowCatagory(
                imageurl: catagories[index].image,
                title: catagories[index].title,
                desc: catagories[index].description,
                url: catagories[index].url,
              );
            },
          ),
        ),
      ],
    ),
  );
}
}

class ShowCatagory extends StatefulWidget {
  final String? imageurl, title, desc, url;

  const ShowCatagory({this.imageurl, this.title, this.desc, this.url});

  @override
  _ShowCatagoryState createState() => _ShowCatagoryState();
}

class _ShowCatagoryState extends State<ShowCatagory> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    checkIfSaved();
  }

  Future<void> checkIfSaved() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        final savedNews = userDoc.data()!['savednews'] ?? [];
        setState(() {
          isSaved = savedNews.any((item) => item['url'] == widget.url);
        });
      }
    } catch (e) {
      print("Error checking if news is saved: $e");
    }
  }

  Future<void> toggleSave() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: User not logged in");
        return;
      }

      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final userDoc = await userDocRef.get();
      List<dynamic> savedNews = [];
      if (userDoc.exists && userDoc.data() != null) {
        savedNews = userDoc.data()!['savednews'] ?? [];
      }

      final newsItem = {
        'imageurl': widget.imageurl ?? '',
        'title': widget.title ?? 'No Title',
        'desc': widget.desc ?? 'No Description',
        'url': widget.url ?? '',
      };

      bool isAlreadySaved = savedNews.any((item) => item['url'] == newsItem['url']);

      if (isAlreadySaved) {
        savedNews.removeWhere((item) => item['url'] == newsItem['url']);
        print("News removed from saved items: ${widget.url}");
      } else {
        savedNews.add(newsItem);
        print("News saved successfully: ${widget.url}");
      }

      await userDocRef.update({'savednews': savedNews});

      setState(() {
        isSaved = !isSaved;
      });
    } catch (e) {
      print("Error toggling save: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.url != null && await canLaunchUrl(Uri.parse(widget.url!))) {
          await launchUrl(Uri.parse(widget.url!), mode: LaunchMode.externalApplication);
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
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.imageurl != null
                        ? Image.network(
                            widget.imageurl!,
                            height: 120,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(
                            height: 120,
                            width: 100,
                            child: Center(
                              child: Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                          ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.title ?? "No title",
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isSaved ? Icons.bookmark : Icons.bookmark_border,
                                color: isSaved ? Colors.yellow : Colors.grey,
                              ),
                              onPressed: toggleSave,
                            ),
                          ],
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          widget.desc ?? "No description",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
