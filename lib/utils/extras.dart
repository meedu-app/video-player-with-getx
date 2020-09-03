String parseDuration(Duration duration) {
  String twoDigits(int v) {
    return v >= 10 ? "$v" : "0$v";
  }

  final String minutes = twoDigits(duration.inMinutes);
  final String seconds = twoDigits(
    duration.inSeconds.remainder(60),
  );
  return "$minutes:$seconds";
}
