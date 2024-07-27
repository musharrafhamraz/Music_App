import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import '../functions/image_display.dart';

class ReccomendationScreen extends StatefulWidget {
  const ReccomendationScreen({
    super.key,
    required this.prediction,
    required this.songs,
    required this.audioPlayer,
  });

  final String prediction;
  final List<SongModel> songs;
  final AudioPlayer audioPlayer;

  @override
  State<ReccomendationScreen> createState() => _ReccomendationScreenState();
}

class _ReccomendationScreenState extends State<ReccomendationScreen> {
  SongModel? recommendedSong;

  @override
  void initState() {
    super.initState();
    recommendedSong = _getRecommendedSong(widget.prediction);
  }

  SongModel? _getRecommendedSong(String emotion) {
    Map<String, List<String>> emotionToGenre = {
      'happy': ['Pop', 'Dance', 'Electronic', 'Romantic', 'Folk', 'Hip Hop'],
      'sad': [
        'Ballad',
        'Blues',
        'Soul',
        'Romantic',
      ],
      'angry': [],
      'neutral': [
        'Indie',
        'Jazz',
        'Alternative',
        'Classical',
        'Electronic',
      ],
      'disgust': ['R&B'],
      'fearful': [],
      'surprised': [
        'Pop',
        'Dance',
        'Electronic',
      ],
    };

    List<String>? genres = emotionToGenre[emotion.toLowerCase()];

    List<SongModel> filteredSongs = widget.songs.where((song) {
      String songMetadata = '${song.album} ${song.artist}'.toLowerCase();
      return genres != null &&
          genres.any((genre) => songMetadata.contains(genre.toLowerCase()));
    }).toList();

    return filteredSongs.isNotEmpty ? filteredSongs.first : null;
  }

  void _playSong(SongModel song) async {
    try {
      await widget.audioPlayer
          .setAudioSource(AudioSource.uri(Uri.file(song.data)));
      widget.audioPlayer.play();
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = getImagePath(widget.prediction);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation for ${widget.prediction}'),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Image.asset(imagePath),
            recommendedSong != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QueryArtworkWidget(
                        id: recommendedSong!.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget:
                            const Icon(Icons.music_note, size: 100),
                        artworkFit: BoxFit.cover,
                        artworkHeight: 200,
                        artworkWidth: 200,
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
                      ElevatedButton.icon(
                        onPressed: () => _playSong(recommendedSong!),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Play"),
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
    );
  }
}
