import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtworkDisplay extends StatelessWidget {
  final int songId;

  const ArtworkDisplay({
    super.key,
    required this.songId,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: QueryArtworkWidget(
        id: songId,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const Icon(Icons.music_note, size: 100),
        artworkFit: BoxFit.cover,
        artworkHeight: 200,
        artworkWidth: 200,
      ),
    );
  }
}
