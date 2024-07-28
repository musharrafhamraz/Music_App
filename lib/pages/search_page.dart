import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/pages/musicscreen.dart';
import 'package:music/provider/audio_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.songs});

  final List<SongModel> songs; // Accept a list of SongModel

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _searchController = TextEditingController();
  late List<SongModel> _filteredSongs;

  @override
  void initState() {
    super.initState();

    // Use the songs list from the widget and initialize the filtered list
    _filteredSongs = widget.songs;

    // Initialize the search controller with listener
    _searchController.addListener(_searchSongs);
  }

  void _searchSongs() {
    String query = _searchController.text.toLowerCase();
    List<SongModel> filtered = widget.songs.where((song) {
      return song.title.toLowerCase().contains(query) ||
          (song.artist?.toLowerCase().contains(query) ?? false);
    }).toList();

    setState(() {
      _filteredSongs = filtered;
    });
  }

  @override
  void dispose() {
    // Dispose the search controller to avoid memory leaks
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
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
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  suffixIcon: const Icon(Icons.search, color: Colors.white),
                  hintText: 'Search Song',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20), // Add some spacing
              _filteredSongs.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          "No data found!",
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _filteredSongs.length,
                        itemBuilder: (context, index) => ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
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
                          trailing:
                              const Icon(Icons.more_vert, color: Colors.white),
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
                                ),
                              ),
                            );
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
