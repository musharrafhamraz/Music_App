/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/pages/camera.dart';
import 'package:music/pages/musicscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../functions/find_genre.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongModel> _songs = [];

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

    List<SongModel> filteredSongs =
        songs.where((song) => song.album != "WhatsApp Audio").toList();

    setState(() {
      _songs = filteredSongs;
    });
  }

  // Function to show modal with song details
  void _showSongDetails(SongModel song) {
    String genre = findGenreBySongMetadata(song); // Get genre by metadata
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSongDetailsModal(song, genre),
    );
  }

  // Function to build the song details modal
  Widget _buildSongDetailsModal(SongModel song, String genre) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Add ellipsis overflow
                    maxLines: 1, // Limit to 1 line
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: 100,
                  artworkWidth: 100,
                  artworkFit: BoxFit.cover,
                  nullArtworkWidget: const Icon(Icons.music_note, size: 100),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Artist: ${song.artist ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 16),
                        overflow:
                            TextOverflow.ellipsis, // Add ellipsis overflow
                        maxLines: 1, // Limit to 1 line
                      ),
                      Text(
                        'Album: ${song.album ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 16),
                        overflow:
                            TextOverflow.ellipsis, // Add ellipsis overflow
                        maxLines: 1, // Limit to 1 line
                      ),
                      Text(
                        'Genre: $genre',
                        style: const TextStyle(fontSize: 16),
                        overflow:
                            TextOverflow.ellipsis, // Add ellipsis overflow
                        maxLines: 1, // Limit to 1 line
                      ),
                      Text(
                        'Duration: ${Duration(milliseconds: song.duration ?? 0).inMinutes}:${Duration(milliseconds: song.duration ?? 0).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Additional Info:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'ID: ${song.id}',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis, // Add ellipsis overflow
              maxLines: 1, // Limit to 1 line
            ),
            Text(
              'File Path: ${song.data}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "--- Hi, Musharraf Hamraz!",
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CameraScreen(
                                  songs: _songs,
                                  audioPlayer: _audioPlayer,
                                )));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black87.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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
                TextField(
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RECENTLY PLAYED',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'See more',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _songs.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NowPlayingScreen(
                                            songModel: _songs[index],
                                            audioPlayer: _audioPlayer,
                                          )));
                            },
                            onLongPress: () {
                              _showSongDetails(_songs[index]);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: QueryArtworkWidget(
                                        id: _songs[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Icon(
                                            Icons.music_note,
                                            size: 50,
                                            color: Colors.white),
                                        artworkFit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _songs[index].title,
                                    maxLines: 1,
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _songs[index].artist == '<unknown>'
                                        ? "Unknown Artist"
                                        : _songs[index].artist.toString(),
                                    maxLines: 1,
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount: _songs.length,
                        ),
                      ),
                // const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MOST POPULAR',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'See more',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _songs.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) => ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            leading: QueryArtworkWidget(
                              id: _songs[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(Icons.music_note,
                                  size: 50, color: Colors.white),
                            ),
                            title: Text(
                              _songs[index].title,
                              maxLines: 2,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              _songs[index].artist == '<unknown>'
                                  ? "Unknown Artist"
                                  : _songs[index].artist.toString(),
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            trailing: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NowPlayingScreen(
                                            songModel: _songs[index],
                                            audioPlayer: _audioPlayer,
                                          )));
                            },
                            onLongPress: () {
                              _showSongDetails(_songs[index]);
                            },
                          ),
                          itemCount: _songs.length,
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
*/

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

class HomeScreen extends StatefulWidget {
  @override
  _MyMusicAppState createState() => _MyMusicAppState();
}

class _MyMusicAppState extends State<HomeScreen> {
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
      builder: (context) => _buildSongDetailsModal(song, genre),
    );
  }

  // Function to build the song details modal
  Widget _buildSongDetailsModal(SongModel song, String genre) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Add ellipsis overflow
                    maxLines: 1, // Limit to 1 line
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: 100,
                  artworkWidth: 100,
                  artworkFit: BoxFit.cover,
                  nullArtworkWidget: const Icon(Icons.music_note, size: 100),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Artist: ${song.artist ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 16),
                        overflow:
                            TextOverflow.ellipsis, // Add ellipsis overflow
                        maxLines: 1, // Limit to 1 line
                      ),
                      Text(
                        'Album: ${song.album ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 16),
                        overflow:
                            TextOverflow.ellipsis, // Add ellipsis overflow
                        maxLines: 1, // Limit to 1 line
                      ),
                      Text(
                        'Genre: $genre',
                        style: const TextStyle(fontSize: 16),
                        overflow:
                            TextOverflow.ellipsis, // Add ellipsis overflow
                        maxLines: 1, // Limit to 1 line
                      ),
                      Text(
                        'Duration: ${Duration(milliseconds: song.duration ?? 0).inMinutes}:${Duration(milliseconds: song.duration ?? 0).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Additional Info:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'ID: ${song.id}',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis, // Add ellipsis overflow
              maxLines: 1, // Limit to 1 line
            ),
            Text(
              'File Path: ${song.data}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "--- Hi, Musharraf Hamraz!",
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CameraScreen(
                                  songs: _songs,
                                  audioPlayer: _audioPlayer,
                                )));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black87.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                                textStyle:
                                    const TextStyle(color: Colors.white)),
                          ),
                          const Icon(Icons.search, color: Colors.white),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RECENTLY PLAYED',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'See more',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _filteredSongs.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filteredSongs.length,
                          itemBuilder: (context, index) => InkWell(
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
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: QueryArtworkWidget(
                                        id: _filteredSongs[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Icon(
                                            Icons.music_note,
                                            size: 50,
                                            color: Colors.white),
                                        artworkFit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _filteredSongs[index].title,
                                    maxLines: 1,
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _filteredSongs[index].artist == '<unknown>'
                                        ? "Unknown Artist"
                                        : _filteredSongs[index]
                                            .artist
                                            .toString(),
                                    maxLines: 1,
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MOST POPULAR',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'See more',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
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
                            trailing: const Icon(Icons.more_vert,
                                color: Colors.white),
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
        ),
      ),
    );
  }
}
