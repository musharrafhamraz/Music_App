import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF1C3FAA), // Background color
      body: Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: [
            Colors.blueAccent,
            Color.fromRGBO(37, 31, 159, 1),
          ],
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder for the main image
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(500),
                        topRight: Radius.circular(500),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      border: Border.all(
                        color: Colors.white38,
                        width: 3,
                      ),
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),

                  Image.asset(
                    'assets/images/splashscreen.png',
                    fit: BoxFit.cover,
                  ),
                  // Music notes
                ],
              ),
              const SizedBox(height: 40),
              Text('Listen and Enjoy\nYour Music',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 16),
              Text(
                'listen to our music and feel the joy of the songs we provide',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.blue[900],
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
