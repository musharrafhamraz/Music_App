import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({
    super.key,
    required this.currentSongIndex,
    required this.songs,
    required this.audioPlayer,
  });

  final int currentSongIndex;
  final List<SongModel> songs;
  final AudioPlayer audioPlayer;

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;
  bool _isShuffling = false;
  bool _isRepeating = false;
  int _currentSongIndex = 0;
  List<SongModel> _shuffledSongs = [];

  @override
  void initState() {
    super.initState();
    _currentSongIndex = widget.currentSongIndex;
    _shuffledSongs = List.from(widget.songs);
    playSong();
  }

  playSong() async {
    try {
      await widget.audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(_shuffledSongs[_currentSongIndex].uri!)),
      );
      widget.audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    } on Exception {
      // _showErrorDialog();
    }

    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });

    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });

    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_isRepeating) {
          widget.audioPlayer.seek(Duration.zero);
        } else {
          _playNextSong();
        }
      }
    });
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: const Text("Please try again"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  void _playNextSong() {
    setState(() {
      if (_currentSongIndex < _shuffledSongs.length - 1) {
        _currentSongIndex++;
      } else {
        _currentSongIndex = 0;
      }
      playSong();
    });
  }

  void _playPreviousSong() {
    setState(() {
      if (_currentSongIndex > 0) {
        _currentSongIndex--;
      } else {
        _currentSongIndex = _shuffledSongs.length - 1;
      }
      playSong();
    });
  }

  void _shufflePlaylist() {
    setState(() {
      _isShuffling = !_isShuffling;
      if (_isShuffling) {
        // Shuffle the songs and save the current song index to ensure the current song doesn't change.
        int currentSongId = _shuffledSongs[_currentSongIndex].id;
        _shuffledSongs.shuffle();

        // Find the new index of the current song after shuffling.
        _currentSongIndex =
            _shuffledSongs.indexWhere((song) => song.id == currentSongId);
      } else {
        // Restore the original song order and update the current song index.
        _shuffledSongs = List.from(widget.songs);
        int currentSongId = widget.songs[_currentSongIndex].id;
        _currentSongIndex =
            _shuffledSongs.indexWhere((song) => song.id == currentSongId);
      }
    });
  }

  void _repeatSong() {
    setState(() {
      _isRepeating = !_isRepeating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'NOW PLAYING',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: QueryArtworkWidget(
                            id: _shuffledSongs[_currentSongIndex].id,
                            quality: 100,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(Icons.music_note,
                                size: 50, color: Colors.white),
                            artworkFit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _shuffledSongs[_currentSongIndex].displayNameWOExt,
                  maxLines: 2,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _shuffledSongs[_currentSongIndex].artist.toString() ==
                          "<unknown>"
                      ? "Unknown Artist"
                      : _shuffledSongs[_currentSongIndex].artist.toString(),
                  maxLines: 1,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                Expanded(
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    min: const Duration(microseconds: 0).inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    activeColor: const Color.fromARGB(255, 255, 255, 255),
                    inactiveColor: Colors.white54,
                    onChanged: (value) {
                      setState(() {
                        changeToSeconds(value.toInt());
                        value = value;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _position.toString().split(".")[0],
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    Text(
                      _duration.toString().split(".")[0],
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shuffle,
                          color:
                              _isShuffling ? Colors.blueAccent : Colors.white),
                      onPressed: _shufflePlaylist,
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: _playPreviousSong,
                    ),
                    IconButton(
                      icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.blueAccent,
                          size: 70),
                      onPressed: () {
                        setState(() {
                          if (_isPlaying) {
                            widget.audioPlayer.pause();
                          } else {
                            widget.audioPlayer.play();
                          }
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: _playNextSong,
                    ),
                    IconButton(
                      icon: Icon(Icons.repeat,
                          color:
                              _isRepeating ? Colors.blueAccent : Colors.white),
                      onPressed: _repeatSong,
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Songs',
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
