import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart'; // Import the audio query package

class SongDetailsModal extends StatelessWidget {
  final SongModel song;
  final String genre;

  const SongDetailsModal({
    super.key,
    required this.song,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
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
}
