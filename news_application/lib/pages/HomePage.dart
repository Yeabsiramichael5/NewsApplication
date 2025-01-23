import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_application/model/Slider_model.dart';
import 'package:news_application/model/articl_model.dart';
import 'package:news_application/model/catagoryModel.dart';
import 'package:news_application/pages/SavedNewsPage.dart';
import 'package:news_application/pages/articl_view.dart';
import 'package:news_application/pages/catagory_news.dart';
import 'package:news_application/services/Slider_data.dart';
import 'package:news_application/services/data.dart';
import 'package:news_application/services/news.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfilePage.dart';
import 'LandingPage.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  
  List<Catagorymodel> catagories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  int activeIndex = 0;

  @override
  void initState() {
    catagories = getCatagories();
    getsliders();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      _loading = false;
    });
  }

  getsliders() async {
    Sliders slider = Sliders();
    await slider.getSliders();
    sliders = slider.sliders;
    sliders = slider.sliders.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("News"),
            Text(
              "Application",
              style: TextStyle(
                color: const Color.fromARGB(255, 9, 43, 82),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 9, 43, 82),
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            // My Account Section
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),

            // Saved News Section
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Saved News'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedNewsPage()),
                );
              },
            ),

            // Logout Section
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),

      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: catagories.length,
                      itemBuilder: (context, index) {
                        return CatagoryTile(
                          image: catagories[index].image,
                          catagoryName: catagories[index].catagoryName,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Breaking News!",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0),
                        ),
                        
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),

                  
      CarouselSlider.builder(
                        itemCount: sliders.length,
                        itemBuilder: (context, index, realIndex) {
                          String? res = sliders[index].image;
                          String? resl = sliders[index].title;
                          String? url = sliders[index].url;
                          return buildImage(res, index, resl, url);
                        },
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          },
                        ),
                      ),

                SizedBox(height: 30.0),
                Center(child: buildIndicator()),
                SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trending News",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return BlogTile(
                      imageurl: articles[index].image,
                      title: articles[index].title,
                      desc: articles[index].description,
                      url: articles[index].url,
                    );
                  },
                ),
              ],
            ),
          ),
  );
}


  


 Widget buildImage(String? image, int index, String? name, String? url) {
  return GestureDetector(
    onTap: () async {
      if (url != null && await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch URL");
      }
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image ?? 'images/placeholder.png',
              height: 250,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            height: 250,
            padding: EdgeInsets.only(left: 10.0),
            margin: EdgeInsets.only(top: 170.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Text(
              name ?? 'No name',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: sliders.length,
        effect: SlideEffect(
            dotWidth: 15.0, dotHeight: 15, activeDotColor: const Color.fromARGB(255, 9, 43, 82)),
      );

       void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Landingpage()),
                    (route) => false,
                  );
                });
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

}

class CatagoryTile extends StatelessWidget {
  final image,catagoryName;
  CatagoryTile({this.catagoryName,this.image});
   
      
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CatagoryNews(name: catagoryName)));
      } ,
      child:  Container(
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
           child:Image.asset(
            image,
            width: 120,
            height: 60,fit: BoxFit.cover,
            )
            ),
             Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Center(child: Text(catagoryName,
              style: TextStyle(color: Colors.white ,fontSize: 15,fontWeight: FontWeight.bold), ),)
             )
            ],
            ),
    ),
    );
   
  }

  
}

class BlogTile extends StatefulWidget {
  final String? imageurl, title, desc, url;

  const BlogTile({this.imageurl, this.title, this.desc, this.url});

  @override
  _BlogTileState createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  bool isSaved = false;

  Future<void> toggleSave() async {
  try {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Error: User not logged in");
      return;
    }

    // Reference to the user's document
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Get the current user's document
    final userDoc = await userDocRef.get();

    // Get the savednews array
    List<dynamic> savedNews = [];
    if (userDoc.exists && userDoc.data() != null) {
      savedNews = userDoc.data()!['savednews'] ?? [];
    }

    // Create the news item as a map
    final newsItem = {
      'imageurl': widget.imageurl ?? '',
      'title': widget.title ?? 'No Title',
      'desc': widget.desc ?? 'No Description',
      'url': widget.url ?? '',
    };

    // Check if the news item is already in the savednews array
    bool isAlreadySaved = savedNews.any((item) => item['url'] == newsItem['url']);

    if (isAlreadySaved) {
      // If the item exists, remove it from the array
      savedNews.removeWhere((item) => item['url'] == newsItem['url']);
      print("News removed from saved items: ${widget.url}");
    } else {
      // Otherwise, add it to the array
      savedNews.add(newsItem);
      print("News saved successfully: ${widget.url}");
    }

    // Update the user's document with the updated savednews array
    await userDocRef.update({'savednews': savedNews});

    // Update the UI state
    setState(() {
      isSaved = !isSaved;
    });
  } catch (e) {
    print("Error in toggleSave: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.url != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticlView(blogUrl: widget.url!),
            ),
          );
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