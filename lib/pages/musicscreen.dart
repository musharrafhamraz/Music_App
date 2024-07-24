import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen(
      {super.key, required this.songModel, required this.audioPlayer});
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    playSong();
  }

  playSong() {
    try {
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(widget.songModel.uri!)),
      );
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      Dialog(
        child: Center(
          child: Column(
            children: [
              const Text("Error"),
              const SizedBox(
                height: 4.0,
              ),
              const Text("Please try again"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Text("OK"))
            ],
          ),
        ),
      );
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
        )),
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
                          id: widget.songModel.id,
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
                widget.songModel.displayNameWOExt,
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
                widget.songModel.artist.toString() == "<unknown>"
                    ? "Unknown Artist"
                    : widget.songModel.artist.toString(),
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
                    icon: const Icon(Icons.shuffle, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: () {},
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.repeat, color: Colors.white),
                    onPressed: () {},
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
    ));
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
