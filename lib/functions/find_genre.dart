import 'package:on_audio_query/on_audio_query.dart';

String findGenreBySongMetadata(SongModel song) {
  String title = song.title.toLowerCase();
  String artist = song.artist?.toLowerCase() ?? '';

  if (_isRomantic(title, artist)) {
    return 'Romantic';
  } else if (_isPop(title, artist)) {
    return 'Pop';
  } else if (_isHipHop(title, artist)) {
    return 'Hip Hop';
  } else if (_isSad(title, artist)) {
    return 'Sad';
  } else if (_isRock(title, artist)) {
    return 'Rock';
  } else if (_isJazz(title, artist)) {
    return 'Jazz';
  } else if (_isClassical(title, artist)) {
    return 'Classical';
  } else if (_isCountry(title, artist)) {
    return 'Country';
  } else if (_isMetal(title, artist)) {
    return 'Metal';
  } else if (_isElectronic(title, artist)) {
    return 'Electronic';
  } else if (_isReggae(title, artist)) {
    return 'Reggae';
  } else if (_isBlues(title, artist)) {
    return 'Blues';
  } else if (_isFolk(title, artist)) {
    return 'Folk';
  } else if (_isSoul(title, artist)) {
    return 'Soul';
  } else if (_isRnb(title, artist)) {
    return 'R&B';
  } else if (_isLatin(title, artist)) {
    return 'Latin';
  } else if (_isIndie(title, artist)) {
    return 'Indie';
  } else {
    return 'Unknown';
  }
}

// Function to check if a song is Romantic
bool _isRomantic(String title, String artist) {
  final romanticKeywords = [
    'love',
    'heart',
    'romance',
    'valentine',
    'darling',
    'sweetheart',
    'passion',
    'kiss',
    'cuddle',
    'cherish',
    'forever',
    'crush',
    'affection',
    'devotion',
    'embrace',
    'adoration',
    'amour',
    'desire',
    'lovesong',
    'soulmate'
  ];

  return _containsAny(title, artist, romanticKeywords);
}

// Function to check if a song is Pop
bool _isPop(String title, String artist) {
  final popKeywords = [
    'dance',
    'hit',
    'chart',
    'pop',
    'catchy',
    'beat',
    'rhythm',
    'anthem',
    'radio',
    'star',
    'bubblegum',
    'mainstream',
    'groove',
    'melody',
    'party',
    'banger',
    'popstar',
    'club',
    'jive',
    'dancefloor'
  ];

  return _containsAny(title, artist, popKeywords);
}

// Function to check if a song is Hip Hop
bool _isHipHop(String title, String artist) {
  final hipHopKeywords = [
    'hip hop',
    'rap',
    'trap',
    'flow',
    'bars',
    'freestyle',
    'beatbox',
    'dj',
    'turntable',
    'lyricist',
    'rhyme',
    'cypher',
    'spit',
    'emcee',
    'bling',
    'gangsta',
    'crew',
    'mic',
    'hustle',
    'street'
  ];

  return _containsAny(title, artist, hipHopKeywords);
}

// Function to check if a song is Sad
bool _isSad(String title, String artist) {
  final sadKeywords = [
    'sad',
    'cry',
    'tears',
    'lonely',
    'heartbreak',
    'melancholy',
    'blue',
    'sorrow',
    'pain',
    'lost',
    'broken',
    'goodbye',
    'farewell',
    'mourn',
    'regret',
    'aching',
    'misery',
    'despair',
    'grief',
    'wistful'
  ];

  return _containsAny(title, artist, sadKeywords);
}

// Function to check if a song is Rock
bool _isRock(String title, String artist) {
  final rockKeywords = [
    'rock',
    'guitar',
    'band',
    'live',
    'stage',
    'electric',
    'drums',
    'solo',
    'riff',
    'metal',
    'punk',
    'hard',
    'anthem',
    'grunge',
    'garage',
    'thrash',
    'mosh',
    'rebellion',
    'headbang',
    'stadium'
  ];

  return _containsAny(title, artist, rockKeywords);
}

// Function to check if a song is Jazz
bool _isJazz(String title, String artist) {
  final jazzKeywords = [
    'jazz',
    'swing',
    'blues',
    'saxophone',
    'trumpet',
    'improvise',
    'big band',
    'bebop',
    'cool',
    'fusion',
    'lounge',
    'jive',
    'ragtime',
    'syncopate',
    'blues',
    'jam',
    'brass',
    'croon',
    'smooth',
    'bebop'
  ];

  return _containsAny(title, artist, jazzKeywords);
}

// Function to check if a song is Classical
bool _isClassical(String title, String artist) {
  final classicalKeywords = [
    'classical',
    'symphony',
    'orchestra',
    'piano',
    'violin',
    'concerto',
    'composer',
    'sonata',
    'opera',
    'quartet',
    'choir',
    'baroque',
    'romantic',
    'canon',
    'adagio',
    'minuet',
    'fugue',
    'serenade',
    'suite',
    'overture'
  ];

  return _containsAny(title, artist, classicalKeywords);
}

// Function to check if a song is Country
bool _isCountry(String title, String artist) {
  final countryKeywords = [
    'country',
    'cowboy',
    'truck',
    'whiskey',
    'honky',
    'americana',
    'southern',
    'banjo',
    'fiddle',
    'barn',
    'rodeo',
    'bluegrass',
    'hillbilly',
    'western',
    'boots',
    'highway',
    'roots',
    'line dance',
    'yodel',
    'plains'
  ];

  return _containsAny(title, artist, countryKeywords);
}

// Function to check if a song is Metal
bool _isMetal(String title, String artist) {
  final metalKeywords = [
    'metal',
    'heavy',
    'scream',
    'thrash',
    'blast',
    'death',
    'doom',
    'black',
    'shred',
    'mosh',
    'riff',
    'growl',
    'headbang',
    'viking',
    'grindcore',
    'gothic',
    'industrial',
    'speed',
    'sludge',
    'progressive'
  ];

  return _containsAny(title, artist, metalKeywords);
}

// Function to check if a song is Electronic
bool _isElectronic(String title, String artist) {
  final electronicKeywords = [
    'electronic',
    'techno',
    'house',
    'edm',
    'trance',
    'dubstep',
    'synth',
    'bass',
    'drum',
    'dj',
    'rave',
    'party',
    'remix',
    'beat',
    'groove',
    'ambient',
    'loop',
    'vibe',
    'drop',
    'mix'
  ];

  return _containsAny(title, artist, electronicKeywords);
}

// Function to check if a song is Reggae
bool _isReggae(String title, String artist) {
  final reggaeKeywords = [
    'reggae',
    'jamaica',
    'island',
    'dub',
    'roots',
    'rastafari',
    'marley',
    'skank',
    'rocksteady',
    'dancehall',
    'irie',
    'selector',
    'dubplate',
    'sound',
    'system',
    'groove',
    'rhythm',
    'peace',
    'calypso',
    'ganja'
  ];

  return _containsAny(title, artist, reggaeKeywords);
}

// Function to check if a song is Blues
bool _isBlues(String title, String artist) {
  final bluesKeywords = [
    'blues',
    'guitar',
    'harmonica',
    'shuffle',
    'soul',
    'delta',
    'rhythm',
    'bessie',
    'muddy',
    'slide',
    'bottleneck',
    'juke',
    'lament',
    'moan',
    'grief',
    'riff',
    'jam',
    'club',
    'memphis',
    'shack'
  ];

  return _containsAny(title, artist, bluesKeywords);
}

// Function to check if a song is Folk
bool _isFolk(String title, String artist) {
  final folkKeywords = [
    'folk',
    'acoustic',
    'story',
    'traditional',
    'banjo',
    'ballad',
    'tale',
    'roots',
    'singer',
    'guitar',
    'storytelling',
    'harmonica',
    'barn',
    'campfire',
    'whistle',
    'mandolin',
    'plains',
    'fiddle',
    'hymn',
    'homestead'
  ];

  return _containsAny(title, artist, folkKeywords);
}

// Function to check if a song is Soul
bool _isSoul(String title, String artist) {
  final soulKeywords = [
    'soul',
    'heart',
    'rhythm',
    'gospel',
    'smooth',
    'emotion',
    'blues',
    'motown',
    'funk',
    'vibe',
    'passion',
    'silk',
    'croon',
    'harmony',
    'deep',
    'groove',
    'melodic',
    'singer',
    'diva',
    'mojo'
  ];

  return _containsAny(title, artist, soulKeywords);
}

// Function to check if a song is R&B
bool _isRnb(String title, String artist) {
  final rnbKeywords = [
    'r&b',
    'soul',
    'rhythm',
    'funk',
    'smooth',
    'beat',
    'vibe',
    'groove',
    'melodic',
    'croon',
    'silk',
    'romantic',
    'diva',
    'passion',
    'harmonies',
    'vocals',
    'urban',
    'singer',
    'slow jam',
    'club'
  ];

  return _containsAny(title, artist, rnbKeywords);
}

// Function to check if a song is Latin
bool _isLatin(String title, String artist) {
  final latinKeywords = [
    'latin',
    'salsa',
    'tango',
    'rumba',
    'bachata',
    'reggaeton',
    'fiesta',
    'flamenco',
    'mambo',
    'bossa',
    'cha cha',
    'merengue',
    'cumbia',
    'bailar',
    'carnaval',
    'caliente',
    'maracas',
    'guitar',
    'mariachi',
    'conga'
  ];

  return _containsAny(title, artist, latinKeywords);
}

// Function to check if a song is Indie
bool _isIndie(String title, String artist) {
  final indieKeywords = [
    'indie',
    'alternative',
    'unsigned',
    'band',
    'garage',
    'experimental',
    'lo-fi',
    'diy',
    'folk',
    'punk',
    'grunge',
    'dream pop',
    'art rock',
    'shoegaze',
    'psychedelic',
    'nu gaze',
    'hipster',
    'eclectic',
    'experimental',
    'chill'
  ];

  return _containsAny(title, artist, indieKeywords);
}

// Helper function to check if any keyword is present in title or artist
bool _containsAny(String title, String artist, List<String> keywords) {
  return keywords
      .any((keyword) => title.contains(keyword) || artist.contains(keyword));
}
