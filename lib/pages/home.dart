import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/pages/camera.dart';
import 'package:music/pages/musicscreen.dart';
import 'package:music/provider/audio_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../functions/find_genre.dart';
import 'search_page.dart';
import '../components/song_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  MyMusicAppState createState() => MyMusicAppState();
}

class MyMusicAppState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> _songs = [];
  List<SongModel> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    _loadSongsAndGenres();
  }

  void _loadSongsAndGenres() async {
    List<SongModel> songs = await _audioQuery.querySongs();

    // Filter out songs that belong to the "WhatsApp Audio" album
    List<SongModel> filteredSongs =
        songs.where((song) => song.album != "WhatsApp Audio").toList();

    setState(() {
      _songs = filteredSongs;
      _filteredSongs = filteredSongs; // Initialize the filtered list
    });
  }

  // Function to show modal with song details
  void _showSongDetails(SongModel song) {
    String genre = findGenreBySongMetadata(song); // Get genre by metadata
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => SongDetailsModal(genre: genre, song: song));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'M U S I F Y',
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CameraScreen(
                        songs: _songs,
                        audioPlayer: _audioPlayer,
                      )));
            },
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 0.5,
            colors: [
              Colors.blueAccent,
              Color.fromRGBO(37, 31, 159, 1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Listen To Your\nMusic Today 🎵',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(songs: _songs)));
                },
                child: Container(
                  height: 50.0,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Search Songs",
                        style: GoogleFonts.openSans(
                            textStyle: const TextStyle(color: Colors.white)),
                      ),
                      const Icon(Icons.search, color: Colors.white),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            Text(
              'MOST POPULAR',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _filteredSongs.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _filteredSongs.length,
                      itemBuilder: (context, index) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        leading: QueryArtworkWidget(
                          id: _filteredSongs[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(Icons.music_note,
                              size: 50, color: Colors.white),
                        ),
                        title: Text(
                          _filteredSongs[index].title,
                          maxLines: 2,
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          _filteredSongs[index].artist == '<unknown>'
                              ? "Unknown Artist"
                              : _filteredSongs[index].artist.toString(),
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            _showSongDetails(_filteredSongs[index]);
                          },
                          child:
                              const Icon(Icons.more_vert, color: Colors.white),
                        ),
                        onTap: () {
                          Provider.of<AudioProvider>(context, listen: false)
                              .stop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NowPlayingScreen(
                                        currentSongIndex: index,
                                        songs: _filteredSongs,
                                        audioPlayer: _audioPlayer,
                                      )));
                        },
                        onLongPress: () {
                          _showSongDetails(_filteredSongs[index]);
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
