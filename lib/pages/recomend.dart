import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music/provider/audio_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../functions/image_display.dart';

class ReccomendationScreen extends StatefulWidget {
  const ReccomendationScreen({
    super.key,
    required this.prediction,
    required this.songs,
  });

  final String prediction;
  final List<SongModel> songs;

  @override
  State<ReccomendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<ReccomendationScreen> {
  SongModel? recommendedSong;
  List<SongModel> playedSongs = [];

  @override
  void initState() {
    super.initState();
    recommendedSong = _getRecommendedSong(widget.prediction);
    if (recommendedSong != null) {
      context.read<AudioProvider>().playSong(recommendedSong!);
    }
  }

  SongModel? _getRecommendedSong(String emotion) {
    Map<String, List<String>> emotionToGenre = {
      'happy': ['Pop', 'Dance', 'Electronic', 'Romantic', 'Folk', 'Hip Hop'],
      'sad': ['Ballad', 'Blues', 'Soul', 'Romantic', 'Acoustic', 'Classical'],
      'angry': ['Metal', 'Hard Rock', 'Punk', 'Rap', 'Industrial', 'Pop'],
      'neutral': [
        'Indie',
        'Jazz',
        'Alternative',
        'Classical',
        'Electronic',
        'Chill'
      ],
      'disgust': ['R&B', 'Grunge', 'Alternative', 'Goth'],
      'fearful': ['Pop', 'Dance', 'Electronic', 'Romantic', 'Folk', 'Hip Hop'],
      'surprised': ['Pop', 'Dance', 'Electronic', 'Experimental', 'Synthwave'],
    };

    List<String>? genres = emotionToGenre[emotion.toLowerCase()];

    List<SongModel> filteredSongs = widget.songs.where((song) {
      String songMetadata = '${song.album} ${song.artist}'.toLowerCase();
      return genres != null &&
          genres.any((genre) => songMetadata.contains(genre.toLowerCase()));
    }).toList();

    filteredSongs.removeWhere((song) => playedSongs.contains(song));

    if (filteredSongs.isEmpty) {
      playedSongs.clear();
      filteredSongs = widget.songs.where((song) {
        String songMetadata = '${song.album} ${song.artist}'.toLowerCase();
        return genres != null &&
            genres.any((genre) => songMetadata.contains(genre.toLowerCase()));
      }).toList();
    }

    if (filteredSongs.isNotEmpty) {
      filteredSongs.shuffle();
      return filteredSongs.first;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = getImagePath(widget.prediction);
    var audioProvider = Provider.of<AudioProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2,
            colors: [
              Colors.blueAccent,
              Color.fromRGBO(37, 31, 159, 1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                recommendedSong != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          QueryArtworkWidget(
                            id: recommendedSong!.id,
                            type: ArtworkType.AUDIO,
                            quality: 100,
                            nullArtworkWidget:
                                const Icon(Icons.music_note, size: 100),
                            artworkFit: BoxFit.cover,
                            artworkHeight: 300,
                            artworkWidth: 300,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            recommendedSong!.title,
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            recommendedSong!.artist == '<unknown>'
                                ? "Unknown Artist"
                                : recommendedSong!.artist.toString(),
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          IconButton(
                            icon: Icon(
                              audioProvider.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.blueAccent,
                              size: 70,
                            ),
                            onPressed: () {
                              audioProvider.togglePlayPause();
                            },
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          'No song available for this emotion.',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
