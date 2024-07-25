String getImagePath(String prediction) {
  if (prediction.toLowerCase().contains('happy')) {
    return 'assets/images/happy.png';
  } else if (prediction.toLowerCase().contains('sad')) {
    return 'assets/images/sad.png';
  } else if (prediction.toLowerCase().contains('angry')) {
    return 'assets/images/angry.png';
  } else if (prediction.toLowerCase().contains('surprised')) {
    return 'assets/images/surprised.png';
  } else if (prediction.toLowerCase().contains('fearful')) {
    return 'assets/images/fearful.png';
  } else if (prediction.toLowerCase().contains('disgusted')) {
    return 'assets/images/disgusted.png';
  } else {
    return 'assets/images/neutral.png'; // Default image for other predictions
  }
}
