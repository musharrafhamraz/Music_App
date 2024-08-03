import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  SongModel? currentSong;
  bool isPlaying = false;

  Future<void> playSong(SongModel song) async {
    try {
      await audioPlayer.setAudioSource(AudioSource.uri(
        Uri.file(song.data),
        tag: MediaItem(
          id: song.id.toString(),
          album: song.album ?? 'Unknown Album',
          title: song.displayNameWOExt,
          artUri: Uri.parse(song.id.toString()),
        ),
      ));
      await audioPlayer.play();
      currentSong = song;
      isPlaying = true;
      notifyListeners();
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  void togglePlayPause() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      isPlaying = false;
      notifyListeners();
    } else {
      await audioPlayer.play();
      isPlaying = true;
      notifyListeners();
    }
    notifyListeners();
  }

  void stop() async {
    await audioPlayer.stop();
    isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
