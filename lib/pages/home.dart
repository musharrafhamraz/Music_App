import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/pages/musicscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
    _loadSongs();
  }

  void _loadSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs();
    setState(() {
      _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF002060),
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
          )),
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
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black87.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.align_horizontal_center,
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
                const SizedBox(height: 10),
                _songs.reversed.isEmpty
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
                                  _songs[index].artist ?? 'Unknown Artist',
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
                      )),
                const SizedBox(height: 20),
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
                              _songs[index].artist ?? 'Unknown Artist',
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
                              // playSong(_songs[index].uri!);
                            },
                          ),
                          itemCount: _songs.length,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

//   Widget _buildRecentlyPlayedCard(String title, String artist) {
//     return Container(
//       margin: const EdgeInsets.only(right: 16),
//       width: 150,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 150,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Center(
//               child: Text(
//                 'Image',
//                 style: GoogleFonts.nunito(
//                   textStyle: const TextStyle(color: Colors.white54),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: GoogleFonts.nunito(
//               textStyle: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Text(
//             artist,
//             style: GoogleFonts.nunito(
//               textStyle: const TextStyle(
//                 color: Colors.white54,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
}
