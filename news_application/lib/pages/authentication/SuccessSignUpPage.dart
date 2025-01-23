import 'package:flutter/material.dart';
import 'SignInPage.dart';

class SuccessSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success message
            Text(
              'Success!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            // Description message
            Text(
              'Your account has been created',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Checkmark icon
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: const Color.fromARGB(255, 9, 43, 82), // Teal checkmark color
              ),
            ),
            SizedBox(height: 40),
            // Continue button
            ElevatedButton(
              onPressed: () {
                // Navigate to the Sign-In page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 9, 43, 82), // Teal button color
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 18, color: Colors.white), // White text
              ),
            ),
          ],
        ),
      ),
    );
  }
}