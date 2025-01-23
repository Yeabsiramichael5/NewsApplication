import 'package:flutter/material.dart';
import 'authentication/SignInPage.dart';
class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        body: Center(
          child: Stack(
            children: [
              // Background image
              Image.asset(
                'images/news2.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
               fit: BoxFit.cover, ),
              // Get Started button
              Positioned(
                bottom: 50, // Adjust this value to position the button
                left: 0,
                right: 0,
                  child: Center( // Center the button horizontally
                  child: Container(
                    width: 300, // Set the desired width
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const Color.fromARGB(255, 9, 43, 82), // Button color
                        padding: EdgeInsets.symmetric(vertical: 15), // Button padding
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18, // Text size
                        ),
                    ),
                  ),
                ),
              )
              ),
            ],
          
          ),
        ),
      ),
    );
  }
}


