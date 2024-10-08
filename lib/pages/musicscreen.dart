import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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

    // Initialize the playlist
    _initializePlaylist().then((_) => playSong());

    // Listen to the player state to update play/pause status
    widget.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;

        // Automatically play the next song when the current one ends
        if (state.processingState == ProcessingState.completed) {
          _playNextSong();
        }
      });
    });

    // Listen for changes in the song duration
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d ?? const Duration();
      });
    });

    // Listen for changes in the song position
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  Future<void> _initializePlaylist() async {
    try {
      final playlist = ConcatenatingAudioSource(
        children: _shuffledSongs.map((song) {
          return AudioSource.uri(
            Uri.parse(song.uri!),
            tag: MediaItem(
              id: song.id.toString(),
              album: song.album ?? 'Unknown Album',
              title: song.displayNameWOExt,
              artUri: Uri.parse(song.id.toString()),
            ),
          );
        }).toList(),
      );

      await widget.audioPlayer
          .setAudioSource(playlist, initialIndex: _currentSongIndex);
    } on Exception catch (e) {
      print('Error initializing playlist: $e');
      _showErrorDialog();
    }
  }

  Future<void> playSong() async {
    try {
      await widget.audioPlayer.seek(Duration.zero, index: _currentSongIndex);
      widget.audioPlayer.play();
    } on Exception catch (e) {
      print('Error playing song: $e');
      _showErrorDialog();
    }
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
    });
    playSong();
  }

  void _playPreviousSong() {
    setState(() {
      if (_currentSongIndex > 0) {
        _currentSongIndex--;
      } else {
        _currentSongIndex = _shuffledSongs.length - 1;
      }
    });
    playSong();
  }

  void _shufflePlaylist() {
    setState(() {
      _isShuffling = !_isShuffling;
      widget.audioPlayer.setShuffleModeEnabled(_isShuffling);

      if (_isShuffling) {
        _shuffledSongs.shuffle();
      } else {
        _shuffledSongs = List.from(widget.songs);
      }

      // Update the audio source with shuffled songs
      final playlist = ConcatenatingAudioSource(
        children: _shuffledSongs.map((song) {
          return AudioSource.uri(
            Uri.parse(song.uri!),
            tag: MediaItem(
              id: song.id.toString(),
              album: song.album ?? 'Unknown Album',
              title: song.displayNameWOExt,
              artUri: Uri.parse(song.id.toString()),
            ),
          );
        }).toList(),
      );

      widget.audioPlayer
          .setAudioSource(playlist, initialIndex: _currentSongIndex);
    });
  }

  void _repeatSong() {
    setState(() {
      _isRepeating = !_isRepeating;
      widget.audioPlayer
          .setLoopMode(_isRepeating ? LoopMode.one : LoopMode.off);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'NOW PLAYING',
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          type: ArtworkType.AUDIO,
                          quality: 100,
                          nullArtworkWidget:
                              const Icon(Icons.music_note, size: 100),
                          artworkFit: BoxFit.cover,
                          artworkHeight: 200,
                          artworkWidth: 200,
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.white38,
                min: 0.0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds
                    .toDouble()
                    .clamp(0.0, _duration.inSeconds.toDouble()),
                onChanged: (value) {
                  changeToSeconds(value.toInt());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _position.toString().split(".")[0],
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      _duration.toString().split(".")[0],
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shuffle,
                      color: _isShuffling ? Colors.blue : Colors.white,
                    ),
                    onPressed: _shufflePlaylist,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: _playPreviousSong,
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.blueAccent,
                      size: 70,
                    ),
                    onPressed: () {
                      if (_isPlaying) {
                        widget.audioPlayer.pause();
                      } else {
                        widget.audioPlayer.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: _playNextSong,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.repeat,
                      color: _isRepeating ? Colors.blue : Colors.white,
                    ),
                    onPressed: _repeatSong,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
