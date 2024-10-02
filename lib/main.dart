import 'package:flutter/material.dart';
import 'package:music/provider/audio_provider.dart';
import 'package:music/provider/image_provider.dart';
import 'pages/splashscreen.dart';
import 'pages/home.dart';

import 'package:provider/provider.dart';

import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the JustAudioBackground
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  // Run the app with MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => SongImageProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
