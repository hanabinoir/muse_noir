
/// Extensions on Duration
extension DurationExtension on Duration {
  /// Format duration to MM:SS format
  String toFormattedString() {
    final minutes = inMinutes;
    final seconds = inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format duration with hours if applicable
  String toFormattedStringWithHours() {
    final hours = inHours;
    final minutes = (inMinutes % 60);
    final seconds = inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

