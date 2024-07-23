import 'package:flutter/material.dart';
import 'pages/splashscreen.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MusicScreen(),
      routes: {
        '/login': (context) => HomeScreen(),
      },
    );
  }
}
