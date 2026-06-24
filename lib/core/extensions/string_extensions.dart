extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  String toSearchQuery() => trim().toLowerCase();

  bool get isArabic => RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]+').hasMatch(this);

  String get posterUrl => 'https://image.tmdb.org/t/p/w500$this';
  String get backdropUrl => 'https://image.tmdb.org/t/p/w1280$this';
  String get profileUrl => 'https://image.tmdb.org/t/p/w185$this';
  String get originalUrl => 'https://image.tmdb.org/t/p/original$this';
}
