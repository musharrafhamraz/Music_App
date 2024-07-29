import 'package:flutter/material.dart';
import 'package:music/provider/audio_provider.dart';
import 'package:music/provider/song_image_provider.dart';
import 'pages/splashscreen.dart';
import 'pages/home.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AudioProvider(),
    ),
    ChangeNotifierProvider(create: (_) => SongImageProvider()),
  ], child: MyApp()));
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
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
