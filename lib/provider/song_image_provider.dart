// import 'package:flutter/material.dart';

// class SongImageProvider with ChangeNotifier {
//   int _id = 0;

//   int get id => _id;

//   void setId(int id) {
//     _id = id;
//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';

class SongImageProvider with ChangeNotifier {
  int _id = 0;
  String _artUri = ''; // Add a property for artwork URI

  int get id => _id;
  String get artUri => _artUri;

  void setId(int id) {
    _id = id;
    _updateArtUri(id); // Update the artwork URI based on the new ID
    notifyListeners();
  }

  // Simulate fetching artwork URI based on song ID
  void _updateArtUri(int id) {
    // Replace with your actual logic to fetch artwork URI
    _artUri = 'https://example.com/albumart$id.jpg'; // Example URI
  }
}
