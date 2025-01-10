import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharpens/sharpmen/login.dart';

class SharpMenApp extends StatefulWidget {
  @override
  State<SharpMenApp> createState() => _SharpMenAppState();
}

class _SharpMenAppState extends State<SharpMenApp> {
  @override
  void initState() {
    super.initState();
    // No navigation in initState anymore
  }

  @override
  Widget build(BuildContext context) {
    // Use Future.delayed to navigate after the splash screen
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "Sharp Men" text
            Text(
              'Sharp Men',
              style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.w600,
                color: Colors.black54, // Changed text color to black
                letterSpacing: 2.5,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 5.0,
                    color: Colors.grey.shade400, // Adjusted shadow color
                  ),
                ],
              ),
            ),
            SizedBox(height: 40), // Spacing between title and button

            // "Get Started" button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54, // Background color
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                shadowColor: Colors.black.withOpacity(0.3),
                elevation: 5,
              ),
              child: Text(
                'Get Started',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white, // Button text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
