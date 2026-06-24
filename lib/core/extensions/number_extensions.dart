extension NumberExtensions on num {
  String toDurationString() {
    final hours = this ~/ 60;
    final minutes = this % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String toRuntimeString() {
    final h = this ~/ 60;
    final m = this % 60;
    if (h > 0) {
      return '${h}h ${m}m';
    }
    return '${m}m';
  }

  String formatCount() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }

  String toPercentage() => '${toStringAsFixed(0)}%';
}
